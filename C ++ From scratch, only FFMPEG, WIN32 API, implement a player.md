## Foreword

At first I just wanted to make a program that directly read the video file and play characters animation. My idea is very simple, as long as there is a ready-made library, help me analyze the video file into the original picture information of one frame, then I only need to read the RGB value of each pixel inside, calculate the brightness, then map according to the brightness map To a character, all these characters have been put together, and things are completed. So I started researching how to use FFmpeg's library, I still easily find the relevant tutorial, soon I will realize the goal.

![image](https://programmerall.com/images/521/d6/d67624cf1b4cbe2a7dc04d09cb5240f9.png)

After I thought, I would like to do a positive player to see it. As a result, I have encountered a bunch of questions. The purpose of writing this article is to explore these problems, and my answer. Share it.

Because it is not intended to cross the platform, there is no use of any build system, and the Visual Studio 2019 new project is opened. I don't plan to show the superb software engineering skills, and the perfect mistake handling, so the code is a bus. How can I just simply come, the focus is how to do this, how to start, the rest of the situation Give everyone a free play.

I thought I was written, and I feel that it is too long. Especially the rendering part of DirectX 11 is too complicated. DirectX 9 is still simple, so the first one, first put DX9 rendering, second, then say DX11.

## A simple window

Now that the actual product will not write Gui directly with Win32 API, I have chosen this, because I want to understand the underlying thing, but I don't want to introduce too much extra thing, such as Qt, SDL The Gui library and the like, and I have never thought about it. I have to make a utility. In fact, my version is done with SDL 2.0, and then slowly disengage, write rendering code.

![image](https://programmerall.com/images/168/30/308efe8059523337a2532415185eef28.png)

The first thing to say is, in the project properties - linker - system - subsystem selection**Window (/ Subsystem: Windows)**If you can start, you can start the console window when you start. Of course, this is actually not a matter, even if it is used.**Console (/ Subsystem: console)**It also does not hinder the functionality of the program function.

Create a core function of the window,[`CreateWindow`](https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-createwindoww)(Experience: Yes`CreateWindowA`or`CreateWindowW`These two are the name of the user32.dll export function, but for convenience, I will use the macro that introduces the Windows header file as a function name, but it is important to pay attention to it), but it has 11 parameters to fill, very Persuade.

```cpp
Auto window = CreateWindow (ClassName, L <span class="hljs-string">"Hello World Title"</span>, WS_Overlapped, CW_USEDEFAULT, CW_USEDEFAULT, <span class="hljs-number">800</span>, <span class="hljs-number">600</span>, <span class="hljs-literal">NULL</span>, <span class="hljs-literal">NULL</span>, HINSTANCE, <span class="hljs-literal">NULL</span>;
```

`className` It is the name of the window, and I will say it later.`L "Hello World Title"` It will appear in the window title bar,`WS_OVERLAPPEDWINDOW`It is a macro, represents a window style, such as when you want a window without a borderless window, you have to use another style.`CW_USEDEFAULT, CW_USEDEFAULT, 800, 600`Represents the position coordinates and aspects of the window, where we use the default, the size can be specified, and the remaining parameters are not important in the current, all NULL is completely no problem.

In call`CreateWindow` Before, you usually want to call`RegisterClass`, Register a window class, class names can be taken casually.

```cpp
auto className = L"MyWindow";
WNDCLASSW wndClass = {};
wndClass.hInstance = hInstance;
wndClass.lpszClassName = className;
wndClass.lpfnWndProc = [](HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) -> LRESULT {
	return DefWindowProc(hwnd, msg, wParam, lParam);
};

RegisterClass(&wndClass);
```

`WNDCLASSW`There are many content that need to be set, but it is essential is two, lpszclassname and lpfnWndproc, Hinstance are not necessary. lpszclassname is a class name, and lpfnWndProc is a function pointer, and this function is called whenever the window receives a message. Here we can use the Lambda expression of C ++ 11, it will automatically convert to a pure function pointer when assigning to lpfnWndProc, and you don't have to worry about the STDCALL CDECL invoking agreement, the premise is that we cannot use variable capture characteristics.

`return DefWindowProc(hwnd, msg, wParam, lParam);`The role is to hand over the message to Windows for default processing. For example, click the × hierarchy of the title bar to close the window, and maximize the minimization, the default behavior can be taken by the user, and we will handle it here. Mouse keyboard and other messages.

The window that is just created by default is hidden, so we have to call`ShowWindow` The window is displayed, and finally uses the message loop to make the window continue to receive the message.

```cpp
ShowWindow(window, SW_SHOW);

MSG msg;
while (GetMessage(&msg, window, 0, 0) > 0) {
	TranslateMessage(&msg);
	DispatchMessage(&msg);
}

```

Finally, don't forget the most beginning to call in the program.`SetProcessDPIAware()`Prevent Windows from being displayed in a blurred display when the Windows is displayed greater than 100%.

The complete code looks like this:

```cpp
#include <stdio.h>
#include <Windows.h>

int WINAPI WinMain (
	_In_ HINSTANCE hInstance,
	_In_opt_ HINSTANCE hPrevInstance,
	_In_ LPSTR lpCmdLine,
	_In_ int nShowCmd
) {
	SetProcessDPIAware();

	auto className = L"MyWindow";
	WNDCLASSW wndClass = {};
	wndClass.hInstance = NULL;
	wndClass.lpszClassName = className;
	wndClass.lpfnWndProc = [](HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) -> LRESULT {
		return DefWindowProc(hwnd, msg, wParam, lParam);
	};

	RegisterClass(&wndClass);
	Auto Window = CreateWindow (ClassName, L "Hello World Title", WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, 800, 600, NULL, NULL, NULL, NULL;

	ShowWindow(window, SW_SHOW);

	MSG msg;
	while (GetMessage(&msg, window, 0, 0) > 0) {
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}

	return 0;
}
```

Effect:

![image](https://programmerall.com/images/819/63/637dc268dffb6eedbfa653e97112b55b.png)

## FFMPEG

We can't comply with the source code, download the compiled file directly:[https://github.com/BtbN/FFmpeg-Builds/releases](https://github.com/BtbN/FFmpeg-Builds/releases)Pay attention to the version of the version of Shared, for example:`ffmpeg-N-102192-gc7c138e411-win64-gpl-shared.zip`After decompression, there are three folders, which are bin, including, lib, which corresponds to three things that need to be configured.

Next, build two environment variables, pay attention to the directory to your actual extract directory:

-   FFMPEG\_INCLUDE = D:\\Download\\ffmpeg-N-102192-gc7c138e411-win64-gpl-shared\\include
-   FFMPEG\_LIB = D:\\Download\\ffmpeg-N-102192-gc7c138e411-win64-gpl-shared\\lib

Note Each time you modify the environment variable, you need to restart Visual Studio. Then configure the included directory and library directory in the VC ++ directory.

![image](https://programmerall.com/images/890/81/81aaef6c33bc4e7532940cb1937d7efa.png)

Then you can introduce FFMPEG header files in your code and correctly compiled:

```cpp
extern "C" {
#include <libavcodec/avcodec.h>
#pragma comment(lib, "avcodec.lib")

#include <libavformat/avformat.h>
#pragma comment(lib, "avformat.lib")

#include <libavutil/imgutils.h>
#pragma comment(lib, "avutil.lib")

}
```

Finally, join the path in the environment variable Path`D:\Download\ffmpeg-N-102192-gc7c138e411-win64-gpl-shared\bin`In order to make the program to properly load FFMPEG's DLL when running.

## Decoding the first frame picture

Next we write a function to get the pixel collection of the first frame.

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

The process is simple, that is:

1.  Obtain `AVFormatContext`This represents the container of this video file
2.  Obtain `AVStream`A video file will have multiple streams, video streams, audio flows, etc. Other resources, we currently only pay attention to video flow, so there is a judgment here.`stream->codecpar->codec_type == AVMEDIA_TYPE_VIDEO`
3.  Obtain `AVCodec`, Decoder corresponding to a stream
4.  Obtain`AVCodecContext`, Represent the decoder context environment
5.  Enter the decoding cycle, call`av_read_frame` Obtain `AVPacket`, Determine whether it is a data packet of a video stream, is called`avcodec_send_packet` send to `AVCodecContext` Decoding, sometimes a packet is not enough to decode a complete frame screen, at this time, it is necessary to obtain the next packet, call again.`avcodec_send_packet` Send it to the decoder and attempts to decode successful.
6.  Last pass`avcodec_receive_frame` owned `AVFrame` Inside the original picture information

Many video screens are all black, it is not convenient to test, so you can change the code slightly, read more frames more.

```cpp
AVFrame* getFirstFrame(const char* filePath, int frameIndex) {
// ...
	n++;
	if (n == frameIndex) {
		av_packet_unref(packet);
		avcodec_free_context(&vcodecCtx);
		avformat_close_input(&fmtCtx);
		return frame;
	}
	else {
		av_frame_unref(frame);
	}
// ...
}
```

You can read the width of the screen directly through the AVFrame. Height

```
AVFrame* firstframe = getFirstFrame(filePath.c_str(), <span class="hljs-number">10</span>);

<span class="hljs-keyword">int</span> width = firstframe-&gt;width;
<span class="hljs-keyword">int</span> height = firstframe-&gt;height;
```

Our original picture pixel information is concerned`AVFrame::data` In his specific structure, depending on`AVFrame::format`This is the pixel format used by the video. At present, most of the video is YUV420P (`AVPixelFormat::AV_PIX_FMT_YUV420P`For convenience, we only consider its processing.

## Rendering the first frame screen

Unlike us, the pixel format used in most videos is not RGB, but YUV, Y represents brightness, UV represents chromaticity, concentration. The most important thing is that it has different sampling methods, the most common YUV420P, each pixel, all stores 1 byte Y value, each 4 pixels, shared 1 U and 1 V value, so a 1920x1080 Image, only occupied`1920 * 1080 * (1 + (1 + 1) / 4) = 3110400` Bytes are half of RGB coding. This uses the human eye to sensitive to brightness, but is relatively insensitive to color, even if the chromatic bandwidth is lowered, the senses are not too distorted.

But Windows cannot directly render the data of YUV, so it needs to be converted. Here, in order to see the picture as soon as possible, we only use the Y value to display black and white pictures, the specific practices are as follows:

```cpp
struct Color_RGB
{
	uint8_t r;
	uint8_t g;
	uint8_t b;
};

AVFrame* firstframe = getFirstFrame(filePath.c_str(), 30);

int width = firstframe->width;
int height = firstframe->height;

vector<Color_RGB> pixels(width * height);
for (int i = 0; i < pixels.size(); i++) {
	uint8_t r = firstframe->data[0][i];
	uint8_t g = r;
	uint8_t b = r;
	pixels[i] = { r, g, b };
}
```

The YUV420P format will store the Y, U, V three values stored in three arrays.`AVFrame::data[0]` Is the Y channel array, we simply put the brightness value into the RGB, you can achieve a black and white picture. Next, write a function to rendering the processed RGB array, we use the most traditional GDI drawing method here:

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

exist `ShowWindow` After calling, call the above`StretchBits` The function will see that the screen is gradually appearing in the window:

```cpp
//...
ShowWindow(window, SW_SHOW);

StretchBits(window, pixels, width, height);

MSG msg;
while (GetMessage(&msg, window, 0, 0) > 0) {
	TranslateMessage(&msg);
	DispatchMessage(&msg);
}
// ...
```

![image](https://programmerall.com/images/810/25/25e3553bea9f67701f7fe8acf6c18c3a.png)

An obvious question is that the rendering efficiency is too low. It takes a frame to show a few seconds. For the video of 24 frames per second, this is completely unacceptable, so we will try gradually optimize`StretchBits` function.

## Optimize GDI rendering

`SetPixel` The function is obviously too low, and a better solution is to use`StretchDIBits` Function, but he is not as simple as it is used.

```cpp
void StretchBits (HWND hwnd, const vector<Color_RGB>& bits, int width, int height) {
	auto hdc = GetDC(hwnd);
	BITMAPINFO bitinfo = {};
	auto& bmiHeader = bitinfo.bmiHeader;
	bmiHeader.biSize = sizeof(bitinfo.bmiHeader);
	bmiHeader.biWidth = width;
	bmiHeader.biHeight = -height;
	bmiHeader.biPlanes = 1;
	bmiHeader.biBitCount = 24;
	bmiHeader.biCompression = BI_RGB;

	StretchDIBits(hdc, 0, 0, width, height, 0, 0, width, height, &bits[0], &bitinfo, DIB_RGB_COLORS, SRCCOPY);
	ReleaseDC(hwnd, hdc);
}
```

Notice `bmiHeader.biHeight = -height;` Here you must use a negative number, otherwise the screen will turn upside down,[BITMAPINFOHEADER structure](https://docs.microsoft.com/en-us/previous-versions/dd183376(v=vs.85)) There is a detailed explanation. At this time we rendered a frame of screen, shortened to a few milliseconds.

## Play continuous screen

First we have to dismantle`getFirstFrame` Function, extract the part of the cyclic decoding, decompose into two functions:`InitDecoder` with `RequestFrame`

```cpp
struct DecoderParam
{
	AVFormatContext* fmtCtx;
	AVCodecContext* vcodecCtx;
	int width;
	int height;
	int videoStreamIndex;
};

void InitDecoder(const char* filePath, DecoderParam& param) {
	AVFormatContext* fmtCtx = nullptr;
	avformat_open_input(&fmtCtx, filePath, NULL, NULL);
	avformat_find_stream_info(fmtCtx, NULL);

	AVCodecContext* vcodecCtx = nullptr;
	for (int i = 0; i < fmtCtx->nb_streams; i++) {
		const AVCodec* codec = avcodec_find_decoder(fmtCtx->streams[i]->codecpar->codec_id);
		if (codec->type == AVMEDIA_TYPE_VIDEO) {
			param.videoStreamIndex = i;
			vcodecCtx = avcodec_alloc_context3(codec);
			avcodec_parameters_to_context(vcodecCtx, fmtCtx->streams[i]->codecpar);
			avcodec_open2(vcodecCtx, codec, NULL);
		}
	}

	param.fmtCtx = fmtCtx;
	param.vcodecCtx = vcodecCtx;
	param.width = vcodecCtx->width;
	param.height = vcodecCtx->height;
}

AVFrame* RequestFrame(DecoderParam& param) {
	auto& fmtCtx = param.fmtCtx;
	auto& vcodecCtx = param.vcodecCtx;
	auto& videoStreamIndex = param.videoStreamIndex;

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
					return frame;
				}
				else if (ret == AVERROR(EAGAIN)) {
					av_frame_unref(frame);
				}
			}
		}

		av_packet_unref(packet);
	}

	return nullptr;
}
```

In`main` Write this in the function:

```cpp
// ...
DecoderParam decoderParam;
InitDecoder(filePath.c_str(), decoderParam);
auto& width = decoderParam.width;
auto& height = decoderParam.height;
auto& fmtCtx = decoderParam.fmtCtx;
auto& vcodecCtx = decoderParam.vcodecCtx;

 Auto window = CreateWindow (ClassName, L "Hello World Title", WS_OVERLAPPEDWINDOW, 0, 0, DECODERPARM.WIDTH, DECODERPARAM.HEIGHT, NULL, NULL, HINSTANCE, NULL

ShowWindow(window, SW_SHOW);

MSG msg;
while (GetMessage(&msg, window, 0, 0) > 0) {
	AVFrame* frame = RequestFrame(decoderParam);

	vector<Color_RGB> pixels(width * height);
	for (int i = 0; i < pixels.size(); i++) {
		uint8_t r = frame->data[0][i];
		uint8_t g = r;
		uint8_t b = r;
		pixels[i] = { r, g, b };
	}

	av_frame_free(&frame);

	StretchBits(window, pixels, width, height);

	TranslateMessage(&msg);
	DispatchMessage(&msg);
}
// ...
```

At this point, run the program, discover the picture or not moving, only when our mouse is moving continuously, the screen will play continuously. This is because we used`GetMessage`When the window does not have any messages, the function will blocked until a new message will return. When we keep moving on the window, it is actually equivalent to sending a mouse event message to the window, which is allowed to make the While loop constantly.

Solution is to use`PeekMessage` Instead, the function returns no matter whether there is any received message. We change the message loop code slightly:

```cpp
// ...
wndClass.lpfnWndProc = [](HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) -> LRESULT {
	switch (msg)
	{
	case WM_DESTROY:
		PostQuitMessage(0);
		return 0;
	default:
		return DefWindowProc(hwnd, msg, wParam, lParam);
	}
};
// ...
while (1) {
	BOOL hasMsg = PeekMessage(&msg, NULL, 0, 0, PM_REMOVE);
	if (hasMsg) {
		if (msg.message == WM_QUIT) {
			break;
		}
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}
	else {
		AVFrame* frame = RequestFrame(decoderParam);

		vector<Color_RGB> pixels(width * height);
		for (int i = 0; i < pixels.size(); i++) {
			uint8_t r = frame->data[0][i];
			uint8_t g = r;
			uint8_t b = r;
			pixels[i] = { r, g, b };
		}

		av_frame_free(&frame);

		StretchBits(window, pixels, width, height);
	}
}
```

Pay attention to switch`PeekMessage` After you need to manually`WM_DESTROY` with `WM_QUIT` information. At this time, even if the mouse does not move the screen. But in my weakness of my notebook i5-1035G1, the picture is more miserable than the PPT. At this time, simply change the version of the VS from Debug to Release, the picture is directly like a fast forward button, this code optimizes and not It is time to be a difference.

It is too powerful to insert a performance diagnostic tool for Visual Studio.

![image](https://programmerall.com/images/785/48/485a5aed177433e476bde3f4a1b7b4c9.png)

You can clearly see the code, which function, how much CPU, take advantage of it, can easily find the most important place. You can see that the distribution of the Vector takes up most of the CPU time, we will make it again.

## Color picture

Ffmpeg's own function can help us handle color coding conversion, we need to introduce new headers:

```cpp
// ...
#include <libswscale/swscale.h>
#pragma comment(lib, "swscale.lib")
// ...
```

Then write a new function to convert color coding

```cpp
vector<Color_RGB> GetRGBPixels(AVFrame* frame) {
	static SwsContext* swsctx = nullptr;
	swsctx = sws_getCachedContext(
		swsctx,
		frame->width, frame->height, (AVPixelFormat)frame->format,
		frame->width, frame->height, AVPixelFormat::AV_PIX_FMT_BGR24, NULL, NULL, NULL, NULL);

	vector<Color_RGB> buffer(frame->width * frame->height);
	uint8_t* data[] = { (uint8_t*)&buffer[0] };
	int linesize[] = { frame->width * 3 };
	sws_scale(swsctx, frame->data, frame->linesize, 0, frame->height, data, linesize);

	return buffer;
}
```

`sws_scale` The function can be scaled on the screen while also changing the color code. Here we do not need to scale, so Width and Height are consistent.

Then call after decoding:

```cpp
// ...
AVFrame* frame = RequestFrame(decoderParam);

vector<Color_RGB> pixels = GetRGBPixels(frame);

av_frame_free(&frame);

StretchBits(window, pixels, width, height);
// ...
```

The effect is not bad:

![image](https://programmerall.com/images/374/e7/e7fcb8d11469e888d3f8e2986ebbc96e.png)

Next slightly optimized the code, in Debug mode, the Vector allocation memory seems to consume a lot of performance, and we think that the way is allocated before the message is loop.

```cpp
vector<Color_RGB> GetRGBPixels(AVFrame* frame, vector<Color_RGB>& buffer) {
	static SwsContext* swsctx = nullptr;
	swsctx = sws_getCachedContext(
		swsctx,
		frame->width, frame->height, (AVPixelFormat)frame->format,
		frame->width, frame->height, AVPixelFormat::AV_PIX_FMT_BGR24, NULL, NULL, NULL, NULL);

	uint8_t* data[] = { (uint8_t*)&buffer[0] };
	int linesize[] = { frame->width * 3 };
	sws_scale(swsctx, frame->data, frame->linesize, 0, frame->height, data, linesize);

	return buffer;
}

// ...
InitDecoder(filePath.c_str(), decoderParam);
auto& width = decoderParam.width;
auto& height = decoderParam.height;
auto& fmtCtx = decoderParam.fmtCtx;
auto& vcodecCtx = decoderParam.vcodecCtx;

vector<Color_RGB> buffer(width * height);
// ...
while (1) {
// ...
vector<Color_RGB> pixels = GetRGBPixels(frame, buffer);
// ...
}
```

This is not a PPT even in Debug mode.

## Correct playback speed

At present, our picture playback speed depends on your CPU computation speed, how do you control the presentation timing of each frame? A simple idea is to get the frame rate of the video, calculate how long each frame should be intervals, and then rendezed at each frame, call`Sleep` The function is delayed, and you will try it first:

```cpp
AVFrame* frame = RequestFrame(decoderParam);

vector<Color_RGB> pixels = GetRGBPixels(frame, buffer);

av_frame_free(&frame);

StretchBits(window, pixels, width, height);

double framerate = (double)vcodecCtx->framerate.den / vcodecCtx->framerate.num;
Sleep(framerate * 1000);
```

`AVCodecContext::framerate` You can get the frame rate of the video, representing how many frames need to be present per second, he is`AVRational` Type, similar to the score, NUM is a molecule, DEN is a denominator. Here we poured him, then multiplied by 1000, you need to wait for milliseconds per frame.

However, the actual viewing rate is slow, because the decoding and rendering itself will consume a lot of time, then the time to wait for the SLEEP wait, in fact, the time intervals per frame is elongated, and we try to solve this problem:

```cpp
// ...
#include <chrono>
#include <thread>
// ...

using namespace std::chrono;
// ...

int WINAPI WinMain (
	_In_ HINSTANCE hInstance,
	_In_opt_ HINSTANCE hPrevInstance,
	_In_ LPSTR lpCmdLine,
	_In_ int nShowCmd
) {
// ...

	auto currentTime = system_clock::now();

	MSG msg;
	while (1) {
		BOOL hasMsg = PeekMessage(&msg, NULL, 0, 0, PM_REMOVE);
		if (hasMsg) {
			// ...
		} else {
			// ...
			
			av_frame_free(&frame);

			double framerate = (double)vcodecCtx->framerate.den / vcodecCtx->framerate.num;
			std::this_thread::sleep_until(currentTime + milliseconds((int)(framerate * 1000)));
			currentTime = system_clock::now();

			StretchBits(window, pixels, width, height);
		}
	}
```

`std::this_thread::sleep_until`Ability to delay the specified point in time, using this feature, even if decoding and rendering occupy time, it does not affect the overall delay time, unless your decoding rendership time has exceeded each frame interval.

Rest assured, this clumsy approach is certainly not our ultimate program.

## Hardware decoding

Using this program on my notebook or smoothly playing 1080p24fps video, but when playing 1080p60fps video, let's take a look at it first, let's take a look for the most CPU:

![image](https://programmerall.com/images/78/76/768ebd3736205ba796d4ee8210da2f86.png)

Obvious`RequestFrame` It takes a lot of resources, which is the function of decoding, and try to use hardware decoding to see if it can improve efficiency:

```cpp
void InitDecoder(const char* filePath, DecoderParam& param) {
	// ...

	 // Enable hardware decoder
	AVBufferRef* hw_device_ctx = nullptr;
	av_hwdevice_ctx_create(&hw_device_ctx, AVHWDeviceType::AV_HWDEVICE_TYPE_DXVA2, NULL, NULL, NULL);
	vcodecCtx->hw_device_ctx = hw_device_ctx;

	param.fmtCtx = fmtCtx;
	param.vcodecCtx = vcodecCtx;
	param.width = vcodecCtx->width;
	param.height = vcodecCtx->height;
}

vector<Color_RGB> GetRGBPixels(AVFrame* frame, vector<Color_RGB>& buffer) {
	AVFrame* swFrame = av_frame_alloc();
	av_hwframe_transfer_data(swFrame, frame, 0);
	frame = swFrame;

	static SwsContext* swsctx = nullptr;
	
	// ...
	
	sws_scale(swsctx, frame->data, frame->linesize, 0, frame->height, data, linesize);

	av_frame_free(&swFrame);

	return buffer;
}
```

First pass`av_hwdevice_ctx_create` Create a hardware decoding device and assign the device to the device.`AVCodecContext::hw_device_ctx` That's`AV_HWDEVICE_TYPE_DXVA2` Is a type of hardware decoding device, related to the platform you run, in the Windows platform, usually used`AV_HWDEVICE_TYPE_DXVA2` or `AV_HWDEVICE_TYPE_D3D11VA`The compatibility is best, because later use DX9 rendering, we first use DXVA2.

At this time, the AVFrame decoded is not directly accessed to the original picture information, because the decoded data is still in the GPU memory, it needs to pass`av_hwframe_transfer_data` Copy (this is the Copy-Back option inside the player), and the color coding is turned into`AV_PIX_FMT_NV12`, Not formerly common`AV_PIX_FMT_YUV420P`But this doesn't have to worry,`sws_scale` Can help us handle it.

After running the program, the task manager does see that the GPU has a certain occupation:

![image](https://programmerall.com/images/359/7a/7a70425233101c31a1e4132d61909bef.png)

But still is not smooth enough, let's look at the performance analysis:

![image](https://programmerall.com/images/277/40/40fef68e12902713e928c15806ed9735.png)

It seems`sws_scale` The function consumes performance, but this is FFmpeg's function, we can't optimize from his internal, and then it is temporarily put on hold, and then resolves it later.

## Use D3D9 rendering screen

GDI rendering is ancient law, now we are always modern: Direct3D 9 rendering.

First introduce the necessary header files:

```cpp
#include <d3d9.h>
#pragma comment(lib, "d3d9.lib")
```

There is also a Microsoft to our benefits, Comptr:

```cpp
#include <wrl.h>
using Microsoft::WRL::ComPtr;
```

Because we will use the COM (Component Object Model) technology, it will be very convenient for COMPTR. About COM can say too much, it is really impossible to say too thin in this article, it is recommended to read the relevant information a little understanding again.

Next, the D3D9 device is initialized

```cpp
// ...

ShowWindow(window, SW_SHOW);

// D3D9
ComPtr<IDirect3D9> d3d9 = Direct3DCreate9(D3D_SDK_VERSION);
ComPtr<IDirect3DDevice9> d3d9Device;

D3DPRESENT_PARAMETERS d3dParams = {};
d3dParams.Windowed = TRUE;
d3dParams.SwapEffect = D3DSWAPEFFECT_DISCARD;
d3dParams.BackBufferFormat = D3DFORMAT::D3DFMT_X8R8G8B8;
d3dParams.Flags = D3DPRESENTFLAG_LOCKABLE_BACKBUFFER;
d3dParams.BackBufferWidth = width;
d3dParams.BackBufferHeight = height;
d3d9->CreateDevice(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, window, D3DCREATE_HARDWARE_VERTEXPROCESSING, &d3dParams, d3d9Device.GetAddressOf());

auto currentTime = system_clock::now();
// ...
```

use `ComPtr` This C ++ template class woines the COM pointer, there is no need to worry about the resource release problem, and the end of the variable lifecycle will automatically call the release resource.

The most important parameter for creating equipment is`D3DPRESENT_PARAMETERS` structure,`Windowed = TRUE` Set up window mode, we don't need full screen now.`SwapEffect` Is the exchange chain mode, choose`D3DSWAPEFFECT_DISCARD` Phase.`BackBufferFormat` More important, you must choose`D3DFMT_X8R8G8B8`, Because he can simultaneously act as a post-buffered format and display format (see figure below), and`sws_scale` It can also be converted to this format correctly.

![image](https://programmerall.com/images/959/ee/ee90945138ee2cea68a23caca1151997.png)

Flags must be`D3DPRESENTFLAG_LOCKABLE_BACKBUFFER`, Because we will write directly to the data directly, you don't have a 3D texture.

Re-adjusted`GetRGBPixels` function:

```cpp
void GetRGBPixels(AVFrame* frame, vector<uint8_t>& buffer, AVPixelFormat pixelFormat, int byteCount) {
	AVFrame* swFrame = av_frame_alloc();
	av_hwframe_transfer_data(swFrame, frame, 0);
	frame = swFrame;

	static SwsContext* swsctx = nullptr;
	swsctx = sws_getCachedContext(
		swsctx,
		frame->width, frame->height, (AVPixelFormat)frame->format,
		frame->width, frame->height, pixelFormat, NULL, NULL, NULL, NULL);

	uint8_t* data[] = { &buffer[0] };
	int linesize[] = { frame->width * byteCount };
	sws_scale(swsctx, frame->data, frame->linesize, 0, frame->height, data, linesize);

	av_frame_free(&swFrame);
}
```

Added parameters PixelFormat to customize the output pixel format, the purpose is to output it later`AV_PIX_FMT_BGRA` Formatted data, it corresponds to`D3DFMT_X8R8G8B8`And different formats, each pixel occupies the number of bytes, so it is also necessary to need a ByteCount parameter to represent the number of percentage bytes. certainly `vector<Color_RGB>` We don't have to be used, changed to general`vector<uint8_t>`。

Re-adjust the StretchBITS function:

```cpp
void StretchBits(IDirect3DDevice9* device, const vector<uint8_t>& bits, int width, int height) {
	ComPtr<IDirect3DSurface9> surface;
	device->GetBackBuffer(0, 0, D3DBACKBUFFER_TYPE_MONO, surface.GetAddressOf());

	D3DLOCKED_RECT lockRect;
	surface->LockRect(&lockRect, NULL, D3DLOCK_DISCARD);

	memcpy(lockRect.pBits, &bits[0], bits.size());

	surface->UnlockRect();

	device->Present(NULL, NULL, NULL, NULL);
}
```

Here is to write the screen data, then call the present, will be displayed in the window.

Finally adjust some of the main function:

```cpp
// ...

vector<uint8_t> buffer(width * height * 4);

 Auto window = CreateWindow (ClassName, L "Hello World Title", WS_OVERLAPPEDWINDOW, 0, 0, DECODERPARM.WIDTH, DECODERPARAM.HEIGHT, NULL, NULL, HINSTANCE, NULL
// ...

AVFrame* frame = RequestFrame(decoderParam);

GetRGBPixels(frame, buffer, AVPixelFormat::AV_PIX_FMT_BGRA, 4);

av_frame_free(&frame);

double framerate = (double)vcodecCtx->framerate.den / vcodecCtx->framerate.num;
std::this_thread::sleep_until(currentTime + milliseconds((int)(framerate * 1000)));
currentTime = system_clock::now();

StretchBits(d3d9Device.Get(), buffer, width, height);
// ...
```

Note that the size of the buffer changes.`GetRGBPixels` Parameter needs to be used`AV_PIX_FMT_BGRA`，`StretchBits` Change to pass to the D3D9 device pointer.

Run the program, it looks like a difference, but in fact, the CPU occupied at this time will be slightly reduced, while GPUs will increase.

![image](https://programmerall.com/images/97/1d/1dcde753f863d14becc5d5d582265ac9.png)

## Say goodbye SWS\_SCALE

First adjust the window to the border, which looks more cool, and makes the proportion of the picture normal:

```cpp
// ...

 Auto window = CreateWindow (ClassName, L "Hello World Title", WS_POPUP, 100, 100, 1280, 720, NULL, NULL, HINSTANCE, NULL)
// ...
```

![image](https://programmerall.com/images/332/24/24bd7971b8723b19a933a87c46ce24fc.png)

I used to mention that hardly explained Avframe didn't have original picture information, but we went to see its format value, it will find that the corresponding is`AV_PIX_FMT_DXVA2_VLD`：

![image](https://programmerall.com/images/846/c9/c908fe8a3d0c4ce8ca55cacc88c354a6.png)

In the comment: Data \[3\] is a`LPDIRECT3DSURFACE9`That is`IDirect3DSurface9*`, Then we can present this Surface directly to the window, no need to copy the picture data from the GPU to the memory,`sws_scale` You can also throw it.

We write a new function`RenderHWFrame` Do this,`StretchBits` with `GetRGBPixels` No need:

```cpp
void RenderHWFrame(HWND hwnd, AVFrame* frame) {
	IDirect3DSurface9* surface = (IDirect3DSurface9*)frame->data[3];
	IDirect3DDevice9* device;
	surface->GetDevice(&device);

	ComPtr<IDirect3DSurface9> backSurface;
	device->GetBackBuffer(0, 0, D3DBACKBUFFER_TYPE_MONO, backSurface.GetAddressOf());

	device->StretchRect(surface, NULL, backSurface.Get(), NULL, D3DTEXF_LINEAR);

	device->Present(NULL, NULL, hwnd, NULL);
}

int WINAPI WinMain (
	_In_ HINSTANCE hInstance,
	_In_opt_ HINSTANCE hPrevInstance,
	_In_ LPSTR lpCmdLine,
	_In_ int nShowCmd
) {
// ...

AVFrame* frame = RequestFrame(decoderParam);

double framerate = (double)vcodecCtx->framerate.den / vcodecCtx->framerate.num;
std::this_thread::sleep_until(currentTime + milliseconds((int)(framerate * 1000)));
currentTime = system_clock::now();

RenderHWFrame(window, frame);

av_frame_free(&frame);
// ...
```

Sharing resources between different D3D9 devices are more troublesome, so we get directly to the D3D9 device created by FFmepg, then call Present to specify the window handle, allow the screen to appear in our own window.

![image](https://programmerall.com/images/398/e9/e92264e9eb1e81f3d1ecef717d2d3d26.png)

The foothold of this CPU is really low to ignore it. However, there was a new problem at this time, carefully observed the screen, and it will find that the picture is blurred. The reason is that we directly use the FFMPEG's D3D9 device to create a switched chain, this switching chain is quite low, only 640x480 , I will know if he looks at his source code.[hwcontext\_dxva2.c:46](https://github.com/FFmpeg/FFmpeg/blob/master/libavutil/hwcontext_dxva2.c#L46)）

![image](https://programmerall.com/images/541/d1/d1e883d9ed1a2c8289ddcfea5df88d6d.png)

So we need to create your own exchange with FFmPEG's D3D9 device:

```cpp
void RenderHWFrame(HWND hwnd, AVFrame* frame) {
	IDirect3DSurface9* surface = (IDirect3DSurface9*)frame->data[3];
	IDirect3DDevice9* device;
	surface->GetDevice(&device);

	static ComPtr<IDirect3DSwapChain9> mySwap;
	if (mySwap == nullptr) {
		D3DPRESENT_PARAMETERS params = {};
		params.Windowed = TRUE;
		params.hDeviceWindow = hwnd;
		params.BackBufferFormat = D3DFORMAT::D3DFMT_X8R8G8B8;
		params.BackBufferWidth = frame->width;
		params.BackBufferHeight = frame->height;
		params.SwapEffect = D3DSWAPEFFECT_DISCARD;
		params.BackBufferCount = 1;
		params.Flags = 0;
		device->CreateAdditionalSwapChain(&params, mySwap.GetAddressOf());
	}

	ComPtr<IDirect3DSurface9> backSurface;
	mySwap->GetBackBuffer(0, D3DBACKBUFFER_TYPE_MONO, backSurface.GetAddressOf());

	device->StretchRect(surface, NULL, backSurface.Get(), NULL, D3DTEXF_LINEAR);

	mySwap->Present(NULL, NULL, NULL, NULL, NULL);
}
```

A D3DDevice is available, using multiple switched chains.`CreateAdditionalSwapChain` The function can be created, and then, like the previous, the Surface that is hardly explained is copied to the new switching chain.

![image](https://programmerall.com/images/958/da/da29c7b8b049e23cee66c839de22504e.png)

Now there is no pressure even if the video of 4K60FPS is played.

## currently existing problems

1.  If your screen refresh rate is 60Hz, when the program is playing 60 frames, the speed is slower than normal, the reason is`IDirect3DSwapChain9::Present` It will force the screen to be synchronized vertically, so the presentation time will always be better than normal time.
2.  Without any operational control, it is also possible to suspend fast forward, etc.
3.  No sound.

We have left the second solvement.