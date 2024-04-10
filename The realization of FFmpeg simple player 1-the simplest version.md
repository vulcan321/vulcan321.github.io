## The realization of FFmpeg simple player 1-the simplest version

tags: [ffmpeg](https://programmerall.com/tag/ffmpeg/ "ffmpeg")  [Audio and video development](https://programmerall.com/tag/Audio+and+video+development/ "Audio and video development")  [ffplay](https://programmerall.com/tag/ffplay/ "ffplay")  

<iframe data-id="programmerall.com_750x280_in_content_DFP" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" topmargin="0" leftmargin="0" width="1" height="1" data-rendered="true"></iframe>(function () { var size='728x90|300x250', adunit = 'programmerall.com\_750x280\_in\_content\_DFP', childNetworkId = '22316101559', xmlhttp = new XMLHttpRequest();xmlhttp.onreadystatechange = function(){if(xmlhttp.readyState==4 && xmlhttp.status==200){var es = document.querySelectorAll("\[data-id='"+adunit+"'\]");var e = Array.from(es).filter(function(e) {return !e.hasAttribute("data-rendered")});if(e.length > 0){e.forEach(function(el){var iframe = el.contentWindow.document;iframe.open();iframe.write(xmlhttp.responseText);iframe.close();el.setAttribute('data-rendered', true)})}}};var child=childNetworkId.trim()?','+childNetworkId.trim():'';xmlhttp.open("GET", 'https://pubads.g.doubleclick.net/gampad/adx?iu=/147246189'+child+'/'+adunit+'&sz='+encodeURI(size)+'&t=Placement\_type%3Dserving&'+Date.now(), true);xmlhttp.send();})();

(function(v,d,o,ai){ai=d.createElement('script');ai.defer=true;ai.async=true;ai.src=v.location.protocol+o;d.head.appendChild(ai);})(window, document, '//a.vdo.ai/core/v-programmerall/vdo.ai.js');

This article is the author's original:[/article/3460657586/](https://programmerall.com/article/3460657586/),Please indicate the source

A simple video player based on FFmpeg and SDL is mainly divided into two parts: reading video file decoding and calling SDL playback.

This experiment only implements the simplest video playback process, without considering the details, without considering the audio. This experiment mainly refers to the following two articles:  
\[1\]. [The simplest video player ver2 based on FFMPEG+SDL (using SDL2.0)](https://blog.csdn.net/leixiaohua1020/article/details/38868499)  
\[2\]. [An ffmpeg and SDL Tutorial](https://blog.csdn.net/leixiaohua1020/article/details/38868499)

FFmpeg simple player series articles are as follows:  
\[1\]. [The realization of FFmpeg simple player 1-the simplest version](https://programmerall.com/article/3460657586/)  
\[2\]. [Realization of FFmpeg simple player 2-video playback](https://www.cnblogs.com/leisure_chn/p/10047035.html)  
\[3\]. [Realization of FFmpeg simple player 3-audio playback](https://www.cnblogs.com/leisure_chn/p/10068490.html)  
\[4\]. [Realization of FFmpeg simple player 4-audio and video playback](https://www.cnblogs.com/leisure_chn/p/10235926.html)  
\[5\]. [Realization of FFmpeg simple player 5-audio and video synchronization](https://www.cnblogs.com/leisure_chn/p/10284653.html)

## 1\. Basic Principles of Video Players

The image below is quoted from "[Lei Xiaohua, Zero-Basic Learning Method of Video and Audio Coding and Decoding Technology](https://blog.csdn.net/leixiaohua1020/article/details/18893769)"Because the original picture is too small to see clearly, I made a new picture.  
![播放器基本原理示意图](https://programmerall.com/images/208/ed/ed862a8fa36bc3b2324b381d6e12e3e0.jpeg "播放器基本原理示意图")  
The following content is quoted from "[Lei Xiaohua, Zero-Basic Learning Method of Video and Audio Coding and Decoding Technology](https://blog.csdn.net/leixiaohua1020/article/details/18893769)”：

> **Solution agreement**  
> parses the streaming media protocol data into standard corresponding encapsulation format data. When video and audio are disseminated on the Internet, various streaming media protocols, such as HTTP, RTMP, or MMS, are often used. While these protocols transmit video and audio data, they also transmit some signaling data. These signaling data include control of playback (play, pause, stop), or description of network status, etc. In the process of de-agreement, the signaling data will be removed and only the video and audio data will be retained. For example, the data transmitted using the RTMP protocol will output FLV format data after de-protocol operation.
> 
> **Decapsulation**  
> Separate the input data in encapsulation format into audio stream compression coded data and video stream compression coded data. There are many types of encapsulation formats, such as MP4, MKV, RMVB, TS, FLV, AVI, etc. Its function is to put the compressed and encoded video data and audio data together in a certain format. For example, FLV format data, after decapsulation operation, output H.264 coded video code stream and AAC coded audio code stream.
> 
> **decoding**  
> The video/audio compression coded data is decoded into uncompressed video/audio raw data. Audio compression coding standards include AAC, MP3, AC-3, etc., video compression coding standards include H.264, MPEG2, VC-1, and so on. Decoding is the most important and most complex link in the entire system. Through decoding, the compressed and encoded video data is output as uncompressed color data, such as YUV420P, RGB, etc.; the compressed and encoded audio data is output as uncompressed audio sample data, such as PCM data.
> 
> **Audio and video synchronization**  
> According to the parameter information obtained during the processing of the decapsulation module, the decoded video and audio data are synchronized, and the video and audio data are sent to the graphics card and sound card of the system for playback.

## 2\. Realization of the simplest player

### 2.1 Experimental platform

```
<span class="hljs-attribute">Experimental</span> platform: openSUSE Leap <span class="hljs-number">42</span>.<span class="hljs-number">3</span>  
 <span class="hljs-attribute">FFmpeg</span> version: <span class="hljs-number">4</span>.<span class="hljs-number">1</span>  
 <span class="hljs-attribute">SDL</span> version: <span class="hljs-number">2</span>.<span class="hljs-number">0</span>.<span class="hljs-number">9</span>  
```

FFmpeg development environment construction can refer to "[FFmpeg development environment construction](https://www.cnblogs.com/leisure_chn/p/10035365.html)”

### 2.2 Source code list

```
<span class="hljs-comment">/*****************************************************************
 * ffplayer.c
 *
 * history:
 *   2018-11-27 - [lei]     created file
 *
 * details:
 *   A simple ffmpeg player.
 *
 * refrence:
 *   1. https://blog.csdn.net/leixiaohua1020/article/details/38868499
 *   2. http://dranger.com/ffmpeg/ffmpegtutorial_all.html#tutorial01.html
 *   3. http://dranger.com/ffmpeg/ffmpegtutorial_all.html#tutorial02.html
******************************************************************/</span>

<span class="hljs-meta">#<span class="hljs-meta-keyword">include</span> <span class="hljs-meta-string">&lt;stdio.h&gt;</span></span>
<span class="hljs-meta">#<span class="hljs-meta-keyword">include</span> <span class="hljs-meta-string">&lt;libavcodec/avcodec.h&gt;</span></span>
<span class="hljs-meta">#<span class="hljs-meta-keyword">include</span> <span class="hljs-meta-string">&lt;libavformat/avformat.h&gt;</span></span>
<span class="hljs-meta">#<span class="hljs-meta-keyword">include</span> <span class="hljs-meta-string">&lt;libswscale/swscale.h&gt;</span></span>
<span class="hljs-meta">#<span class="hljs-meta-keyword">include</span> <span class="hljs-meta-string">&lt;SDL2/SDL.h&gt;</span></span>
<span class="hljs-meta">#<span class="hljs-meta-keyword">include</span> <span class="hljs-meta-string">&lt;SDL2/SDL_video.h&gt;</span></span>
<span class="hljs-meta">#<span class="hljs-meta-keyword">include</span> <span class="hljs-meta-string">&lt;SDL2/SDL_render.h&gt;</span></span>
<span class="hljs-meta">#<span class="hljs-meta-keyword">include</span> <span class="hljs-meta-string">&lt;SDL2/SDL_rect.h&gt;</span></span>

<span class="hljs-function"><span class="hljs-keyword">int</span> <span class="hljs-title">main</span><span class="hljs-params">(<span class="hljs-keyword">int</span> argc, <span class="hljs-keyword">char</span> *argv[])</span>
</span>{
    <span class="hljs-comment">// Initalizing these to NULL prevents segfaults!</span>
    AVFormatContext*    p_fmt_ctx = <span class="hljs-literal">NULL</span>;
    AVCodecContext*     p_codec_ctx = <span class="hljs-literal">NULL</span>;
    AVCodecParameters*  p_codec_par = <span class="hljs-literal">NULL</span>;
    AVCodec*            p_codec = <span class="hljs-literal">NULL</span>;
         AVFrame* p_frm_raw = <span class="hljs-literal">NULL</span>; <span class="hljs-comment">// Frame, the original frame is obtained by packet decoding</span>
         AVFrame* p_frm_yuv = <span class="hljs-literal">NULL</span>; <span class="hljs-comment">// Frame, obtained by color conversion of the original frame</span>
         AVPacket* p_packet = <span class="hljs-literal">NULL</span>; <span class="hljs-comment">// Packet, a piece of data read from the stream</span>
    <span class="hljs-class"><span class="hljs-keyword">struct</span> <span class="hljs-title">SwsContext</span>*  <span class="hljs-title">sws_ctx</span> =</span> <span class="hljs-literal">NULL</span>;
    <span class="hljs-keyword">int</span>                 buf_size;
    <span class="hljs-keyword">uint8_t</span>*            buffer = <span class="hljs-literal">NULL</span>;
    <span class="hljs-keyword">int</span>                 i;
    <span class="hljs-keyword">int</span>                 v_idx;
    <span class="hljs-keyword">int</span>                 ret;
    SDL_Window*         screen; 
    SDL_Renderer*       sdl_renderer;
    SDL_Texture*        sdl_texture;
    SDL_Rect            sdl_rect;

    <span class="hljs-keyword">if</span> (argc &lt; <span class="hljs-number">2</span>)
    {
        <span class="hljs-built_in">printf</span>(<span class="hljs-string">"Please provide a movie file\n"</span>);
        <span class="hljs-keyword">return</span> <span class="hljs-number">-1</span>;
    }

         <span class="hljs-comment">// Initialize libavformat (all formats), register all multiplexers/demultiplexers</span>
         <span class="hljs-comment">// av_register_all(); // has been declared as obsolete, just no longer use it</span>

         <span class="hljs-comment">// A1. Open the video file: read the file header and store the file format information in the "fmt context"</span>
    ret = avformat_open_input(&amp;p_fmt_ctx, argv[<span class="hljs-number">1</span>], <span class="hljs-literal">NULL</span>, <span class="hljs-literal">NULL</span>);
    <span class="hljs-keyword">if</span> (ret != <span class="hljs-number">0</span>)
    {
        <span class="hljs-built_in">printf</span>(<span class="hljs-string">"avformat_open_input() failed\n"</span>);
        <span class="hljs-keyword">return</span> <span class="hljs-number">-1</span>;
    }

         <span class="hljs-comment">// A2. Search for stream information: read a piece of video file data, try to decode, and fill in the obtained stream information into pFormatCtx-&gt;streams</span>
         <span class="hljs-comment">// p_fmt_ctx-&gt;streams is an array of pointers, the size of the array is pFormatCtx-&gt;nb_streams</span>
    ret = avformat_find_stream_info(p_fmt_ctx, <span class="hljs-literal">NULL</span>);
    <span class="hljs-keyword">if</span> (ret &lt; <span class="hljs-number">0</span>)
    {
        <span class="hljs-built_in">printf</span>(<span class="hljs-string">"avformat_find_stream_info() failed\n"</span>);
        <span class="hljs-keyword">return</span> <span class="hljs-number">-1</span>;
    }

         <span class="hljs-comment">// Print the file-related information on the standard error device</span>
    av_dump_format(p_fmt_ctx, <span class="hljs-number">0</span>, argv[<span class="hljs-number">1</span>], <span class="hljs-number">0</span>);

         <span class="hljs-comment">// A3. Find the first video stream</span>
    v_idx = <span class="hljs-number">-1</span>;
    <span class="hljs-keyword">for</span> (i=<span class="hljs-number">0</span>; i&lt;p_fmt_ctx-&gt;nb_streams; i++)
    {
        <span class="hljs-keyword">if</span> (p_fmt_ctx-&gt;streams[i]-&gt;codecpar-&gt;codec_type == AVMEDIA_TYPE_VIDEO)
        {
            v_idx = i;
            <span class="hljs-built_in">printf</span>(<span class="hljs-string">"Find a video stream, index %d\n"</span>, v_idx);
            <span class="hljs-keyword">break</span>;
        }
    }
    <span class="hljs-keyword">if</span> (v_idx == <span class="hljs-number">-1</span>)
    {
        <span class="hljs-built_in">printf</span>(<span class="hljs-string">"Cann't find a video stream\n"</span>);
        <span class="hljs-keyword">return</span> <span class="hljs-number">-1</span>;
    }

         <span class="hljs-comment">// A5. Build a decoder AVCodecContext for the video stream</span>

         <span class="hljs-comment">// A5.1 Get decoder parameters AVCodecParameters</span>
    p_codec_par = p_fmt_ctx-&gt;streams[v_idx]-&gt;codecpar;
         <span class="hljs-comment">// A5.2 Get decoder</span>
    p_codec = avcodec_find_decoder(p_codec_par-&gt;codec_id);
    <span class="hljs-keyword">if</span> (p_codec == <span class="hljs-literal">NULL</span>)
    {
        <span class="hljs-built_in">printf</span>(<span class="hljs-string">"Cann't find codec!\n"</span>);
        <span class="hljs-keyword">return</span> <span class="hljs-number">-1</span>;
    }
         <span class="hljs-comment">// A5.3 Build the decoder AVCodecContext</span>
         <span class="hljs-comment">// A5.3.1 p_codec_ctx initialization: allocate structure, use p_codec to initialize the corresponding member to the default value</span>
    p_codec_ctx = avcodec_alloc_context3(p_codec);

         <span class="hljs-comment">// A5.3.2 p_codec_ctx initialization: p_codec_par ==&gt; p_codec_ctx, initialize the corresponding members</span>
    ret = avcodec_parameters_to_context(p_codec_ctx, p_codec_par);
    <span class="hljs-keyword">if</span> (ret &lt; <span class="hljs-number">0</span>)
    {
        <span class="hljs-built_in">printf</span>(<span class="hljs-string">"avcodec_parameters_to_context() failed %d\n"</span>, ret);
        <span class="hljs-keyword">return</span> <span class="hljs-number">-1</span>;
    }

         <span class="hljs-comment">// A5.3.3 p_codec_ctx initialization: use p_codec to initialize p_codec_ctx, the initialization is complete</span>
    ret = avcodec_open2(p_codec_ctx, p_codec, <span class="hljs-literal">NULL</span>);
    <span class="hljs-keyword">if</span> (ret &lt; <span class="hljs-number">0</span>)
    {
        <span class="hljs-built_in">printf</span>(<span class="hljs-string">"avcodec_open2() failed %d\n"</span>, ret);
        <span class="hljs-keyword">return</span> <span class="hljs-number">-1</span>;
    }

         <span class="hljs-comment">// A6. Assign AVFrame</span>
         <span class="hljs-comment">// A6.1 allocate AVFrame structure, note that data buffer is not allocated (ie AVFrame.*data[])</span>
    p_frm_raw = av_frame_alloc();
    p_frm_yuv = av_frame_alloc();

         <span class="hljs-comment">// A6.2 Manually allocate a buffer for AVFrame.*data[] to store the target frame video data in sws_scale()</span>
         <span class="hljs-comment">// The data_buffer of p_frm_raw is allocated by av_read_frame(), so it does not need to be allocated manually</span>
         <span class="hljs-comment">// The data_buffer of p_frm_yuv has nowhere to be allocated, so it is manually allocated here</span>
    buf_size = av_image_get_buffer_size(AV_PIX_FMT_YUV420P, 
                                        p_codec_ctx-&gt;width, 
                                        p_codec_ctx-&gt;height, 
                                        <span class="hljs-number">1</span>
                                       );
         <span class="hljs-comment">// buffer will be used as the video data buffer of p_frm_yuv</span>
    buffer = (<span class="hljs-keyword">uint8_t</span> *)av_malloc(buf_size);
         <span class="hljs-comment">// Use the given parameters to set p_frm_yuv-&gt;data and p_frm_yuv-&gt;linesize</span>
    av_image_fill_arrays(p_frm_yuv-&gt;data,           <span class="hljs-comment">// dst data[]</span>
                         p_frm_yuv-&gt;linesize,       <span class="hljs-comment">// dst linesize[]</span>
                         buffer,                    <span class="hljs-comment">// src buffer</span>
                         AV_PIX_FMT_YUV420P,        <span class="hljs-comment">// pixel format</span>
                         p_codec_ctx-&gt;width,        <span class="hljs-comment">// width</span>
                         p_codec_ctx-&gt;height,       <span class="hljs-comment">// height</span>
                         <span class="hljs-number">1</span>                          <span class="hljs-comment">// align</span>
                        );

         <span class="hljs-comment">// A7. Initialize the SWS context for subsequent image conversion</span>
         <span class="hljs-comment">// The sixth parameter here uses the pixel format in FFmpeg. For comparison, refer to note B4</span>
         <span class="hljs-comment">// The pixel format AV_PIX_FMT_YUV420P in FFmpeg corresponds to the pixel format SDL_PIXELFORMAT_IYUV in SDL</span>
         <span class="hljs-comment">// If the decoded image is not supported by SDL, and without image conversion, SDL cannot display the image normally</span>
         <span class="hljs-comment">// If the decoded image can be supported by SDL, there is no need to perform image conversion</span>
         <span class="hljs-comment">// For the sake of coding simplicity, unified conversion to the format supported by SDL AV_PIX_FMT_YUV420P==&gt;SDL_PIXELFORMAT_IYUV</span>
    sws_ctx = sws_getContext(p_codec_ctx-&gt;width,    <span class="hljs-comment">// src width</span>
                             p_codec_ctx-&gt;height,   <span class="hljs-comment">// src height</span>
                             p_codec_ctx-&gt;pix_fmt,  <span class="hljs-comment">// src format</span>
                             p_codec_ctx-&gt;width,    <span class="hljs-comment">// dst width</span>
                             p_codec_ctx-&gt;height,   <span class="hljs-comment">// dst height</span>
                             AV_PIX_FMT_YUV420P,    <span class="hljs-comment">// dst format</span>
                             SWS_BICUBIC,           <span class="hljs-comment">// flags</span>
                             <span class="hljs-literal">NULL</span>,                  <span class="hljs-comment">// src filter</span>
                             <span class="hljs-literal">NULL</span>,                  <span class="hljs-comment">// dst filter</span>
                             <span class="hljs-literal">NULL</span>                   <span class="hljs-comment">// param</span>
                            );                 


         <span class="hljs-comment">// B1. Initialize the SDL subsystem: default (event processing, file IO, thread), video, audio, timer</span>
    <span class="hljs-keyword">if</span> (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO | SDL_INIT_TIMER))
    {  
        <span class="hljs-built_in">printf</span>(<span class="hljs-string">"SDL_Init() failed: %s\n"</span>, SDL_GetError()); 
        <span class="hljs-keyword">return</span> <span class="hljs-number">-1</span>;
    }
    
         <span class="hljs-comment">// B2. Create SDL window, SDL 2.0 supports multiple windows</span>
         <span class="hljs-comment">// SDL_Window is the video window that pops up after running the program, same as SDL_Surface in SDL 1.x</span>
    screen = SDL_CreateWindow(<span class="hljs-string">"Simplest ffmpeg player's Window"</span>, 
                                                             SDL_WINDOWPOS_UNDEFINED,<span class="hljs-comment">// Do not care about the window X coordinate</span>
                                                             SDL_WINDOWPOS_UNDEFINED,<span class="hljs-comment">// Do not care about the window Y coordinate</span>
                              p_codec_ctx-&gt;width, 
                              p_codec_ctx-&gt;height,
                              SDL_WINDOW_OPENGL
                             );

    <span class="hljs-keyword">if</span> (screen == <span class="hljs-literal">NULL</span>)
    {  
        <span class="hljs-built_in">printf</span>(<span class="hljs-string">"SDL_CreateWindow() failed: %s\n"</span>, SDL_GetError());  
        <span class="hljs-keyword">return</span> <span class="hljs-number">-1</span>;
    }

         <span class="hljs-comment">// B3. Create SDL_Renderer</span>
         <span class="hljs-comment">// SDL_Renderer: renderer</span>
    sdl_renderer = SDL_CreateRenderer(screen, <span class="hljs-number">-1</span>, <span class="hljs-number">0</span>);

         <span class="hljs-comment">// B4. Create SDL_Texture</span>
    <span class="hljs-comment">// One SDL_Texture corresponds to one frame of YUV data, same as SDL_Overlay in SDL 1.x</span>
         <span class="hljs-comment">// The second parameter here uses the pixel format in SDL. For comparison, refer to note A7</span>
         <span class="hljs-comment">// The pixel format AV_PIX_FMT_YUV420P in FFmpeg corresponds to the pixel format SDL_PIXELFORMAT_IYUV in SDL</span>
    sdl_texture = SDL_CreateTexture(sdl_renderer, 
                                    SDL_PIXELFORMAT_IYUV, 
                                    SDL_TEXTUREACCESS_STREAMING,
                                    p_codec_ctx-&gt;width,
                                    p_codec_ctx-&gt;height);  

    sdl_rect.x = <span class="hljs-number">0</span>;
    sdl_rect.y = <span class="hljs-number">0</span>;
    sdl_rect.w = p_codec_ctx-&gt;width;
    sdl_rect.h = p_codec_ctx-&gt;height;

    p_packet = (AVPacket *)av_malloc(<span class="hljs-keyword">sizeof</span>(AVPacket));
         <span class="hljs-comment">// A8. Read a packet from the video file</span>
         <span class="hljs-comment">// The packet may be a video frame, audio frame or other data. The decoder will only decode the video frame or audio frame. Non-audio and video data will not be</span>
         <span class="hljs-comment">// Throw it away so as to provide as much information as possible to the decoder</span>
         <span class="hljs-comment">// For video, a packet contains only one frame</span>
         <span class="hljs-comment">// For audio, if it is a format with a fixed frame length, a packet can contain an integer number of frames,</span>
         <span class="hljs-comment">// If it is a format with a variable frame length, a packet contains only one frame</span>
    <span class="hljs-keyword">while</span> (av_read_frame(p_fmt_ctx, p_packet) == <span class="hljs-number">0</span>)
    {
                 <span class="hljs-keyword">if</span> (p_packet-&gt;stream_index == v_idx) <span class="hljs-comment">// only process video frames</span>
        {
                         <span class="hljs-comment">// A9. Video decoding: packet ==&gt; frame</span>
                         <span class="hljs-comment">// A9.1 Feed data to the decoder, a packet may be a video frame or multiple audio frames, where the audio frame has been filtered out by the previous sentence</span>
            ret = avcodec_send_packet(p_codec_ctx, p_packet);
            <span class="hljs-keyword">if</span> (ret != <span class="hljs-number">0</span>)
            {
                <span class="hljs-built_in">printf</span>(<span class="hljs-string">"avcodec_send_packet() failed %d\n"</span>, ret);
                <span class="hljs-keyword">return</span> <span class="hljs-number">-1</span>;
            }
                         <span class="hljs-comment">// A9.2 Receive the data output by the decoder, here only the video frame is processed, each time a packet is received, decode it to get a frame</span>
            ret = avcodec_receive_frame(p_codec_ctx, p_frm_raw);
            <span class="hljs-keyword">if</span> (ret != <span class="hljs-number">0</span>)
            {
                <span class="hljs-built_in">printf</span>(<span class="hljs-string">"avcodec_receive_frame() failed %d\n"</span>, ret);
                <span class="hljs-keyword">return</span> <span class="hljs-number">-1</span>;
            }

                         <span class="hljs-comment">// A10. Image conversion: p_frm_raw-&gt;data ==&gt; p_frm_yuv-&gt;data</span>
                         <span class="hljs-comment">// Update a continuous area in the source image to the corresponding area of the target image after processing. The processed image area must be continuous line by line</span>
                         <span class="hljs-comment">// plane: For example, YUV has three planes of Y, U, and V, and RGB has three planes of R, G, and B</span>
                         <span class="hljs-comment">// slice: A slice of continuous lines in the image, must be continuous, the order is from top to bottom or from bottom to top</span>
                         <span class="hljs-comment">// stride/pitch: the number of bytes occupied by a line of image, Stride=BytesPerPixel*Width+Padding, pay attention to alignment</span>
                         <span class="hljs-comment">// AVFrame.*data[]: Each array element points to the corresponding plane</span>
                         <span class="hljs-comment">// AVFrame.linesize[]: Each array element represents the number of bytes occupied by a line of image in the corresponding plane</span>
            sws_scale(sws_ctx,                                  <span class="hljs-comment">// sws context</span>
                      (<span class="hljs-keyword">const</span> <span class="hljs-keyword">uint8_t</span> *<span class="hljs-keyword">const</span> *)p_frm_raw-&gt;data,  <span class="hljs-comment">// src slice</span>
                      p_frm_raw-&gt;linesize,                      <span class="hljs-comment">// src stride</span>
                      <span class="hljs-number">0</span>,                                        <span class="hljs-comment">// src slice y</span>
                      p_codec_ctx-&gt;height,                      <span class="hljs-comment">// src slice height</span>
                      p_frm_yuv-&gt;data,                          <span class="hljs-comment">// dst planes</span>
                      p_frm_yuv-&gt;linesize                       <span class="hljs-comment">// dst strides</span>
                     );
            
                         <span class="hljs-comment">// B5. Update SDL_Rect with new YUV pixel data</span>
            SDL_UpdateYUVTexture(sdl_texture,                   <span class="hljs-comment">// sdl texture</span>
                                 &amp;sdl_rect,                     <span class="hljs-comment">// sdl rect</span>
                                 p_frm_yuv-&gt;data[<span class="hljs-number">0</span>],            <span class="hljs-comment">// y plane</span>
                                 p_frm_yuv-&gt;linesize[<span class="hljs-number">0</span>],        <span class="hljs-comment">// y pitch</span>
                                 p_frm_yuv-&gt;data[<span class="hljs-number">1</span>],            <span class="hljs-comment">// u plane</span>
                                 p_frm_yuv-&gt;linesize[<span class="hljs-number">1</span>],        <span class="hljs-comment">// u pitch</span>
                                 p_frm_yuv-&gt;data[<span class="hljs-number">2</span>],            <span class="hljs-comment">// v plane</span>
                                 p_frm_yuv-&gt;linesize[<span class="hljs-number">2</span>]         <span class="hljs-comment">// v pitch</span>
                                 );
            
                         <span class="hljs-comment">// B6. Use a specific color to clear the current render target</span>
            SDL_RenderClear(sdl_renderer);
                         <span class="hljs-comment">// B7. Use part of the image data (texture) to update the current rendering target</span>
            SDL_RenderCopy(sdl_renderer,                        <span class="hljs-comment">// sdl renderer</span>
                           sdl_texture,                         <span class="hljs-comment">// sdl texture</span>
                           <span class="hljs-literal">NULL</span>,                                <span class="hljs-comment">// src rect, if NULL copy texture</span>
                           &amp;sdl_rect                            <span class="hljs-comment">// dst rect</span>
                          );
                         <span class="hljs-comment">// B8. Perform rendering and update screen display</span>
            SDL_RenderPresent(sdl_renderer);  

                         <span class="hljs-comment">// B9. The control frame rate is 25FPS, which is not accurate enough here, and the time consumed by decoding is not considered</span>
            SDL_Delay(<span class="hljs-number">40</span>);
        }
        av_packet_unref(p_packet);
    }

    SDL_Quit();
    sws_freeContext(sws_ctx);
    av_free(buffer);
    av_frame_free(&amp;p_frm_yuv);
    av_frame_free(&amp;p_frm_raw);
    avcodec_close(p_codec_ctx);
    avformat_close_input(&amp;p_fmt_ctx);

    <span class="hljs-keyword">return</span> <span class="hljs-number">0</span>;
}
```

Some concepts involved in the source code list are briefly described as follows:  
**container:**  
The container, also known as the wrapper, corresponds to the data structure AVFormatContext. Encapsulation refers to assembling stream data into files in a specified format. The encapsulation formats are AVI, MP4, etc. FFmpeg can recognize five stream types: video (v), audio (a), attachment (t), data (d), subtitle subtitle.

**codec:**  
Codec, corresponding to the data structure AVCodec. The encoder encodes uncompressed original image or audio data into compressed data. The decoder is the opposite.

**codec context**:  
Codec context, corresponding to the data structure AVCodecContext. This is a very important data structure, which will be analyzed later. Each API uses AVCodecContext extensively to reference codecs.

**codec par**:  
Codec parameters, corresponding to the data structure AVCodecParameters. Fields added in the new version. The new version recommends using AVStream->codepar instead of AVStream->codec.

**packet**:  
The encoded data packet corresponds to the data structure AVPacket. A packet obtained from a media file through av\_read\_frame() may contain multiple (integer) audio frames or a single video frame, or other types of streaming data.

**frame**:  
Uncoded original data frame, corresponding to the data structure AVFrame. The decoder decodes the packet and generates a frame.

**plane**:  
For example, YUV has three planes: Y, U, and V, and RGB has three planes: R, G, and B.

**slice**:  
A continuous line in the image, must be continuous, the order is from top to bottom or from bottom to top

**stride/pitch**:  
The number of bytes occupied by a line of image, Stride = BytesPerPixel × Width, aligned by x bytes \[to be confirmed\]

**sdl window**:  
The window that pops up when the video is played, corresponding to the data structure SDL\_Window. In SDL1.x version, only one window can be created. In SDL2.0 version, multiple windows can be created.

**sdl texture**:  
corresponds to the data structure SDL\_Texture. One SDL\_Texture corresponds to one frame of decoded image data.

**sdl renderer**:  
renderer, corresponding to the data structure SDL\_Renderer. Render SDL\_Texture to SDL\_Window.

**sdl rect**:  
corresponds to the data structure SDL\_Rect, SDL\_Rect is used to determine the display position of SDL\_Texture. Multiple SDL\_Rects can be displayed on one SDL\_Window. In this way, split screen display of the same window can be realized.

### 2.3 Brief description of source code process

The process is relatively simple, no flow chart is drawn, and the brief description is as follows:

```
media file --[decode]--&gt; raw frame --[scale]--&gt; yuv frame --[SDL]--&gt; display  
media file ------------&gt; p_frm_raw -----------&gt; p_frm_yuv ---------&gt; sdl_renderer  
```

After adding related key functions, the process is as follows:

```
<span class="hljs-attr">media_file</span> <span class="hljs-string">---[av_read_frame()]-----------&gt;  </span>
<span class="hljs-attr">p_packet</span>   <span class="hljs-string">---[avcodec_send_packet()]-----&gt;  </span>
<span class="hljs-attr">decoder</span>    <span class="hljs-string">---[avcodec_receive_frame()]---&gt;  </span>
<span class="hljs-attr">p_frm_raw</span>  <span class="hljs-string">---[sws_scale()]---------------&gt;  </span>
<span class="hljs-attr">p_frm_yuv</span>  <span class="hljs-string">---[SDL_UpdateYUVTexture()]----&gt;  </span>
<span class="hljs-attr">display</span>  <span class="hljs-string"></span>
```

#### 2.3.1 Initialization

Initialize the decoding and display environment.

#### 2.3.2 Read video data

Call av\_read\_frame() to read the video data packet from the input file.

#### 2.3.3 Video data decoding

Call avcodec\_send\_packet() and avcodec\_receive\_frame() to decode the video data.

#### 2.3.4 Image format conversion

The purpose of image format conversion is for the decoded video frame to be displayed normally by SDL. Because the image format obtained after FFmpeg decoding may not be supported by SDL, in this case, it cannot be displayed normally without image conversion.

#### 2.3.5 Display

Call SDL related functions to display the image on the screen.

## 3\. Compilation and verification

### 3.1 Compile

```
gcc -o ffplayer ffplayer.c -lavutil -lavformat -lavcodec -lavutil -lswscale -lSDL2
```

### 3.2 Verification

Choose bigbuckbunny\_480x272.h265 test file, download the test file (right click and save as):[bigbuckbunny\_480x272.h265](https://github.com/leichn/blog_resources/raw/master/video/bigbuckbunny_480x272.h265)  
Run test command:

```
./ffplayer bigbuckbunny_480x272.h265 
```

## 4\. References

\[1\] Lei Xiaohua,[Video and audio coding and decoding technology zero-based learning method](https://blog.csdn.net/leixiaohua1020/article/details/18893769)  
\[2\] Lei Xiaohua,[Simple analysis of FFmpeg source code: initialization and destruction of common structures (AVFormatContext, AVFrame, etc.)](https://blog.csdn.net/leixiaohua1020/article/details/41181155)  
\[3\] Lei Xiaohua,[The simplest video player ver2 based on FFMPEG+SDL (using SDL2.0)](https://blog.csdn.net/leixiaohua1020/article/details/38868499)  
\[4\] Martin Bohme, [An ffmpeg and SDL Tutorial, Tutorial 01: Making Screencaps](http://dranger.com/ffmpeg/ffmpegtutorial_all.html#tutorial01.html)  
\[5\] Martin Bohme, [An ffmpeg and SDL Tutorial, Tutorial 02: Outputting to the Screen](http://dranger.com/ffmpeg/ffmpegtutorial_all.html#tutorial02.html)  
\[6\] [Explanation of stride and plane in YUV image](https://www.cnblogs.com/welhzh/p/4939613.html)  
\[7\] [Detailed graphic explanation of YUV420 data format](https://www.cnblogs.com/azraelly/archive/2013/01/01/2841269.html)  
\[8\] [YUV](https://zh.wikipedia.org/wiki/YUV)，[https://zh.wikipedia.org/wiki/YUV](https://zh.wikipedia.org/wiki/YUV)