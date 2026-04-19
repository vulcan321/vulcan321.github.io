# 【超简单】之基于PaddleSpeech搭建个人语音听写服务

[快速实现AI想法](https://zhuanlan.zhihu.com//www.zhihu.com/people/li-kai-63-51-96)

学AI就上AI Studio，提供在线编程环境免费GPU算力

## 一、基于PaddleSpeech搭建个人语音听写服务

## **2.需求再分析**

**那么对于某些会议，比如保密会议，需要离线的，那么完全办不到，该怎么办呢？** 下面就有请我们的PaddleSpeech出场来解决问题。

## **3.解决思路**

【超简单】之基于PaddleSpeech搭建个人语音听写服务，顾名思义，是通过PaddleSpeech来搭建语音听写服务的，主要思路如下。

-   1.录音长度切分
-   2.录音听写
-   3.录音文本加标点

## 二、环境搭建

## **1.PaddleSpeech简介**

**PaddleSpeech** 是基于飞桨 [PaddlePaddle](https://link.zhihu.com/?target=https%3A//github.com/PaddlePaddle/Paddle) 的语音方向的开源模型库，用于语音和音频中的各种关键任务的开发，包含大量基于深度学习前沿和有影响力的模型，一些典型的应用如下：

-   语音识别
-   语音翻译
-   语音合成

## **2.PaddleSpeech安装**

```text
pip install paddlespeech
```

### **2.1相关依赖**

-   gcc >= 4.8.5
-   paddlepaddle >= 2.3.1
-   python >= 3.7
-   linux(推荐), mac, windows

### **2.2 win安装注意事项**

-   1.win必须安装 Microsoft C++ 生成工具 - Visual Studio [https://visualstudio.microsoft.com/zh-hans/visual-cpp-build-tools/](https://link.zhihu.com/?target=https%3A//visualstudio.microsoft.com/zh-hans/visual-cpp-build-tools/) 工具，原因是 **安装非纯 Python 包或编译 Cython 或 Pyrex 文件**。
-   2.参考： WindowsCompilers - Python Wiki [https://wiki.python.org/moin/WindowsCompilers](https://link.zhihu.com/?target=https%3A//wiki.python.org/moin/WindowsCompilers)

```python
!pip install paddlespeech >log.log
```

## **2.3 快速试用**

```python
!wget -c https://paddlespeech.bj.bcebos.com/PaddleAudio/zh.wav
--2022-07-27 00:31:57--  https://paddlespeech.bj.bcebos.com/PaddleAudio/zh.wav
Resolving paddlespeech.bj.bcebos.com (paddlespeech.bj.bcebos.com)... 182.61.200.195, 182.61.200.229, 2409:8c04:1001:1002:0:ff:b001:368a
Connecting to paddlespeech.bj.bcebos.com (paddlespeech.bj.bcebos.com)|182.61.200.195|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 159942 (156K) [audio/wav]
Saving to: ‘zh.wav’

zh.wav              100%[===================>] 156.19K  --.-KB/s    in 0.03s   

2022-07-27 00:31:57 (5.52 MB/s) - ‘zh.wav’ saved [159942/159942]
```

  

### **2.3.1 API调用**

  

```python
from paddlespeech.cli.asr.infer import ASRExecutor

asr = ASRExecutor()
result = asr(audio_file="zh.wav")
[2022-07-27 00:33:02,175] [    INFO] - checking the audio file format......
```

  

```python
print(result)
我认为跑步最重要的就是给我带来了身体健康
```

### **2.3.2 命令行调用**

  

```python
!paddlespeech asr --lang zh --input zh.wav
/opt/conda/envs/python35-paddle120-env/lib/python3.7/site-packages/nltk/decorators.py:68: DeprecationWarning: `formatargspec` is deprecated since Python 3.5. Use `signature` and the `Signature` object directly
  regargs, varargs, varkwargs, defaults, formatvalue=lambda value: ""
/opt/conda/envs/python35-paddle120-env/lib/python3.7/site-packages/nltk/lm/counter.py:15: DeprecationWarning: Using or importing the ABCs from 'collections' instead of from 'collections.abc' is deprecated, and in 3.8 it will stop working
  from collections import Sequence, defaultdict
/opt/conda/envs/python35-paddle120-env/lib/python3.7/site-packages/nltk/lm/vocabulary.py:13: DeprecationWarning: Using or importing the ABCs from 'collections' instead of from 'collections.abc' is deprecated, and in 3.8 it will stop working
  from collections import Counter, Iterable
[nltk_data] Downloading package averaged_perceptron_tagger to
[nltk_data]     /home/aistudio/nltk_data...
[nltk_data]   Unzipping taggers/averaged_perceptron_tagger.zip.
[nltk_data] Downloading package cmudict to /home/aistudio/nltk_data...
[nltk_data]   Unzipping corpora/cmudict.zip.
/opt/conda/envs/python35-paddle120-env/lib/python3.7/site-packages/matplotlib/__init__.py:107: DeprecationWarning: Using or importing the ABCs from 'collections' instead of from 'collections.abc' is deprecated, and in 3.8 it will stop working
  from collections import MutableMapping
/opt/conda/envs/python35-paddle120-env/lib/python3.7/site-packages/matplotlib/rcsetup.py:20: DeprecationWarning: Using or importing the ABCs from 'collections' instead of from 'collections.abc' is deprecated, and in 3.8 it will stop working
  from collections import Iterable, Mapping
/opt/conda/envs/python35-paddle120-env/lib/python3.7/site-packages/matplotlib/colors.py:53: DeprecationWarning: Using or importing the ABCs from 'collections' instead of from 'collections.abc' is deprecated, and in 3.8 it will stop working
  from collections import Sized
W0727 00:38:55.935500  2181 gpu_resources.cc:61] Please NOTE: device: 0, GPU Compute Capability: 7.0, Driver API Version: 11.2, Runtime API Version: 10.1
W0727 00:38:55.940197  2181 gpu_resources.cc:91] device: 0, cuDNN Version: 7.6.
/opt/conda/envs/python35-paddle120-env/lib/python3.7/site-packages/h5py/__init__.py:36: DeprecationWarning: `np.typeDict` is a deprecated alias for `np.sctypeDict`.
  from ._conv import register_converters as _register_converters
我认为跑步最重要的就是给我带来了身体健康
```

会自动下载一堆东西有点慢，可以不用这个。

```text
[nltk_data] Downloading package averaged_perceptron_tagger to
[nltk_data]     /home/aistudio/nltk_data...
[nltk_data]   Unzipping taggers/averaged_perceptron_tagger.zip.
[nltk_data] Downloading package cmudict to /home/aistudio/nltk_data...
```

### **2.3.3 常见错误**

如遇到以下错误

```text
[2022-07-26 21:13:28,589] [    INFO] - checking the audio file format......
[2022-07-26 21:13:28,594] [   ERROR] - Please input audio file less then 50 seconds.
```

报错很明显，提示一个是音频格式问题，一个是小于50s问题，如果遇到这个问题后面解决。

-   1.音频必须为wav格式
-   2.音频大小必须小于50s

**音频格式为wav格式，这个可通过录音笔设置（一般默认），或python代码转换，或者格式工厂进行转换。**

## **3.音频切分**

此处使用auditok库

  

```python
!pip install auditok
Looking in indexes: https://pypi.tuna.tsinghua.edu.cn/simple
Collecting auditok
  Downloading https://pypi.tuna.tsinghua.edu.cn/packages/49/3a/8b5579063cfb7ae3e89d40d495f4eff6e9cdefa14096ec0654d6aac52617/auditok-0.2.0-py3-none-any.whl (1.5 MB)
     l     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 0.0/1.5 MB ? eta -:--:--━━━━━━━━━━╸━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 0.4/1.5 MB 14.2 MB/s eta 0:00:01━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╸━━━━━━ 1.3/1.5 MB 19.7 MB/s eta 0:00:01━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 1.5/1.5 MB 15.4 MB/s eta 0:00:00
[?25hInstalling collected packages: auditok
Successfully installed auditok-0.2.0

[notice] A new release of pip available: 22.1.2 -> 22.2
[notice] To update, run: pip install --upgrade pip
```

## 三、音频切分

切分原因上面交代过，因为PaddleSpeech识别最长语音为50s，故需要切分，这里直接调用好了。

```python
from paddlespeech.cli.asr.infer import ASRExecutor
import csv
import moviepy.editor as mp
import auditok
import os
import paddle
from paddlespeech.cli import ASRExecutor, TextExecutor
import soundfile
import librosa
import warnings

warnings.filterwarnings('ignore')
# 引入auditok库
import auditok
# 输入类别为audio
def qiefen(path, ty='audio', mmin_dur=1, mmax_dur=100000, mmax_silence=1, menergy_threshold=55):
    audio_file = path
    audio, audio_sample_rate = soundfile.read(
        audio_file, dtype="int16", always_2d=True)

    audio_regions = auditok.split(
        audio_file,
        min_dur=mmin_dur,  # minimum duration of a valid audio event in seconds
        max_dur=mmax_dur,  # maximum duration of an event
        # maximum duration of tolerated continuous silence within an event
        max_silence=mmax_silence,
        energy_threshold=menergy_threshold  # threshold of detection
    )

    for i, r in enumerate(audio_regions):
        # Regions returned by `split` have 'start' and 'end' metadata fields
        print(
            "Region {i}: {r.meta.start:.3f}s -- {r.meta.end:.3f}s".format(i=i, r=r))

        epath = ''
        file_pre = str(epath.join(audio_file.split('.')[0].split('/')[-1]))

        mk = 'change'
        if (os.path.exists(mk) == False):
            os.mkdir(mk)
        if (os.path.exists(mk + '/' + ty) == False):
            os.mkdir(mk + '/' + ty)
        if (os.path.exists(mk + '/' + ty + '/' + file_pre) == False):
            os.mkdir(mk + '/' + ty + '/' + file_pre)
        num = i
        # 为了取前三位数字排序
        s = '000000' + str(num)

        file_save = mk + '/' + ty + '/' + file_pre + '/' + \
                    s[-3:] + '-' + '{meta.start:.3f}-{meta.end:.3f}' + '.wav'
        filename = r.save(file_save)
        print("region saved as: {}".format(filename))
    return mk + '/' + ty + '/' + file_pre
```

## 四、语音转文本

直接调用ASRExecutor进行语音到文本转换。

**需要注意的是，此处 force\_yes=True， 即强行进行音频频率转换，PaddleSpeech使用16000hz频率。如force\_yes=False，则需要手动确认。。。。。**

```python
# 语音转文本
asr_executor = ASRExecutor()

def audio2txt(path):
    # 返回path下所有文件构成的一个list列表
    print(f"path: {path}")
    filelist = os.listdir(path)
    # 保证读取按照文件的顺序
    filelist.sort(key=lambda x: int(os.path.splitext(x)[0][:3]))
    # 遍历输出每一个文件的名字和类型
    words = []
    for file in filelist:
        print(path + '/' + file)
        text = asr_executor(
            audio_file=path + '/' + file,
            device=paddle.get_device(), force_yes=True) # force_yes参数需要注意
        words.append(text)
    return words
# 保存
import csv

def txt2csv(txt_all):
    with open('result.csv', 'w', encoding='utf-8') as f:
        f_csv = csv.writer(f)
        for row in txt_all:
            f_csv.writerow([row])
```

## 五、标点符号修正

直接调用 TextExecutor 进行修正，简单粗暴。

下面上传一段录音来试试吧。

## **1.语音内容**

  

![](https://pic1.zhimg.com/v2-3732f7a952374afec6b790e05f88e560_b.jpg)

![](https://pic1.zhimg.com/80/v2-3732f7a952374afec6b790e05f88e560_720w.webp)

  

## **2.语音识别并修正标点**

```python
!unzip -qoa 录音.zip
!mv ┬╝╥Ї.wav 录音.wav
from paddlespeech.cli.asr.infer import ASRExecutor
import csv
import moviepy.editor as mp
import auditok
import os
import paddle
from paddlespeech.cli import ASRExecutor, TextExecutor
import soundfile
import librosa
import warnings

warnings.filterwarnings('ignore')
# 可替换成自身的录音文件
source_path = '录音.wav'
# 划分音频
path = qiefen(path=source_path, ty='audio',
                mmin_dur=0.5, mmax_dur=100000, mmax_silence=0.5, menergy_threshold=55)
# 音频转文本  需要GPU
txt_all = audio2txt(path)
# 存入csv
txt2csv(txt_all)

!head result.csv
```

  

```python
# 拿到新生成的音频的路径
texts = ''
source_path = 'result.csv'
with open(source_path, 'r') as f:
    text = f.readlines()
for i in range(len(text)):
    text[i] = text[i].replace('\n', '')
    texts = texts + text[i]
print(texts)
text_executor = TextExecutor()
if text:
    result = text_executor(
        text=texts,
        task='punc',
        model='ernie_linear_p3_wudao',
        device=paddle.get_device(),
        # force_yes=True
    )
print(result)
with open("final_result.txt", 'w') as f:
e=paddle.get_device(),
        # force_yes=True
    )
print(result)
with open("final_result.txt", 'w') as f:
    f.writelines(result)
!head final_result.txt
为推动教育部教育数字化战略行动，更好落实教育部办公厅关于启动部分重点领域教学资源建设工作的通知，促进高校共建共享人工智能领域优质教小资源，协助教师搭建个性化课程，服务专业教学活动，提升惨教融合协同育人成效，上海交通大学北京航空航天大学联合百度公司主办各邀请教育部重点领域教学资源建设向专家组有关专家麦克谢谢。
```

## **3.识别结果**

```text
为推动，教育部。教育数字化战略行动。更好落实教育部办公厅关于启动部分重点领域。教学资源建设工作的通知。促进高校共建共享人工智能领域优质教小资源。协助教师搭建个性化课程。服务专业教学活动，提升惨教融合协同育人成效。上海交通大学，北京航空航天大学联合百度公司主办。各邀请教育部重点领域教学资源建设。向专家组。有关专家。麦克。谢谢
```

## **4.修正标点结果**

```text
为推动教育部教育数字化战略行动，更好落实教育部办公厅关于启动部分重点领域教学资源建设工作的通知，促进高校共建共享人工智能领域优质教小资源，协助教师搭建个性化课程，服务专业教学活动，提升惨教融合协同育人成效，上海交通大学北京航空航天大学联合百度公司主办各邀请教育部重点领域教学资源建设向专家组有关专家麦克谢谢。
```

## 六、后续计划

目前测试效果不错，计划后续GUI部署使用。