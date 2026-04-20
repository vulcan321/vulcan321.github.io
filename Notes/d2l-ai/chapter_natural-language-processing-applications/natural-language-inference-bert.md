# 自然语言推断：微调BERT
:label:`sec_natural-language-inference-bert`

在本章的前面几节中，我们已经为SNLI数据集（ :numref:`sec*natural-language-inference-and-dataset`）上的自然语言推断任务设计了一个基于注意力的结构（ :numref:`sec*natural-language-inference-attention`）。现在，我们通过微调BERT来重新审视这项任务。正如在 :numref:`sec*finetuning-bert`中讨论的那样，自然语言推断是一个序列级别的文本对分类问题，而微调BERT只需要一个额外的基于多层感知机的架构，如 :numref:`fig*nlp-map-nli-bert`中所示。

![将预训练BERT提供给基于多层感知机的自然语言推断架构](../img/nlp-map-nli-bert.svg)
:label:`fig_nlp-map-nli-bert`

本节将下载一个预训练好的小版本的BERT，然后对其进行微调，以便在SNLI数据集上进行自然语言推断。

```{.python .input}
from d2l import mxnet as d2l
import json
import multiprocessing
from mxnet import gluon, np, npx
from mxnet.gluon import nn
import os

npx.set_np()
```

```{.python .input}
# @tab pytorch
from d2l import torch as d2l
import json
import multiprocessing
import torch
from torch import nn
import os
```

```{.python .input}
# @tab paddle
from d2l import paddle as d2l
import warnings
warnings.filterwarnings("ignore")
import json
import multiprocessing
import paddle
from paddle import nn
import os
```

# # [**加载预训练的BERT**]

我们已经在 :numref:`sec*bert-dataset`和 :numref:`sec*bert-pretraining`WikiText-2数据集上预训练BERT（请注意，原始的BERT模型是在更大的语料库上预训练的）。正如在 :numref:`sec_bert-pretraining`中所讨论的，原始的BERT模型有数以亿计的参数。在下面，我们提供了两个版本的预训练的BERT：“bert.base”与原始的BERT基础模型一样大，需要大量的计算资源才能进行微调，而“bert.small”是一个小版本，以便于演示。

```{.python .input}
d2l.DATA*HUB['bert.base'] = (d2l.DATA*URL + 'bert.base.zip',
                             '7b3820b35da691042e5d34c0971ac3edbd80d3f4')
d2l.DATA*HUB['bert.small'] = (d2l.DATA*URL + 'bert.small.zip',
                              'a4e718a47137ccd1809c9107ab4f5edd317bae2c')
```

```{.python .input}
# @tab pytorch
d2l.DATA*HUB['bert.base'] = (d2l.DATA*URL + 'bert.base.torch.zip',
                             '225d66f04cae318b841a13d32af3acc165f253ac')
d2l.DATA*HUB['bert.small'] = (d2l.DATA*URL + 'bert.small.torch.zip',
                              'c72329e68a732bef0452e4b96a1c341c8910f81f')
```

```{.python .input}
# @tab paddle
d2l.DATA*HUB['bert*small'] = ('https://paddlenlp.bj.bcebos.com/models/bert.small.paddle.zip', '9fcde07509c7e87ec61c640c1b277509c7e87ec6153d9041758e4')

d2l.DATA*HUB['bert*base'] = ('https://paddlenlp.bj.bcebos.com/models/bert.base.paddle.zip', '9fcde07509c7e87ec61c640c1b27509c7e87ec61753d9041758e4')
```

两个预训练好的BERT模型都包含一个定义词表的“vocab.json”文件和一个预训练参数的“pretrained.params”文件。我们实现了以下`load*pretrained*model`函数来[**加载预先训练好的BERT参数**]。

```{.python .input}
def load*pretrained*model(pretrained*model, num*hiddens, ffn*num*hiddens,
                          num*heads, num*layers, dropout, max_len, devices):
    data*dir = d2l.download*extract(pretrained_model)
    # 定义空词表以加载预定义词表
    vocab = d2l.Vocab()
    vocab.idx*to*token = json.load(open(os.path.join(data_dir,
         'vocab.json')))
    vocab.token*to*idx = {token: idx for idx, token in enumerate(
        vocab.idx*to*token)}
    bert = d2l.BERTModel(len(vocab), num*hiddens, ffn*num_hiddens, 
                         num*heads, num*layers, dropout, max_len)
    # 加载预训练BERT参数
    bert.load*parameters(os.path.join(data*dir, 'pretrained.params'),
                         ctx=devices)
    return bert, vocab
```

```{.python .input}
# @tab pytorch
def load*pretrained*model(pretrained*model, num*hiddens, ffn*num*hiddens,
                          num*heads, num*layers, dropout, max_len, devices):
    data*dir = d2l.download*extract(pretrained_model)
    # 定义空词表以加载预定义词表
    vocab = d2l.Vocab()
    vocab.idx*to*token = json.load(open(os.path.join(data_dir, 
        'vocab.json')))
    vocab.token*to*idx = {token: idx for idx, token in enumerate(
        vocab.idx*to*token)}
    bert = d2l.BERTModel(len(vocab), num*hiddens, norm*shape=[256],
                         ffn*num*input=256, ffn*num*hiddens=ffn*num*hiddens,
                         num*heads=4, num*layers=2, dropout=0.2,
                         max*len=max*len, key*size=256, query*size=256,
                         value*size=256, hid*in_features=256,
                         mlm*in*features=256, nsp*in*features=256)
    # 加载预训练BERT参数
    bert.load*state*dict(torch.load(os.path.join(data_dir,
                                                 'pretrained.params')))
    return bert, vocab
```

```{.python .input}
# @tab paddle
def load*pretrained*model(pretrained*model, num*hiddens, ffn*num*hiddens,
                          num*heads, num*layers, dropout, max_len, devices):
    data*dir = d2l.download*extract(pretrained_model)
    # 定义空词表以加载预定义词表
    vocab = d2l.Vocab()
    vocab.idx*to*token = json.load(open(os.path.join(data_dir,
        'vocab.json')))
    vocab.token*to*idx = {token: idx for idx, token in enumerate(
        vocab.idx*to*token)}
    bert = d2l.BERTModel(len(vocab), num*hiddens, norm*shape=[256],
                         ffn*num*input=256, ffn*num*hiddens=ffn*num*hiddens,
                         num*heads=4, num*layers=2, dropout=0.2,
                         max*len=max*len, key*size=256, query*size=256,
                         value*size=256, hid*in_features=256,
                         mlm*in*features=256, nsp*in*features=256)
    # 加载预训练BERT参数
    bert.set*state*dict(paddle.load(os.path.join(data_dir,
                                                 'pretrained.pdparams')))

    return bert, vocab
```

为了便于在大多数机器上演示，我们将在本节中加载和微调经过预训练BERT的小版本（“bert.small”）。在练习中，我们将展示如何微调大得多的“bert.base”以显著提高测试精度。

```{.python .input}
# @tab mxnet, pytorch
devices = d2l.try*all*gpus()
bert, vocab = load*pretrained*model(
    'bert.small', num*hiddens=256, ffn*num*hiddens=512, num*heads=4,
    num*layers=2, dropout=0.1, max*len=512, devices=devices)
```

```{.python .input}
# @tab paddle
devices = d2l.try*all*gpus()
bert, vocab = load*pretrained*model(
    'bert*small', num*hiddens=256, ffn*num*hiddens=512, num_heads=4,
    num*layers=2, dropout=0.1, max*len=512, devices=devices)
```

# # [**微调BERT的数据集**]

对于SNLI数据集的下游任务自然语言推断，我们定义了一个定制的数据集类`SNLIBERTDataset`。在每个样本中，前提和假设形成一对文本序列，并被打包成一个BERT输入序列，如 :numref:`fig*bert-two-seqs`所示。回想 :numref:`subsec*bert*input*rep`，片段索引用于区分BERT输入序列中的前提和假设。利用预定义的BERT输入序列的最大长度（`max*len`），持续移除输入文本对中较长文本的最后一个标记，直到满足`max*len`。为了加速生成用于微调BERT的SNLI数据集，我们使用4个工作进程并行生成训练或测试样本。

```{.python .input}
class SNLIBERTDataset(gluon.data.Dataset):
    def **init**(self, dataset, max_len, vocab=None):
        all*premise*hypothesis_tokens = [[
            p*tokens, h*tokens] for p*tokens, h*tokens in zip(
            *[d2l.tokenize([s.lower() for s in sentences])
              for sentences in dataset[:2]])]
        
        self.labels = np.array(dataset[2])
        self.vocab = vocab
        self.max*len = max*len
        (self.all*token*ids, self.all_segments,
         self.valid*lens) = self.*preprocess(all*premise*hypothesis_tokens)
        print('read ' + str(len(self.all*token*ids)) + ' examples')

    def *preprocess(self, all*premise*hypothesis*tokens):
        pool = multiprocessing.Pool(4)  # 使用4个进程
        out = pool.map(self.*mp*worker, all*premise*hypothesis_tokens)
        all*token*ids = [
            token*ids for token*ids, segments, valid_len in out]
        all*segments = [segments for token*ids, segments, valid_len in out]
        valid*lens = [valid*len for token*ids, segments, valid*len in out]
        return (np.array(all*token*ids, dtype='int32'),
                np.array(all_segments, dtype='int32'), 
                np.array(valid_lens))

    def *mp*worker(self, premise*hypothesis*tokens):
        p*tokens, h*tokens = premise*hypothesis*tokens
        self.*truncate*pair*of*tokens(p*tokens, h*tokens)
        tokens, segments = d2l.get*tokens*and*segments(p*tokens, h_tokens)
        token_ids = self.vocab[tokens] + [self.vocab['<pad>']] \
                             * (self.max_len - len(tokens))
        segments = segments + [0] * (self.max_len - len(segments))
        valid_len = len(tokens)
        return token*ids, segments, valid*len

    def *truncate*pair*of*tokens(self, p*tokens, h*tokens):
        # 为BERT输入中的'<CLS>'、'<SEP>'和'<SEP>'词元保留位置
        while len(p*tokens) + len(h*tokens) > self.max_len - 3:
            if len(p*tokens) > len(h*tokens):
                p_tokens.pop()
            else:
                h_tokens.pop()

    def **getitem**(self, idx):
        return (self.all*token*ids[idx], self.all_segments[idx],
                self.valid_lens[idx]), self.labels[idx]

    def **len**(self):
        return len(self.all*token*ids)
```

```{.python .input}
# @tab pytorch
class SNLIBERTDataset(torch.utils.data.Dataset):
    def **init**(self, dataset, max_len, vocab=None):
        all*premise*hypothesis_tokens = [[
            p*tokens, h*tokens] for p*tokens, h*tokens in zip(
            *[d2l.tokenize([s.lower() for s in sentences])
              for sentences in dataset[:2]])]
        
        self.labels = torch.tensor(dataset[2])
        self.vocab = vocab
        self.max*len = max*len
        (self.all*token*ids, self.all_segments,
         self.valid*lens) = self.*preprocess(all*premise*hypothesis_tokens)
        print('read ' + str(len(self.all*token*ids)) + ' examples')

    def *preprocess(self, all*premise*hypothesis*tokens):
        pool = multiprocessing.Pool(4)  # 使用4个进程
        out = pool.map(self.*mp*worker, all*premise*hypothesis_tokens)
        all*token*ids = [
            token*ids for token*ids, segments, valid_len in out]
        all*segments = [segments for token*ids, segments, valid_len in out]
        valid*lens = [valid*len for token*ids, segments, valid*len in out]
        return (torch.tensor(all*token*ids, dtype=torch.long),
                torch.tensor(all_segments, dtype=torch.long), 
                torch.tensor(valid_lens))

    def *mp*worker(self, premise*hypothesis*tokens):
        p*tokens, h*tokens = premise*hypothesis*tokens
        self.*truncate*pair*of*tokens(p*tokens, h*tokens)
        tokens, segments = d2l.get*tokens*and*segments(p*tokens, h_tokens)
        token_ids = self.vocab[tokens] + [self.vocab['<pad>']] \
                             * (self.max_len - len(tokens))
        segments = segments + [0] * (self.max_len - len(segments))
        valid_len = len(tokens)
        return token*ids, segments, valid*len

    def *truncate*pair*of*tokens(self, p*tokens, h*tokens):
        # 为BERT输入中的'<CLS>'、'<SEP>'和'<SEP>'词元保留位置
        while len(p*tokens) + len(h*tokens) > self.max_len - 3:
            if len(p*tokens) > len(h*tokens):
                p_tokens.pop()
            else:
                h_tokens.pop()

    def **getitem**(self, idx):
        return (self.all*token*ids[idx], self.all_segments[idx],
                self.valid_lens[idx]), self.labels[idx]

    def **len**(self):
        return len(self.all*token*ids)
```

```{.python .input}
# @tab paddle
class SNLIBERTDataset(paddle.io.Dataset):
    def **init**(self, dataset, max_len, vocab=None):
        all*premise*hypothesis_tokens = [[
            p*tokens, h*tokens] for p*tokens, h*tokens in zip(
            *[d2l.tokenize([s.lower() for s in sentences])
              for sentences in dataset[:2]])]

        self.labels = paddle.to_tensor(dataset[2])
        self.vocab = vocab
        self.max*len = max*len
        (self.all*token*ids, self.all_segments,
         self.valid*lens) = self.*preprocess(all*premise*hypothesis_tokens)
        print('read ' + str(len(self.all*token*ids)) + ' examples')

    def *preprocess(self, all*premise*hypothesis*tokens):
        # pool = multiprocessing.Pool(1)  # 使用4个进程
        # out = pool.map(self.*mp*worker, all*premise*hypothesis_tokens)
        out = []
        for i in all*premise*hypothesis_tokens:
            tempOut = self.*mp*worker(i)
            out.append(tempOut)
        
        all*token*ids = [
            token*ids for token*ids, segments, valid_len in out]
        all*segments = [segments for token*ids, segments, valid_len in out]
        valid*lens = [valid*len for token*ids, segments, valid*len in out]
        return (paddle.to*tensor(all*token_ids, dtype='int64'),
                paddle.to*tensor(all*segments, dtype='int64'),
                paddle.to*tensor(valid*lens))

    def *mp*worker(self, premise*hypothesis*tokens):
        p*tokens, h*tokens = premise*hypothesis*tokens
        self.*truncate*pair*of*tokens(p*tokens, h*tokens)
        tokens, segments = d2l.get*tokens*and*segments(p*tokens, h_tokens)
        token_ids = self.vocab[tokens] + [self.vocab['<pad>']] \
                             * (self.max_len - len(tokens))
        segments = segments + [0] * (self.max_len - len(segments))
        valid_len = len(tokens)
        return token*ids, segments, valid*len

    def *truncate*pair*of*tokens(self, p*tokens, h*tokens):
        # 为BERT输入中的'<CLS>'、'<SEP>'和'<SEP>'词元保留位置
        while len(p*tokens) + len(h*tokens) > self.max_len - 3:
            if len(p*tokens) > len(h*tokens):
                p_tokens.pop()
            else:
                h_tokens.pop()

    def **getitem**(self, idx):
        return (self.all*token*ids[idx], self.all_segments[idx],
                self.valid_lens[idx]), self.labels[idx]

    def **len**(self):
        return len(self.all*token*ids)
```

下载完SNLI数据集后，我们通过实例化`SNLIBERTDataset`类来[**生成训练和测试样本**]。这些样本将在自然语言推断的训练和测试期间进行小批量读取。

```{.python .input}
# 如果出现显存不足错误，请减少“batch*size”。在原始的BERT模型中，max*len=512
batch*size, max*len, num*workers = 512, 128, d2l.get*dataloader_workers()
data*dir = d2l.download*extract('SNLI')
train*set = SNLIBERTDataset(d2l.read*snli(data*dir, True), max*len, vocab)
test*set = SNLIBERTDataset(d2l.read*snli(data*dir, False), max*len, vocab)
train*iter = gluon.data.DataLoader(train*set, batch_size, shuffle=True,
                                   num*workers=num*workers)
test*iter = gluon.data.DataLoader(test*set, batch_size,
                                  num*workers=num*workers)
```

```{.python .input}
# @tab pytorch
# 如果出现显存不足错误，请减少“batch*size”。在原始的BERT模型中，max*len=512
batch*size, max*len, num*workers = 512, 128, d2l.get*dataloader_workers()
data*dir = d2l.download*extract('SNLI')
train*set = SNLIBERTDataset(d2l.read*snli(data*dir, True), max*len, vocab)
test*set = SNLIBERTDataset(d2l.read*snli(data*dir, False), max*len, vocab)
train*iter = torch.utils.data.DataLoader(train*set, batch_size, shuffle=True,
                                   num*workers=num*workers)
test*iter = torch.utils.data.DataLoader(test*set, batch_size,
                                  num*workers=num*workers)
```

```{.python .input}
# @tab paddle
# 如果出现显存不足错误，请减少“batch*size”。在原始的BERT模型中，max*len=512
batch*size, max*len, num*workers = 512, 128, d2l.get*dataloader_workers()
data*dir = d2l.download*extract('SNLI')
train*set = SNLIBERTDataset(d2l.read*snli(data*dir, True), max*len, vocab)
test*set = SNLIBERTDataset(d2l.read*snli(data*dir, False), max*len, vocab)
train*iter = paddle.io.DataLoader(train*set, batch*size=batch*size, shuffle=True, return_list=True)
test*iter = paddle.io.DataLoader(test*set, batch*size=batch*size, return_list=True)
```

# # 微调BERT

如 :numref:`fig_bert-two-seqs`所示，用于自然语言推断的微调BERT只需要一个额外的多层感知机，该多层感知机由两个全连接层组成（请参见下面`BERTClassifier`类中的`self.hidden`和`self.output`）。[**这个多层感知机将特殊的“&lt;cls&gt;”词元**]的BERT表示进行了转换，该词元同时编码前提和假设的信息(**为自然语言推断的三个输出**)：蕴涵、矛盾和中性。

```{.python .input}
class BERTClassifier(nn.Block):
    def **init**(self, bert):
        super(BERTClassifier, self).**init**()
        self.encoder = bert.encoder
        self.hidden = bert.hidden
        self.output = nn.Dense(3)

    def forward(self, inputs):
        tokens*X, segments*X, valid*lens*x = inputs
        encoded*X = self.encoder(tokens*X, segments*X, valid*lens_x)
        return self.output(self.hidden(encoded_X[:, 0, :]))
```

```{.python .input}
# @tab pytorch
class BERTClassifier(nn.Module):
    def **init**(self, bert):
        super(BERTClassifier, self).**init**()
        self.encoder = bert.encoder
        self.hidden = bert.hidden
        self.output = nn.Linear(256, 3)

    def forward(self, inputs):
        tokens*X, segments*X, valid*lens*x = inputs
        encoded*X = self.encoder(tokens*X, segments*X, valid*lens_x)
        return self.output(self.hidden(encoded_X[:, 0, :]))
```

```{.python .input}
# @tab paddle
class BERTClassifier(nn.Layer):
    def **init**(self, bert):
        super(BERTClassifier, self).**init**()
        self.encoder = bert.encoder
        self.hidden = bert.hidden
        self.output = nn.Linear(256, 3)

    def forward(self, inputs):
        tokens*X, segments*X, valid*lens*x = inputs
        encoded*X = self.encoder(tokens*X, segments*X, valid*lens_x.squeeze(1))
        return self.output(self.hidden(encoded_X[:, 0, :]))
```

在下文中，预训练的BERT模型`bert`被送到用于下游应用的`BERTClassifier`实例`net`中。在BERT微调的常见实现中，只有额外的多层感知机（`net.output`）的输出层的参数将从零开始学习。预训练BERT编码器（`net.encoder`）和额外的多层感知机的隐藏层（`net.hidden`）的所有参数都将进行微调。

```{.python .input}
net = BERTClassifier(bert)
net.output.initialize(ctx=devices)
```

```{.python .input}
# @tab pytorch, paddle
net = BERTClassifier(bert)
```

回想一下，在 :numref:`sec_bert`中，`MaskLM`类和`NextSentencePred`类在其使用的多层感知机中都有一些参数。这些参数是预训练BERT模型`bert`中参数的一部分，因此是`net`中的参数的一部分。然而，这些参数仅用于计算预训练过程中的遮蔽语言模型损失和下一句预测损失。这两个损失函数与微调下游应用无关，因此当BERT微调时，`MaskLM`和`NextSentencePred`中采用的多层感知机的参数不会更新（陈旧的，staled）。

为了允许具有陈旧梯度的参数，标志`ignore*stale*grad=True`在`step`函数`d2l.train*batch*ch13`中被设置。我们通过该函数使用SNLI的训练集（`train*iter`）和测试集（`test*iter`）对`net`模型进行训练和评估。由于计算资源有限，[**训练**]和测试精度可以进一步提高：我们把对它的讨论留在练习中。

```{.python .input}
lr, num_epochs = 1e-4, 5
trainer = gluon.Trainer(net.collect*params(), 'adam', {'learning*rate': lr})
loss = gluon.loss.SoftmaxCrossEntropyLoss()
d2l.train*ch13(net, train*iter, test*iter, loss, trainer, num*epochs, 
    devices, d2l.split*batch*multi_inputs)
```

```{.python .input}
# @tab pytorch
lr, num_epochs = 1e-4, 5
trainer = torch.optim.Adam(net.parameters(), lr=lr)
loss = nn.CrossEntropyLoss(reduction='none')
d2l.train*ch13(net, train*iter, test*iter, loss, trainer, num*epochs, 
    devices)
```

```{.python .input}
# @tab paddle
lr, num_epochs = 1e-4, 5
trainer = paddle.optimizer.Adam(learning_rate=lr, parameters=net.parameters())
loss = nn.CrossEntropyLoss(reduction='none')
d2l.train*ch13(net, train*iter, test*iter, loss, trainer, num*epochs,
    devices)
```

# # 小结

* 我们可以针对下游应用对预训练的BERT模型进行微调，例如在SNLI数据集上进行自然语言推断。
* 在微调过程中，BERT模型成为下游应用模型的一部分。仅与训练前损失相关的参数在微调期间不会更新。

# # 练习

1. 如果您的计算资源允许，请微调一个更大的预训练BERT模型，该模型与原始的BERT基础模型一样大。修改`load*pretrained*model`函数中的参数设置：将“bert.small”替换为“bert.base”，将`num*hiddens=256`、`ffn*num*hiddens=512`、`num*heads=4`和`num_layers=2`的值分别增加到768、3072、12和12。通过增加微调迭代轮数（可能还会调优其他超参数），你可以获得高于0.86的测试精度吗？
1. 如何根据一对序列的长度比值截断它们？将此对截断方法与`SNLIBERTDataset`类中使用的方法进行比较。它们的利弊是什么？

:begin_tab:`mxnet`
[Discussions](https://discuss.d2l.ai/t/5715)
:end_tab:

:begin_tab:`pytorch`
[Discussions](https://discuss.d2l.ai/t/5718)
:end_tab:

:begin_tab:`paddle`
[Discussions](https://discuss.d2l.ai/t/11831)
:end_tab:
