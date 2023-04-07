### 1.0 conda环境准备

conda是很好用python管理工具，可以方便建立管理多个python环境。后面安装的步骤里我也会介绍一些常用的conda指令。

conda 我推荐使用安装miniconda，大家可以理解为精简版的anaconda，只保留了一些必备的组件，所以安装会比快上很多，同时也能满足我们管理python环境的需求。（anaconda一般在固态硬盘安装需要占用几个G内存，花费1-2个小时，miniconda一般几百M，10分钟就可以安装完成了）

miniconda推荐使用清华源下载：[https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/](https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/)

选择适合自己的版本就可以，

-   windows推荐地址：[https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-4.7.10-Windows-x86\_64.exe](https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-4.7.10-Windows-x86_64.exe)
-   ubuntu推荐地址：[https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-4.7.10-Linux-x86\_64.sh](https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-4.7.10-Linux-x86_64.sh)
-   Mac os推荐地址：[https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-4.7.10-MacOSX-x86\_64.pkg](https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-4.7.10-MacOSX-x86_64.pkg)

下以windows版本来安装miniconda作为演示，从上述下载合适版本，下载好后以管理员权限打开点击安装。



注意这两个都要勾选，一个是让我们可以直接在cmd使用conda指令，第二个是把miniconda自带的python3.7作为系统python。

安装好后就可以在cmd中使用conda指令了，cmd打开方式，windows键+R键，弹出输入框，输入cmd就进入了。也可以直接在windows搜索cmd点击运行。

下面介绍些cmd conda指令：

1.  查看conda环境：conda env list
2.  新建conda环境(env\_name就是创建的环境名，可以自定义)：conda create -n env\_name
3.  激活conda环境（ubuntu与Macos 将conda 替换为source）：conda activate env\_name
4.  退出conda环境：conda deactivate
5.  安装和卸载python包：conda install numpy # conda uninstall numpy
6.  查看已安装python列表：conda list -n env\_name

知道这些指令就可以开始使用conda新建一个环境安装TF2.0了。

### 1.1 TF2.0 CPU版本安装

TF CPU安装比较简单，因为不需要配置GPU，所以windows ubuntu macOS安装方式都类似，缺点就是运行速度慢，但是用于日常学习使用还是可以的。

下面以windows版本做演示：一下均在命令行操作

**1.1.0 新建TF2.0 CPU环境（使用conda 新建环境指令 python==3.6表示在新建环境时同时python3.6）**

```
conda create -n TF_2C python=3.6
```

当弹出 ：Proceed (\[y\]/n)? 输入y回车

完成后就可以进入此环境

**1.1.1 进入TF\_2C环境**

```
conda activate TF_2C
```

进入后我们就可以发现：(TF\_2C)在之前路径前面，表示进入了这个环境。使用conda deactivate可以退出。

我们再次进入 conda activate TF\_2C ，便于执行下述命令

**1.1.2 安装TF2.0 CPU版本（后面的 -i 表示从国内清华源下载，速度比默认源快很多）**

```
pip install tensorflow==2.0.0 -i https://pypi.tuna.tsinghua.edu.cn/simple
```

如果网不好的，多执行几次。然后过一会就安装好啦。下面我们做下简单测试。

**1.1.3 测试TF2.0 CPU版本(把下面代码保存到demo.py使用TF\_2C python运行)**  

```python
import tensorflow as tf
version = tf.__version__
gpu_ok = tf.test.is_gpu_available()
print("tf version:",version,"\nuse GPU",gpu_ok)
```

如果没有问题的话输出结果如下：可以看到tf 版本为2.0.0 因为是cpu版本，所以gpu 为False

```
tf version: 2.0.0
use GPU False
```

### 1.2 TF2.0 GPU版本安装

GPU版本和CPU类似，但是会多一步对于GPU支持的安装。下面来一步步实现。安装之前确认你的电脑拥有Nvidia的GPU

**1.2.0 新建TF2.0 GPU环境（使用conda 新建环境指令 python==3.6表示在新建环境时同时python3.6）**

```
conda create -n TF_2G python=3.6
```



当弹出 ：Proceed (\[y\]/n)? 输入y回车

完成后就可以进入此环境

**1.1.1 进入TF\_2G环境**

```
conda activate TF_2G
```



**1.1.2 安装GPU版本支持，拥有Nvidia的GPU的windows一般都有默认驱动的，只需要安装cudatoolkit 与 cudnn包就可以了，要注意一点需要安装cudatoolkit 10.0 版本，注意一点，如果系统的cudatoolkit小于10.0需要更新一下至10.0**

```
conda install cudatoolkit=10.0 cudnn=7
```



**1.1.3 安装TF2.0 GPU版本（后面的 -i 表示从国内清华源下载，速度比默认源快很多）**

```
pip install tensorflow-gpu==2.0.0 -i https://pypi.tuna.tsinghua.edu.cn/simple
```



如果网不好的，多执行几次。然后过一会就安装好啦。下面我们做下简单测试。

**1.1.3 测试TF2.0 GPU版本(把下面代码保存到demo.py使用TF\_2G python运行)**

```python
import tensorflow as tf
version = tf.__version__
gpu_ok = tf.test.is_gpu_available()
print("tf version:",version,"\nuse GPU",gpu_ok)
```

如果没有问题的话输出结果如下：可以看到tf 版本为2.0.0 因为是gpu版本，所以gpu 为True，这表示GPU版本安装完成了。

```python
tf version: 2.0.0
use GPU True
```

### 1.2 最后我们测试一个使用TF2.0版本方式写的线性拟合代码

把下述代码保存为main.py

```python
import tensorflow as tf
 
X = tf.constant([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]])
y = tf.constant([[10.0], [20.0]])
 
 
class Linear(tf.keras.Model):
    def __init__(self):
        super().__init__()
        self.dense = tf.keras.layers.Dense(
            units=1,
            activation=None,
            kernel_initializer=tf.zeros_initializer(),
            bias_initializer=tf.zeros_initializer()
        )
 
    def call(self, input):
        output = self.dense(input)
        return output
 
 
# 以下代码结构与前节类似
model = Linear()
optimizer = tf.keras.optimizers.SGD(learning_rate=0.01)
for i in range(100):
    with tf.GradientTape() as tape:
        y_pred = model(X)      # 调用模型 y_pred = model(X) 而不是显式写出 y_pred = a * X + b
        loss = tf.reduce_mean(tf.square(y_pred - y))
     
    grads = tape.gradient(loss, model.variables)    # 使用 model.variables 这一属性直接获得模型中的所有变量
    optimizer.apply_gradients(grads_and_vars=zip(grads, model.variables))
    if i % 10 == 0:
        print(i, loss.numpy())
print(model.variables)
```

### 输出结果如下：

```python
0 250.0
10 0.73648137
20 0.6172349
30 0.5172956
40 0.4335389
50 0.36334264
60 0.3045124
70 0.25520816
80 0.2138865
90 0.17925593
[<tf.Variable 'linear/dense/kernel:0' shape=(3, 1) dtype=float32, numpy=
array([[0.40784496],
       [1.191065  ],
       [1.9742855 ]], dtype=float32)>, <tf.Variable 'linear/dense/bias:0' shape=(1,) dtype=float32, numpy=array([0.78322077], dtype=float32)>]
```



## 1. 后记

回复两个评论区问的较为多的问题：

> 新建tf环境了之后在安装，是必须的嘛？我几次都是直接在root里安装了

回复： 不新建环境直接安装时使用的是默认的环境安装。不建议这么操作，都在默认环境安装新的模块后面可能会有冲突。建议不同任务使用不同环境。。

> 使用conda install就不需要事先配置cudatoolkit和cudnn了。（cudatoolkit和cudnn版本问题）

回复： 目前tf2.0还不支持conda install，只能使用pip install。windows可以直接使用conda install cudatoolkit cudnn。要注意一点，tf1.14以上要使用cudatoolkit >= 10.0。由于windows10默认cudatoolkit是9版本的，需要手动安装10版本。其实他们关系是向下包容，就是如果你装了10版本，那么9，8，7版本都可以用conda安装