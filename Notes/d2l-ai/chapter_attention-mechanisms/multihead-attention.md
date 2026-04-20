# 多头注意力
:label:`sec_multihead-attention`

在实践中，当给定相同的查询、键和值的集合时，
我们希望模型可以基于相同的注意力机制学习到不同的行为，
然后将不同的行为作为知识组合起来，
捕获序列内各种范围的依赖关系
（例如，短距离依赖和长距离依赖关系）。
因此，允许注意力机制组合使用查询、键和值的不同
*子空间表示*（representation subspaces）可能是有益的。

为此，与其只使用单独一个注意力汇聚，
我们可以用独立学习得到的$h$组不同的
*线性投影*（linear projections）来变换查询、键和值。
然后，这$h$组变换后的查询、键和值将并行地送到注意力汇聚中。
最后，将这$h$个注意力汇聚的输出拼接在一起，
并且通过另一个可以学习的线性投影进行变换，
以产生最终输出。
这种设计被称为*多头注意力*（multihead attention）
 :cite:`Vaswani.Shazeer.Parmar.ea.2017`。
对于$h$个注意力汇聚输出，每一个注意力汇聚都被称作一个*头*（head）。
 :numref:`fig_multi-head-attention`
展示了使用全连接层来实现可学习的线性变换的多头注意力。

![多头注意力：多个头连结然后线性变换](../img/multi-head-attention.svg)
:label:`fig_multi-head-attention`

# # 模型

在实现多头注意力之前，让我们用数学语言将这个模型形式化地描述出来。
给定查询$\mathbf{q} \in \mathbb{R}^{d_q}$、
键$\mathbf{k} \in \mathbb{R}^{d_k}$和
值$\mathbf{v} \in \mathbb{R}^{d_v}$，
每个注意力头$\mathbf{h}_i$（$i = 1, \ldots, h$）的计算方法为：

$$\mathbf{h}*i = f(\mathbf W*i^{(q)}\mathbf q, \mathbf W*i^{(k)}\mathbf k,\mathbf W*i^{(v)}\mathbf v) \in \mathbb R^{p_v},$$

其中，可学习的参数包括
$\mathbf W*i^{(q)}\in\mathbb R^{p*q\times d_q}$、
$\mathbf W*i^{(k)}\in\mathbb R^{p*k\times d_k}$和
$\mathbf W*i^{(v)}\in\mathbb R^{p*v\times d_v}$，
以及代表注意力汇聚的函数$f$。
$f$可以是 :numref:`sec_attention-scoring-functions`中的
加性注意力和缩放点积注意力。
多头注意力的输出需要经过另一个线性转换，
它对应着$h$个头连结后的结果，因此其可学习参数是
$\mathbf W*o\in\mathbb R^{p*o\times h p_v}$：

$$\mathbf W*o \begin{bmatrix}\mathbf h*1\\\vdots\\\mathbf h*h\end{bmatrix} \in \mathbb{R}^{p*o}.$$

基于这种设计，每个头都可能会关注输入的不同部分，
可以表示比简单加权平均值更复杂的函数。

```{.python .input}
from d2l import mxnet as d2l
import math
from mxnet import autograd, np, npx
from mxnet.gluon import nn
npx.set_np()
```

```{.python .input}
# @tab pytorch
from d2l import torch as d2l
import math
import torch
from torch import nn
```

```{.python .input}
# @tab tensorflow
from d2l import tensorflow as d2l
import tensorflow as tf
```

```{.python .input}
# @tab paddle
from d2l import paddle as d2l
import warnings
warnings.filterwarnings("ignore")
import math
import paddle
from paddle import nn
```

# # 实现

在实现过程中通常[**选择缩放点积注意力作为每一个注意力头**]。
为了避免计算代价和参数代价的大幅增长，
我们设定$p*q = p*k = p*v = p*o / h$。
值得注意的是，如果将查询、键和值的线性变换的输出数量设置为
$p*q h = p*k h = p*v h = p*o$，
则可以并行计算$h$个头。
在下面的实现中，$p*o$是通过参数`num*hiddens`指定的。

```{.python .input}
# @save
class MultiHeadAttention(nn.Block):
    """多头注意力"""
    def **init**(self, num*hiddens, num*heads, dropout, use_bias=False,
                 **kwargs):
        super(MultiHeadAttention, self).**init**(**kwargs)
        self.num*heads = num*heads
        self.attention = d2l.DotProductAttention(dropout)
        self.W*q = nn.Dense(num*hiddens, use*bias=use*bias, flatten=False)
        self.W*k = nn.Dense(num*hiddens, use*bias=use*bias, flatten=False)
        self.W*v = nn.Dense(num*hiddens, use*bias=use*bias, flatten=False)
        self.W*o = nn.Dense(num*hiddens, use*bias=use*bias, flatten=False)

    def forward(self, queries, keys, values, valid_lens):
        # queries，keys，values的形状:
        # (batch*size，查询或者“键－值”对的个数，num*hiddens)
        # valid_lens　的形状:
        # (batch*size，)或(batch*size，查询的个数)
        # 经过变换后，输出的queries，keys，values　的形状:
        # (batch*size*num*heads，查询或者“键－值”对的个数，
        # num*hiddens/num*heads)
        queries = transpose*qkv(self.W*q(queries), self.num_heads)
        keys = transpose*qkv(self.W*k(keys), self.num_heads)
        values = transpose*qkv(self.W*v(values), self.num_heads)

        if valid_lens is not None:
            # 在轴0，将第一项（标量或者矢量）复制num_heads次，
            # 然后如此复制第二项，然后诸如此类。
            valid*lens = valid*lens.repeat(self.num_heads, axis=0)

        # output的形状:(batch*size*num*heads，查询的个数，
        # num*hiddens/num*heads)
        output = self.attention(queries, keys, values, valid_lens)
        
        # output*concat的形状:(batch*size，查询的个数，num_hiddens)
        output*concat = transpose*output(output, self.num_heads)
        return self.W*o(output*concat)
```

```{.python .input}
# @tab pytorch
# @save
class MultiHeadAttention(nn.Module):
    """多头注意力"""
    def **init**(self, key*size, query*size, value*size, num*hiddens,
                 num_heads, dropout, bias=False, **kwargs):
        super(MultiHeadAttention, self).**init**(**kwargs)
        self.num*heads = num*heads
        self.attention = d2l.DotProductAttention(dropout)
        self.W*q = nn.Linear(query*size, num_hiddens, bias=bias)
        self.W*k = nn.Linear(key*size, num_hiddens, bias=bias)
        self.W*v = nn.Linear(value*size, num_hiddens, bias=bias)
        self.W*o = nn.Linear(num*hiddens, num_hiddens, bias=bias)

    def forward(self, queries, keys, values, valid_lens):
        # queries，keys，values的形状:
        # (batch*size，查询或者“键－值”对的个数，num*hiddens)
        # valid_lens　的形状:
        # (batch*size，)或(batch*size，查询的个数)
        # 经过变换后，输出的queries，keys，values　的形状:
        # (batch*size*num*heads，查询或者“键－值”对的个数，
        # num*hiddens/num*heads)
        queries = transpose*qkv(self.W*q(queries), self.num_heads)
        keys = transpose*qkv(self.W*k(keys), self.num_heads)
        values = transpose*qkv(self.W*v(values), self.num_heads)

        if valid_lens is not None:
            # 在轴0，将第一项（标量或者矢量）复制num_heads次，
            # 然后如此复制第二项，然后诸如此类。
            valid*lens = torch.repeat*interleave(
                valid*lens, repeats=self.num*heads, dim=0)

        # output的形状:(batch*size*num*heads，查询的个数，
        # num*hiddens/num*heads)
        output = self.attention(queries, keys, values, valid_lens)

        # output*concat的形状:(batch*size，查询的个数，num_hiddens)
        output*concat = transpose*output(output, self.num_heads)
        return self.W*o(output*concat)
```

```{.python .input}
# @tab tensorflow
# @save
class MultiHeadAttention(tf.keras.layers.Layer):
    """多头注意力"""
    def **init**(self, key*size, query*size, value*size, num*hiddens,
                 num_heads, dropout, bias=False, **kwargs):
        super().**init**(**kwargs)
        self.num*heads = num*heads
        self.attention = d2l.DotProductAttention(dropout)
        self.W*q = tf.keras.layers.Dense(num*hiddens, use_bias=bias)
        self.W*k = tf.keras.layers.Dense(num*hiddens, use_bias=bias)
        self.W*v = tf.keras.layers.Dense(num*hiddens, use_bias=bias)
        self.W*o = tf.keras.layers.Dense(num*hiddens, use_bias=bias)
    
    def call(self, queries, keys, values, valid_lens, **kwargs):
        # queries，keys，values的形状:
        # (batch*size，查询或者“键－值”对的个数，num*hiddens)
        # valid_lens　的形状:
        # (batch*size，)或(batch*size，查询的个数)
        # 经过变换后，输出的queries，keys，values　的形状:
        # (batch*size*num*heads，查询或者“键－值”对的个数，
        # num*hiddens/num*heads)
        queries = transpose*qkv(self.W*q(queries), self.num_heads)
        keys = transpose*qkv(self.W*k(keys), self.num_heads)
        values = transpose*qkv(self.W*v(values), self.num_heads)
        
        if valid_lens is not None:
            # 在轴0，将第一项（标量或者矢量）复制num_heads次，
            # 然后如此复制第二项，然后诸如此类。
            valid*lens = tf.repeat(valid*lens, repeats=self.num_heads, axis=0)
            
        # output的形状:(batch*size*num*heads，查询的个数，
        # num*hiddens/num*heads)
        output = self.attention(queries, keys, values, valid_lens, **kwargs)
        
        # output*concat的形状:(batch*size，查询的个数，num_hiddens)
        output*concat = transpose*output(output, self.num_heads)
        return self.W*o(output*concat)
```

```{.python .input}
# @tab paddle
# @save
class MultiHeadAttention(nn.Layer):
    def **init**(self, key*size, query*size, value*size, num*hiddens,
                 num_heads, dropout, bias=False, **kwargs):
        super(MultiHeadAttention, self).**init**(**kwargs)
        self.num*heads = num*heads
        self.attention = d2l.DotProductAttention(dropout)
        self.W*q = nn.Linear(query*size, num*hiddens, bias*attr=bias)
        self.W*k = nn.Linear(key*size, num*hiddens, bias*attr=bias)
        self.W*v = nn.Linear(value*size, num*hiddens, bias*attr=bias)
        self.W*o = nn.Linear(num*hiddens, num*hiddens, bias*attr=bias)

    def forward(self, queries, keys, values, valid_lens):
        # queries，keys，values的形状:
        # (batch*size，查询或者“键－值”对的个数，num*hiddens)
        # valid_lens　的形状:
        # (batch*size，)或(batch*size，查询的个数)
        # 经过变换后，输出的queries，keys，values　的形状:
        # (batch*size*num*heads，查询或者“键－值”对的个数，
        # num*hiddens/num*heads)
        queries = transpose*qkv(self.W*q(queries), self.num_heads)
        keys = transpose*qkv(self.W*k(keys), self.num_heads)
        values = transpose*qkv(self.W*v(values), self.num_heads)
        if valid_lens is not None:
            # 在轴0，将第一项（标量或者矢量）复制num_heads次，
            # 然后如此复制第二项，然后诸如此类。
            valid*lens = paddle.repeat*interleave(
                valid*lens, repeats=self.num*heads, axis=0)

        # output的形状:(batch*size*num*heads，查询的个数，
        # num*hiddens/num*heads)
        output = self.attention(queries, keys, values, valid_lens)

        # output*concat的形状:(batch*size，查询的个数，num_hiddens)
        output*concat = transpose*output(output, self.num_heads)
        return self.W*o(output*concat)
```

为了能够[**使多个头并行计算**]，
上面的`MultiHeadAttention`类将使用下面定义的两个转置函数。
具体来说，`transpose*output`函数反转了`transpose*qkv`函数的操作。

```{.python .input}
# @save
def transpose*qkv(X, num*heads):
    """为了多注意力头的并行计算而变换形状"""
    # 输入X的形状:(batch*size，查询或者“键－值”对的个数，num*hiddens)
    # 输出X的形状:(batch*size，查询或者“键－值”对的个数，num*heads，
    # num*hiddens/num*heads)
    X = X.reshape(X.shape[0], X.shape[1], num_heads, -1)

    # 输出X的形状:(batch*size，num*heads，查询或者“键－值”对的个数,
    # num*hiddens/num*heads)
    X = X.transpose(0, 2, 1, 3)

    # 最终输出的形状:(batch*size*num*heads,查询或者“键－值”对的个数,
    # num*hiddens/num*heads)
    return X.reshape(-1, X.shape[2], X.shape[3])


# @save
def transpose*output(X, num*heads):
    """逆转transpose_qkv函数的操作"""
    X = X.reshape(-1, num_heads, X.shape[1], X.shape[2])
    X = X.transpose(0, 2, 1, 3)
    return X.reshape(X.shape[0], X.shape[1], -1)
```

```{.python .input}
# @tab pytorch
# @save
def transpose*qkv(X, num*heads):
    """为了多注意力头的并行计算而变换形状"""
    # 输入X的形状:(batch*size，查询或者“键－值”对的个数，num*hiddens)
    # 输出X的形状:(batch*size，查询或者“键－值”对的个数，num*heads，
    # num*hiddens/num*heads)
    X = X.reshape(X.shape[0], X.shape[1], num_heads, -1)

    # 输出X的形状:(batch*size，num*heads，查询或者“键－值”对的个数,
    # num*hiddens/num*heads)
    X = X.permute(0, 2, 1, 3)

    # 最终输出的形状:(batch*size*num*heads,查询或者“键－值”对的个数,
    # num*hiddens/num*heads)
    return X.reshape(-1, X.shape[2], X.shape[3])


# @save
def transpose*output(X, num*heads):
    """逆转transpose_qkv函数的操作"""
    X = X.reshape(-1, num_heads, X.shape[1], X.shape[2])
    X = X.permute(0, 2, 1, 3)
    return X.reshape(X.shape[0], X.shape[1], -1)
```

```{.python .input}
# @tab tensorflow
# @save
def transpose*qkv(X, num*heads):
    """为了多注意力头的并行计算而变换形状"""
    # 输入X的形状:(batch*size，查询或者“键－值”对的个数，num*hiddens)
    # 输出X的形状:(batch*size，查询或者“键－值”对的个数，num*heads，
    # num*hiddens/num*heads)
    X = tf.reshape(X, shape=(X.shape[0], X.shape[1], num_heads, -1))

    # 输出X的形状:(batch*size，num*heads，查询或者“键－值”对的个数,
    # num*hiddens/num*heads)
    X = tf.transpose(X, perm=(0, 2, 1, 3))

    # 最终输出的形状:(batch*size*num*heads,查询或者“键－值”对的个数,
    # num*hiddens/num*heads)
    return tf.reshape(X, shape=(-1, X.shape[2], X.shape[3]))


# @save
def transpose*output(X, num*heads):
    """逆转transpose_qkv函数的操作"""
    X = tf.reshape(X, shape=(-1, num_heads, X.shape[1], X.shape[2]))
    X = tf.transpose(X, perm=(0, 2, 1, 3))
    return tf.reshape(X, shape=(X.shape[0], X.shape[1], -1))
```

```{.python .input}
# @tab paddle
# @save
def transpose*qkv(X, num*heads):
    """为了多注意力头的并行计算而变换形状"""
    # 输入X的形状:(batch*size，查询或者“键－值”对的个数，num*hiddens)
    # 输出X的形状:(batch*size，查询或者“键－值”对的个数，num*heads，
    # num*hiddens/num*heads)
    X = X.reshape((X.shape[0], X.shape[1], num_heads, -1))

    # 输出X的形状:(batch*size，num*heads，查询或者“键－值”对的个数,
    # num*hiddens/num*heads)
    X = X.transpose((0, 2, 1, 3))

    # 最终输出的形状:(batch*size*num*heads,查询或者“键－值”对的个数,
    # num*hiddens/num*heads)
    return X.reshape((-1, X.shape[2], X.shape[3]))


# @save
def transpose*output(X, num*heads):
    """逆转transpose_qkv函数的操作"""
    X = X.reshape((-1, num_heads, X.shape[1], X.shape[2]))
    X = X.transpose((0, 2, 1, 3))
    return X.reshape((X.shape[0], X.shape[1], -1))
```

下面使用键和值相同的小例子来[**测试**]我们编写的`MultiHeadAttention`类。
多头注意力输出的形状是（`batch*size`，`num*queries`，`num_hiddens`）。

```{.python .input}
num*hiddens, num*heads = 100, 5
attention = MultiHeadAttention(num*hiddens, num*heads, 0.5)
attention.initialize()
```

```{.python .input}
# @tab pytorch
num*hiddens, num*heads = 100, 5
attention = MultiHeadAttention(num*hiddens, num*hiddens, num_hiddens,
                               num*hiddens, num*heads, 0.5)
attention.eval()
```

```{.python .input}
# @tab tensorflow
num*hiddens, num*heads = 100, 5
attention = MultiHeadAttention(num*hiddens, num*hiddens, num_hiddens,
                               num*hiddens, num*heads, 0.5)
```

```{.python .input}
# @tab paddle
num*hiddens, num*heads = 100, 5
attention = MultiHeadAttention(num*hiddens, num*hiddens, num_hiddens,
                               num*hiddens, num*heads, 0.5)
attention.eval()
```

```{.python .input}
# @tab mxnet, pytorch, paddle
batch*size, num*queries = 2, 4
num*kvpairs, valid*lens =  6, d2l.tensor([3, 2])
X = d2l.ones((batch*size, num*queries, num_hiddens))
Y = d2l.ones((batch*size, num*kvpairs, num_hiddens))
attention(X, Y, Y, valid_lens).shape
```

```{.python .input}
# @tab tensorflow
batch*size, num*queries = 2, 4
num*kvpairs, valid*lens = 6, d2l.tensor([3, 2])
X = tf.ones((batch*size, num*queries, num_hiddens))
Y = tf.ones((batch*size, num*kvpairs, num_hiddens))
attention(X, Y, Y, valid_lens, training=False).shape
```

# # 小结

* 多头注意力融合了来自于多个注意力汇聚的不同知识，这些知识的不同来源于相同的查询、键和值的不同的子空间表示。
* 基于适当的张量操作，可以实现多头注意力的并行计算。

# # 练习

1. 分别可视化这个实验中的多个头的注意力权重。
1. 假设有一个完成训练的基于多头注意力的模型，现在希望修剪最不重要的注意力头以提高预测速度。如何设计实验来衡量注意力头的重要性呢？

:begin_tab:`mxnet`
[Discussions](https://discuss.d2l.ai/t/5757)
:end_tab:

:begin_tab:`pytorch`
[Discussions](https://discuss.d2l.ai/t/5758)
:end_tab:

:begin_tab:`paddle`
[Discussions](https://discuss.d2l.ai/t/11843)
:end_tab: