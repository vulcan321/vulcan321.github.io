```cpp
int Grial(int a, int b)
{
	if(b == 0) return a;
	return Grial(b, a%b);
}
 
void PlayVideo(const string& strVideoPath)
{
av_register_all();
AVFormatContext* avFormatContext = avformat_alloc_context();
int ret = avformat_open_input(&avFormatContext, strVideoPath.c_str(), NULL, NULL);//读取文件头
if (ret != 0)
	return;
ret = avformat_find_stream_info(avFormatContext, NULL);
if (ret < 0)
	return;
int videoStream_index = -1;//视频流索引号
for (int i = 0; i < avFormatContext->nb_streams; i++)
{
	if (avFormatContext->streams[i]->codec->codec_type == AVMEDIA_TYPE_VIDEO){
		videoStream_index = i;
		break;
	}
}
if (videoStream_index == -1)
	return;
AVCodecContext* videoCodecContext = avFormatContext->streams[videoStream_index]->codec;
AVCodec* videoCodec = avcodec_find_decoder(videoCodecContext->codec_id);//通过上下文查找编码器
if (videoCodec == NULL){
	printf("Couldn't get AVCodec\n");
	return;
}
if (avcodec_open2(videoCodecContext, videoCodec, NULL) < 0){// 打开编码器
	printf("Couldn't open AVCodec\n");
	return;
}
AVPacket *avPacket = (AVPacket*)av_malloc(sizeof(AVPacket));//分配avPacket
AVFrame *videoFrame = av_frame_alloc();//分配视频帧
int64_t start_time = av_gettime_relative();
while (av_read_frame(avFormatContext, avPacket) >= 0)
{
	if (avPacket->stream_index == videoStream_index)
	{
		int got_picture_ptr = 0;//是否被解码成功解码的标识(0标识失败,非0表示成功)
		avcodec_decode_video2(videoCodecContext, videoFrame, &got_picture_ptr, avPacket);//解码视频帧
		if (0 != got_picture_ptr)
		{
			RECT rt = video_ctrl_screen_->GetPos();
			int item_h = rt.bottom - rt.top;
			int item_w = rt.right - rt.left;
			int nGrial = Grial(videoCodecContext->width, videoCodecContext->height);//利用辗转相除法，计算得到最大公约数
			int nW = videoCodecContext->width / nGrial;
			int nH = videoCodecContext->height / nGrial;
 
			int nZearoWidth = 100;
			int nZearoHeight = nZearoWidth * nH / nW;
			int nWidthTemp = (item_w - nZearoWidth) / 4;
			int nHeightTemp = (item_h - nZearoHeight) / (4 * nH / nW);
			int nMin = min(nWidthTemp, nHeightTemp);
			int nOutWidth = nZearoWidth + nMin * 4;
			int nOutHeight = nZearoHeight + nMin *  (4 * nH / nW);
 
			AVFrame* pFrameRGB = av_frame_alloc();
			int numBytes = avpicture_get_size(AV_PIX_FMT_BGR24, nOutWidth, nOutHeight);
			uint8_t* buffer = new(std::nothrow) uint8_t[numBytes];
			avpicture_fill((AVPicture *)pFrameRGB, buffer, AV_PIX_FMT_BGR24, nOutWidth, nOutHeight);
			SwsContext *pSWSCtx = sws_getContext(videoCodecContext->width, videoCodecContext->height, \
				videoCodecContext->pix_fmt, nOutWidth, nOutHeight, AV_PIX_FMT_BGR24, SWS_BICUBIC, NULL, NULL, NULL);
 
			sws_scale(pSWSCtx, videoFrame->data, videoFrame->linesize, 0, videoFrame->height, pFrameRGB->data, pFrameRGB->linesize);
			if (video_ctrl_screen_)
				video_ctrl_screen_->Refresh(nOutWidth, nOutHeight, (unsigned char*)pFrameRGB->data[0], nOutWidth * nOutHeight * AV_PIX_FMT_BGR24);
 
			//对视频流进行同步
			AVRational time_base = avFormatContext->streams[videoStream_index]->time_base;
			AVRational time_base_q = { 1, AV_TIME_BASE };
			int64_t pts_time = av_rescale_q(avPacket->pts, time_base, time_base_q);
			int64_t now_time = av_gettime_relative() - start_time;
			if (pts_time > now_time)
				av_usleep(pts_time - now_time);
 
			delete[] buffer;
			buffer = nullptr;
			sws_freeContext(pSWSCtx);
			av_frame_free(&pFrameRGB);
		}
	}
	av_free_packet(avPacket);	
}
av_frame_free(&videoFrame);//释放videoFrame
av_packet_free(&avPacket);//释放avPacket
avcodec_close(videoCodecContext);//关闭视频解码器
avformat_close_input(&avFormatContext);//关闭输入文件
}
```