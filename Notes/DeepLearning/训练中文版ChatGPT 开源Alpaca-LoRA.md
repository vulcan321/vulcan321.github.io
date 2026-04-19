# 训练个中文版ChatGPT没那么难：不用A100，开源Alpaca-LoRA+RTX 4090就能搞定

> Alpaca-LoRA 将微调类 ChatGPT 模型的算力需求降到了消费级，训练个自己的中文对话模型真就没那么难了。

  

2023 年，聊天机器人领域似乎只剩下两个阵营：「OpenAI 的 ChatGPT」和「其他」。

  

ChatGPT 功能强大，但 OpenAI 几乎不可能将其开源。「其他」阵营表现欠佳，但不少人都在做开源方面的努力，比如前段时间 [Meta 开源的 LLaMA](http://mp.weixin.qq.com/s?__biz=MzA3MzI4MjgzMw==&mid=2650869478&idx=1&sn=c06afe59ab0322e885a0f4358b9b6907&chksm=84e4ca98b393438e77ff7893e43524273e396e1a0c43fae592b04acfb674ab8f64ffb2ba21ae&scene=21#wechat_redirect)。

  

LLaMA 是一系列模型的总称，参数量从 70 亿到 650 亿不等，其中，130 亿参数的 LLaMA 模型「在大多数基准上」可以胜过参数量达 1750 亿的 GPT-3。不过，该模型并没有经过指令微调（instruct tuning），因此生成效果较差。

  

为了提高模型性能，来自斯坦福的研究者帮助其完成了指令微调的工作，训练了一个名为 [Alpaca](http://mp.weixin.qq.com/s?__biz=MzA3MzI4MjgzMw==&mid=2650870948&idx=4&sn=8afcea870afc1210499686678bf5dbbb&chksm=84e4d0dab39359ccf3ea8d085f0ea284ed3f01efe4edac2b303ff3f0ff448ea8d0da1393c244&scene=21#wechat_redirect)（羊驼）的 70 亿参数新模型（基于 LLaMA 7B）。具体来说，他们让 OpenAI 的 text-davinci-003 模型以 self-instruct 方式生成 52K 指令遵循（instruction-following）样本，以此作为 Alpaca 的训练数据。实验结果表明，Alpaca 的很多行为都与 text-davinci-003 类似。也就是说，只有 7B 参数的轻量级模型 Alpaca 性能可媲美 GPT-3.5 这样的超大规模语言模型。

  

![Image](https://mmbiz.qpic.cn/mmbiz_png/KmXPKA19gWibj5FStLMZE8VzJyzhV8J6EfddF1jnWUGStqdYKb958LgNicpBibSNHGt1kqdY5TUnvRWt2KN5jMDibA/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

  

对于普通研究者来说，这是一种切实可行的廉价微调方式，不过需要的运算量仍然较大（作者表示他们在 8 个 80GB A100 上微调了 3 个小时）。而且，Alpaca 的种子任务都是英语，收集的数据也都是英文，因此训练出来的模型未对中文优化。

  

为了进一步降低微调成本，另一位来自斯坦福的研究者 ——Eric J. Wang 使用 LoRA（low-rank adaptation）技术复现了 Alpaca 的结果。具体来说，Eric J. Wang 使用一块 RTX 4090 显卡，只用 5 个小时就训练了一个和 Alpaca 水平相当的模型，将这类模型对算力的需求降到了消费级。而且，该模型可以在树莓派上运行（用于研究）。

  

![Image](https://mmbiz.qpic.cn/mmbiz_png/KmXPKA19gWibj5FStLMZE8VzJyzhV8J6EuFESz7L2arXZyr8mabib671veYMzOZ2bCmxe2eOuYNn1os6cfHh9oIQ/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

_LoRA 的技术原理。LoRA 的思想是在原始 PLM 旁边增加一个旁路，做一个降维再升维的操作，来模拟所谓的 intrinsic rank。训练的时候固定 PLM 的参数，只训练降维矩阵 A 与升维矩阵 B。而模型的输入输出维度不变，输出时将 BA 与 PLM 的参数叠加。用随机高斯分布初始化 A，用 0 矩阵初始化 B，保证训练的开始此旁路矩阵依然是 0 矩阵（引自：https://finisky.github.io/lora/）。LoRA 的最大优势是速度更快，使用的内存更少，因此可以在消费级硬件上运行。_

  

![Image](https://mmbiz.qpic.cn/mmbiz_png/KmXPKA19gWibj5FStLMZE8VzJyzhV8J6EbpmywZ7uQOgZqD24qnJn4Bzo3XA4GA0swcKelz3UYk4ccpUR54Wibww/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

_Eric J. Wang 发布的 Alpaca-LoRA 项目。_  

  

项目地址：https://github.com/tloen/alpaca-lora

  

对于想要训练自己的类 ChatGPT 模型（包括中文版类 ChatGPT）但又没有顶级算力资源配置的研究者来说，这无疑是一大惊喜。因此，在 Alpaca-LoRA 项目问世后，围绕该项目的教程和训练成果不断涌现，本文将介绍其中的几个。

  

**如何使用 Alpaca-LoRA 微调 LLaMA**

  

在 Alpaca-LoRA 项目中，作者提到，为了廉价高效地进行微调，他们使用了 Hugging Face 的 PEFT。PEFT 是一个库（LoRA 是其支持的技术之一），可以让你使用各种基于 Transformer 的语言模型并使用 LoRA 对其进行微调。好处在于，它允许你在一般的硬件上廉价而有效地微调模型，并有较小的（也许是可组合的）输出。

  

在近期的一篇博客中，几位研究者介绍了如何使用 Alpaca-LoRA 来微调 LLaMA。

  

使用 Alpaca-LoRA 之前，需要具备一些先决条件。首先是 GPU 的选择，得益于 LoRA，现在你可以在 NVIDIA T4 这样低规格 GPU 或 4090 消费级 GPU 上完成微调；此外，你还需要申请 LLaMA 权重，因为其权重并不对外公开。

  

先决条件具备了，接下来就是如何使用 Alpaca-LoRA。首选你需要克隆 Alpaca-LoRA 存储库，代码如下：

  

```
git clone https://github.com/daanelson/alpaca-lora
```

  

其次，获取 LLaMA 权重。将下载到的权重值存储到名为 unconverted-weights 文件夹里，文件夹层次结构就像下面这样：

  

```
unconverted-weights
```

  

权重存储好后，接着使用以下命令将 PyTorch checkpoint 的权重转换为 transformer 兼容的格式：

  

```
cog run python -m transformers.models.llama.convert_llama_weights_to_hf \
```

  

得到最终的目录结构应该是这样的：

  

```
weights
```

  

处理好上述两步，来到第三步，安装 Cog：

  

```
sudo curl -o /usr/local/bin/cog -L "https://github.com/replicate/cog/releases/latest/download/cog_$(uname -s)_$(uname -m)"
```

  

第四步来到微调模型，默认情况下，微调脚本上配置的 GPU 功能较弱，但如果你有性能更好的 GPU，则可以在 finetune.py 中将 MICRO\_BATCH\_SIZE 增加到 32 或 64。此外，如果你有指令调优数据集，则可以在 finetune.py 中编辑 DATA\_PATH 以指向自己的数据集。需要注意的是这一项操作应该确保数据格式与 alpaca\_data\_cleaned.json 相同。接下来运行微调脚本：

  

```
cog run python finetune.py
```

  

微调过程在 40GB A100 GPU 上花费 3.5 小时，对于处理能力较低的 GPU 则需要更多时间。

  

最后一步用 Cog 运行模型：

  

```
$ cog predict -i prompt="Tell me something about alpacas."
```

  

教程作者表示，在完成以上步骤之后，大家可以继续尝试各种玩法，包括但不限于：

  

-   带上你自己的数据集，微调你自己的 LoRA，比如微调 LLaMA，让它像动漫角色一样说话。参见：https://replicate.com/blog/fine-tune-llama-to-speak-like-homer-simpson
    
-   将模型部署到云平台上；
    
-   结合其他 LoRA，比如 Stable Diffusion LoRA，把这些都用到图像领域；
    
-   使用 Alpaca 数据集（或其他数据集）微调更大的 LLaMA 模型，并查看它们的表现。这应该可以通过 PEFT 和 LoRA 实现，尽管它需要更大的 GPU。
    

  

**Alpaca-LoRA 的衍生项目**

  

尽管 Alpaca 性能可以媲美 GPT 3.5，但其种子任务都是英语，收集的数据也都是英文，因此训练出来的模型对中文并不友好。为了提升对话模型在中文上的效果，我们看看都有哪些比较好的项目。

  

首先是来自华中师范大学等机构的三位个人开发者开源的中文语言模型骆驼 (Luotuo)，该项目基于 LLaMA、Stanford Alpaca、Alpaca LoRA、Japanese-Alpaca-LoRA 等完成，单卡就能完成训练部署。有意思的是，他们之所以将模型名字命名为骆驼，是因为 LLaMA（大羊驼）和 alpaca（羊驼）都属于偶蹄目 - 骆驼科。这样看来，起这个名字也在意料之中。

  

这个模型是在 Meta 开源的 LLaMA 基础上，参考 Alpaca 和 Alpaca-LoRA 两个项目，对中文进行了训练。

  

![Image](https://mmbiz.qpic.cn/mmbiz_png/KmXPKA19gWibj5FStLMZE8VzJyzhV8J6Eo483l67kullBM07BoCxoib3cJanrjJuRqJkiakibOJRGFIW4qKnrGdicZQ/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

  

项目地址：https://github.com/LC1332/Chinese-alpaca-lora

  

目前该项目释放了两个模型 luotuo-lora-7b-0.1、luotuo-lora-7b-0.3，还有一个模型在计划中：

  

![Image](https://mmbiz.qpic.cn/mmbiz_png/KmXPKA19gWibj5FStLMZE8VzJyzhV8J6EvpU0DssYWFQXOMaKsd8szXnicMSL1PxHV2UeHq3ZWBF7yRnIxDwiaOrw/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

  

下面是效果展示：

  

![Image](https://mmbiz.qpic.cn/mmbiz_png/KmXPKA19gWibj5FStLMZE8VzJyzhV8J6Ezfa2Rfd2uAzzpApMm9NFpazmJg0xLP5TgMFlUNdiaV0RNicEI7AhrgOA/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

  

![Image](https://mmbiz.qpic.cn/mmbiz_png/KmXPKA19gWibj5FStLMZE8VzJyzhV8J6Edz5Q2bYucJjhQ6uScP0p2WfDVodeuyrgxFG1kgvicr7iaYJmgW0QQic4Q/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

  

不过 luotuo-lora-7b-0.1（0.1）、luotuo-lora-7b-0.3（0.3）还是有差距的，在用户询问华中师范大学地址时，0.1 回答错误：

  

![Image](https://mmbiz.qpic.cn/mmbiz_png/KmXPKA19gWibj5FStLMZE8VzJyzhV8J6E2RiaeVY05O2EAOica7iafQHd8hXJibynHUuYgYWCz0PJD5GuOUoUEWI1Gg/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

  

除了进行简单的对话外，还有人在保险相关领域进行了模型优化。据这位推特网友表示，借助 Alpaca-LoRA 项目，他输入了一些中文保险问答数据，最后效果也不错。

  

具体来说，作者训练中文版 Alpaca LoRa 用了 3K 多条中文问答保险语料，实现过程使用了 LoRa 方法，并微调 Alpaca 7B 模型，耗时 240 分钟，最终 Loss 0.87 。