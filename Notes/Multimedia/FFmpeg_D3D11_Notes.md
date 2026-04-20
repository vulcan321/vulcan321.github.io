
# FFmpeg 与 D3D11 相关笔记整合

本文档整合了多个关于 FFmpeg 和 D3D11 的 Markdown 文件，涵盖了从基础使用到高级主题的各种内容，包括硬件加速、视频渲染和播放器实现等。

---

# # D3D11显示ffmpeg解码出的YUV420P数据

最近在做D3D11的播放器，用来显示ffmpeg解码出来的AVFrame，这里记录下踩过的坑。

刚开始的实现是基于RGBA，需要使用sws*scale将AVFrame像素格式转换成RGBA，然后更新纹理（格式为DXGI*FORMAT*R8G8B8A8*UNORM）。这里就有两个选择：第一种是创建纹理时选择D3D11*USAGE*DEFAULT类型的内存，然后只用UpdateSubresource来更新纹理；第二种是选择D3D11*USAGE*DYNAMIC类型的内存，加上D3D11*CPU*ACCESS_WRITE标记，这样可以使用 Map/memcpy/Unmap模式来更新纹理。比较而言，前者的效率更高些。

这里有一个坑：当显示全尺寸的图像时没什么问题。但是当播放器窗口较小时，就会黑屏（静止），最后发现是创建纹理缓存时，没有指定MipLevels=1，所以导致后续的更新纹理操作都只更新了原始的那个纹理。

后来考虑到sws_scale只是CPU处理，而且RGBA数据比原始的YUV420P要大很多，占用带宽，相同大小的YUV420P数据量只相当于RGBA像素格式的 6/16（以每4像素算，前者6字节，后者16字节）。既然YUV420P分为3个plane，每个plane都可以视为一个纹理，那么直接使用3个纹理也是没问题的。

> 搜索到 https://www.cnblogs.com/betterwgo/p/6131723.html 实现的和这个最接近（感谢前辈），但代码包括shader都是 d3d9 的，把它转成 d3d11

> 1.创建纹理方面的代码如下：  
> 
> ```cpp
> // ID3D11ShaderResourceView* resourceViewPlanes_[3];
> // ID3D11Texture2D *texturePlanes_[3];
> CD3D11*TEXTURE2D*DESC textureDesc(DXGI*FORMAT*R8_UNORM, width, height);
> textureDesc.MipLevels = 1;
> hr = device->CreateTexture2D(&textureDesc, NULL, &texturePlanes_[0]);
> textureDesc.Width = width/2; textureDesc.Height = height/2;
> hr = device->CreateTexture2D(&textureDesc, NULL, &texturePlanes_[1]);
> hr = device->CreateTexture2D(&textureDesc, NULL, &texturePlanes_[2]);
> 
> // CD3D11*SHADER*RESOURCE*VIEW*DESC srvDesc(texturePlanes*[0],D3D11*SRV*DIMENSION*TEXTURE2D,DXGI*FORMAT*R8_UNORM);
> // hr = videoDevice*->CreateShaderResourceView(texturePlanes*[0], &srvDesc,&resourceViewPlanes_[0]);
> // srvDesc.Format = DXGI*FORMAT*R8_UNORM;
> // hr = videoDevice*->CreateShaderResourceView(texturePlanes*[1], &srvDesc,&resourceViewPlanes_[1]);
> // hr = videoDevice*->CreateShaderResourceView(texturePlanes*[2], &srvDesc,&resourceViewPlanes_[2]);
> ```
> 
> 2.更新纹理代码如下：  
> 
> ```cpp
> //AVFrame *frame，保证是 AV*PIX*FMT_YUV420P
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

> 这里又有个坑：当你创建纹理缓存时指定的DXGI*FORMAT*R8*UNORM和 shader 内 PS 函数获取采样色彩后分量不一致时，会没有效果。我当时指定 DXGI*FORMAT*A8*UNORM，获取时写 float y = u*texY.Sample(SampleType, input.tex).r，注意最后那个 .r，这时候需要把 .r 改为 .a，或者将DXGI*FORMAT*A8*UNORM改为DXGI*FORMAT*R8_UNORM。

> 改完之后，绘制效率提升不少。

---

# # 使用D3D11直接渲染YUV数据

最初学习D3D11时，采取的是直接渲染RGB数据的方式，因为采集的时候采出来的是YUV420格式，需要利用libyuv库把YUVI420转成RGB格式。但是在实际项目中，这种转换会非常消耗CPU性能，因此需要寻求一种能够直接渲染YUV数据方式。

目前D3D11直接渲染YUV的主流方式有两种，第一种是创建三个纹理，用着色器转成RGB数据渲染（这部分转换操作应该是在GPU上进行的）；第二种是D3D11.1之后支持直接渲染YUV数据。这里采取的是第一种方式，废话不多说，直接上代码。

```cpp
bool D3D11Render::InitDirect3d()
{
	HRESULT hr = S_OK;
	//创建d3d设备及设备上下文

	//驱动类型数组
	D3D*DRIVER*TYPE driverTypes[] = {
		D3D*DRIVER*TYPE_HARDWARE,  //硬件驱动
		D3D*DRIVER*TYPE_WARP,	   //WARP驱动
		D3D*DRIVER*TYPE_REFERENCE, //软件驱动
	};
	UINT numDriverTypes = ARRAYSIZE(driverTypes);

	//特性等级数组
	D3D*FEATURE*LEVEL featureLevels[] = {
		D3D*FEATURE*LEVEL*11*1,
		D3D*FEATURE*LEVEL*11*0,
	};
	UINT numFeatureLevels = ARRAYSIZE(featureLevels);

	D3D*FEATURE*LEVEL featureLevel;
	D3D*DRIVER*TYPE d3dDriverType;
	for (UINT driverTypeIndex = 0; driverTypeIndex < numDriverTypes; driverTypeIndex++) {
		d3dDriverType = driverTypes[driverTypeIndex];
		hr = D3D11CreateDevice(nullptr, d3dDriverType, nullptr, 0, featureLevels, numFeatureLevels, D3D11*SDK*VERSION,
			m*pd3dDevice.GetAddressOf(), &featureLevel, m*pd3dImmediateContex.GetAddressOf());
		if (hr == E_INVALIDARG) {
			//Direct3D 11.0的API不承认D3D*FEATURE*LEVEL*11*1,因此需要尝试D3D*FEATURE*LEVEL*11*0及其以下版本
			hr = D3D11CreateDevice(nullptr, d3dDriverType, nullptr, 0, &featureLevels[1], numFeatureLevels - 1, D3D11*SDK*VERSION,
				m*pd3dDevice.GetAddressOf(), &featureLevel, m*pd3dImmediateContex.GetAddressOf());
		}
		if (SUCCEEDED(hr)) break;
	}
	if (FAILED(hr)) {
		std::cout << "Create Direct3D device failed." << std::endl;
		return false;
	}

	//检测是否支持特性等级11.0或者11.1
	if (featureLevel != D3D*FEATURE*LEVEL*11*1 && featureLevel != D3D*FEATURE*LEVEL*11*0) {
		std::cout << "Direct3D feature level 11 not support." << std::endl;
		return false;
	}
	//检测MSAA支持的质量等级
	m*pd3dDevice->CheckMultisampleQualityLevels(DXGI*FORMAT*B8G8R8A8*UNORM, 4, &m_4xMsaaQuality);
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
		hr = m*pd3dDevice.As(&m*pd3dDevice1);
		if (FAILED(hr)) {
			std::cout << "m*pd3dDevice.As(&m*pd3dDevice1) failed." << std::endl;
			LogErrorText(hr);
			return false;
		}
		m*pd3dImmediateContex.As(&m*pd3dImmediateContex1);
		if (FAILED(hr)) {
			std::cout << "m*pd3dImmediateContex.As(&m*pd3dImmediateContex1) failed." << std::endl;
			LogErrorText(hr);
			return false;
		}
		//创建11.1 Swap Chain
		DXGI*SWAP*CHAIN_DESC1 sd;
		ZeroMemory(&sd, sizeof(sd));
		sd.Width = m_width; 
		sd.Height = m_height; 
		sd.Format = DXGI*FORMAT*B8G8R8A8_UNORM; 
		if (m_Enable4xMsaa) {
			sd.SampleDesc.Count = 4; 
			sd.SampleDesc.Quality = m_4xMsaaQuality - 1; 
		}
		else {
			sd.SampleDesc.Count = 1;
			sd.SampleDesc.Quality = 0;
		}
		sd.BufferUsage = DXGI*USAGE*RENDER*TARGET*OUTPUT; 
		sd.BufferCount = 1;								 
		sd.SwapEffect = DXGI*SWAP*EFFECT_DISCARD;		  
		sd.Flags = 0;									
		

		DXGI*SWAP*CHAIN*FULLSCREEN*DESC fd;
		fd.RefreshRate.Denominator = 1; 
		fd.RefreshRate.Numerator = 60; 
		fd.Scaling = DXGI*MODE*SCALING_UNSPECIFIED;
		fd.ScanlineOrdering = DXGI*MODE*SCANLINE*ORDER*UNSPECIFIED;
		fd.Windowed = TRUE; 

		hr = dxgiFactory2->CreateSwapChainForHwnd(m*pd3dDevice.Get(), m*hwnd, &sd, &fd, nullptr, m_pSwapChain1.GetAddressOf());
		if (FAILED(hr)) {
			std::cout << "CreateSwapChain1 failed." << std::endl;
			LogErrorText(hr);
			return false;
		}
		hr = m*pSwapChain1.As(&m*pSwapChain);
		if (FAILED(hr)) {
			std::cout << "m*pSwapChain1.As(&m*pSwapChain) failed." << std::endl;
			LogErrorText(hr);
			return false;
		}
	}
	else {
		//创建11.0 Swap Chain
		DXGI*SWAP*CHAIN_DESC sd;
		ZeroMemory(&sd, sizeof(sd));
		sd.BufferDesc.Width = m_width;
		sd.BufferDesc.Height = m_height;
		sd.BufferDesc.RefreshRate.Numerator = 60;
		sd.BufferDesc.RefreshRate.Denominator = 1;
		sd.BufferDesc.Format = DXGI*FORMAT*B8G8R8A8_UNORM;
		sd.BufferDesc.ScanlineOrdering = DXGI*MODE*SCANLINE*ORDER*UNSPECIFIED;
		sd.BufferDesc.Scaling = DXGI*MODE*SCALING_UNSPECIFIED;
		if (m_Enable4xMsaa) {
			sd.SampleDesc.Count = 4; 
			sd.SampleDesc.Quality = m_4xMsaaQuality - 1; 
		}
		else {
			sd.SampleDesc.Count = 1;
			sd.SampleDesc.Quality = 0;
		}
		sd.BufferUsage = DXGI*USAGE*RENDER*TARGET*OUTPUT;
		sd.BufferCount = 1;
		sd.OutputWindow = m_hwnd;
		sd.Windowed = TRUE;
		sd.SwapEffect = DXGI*SWAP*EFFECT_DISCARD;
		sd.Flags = 0;

		hr = dxgiFactory1->CreateSwapChain(m*pd3dDevice.Get(), &sd, m*pSwapChain.GetAddressOf());
		if (FAILED(hr)) {
			std::cout << "CreateSwapChain failed." << std::endl;
			LogErrorText(hr);
			return false;
		}
	}
	dxgiFactory1->MakeWindowAssociation(m*hwnd, DXGI*MWA*NO*ALT_ENTER);

	//创建三个YUV纹理
	D3D11*TEXTURE2D*DESC textureDesc;
	textureDesc.Width = m_width;
	textureDesc.Height = m_height;
	textureDesc.MipLevels = 1; 
	textureDesc.ArraySize = 1; 
	textureDesc.Format = DXGI*FORMAT*R8_UNORM; 
	if (m_Enable4xMsaa) {
		textureDesc.SampleDesc.Count = 4;
		textureDesc.SampleDesc.Quality = m_4xMsaaQuality - 1;
	}
	else {
		textureDesc.SampleDesc.Count = 1;
		textureDesc.SampleDesc.Quality = 0;
	}
	textureDesc.Usage = D3D11*USAGE*DEFAULT;
	textureDesc.BindFlags = D3D11*BIND*SHADER_RESOURCE;
	textureDesc.CPUAccessFlags = D3D11*CPU*ACCESS_WRITE; 
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
	D3D11*SHADER*RESOURCE*VIEW*DESC resourceviewDesc;
	resourceviewDesc.Format = DXGI*FORMAT*R8_UNORM;
	resourceviewDesc.ViewDimension = D3D11*SRV*DIMENSION_TEXTURE2D;
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
	hr = m*pd3dDevice->CreateRenderTargetView(backBuffer.Get(), nullptr, m*pRenderTargetView.GetAddressOf()); 
	if (FAILED(hr)) {
		std::cout << "CreateRenderTargetView failed." << std::endl;
		LogErrorText(hr);
		return false;
	}
	m*pd3dImmediateContex->OMSetRenderTargets(1, m*pRenderTargetView.GetAddressOf(), nullptr);

	m_ScreenViewPort.TopLeftX = 0; 
	m_ScreenViewPort.TopLeftY = 0; 
	m*ScreenViewPort.Width = static*cast<float>(m_width);
	m*ScreenViewPort.Height = static*cast<float>(m_height);
	m_ScreenViewPort.MinDepth = 0.0f; 
	m_ScreenViewPort.MaxDepth = 1.0f; 
	m*pd3dImmediateContex->RSSetViewports(1, &m*ScreenViewPort); 
	SetWindowPos(m*hwnd, NULL, 0, 0, m*width, m*height, SWP*NOZORDER);

	std::cout << "Initialize D3D11 success." << std::endl;
	return true;
}
```

---

# # 基于FFMPEG 和 DirectX11的流媒体视频

## # 第一步：设置源流和视频解码器

```cpp
// initialize stream
const std::string hw*device*name = "d3d11va";
AVHWDeviceType device*type = av*hwdevice*find*type*by*name(hw*device*name.c_str());
// set up codec context
AVBufferRef* hw*device*ctx;
av*hwdevice*ctx*create(&hw*device*ctx, device*type, nullptr, nullptr, 0);
codec*ctx->hw*device*ctx = av*buffer*ref(hw*device_ctx);
// open stream
```

## # 第二步：转换 NV12 为 RGBA

```cpp
SwsContext* conversion*ctx = sws*getContext(
        SRC*WIDTH, SRC*HEIGHT, AV*PIX*FMT_NV12,
        DST*WIDTH, DST*HEIGHT, AV*PIX*FMT_RGBA,
        SWS*BICUBLIN | SWS*BITEXACT, nullptr, nullptr, nullptr);
```

## # 第三步：设置 DirectX11 渲染

## # 第四步：交换纹理颜色

## # 第五步：渲染实际的帧

```cpp
// decode and convert frame
static constexpr int BYTES*IN*RGBA_PIXEL = 4;
D3D11*MAPPED*SUBRESOURCE ms;
device*context->Map(m*texture.Get(), 0, D3D11*MAP*WRITE_DISCARD, 0, &ms);
memcpy(ms.pData, frame->data[0], frame->width * frame->height * BYTES*IN*RGBA_PIXEL);
device*context->Unmap(m*texture.Get(), 0);
// clear the render target view, draw the indices, present the swapchain
```

## # 第六步：渲染实际帧… 可能是正确的

```cpp
AVBufferRef* hw*device*ctx = av*hwdevice*ctx*alloc(AV*HWDEVICE*TYPE*D3D11VA);
AVHWDeviceContext* device*ctx = reinterpret*cast<AVHWDeviceContext*>(hw*device*ctx->data);
AVD3D11VADeviceContext* d3d11va*device*ctx = reinterpret*cast<AVD3D11VADeviceContext*>(device*ctx->hwctx);
// m_device is our ComPtr<ID3D11Device>
d3d11va*device*ctx->device = m_device.Get();
// codec_ctx is a pointer to our FFmpeg AVCodecContext
codec*ctx->hw*device*ctx = av*buffer*ref(hw*device_ctx);
av*hwdevice*ctx*init(codec*ctx->hw*device*ctx);
```

---

# # 调用D3D11硬解码和渲染VideoProcessor版本

在https://blog.csdn.net/robothn/article/details/78781321一文中使用shader来显示FFMPEG硬解码后的YUV420P，本文调用D3D11的videoprocessor来进行图像空间变换和尺寸变换，取得了较好的效果。  
从实际使用效果来看，FFMPEG解码后的数据使用UpdateSubresource需要把数据进行搬运出来处理，使用videoprocessorBLT设置适当的入参，可直接对Subresource进行色度空间和尺寸变换，减少了数据搬运过程。  
frame->data\[1\]是subresource的index。  
处理如下：  
int index = (intptr\_t)frame->data\[1\];

---

# # Qt音视频开发10-ffmpeg内核硬解码

## # 硬解码大致流程：

1.  根据硬解码类型查找硬解码设备类型 av\*hwdevice\*find\*type\*by\_name
2.  根据解码设备类型找到硬解码的格式 find\*fmt\*by\*hw\*type
3.  获取解码器格式回调 videoCodecCtx->get\_format
4.  创建硬解码设备 av\*hwdevice\*ctx\_create
5.  设备硬解码设备 videoCodecCtx->hw\*device\*ctx
6.  解码数据包 avcodec\*send\*packet avcodec\*receive\*frame
7.  将硬解码后的数据从GPU转换取出来 av\*hwframe\*transfer\_data

---

# # The realization of FFmpeg simple player 1-the simplest version

## # 2.2 Source code list

```c
# include <stdio.h>
# include <libavcodec/avcodec.h>
# include <libavformat/avformat.h>
# include <libswscale/swscale.h>
# include <SDL2/SDL.h>
# include <SDL2/SDL_video.h>
# include <SDL2/SDL_render.h>
# include <SDL2/SDL_rect.h>

int main(int argc, char *argv[])
{
    // ...
    ret = avformat*open*input(&p*fmt*ctx, argv[1], NULL, NULL);
    // ...
    ret = avformat*find*stream*info(p*fmt_ctx, NULL);
    // ...
    p*codec = avcodec*find*decoder(p*codec*par->codec*id);
    // ...
    ret = avcodec*open2(p*codec*ctx, p*codec, NULL);
    // ...
    while (av*read*frame(p*fmt*ctx, p_packet) == 0)
    {
        if (p*packet->stream*index == v_idx) 
        {
            ret = avcodec*send*packet(p*codec*ctx, p_packet);
            // ...
            ret = avcodec*receive*frame(p*codec*ctx, p*frm*raw);
            // ...
            sws*scale(sws*ctx, (const uint8*t *const *)p*frm*raw->data, p*frm*raw->linesize, 0, p*codec*ctx->height, p*frm*yuv->data, p*frm_yuv->linesize);
            // ...
            SDL*UpdateYUVTexture(sdl*texture, &sdl*rect, p*frm*yuv->data[0], p*frm*yuv->linesize[0], p*frm*yuv->data[1], p*frm*yuv->linesize[1], p*frm*yuv->data[2], p*frm_yuv->linesize[2]);
            // ...
            SDL*RenderPresent(sdl*renderer);  
            // ...
        }
        av*packet*unref(p_packet);
    }
    // ...
}
```

---

# # C ++ From scratch, only FFMPEG, WIN32 API, implement a player

## # Decoding the first frame picture

```cpp
AVFrame* getFirstFrame(const char* filePath) {
	AVFormatContext* fmtCtx = nullptr;
	avformat*open*input(&fmtCtx, filePath, NULL, NULL);
	avformat*find*stream_info(fmtCtx, NULL);

	int videoStreamIndex;
	AVCodecContext* vcodecCtx = nullptr;
	for (int i = 0; i < fmtCtx->nb_streams; i++) {
		AVStream* stream = fmtCtx->streams[i];
		if (stream->codecpar->codec*type == AVMEDIA*TYPE_VIDEO) {
			const AVCodec* codec = avcodec*find*decoder(stream->codecpar->codec_id);
			videoStreamIndex = i;
			vcodecCtx = avcodec*alloc*context3(codec);
			avcodec*parameters*to_context(vcodecCtx, fmtCtx->streams[i]->codecpar);
			avcodec_open2(vcodecCtx, codec, NULL);
		}
	}

	while (1) {
		AVPacket* packet = av*packet*alloc();
		int ret = av*read*frame(fmtCtx, packet);
		if (ret == 0 && packet->stream_index == videoStreamIndex) {
			ret = avcodec*send*packet(vcodecCtx, packet);
			if (ret == 0) {
				AVFrame* frame = av*frame*alloc();
				ret = avcodec*receive*frame(vcodecCtx, frame);
				if (ret == 0) {
					av*packet*unref(packet);
					avcodec*free*context(&vcodecCtx);
					avformat*close*input(&fmtCtx);
					return frame;
				}
				else if (ret == AVERROR(EAGAIN)) {
					av*frame*unref(frame);
					continue;
				}
			}
		}
		av*packet*unref(packet);
	}
}
```

## # Rendering the first frame screen

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

# # FFmpeg - .configure编译参数

## # 1.1 Help options 帮助选项

| 参数 | 参数作用 |
| --- | --- |
| –help | 打印显示帮助信息 |
| –quiet | 禁止显示信息输出 |
| –list-decoders | 显示所有可用的解码器 |
| –list-encoders | 显示所有可用的编码器 |

... (and many more options)

