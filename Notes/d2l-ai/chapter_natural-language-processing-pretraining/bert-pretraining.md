# 预训练BERT
:label:`sec_bert-pretraining`

利用 :numref:`sec*bert`中实现的BERT模型和 :numref:`sec*bert-dataset`中从WikiText-2数据集生成的预训练样本，我们将在本节中在WikiText-2数据集上对BERT进行预训练。

```{.python .input}
from d2l import mxnet as d2l
from mxnet import autograd, gluon, init, np, npx

npx.set_np()
```

```{.python .input}
# @tab pytorch
from d2l import torch as d2l
import torch
from torch import nn
```

```{.python .input}
# @tab paddle
from d2l import paddle as d2l
import warnings
warnings.filterwarnings("ignore")
import paddle
from paddle import nn
```

首先，我们加载WikiText-2数据集作为小批量的预训练样本，用于遮蔽语言模型和下一句预测。批量大小是512，BERT输入序列的最大长度是64。注意，在原始BERT模型中，最大长度是512。

```{.python .input}
# @tab mxnet, pytorch
batch*size, max*len = 512, 64
train*iter, vocab = d2l.load*data*wiki(batch*size, max_len)
```

```{.python .input}
# @tab paddle
def load*data*wiki(batch*size, max*len):
    """加载WikiText-2数据集

    Defined in :numref:`subsec*prepare*mlm_data`"""
    data*dir = d2l.download*extract('wikitext-2', 'wikitext-2')
    paragraphs = d2l.*read*wiki(data_dir)
    train*set = d2l.*WikiTextDataset(paragraphs, max_len)
    train*iter = paddle.io.DataLoader(dataset=train*set, batch*size=batch*size, return_list=True,
                                        shuffle=True, num_workers=0)
    return train*iter, train*set.vocab

batch*size, max*len = 512, 64
train*iter, vocab = load*data*wiki(batch*size, max_len)
```

# # 预训练BERT

原始BERT :cite:`Devlin.Chang.Lee.ea.2018`有两个不同模型尺寸的版本。基本模型（$\text{BERT}*{\text{BASE}}$）使用12层（Transformer编码器块），768个隐藏单元（隐藏大小）和12个自注意头。大模型（$\text{BERT}*{\text{LARGE}}$）使用24层，1024个隐藏单元和16个自注意头。值得注意的是，前者有1.1亿个参数，后者有3.4亿个参数。为了便于演示，我们定义了一个小的BERT，使用了2层、128个隐藏单元和2个自注意头。

```{.python .input}
net = d2l.BERTModel(len(vocab), num*hiddens=128, ffn*num_hiddens=256,
                    num*heads=2, num*layers=2, dropout=0.2)
devices = d2l.try*all*gpus()
net.initialize(init.Xavier(), ctx=devices)
loss = gluon.loss.SoftmaxCELoss()
```

```{.python .input}
# @tab pytorch, paddle
net = d2l.BERTModel(len(vocab), num*hiddens=128, norm*shape=[128],
                    ffn*num*input=128, ffn*num*hiddens=256, num_heads=2,
                    num*layers=2, dropout=0.2, key*size=128, query_size=128,
                    value*size=128, hid*in*features=128, mlm*in_features=128,
                    nsp*in*features=128)
devices = d2l.try*all*gpus()
loss = nn.CrossEntropyLoss()
```

在定义训练代码实现之前，我们定义了一个辅助函数`*get*batch*loss*bert`。给定训练样本，该函数计算遮蔽语言模型和下一句子预测任务的损失。请注意，BERT预训练的最终损失是遮蔽语言模型损失和下一句预测损失的和。

```{.python .input}
# @save
def *get*batch*loss*bert(net, loss, vocab*size, tokens*X_shards,
                         segments*X*shards, valid*lens*x_shards,
                         pred*positions*X*shards, mlm*weights*X*shards,
                         mlm*Y*shards, nsp*y*shards):
    mlm*ls, nsp*ls, ls = [], [], []
    for (tokens*X*shard, segments*X*shard, valid*lens*x_shard,
         pred*positions*X*shard, mlm*weights*X*shard, mlm*Y*shard,
         nsp*y*shard) in zip(
        tokens*X*shards, segments*X*shards, valid*lens*x_shards,
        pred*positions*X*shards, mlm*weights*X*shards, mlm*Y*shards,
        nsp*y*shards):
        # 前向传播
        *, mlm*Y*hat, nsp*Y_hat = net(
            tokens*X*shard, segments*X*shard, valid*lens*x_shard.reshape(-1),
            pred*positions*X_shard)
        # 计算遮蔽语言模型损失
        mlm_l = loss(
            mlm*Y*hat.reshape((-1, vocab*size)), mlm*Y_shard.reshape(-1),
            mlm*weights*X_shard.reshape((-1, 1)))
        mlm*l = mlm*l.sum() / (mlm*weights*X_shard.sum() + 1e-8)
        # 计算下一句子预测任务的损失
        nsp*l = loss(nsp*Y*hat, nsp*y_shard)
        nsp*l = nsp*l.mean()
        mlm*ls.append(mlm*l)
        nsp*ls.append(nsp*l)
        ls.append(mlm*l + nsp*l)
        npx.waitall()
    return mlm*ls, nsp*ls, ls
```

```{.python .input}
# @tab pytorch
# @save
def *get*batch*loss*bert(net, loss, vocab*size, tokens*X,
                         segments*X, valid*lens_x,
                         pred*positions*X, mlm*weights*X,
                         mlm*Y, nsp*y):
    # 前向传播
    *, mlm*Y*hat, nsp*Y*hat = net(tokens*X, segments_X,
                                  valid*lens*x.reshape(-1),
                                  pred*positions*X)
    # 计算遮蔽语言模型损失
    mlm*l = loss(mlm*Y*hat.reshape(-1, vocab*size), mlm_Y.reshape(-1)) *\
    mlm*weights*X.reshape(-1, 1)
    mlm*l = mlm*l.sum() / (mlm*weights*X.sum() + 1e-8)
    # 计算下一句子预测任务的损失
    nsp*l = loss(nsp*Y*hat, nsp*y)
    l = mlm*l + nsp*l
    return mlm*l, nsp*l, l
```

```{.python .input}
# @tab paddle
# @save
def *get*batch*loss*bert(net, loss, vocab*size, tokens*X,
                         segments*X, valid*lens_x,
                         pred*positions*X, mlm*weights*X,
                         mlm*Y, nsp*y):
    # 前向传播
    *, mlm*Y*hat, nsp*Y*hat = net(tokens*X, segments_X,
                                  valid*lens*x.reshape([-1]), 
                                  pred*positions*X)
    # 计算遮蔽语言模型损失
    mlm*l = loss(mlm*Y*hat.reshape([-1, vocab*size]), mlm_Y.reshape([-1])) *\
    mlm*weights*X.reshape([-1, 1])
    mlm*l = mlm*l.sum() / (mlm*weights*X.sum() + 1e-8)
    # 计算下一句子预测任务的损失
    nsp*l = loss(nsp*Y*hat, nsp*y)
    l = mlm*l + nsp*l
    return mlm*l, nsp*l, l
```

通过调用上述两个辅助函数，下面的`train*bert`函数定义了在WikiText-2（`train*iter`）数据集上预训练BERT（`net`）的过程。训练BERT可能需要很长时间。以下函数的输入`num*steps`指定了训练的迭代步数，而不是像`train*ch13`函数那样指定训练的轮数（参见 :numref:`sec*image*augmentation`）。

```{.python .input}
def train*bert(train*iter, net, loss, vocab*size, devices, num*steps):
    trainer = gluon.Trainer(net.collect_params(), 'adam',
                            {'learning_rate': 0.01})
    step, timer = 0, d2l.Timer()
    animator = d2l.Animator(xlabel='step', ylabel='loss',
                            xlim=[1, num_steps], legend=['mlm', 'nsp'])
    # 遮蔽语言模型损失的和，下一句预测任务损失的和，句子对的数量，计数
    metric = d2l.Accumulator(4)
    num*steps*reached = False
    while step < num*steps and not num*steps_reached:
        for batch in train_iter:
            (tokens*X*shards, segments*X*shards, valid*lens*x_shards,
             pred*positions*X*shards, mlm*weights*X*shards,
             mlm*Y*shards, nsp*y*shards) = [gluon.utils.split*and*load(
                elem, devices, even_split=False) for elem in batch]
            timer.start()
            with autograd.record():
                mlm*ls, nsp*ls, ls = *get*batch*loss*bert(
                    net, loss, vocab*size, tokens*X*shards, segments*X_shards,
                    valid*lens*x*shards, pred*positions*X*shards,
                    mlm*weights*X*shards, mlm*Y*shards, nsp*y_shards)
            for l in ls:
                l.backward()
            trainer.step(1)
            mlm*l*mean = sum([float(l) for l in mlm*ls]) / len(mlm*ls)
            nsp*l*mean = sum([float(l) for l in nsp*ls]) / len(nsp*ls)
            metric.add(mlm*l*mean, nsp*l*mean, batch[0].shape[0], 1)
            timer.stop()
            animator.add(step + 1,
                         (metric[0] / metric[3], metric[1] / metric[3]))
            step += 1
            if step == num_steps:
                num*steps*reached = True
                break

    print(f'MLM loss {metric[0] / metric[3]:.3f}, '
          f'NSP loss {metric[1] / metric[3]:.3f}')
    print(f'{metric[2] / timer.sum():.1f} sentence pairs/sec on '
          f'{str(devices)}')
```

```{.python .input}
# @tab pytorch
def train*bert(train*iter, net, loss, vocab*size, devices, num*steps):
    net = nn.DataParallel(net, device_ids=devices).to(devices[0])
    trainer = torch.optim.Adam(net.parameters(), lr=0.01)
    step, timer = 0, d2l.Timer()
    animator = d2l.Animator(xlabel='step', ylabel='loss',
                            xlim=[1, num_steps], legend=['mlm', 'nsp'])
    # 遮蔽语言模型损失的和，下一句预测任务损失的和，句子对的数量，计数
    metric = d2l.Accumulator(4)
    num*steps*reached = False
    while step < num*steps and not num*steps_reached:
        for tokens*X, segments*X, valid*lens*x, pred*positions*X,\
            mlm*weights*X, mlm*Y, nsp*y in train_iter:
            tokens*X = tokens*X.to(devices[0])
            segments*X = segments*X.to(devices[0])
            valid*lens*x = valid*lens*x.to(devices[0])
            pred*positions*X = pred*positions*X.to(devices[0])
            mlm*weights*X = mlm*weights*X.to(devices[0])
            mlm*Y, nsp*y = mlm*Y.to(devices[0]), nsp*y.to(devices[0])
            trainer.zero_grad()
            timer.start()
            mlm*l, nsp*l, l = *get*batch*loss*bert(
                net, loss, vocab*size, tokens*X, segments*X, valid*lens_x,
                pred*positions*X, mlm*weights*X, mlm*Y, nsp*y)
            l.backward()
            trainer.step()
            metric.add(mlm*l, nsp*l, tokens_X.shape[0], 1)
            timer.stop()
            animator.add(step + 1,
                         (metric[0] / metric[3], metric[1] / metric[3]))
            step += 1
            if step == num_steps:
                num*steps*reached = True
                break

    print(f'MLM loss {metric[0] / metric[3]:.3f}, '
          f'NSP loss {metric[1] / metric[3]:.3f}')
    print(f'{metric[2] / timer.sum():.1f} sentence pairs/sec on '
          f'{str(devices)}')
```

```{.python .input}
# @tab paddle
def train*bert(train*iter, net, loss, vocab*size, devices, num*steps):
    trainer = paddle.optimizer.Adam(parameters=net.parameters(), learning_rate=0.01)
    step, timer = 0, d2l.Timer()
    animator = d2l.Animator(xlabel='step', ylabel='loss',
                            xlim=[1, num_steps], legend=['mlm', 'nsp'])
    # 遮蔽语言模型损失的和，下一句预测任务损失的和，句子对的数量，计数
    metric = d2l.Accumulator(4)
    num*steps*reached = False
    while step < num*steps and not num*steps_reached:
        for tokens*X, segments*X, valid*lens*x, pred*positions*X,\
            mlm*weights*X, mlm*Y, nsp*y in train_iter:
            trainer.clear_grad()
            timer.start()
            mlm*l, nsp*l, l = *get*batch*loss*bert(
                net, loss, vocab*size, tokens*X, segments*X, valid*lens_x,
                pred*positions*X, mlm*weights*X, mlm*Y, nsp*y)
            l.backward()
            trainer.step()
            metric.add(mlm*l, nsp*l, tokens_X.shape[0], 1)
            timer.stop()
            animator.add(step + 1,
                         (metric[0] / metric[3], metric[1] / metric[3]))
            step += 1
            if step == num_steps:
                num*steps*reached = True
                break

    print(f'MLM loss {metric[0] / metric[3]:.3f}, '
          f'NSP loss {metric[1] / metric[3]:.3f}')
    print(f'{metric[2] / timer.sum():.1f} sentence pairs/sec on '
          f'{str(devices)}')
```

在预训练过程中，我们可以绘制出遮蔽语言模型损失和下一句预测损失。

```{.python .input}
# @tab mxnet, pytorch
train*bert(train*iter, net, loss, len(vocab), devices, 50)
```

```{.python .input}
# @tab paddle
train*bert(train*iter, net, loss, len(vocab), devices[:1], 50)
```

# # 用BERT表示文本

在预训练BERT之后，我们可以用它来表示单个文本、文本对或其中的任何词元。下面的函数返回`tokens*a`和`tokens*b`中所有词元的BERT（`net`）表示。

```{.python .input}
def get*bert*encoding(net, tokens*a, tokens*b=None):
    tokens, segments = d2l.get*tokens*and*segments(tokens*a, tokens_b)
    token*ids = np.expand*dims(np.array(vocab[tokens], ctx=devices[0]),
                               axis=0)
    segments = np.expand_dims(np.array(segments, ctx=devices[0]), axis=0)
    valid*len = np.expand*dims(np.array(len(tokens), ctx=devices[0]), axis=0)
    encoded*X, *, * = net(token*ids, segments, valid_len)
    return encoded_X
```

```{.python .input}
# @tab pytorch
def get*bert*encoding(net, tokens*a, tokens*b=None):
    tokens, segments = d2l.get*tokens*and*segments(tokens*a, tokens_b)
    token_ids = torch.tensor(vocab[tokens], device=devices[0]).unsqueeze(0)
    segments = torch.tensor(segments, device=devices[0]).unsqueeze(0)
    valid_len = torch.tensor(len(tokens), device=devices[0]).unsqueeze(0)
    encoded*X, *, * = net(token*ids, segments, valid_len)
    return encoded_X
```

```{.python .input}
# @tab paddle
def get*bert*encoding(net, tokens*a, tokens*b=None):
    tokens, segments = d2l.get*tokens*and*segments(tokens*a, tokens_b)
    token*ids = paddle.to*tensor(vocab[tokens]).unsqueeze(0)
    segments = paddle.to_tensor(segments).unsqueeze(0)
    valid*len = paddle.to*tensor(len(tokens))
    
    encoded*X, *, * = net(token*ids, segments, valid_len)
    return encoded_X
```

考虑“a crane is flying”这句话。回想一下 :numref:`subsec*bert*input*rep`中讨论的BERT的输入表示。插入特殊标记“&lt;cls&gt;”（用于分类）和“&lt;sep&gt;”（用于分隔）后，BERT输入序列的长度为6。因为零是“&lt;cls&gt;”词元，`encoded*text[:, 0, :]`是整个输入语句的BERT表示。为了评估一词多义词元“crane”，我们还打印出了该词元的BERT表示的前三个元素。

```{.python .input}
# @tab all
tokens_a = ['a', 'crane', 'is', 'flying']
encoded*text = get*bert*encoding(net, tokens*a)
# 词元：'<cls>','a','crane','is','flying','<sep>'
encoded*text*cls = encoded_text[:, 0, :]
encoded*text*crane = encoded_text[:, 2, :]
encoded*text.shape, encoded*text*cls.shape, encoded*text_crane[0][:3]
```

现在考虑一个句子“a crane driver came”和“he just left”。类似地，`encoded_pair[:, 0, :]`是来自预训练BERT的整个句子对的编码结果。注意，多义词元“crane”的前三个元素与上下文不同时的元素不同。这支持了BERT表示是上下文敏感的。

```{.python .input}
# @tab all
tokens*a, tokens*b = ['a', 'crane', 'driver', 'came'], ['he', 'just', 'left']
encoded*pair = get*bert*encoding(net, tokens*a, tokens_b)
# 词元：'<cls>','a','crane','driver','came','<sep>','he','just',
# 'left','<sep>'
encoded*pair*cls = encoded_pair[:, 0, :]
encoded*pair*crane = encoded_pair[:, 2, :]
encoded*pair.shape, encoded*pair*cls.shape, encoded*pair_crane[0][:3]
```

在 :numref:`chap*nlp*app`中，我们将为下游自然语言处理应用微调预训练的BERT模型。

# # 小结

* 原始的BERT有两个版本，其中基本模型有1.1亿个参数，大模型有3.4亿个参数。
* 在预训练BERT之后，我们可以用它来表示单个文本、文本对或其中的任何词元。
* 在实验中，同一个词元在不同的上下文中具有不同的BERT表示。这支持BERT表示是上下文敏感的。

# # 练习

1. 在实验中，我们可以看到遮蔽语言模型损失明显高于下一句预测损失。为什么？
2. 将BERT输入序列的最大长度设置为512（与原始BERT模型相同）。使用原始BERT模型的配置，如$\text{BERT}_{\text{LARGE}}$。运行此部分时是否遇到错误？为什么？

:begin_tab:`mxnet`
[Discussions](https://discuss.d2l.ai/t/5742)
:end_tab:

:begin_tab:`pytorch`
[Discussions](https://discuss.d2l.ai/t/5743)
:end_tab:

:begin_tab:`paddle`
[Discussions](https://discuss.d2l.ai/t/11824)
:end_tab:
