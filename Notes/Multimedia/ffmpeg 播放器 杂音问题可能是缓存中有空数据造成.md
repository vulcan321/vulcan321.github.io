## 结合 ffmpeg 和 Qt 开发一个简单的播放器   

### 一、视频解码流程

该项目是使用 **QWidget** 进行渲染, 所以需要将解码出来 **YUV** 图像格式转换成 **RGB** 格式。视频的解码流程如下图:

![image-01](https://github.com/mingxingren/Notes/raw/master/resource/photo/image-2021051701.png)

### 二、音频解码流程

音频解码稍微复杂一点(个人认为...)， 因为音频要搞清楚 采样率， 样本位数， 通道位数。当然ffmpeg 库非常强大，包含你想要的任何功能，但至少要明白一些多媒体的基础知识，相关知识请参考: https://blog.csdn.net/leixiaohua1020/article/details/15811977?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522162126634016780357257374%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fblog.%2522%257D&request_id=162126634016780357257374&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~first_rank_v2~rank_v29-1-15811977.nonecase&utm_term=j%E5%9F%BA%E7%A1%80%E7%9F%A5%E8%AF%86



音频解码调用流程图如下:

![image-02](https://github.com/mingxingren/Notes/raw/master/resource/photo/image-2021051702.png)



### 三、音视频同步

首先，我看了很多的博客，很多的代码，大多数都是用 **SDL** + **FFMPEG** 那一套进行开发，采用的同步方式大都是视频往音频上做同步。虽然大相径庭，但某些细节上的问题，却是各种各样(那时候我不会用 **ffmpeg**)。直到后来我扫了几眼 **FFMEPG** 的 **ffplay** 的源码... , 这件事情后，我想以后不管多麻烦，还是要看看源码更能提升自己的能力。

音视频同步，在某些人看来是 **ffmpeg** 的入门证明。同步方式无非有三种: 

① 外部增加一个计时器，然后分别判断音频帧 和 视频帧，到时间就播放或者显示

② 让音频按照自己频率播放 ( 这个**SDL** 多媒体可以通过定时回调播放音频帧 )，然后判断图像帧的时间戳，到时间就显示图像帧

③ 让图像帧正常播放，然后定时播放音频帧 ( 没见过别人有使用过，估计比较麻烦或者效果不好，不推荐 )



音视频的时间戳的计算是根据 **AVFrame**  的 **PTS**  计算得到的，其代码如下:

```C++
///< 计算 PTS 的时间刻度，这里乘以1000 是想让刻度精确到毫秒
double dVieoUnit = av_q2d(pFormatContex->streams[i]->time_base) * 1000;		
int64_t iTimeStamp = dVieoUnit * pFrameOrg->pts;	///< 计算出每帧显示多少毫秒
```



项目代码：https://github.com/mingxingren/ffmpeg_practice



### 注意: 音频播放有杂音, 可能是申请的音频帧内存比实际音频帧大，导致播放时候遇到无效的内存出现杂音