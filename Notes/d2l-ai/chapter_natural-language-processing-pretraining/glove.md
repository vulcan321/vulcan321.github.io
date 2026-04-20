# 全局向量的词嵌入（GloVe）
:label:`sec_glove`

上下文窗口内的词共现可以携带丰富的语义信息。例如，在一个大型语料库中，“固体”比“气体”更有可能与“冰”共现，但“气体”一词与“蒸汽”的共现频率可能比与“冰”的共现频率更高。此外，可以预先计算此类共现的全局语料库统计数据：这可以提高训练效率。为了利用整个语料库中的统计信息进行词嵌入，让我们首先回顾 :numref:`subsec_skip-gram`中的跳元模型，但是使用全局语料库统计（如共现计数）来解释它。

# # 带全局语料统计的跳元模型
:label:`subsec_skipgram-global`

用$q*{ij}$表示词$w*j$的条件概率$P(w*j\mid w*i)$，在跳元模型中给定词$w_i$，我们有：

$$q*{ij}=\frac{\exp(\mathbf{u}*j^\top \mathbf{v}*i)}{ \sum*{k \in \mathcal{V}} \text{exp}(\mathbf{u}*k^\top \mathbf{v}*i)},$$

其中，对于任意索引$i$，向量$\mathbf{v}*i$和$\mathbf{u}*i$分别表示词$w_i$作为中心词和上下文词，且$\mathcal{V} = \{0, 1, \ldots, |\mathcal{V}|-1\}$是词表的索引集。

考虑词$w*i$可能在语料库中出现多次。在整个语料库中，所有以$w*i$为中心词的上下文词形成一个词索引的*多重集*$\mathcal{C}*i$，该索引允许同一元素的多个实例。对于任何元素，其实例数称为其*重数*。举例说明，假设词$w*i$在语料库中出现两次，并且在两个上下文窗口中以$w*i$为其中心词的上下文词索引是$k, j, m, k$和$k, l, k, j$。因此，多重集$\mathcal{C}*i = \{j, j, k, k, k, k, l, m\}$，其中元素$j, k, l, m$的重数分别为2、4、1、1。

现在，让我们将多重集$\mathcal{C}*i$中的元素$j$的重数表示为$x*{ij}$。这是词$w*j$（作为上下文词）和词$w*i$（作为中心词）在整个语料库的同一上下文窗口中的全局共现计数。使用这样的全局语料库统计，跳元模型的损失函数等价于：

$$-\sum*{i\in\mathcal{V}}\sum*{j\in\mathcal{V}} x*{ij} \log\,q*{ij}.$$
:eqlabel:`eq*skipgram-x*ij`

我们用$x*i$表示上下文窗口中的所有上下文词的数量，其中$w*i$作为它们的中心词出现，这相当于$|\mathcal{C}*i|$。设$p*{ij}$为用于生成上下文词$w*j$的条件概率$x*{ij}/x*i$。给定中心词$w*i$， :eqref:`eq*skipgram-x*ij`可以重写为：

$$-\sum*{i\in\mathcal{V}} x*i \sum*{j\in\mathcal{V}} p*{ij} \log\,q_{ij}.$$
:eqlabel:`eq*skipgram-p*ij`

在 :eqref:`eq*skipgram-p*ij`中，$-\sum*{j\in\mathcal{V}} p*{ij} \log\,q*{ij}$计算全局语料统计的条件分布$p*{ij}$和模型预测的条件分布$q*{ij}$的交叉熵。如上所述，这一损失也按$x*i$加权。在 :eqref:`eq*skipgram-p*ij`中最小化损失函数将使预测的条件分布接近全局语料库统计中的条件分布。

虽然交叉熵损失函数通常用于测量概率分布之间的距离，但在这里可能不是一个好的选择。一方面，正如我们在 :numref:`sec*approx*train`中提到的，规范化$q_{ij}$的代价在于整个词表的求和，这在计算上可能非常昂贵。另一方面，来自大型语料库的大量罕见事件往往被交叉熵损失建模，从而赋予过多的权重。

# # GloVe模型

有鉴于此，*GloVe*模型基于平方损失 :cite:`Pennington.Socher.Manning.2014`对跳元模型做了三个修改：

1. 使用变量$p'*{ij}=x*{ij}$和$q'*{ij}=\exp(\mathbf{u}*j^\top \mathbf{v}_i)$
而非概率分布，并取两者的对数。所以平方损失项是$\left(\log\,p'*{ij} - \log\,q'*{ij}\right)^2 = \left(\mathbf{u}*j^\top \mathbf{v}*i - \log\,x_{ij}\right)^2$。
2. 为每个词$w*i$添加两个标量模型参数：中心词偏置$b*i$和上下文词偏置$c_i$。
3. 用权重函数$h(x_{ij})$替换每个损失项的权重，其中$h(x)$在$[0, 1]$的间隔内递增。

整合代码，训练GloVe是为了尽量降低以下损失函数：

$$\sum*{i\in\mathcal{V}} \sum*{j\in\mathcal{V}} h(x*{ij}) \left(\mathbf{u}*j^\top \mathbf{v}*i + b*i + c*j - \log\,x*{ij}\right)^2.$$
:eqlabel:`eq_glove-loss`

对于权重函数，建议的选择是：当$x < c$（例如，$c = 100$）时，$h(x) = (x/c) ^\alpha$（例如$\alpha = 0.75$）；否则$h(x) = 1$。在这种情况下，由于$h(0)=0$，为了提高计算效率，可以省略任意$x*{ij}=0$的平方损失项。例如，当使用小批量随机梯度下降进行训练时，在每次迭代中，我们随机抽样一小批量*非零*的$x*{ij}$来计算梯度并更新模型参数。注意，这些非零的$x_{ij}$是预先计算的全局语料库统计数据；因此，该模型GloVe被称为*全局向量*。

应该强调的是，当词$w*i$出现在词$w*j$的上下文窗口时，词$w*j$也出现在词$w*i$的上下文窗口。因此，$x*{ij}=x*{ji}$。与拟合非对称条件概率$p*{ij}$的word2vec不同，GloVe拟合对称概率$\log \, x*{ij}$。因此，在GloVe模型中，任意词的中心词向量和上下文词向量在数学上是等价的。但在实际应用中，由于初始值不同，同一个词经过训练后，在这两个向量中可能得到不同的值：GloVe将它们相加作为输出向量。

# # 从条件概率比值理解GloVe模型

我们也可以从另一个角度来理解GloVe模型。使用 :numref:`subsec*skipgram-global`中的相同符号，设$p*{ij} \stackrel{\mathrm{def}}{=} P(w*j \mid w*i)$为生成上下文词$w*j$的条件概率，给定$w*i$作为语料库中的中心词。 :numref:`tab_glove`根据大量语料库的统计数据，列出了给定单词“ice”和“steam”的共现概率及其比值。

:大型语料库中的词-词共现概率及其比值（根据 :cite:`Pennington.Socher.Manning.2014`中的表1改编）

|$w_k$=|solid|gas|water|fashion|
|:--|:-|:-|:-|:-|
|$p*1=P(w*k\mid \text{ice})$|0.00019|0.000066|0.003|0.000017|
|$p*2=P(w*k\mid\text{steam})$|0.000022|0.00078|0.0022|0.000018|
|$p*1/p*2$|8.9|0.085|1.36|0.96|
:label:`tab_glove`

从 :numref:`tab_glove`中，我们可以观察到以下几点：

* 对于与“ice”相关但与“steam”无关的单词$w*k$，例如$w*k=\text{solid}$，我们预计会有更大的共现概率比值，例如8.9。
* 对于与“steam”相关但与“ice”无关的单词$w*k$，例如$w*k=\text{gas}$，我们预计较小的共现概率比值，例如0.085。
* 对于同时与“ice”和“steam”相关的单词$w*k$，例如$w*k=\text{water}$，我们预计其共现概率的比值接近1，例如1.36.
* 对于与“ice”和“steam”都不相关的单词$w*k$，例如$w*k=\text{fashion}$，我们预计共现概率的比值接近1，例如0.96.

由此可见，共现概率的比值能够直观地表达词与词之间的关系。因此，我们可以设计三个词向量的函数来拟合这个比值。对于共现概率${p*{ij}}/{p*{ik}}$的比值，其中$w*i$是中心词，$w*j$和$w_k$是上下文词，我们希望使用某个函数$f$来拟合该比值：

$$f(\mathbf{u}*j, \mathbf{u}*k, {\mathbf{v}}*i) \approx \frac{p*{ij}}{p_{ik}}.$$
:eqlabel:`eq_glove-f`

在$f$的许多可能的设计中，我们只在以下几点中选择了一个合理的选择。因为共现概率的比值是标量，所以我们要求$f$是标量函数，例如$f(\mathbf{u}*j, \mathbf{u}*k, {\mathbf{v}}*i) = f\left((\mathbf{u}*j - \mathbf{u}*k)^\top {\mathbf{v}}*i\right)$。在 :eqref:`eq_glove-f`中交换词索引$j$和$k$，它必须保持$f(x)f(-x)=1$，所以一种可能性是$f(x)=\exp(x)$，即：

$$f(\mathbf{u}*j, \mathbf{u}*k, {\mathbf{v}}*i) = \frac{\exp\left(\mathbf{u}*j^\top {\mathbf{v}}*i\right)}{\exp\left(\mathbf{u}*k^\top {\mathbf{v}}*i\right)} \approx \frac{p*{ij}}{p_{ik}}.$$

现在让我们选择$\exp\left(\mathbf{u}*j^\top {\mathbf{v}}*i\right) \approx \alpha p*{ij}$，其中$\alpha$是常数。从$p*{ij}=x*{ij}/x*i$开始，取两边的对数得到$\mathbf{u}*j^\top {\mathbf{v}}*i \approx \log\,\alpha + \log\,x*{ij} - \log\,x*i$。我们可以使用附加的偏置项来拟合$- \log\, \alpha + \log\, x*i$，如中心词偏置$b*i$和上下文词偏置$c_j$：

$$\mathbf{u}*j^\top \mathbf{v}*i + b*i + c*j \approx \log\, x_{ij}.$$
:eqlabel:`eq_glove-square`

通过对 :eqref:`eq*glove-square`的加权平方误差的度量，得到了 :eqref:`eq*glove-loss`的GloVe损失函数。

# # 小结

* 诸如词-词共现计数的全局语料库统计可以来解释跳元模型。
* 交叉熵损失可能不是衡量两种概率分布差异的好选择，特别是对于大型语料库。GloVe使用平方损失来拟合预先计算的全局语料库统计数据。
* 对于GloVe中的任意词，中心词向量和上下文词向量在数学上是等价的。
* GloVe可以从词-词共现概率的比率来解释。

# # 练习

1. 如果词$w*i$和$w*j$在同一上下文窗口中同时出现，我们如何使用它们在文本序列中的距离来重新设计计算条件概率$p_{ij}$的方法？提示：参见GloVe论文 :cite:`Pennington.Socher.Manning.2014`的第4.2节。
1. 对于任何一个词，它的中心词偏置和上下文偏置在数学上是等价的吗？为什么？

[Discussions](https://discuss.d2l.ai/t/5736)
