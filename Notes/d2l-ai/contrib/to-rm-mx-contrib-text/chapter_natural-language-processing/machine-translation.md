# 机器翻译

机器翻译是指将一段文本从一种语言自动翻译到另一种语言。因为一段文本序列在不同语言中的长度不一定相同，所以我们使用机器翻译为例来介绍编码器—解码器和注意力机制的应用。

# # 读取和预处理数据集

我们先定义一些特殊符号。其中“&lt;pad&gt;”（padding）符号用来添加在较短序列后，直到每个序列等长，而“&lt;bos&gt;”和“&lt;eos&gt;”符号分别表示序列的开始和结束。

```{.python .input  n=2}
import collections
from d2lzh import text
import io
import math
from mxnet import autograd, gluon, init, nd
from mxnet.gluon import data as gdata, loss as gloss, nn, rnn

PAD, BOS, EOS = '<pad>', '<bos>', '<eos>'
```

接着定义两个辅助函数对后面读取的数据进行预处理。

```{.python .input}
# 将一个序列中所有的词记录在all_tokens中以便之后构造词典，然后在该序列后面添加PAD直到序列
# 长度变为max*seq*len，然后将序列保存在all_seqs中
def process*one*seq(seq*tokens, all*tokens, all*seqs, max*seq_len):
    all*tokens.extend(seq*tokens)
    seq*tokens += [EOS] + [PAD] * (max*seq*len - len(seq*tokens) - 1)
    all*seqs.append(seq*tokens)

# 使用所有的词来构造词典。并将所有序列中的词变换为词索引后构造NDArray实例
def build*data(all*tokens, all_seqs):
    vocab = text.vocab.Vocabulary(collections.Counter(all_tokens),
                                  reserved_tokens=[PAD, BOS, EOS])
    indices = [vocab.to*indices(seq) for seq in all*seqs]
    return vocab, nd.array(indices)
```

为了演示方便，我们在这里使用一个很小的法语—英语数据集。在这个数据集里，每一行是一对法语句子和它对应的英语句子，中间使用`'\t'`隔开。在读取数据时，我们在句末附上“&lt;eos&gt;”符号，并可能通过添加“&lt;pad&gt;”符号使每个序列的长度均为`max*seq*len`。我们为法语词和英语词分别创建词典。法语词的索引和英语词的索引相互独立。

```{.python .input  n=31}
def read*data(max*seq_len):
    # in和out分别是input和output的缩写
    in*tokens, out*tokens, in*seqs, out*seqs = [], [], [], []
    with io.open('../data/fr-en-small.txt') as f:
        lines = f.readlines()
    for line in lines:
        in*seq, out*seq = line.rstrip().split('\t')
        in*seq*tokens, out*seq*tokens = in*seq.split(' '), out*seq.split(' ')
        if max(len(in*seq*tokens), len(out*seq*tokens)) > max*seq*len - 1:
            continue  # 如果加上EOS后长于max*seq*len，则忽略掉此样本
        process*one*seq(in*seq*tokens, in*tokens, in*seqs, max*seq*len)
        process*one*seq(out*seq*tokens, out*tokens, out*seqs, max*seq*len)
    in*vocab, in*data = build*data(in*tokens, in_seqs)
    out*vocab, out*data = build*data(out*tokens, out_seqs)
    return in*vocab, out*vocab, gdata.ArrayDataset(in*data, out*data)
```

将序列的最大长度设成7，然后查看读取到的第一个样本。该样本分别包含法语词索引序列和英语词索引序列。

```{.python .input  n=181}
max*seq*len = 7
in*vocab, out*vocab, dataset = read*data(max*seq_len)
dataset[0]
```

# # 含注意力机制的编码器—解码器

我们将使用含注意力机制的编码器—解码器来将一段简短的法语翻译成英语。下面我们来介绍模型的实现。

## # 编码器

在编码器中，我们将输入语言的词索引通过词嵌入层得到词的表征，然后输入到一个多层门控循环单元中。正如我们在[“循环神经网络的简洁实现”](../chapter_recurrent-neural-networks/rnn-gluon.md)一节提到的，Gluon的`rnn.GRU`实例在前向计算后也会分别返回输出和最终时间步的多层隐状态。其中的输出指的是最后一层的隐藏层在各个时间步的隐状态，并不涉及输出层计算。注意力机制将这些输出作为键项和值项。

```{.python .input  n=165}
class Encoder(nn.Block):
    def **init**(self, vocab*size, embed*size, num*hiddens, num*layers,
                 drop_prob=0, **kwargs):
        super(Encoder, self).**init**(**kwargs)
        self.embedding = nn.Embedding(vocab*size, embed*size)
        self.rnn = rnn.GRU(num*hiddens, num*layers, dropout=drop_prob)

    def forward(self, inputs, state):
        # 输入形状是(批量大小, 时间步数)。将输出互换样本维和时间步维
        embedding = self.embedding(inputs).swapaxes(0, 1)
        return self.rnn(embedding, state)

    def begin_state(self, *args, **kwargs):
        return self.rnn.begin_state(*args, **kwargs)
```

下面我们来创建一个批量大小为4、时间步数为7的小批量序列输入。设门控循环单元的隐藏层个数为2，隐藏单元个数为16。编码器对该输入执行前向计算后返回的输出形状为(时间步数, 批量大小, 隐藏单元个数)。门控循环单元在最终时间步的多层隐状态的形状为(隐藏层个数, 批量大小, 隐藏单元个数)。对门控循环单元来说，`state`列表中只含一个元素，即隐状态；如果使用长短期记忆，`state`列表中还将包含另一个元素，即记忆细胞。

```{.python .input  n=166}
encoder = Encoder(vocab*size=10, embed*size=8, num*hiddens=16, num*layers=2)
encoder.initialize()
output, state = encoder(nd.zeros((4, 7)), encoder.begin*state(batch*size=4))
output.shape, state[0].shape
```

## # 注意力机制

在介绍如何实现注意力机制的矢量化计算之前，我们先了解一下`Dense`实例的`flatten`选项。当输入的维度大于2时，默认情况下，`Dense`实例会将除了第一维（样本维）以外的维度均视作需要仿射变换的特征维，并将输入自动转成行为样本、列为特征的二维矩阵。计算后，输出矩阵的形状为(样本数, 输出个数)。如果我们希望全连接层只对输入的最后一维做仿射变换，而保持其他维度上的形状不变，便需要将`Dense`实例的`flatten`选项设为`False`。在下面例子中，全连接层只对输入的最后一维做仿射变换，因此输出形状中只有最后一维变为全连接层的输出个数2。

```{.python .input}
dense = nn.Dense(2, flatten=False)
dense.initialize()
dense(nd.zeros((3, 5, 7))).shape
```

我们将实现[“注意力机制”](./attention.md)一节中定义的函数$a$：将输入连结后通过含单隐藏层的多层感知机变换。其中隐藏层的输入是解码器的隐状态与编码器在所有时间步上隐状态的一一连结，且使用tanh函数作为激活函数。输出层的输出个数为1。两个`Dense`实例均不使用偏置，且设`flatten=False`。其中函数$a$定义里向量$\boldsymbol{v}$的长度是一个超参数，即`attention_size`。

```{.python .input  n=167}
def attention*model(attention*size):
    model = nn.Sequential()
    model.add(nn.Dense(attention*size, activation='tanh', use*bias=False,
                       flatten=False),
              nn.Dense(1, use_bias=False, flatten=False))
    return model
```

注意力机制的输入包括查询项、键项和值项。设编码器和解码器的隐藏单元个数相同。这里的查询项为解码器在上一时间步的隐状态，形状为(批量大小, 隐藏单元个数)；键项和值项均为编码器在所有时间步的隐状态，形状为(时间步数, 批量大小, 隐藏单元个数)。注意力机制返回当前时间步的上下文变量，形状为(批量大小, 隐藏单元个数)。

```{.python .input  n=168}
def attention*forward(model, enc*states, dec_state):
    # 将解码器隐状态广播到和编码器隐状态形状相同后进行连结
    dec*states = nd.broadcast*axis(
        dec*state.expand*dims(0), axis=0, size=enc_states.shape[0])
    enc*and*dec*states = nd.concat(enc*states, dec_states, dim=2)
    e = model(enc*and*dec_states)  # 形状为(时间步数, 批量大小, 1)
    alpha = nd.softmax(e, axis=0)  # 在时间步维度做softmax运算
    return (alpha * enc_states).sum(axis=0)  # 返回上下文变量
```

在下面的例子中，编码器的时间步数为10，批量大小为4，编码器和解码器的隐藏单元个数均为8。注意力机制返回一个小批量的背景向量，每个背景向量的长度等于编码器的隐藏单元个数。因此输出的形状为(4, 8)。

```{.python .input  n=169}
seq*len, batch*size, num_hiddens = 10, 4, 8
model = attention_model(10)
model.initialize()
enc*states = nd.zeros((seq*len, batch*size, num*hiddens))
dec*state = nd.zeros((batch*size, num_hiddens))
attention*forward(model, enc*states, dec_state).shape
```

## # 含注意力机制的解码器

我们直接将编码器在最终时间步的隐状态作为解码器的初始隐状态。这要求编码器和解码器的循环神经网络使用相同的隐藏层个数和隐藏单元个数。

在解码器的前向计算中，我们先通过刚刚介绍的注意力机制计算得到当前时间步的背景向量。由于解码器的输入来自输出语言的词索引，我们将输入通过词嵌入层得到表征，然后和背景向量在特征维连结。我们将连结后的结果与上一时间步的隐状态通过门控循环单元计算出当前时间步的输出与隐状态。最后，我们将输出通过全连接层变换为有关各个输出词的预测，形状为(批量大小, 输出词典大小)。

```{.python .input  n=170}
class Decoder(nn.Block):
    def **init**(self, vocab*size, embed*size, num*hiddens, num*layers,
                 attention*size, drop*prob=0, **kwargs):
        super(Decoder, self).**init**(**kwargs)
        self.embedding = nn.Embedding(vocab*size, embed*size)
        self.attention = attention*model(attention*size)
        self.rnn = rnn.GRU(num*hiddens, num*layers, dropout=drop_prob)
        self.out = nn.Dense(vocab_size, flatten=False)

    def forward(self, cur*input, state, enc*states):
        # 使用注意力机制计算背景向量
        c = attention*forward(self.attention, enc*states, state[0][-1])
        # 将嵌入后的输入和背景向量在特征维连结
        input*and*c = nd.concat(self.embedding(cur_input), c, dim=1)
        # 为输入和背景向量的连结增加时间步维，时间步个数为1
        output, state = self.rnn(input*and*c.expand_dims(0), state)
        # 移除时间步维，输出形状为(批量大小, 输出词典大小)
        output = self.out(output).squeeze(axis=0)
        return output, state

    def begin*state(self, enc*state):
        # 直接将编码器最终时间步的隐状态作为解码器的初始隐状态
        return enc_state
```

# # 训练模型

我们先实现`batch_loss`函数计算一个小批量的损失。解码器在最初时间步的输入是特殊字符`BOS`。之后，解码器在某时间步的输入为样本输出序列在上一时间步的词，即强制教学。此外，同[“word2vec的实现”](word2vec-gluon.md)一节中的实现一样，我们在这里也使用掩码变量避免填充项对损失函数计算的影响。

```{.python .input}
def batch_loss(encoder, decoder, X, Y, loss):
    batch_size = X.shape[0]
    enc*state = encoder.begin*state(batch*size=batch*size)
    enc*outputs, enc*state = encoder(X, enc_state)
    # 初始化解码器的隐状态
    dec*state = decoder.begin*state(enc_state)
    # 解码器在最初时间步的输入是BOS
    dec*input = nd.array([out*vocab.token*to*idx[BOS]] * batch_size)
    # 我们将使用掩码变量mask来忽略掉标签为填充项PAD的损失
    mask, num*not*pad*tokens = nd.ones(shape=(batch*size,)), 0
    l = nd.array([0])
    for y in Y.T:
        dec*output, dec*state = decoder(dec*input, dec*state, enc_outputs)
        l = l + (mask * loss(dec_output, y)).sum()
        dec_input = y  # 使用强制教学
        num*not*pad_tokens += mask.sum().asscalar()
        # 当遇到EOS时，序列后面的词将均为PAD，相应位置的掩码设成0
        mask = mask * (y != out*vocab.token*to_idx[EOS])
    return l / num*not*pad_tokens
```

在训练函数中，我们需要同时迭代编码器和解码器的模型参数。

```{.python .input  n=188}
def train(encoder, decoder, dataset, lr, batch*size, num*epochs):
    encoder.initialize(init.Xavier(), force_reinit=True)
    decoder.initialize(init.Xavier(), force_reinit=True)
    enc*trainer = gluon.Trainer(encoder.collect*params(), 'adam',
                                {'learning_rate': lr})
    dec*trainer = gluon.Trainer(decoder.collect*params(), 'adam',
                                {'learning_rate': lr})
    loss = gloss.SoftmaxCrossEntropyLoss()
    data*iter = gdata.DataLoader(dataset, batch*size, shuffle=True)
    for epoch in range(num_epochs):
        l_sum = 0.0
        for X, Y in data_iter:
            with autograd.record():
                l = batch_loss(encoder, decoder, X, Y, loss)
            l.backward()
            enc_trainer.step(1)
            dec_trainer.step(1)
            l_sum += l.asscalar()
        if (epoch + 1) % 10 == 0:
            print("epoch %d, loss %.3f" % (epoch + 1, l*sum / len(data*iter)))
```

接下来，创建模型实例并设置超参数。然后，我们就可以训练模型了。

```{.python .input}
embed*size, num*hiddens, num_layers = 64, 64, 2
attention*size, drop*prob, lr, batch*size, num*epochs = 10, 0.5, 0.01, 2, 50
encoder = Encoder(len(in*vocab), embed*size, num*hiddens, num*layers,
                  drop_prob)
decoder = Decoder(len(out*vocab), embed*size, num*hiddens, num*layers,
                  attention*size, drop*prob)
train(encoder, decoder, dataset, lr, batch*size, num*epochs)
```

# # 预测不定长的序列

在[“束搜索”](beam-search.md)一节中我们介绍了3种方法来生成解码器在每个时间步的输出。这里我们实现最简单的贪婪搜索。

```{.python .input  n=177}
def translate(encoder, decoder, input*seq, max*seq_len):
    in*tokens = input*seq.split(' ')
    in*tokens += [EOS] + [PAD] * (max*seq*len - len(in*tokens) - 1)
    enc*input = nd.array([in*vocab.to*indices(in*tokens)])
    enc*state = encoder.begin*state(batch_size=1)
    enc*output, enc*state = encoder(enc*input, enc*state)
    dec*input = nd.array([out*vocab.token*to*idx[BOS]])
    dec*state = decoder.begin*state(enc_state)
    output_tokens = []
    for * in range(max*seq_len):
        dec*output, dec*state = decoder(dec*input, dec*state, enc_output)
        pred = dec_output.argmax(axis=1)
        pred*token = out*vocab.idx*to*token[int(pred.asscalar())]
        if pred_token == EOS:  # 当任一时间步搜索出EOS时，输出序列即完成
            break
        else:
            output*tokens.append(pred*token)
            dec_input = pred
    return output_tokens
```

简单测试一下模型。输入法语句子“ils regardent.”，翻译后的英语句子应该是“they are watching.”。

```{.python .input}
input_seq = 'ils regardent .'
translate(encoder, decoder, input*seq, max*seq_len)
```

# # 评价翻译结果

评价机器翻译结果通常使用BLEU（Bilingual Evaluation Understudy）[1]。对于模型预测序列中任意的子序列，BLEU考察这个子序列是否出现在标签序列中。

具体来说，设词数为$n$的子序列的精度为$p*n$。它是预测序列与标签序列匹配词数为$n$的子序列的数量与预测序列中词数为$n$的子序列的数量之比。举个例子，假设标签序列为$A$、$B$、$C$、$D$、$E$、$F$，预测序列为$A$、$B$、$B$、$C$、$D$，那么$p*1 = 4/5,\ p*2 = 3/4,\ p*3 = 1/3,\ p*4 = 0$。设$len*{\text{label}}$和$len_{\text{pred}}$分别为标签序列和预测序列的词数，那么，BLEU的定义为

$$ \exp\left(\min\left(0, 1 - \frac{len*{\text{label}}}{len*{\text{pred}}}\right)\right) \prod*{n=1}^k p*n^{1/2^n},$$

其中$k$是我们希望匹配的子序列的最大词数。可以看到当预测序列和标签序列完全一致时，BLEU为1。

因为匹配较长子序列比匹配较短子序列更难，BLEU对匹配较长子序列的精度赋予了更大权重。例如，当$p*n$固定在0.5时，随着$n$的增大，$0.5^{1/2} \approx 0.7, 0.5^{1/4} \approx 0.84, 0.5^{1/8} \approx 0.92, 0.5^{1/16} \approx 0.96$。另外，模型预测较短序列往往会得到较高$p*n$值。因此，上式中连乘项前面的系数是为了惩罚较短的输出而设的。举个例子，当$k=2$时，假设标签序列为$A$、$B$、$C$、$D$、$E$、$F$，而预测序列为$A$、$B$。虽然$p*1 = p*2 = 1$，但惩罚系数$\exp(1-6/2) \approx 0.14$，因此BLEU也接近0.14。

下面来实现BLEU的计算。

```{.python .input}
def bleu(pred*tokens, label*tokens, k):
    len*pred, len*label = len(pred*tokens), len(label*tokens)
    score = math.exp(min(0, 1 - len*label / len*pred))
    for n in range(1, k + 1):
        num*matches, label*subs = 0, collections.defaultdict(int)
        for i in range(len_label - n + 1):
            label*subs[''.join(label*tokens[i: i + n])] += 1
        for i in range(len_pred - n + 1):
            if label*subs[''.join(pred*tokens[i: i + n])] > 0:
                num_matches += 1
                label*subs[''.join(pred*tokens[i: i + n])] -= 1
        score *= math.pow(num*matches / (len*pred - n + 1), math.pow(0.5, n))
    return score
```

接下来，定义一个辅助打印函数。

```{.python .input}
def score(input*seq, label*seq, k):
    pred*tokens = translate(encoder, decoder, input*seq, max*seq*len)
    label*tokens = label*seq.split(' ')
    print('bleu %.3f, predict: %s' % (bleu(pred*tokens, label*tokens, k),
                                      ' '.join(pred_tokens)))
```

预测正确则分数为1。

```{.python .input}
score('ils regardent .', 'they are watching .', k=2)
```

测试一个不在训练集中的样本。

```{.python .input}
score('ils sont canadiens .', 'they are canadian .', k=2)
```

# # 小结

* 可以将编码器—解码器和注意力机制应用于机器翻译中。
* BLEU可以用来评价翻译结果。

# # 练习

* 如果编码器和解码器的隐藏单元个数不同或隐藏层个数不同，该如何改进解码器的隐状态的初始化方法？
* 在训练中，将强制教学替换为使用解码器在上一时间步的输出作为解码器在当前时间步的输入，结果有什么变化吗？
* 试着使用更大的翻译数据集来训练模型，如WMT [2] 和Tatoeba Project [3]。




# # 参考文献

[1] Papineni, K., Roukos, S., Ward, T., & Zhu, W. J. (2002, July). BLEU: a method for automatic evaluation of machine translation. In Proceedings of the 40th annual meeting on association for computational linguistics (pp. 311-318). Association for Computational Linguistics.

[2] WMT. http://www.statmt.org/wmt14/translation-task.html

[3] Tatoeba Project. http://www.manythings.org/anki/

# # 扫码直达[讨论区](https://discuss.gluon.ai/t/topic/4689)

![](../img/qr_machine-translation.svg)
