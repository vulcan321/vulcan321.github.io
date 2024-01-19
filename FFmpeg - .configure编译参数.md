## 1 FFmpge编译参数

本文对FFmpeg4.4.1的`./configure`的所有编译参数进行了简要说明。在Linux系统上编译FFmpge时总是不太明白应该使用哪一些编译参数，这里以FFmpge4.4.1版本为例，对FFmpge的所有可选编译参数进行总结和整理。

### 1.1 Help options 帮助选项

| 参数 | 参数作用 |
| --- | --- |
| –help | 打印显示帮助信息 |
| –quiet | 禁止显示信息输出 |
| –list-decoders | 显示所有可用的解码器 |
| –list-encoders | 显示所有可用的编码器 |
| –list-hwaccels | 显示所有可用的硬件加速器 |
| –list-demuxers | 显示所有可用的解复用器 |
| –list-muxers | 显示所有可用的复用器 |
| –list-parsers | 显示所有可用的解析器 |
| –list-protocols | 显示所有可用的协议 |
| –list-bsfs | 显示所有可用的比特流过滤器 |
| –list-indevs | 显示所有可用的输入设备 |
| –list-outdevs | 显示所有可用的输出设备 |
| –list-filters | 显示所有可用的过滤器 |

### 1.2 Standard options 标准选项

| 参数 | 参数作用 |
| --- | --- |
| –logfile=FILE | 记录测试并输出到 指定文件FILE ，默认为ffbuild/config.log |
| –disable-logging | 不记录配置调试信息 |
| –fatal-warnings | 如果生成任何配置警告，则失败 |
| –prefix=PREFIX | 安装在指定路径PREFIX，默认为/usr/local |
| –bindir=DIR | 在指定路径DIR 中安装二进制文件，默认为PREFIX/bin |
| –datadir=DIR | 在指定路径DIR中安装数据文件，默认为PREFIX/share/ffmpeg |
| –docdir=DIR | 在指定路径DIR中安装文档，默认为PREFIX/share/doc/ffmpeg |
| –libdir=DIR | 在指定路径安装库，默认为PREFIX/lib |
| –shlibdir=DIR | 在指定路径安装共享库，默认为LIBDIR，即PREFIX/lib |
| –incdir=DIR | 在指定路径安装包含文件，默认为PREFIX/include |
| –mandir=DIR | 在指定路径安装手册页，默认为PREFIX/share/man |
| –pkgconfigdir=DIR | 在指定路径安装pkg-config 文件，默认为LIBDIR/pkgconfig |
| –enable-rpath | 使用rpath允许在不属于动态链接器搜索路径的路径中安装库链接程序时使用rpath（小心使用） |
| –install-name-dir=DIR | Darwin 已安装目标的目录名称 |

### 1.3 Licensing options 证书选项

| 参数 | 参数作用 |
| --- | --- |
| –enable-gpl | 允许使用GPL代码，编译的库和二进制文件处于GPL许可下，默认为否 |
| –enable-version3 | 升级(L)GPL到版本3，默认为否 |
| –enable-nonfree | 允许使用非自由代码，并且二进制文件将不可再分发，默认为否 |

### 1.4 Configuration options 配置选项

| 参数 | 参数作用 |
| --- | --- |
| –disable-static | 不构建静态库，默认为否 |
| –enable-shared | 构建共享动态库，默认为否 |
| –enable-small | 优化大小而不是速度 |
| –disable-runtime-cpudetect | 禁用在运行时检测 CPU 功能（较小的二进制文件） |
| –enable-gray | 启用全灰度支持（较慢的颜色） |
| –disable-swscale-alpha | 在 swscale 中禁用 alpha 通道支持 |
| –disable-all | 禁用构建组件、库和程序 |
| –disable-autodetect | 禁用自动检测到的外部库，默认为否 |

### 1.5 Program options 程序选项

| 参数 | 参数作用 |
| --- | --- |
| –disable-programs | 不构建命令行程序 |
| –disable-ffmpeg | 禁用 ffmpeg 构建 |
| –disable-ffplay | 禁用 ffplay 构建 |
| –disable-ffprobe | 禁用 ffprobe 构建 |

### 1.6 Documentation options 文档选项

| 参数 | 参数作用 |
| --- | --- |
| –disable-doc | 不构建文档 |
| –disable-htmlpages | 不构建 HTML 文档页面 |
| –disable-manpages | 不构建手册文档页面 |
| –disable-podpages | 不构建 POD 文档页面 |
| –disable-txtpages | 不构建文本文档页面 |

### 1.7 Component options 组件选项

| 参数 | 参数作用 |
| --- | --- |
| –disable-avdevice | 禁用 libavdevice 构建 |
| –disable-avcodec | 禁用 libavcodec 构建 |
| –disable-avformat | 禁用 libavformat 构建 |
| –disable-swresample | 禁用 libswresample 构建 |
| –disable-swscale | 禁用 libswscale 构建 |
| –disable-postproc | 禁用 libpostproc 构建 |
| –disable-avfilter | 禁用 libavfilter 构建 |
| –enable-avresample | 启用 libavresample 构建（已弃用），默认为否 |
| –disable-pthreads | 禁用 pthreads \[自动检测\] |
| –disable-w32threads | 禁用 Win32 线程 \[自动检测\] |
| –disable-os2threads | 禁用 OS/2 线程 \[自动检测\] |
| –disable-network | 禁用网络支持 ，默认为否 |
| –disable-dct | 禁用 DCT 代码 |
| –disable-dwt | 禁用 DWT 代码 |
| –disable-error-resilience | 禁用错误恢复代码 |
| –disable-lsp | 禁用 LSP 代码 |
| –disable-lzo | 禁用 LZO 解码器代码 |
| –disable-mdct | 禁用 MDCT 代码 |
| –disable-rdft | 禁用 RDFT 代码 |
| –disable-fft | 禁用 FFT 代码 |
| –disable-faan | 禁用浮点 AAN (I)DCT 代码 |
| –disable-pixelutils | 在 libavutil 中禁用像素工具 |

### 1.8 Individual component options 独立组件选项

| 参数 | 参数作用 |
| --- | --- |
| –disable-everything | 禁用下面列出的所有组件 |
| –disable-encoder=NAME | 禁用指定NAME的编码器 |
| –enable-encoder=NAME | 启用指定NAME的编码器 |
| –disable-encoders | 禁用所有编码器 |
| –disable-decoder=NAME | 禁用指定NAME的解码器 |
| –enable-decoder=NAME | 启用指定NAME的解码器 |
| –disable-decoders | 禁用所有解码器 |
| –disable-hwaccel=NAME | 禁用指定NAME的硬件 |
| –enable-hwaccel=NAME | 启用指定NAME的硬件 |
| –disable-hwaccels | 禁用所有 hwaccels |
| –disable-muxer=NAME | 禁用指定NAME的复用器 |
| –enable-muxer=NAME | 启用指定NAME的复用器 |
| –disable-muxers | 禁用所有复用器 |
| –disable-demuxer=NAME | 禁用指定NAME的解复用器 |
| –enable-demuxer=NAME | 启用指定NAME的解复用器 |
| –disable-demuxers | 禁用所有解复用器 |
| –enable-parser=NAME | 启用指定NAME的解析器 |
| –disable-parser=NAME | 禁用指定NAME的解析器 |
| –disable-parsers | 禁用所有解析器 |
| –enable-bsf=NAME | 启用指定NAME的比特流过滤器 |
| –disable-bsf=NAME | 禁用指定NAME的比特流过滤器 |
| –disable-bsfs | 禁用所有比特流过滤器 |
| –enable-protocol=NAME | 启用指定NAME协议 |
| –disable-protocol=NAME | 禁用指定NAME协议 |
| –disable-protocols | 禁用所有协议 |
| –enable-indev=NAME | 启用指定NAME的输入设备 |
| –disable-indev=NAME | 禁用指定NAME的输入设备 |
| –disable-indevs | 禁用输入设备 |
| –enable-outdev=NAME | 启用指定NAME的输出设备 |
| –disable-outdev=NAME | 禁用指定NAME的输出设备 |
| –disable-outdevs | 禁用输出设备 |
| –disable-devices | 禁用所有设备 |
| –enable-filter=NAME | 启用指定NAME的过滤器名称 |
| –disable-filter=NAME | 禁用指定NAME的过滤器名称 |
| –disable-filters | 禁用所有过滤器 |

### 1.9 External library support 扩展库支持

使用以下任何选项将允许 FFmpeg 链接到相应的外部库。 如果满足所有其他依赖项并且未明确禁用它们，则依赖于该库的所有组件都将启用。 例如。 --enable-libopus 将启用与 libopus 的链接并允许构建 libopus 编码器，除非使用 --disable-encoder=libopus 明确禁用它。

请注意，只有系统库会被自动检测。 所有其他外部库必须显式启用。

另请注意，以下帮助文本描述了库本身的用途，并非它们的所有功能都必须由 FFmpeg 使用。

| 参数 | 参数作用 |
| --- | --- |
| –disable-alsa | 禁用 ALSA 支持 \[自动检测\] |
| –disable-appkit | 禁用 Apple AppKit 框架 \[自动检测\] |
| –disable-avfoundation | 禁用 Apple AVFoundation 框架 \[自动检测\] |
| –enable-avisynth | 启用读取 AviSynth 脚本文件 \[否\] |
| –disable-bzlib | 禁用 bzlib \[自动检测\] |
| –disable-coreimage | 禁用 Apple CoreImage 框架 \[自动检测\] |
| –enable-chromaprint | 使用 chromaprint 启用音频指纹识别，默认为否 |
| –enable-frei0r | 启用 frei0r 视频过滤 ，默认为否 |
| –enable-gcrypt | 启用 gcrypt，需要 rtmp(t)e 支持，如果未使用 openssl、librtmp 或 gmp则默认为否 |
| –enable-gmp | 启用 gmp，需要 rtmp(t)e 支持，如果未使用 openssl 或 librtmp则默认为否 |
| –enable-gnutls | 启用 gnutls，需要 https 支持，如果未使用 openssl、libtls 或 mbedtls则默认为否 |
| –disable-iconv | 禁用 iconv \[自动检测\] |
| –enable-jni | 启用 JNI 支持，默认为否 |
| –enable-ladspa | 启用 LADSPA 音频过滤，默认为否 |
| –enable-libaom | 通过 libaom 启用 AV1 视频编码/解码，默认为否 |
| –enable-libaribb24 | 通过 libaribb24 启用 ARIB 文本和字幕解码，默认为否 |
| –enable-libass | 启用 libass 字幕渲染，需要字幕，默认为否 |
| –enable-libbluray | 使用 libbluray 启用蓝光阅读，默认为否 |
| –enable-libbs2b | 启用 bs2b DSP 库，默认为否 |
| –enable-libcaca | 使用 libcaca 启用文本显示，默认为否 |
| –enable-libcelt | 通过 libcelt 启用 CELT 解码，默认为否 |
| –enable-libcdio | 启用使用 libcdio 抓取音频 CD，默认为否 |
| –enable-libcodec2 | 使用 libcodec2 启用 codec2 编码/解码，默认为否 |
| –enable-libdav1d | 通过 libdav1d 启用 AV1 解码，默认为否 |
| –enable-libdavs2 | 通过 libdavs2 启用 AVS2 解码，默认为否 |
| –enable-libdc1394 | 使用 libdc1394和libraw1394启用IIDC-1394 抓取 |
| –enable-libfdk-aac | 通过 libfdk-aac 启用 AAC 解码/编码，默认为否 |
| –enable-libflite | 通过 libflite 启用 flite（语音合成）支持，默认为否 |
| –enable-libfontconfig | 启用 libfontconfig，对 drawtext 过滤器有用，默认为否 |
| –enable-libfreetype | 启用 libfreetype，drawtext 过滤器需要，默认为否 |
| –enable-libfribidi | 启用 libfribidi，改进 drawtext 过滤器，默认为否 |
| –enable-libglslang | 启用 GLSL->SPIRV 编译通过 libglslang，默认为否 |
| –enable-libgme | 通过 libgme 启用游戏音乐 Emu，默认为否 |
| –enable-libgsm | 通过 libgsm 启用 GSM 解码/编码，默认为否 |
| –enable-libiec61883 | 通过 libiec61883 启用 iec61883，默认为否 |
| –enable-libilbc | 通过 libilbc 启用 iLBC 解码/编码，默认为否 |
| –enable-libjack | 启用 JACK 音频声音服务器，默认为否 |
| –enable-libklvanc | 启用内核实验室 VANC 处理，默认为否 |
| –enable-libkvazaar | 通过 libkvazaar 启用 HEVC 编码，默认为否 |
| –enable-liblensfun | 启用 lensfun 镜头校正，默认为否 |
| –enable-libmodplug | 通过 libmodplug 启用 ModPlug，默认为否 |
| –enable-libmp3lame | 通过 libmp3lame 启用 MP3 编码，默认为否 |
| –enable-libopencore-amrnb | 通过 libopencore-amrnb 启用 AMR-NB 解码/编码，默认为否 |
| –enable-libopencore-amrwb | 通过 libopencore-amrwb 启用 AMR-WB 解码，默认为否 |
| –enable-libopencv | 通过 libopencv 启用视频过滤，默认为否 |
| –enable-libopenh264 | 通过 OpenH264 启用 H.264 编码，默认为否 |
| –enable-libopenjpeg | 通过 OpenJPEG 启用 JPEG 2000 解码/编码，默认为否 |
| –enable-libopenmpt | 启用通过 libopenmpt 解码跟踪的文件，默认为否 |
| –enable-libopenvino | 启用 OpenVINO 作为 DNN 模块后端，默认为否 |
| –enable-libopus | 通过 libopus 启用 Opus 解码/编码，默认为否 |
| –enable-libpulse | 通过 libpulse 启用 Pulseaudio 输入，默认为否 |
| –enable-librabbitmq | 启用 RabbitMQ 库，默认为否 |
| –enable-librav1e | 通过 rav1e 启用 AV1 编码，默认为否 |
| –enable-librist | 通过 librist 启用 RIST，默认为否 |
| –enable-librsvg | 通过 librsvg 启用 SVG 光栅化，默认为否 |
| –enable-librubberband | 启用橡皮筋过滤器所需的橡皮筋，默认为否 |
| –enable-librtmp | 通过 librtmp 启用 RTMP\[E\] 支持，默认为否 |
| –enable-libshine | 通过 libshine 启用定点 MP3 编码，默认为否 |
| –enable-libsmbclient | 通过 libsmbclient 启用 Samba 协议，默认为否 |
| –enable-libsnappy | 启用 Snappy 压缩，需要 hap 编码，默认为否 |
| –enable-libsoxr | 启用libsoxr 重采样，默认为否 |
| –enable-libspeex | 通过 libspeex 启用 Speex 解码/编码，默认为否 |
| –enable-libsrt | 通过 libsrt 启用 Haivision SRT 协议，默认为否 |
| –enable-libssh | 通过 libssh 启用 SFTP 协议，默认为否 |
| –enable-libsvtav1 | 通过 SVT 启用 AV1 编码，默认为否 |
| –enable-libtensorflow | 启用TensorFlow作为基于DNN的过滤器的DNN模块后端，默认为否 |
| –enable-libtesseract | 启用 Tesseract，ocr 过滤器需要，默认为否 |
| –enable-libtheora | 通过 libtheora 启用 Theora 编码，默认为否 |
| –enable-libtls | 如果未使用openssl、gnutls或mbedtls，则启用https支持所需的LibreSSL，默认为否 |
| –enable-libtwolame | 通过 libttwolame 启用 MP2 编码，默认为否 |
| –enable-libuavs3d | 通过 libuavs3d 启用 AVS3 解码，默认为否 |
| –enable-libv4l2 | 启用 libv4l2/v4l-utils，默认为否 |
| –enable-libvidstab | 使用 vid.stab 启用视频稳定，默认为否 |
| –enable-libvmaf | 通过 libvmaf 启用 vmaf 过滤器，默认为否 |
| –enable-libvo-amrwbenc | 通过 libvo-amrwbenc 启用 AMR-WB 编码，默认为否 |
| –enable-libvorbis | 通过 libvorbis 启用 Vorbis 编码/解码，默认为否 |
| –enable-libvpx | 通过 libvpx 启用 VP8 和 VP9 解码/编码，默认为否 |
| –enable-libwebp | 通过 libwebp 启用 WebP 编码，默认为否 |
| –enable-libx264 | 通过 x264 启用 H.264 编码，默认为否 |
| –enable-libx265 | 通过 x265 启用 HEVC 编码，默认为否 |
| –enable-libxavs | 通过 xavs 启用 AVS 编码，默认为否 |
| –enable-libxavs2 | 通过 xavs2 启用 AVS2 编码，默认为否 |
| –enable-libxcb | 使用 XCB 启用 X11 抓取 \[自动检测\] |
| –enable-libxcb-shm | 启用 X11 抓取 shm 通信 \[自动检测\] |
| –enable-libxcb-xfixes | 启用 X11 抓取鼠标渲染 \[自动检测\] |
| –enable-libxcb-shape | 启用 X11 抓取形状渲染 \[自动检测\] |
| –enable-libxvid | 通过 xvidcore 启用 Xvid 编码，存在原生 MPEG-4/Xvid 编码器，默认为否 |
| –enable-libxml2 | 使用 C 库 libxml2 启用 XML 解析，默认为否 |
| –enable-libzimg | 启用 z.lib，zscale 过滤器需要，默认为否 |
| –enable-libzmq | 启用通过 libzmq 传递消息，默认为否 |
| –enable-libzvbi | 通过 libzvbi 启用图文电视支持，默认为否 |
| –enable-lv2 | 启用 LV2 音频过滤，默认为否 |
| –disable-lzma | 禁用 lzma \[自动检测\] |
| –enable-decklink | 启用 Blackmagic DeckLink I/O 支持，默认为否 |
| –enable-mbedtls | 如果未使用openssl、gnutls或libtls，则启用https支持所需的mbedTLS，默认为否 |
| –enable-mediacodec | 启用 Android MediaCodec 支持，默认为否 |
| –enable-mediafoundation | 通过 MediaFoundation 启用编码 |
| –enable-libmysofa | 启用 libmysofa，需要 soflizer 过滤器，默认为否 |
| –enable-openal | 启用 OpenAL 1.1 捕获支持，默认为否 |
| –enable-opencl | 启用 OpenCL 处理，默认为否 |
| –enable-opengl | 启用 OpenGL 渲染，默认为否 |
| –enable-openssl | 如果未使用gnutls、libtls 或 mbedtls，则启用https支持所需的openssl，默认为否 |
| –enable-pocketsphinx | 启用 PocketSphinx，asr 过滤器需要，默认为否 |
| –disable-sndio | 禁用 sndio 支持 \[自动检测\] |
| –disable-schannel | 禁用 SChannel SSP，需要 TLS 支持\[自动检测\] |
| –disable-sdl2 | 禁用 sdl2 \[自动检测\] |
| –disable-securetransport | 禁用安全传输，需要 TLS 支持 |
| –enable-vapoursynth | 启用 VapourSynth 解复用器，默认为否 |
| –enable-vulkan | 启用 Vulkan 代码，默认为否 |
| –disable-xlib | 禁用 xlib \[自动检测\] |
| –disable-zlib | 禁用 zlib \[自动检测\] |

以下库提供各种硬件加速功能：

| 参数 | 参数作用 |
| --- | --- |
| –disable-amf | 禁用 AMF 视频编码代码 \[自动检测\] |
| –disable-audiotoolbox | 禁用 Apple AudioToolbox 代码 \[自动检测\] |
| –enable-cuda-nvcc | 启用 Nvidia CUDA 编译器，默认为否 |
| –disable-cuda-llvm | 使用 clang， 禁用 CUDA 编译\[自动检测\] |
| –disable-cuvid | 禁用 Nvidia CUVID 支持 \[自动检测\] |
| –disable-d3d11va | 禁用 Microsoft Direct3D 11 视频加速代码 \[自动检测\] |
| –disable-dxva2 | 禁用 Microsoft DirectX 9 视频加速代码 \[自动检测\] |
| –disable-ffnvcodec | 禁用动态链接的 Nvidia 代码 \[自动检测\] |
| –enable-libdrm | 启用 DRM 代码 (Linux)，默认为否 |
| –enable-libmfx | 通过 libmfx 启用英特尔 MediaSDK（AKA 快速同步视频）代码，默认为否 |
| –enable-libnpp | 启用基于 Nvidia Performance Primitives 的代码，默认为否 |
| –enable-mmal | 通过 MMAL 启用 Broadcom 多媒体抽象层 (Raspberry Pi) ，默认为否 |
| –disable-nvdec | 禁用 Nvidia 视频解码加速（通过 hwaccel）\[自动检测\] |
| –disable-nvenc | 禁用 Nvidia 视频编码代码 \[自动检测\] |
| –enable-omx | 启用 OpenMAX IL 代码，默认为否 |
| –enable-omx-rpi | 为 Raspberry Pi 启用 OpenMAX IL 代码 ，默认为否 |
| –enable-rkmpp | 启用瑞芯微媒体处理平台代码 ，默认为否 |
| –disable-v4l2-m2m | 禁用 V4L2 mem2mem 代码 \[自动检测\] |
| –disable-vaapi | 禁用视频加速 API（主要是 Unix/Intel）代码 \[自动检测\] |
| –disable-vdpau | 禁用适用于 Unix 代码的 Nvidia Video Decode 和 Presentation API \[自动检测\] |
| –disable-videotoolbox | 禁用 VideoToolbox 代码 \[自动检测\] |

### 1.10 Toolchain options 工具链选项

| 参数 | 参数作用 |
| --- | --- |
| –arch=ARCH | 选择架构 |
| –cpu=CPU | 选择所需的最小CPU（影响指令选择，可能会在较旧的 CPU 上崩溃） |
| –cross-prefix=PREFIX | 编译工具使用 PREFIX |
| –progs-suffix=SUFFIX | 程序名后缀 |
| –enable-cross-compile | 假设使用了交叉编译器 |
| –sysroot=PATH | 交叉构建树的根 |
| –sysinclude=PATH | 交叉构建系统头文件的位置 |
| –target-os=OS | 编译器目标 OS |
| –target-exec=CMD | 目标上运行可执行文件的命令 |
| –target-path=DIR | 在目标上查看构建目录的路径 |
| –target-samples=DIR | 目标样本目录的路径 |
| –tempprefix=PATH | 强制固定目录/前缀而不是 mktemp 进行检查 |
| –toolchain=NAME | 根据 NAME 设置工具默认值 |
| –nm=NM | 使用 nm 工具 NM \[nm -g\] |
| –ar=AR | 使用存档工具 AR \[ar\] |
| –as=AS | 使用汇编器 AS |
| –ln\_s=LN\_S | 使用符号链接工具 LN\_S \[ln -s -f\] |
| –strip=STRIP | 使用剥离工具STRIP \[strip\] |
| –windres=WINDRES | 使用windows资源编译器WINDRES \[windres\] |
| –x86asmexe=EXE | 使用 nasm 兼容的汇编程序 EXE \[nasm\] |
| –cc=CC | 使用 C 编译器 CC \[gcc\] |
| –cxx=CXX | 使用 C 编译器 CXX \[g++\] |
| –objcc=OCC | 使用 ObjC 编译器 OCC \[gcc\] |
| –dep-cc=DEPCC | 使用依赖生成器 DEPCC \[gcc\] |
| –nvcc=NVCC | 使用 Nvidia CUDA 编译器 NVCC 或 clang |
| –ld=LD | 使用链接器 LD |
| –pkg-config=PKGCONFIG | 使用 pkg-config 工具 PKGCONFIG \[pkg-config\] |
| –pkg-config-flags=FLAGS | 将附加标志传递给 pkgconf |
| –ranlib=RANLIB | 使用ranlib RANLIB |
| –doxygen=DOXYGEN | 使用 DOXYGEN 生成 API doc \[doxygen\] |
| –host-cc=HOSTCC | 使用主机 C 编译器 HOSTCC |
| –host-cflags=HCFLAGS | 在为主机编译时使用 HCFLAGS |
| –host-cppflags=HCPPFLAGS | 在为主机编译时使用 HCPPFLAGS |
| –host-ld=HOSTLD | 使用主机链接器 HOSTLD |
| –host-ldflags=HLDFLAGS | 链接主机时使用 HLDFLAGS |
| –host-extralibs=HLIBS | 链接主机时使用库 HLIBS |
| –host-os=OS | 编译器主机操作系统 |
| –extra-cflags=ECFLAGS | 将 ECFLAGS 添加到 CFLAGS |
| –extra-cxxflags=ECFLAGS | 将 ECFLAGS 添加到 CXXFLAGS |
| –extra-objcflags=FLAGS | 将 FLAGS 添加到 OBJCFLAGS |
| –extra-ldflags=ELDFLAGS | 将 ELDFLAGS 添加到 LDFLAGS |
| –extra-ldexeflags=ELDFLAGS | 将 ELDFLAGS 添加到 LDEXEFLAGS |
| –extra-ldsoflags=ELDFLAGS | 将 ELDFLAGS 添加到 LDSOFLAGS |
| –extra-libs=ELIBS | 添加 ELIBS |
| –extra-version=STRING | 版本字符串后缀 |
| –optflags=OPTFLAGS | 覆盖优化相关的编译器标志 |
| –nvccflags=NVCCFLAGS | 覆盖 nvcc 标志 |
| –build-suffix=SUFFIX | 库名后缀 |
| –enable-pic | 构建与位置无关的代码 |
| –enable-thumb | 编译 Thumb 指令集 |
| –enable-l | 使用链接时优化 |
| –env=“ENV=override” | 覆盖环境变量 |

### 1.11 Advanced options 高级选项

| 参数 | 参数作用 |
| --- | --- |
| –malloc-prefix=PREFIX | 前缀 malloc 和带有 PREFIX 的相关名称 |
| –custom-allocator=NAME | 使用支持的自定义分配器 |
| –disable-symver | 禁用符号版本控制 |
| –enable-hardcoded-tables | 使用硬编码表而不是运行时生成 |
| –disable-safe-bitstream-reader | 在位读取器中禁用缓冲区边界检查（更快，但可能会崩溃） |
| –sws-max-filter-size=N swscale | 使用的最大过滤器大小 ，默认为256 |

### 1.12 Optimization options 优化选项

| 参数 | 参数作用 |
| --- | --- |
| –disable-asm | 禁用所有程序集优化 |
| –disable-altivec | 禁用 AltiVec 优化 |
| –disable-vsx | 禁用 VSX 优化 |
| –disable-power8 | 禁用 POWER8 优化 |
| –disable-amd3dnow | 禁用 3DNow！优化 |
| –disable-amd3dnowext | 禁用 3DNow！扩展优化 |
| –disable-mmx | 禁用 MMX 优化 |
| –disable-mmxext | 禁用 MMXEXT 优化 |
| –disable-sse | 禁用 SSE 优化 |
| –disable-sse2 | 禁用 SSE2 优化 |
| –disable-sse3 | 禁用 SSE3 优化 |
| –disable-ssse3 | 禁用 SSSE3 优化 |
| –disable-sse4 | 禁用 SSE4 优化 |
| –disable-sse42 | 禁用 SSE4.2 优化 |
| –disable-avx | 禁用 AVX 优化 |
| –disable-xop | 禁用 XOP 优化 |
| –disable-fma3 | 禁用 FMA3 优化 |
| –disable-fma4 | 禁用 FMA4 优化 |
| –disable-avx2 | 禁用 AVX2 优化 |
| –disable-avx512 | 禁用 AVX-512 优化 |
| –disable-aesni | 禁用 AESNI 优化 |
| –disable-armv5te | 禁用 armv5te 优化 |
| –disable-armv6 | 禁用 armv6 优化 |
| –disable-armv6t2 | 禁用 armv6t2 优化 |
| –disable-vfp | 禁用 VFP 优化 |
| –disable-neon | 禁用 NEON 优化 |
| –disable-inline-asm | 禁用内联汇编 |
| –disable-x86asm | 禁用独立 x86 程序集 |
| –disable-mipsdsp | 禁用 MIPS DSP ASE R1 优化 |
| –disable-mipsdspr2 | 禁用 MIPS DSP ASE R2 优化 |
| –disable-msa | 禁用 MSA 优化 |
| –disable-msa2 | 禁用 MSA2 优化 |
| –disable-mipsfpu | 禁用浮点 MIPS 优化 |
| –disable-mmi | 禁用龙芯 SIMD 优化 |
| –disable-fast-unaligned | 考虑未对齐访问缓慢 |

### 1.13 开发人员选项

| 参数 | 参数作用 |
| --- | --- |
| –disable-debug | 禁用调试符号 |
| –enable-debug=LEVEL | 设置调试级别 |
| –disable-optimizations | 禁用编译器优化 |
| –enable-extra-warnings | 启用更多编译器警告 |
| –disable-stripping | 禁用剥离可执行文件和共享库 |
| –assert-level=level | 0（默认），1或2，断言测试的数量，2 会导致运行时变慢 |
| –enable-memory-poisoning | 用任意数据填充堆未初始化的分配空间 |
| –valgrind=VALGRIND | 通过 valgrind 运行“make fate”测试以检测内存泄漏和错误，使用指定的 valgrind 二进制文件。不能与 --target-exec 结合使用 |
| –enable-ftrapv | 陷阱算术溢出 |
| –samples=FATE | 测试样本的路径位置 |
| –enable-neon-clobber-test | 检查 NEON 寄存器的破坏（应该是仅用于调试目的） |
| –enable-xmm-clobber-test | 检查 XMM 寄存器的破坏（仅限 Win64；应仅用于调试目的） |
| –enable-random | 随机启用/禁用组件 |
| –enable-random=LIST | 随机启用/禁用特定组件，LIST 是一个逗号分隔的列表 NAME\[:PROB\] 条目，其中 NAME 是一个组件(group) 和 PROB 相关的概率 名称（默认 0.5）。 |
| –random-seed=VALUE | –enable/disable-random 的种子值 |
| –disable-valgrind-backtrace | 在 Valgrind 下不打印回溯（仅适用于 --disable-optimizations 构建） |
| –enable-ossfuzz | 启用构建模糊器工具 |
| –libfuzzer=PATH | libfuzzer 的路径 |
| –ignore-tests=TESTS | 被忽略的测试 |
| –enable-linux-perf | 启用 Linux 性能监视器 API |
| –disable-large-tests | 禁用使用大量内存的测试 |