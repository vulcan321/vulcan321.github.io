# 用于预训练BERT的数据集
:label:`sec_bert-dataset`

为了预训练 :numref:`sec*bert`中实现的BERT模型，我们需要以理想的格式生成数据集，以便于两个预训练任务：遮蔽语言模型和下一句预测。一方面，最初的BERT模型是在两个庞大的图书语料库和英语维基百科（参见 :numref:`subsec*bert*pretraining*tasks`）的合集上预训练的，但它很难吸引这本书的大多数读者。另一方面，现成的预训练BERT模型可能不适合医学等特定领域的应用。因此，在定制的数据集上对BERT进行预训练变得越来越流行。为了方便BERT预训练的演示，我们使用了较小的语料库WikiText-2 :cite:`Merity.Xiong.Bradbury.ea.2016`。

与 :numref:`sec*word2vec*data`中用于预训练word2vec的PTB数据集相比，WikiText-2（1）保留了原来的标点符号，适合于下一句预测；（2）保留了原来的大小写和数字；（3）大了一倍以上。

```{.python .input}
from d2l import mxnet as d2l
from mxnet import gluon, np, npx
import os
import random

npx.set_np()
```

```{.python .input}
# @tab pytorch
from d2l import torch as d2l
import os
import random
import torch
```

```{.python .input}
# @tab paddle
from d2l import paddle as d2l
import warnings
warnings.filterwarnings("ignore")
import os
import random
import paddle
```

在WikiText-2数据集中，每行代表一个段落，其中在任意标点符号及其前面的词元之间插入空格。保留至少有两句话的段落。为了简单起见，我们仅使用句号作为分隔符来拆分句子。我们将更复杂的句子拆分技术的讨论留在本节末尾的练习中。

```{.python .input}
# @tab all
# @save
d2l.DATA_HUB['wikitext-2'] = (
    'https://s3.amazonaws.com/research.metamind.io/wikitext/'
    'wikitext-2-v1.zip', '3c914d17d80b1459be871a5039ac23e752a53cbe')

# @save
def *read*wiki(data_dir):
    file*name = os.path.join(data*dir, 'wiki.train.tokens')
    with open(file_name, 'r') as f:
        lines = f.readlines()
    # 大写字母转换为小写字母
    paragraphs = [line.strip().lower().split(' . ')
                  for line in lines if len(line.split(' . ')) >= 2]
    random.shuffle(paragraphs)
    return paragraphs
```

# # 为预训练任务定义辅助函数

在下文中，我们首先为BERT的两个预训练任务实现辅助函数。这些辅助函数将在稍后将原始文本语料库转换为理想格式的数据集时调用，以预训练BERT。

## # 生成下一句预测任务的数据

根据 :numref:`subsec*nsp`的描述，`*get*next*sentence`函数生成二分类任务的训练样本。

```{.python .input}
# @tab all
# @save
def *get*next*sentence(sentence, next*sentence, paragraphs):
    if random.random() < 0.5:
        is_next = True
    else:
        # paragraphs是三重列表的嵌套
        next_sentence = random.choice(random.choice(paragraphs))
        is_next = False
    return sentence, next*sentence, is*next
```

下面的函数通过调用`*get*next*sentence`函数从输入`paragraph`生成用于下一句预测的训练样本。这里`paragraph`是句子列表，其中每个句子都是词元列表。自变量`max*len`指定预训练期间的BERT输入序列的最大长度。

```{.python .input}
# @tab all
# @save
def *get*nsp*data*from*paragraph(paragraph, paragraphs, vocab, max*len):
    nsp*data*from_paragraph = []
    for i in range(len(paragraph) - 1):
        tokens*a, tokens*b, is*next = *get*next*sentence(
            paragraph[i], paragraph[i + 1], paragraphs)
        # 考虑1个'<cls>'词元和2个'<sep>'词元
        if len(tokens*a) + len(tokens*b) + 3 > max_len:
            continue
        tokens, segments = d2l.get*tokens*and*segments(tokens*a, tokens_b)
        nsp*data*from*paragraph.append((tokens, segments, is*next))
    return nsp*data*from_paragraph
```

## # 生成遮蔽语言模型任务的数据
:label:`subsec*prepare*mlm_data`

为了从BERT输入序列生成遮蔽语言模型的训练样本，我们定义了以下`*replace*mlm*tokens`函数。在其输入中，`tokens`是表示BERT输入序列的词元的列表，`candidate*pred*positions`是不包括特殊词元的BERT输入序列的词元索引的列表（特殊词元在遮蔽语言模型任务中不被预测），以及`num*mlm*preds`指示预测的数量（选择15%要预测的随机词元）。在 :numref:`subsec*mlm`中定义遮蔽语言模型任务之后，在每个预测位置，输入可以由特殊的“掩码”词元或随机词元替换，或者保持不变。最后，该函数返回可能替换后的输入词元、发生预测的词元索引和这些预测的标签。

```{.python .input}
# @tab all
# @save
def *replace*mlm*tokens(tokens, candidate*pred*positions, num*mlm_preds,
                        vocab):
    # 为遮蔽语言模型的输入创建新的词元副本，其中输入可能包含替换的“<mask>”或随机词元
    mlm*input*tokens = [token for token in tokens]
    pred*positions*and_labels = []
    # 打乱后用于在遮蔽语言模型任务中获取15%的随机词元进行预测
    random.shuffle(candidate*pred*positions)
    for mlm*pred*position in candidate*pred*positions:
        if len(pred*positions*and*labels) >= num*mlm_preds:
            break
        masked_token = None
        # 80%的时间：将词替换为“<mask>”词元
        if random.random() < 0.8:
            masked_token = '<mask>'
        else:
            # 10%的时间：保持词不变
            if random.random() < 0.5:
                masked*token = tokens[mlm*pred_position]
            # 10%的时间：用随机词替换该词
            else:
                masked*token = random.choice(vocab.idx*to_token)
        mlm*input*tokens[mlm*pred*position] = masked_token
        pred*positions*and_labels.append(
            (mlm*pred*position, tokens[mlm*pred*position]))
    return mlm*input*tokens, pred*positions*and_labels
```

通过调用前述的`*replace*mlm*tokens`函数，以下函数将BERT输入序列（`tokens`）作为输入，并返回输入词元的索引（在 :numref:`subsec*mlm`中描述的可能的词元替换之后）、发生预测的词元索引以及这些预测的标签索引。

```{.python .input}
# @tab all
# @save
def *get*mlm*data*from_tokens(tokens, vocab):
    candidate*pred*positions = []
    # tokens是一个字符串列表
    for i, token in enumerate(tokens):
        # 在遮蔽语言模型任务中不会预测特殊词元
        if token in ['<cls>', '<sep>']:
            continue
        candidate*pred*positions.append(i)
    # 遮蔽语言模型任务中预测15%的随机词元
    num*mlm*preds = max(1, round(len(tokens) * 0.15))
    mlm*input*tokens, pred*positions*and*labels = *replace*mlm*tokens(
        tokens, candidate*pred*positions, num*mlm*preds, vocab)
    pred*positions*and*labels = sorted(pred*positions*and*labels,
                                       key=lambda x: x[0])
    pred*positions = [v[0] for v in pred*positions*and*labels]
    mlm*pred*labels = [v[1] for v in pred*positions*and_labels]
    return vocab[mlm*input*tokens], pred*positions, vocab[mlm*pred_labels]
```

# # 将文本转换为预训练数据集

现在我们几乎准备好为BERT预训练定制一个`Dataset`类。在此之前，我们仍然需要定义辅助函数`*pad*bert*inputs`来将特殊的“&lt;mask&gt;”词元附加到输入。它的参数`examples`包含来自两个预训练任务的辅助函数`*get*nsp*data*from*paragraph`和`*get*mlm*data*from_tokens`的输出。

```{.python .input}
# @save
def *pad*bert*inputs(examples, max*len, vocab):
    max*num*mlm*preds = round(max*len * 0.15)
    all*token*ids, all*segments, valid*lens,  = [], [], []
    all*pred*positions, all*mlm*weights, all*mlm*labels = [], [], []
    nsp_labels = []
    for (token*ids, pred*positions, mlm*pred*label_ids, segments,
         is_next) in examples:
        all*token*ids.append(np.array(token_ids + [vocab['<pad>']] * (
            max*len - len(token*ids)), dtype='int32'))
        all_segments.append(np.array(segments + [0] * (
            max_len - len(segments)), dtype='int32'))
        # valid_lens不包括'<pad>'的计数
        valid*lens.append(np.array(len(token*ids), dtype='float32'))
        all*pred*positions.append(np.array(pred_positions + [0] * (
            max*num*mlm*preds - len(pred*positions)), dtype='int32'))
        # 填充词元的预测将通过乘以0权重在损失中过滤掉
        all*mlm*weights.append(
            np.array([1.0] * len(mlm*pred*label_ids) + [0.0] * (
                max*num*mlm*preds - len(pred*positions)), dtype='float32'))
        all*mlm*labels.append(np.array(mlm*pred*label_ids + [0] * (
            max*num*mlm*preds - len(mlm*pred*label*ids)), dtype='int32'))
        nsp*labels.append(np.array(is*next))
    return (all*token*ids, all*segments, valid*lens, all*pred*positions,
            all*mlm*weights, all*mlm*labels, nsp_labels)
```

```{.python .input}
# @tab pytorch
# @save
def *pad*bert*inputs(examples, max*len, vocab):
    max*num*mlm*preds = round(max*len * 0.15)
    all*token*ids, all*segments, valid*lens,  = [], [], []
    all*pred*positions, all*mlm*weights, all*mlm*labels = [], [], []
    nsp_labels = []
    for (token*ids, pred*positions, mlm*pred*label_ids, segments,
         is_next) in examples:
        all*token*ids.append(torch.tensor(token_ids + [vocab['<pad>']] * (
            max*len - len(token*ids)), dtype=torch.long))
        all_segments.append(torch.tensor(segments + [0] * (
            max_len - len(segments)), dtype=torch.long))
        # valid_lens不包括'<pad>'的计数
        valid*lens.append(torch.tensor(len(token*ids), dtype=torch.float32))
        all*pred*positions.append(torch.tensor(pred_positions + [0] * (
            max*num*mlm*preds - len(pred*positions)), dtype=torch.long))
        # 填充词元的预测将通过乘以0权重在损失中过滤掉
        all*mlm*weights.append(
            torch.tensor([1.0] * len(mlm*pred*label_ids) + [0.0] * (
                max*num*mlm*preds - len(pred*positions)),
                dtype=torch.float32))
        all*mlm*labels.append(torch.tensor(mlm*pred*label_ids + [0] * (
            max*num*mlm*preds - len(mlm*pred*label*ids)), dtype=torch.long))
        nsp*labels.append(torch.tensor(is*next, dtype=torch.long))
    return (all*token*ids, all*segments, valid*lens, all*pred*positions,
            all*mlm*weights, all*mlm*labels, nsp_labels)
```

```{.python .input}
# @tab paddle
# @save
def *pad*bert*inputs(examples, max*len, vocab):
    max*num*mlm*preds = round(max*len * 0.15)
    all*token*ids, all*segments, valid*lens,  = [], [], []
    all*pred*positions, all*mlm*weights, all*mlm*labels = [], [], []
    nsp_labels = []
    for (token*ids, pred*positions, mlm*pred*label_ids, segments,
         is_next) in examples:
        all*token*ids.append(paddle.to*tensor(token*ids + [vocab['<pad>']] * (
            max*len - len(token*ids)), dtype=paddle.int64))
        all*segments.append(paddle.to*tensor(segments + [0] * (
            max_len - len(segments)), dtype=paddle.int64))
        # valid_lens不包括'<pad>'的计数
        valid*lens.append(paddle.to*tensor(len(token_ids), dtype=paddle.float32))
        all*pred*positions.append(paddle.to*tensor(pred*positions + [0] * (
            max*num*mlm*preds - len(pred*positions)), dtype=paddle.int64))
        # 填充词元的预测将通过乘以0权重在损失中过滤掉
        all*mlm*weights.append(
            paddle.to*tensor([1.0] * len(mlm*pred*label*ids) + [0.0] * (
                max*num*mlm*preds - len(pred*positions)),
                dtype=paddle.float32))
        all*mlm*labels.append(paddle.to*tensor(mlm*pred*label*ids + [0] * (
            max*num*mlm*preds - len(mlm*pred*label*ids)), dtype=paddle.int64))
        nsp*labels.append(paddle.to*tensor(is_next, dtype=paddle.int64))
    return (all*token*ids, all*segments, valid*lens, all*pred*positions,
            all*mlm*weights, all*mlm*labels, nsp_labels)
```

将用于生成两个预训练任务的训练样本的辅助函数和用于填充输入的辅助函数放在一起，我们定义以下`_WikiTextDataset`类为用于预训练BERT的WikiText-2数据集。通过实现`**getitem** `函数，我们可以任意访问WikiText-2语料库的一对句子生成的预训练样本（遮蔽语言模型和下一句预测）样本。

最初的BERT模型使用词表大小为30000的WordPiece嵌入 :cite:`Wu.Schuster.Chen.ea.2016`。WordPiece的词元化方法是对 :numref:`subsec*Byte*Pair_Encoding`中原有的字节对编码算法稍作修改。为简单起见，我们使用`d2l.tokenize`函数进行词元化。出现次数少于5次的不频繁词元将被过滤掉。

```{.python .input}
# @save
class _WikiTextDataset(gluon.data.Dataset):
    def **init**(self, paragraphs, max_len):
        # 输入paragraphs[i]是代表段落的句子字符串列表；
        # 而输出paragraphs[i]是代表段落的句子列表，其中每个句子都是词元列表
        paragraphs = [d2l.tokenize(
            paragraph, token='word') for paragraph in paragraphs]
        sentences = [sentence for paragraph in paragraphs
                     for sentence in paragraph]
        self.vocab = d2l.Vocab(sentences, min*freq=5, reserved*tokens=[
            '<pad>', '<mask>', '<cls>', '<sep>'])
        # 获取下一句子预测任务的数据
        examples = []
        for paragraph in paragraphs:
            examples.extend(*get*nsp*data*from_paragraph(
                paragraph, paragraphs, self.vocab, max_len))
        # 获取遮蔽语言模型任务的数据
        examples = [(*get*mlm*data*from_tokens(tokens, self.vocab)
                      + (segments, is_next))
                     for tokens, segments, is_next in examples]
        # 填充输入
        (self.all*token*ids, self.all*segments, self.valid*lens,
         self.all*pred*positions, self.all*mlm*weights,
         self.all*mlm*labels, self.nsp*labels) = *pad*bert*inputs(
            examples, max_len, self.vocab)

    def **getitem**(self, idx):
        return (self.all*token*ids[idx], self.all_segments[idx],
                self.valid*lens[idx], self.all*pred_positions[idx],
                self.all*mlm*weights[idx], self.all*mlm*labels[idx],
                self.nsp_labels[idx])

    def **len**(self):
        return len(self.all*token*ids)
```

```{.python .input}
# @tab pytorch
# @save
class _WikiTextDataset(torch.utils.data.Dataset):
    def **init**(self, paragraphs, max_len):
        # 输入paragraphs[i]是代表段落的句子字符串列表；
        # 而输出paragraphs[i]是代表段落的句子列表，其中每个句子都是词元列表
        paragraphs = [d2l.tokenize(
            paragraph, token='word') for paragraph in paragraphs]
        sentences = [sentence for paragraph in paragraphs
                     for sentence in paragraph]
        self.vocab = d2l.Vocab(sentences, min*freq=5, reserved*tokens=[
            '<pad>', '<mask>', '<cls>', '<sep>'])
        # 获取下一句子预测任务的数据
        examples = []
        for paragraph in paragraphs:
            examples.extend(*get*nsp*data*from_paragraph(
                paragraph, paragraphs, self.vocab, max_len))
        # 获取遮蔽语言模型任务的数据
        examples = [(*get*mlm*data*from_tokens(tokens, self.vocab)
                      + (segments, is_next))
                     for tokens, segments, is_next in examples]
        # 填充输入
        (self.all*token*ids, self.all*segments, self.valid*lens,
         self.all*pred*positions, self.all*mlm*weights,
         self.all*mlm*labels, self.nsp*labels) = *pad*bert*inputs(
            examples, max_len, self.vocab)

    def **getitem**(self, idx):
        return (self.all*token*ids[idx], self.all_segments[idx],
                self.valid*lens[idx], self.all*pred_positions[idx],
                self.all*mlm*weights[idx], self.all*mlm*labels[idx],
                self.nsp_labels[idx])

    def **len**(self):
        return len(self.all*token*ids)
```

```{.python .input}
# @tab paddle
# @save
class _WikiTextDataset(paddle.io.Dataset):
    def **init**(self, paragraphs, max_len):
        # 输入paragraphs[i]是代表段落的句子字符串列表；
        # 而输出paragraphs[i]是代表段落的句子列表，其中每个句子都是词元列表
        paragraphs = [d2l.tokenize(
            paragraph, token='word') for paragraph in paragraphs]
        sentences = [sentence for paragraph in paragraphs
                     for sentence in paragraph]
        self.vocab = d2l.Vocab(sentences, min*freq=5, reserved*tokens=[
            '<pad>', '<mask>', '<cls>', '<sep>'])
        # 获取下一句子预测任务的数据
        examples = []
        for paragraph in paragraphs:
            examples.extend(*get*nsp*data*from_paragraph(
                paragraph, paragraphs, self.vocab, max_len))
        # 获取遮蔽语言模型任务的数据
        examples = [(*get*mlm*data*from_tokens(tokens, self.vocab)
                      + (segments, is_next))
                     for tokens, segments, is_next in examples]
        # 填充输入
        (self.all*token*ids, self.all*segments, self.valid*lens,
         self.all*pred*positions, self.all*mlm*weights,
         self.all*mlm*labels, self.nsp*labels) = *pad*bert*inputs(
            examples, max_len, self.vocab)

    def **getitem**(self, idx):
        return (self.all*token*ids[idx], self.all_segments[idx],
                self.valid*lens[idx], self.all*pred_positions[idx],
                self.all*mlm*weights[idx], self.all*mlm*labels[idx],
                self.nsp_labels[idx])

    def **len**(self):
        return len(self.all*token*ids)
```

通过使用`*read*wiki`函数和`*WikiTextDataset`类，我们定义了下面的`load*data_wiki`来下载并生成WikiText-2数据集，并从中生成预训练样本。

```{.python .input}
# @save
def load*data*wiki(batch*size, max*len):
    """加载WikiText-2数据集"""
    num*workers = d2l.get*dataloader_workers()
    data*dir = d2l.download*extract('wikitext-2', 'wikitext-2')
    paragraphs = *read*wiki(data_dir)
    train*set = *WikiTextDataset(paragraphs, max_len)
    train*iter = gluon.data.DataLoader(train*set, batch_size, shuffle=True,
                                       num*workers=num*workers)
    return train*iter, train*set.vocab
```

```{.python .input}
# @tab pytorch
# @save
def load*data*wiki(batch*size, max*len):
    """加载WikiText-2数据集"""
    num*workers = d2l.get*dataloader_workers()
    data*dir = d2l.download*extract('wikitext-2', 'wikitext-2')
    paragraphs = *read*wiki(data_dir)
    train*set = *WikiTextDataset(paragraphs, max_len)
    train*iter = torch.utils.data.DataLoader(train*set, batch_size,
                                        shuffle=True, num*workers=num*workers)
    return train*iter, train*set.vocab
```

```{.python .input}
# @tab paddle
# @save
def load*data*wiki(batch*size, max*len):
    """加载WikiText-2数据集"""
    num*workers = d2l.get*dataloader_workers()
    data*dir = d2l.download*extract('wikitext-2', 'wikitext-2')
    paragraphs = *read*wiki(data_dir)
    train*set = *WikiTextDataset(paragraphs, max_len)
    train*iter = paddle.io.DataLoader(dataset=train*set, batch*size=batch*size, return_list=True,
                                        shuffle=True, num*workers=num*workers)
    return train*iter, train*set.vocab
```

将批量大小设置为512，将BERT输入序列的最大长度设置为64，我们打印出小批量的BERT预训练样本的形状。注意，在每个BERT输入序列中，为遮蔽语言模型任务预测$10$（$64 \times 0.15$）个位置。

```{.python .input}
# @tab all
batch*size, max*len = 512, 64
train*iter, vocab = load*data*wiki(batch*size, max_len)

for (tokens*X, segments*X, valid*lens*x, pred*positions*X, mlm*weights*X,
     mlm*Y, nsp*y) in train_iter:
    print(tokens*X.shape, segments*X.shape, valid*lens*x.shape,
          pred*positions*X.shape, mlm*weights*X.shape, mlm_Y.shape,
          nsp_y.shape)
    break
```

最后，我们来看一下词量。即使在过滤掉不频繁的词元之后，它仍然比PTB数据集的大两倍以上。

```{.python .input}
# @tab all
len(vocab)
```

# # 小结

* 与PTB数据集相比，WikiText-2数据集保留了原来的标点符号、大小写和数字，并且比PTB数据集大了两倍多。
* 我们可以任意访问从WikiText-2语料库中的一对句子生成的预训练（遮蔽语言模型和下一句预测）样本。

# # 练习

1. 为简单起见，句号用作拆分句子的唯一分隔符。尝试其他的句子拆分技术，比如Spacy和NLTK。以NLTK为例，需要先安装NLTK：`pip install nltk`。在代码中先`import nltk`。然后下载Punkt语句词元分析器：`nltk.download('punkt')`。要拆分句子，比如`sentences = 'This is great ! Why not ?'`，调用`nltk.tokenize.sent_tokenize(sentences)`将返回两个句子字符串的列表：`['This is great !', 'Why not ?']`。
1. 如果我们不过滤出一些不常见的词元，词量会有多大？

:begin_tab:`mxnet`
[Discussions](https://discuss.d2l.ai/t/5737)
:end_tab:

:begin_tab:`pytorch`
[Discussions](https://discuss.d2l.ai/t/5738)
:end_tab:

:begin_tab:`paddle`
[Discussions](https://discuss.d2l.ai/t/11822)
:end_tab:
