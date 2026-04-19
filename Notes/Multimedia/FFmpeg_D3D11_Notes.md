
# FFmpeg 与 D3D11 相关笔记整合

本文档整合了多个关于 FFmpeg 和 D3D11 的 Markdown 文件，涵盖了从基础使用到高级主题的各种内容，包括硬件加速、视频渲染和播放器实现等。

---

## D3D11显示ffmpeg解码出的YUV420P数据

最近在做D3D11的播放器，用来显示[ffmpeg](https://so.csdn.net/so/search?q=ffmpeg&spm=1001.2101.3001.7020)解码出来的AVFrame，这里记录下踩过的坑。

刚开始的实现是基于RGBA，需要使用sws_scale将AVFrame像素格式转换成RGBA，然后更新纹理（格式为DXGI_FORMAT_R8G8B8A8_UNORM）。这里就有两个选择：第一种是创建纹理时选择D3D11_USAGE_DEFAULT类型的内存，然后只用UpdateSubresource来更新纹理；第二种是选择D3D11_USAGE_DYNAMIC类型的内存，加上D3D11_CPU_ACCESS_WRITE标记，这样可以使用 Map/memcpy/Unmap模式来更新纹理。比较而言，前者的效率更高些。

这里有一个坑：当显示全尺寸的图像时没什么问题。但是当播放器窗口较小时，就会黑屏（静止），最后发现是创建纹理缓存时，没有指定MipLevels=1，所以导致后续的更新纹理操作都只更新了原始的那个纹理。

后来考虑到sws_scale只是CPU处理，而且RGBA数据比原始的YUV420P要大很多，占用带宽，相同大小的YUV420P数据量只相当于RGBA像素格式的 6/16（以每4像素算，前者6字节，后者16字节）。既然YUV420P分为3个plane，每个plane都可以视为一个纹理，那么直接使用3个纹理也是没问题的。

> 搜索到 https://www.cnblogs.com/betterwgo/p/6131723.html 实现的和这个最接近（感谢前辈），但代码包括shader都是 d3d9 的，把它转成 d3d11

> 1.创建纹理方面的代码如下：  
> 
> ```cpp
> // ID3D11ShaderResourceView* resourceViewPlanes_[3];
> // ID3D11Texture2D *texturePlanes_[3];
> CD3D11_TEXTURE2D_DESC textureDesc(DXGI_FORMAT_R8_UNORM, width, height);
> textureDesc.MipLevels = 1;
> hr = device->CreateTexture2D(&textureDesc, NULL, &texturePlanes_[0]);
> textureDesc.Width = width/2; textureDesc.Height = height/2;
> hr = device->CreateTexture2D(&textureDesc, NULL, &texturePlanes_[1]);
> hr = device->CreateTexture2D(&textureDesc, NULL, &texturePlanes_[2]);
> 
> // CD3D11_SHADER_RESOURCE_VIEW_DESC srvDesc(texturePlanes_[0],D3D11_SRV_DIMENSION_TEXTURE2D,DXGI_FORMAT_R8_UNORM);
> // hr = videoDevice_->CreateShaderResourceView(texturePlanes_[0], &srvDesc,&resourceViewPlanes_[0]);
> // srvDesc.Format = DXGI_FORMAT_R8_UNORM;
> // hr = videoDevice_->CreateShaderResourceView(texturePlanes_[1], &srvDesc,&resourceViewPlanes_[1]);
> // hr = videoDevice_->CreateShaderResourceView(texturePlanes_[2], &srvDesc,&resourceViewPlanes_[2]);
> ```
> 
> 2.更新纹理代码如下：  
> 
> ```cpp
> //AVFrame *frame，保证是 AV_PIX_FMT_YUV420P
> for (int i = 0; i < 3; ++i)
> deviceCtx->UpdateSubresource(texturePlanes_[i], 0, NULL, frame->data[i], frame->linesize[i], 0);
> ```
> 
> 3.渲染时代码如下：  
> 
> ```cpp
> deviceCtx->PSSetShaderResources(0, 3, resourceViewPlanes_);//3个纹理一次传入，SamplerState 传入就省略了
> ```
> 
> 4.shader代码如下：
> 
> ```
> 
> ```

> 这里又有个坑：当你创建纹理缓存时指定的DXGI_FORMAT_R8_UNORM和 shader 内 PS 函数获取采样色彩后分量不一致时，会没有效果。我当时指定 DXGI_FORMAT_A8_UNORM，获取时写 float y = u_texY.Sample(SampleType, input.tex).r，注意最后那个 .r，这时候需要把 .r 改为 .a，或者将DXGI_FORMAT_A8_UNORM改为DXGI_FORMAT_R8_UNORM。

> 改完之后，绘制效率提升不少。

---

## 使用D3D11直接渲染YUV数据

最初学习D3D11时，采取的是直接渲染RGB数据的方式，因为采集的时候采出来的是YUV420格式，需要利用libyuv库把YUVI420转成RGB格式。但是在实际项目中，这种转换会非常消耗CPU性能，因此需要寻求一种能够直接渲染YUV数据方式。

目前D3D11直接渲染YUV的主流方式有两种，第一种是创建三个纹理，用着色器转成RGB数据渲染（这部分转换操作应该是在GPU上进行的）；第二种是D3D11.1之后支持直接渲染YUV数据。这里采取的是第一种方式，废话不多说，直接上代码。

```cpp
bool D3D11Render::InitDirect3d()
{
	HRESULT hr = S_OK;
	//创建d3d设备及设备上下文

	//驱动类型数组
	D3D_DRIVER_TYPE driverTypes[] = {
		D3D_DRIVER_TYPE_HARDWARE,  //硬件驱动
		D3D_DRIVER_TYPE_WARP,	   //WARP驱动
		D3D_DRIVER_TYPE_REFERENCE, //软件驱动
	};
	UINT numDriverTypes = ARRAYSIZE(driverTypes);

	//特性等级数组
	D3D_FEATURE_LEVEL featureLevels[] = {
		D3D_FEATURE_LEVEL_11_1,
		D3D_FEATURE_LEVEL_11_0,
	};
	UINT numFeatureLevels = ARRAYSIZE(featureLevels);

	D3D_FEATURE_LEVEL featureLevel;
	D3D_DRIVER_TYPE d3dDriverType;
	for (UINT driverTypeIndex = 0; driverTypeIndex < numDriverTypes; driverTypeIndex++) {
		d3dDriverType = driverTypes[driverTypeIndex];
		hr = D3D11CreateDevice(nullptr, d3dDriverType, nullptr, 0, featureLevels, numFeatureLevels, D3D11_SDK_VERSION,
			m_pd3dDevice.GetAddressOf(), &featureLevel, m_pd3dImmediateContex.GetAddressOf());
		if (hr == E_INVALIDARG) {
			//Direct3D 11.0的API不承认D3D_FEATURE_LEVEL_11_1,因此需要尝试D3D_FEATURE_LEVEL_11_0及其以下版本
			hr = D3D11CreateDevice(nullptr, d3dDriverType, nullptr, 0, &featureLevels[1], numFeatureLevels - 1, D3D11_SDK_VERSION,
				m_pd3dDevice.GetAddressOf(), &featureLevel, m_pd3dImmediateContex.GetAddressOf());
		}
		if (SUCCEEDED(hr)) break;
	}
	if (FAILED(hr)) {
		std::cout << "Create Direct3D device failed." << std::endl;
		return false;
	}

	//检测是否支持特性等级11.0或者11.1
	if (featureLevel != D3D_FEATURE_LEVEL_11_1 && featureLevel != D3D_FEATURE_LEVEL_11_0) {
		std::cout << "Direct3D feature level 11 not support." << std::endl;
		return false;
	}
	//检测MSAA支持的质量等级
	m_pd3dDevice->CheckMultisampleQualityLevels(DXGI_FORMAT_B8G8R8A8_UNORM, 4, &m_4xMsaaQuality);
	assert(m_4xMsaaQuality > 0);

	ComPtr<IDXGIDevice> dxgiDevice = nullptr;
	ComPtr<IDXGIAdapter> dxgiAdapter = nullptr;
	ComPtr<IDXGIFactory1> dxgiFactory1 = nullptr; 
	ComPtr<IDXGIFactory2> dxgiFactory2 = nullptr; 

	hr = m_pd3dDevice.As(&dxgiDevice);
	if (FAILED(hr)) {
		std::cout << "m_pd3dDevice.As(&dxgiDevice) failed." << std::endl;
		LogErrorText(hr);
		return false;
	}
	hr = dxgiDevice->GetAdapter(&dxgiAdapter);
	if (FAILED(hr)) {
		std::cout << "GetAdapter failed." << std::endl;
		LogErrorText(hr);
		return false;
	}
	hr = dxgiAdapter->GetParent(__uuidof(IDXGIFactory1), reinterpret_cast<void**>(dxgiFactory1.GetAddressOf()));
	if (FAILED(hr)) {
		std::cout << "GetParent failed." << std::endl;
		LogErrorText(hr);
		return false;
	}

	hr = dxgiFactory1.As(&dxgiFactory2);
	if (dxgiFactory2 != nullptr) {
		hr = m_pd3dDevice.As(&m_pd3dDevice1);
		if (FAILED(hr)) {
			std::cout << "m_pd3dDevice.As(&m_pd3dDevice1) failed." << std::endl;
			LogErrorText(hr);
			return false;
		}
		m_pd3dImmediateContex.As(&m_pd3dImmediateContex1);
		if (FAILED(hr)) {
			std::cout << "m_pd3dImmediateContex.As(&m_pd3dImmediateContex1) failed." << std::endl;
			LogErrorText(hr);
			return false;
		}
		//创建11.1 Swap Chain
		DXGI_SWAP_CHAIN_DESC1 sd;
		ZeroMemory(&sd, sizeof(sd));
		sd.Width = m_width; 
		sd.Height = m_height; 
		sd.Format = DXGI_FORMAT_B8G8R8A8_UNORM; 
		if (m_Enable4xMsaa) {
			sd.SampleDesc.Count = 4; 
			sd.SampleDesc.Quality = m_4xMsaaQuality - 1; 
		}
		else {
			sd.SampleDesc.Count = 1;
			sd.SampleDesc.Quality = 0;
		}
		sd.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT; 
		sd.BufferCount = 1;								 
		sd.SwapEffect = DXGI_SWAP_EFFECT_DISCARD;		  
		sd.Flags = 0;									
		

		DXGI_SWAP_CHAIN_FULLSCREEN_DESC fd;
		fd.RefreshRate.Denominator = 1; 
		fd.RefreshRate.Numerator = 60; 
		fd.Scaling = DXGI_MODE_SCALING_UNSPECIFIED;
		fd.ScanlineOrdering = DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED;
		fd.Windowed = TRUE; 

		hr = dxgiFactory2->CreateSwapChainForHwnd(m_pd3dDevice.Get(), m_hwnd, &sd, &fd, nullptr, m_pSwapChain1.GetAddressOf());
		if (FAILED(hr)) {
			std::cout << "CreateSwapChain1 failed." << std::endl;
			LogErrorText(hr);
			return false;
		}
		hr = m_pSwapChain1.As(&m_pSwapChain);
		if (FAILED(hr)) {
			std::cout << "m_pSwapChain1.As(&m_pSwapChain) failed." << std::endl;
			LogErrorText(hr);
			return false;
		}
	}
	else {
		//创建11.0 Swap Chain
		DXGI_SWAP_CHAIN_DESC sd;
		ZeroMemory(&sd, sizeof(sd));
		sd.BufferDesc.Width = m_width;
		sd.BufferDesc.Height = m_height;
		sd.BufferDesc.RefreshRate.Numerator = 60;
		sd.BufferDesc.RefreshRate.Denominator = 1;
		sd.BufferDesc.Format = DXGI_FORMAT_B8G8R8A8_UNORM;
		sd.BufferDesc.ScanlineOrdering = DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED;
		sd.BufferDesc.Scaling = DXGI_MODE_SCALING_UNSPECIFIED;
		if (m_Enable4xMsaa) {
			sd.SampleDesc.Count = 4; 
			sd.SampleDesc.Quality = m_4xMsaaQuality - 1; 
		}
		else {
			sd.SampleDesc.Count = 1;
			sd.SampleDesc.Quality = 0;
		}
		sd.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
		sd.BufferCount = 1;
		sd.OutputWindow = m_hwnd;
		sd.Windowed = TRUE;
		sd.SwapEffect = DXGI_SWAP_EFFECT_DISCARD;
		sd.Flags = 0;

		hr = dxgiFactory1->CreateSwapChain(m_pd3dDevice.Get(), &sd, m_pSwapChain.GetAddressOf());
		if (FAILED(hr)) {
			std::cout << "CreateSwapChain failed." << std::endl;
			LogErrorText(hr);
			return false;
		}
	}
	dxgiFactory1->MakeWindowAssociation(m_hwnd, DXGI_MWA_NO_ALT_ENTER);

	//创建三个YUV纹理
	D3D11_TEXTURE2D_DESC textureDesc;
	textureDesc.Width = m_width;
	textureDesc.Height = m_height;
	textureDesc.MipLevels = 1; 
	textureDesc.ArraySize = 1; 
	textureDesc.Format = DXGI_FORMAT_R8_UNORM; 
	if (m_Enable4xMsaa) {
		textureDesc.SampleDesc.Count = 4;
		textureDesc.SampleDesc.Quality = m_4xMsaaQuality - 1;
	}
	else {
		textureDesc.SampleDesc.Count = 1;
		textureDesc.SampleDesc.Quality = 0;
	}
	textureDesc.Usage = D3D11_USAGE_DEFAULT;
	textureDesc.BindFlags = D3D11_BIND_SHADER_RESOURCE;
	textureDesc.CPUAccessFlags = D3D11_CPU_ACCESS_WRITE; 
	textureDesc.MiscFlags = 0; 
	hr = m_pd3dDevice->CreateTexture2D(&textureDesc, nullptr, texturePlanes[0].GetAddressOf()); 
	if (FAILED(hr)) {
		std::cout << "CreateTexture2D failed." << std::endl;
		LogErrorText(hr);
		return false;
	}
	textureDesc.Width = m_width / 2;
	textureDesc.Height = m_height / 2;
	hr = m_pd3dDevice->CreateTexture2D(&textureDesc, nullptr, texturePlanes[1].GetAddressOf()); 
	if (FAILED(hr)) {
		std::cout << "CreateTexture2D failed." << std::endl;
		LogErrorText(hr);
		return false;
	}
	hr = m_pd3dDevice->CreateTexture2D(&textureDesc, nullptr, texturePlanes[2].GetAddressOf()); 
	if (FAILED(hr)) {
		std::cout << "CreateTexture2D failed." << std::endl;
		LogErrorText(hr);
		return false;
	}
	D3D11_SHADER_RESOURCE_VIEW_DESC resourceviewDesc;
	resourceviewDesc.Format = DXGI_FORMAT_R8_UNORM;
	resourceviewDesc.ViewDimension = D3D11_SRV_DIMENSION_TEXTURE2D;
	resourceviewDesc.Texture2D.MipLevels = 1u;
	resourceviewDesc.Texture2D.MostDetailedMip = 0u;

	for (int i = 0; i < 3; i++) {
		hr = m_pd3dDevice->CreateShaderResourceView(texturePlanes[i].Get(), &resourceviewDesc, reourceviewPlaner[i].GetAddressOf());
		if (FAILED(hr)) {
			std::cout << "CreateShaderResourceView failed." << std::endl;
			LogErrorText(hr);
			return false;
		}
	}
	
	hr = m_pSwapChain->GetBuffer(0, __uuidof(ID3D11Texture2D), reinterpret_cast<void**>(backBuffer.GetAddressOf())); 
	if (FAILED(hr)) {
		std::cout << "GetBuffer failed." << std::endl;
		LogErrorText(hr);
		return false;
	}
	hr = m_pd3dDevice->CreateRenderTargetView(backBuffer.Get(), nullptr, m_pRenderTargetView.GetAddressOf()); 
	if (FAILED(hr)) {
		std::cout << "CreateRenderTargetView failed." << std::endl;
		LogErrorText(hr);
		return false;
	}
	m_pd3dImmediateContex->OMSetRenderTargets(1, m_pRenderTargetView.GetAddressOf(), nullptr);

	m_ScreenViewPort.TopLeftX = 0; 
	m_ScreenViewPort.TopLeftY = 0; 
	m_ScreenViewPort.Width = static_cast<float>(m_width);
	m_ScreenViewPort.Height = static_cast<float>(m_height);
	m_ScreenViewPort.MinDepth = 0.0f; 
	m_ScreenViewPort.MaxDepth = 1.0f; 
	m_pd3dImmediateContex->RSSetViewports(1, &m_ScreenViewPort); 
	SetWindowPos(m_hwnd, NULL, 0, 0, m_width, m_height, SWP_NOZORDER);

	std::cout << "Initialize D3D11 success." << std::endl;
	return true;
}
```

---

## 基于FFMPEG 和 DirectX11的流媒体视频

### 第一步：设置源流和视频解码器

```cpp
// initialize stream
const std::string hw_device_name = "d3d11va";
AVHWDeviceType device_type = av_hwdevice_find_type_by_name(hw_device_name.c_str());
// set up codec context
AVBufferRef* hw_device_ctx;
av_hwdevice_ctx_create(&hw_device_ctx, device_type, nullptr, nullptr, 0);
codec_ctx->hw_device_ctx = av_buffer_ref(hw_device_ctx);
// open stream
```

### 第二步：转换 NV12 为 RGBA

```cpp
SwsContext* conversion_ctx = sws_getContext(
        SRC_WIDTH, SRC_HEIGHT, AV_PIX_FMT_NV12,
        DST_WIDTH, DST_HEIGHT, AV_PIX_FMT_RGBA,
        SWS_BICUBLIN | SWS_BITEXACT, nullptr, nullptr, nullptr);
```

### 第三步：设置 DirectX11 渲染

### 第四步：交换纹理颜色

### 第五步：渲染实际的帧

```cpp
// decode and convert frame
static constexpr int BYTES_IN_RGBA_PIXEL = 4;
D3D11_MAPPED_SUBRESOURCE ms;
device_context->Map(m_texture.Get(), 0, D3D11_MAP_WRITE_DISCARD, 0, &ms);
memcpy(ms.pData, frame->data[0], frame->width * frame->height * BYTES_IN_RGBA_PIXEL);
device_context->Unmap(m_texture.Get(), 0);
// clear the render target view, draw the indices, present the swapchain
```

### 第六步：渲染实际帧… 可能是正确的

```cpp
AVBufferRef* hw_device_ctx = av_hwdevice_ctx_alloc(AV_HWDEVICE_TYPE_D3D11VA);
AVHWDeviceContext* device_ctx = reinterpret_cast<AVHWDeviceContext*>(hw_device_ctx->data);
AVD3D11VADeviceContext* d3d11va_device_ctx = reinterpret_cast<AVD3D11VADeviceContext*>(device_ctx->hwctx);
// m_device is our ComPtr<ID3D11Device>
d3d11va_device_ctx->device = m_device.Get();
// codec_ctx is a pointer to our FFmpeg AVCodecContext
codec_ctx->hw_device_ctx = av_buffer_ref(hw_device_ctx);
av_hwdevice_ctx_init(codec_ctx->hw_device_ctx);
```

---

## 调用D3D11硬解码和渲染VideoProcessor版本

在https://blog.csdn.net/robothn/article/details/78781321一文中使用[shader](https://so.csdn.net/so/search?q=shader&spm=1001.2101.3001.7020)来显示FFMPEG硬解码后的YUV420P，本文调用D3D11的videoprocessor来进行图像空间变换和尺寸变换，取得了较好的效果。  
从实际使用效果来看，[FFMPEG](https://so.csdn.net/so/search?q=FFMPEG&spm=1001.2101.3001.7020)解码后的数据使用UpdateSubresource需要把数据进行搬运出来处理，使用videoprocessorBLT设置适当的入参，可直接对Subresource进行色度空间和尺寸变换，减少了数据搬运过程。  
frame->data\[1\]是subresource的index。  
处理如下：  
int index = (intptr\_t)frame->data\[1\];

---

## Qt音视频开发10-ffmpeg内核硬解码

### 硬解码大致流程：

1.  根据硬解码类型查找硬解码设备类型 av\_hwdevice\_find\_type\_by\_name
2.  根据解码设备类型找到硬解码的格式 find\_fmt\_by\_hw\_type
3.  获取解码器格式回调 videoCodecCtx->get\_format
4.  创建硬解码设备 av\_hwdevice\_ctx\_create
5.  设备硬解码设备 videoCodecCtx->hw\_device\_ctx
6.  解码数据包 avcodec\_send\_packet avcodec\_receive\_frame
7.  将硬解码后的数据从GPU转换取出来 av\_hwframe\_transfer\_data

---

## The realization of FFmpeg simple player 1-the simplest version

### 2.2 Source code list

```c
#include <stdio.h>
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libswscale/swscale.h>
#include <SDL2/SDL.h>
#include <SDL2/SDL_video.h>
#include <SDL2/SDL_render.h>
#include <SDL2/SDL_rect.h>

int main(int argc, char *argv[])
{
    // ...
    ret = avformat_open_input(&p_fmt_ctx, argv[1], NULL, NULL);
    // ...
    ret = avformat_find_stream_info(p_fmt_ctx, NULL);
    // ...
    p_codec = avcodec_find_decoder(p_codec_par->codec_id);
    // ...
    ret = avcodec_open2(p_codec_ctx, p_codec, NULL);
    // ...
    while (av_read_frame(p_fmt_ctx, p_packet) == 0)
    {
        if (p_packet->stream_index == v_idx) 
        {
            ret = avcodec_send_packet(p_codec_ctx, p_packet);
            // ...
            ret = avcodec_receive_frame(p_codec_ctx, p_frm_raw);
            // ...
            sws_scale(sws_ctx, (const uint8_t *const *)p_frm_raw->data, p_frm_raw->linesize, 0, p_codec_ctx->height, p_frm_yuv->data, p_frm_yuv->linesize);
            // ...
            SDL_UpdateYUVTexture(sdl_texture, &sdl_rect, p_frm_yuv->data[0], p_frm_yuv->linesize[0], p_frm_yuv->data[1], p_frm_yuv->linesize[1], p_frm_yuv->data[2], p_frm_yuv->linesize[2]);
            // ...
            SDL_RenderPresent(sdl_renderer);  
            // ...
        }
        av_packet_unref(p_packet);
    }
    // ...
}
```

---

## C ++ From scratch, only FFMPEG, WIN32 API, implement a player

### Decoding the first frame picture

```cpp
AVFrame* getFirstFrame(const char* filePath) {
	AVFormatContext* fmtCtx = nullptr;
	avformat_open_input(&fmtCtx, filePath, NULL, NULL);
	avformat_find_stream_info(fmtCtx, NULL);

	int videoStreamIndex;
	AVCodecContext* vcodecCtx = nullptr;
	for (int i = 0; i < fmtCtx->nb_streams; i++) {
		AVStream* stream = fmtCtx->streams[i];
		if (stream->codecpar->codec_type == AVMEDIA_TYPE_VIDEO) {
			const AVCodec* codec = avcodec_find_decoder(stream->codecpar->codec_id);
			videoStreamIndex = i;
			vcodecCtx = avcodec_alloc_context3(codec);
			avcodec_parameters_to_context(vcodecCtx, fmtCtx->streams[i]->codecpar);
			avcodec_open2(vcodecCtx, codec, NULL);
		}
	}

	while (1) {
		AVPacket* packet = av_packet_alloc();
		int ret = av_read_frame(fmtCtx, packet);
		if (ret == 0 && packet->stream_index == videoStreamIndex) {
			ret = avcodec_send_packet(vcodecCtx, packet);
			if (ret == 0) {
				AVFrame* frame = av_frame_alloc();
				ret = avcodec_receive_frame(vcodecCtx, frame);
				if (ret == 0) {
					av_packet_unref(packet);
					avcodec_free_context(&vcodecCtx);
					avformat_close_input(&fmtCtx);
					return frame;
				}
				else if (ret == AVERROR(EAGAIN)) {
					av_frame_unref(frame);
					continue;
				}
			}
		}
		av_packet_unref(packet);
	}
}
```

### Rendering the first frame screen

```cpp
void StretchBits (HWND hwnd, const vector<Color_RGB>& bits, int width, int height) {
	auto hdc = GetDC(hwnd);
	for (int x = 0; x < width; x++) {
		for (int y = 0; y < height; y++) {
			auto& pixel = bits[x + y * width];
			SetPixel(hdc, x, y, RGB(pixel.r, pixel.g, pixel.b));
		}
	}
	ReleaseDC(hwnd, hdc);
}
```

---

## FFmpeg - .configure编译参数

### 1.1 Help options 帮助选项

| 参数 | 参数作用 |
| --- | --- |
| –help | 打印显示帮助信息 |
| –quiet | 禁止显示信息输出 |
| –list-decoders | 显示所有可用的解码器 |
| –list-encoders | 显示所有可用的编码器 |

... (and many more options)

