**导语：学习Transformer，快来跟着作者动手写一个。**

  

作为工程同学，学习Transformer中，不动手写一个，总感觉理解不扎实。纸上得来终觉浅，绝知此事要躬行，抽空多debug几遍！

  

注：不涉及算法解释，仅是从工程代码实现去加强理解。

  

**一 准备知识**

  

> 以预测二手房价格的模型，先来理解机器学习中的核心概念。

  

**1.1 手撸版**

  

### # 1 准备训练数据

  

```
# 样本数num*examples = 1000# 特征数：房屋大小、新旧num*input = 2# 线性回归模型，2个W参数值：2，-3.4true*w = [2, -3.4]# 1个b参数值true*b = 4.2# 随机生成样本：特征值features = torch.randn(num*examples, num*input, dtype=torch.float32)# print(features[0]) # 随机生成样本：y值labels = true*w[0] * features[:, 0] + true*w[1] * features[:, 1] + true*b# print(labels[0])# 随机生成一批数据，给y值再随机化下*temp = torch.tensor(np.random.normal(0, 0.01, size=labels.size()), dtype=torch.float32)labels = labels + _temp# print(labels[0])
```

  

### # 2 定义模型

  

```
# 模型参数 w：w1、w2，b：b，设了初始值w = torch.tensor(np.random.normal(0, 0.01, (num*input, 1)), dtype=torch.float32)b = torch.zeros(1, dtype=torch.float32)# 设置要求计算梯度w.requires*grad*(requires*grad=True)b.requires*grad*(requires*grad=True)# 线性回归模型：定义 torch.mm(X, w) + b，mm是矩阵乘法（m：multiply缩写）def linreg(X, w, b):    return torch.mm(X, w) + b# 定义损失函数：y*pred=预测值、y=真实值，最简单的 平方误差def squared*loss(y*pred, y):    return (y*pred - y.view(y*pred.size())) ** 2 / 2# 定义梯度下降算法：sgd# params是参数（data 是参数值、grad 是梯度值），lr是学习率，batch是数量# 为什么要除batch？因为这个梯度值，是在batch个数据上累加算的def sgd(params, lr, batch):    for param in params:        # 注意这里更改param时用的param.data        param.data -= lr * param.grad / batch
```

  

3 训练模型

  

```
# 初始学习率lr = 0.03# 训练轮次epoch = 5# 网络：一层，2个输入（2个参数 w1、w2），1个b参数net = linreg# 损失函数loss = squared*loss# 1个批次大小batch*size = 10# 训练模型一共需要epoch个迭代周期for epoch in range(epoch):    # 在每一个迭代周期中，所有样本都要跑，从 0~1000，每个batch=10    for X, y in data*iter(batch*size, features, labels):        # ls是这个batch的损失求和        ls = loss(net(X, w, b), y).sum()        # 求梯度值        ls.backward()        # 更新参数        sgd([w, b], lr, batch*size)        # 不要忘了梯度清零，下一次要用        w.grad.data.zero*()        b.grad.data.zero*()    # 在计算这轮训练完后，打印 loss，可以观察在不断变小    train*l = loss(net(features, w, b), labels)    print('epoch %d, loss %f' % (epoch + 1, train_l.mean().item()))
```

  

> 辅助函数：by batch & 随机，读取样本数据

  

```
# 定义随机读取数据 by batchdef data*iter(batch, features, labels):    nums = len(features)    # 生成 0-1000 数组    indices = list(range(nums))    # 打乱下标的读取顺序    random.shuffle(indices)    # 生成：start=0，stop=1000，step=batch=10    for i in range(0, nums, batch):        # 截取一段下标，size=batch        t*ind = indices[i: min(i + batch, num*examples)]  # 最后一次可能不足一个batch        # 转换为torch要求格式：tensor        j = torch.LongTensor(t*ind)        # 按照下标从向量中找        # yield：生成一个迭代器返回，有点类似闭包，每调用一次返回一次，且下次调用时会从上次暂停的位置继续        yield features.index*select(0, j), labels.index*select(0, j)
```

  

**1.2 pytorch版**

  

### # 1 准备训练数据

同上

  

### # 2 定义模型

  

```
# 定义模型：线性回归class LinearNet(nn.Module):    def **init**(self, n*feature):        super(LinearNet, self).**init**()        # 线性规划：n*feature=几个w，1=1个b        self.linear = nn.Linear(n*feature, 1)    # forward 定义【前向传播】    def forward(self, x):        y = self.linear(x)        return y# 实例化模型，初始化参数值net = LinearNet(num*input)init.normal*(net[0].weight, mean=0, std=0.01)init.constant*(net[0].bias, val=0)# 定义损失函数loss = nn.MSELoss()# 定义梯度下降算法（lr是学习率）optimizer = optim.SGD(net.parameters(), lr=0.03)
```

  

### # 3 训练模型

  

```
num*epochs = 3for epoch in range(1, num*epochs + 1):    for X, y in data*iter:        output = net(X)        # 算损失值        l*sum = loss(output, y.view(-1, 1))        # 更新梯度        l*sum.backward()        # 更新w和b        optimizer.step()        # 梯度清零        optimizer.zero*grad()    print('epoch %d, loss: %f' % (epoch, l_sum.item()))
```

> batch 读取数据

  

```
# 读取数据 by batch & 随机batch*size = 10data*set = Data.TensorDataset(features, labels)data*iter = Data.DataLoader(data*set, batch_size, shuffle=True)
```

  

在用torch框架，进一步要理解：

  

a、nn.Module 和 forward() 函数：表示神经网络中的一个层，覆写 init 和 forward 方法（提问：实现2层网络怎么做？）

b、debug 观察下数据变化，和 手撸版 对比着去理解

  

**二 手写Transformer**

  

![Image](..\..\images\baa9fb7e-3c0e-4776-bddd-5259216889a6.png)

上面这是一个"逻辑"示意图。印象中，第1次看时，以为 "inputs & outputs" 是并行计算、但上面又有依赖，很糊涂。

  

这不是一个技术架构图，上图有很多概念，attention、multi-head等。先尝试转换为面向对象的类图，如下：

  

![Image](..\..\images\7fd14844-3801-474f-a9af-45f828130c69.png)

**2.1 例子：翻译**

  

```
# 定义词典source*vocab = {'E': 0, '我': 1, '吃': 2, '肉': 3}target*vocab = {'E': 0, 'I': 1, 'eat': 2, 'meat': 3, 'S': 4}# 样本数据encoder*input = torch.LongTensor([[1, 2, 3, 0]]).to(device)  # 我 吃 肉 E, E代表结束词decoder*input = torch.LongTensor([[4, 1, 2, 3]]).to(device)  # S I eat meat, S代表开始词, 并右移一位，用于并行训练target = torch.LongTensor([[1, 2, 3, 0]]).to(device)  # I eat meat E, 翻译目标
```

  

**2.2 定义模型**

  

按照上面类图，我们来一点点实现

### # 1 Attention

```
class ScaledDotProductAttention(nn.Module):    def **init**(self):        super(ScaledDotProductAttention, self).**init**()    def forward(self, Q, K, V, attn*mask):        # Q、K、V，此时是已经乘过 W(q)、W(k)、W(v) 矩阵        # 如下图，但不用一个个算，矩阵乘法一次搞定        scores = torch.matmul(Q, K.transpose(-1, -2)) / np.sqrt(d*k)        # 遮盖区的值设为近0，表示E结尾 or decoder 自我顺序遮盖，注意力丢弃        scores.masked*fill*(attn_mask, -1e9)        # softmax后（遮盖区变为0）        attn = nn.Softmax(dim=-1)(scores)        # 乘积意义：给V带上了注意力信息。prob就是下图z（矩阵计算不用在v1+v2）。        prob = torch.matmul(attn, V)        return prob
```

  

![Image](..\..\images\768fd5d9-eb59-47a9-96e0-c97d02d73534.png)

![Image](..\..\images\ba4c5653-2299-45b0-a051-89f25e6eb9fd.png)

### # 2 MultiHeadAttention

  

> 通用变量定义

  

```
d*model = 6  # embedding size# d*model = 3  # embedding sized*ff = 12  # feedforward nerual network  dimensiond*k = d*v = 3  # dimension of k(same as q) and vn*heads = 2  # number of heads in multihead attention# n*heads = 1  # number of heads in multihead attention【注：为debug更简单，可以先改为1个head】p*drop = 0.1  # propability of dropoutdevice = "cpu"
```

  

> 注1：按惯性会想，会有多个head、串行循环计算，不是，多个head是一个张量输入
> 
> 注2：FF 全连接、残差连接、归一化，35、38 行业代码，pytorch框架带来的简化

  

```
class MultiHeadAttention(nn.Module):    def **init**(self):        super(MultiHeadAttention, self).**init**()        self.n*heads = n*heads        self.W*Q = nn.Linear(d*model, d*k * n*heads, bias=False)        self.W*K = nn.Linear(d*model, d*k * n*heads, bias=False)        self.W*V = nn.Linear(d*model, d*v * n*heads, bias=False)        self.fc = nn.Linear(d*v * n*heads, d*model, bias=False)  # ff 全连接        self.layer*norm = nn.LayerNorm(d*model)  # normal 归一化    def forward(self, input*Q, input*K, input*V, attn*mask):        # input*Q：1*4*6，每批1句 * 每句4个词 * 每词6长度编码        # residual 先临时保存下：原始值，后面做残差连接加法        residual, batch = input*Q, input*Q.size(0)        # 乘上 W 矩阵。注：W 就是要训练的参数        # 注意：维度从2维变成3维，增加 head 维度，也是一次性并行计算        Q = self.W*Q(input*Q)  # 乘以 W(6*6) 变为 1*4*6        Q = Q.view(batch, -1, n*heads, d*k).transpose(1, 2)  # 切开为2个Head 变为 1*2*4*3 1批 2个Head 4词 3编码        K = self.W*K(input*K).view(batch, -1, n*heads, d*k).transpose(1, 2)        V = self.W*V(input*V).view(batch, -1, n*heads, d*v).transpose(1, 2)        # 1*2*4*4，2个Head的4*4，最后一列为true        # 因为最后一列是 E 结束符        attn*mask = attn*mask.unsqueeze(1).repeat(1, n*heads, 1, 1)        # 返回1*2*4*3，2个头，4*3为带上关注关系的4词        prob = ScaledDotProductAttention()(Q, K, V, attn*mask)        # 把2头重新拼接起来，变为 1*4*6        prob = prob.transpose(1, 2).contiguous()        prob = prob.view(batch, -1, n*heads * d*v).contiguous()        # 全连接层：对多头注意力的输出进行线性变换，从而更好地提取信息        output = self.fc(prob)        # 残差连接 & 归一化        res = self.layer_norm(residual + output) # return 1*4*6        return res
```

### # 3 Encoder

  

> 在 attention 概念中，有很关键的 "遮盖" 概念，先不细究，你debug一遍会更理解

  

```
def get*attn*pad*mask(seq*q, seq*k):  # 本质是结尾E做注意力遮盖，返回 1*4*4，最后一列为True    batch, len*q = seq*q.size()  # 1, 4    batch, len*k = seq*k.size()  # 1, 4    pad*attn*mask = seq*k.data.eq(0).unsqueeze(1)  # 为0则为true，变为f,f,f,true，意思是把0这个结尾标志为true    return pad*attn*mask.expand(batch, len*q, len*k)  # 扩展为1*4*4，最后一列为true，表示抹掉结尾对应的注意力def get*attn*subsequent*mask(seq):  # decoder的自我顺序注意力遮盖，右上三角形区为true的遮盖    attn*shape = [seq.size(0), seq.size(1), seq.size(1)]    subsequent*mask = np.triu(np.ones(attn*shape), k=1)    subsequent*mask = torch.from*numpy(subsequent*mask)    return subsequent*mask
```

  

```
class Encoder(nn.Module):    def **init**(self):        super(Encoder, self).**init**()        self.source*embedding = nn.Embedding(len(source*vocab), d*model)        self.attention = MultiHeadAttention()    def forward(self, encoder*input):        # input 1 * 4，1句话4个单词        # 1 * 4 * 6，将每个单词的整数字编码扩展到6个浮点数编码        embedded = self.source*embedding(encoder*input)        # 1 * 4 * 4 矩阵，最后一列为true，表示忽略结尾词的注意力机制        mask = get*attn*pad*mask(encoder*input, encoder*input)        # 1*4*6，带上关注力的4个词矩阵        encoder*output = self.attention(embedded, embedded, embedded, mask)        return encoder_output
```

  

4 Decoder

  

```
class Decoder(nn.Module):    def **init**(self):        super(Decoder, self).**init**()        self.target*embedding = nn.Embedding(len(target*vocab), d*model)        self.attention = MultiHeadAttention()    # 三入参形状分别为 1*4, 1*4, 1*4*6，前两者未被embedding，注意后面这个是 encoder*output    def forward(self, decoder*input, encoder*input, encoder*output):        # 编码为1*4*6        decoder*embedded = self.target*embedding(decoder*input)        # 1*4*4 全为false，表示没有结尾词        decoder*self*attn*mask = get*attn*pad*mask(decoder*input, decoder*input)        # 1*4*4 右上三角区为1，其余为0        decoder*subsequent*mask = get*attn*subsequent*mask(decoder*input)        # 1*4*4 右上三角区为true，其余为false        decoder*self*mask = torch.gt(decoder*self*attn*mask + decoder*subsequent*mask, 0)        # 1*4*6 带上注意力的4词矩阵【注：decoder里面，第1个attention】        decoder*output = self.attention(decoder*embedded, decoder*embedded, decoder*embedded, decoder*self*mask)        # 1*4*4 最后一列为true，表示E结尾词        decoder*encoder*attn*mask = get*attn*pad*mask(decoder*input, encoder*input)        # 输入均为 1*4*6，Q表示"S I eat meat"、K表示"我吃肉E"、V表示 "我吃肉E"        # 【注：decoder里面，第2个attention】        decoder*output = self.attention(decoder*output, encoder*output, encoder*output, decoder*encoder*attn*mask)        return decoder_output
```

### # 5 Transformer

```
class Transformer(nn.Module):    def **init**(self):        super(Transformer, self).**init**()        self.encoder = Encoder()        self.decoder = Decoder()        self.fc = nn.Linear(d*model, len(target*vocab), bias=False)    def forward(self, encoder*input, decoder*input):        # 入 1*4，出 1*4*6，作用："我吃肉E"，并带上三词间的关注力信息        encoder*output = self.encoder(encoder*input)        # 入 1*4, 1*4, 1*4*6=encoder*output        decoder*output = self.decoder(decoder*input, encoder*input, encoder*output)        # 预测出4个词，每个词对应到词典中5个词的概率，如下        # tensor([[[ 0.0755, -0.2646,  0.1279, -0.3735, -0.2351],[-1.2789,  0.6237, -0.6452,  1.1632,  0.6479]]]        decoder*logits = self.fc(decoder*output)        res = decoder*logits.view(-1, decoder_logits.size(-1))        return res
```

  

**2.3 训练模型**

  

```
model = Transformer().to(device)criterion = nn.CrossEntropyLoss()optimizer = optim.Adam(model.parameters(), lr=1e-1)for epoch in range(10):    # 输出4*5，代表预测出4个词，每个词对应到词典中5个词的概率    output = model(encoder*input, decoder*input)      # 和目标词 I eat meat E做差异计算    loss = criterion(output, target.view(-1))      print('Epoch:', '%04d' % (epoch + 1), 'loss =', '{:.6f}'.format(loss))    # 这个3个操作：清零梯度、算法梯度、更新参数    optimizer.zero_grad()    loss.backward()    optimizer.step()
```

  

**2.4 使用模型**

  

```
# 预测目标是5个单词target*len = len(target*vocab)  # 1*4*6 输入"我吃肉E"，先算【自注意力】encoder*output = model.encoder(encoder*input)  # 1*5 全是0，表示EEEEEdecoder*input = torch.zeros(1, target*len).type*as(encoder*input.data)  # 表示S开始字符next*symbol = 4  # 5个单词逐个预测【注意：是一个个追加词，不断往后预测的】for i in range(target*len):      # 譬如i=0第一轮，decoder输入为SEEEE，第二轮为S I EEE，把预测 I 给拼上去，继续循环    decoder*input[0][i] = next*symbol      # decoder 输出    decoder*output = model.decoder(decoder*input, encoder*input, encoder*output)    # 负责将解码器的输出映射到目标词汇表，每个元素表示对应目标词汇的分数    # 取出最大的五个词的下标，譬如[1, 3, 3, 3, 3] 表示 i,meat,meat,meat,meat    logits = model.fc(decoder*output).squeeze(0)    prob = logits.max(dim=1, keepdim=False)[1]    next*symbol = prob.data[i].item()  # 只取当前i    for k, v in target*vocab.items():        if v == next*symbol:            print('第', i, '轮:', k)            break    if next_symbol == 0:  # 遇到结尾了，那就完成翻译        break
```

## # **参考资料：**

  

1 https://jalammar.github.io/illustrated-transformer/

2 http://nlp.seas.harvard.edu/annotated-transformer/

3 gpt4：学习过程中有很多疑惑，真是一个好老师

var first\*sceen\*\*time = (+new Date()); if ("" == 1 && document.getElementById('js\*content')) { document.getElementById('js\_content').addEventListener("selectstart",function(e){ e.preventDefault(); }); }

预览时标签不可点

[](javascript:;)