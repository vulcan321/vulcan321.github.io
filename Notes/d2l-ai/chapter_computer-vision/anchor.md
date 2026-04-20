# 锚框
:label:`sec_anchor`

目标检测算法通常会在输入图像中采样大量的区域，然后判断这些区域中是否包含我们感兴趣的目标，并调整区域边界从而更准确地预测目标的*真实边界框*（ground-truth bounding box）。
不同的模型使用的区域采样方法可能不同。
这里我们介绍其中的一种方法：以每个像素为中心，生成多个缩放比和宽高比（aspect ratio）不同的边界框。
这些边界框被称为*锚框*（anchor box）我们将在 :numref:`sec_ssd`中设计一个基于锚框的目标检测模型。

首先，让我们修改输出精度，以获得更简洁的输出。

```{.python .input}
%matplotlib inline
from d2l import mxnet as d2l
from mxnet import gluon, image, np, npx

np.set_printoptions(2)  # 精简输出精度
npx.set_np()
```

```{.python .input}
# @tab pytorch
%matplotlib inline
from d2l import torch as d2l
import torch

torch.set_printoptions(2)  # 精简输出精度
```

```{.python .input}
# @tab paddle
%matplotlib inline
from d2l import paddle as d2l
import warnings
warnings.filterwarnings("ignore")
import paddle
import numpy as np

paddle.set_printoptions(2)  # 精简输出精度
```

# # 生成多个锚框

假设输入图像的高度为$h$，宽度为$w$。
我们以图像的每个像素为中心生成不同形状的锚框：*缩放比*为$s\in (0, 1]$，*宽高比*为$r > 0$。
那么[**锚框的宽度和高度分别是$hs\sqrt{r}$和$hs/\sqrt{r}$。**]
请注意，当中心位置给定时，已知宽和高的锚框是确定的。

要生成多个不同形状的锚框，让我们设置许多缩放比（scale）取值$s*1,\ldots, s*n$和许多宽高比（aspect ratio）取值$r*1,\ldots, r*m$。
当使用这些比例和长宽比的所有组合以每个像素为中心时，输入图像将总共有$whnm$个锚框。
尽管这些锚框可能会覆盖所有真实边界框，但计算复杂性很容易过高。
在实践中，(**我们只考虑**)包含$s*1$或$r*1$的(**组合：**)

(**
$$(s*1, r*1), (s*1, r*2), \ldots, (s*1, r*m), (s*2, r*1), (s*3, r*1), \ldots, (s*n, r*1).$$
**)

也就是说，以同一像素为中心的锚框的数量是$n+m-1$。
对于整个输入图像，将共生成$wh(n+m-1)$个锚框。

上述生成锚框的方法在下面的`multibox_prior`函数中实现。
我们指定输入图像、尺寸列表和宽高比列表，然后此函数将返回所有的锚框。

```{.python .input}
# @save
def multibox_prior(data, sizes, ratios):
    """生成以每个像素为中心具有不同形状的锚框"""
    in*height, in*width = data.shape[-2:]
    device, num*sizes, num*ratios = data.ctx, len(sizes), len(ratios)
    boxes*per*pixel = (num*sizes + num*ratios - 1)
    size_tensor = d2l.tensor(sizes, ctx=device)
    ratio_tensor = d2l.tensor(ratios, ctx=device)

    # 为了将锚点移动到像素的中心，需要设置偏移量。
    # 因为一个像素的高为1且宽为1，我们选择偏移我们的中心0.5
    offset*h, offset*w = 0.5, 0.5
    steps*h = 1.0 / in*height  # 在y轴上缩放步长
    steps*w = 1.0 / in*width  # 在x轴上缩放步长

    # 生成锚框的所有中心点
    center*h = (d2l.arange(in*height, ctx=device) + offset*h) * steps*h
    center*w = (d2l.arange(in*width, ctx=device) + offset*w) * steps*w
    shift*x, shift*y = d2l.meshgrid(center*w, center*h)
    shift*x, shift*y = shift*x.reshape(-1), shift*y.reshape(-1)

    # 生成“boxes*per*pixel”个高和宽，
    # 之后用于创建锚框的四角坐标(xmin,xmax,ymin,ymax)
    w = np.concatenate((size*tensor * np.sqrt(ratio*tensor[0]),
                        sizes[0] * np.sqrt(ratio_tensor[1:]))) \
                        * in*height / in*width  # 处理矩形输入
    h = np.concatenate((size*tensor / np.sqrt(ratio*tensor[0]),
                        sizes[0] / np.sqrt(ratio_tensor[1:])))
    # 除以2来获得半高和半宽
    anchor_manipulations = np.tile(np.stack((-w, -h, w, h)).T,
                                   (in*height * in*width, 1)) / 2

    # 每个中心点都将有“boxes*per*pixel”个锚框，
    # 所以生成含所有锚框中心的网格，重复了“boxes*per*pixel”次
    out*grid = d2l.stack([shift*x, shift*y, shift*x, shift_y],
                         axis=1).repeat(boxes*per*pixel, axis=0)
    output = out*grid + anchor*manipulations
    return np.expand_dims(output, axis=0)
```

```{.python .input}
# @tab pytorch
# @save
def multibox_prior(data, sizes, ratios):
    """生成以每个像素为中心具有不同形状的锚框"""
    in*height, in*width = data.shape[-2:]
    device, num*sizes, num*ratios = data.device, len(sizes), len(ratios)
    boxes*per*pixel = (num*sizes + num*ratios - 1)
    size_tensor = d2l.tensor(sizes, device=device)
    ratio_tensor = d2l.tensor(ratios, device=device)

    # 为了将锚点移动到像素的中心，需要设置偏移量。
    # 因为一个像素的高为1且宽为1，我们选择偏移我们的中心0.5
    offset*h, offset*w = 0.5, 0.5
    steps*h = 1.0 / in*height  # 在y轴上缩放步长
    steps*w = 1.0 / in*width  # 在x轴上缩放步长

    # 生成锚框的所有中心点
    center*h = (torch.arange(in*height, device=device) + offset*h) * steps*h
    center*w = (torch.arange(in*width, device=device) + offset*w) * steps*w
    shift*y, shift*x = torch.meshgrid(center*h, center*w, indexing='ij')
    shift*y, shift*x = shift*y.reshape(-1), shift*x.reshape(-1)

    # 生成“boxes*per*pixel”个高和宽，
    # 之后用于创建锚框的四角坐标(xmin,xmax,ymin,ymax)
    w = torch.cat((size*tensor * torch.sqrt(ratio*tensor[0]),
                   sizes[0] * torch.sqrt(ratio_tensor[1:])))\
                   * in*height / in*width  # 处理矩形输入
    h = torch.cat((size*tensor / torch.sqrt(ratio*tensor[0]),
                   sizes[0] / torch.sqrt(ratio_tensor[1:])))
    # 除以2来获得半高和半宽
    anchor_manipulations = torch.stack((-w, -h, w, h)).T.repeat(
                                        in*height * in*width, 1) / 2

    # 每个中心点都将有“boxes*per*pixel”个锚框，
    # 所以生成含所有锚框中心的网格，重复了“boxes*per*pixel”次
    out*grid = torch.stack([shift*x, shift*y, shift*x, shift_y],
                dim=1).repeat*interleave(boxes*per_pixel, dim=0)
    output = out*grid + anchor*manipulations
    return output.unsqueeze(0)
```

```{.python .input}
# @tab paddle
# @save
def multibox_prior(data, sizes, ratios):
    """生成以每个像素为中心具有不同形状的锚框"""
    in*height, in*width = data.shape[-2:]
    place, num*sizes, num*ratios = data.place, len(sizes), len(ratios)
    boxes*per*pixel = (num*sizes + num*ratios - 1)
    size*tensor = paddle.to*tensor(sizes, place=place)
    ratio*tensor = paddle.to*tensor(ratios, place=place)

    # 为了将锚点移动到像素的中心，需要设置偏移量。
    # 因为一个像素的的高为1且宽为1，我们选择偏移我们的中心0.5
    offset*h, offset*w = 0.5, 0.5
    steps*h = 1.0 / in*height  # 在y轴上缩放步长
    steps*w = 1.0 / in*width  # 在x轴上缩放步长

    # 生成锚框的所有中心点
    center*h = (paddle.arange(in*height) + offset*h) * steps*h
    center*w = (paddle.arange(in*width) + offset*w) * steps*w
    shift*y, shift*x = paddle.meshgrid(center*h, center*w)
    shift*y, shift*x = shift*y.reshape([-1]), shift*x.reshape([-1])

    # 生成“boxes*per*pixel”个高和宽，
    # 之后用于创建锚框的四角坐标(xmin,xmax,ymin,ymax)
    w = paddle.concat((size*tensor * paddle.sqrt(ratio*tensor[0]),
                       sizes[0] * paddle.sqrt(ratio_tensor[1:])))\
                       * in*height / in*width  # 处理矩形输入
    h = paddle.concat((size*tensor / paddle.sqrt(ratio*tensor[0]),
                   sizes[0] / paddle.sqrt(ratio_tensor[1:])))
    # 除以2来获得半高和半宽
    anchor_manipulations = paddle.tile(paddle.stack((-w, -h, w, h)).T,
                                        (in*height * in*width, 1)) / 2

    # 每个中心点都将有“boxes*per*pixel”个锚框，
    # 所以生成含所有锚框中心的网格，重复了“boxes*per*pixel”次
    out*grid = paddle.stack([shift*x, shift*y, shift*x, shift_y], axis=1)
    out*grid = paddle.tile(out*grid, repeat*times=[boxes*per*pixel]).reshape((-1, out*grid.shape[1]))
    output = out*grid + anchor*manipulations
    return output.unsqueeze(0)
```

可以看到[**返回的锚框变量`Y`的形状**]是（批量大小，锚框的数量，4）。

```{.python .input}
img = image.imread('../img/catdog.jpg').asnumpy()
h, w = img.shape[:2]

print(h, w)
X = np.random.uniform(size=(1, 3, h, w))
Y = multibox_prior(X, sizes=[0.75, 0.5, 0.25], ratios=[1, 2, 0.5])
Y.shape
```

```{.python .input}
# @tab pytorch
img = d2l.plt.imread('../img/catdog.jpg')
h, w = img.shape[:2]

print(h, w)
X = torch.rand(size=(1, 3, h, w))
Y = multibox_prior(X, sizes=[0.75, 0.5, 0.25], ratios=[1, 2, 0.5])
Y.shape
```

```{.python .input}
# @tab paddle
img = d2l.plt.imread('../img/catdog.jpg')
h, w = img.shape[:2]

print(h, w)
X = paddle.rand(shape=(1, 3, h, w))
Y = multibox_prior(X, sizes=[0.75, 0.5, 0.25], ratios=[1, 2, 0.5])
Y.shape
```

将锚框变量`Y`的形状更改为(图像高度,图像宽度,以同一像素为中心的锚框的数量,4)后，我们可以获得以指定像素的位置为中心的所有锚框。
在接下来的内容中，我们[**访问以（250,250）为中心的第一个锚框**]。
它有四个元素：锚框左上角的$(x, y)$轴坐标和右下角的$(x, y)$轴坐标。
输出中两个轴的坐标各分别除以了图像的宽度和高度。

```{.python .input}
# @tab mxnet, pytorch
boxes = Y.reshape(h, w, 5, 4)
boxes[250, 250, 0, :]
```

```{.python .input}
# @tab paddle
boxes = Y.reshape([h, w, 5, 4])
boxes[250, 250, 0, :]
```

为了[**显示以图像中以某个像素为中心的所有锚框**]，定义下面的`show_bboxes`函数来在图像上绘制多个边界框。

```{.python .input}
# @tab all
# @save
def show_bboxes(axes, bboxes, labels=None, colors=None):
    """显示所有边界框"""
    def *make*list(obj, default_values=None):
        if obj is None:
            obj = default_values
        elif not isinstance(obj, (list, tuple)):
            obj = [obj]
        return obj
        
    labels = *make*list(labels)
    colors = *make*list(colors, ['b', 'g', 'r', 'm', 'c'])
    for i, bbox in enumerate(bboxes):
        color = colors[i % len(colors)]
        rect = d2l.bbox*to*rect(d2l.numpy(bbox), color)
        axes.add_patch(rect)
        if labels and len(labels) > i:
            text_color = 'k' if color == 'w' else 'w'
            axes.text(rect.xy[0], rect.xy[1], labels[i],
                      va='center', ha='center', fontsize=9, color=text_color,
                      bbox=dict(facecolor=color, lw=0))
```

正如从上面代码中所看到的，变量`boxes`中$x$轴和$y$轴的坐标值已分别除以图像的宽度和高度。
绘制锚框时，我们需要恢复它们原始的坐标值。
因此，在下面定义了变量`bbox_scale`。
现在可以绘制出图像中所有以(250,250)为中心的锚框了。
如下所示，缩放比为0.75且宽高比为1的蓝色锚框很好地围绕着图像中的狗。

```{.python .input}
# @tab all
d2l.set_figsize()
bbox_scale = d2l.tensor((w, h, w, h))
fig = d2l.plt.imshow(img)
show*bboxes(fig.axes, boxes[250, 250, :, :] * bbox*scale,
            ['s=0.75, r=1', 's=0.5, r=1', 's=0.25, r=1', 's=0.75, r=2',
             's=0.75, r=0.5'])
```

# # [**交并比（IoU）**]

我们刚刚提到某个锚框“较好地”覆盖了图像中的狗。
如果已知目标的真实边界框，那么这里的“好”该如何如何量化呢？
直观地说，可以衡量锚框和真实边界框之间的相似性。
*杰卡德系数*（Jaccard）可以衡量两组之间的相似性。
给定集合$\mathcal{A}$和$\mathcal{B}$，他们的杰卡德系数是他们交集的大小除以他们并集的大小：

$$J(\mathcal{A},\mathcal{B}) = \frac{\left|\mathcal{A} \cap \mathcal{B}\right|}{\left| \mathcal{A} \cup \mathcal{B}\right|}.$$

事实上，我们可以将任何边界框的像素区域视为一组像素。通
过这种方式，我们可以通过其像素集的杰卡德系数来测量两个边界框的相似性。
对于两个边界框，它们的杰卡德系数通常称为*交并比*（intersection over union，IoU），即两个边界框相交面积与相并面积之比，如 :numref:`fig_iou`所示。
交并比的取值范围在0和1之间：0表示两个边界框无重合像素，1表示两个边界框完全重合。

![交并比是两个边界框相交面积与相并面积之比。](../img/iou.svg)
:label:`fig_iou`

接下来部分将使用交并比来衡量锚框和真实边界框之间、以及不同锚框之间的相似度。
给定两个锚框或边界框的列表，以下`box_iou`函数将在这两个列表中计算它们成对的交并比。

```{.python .input}
# @save
def box_iou(boxes1, boxes2):
    """计算两个锚框或边界框列表中成对的交并比"""
    box_area = lambda boxes: ((boxes[:, 2] - boxes[:, 0]) *
                              (boxes[:, 3] - boxes[:, 1]))
    # boxes1,boxes2,areas1,areas2的形状:
    # boxes1：(boxes1的数量,4),
    # boxes2：(boxes2的数量,4),
    # areas1：(boxes1的数量,),
    # areas2：(boxes2的数量,)
    areas1 = box_area(boxes1)
    areas2 = box_area(boxes2)

    # inter*upperlefts,inter*lowerrights,inters的形状:
    # (boxes1的数量,boxes2的数量,2)
    inter_upperlefts = np.maximum(boxes1[:, None, :2], boxes2[:, :2])
    inter_lowerrights = np.minimum(boxes1[:, None, 2:], boxes2[:, 2:])
    inters = (inter*lowerrights - inter*upperlefts).clip(min=0)
    # inter*areasandunion*areas的形状:(boxes1的数量,boxes2的数量)
    inter_areas = inters[:, :, 0] * inters[:, :, 1]
    union*areas = areas1[:, None] + areas2 - inter*areas
    return inter*areas / union*areas
```

```{.python .input}
# @tab pytorch
# @save
def box_iou(boxes1, boxes2):
    """计算两个锚框或边界框列表中成对的交并比"""
    box_area = lambda boxes: ((boxes[:, 2] - boxes[:, 0]) *
                              (boxes[:, 3] - boxes[:, 1]))
    # boxes1,boxes2,areas1,areas2的形状:
    # boxes1：(boxes1的数量,4),
    # boxes2：(boxes2的数量,4),
    # areas1：(boxes1的数量,),
    # areas2：(boxes2的数量,)
    areas1 = box_area(boxes1)
    areas2 = box_area(boxes2)
    # inter*upperlefts,inter*lowerrights,inters的形状:
    # (boxes1的数量,boxes2的数量,2)
    inter_upperlefts = torch.max(boxes1[:, None, :2], boxes2[:, :2])
    inter_lowerrights = torch.min(boxes1[:, None, 2:], boxes2[:, 2:])
    inters = (inter*lowerrights - inter*upperlefts).clamp(min=0)
    # inter*areasandunion*areas的形状:(boxes1的数量,boxes2的数量)
    inter_areas = inters[:, :, 0] * inters[:, :, 1]
    union*areas = areas1[:, None] + areas2 - inter*areas
    return inter*areas / union*areas
```

```{.python .input}
# @tab paddle
# @save
def box_iou(boxes1, boxes2):
    """计算两个锚框或边界框列表中成对的交并比"""
    box_area = lambda boxes: ((boxes[:, 2] - boxes[:, 0]) *
                              (boxes[:, 3] - boxes[:, 1]))
    # boxes1,boxes2,areas1,areas2的形状:
    # boxes1：(boxes1的数量,4),
    # boxes2：(boxes2的数量,4),
    # areas1：(boxes1的数量,),
    # areas2：(boxes2的数量,)
    areas1 = box_area(boxes1)
    areas2 = box_area(boxes2)
    # inter*upperlefts,inter*lowerrights,inters的形状:
    # (boxes1的数量,boxes2的数量,2)
    inter_upperlefts = paddle.maximum(boxes1[:, None, :2], boxes2[:, :2])
    inter_lowerrights = paddle.minimum(boxes1[:, None, 2:], boxes2[:, 2:])
    inters = (inter*lowerrights - inter*upperlefts).clip(min=0)
    # inter*areasandunion*areas的形状:(boxes1的数量,boxes2的数量)
    inter_areas = inters[:, :, 0] * inters[:, :, 1]
    union*areas = areas1[:, None] + areas2 - inter*areas
    return inter*areas / union*areas
```

# # 在训练数据中标注锚框
:label:`subsec_labeling-anchor-boxes`

在训练集中，我们将每个锚框视为一个训练样本。
为了训练目标检测模型，我们需要每个锚框的*类别*（class）和*偏移量*（offset）标签，其中前者是与锚框相关的对象的类别，后者是真实边界框相对于锚框的偏移量。
在预测时，我们为每个图像生成多个锚框，预测所有锚框的类别和偏移量，根据预测的偏移量调整它们的位置以获得预测的边界框，最后只输出符合特定条件的预测边界框。

目标检测训练集带有*真实边界框*的位置及其包围物体类别的标签。
要标记任何生成的锚框，我们可以参考分配到的最接近此锚框的真实边界框的位置和类别标签。
下文将介绍一个算法，它能够把最接近的真实边界框分配给锚框。

## # [**将真实边界框分配给锚框**]

给定图像，假设锚框是$A*1, A*2, \ldots, A*{n*a}$，真实边界框是$B*1, B*2, \ldots, B*{n*b}$，其中$n*a \geq n*b$。
让我们定义一个矩阵$\mathbf{X} \in \mathbb{R}^{n*a \times n*b}$，其中第$i$行、第$j$列的元素$x*{ij}$是锚框$A*i$和真实边界框$B_j$的IoU。
该算法包含以下步骤。

1. 在矩阵$\mathbf{X}$中找到最大的元素，并将它的行索引和列索引分别表示为$i*1$和$j*1$。然后将真实边界框$B*{j*1}$分配给锚框$A*{i*1}$。这很直观，因为$A*{i*1}$和$B*{j*1}$是所有锚框和真实边界框配对中最相近的。在第一个分配完成后，丢弃矩阵中${i*1}^\mathrm{th}$行和${j*1}^\mathrm{th}$列中的所有元素。
1. 在矩阵$\mathbf{X}$中找到剩余元素中最大的元素，并将它的行索引和列索引分别表示为$i*2$和$j*2$。我们将真实边界框$B*{j*2}$分配给锚框$A*{i*2}$，并丢弃矩阵中${i*2}^\mathrm{th}$行和${j*2}^\mathrm{th}$列中的所有元素。
1. 此时，矩阵$\mathbf{X}$中两行和两列中的元素已被丢弃。我们继续，直到丢弃掉矩阵$\mathbf{X}$中$n*b$列中的所有元素。此时已经为这$n*b$个锚框各自分配了一个真实边界框。
1. 只遍历剩下的$n*a - n*b$个锚框。例如，给定任何锚框$A*i$，在矩阵$\mathbf{X}$的第$i^\mathrm{th}$行中找到与$A*i$的IoU最大的真实边界框$B*j$，只有当此IoU大于预定义的阈值时，才将$B*j$分配给$A_i$。

下面用一个具体的例子来说明上述算法。
如 :numref:`fig*anchor*label`（左）所示，假设矩阵$\mathbf{X}$中的最大值为$x*{23}$，我们将真实边界框$B*3$分配给锚框$A_2$。
然后，我们丢弃矩阵第2行和第3列中的所有元素，在剩余元素（阴影区域）中找到最大的$x*{71}$，然后将真实边界框$B*1$分配给锚框$A_7$。
接下来，如 :numref:`fig*anchor*label`（中）所示，丢弃矩阵第7行和第1列中的所有元素，在剩余元素（阴影区域）中找到最大的$x*{54}$，然后将真实边界框$B*4$分配给锚框$A_5$。
最后，如 :numref:`fig*anchor*label`（右）所示，丢弃矩阵第5行和第4列中的所有元素，在剩余元素（阴影区域）中找到最大的$x*{92}$，然后将真实边界框$B*2$分配给锚框$A_9$。
之后，我们只需要遍历剩余的锚框$A*1, A*3, A*4, A*6, A_8$，然后根据阈值确定是否为它们分配真实边界框。

![将真实边界框分配给锚框。](../img/anchor-label.svg)
:label:`fig*anchor*label`

此算法在下面的`assign*anchor*to_bbox`函数中实现。

```{.python .input}
# @save
def assign*anchor*to*bbox(ground*truth, anchors, device, iou_threshold=0.5):
    """将最接近的真实边界框分配给锚框"""
    num*anchors, num*gt*boxes = anchors.shape[0], ground*truth.shape[0]
    # 位于第i行和第j列的元素x_ij是锚框i和真实边界框j的IoU
    jaccard = box*iou(anchors, ground*truth)
    # 对于每个锚框，分配的真实边界框的张量
    anchors*bbox*map = np.full((num_anchors,), -1, dtype=np.int32, ctx=device)
    # 根据阈值，决定是否分配真实边界框
    max_ious, indices = np.max(jaccard, axis=1), np.argmax(jaccard, axis=1)
    anc*i = np.nonzero(max*ious >= iou_threshold)[0]
    box*j = indices[max*ious >= iou_threshold]
    anchors*bbox*map[anc*i] = box*j
    col*discard = np.full((num*anchors,), -1)
    row*discard = np.full((num*gt_boxes,), -1)
    for * in range(num*gt_boxes):
        max_idx = np.argmax(jaccard)
        box*idx = (max*idx % num*gt*boxes).astype('int32')
        anc*idx = (max*idx / num*gt*boxes).astype('int32')
        anchors*bbox*map[anc*idx] = box*idx
        jaccard[:, box*idx] = col*discard
        jaccard[anc*idx, :] = row*discard
    return anchors*bbox*map
```

```{.python .input}
# @tab pytorch
# @save
def assign*anchor*to*bbox(ground*truth, anchors, device, iou_threshold=0.5):
    """将最接近的真实边界框分配给锚框"""
    num*anchors, num*gt*boxes = anchors.shape[0], ground*truth.shape[0]
    # 位于第i行和第j列的元素x_ij是锚框i和真实边界框j的IoU
    jaccard = box*iou(anchors, ground*truth)
    # 对于每个锚框，分配的真实边界框的张量
    anchors*bbox*map = torch.full((num_anchors,), -1, dtype=torch.long,
                                  device=device)
    # 根据阈值，决定是否分配真实边界框
    max_ious, indices = torch.max(jaccard, dim=1)
    anc*i = torch.nonzero(max*ious >= iou_threshold).reshape(-1)
    box*j = indices[max*ious >= iou_threshold]
    anchors*bbox*map[anc*i] = box*j
    col*discard = torch.full((num*anchors,), -1)
    row*discard = torch.full((num*gt_boxes,), -1)
    for * in range(num*gt_boxes):
        max_idx = torch.argmax(jaccard)
        box*idx = (max*idx % num*gt*boxes).long()
        anc*idx = (max*idx / num*gt*boxes).long()
        anchors*bbox*map[anc*idx] = box*idx
        jaccard[:, box*idx] = col*discard
        jaccard[anc*idx, :] = row*discard
    return anchors*bbox*map
```

```{.python .input}
# @tab paddle
# @save
def assign*anchor*to*bbox(ground*truth, anchors, place, iou_threshold=0.5):
    """将最接近的真实边界框分配给锚框"""
    num*anchors, num*gt*boxes = anchors.shape[0], ground*truth.shape[0]
    # 位于第i行和第j列的元素x_ij是锚框i和真实边界框j的IoU
    jaccard = box*iou(anchors, ground*truth)
    # 对于每个锚框，分配的真实边界框的张量
    anchors*bbox*map = paddle.full((num_anchors,), -1, dtype=paddle.int64)
    # 根据阈值，决定是否分配真实边界框
    max_ious = paddle.max(jaccard, axis=1)
    indices = paddle.argmax(jaccard, axis=1)
    anc*i = paddle.nonzero(max*ious >= 0.5).reshape([-1])
    box*j = indices[max*ious >= 0.5]
    anchors*bbox*map[anc*i] = box*j
    col*discard = paddle.full((num*anchors,), -1)
    row*discard = paddle.full((num*gt_boxes,), -1)
    for * in range(num*gt_boxes):
        max_idx = paddle.argmax(jaccard)
        box*idx = paddle.cast((max*idx % num*gt*boxes), dtype='int64')
        anc*idx = paddle.cast((max*idx / num*gt*boxes), dtype='int64')
        anchors*bbox*map[anc*idx] = box*idx
        jaccard[:, box*idx] = col*discard
        jaccard[anc*idx, :] = row*discard
    return anchors*bbox*map
```

## # 标记类别和偏移量

现在我们可以为每个锚框标记类别和偏移量了。
假设一个锚框$A$被分配了一个真实边界框$B$。
一方面，锚框$A$的类别将被标记为与$B$相同。
另一方面，锚框$A$的偏移量将根据$B$和$A$中心坐标的相对位置以及这两个框的相对大小进行标记。
鉴于数据集内不同的框的位置和大小不同，我们可以对那些相对位置和大小应用变换，使其获得分布更均匀且易于拟合的偏移量。
这里介绍一种常见的变换。
[**给定框$A$和$B$，中心坐标分别为$(x*a, y*a)$和$(x*b, y*b)$，宽度分别为$w*a$和$w*b$，高度分别为$h*a$和$h*b$，可以将$A$的偏移量标记为：

$$\left( \frac{ \frac{x*b - x*a}{w*a} - \mu*x }{\sigma_x},
\frac{ \frac{y*b - y*a}{h*a} - \mu*y }{\sigma_y},
\frac{ \log \frac{w*b}{w*a} - \mu*w }{\sigma*w},
\frac{ \log \frac{h*b}{h*a} - \mu*h }{\sigma*h}\right),$$
**]
其中常量的默认值为 $\mu*x = \mu*y = \mu*w = \mu*h = 0, \sigma*x=\sigma*y=0.1$ ， $\sigma*w=\sigma*h=0.2$。
这种转换在下面的 `offset_boxes` 函数中实现。

```{.python .input}
# @tab all
# @save
def offset*boxes(anchors, assigned*bb, eps=1e-6):
    """对锚框偏移量的转换"""
    c*anc = d2l.box*corner*to*center(anchors)
    c*assigned*bb = d2l.box*corner*to*center(assigned*bb)
    offset*xy = 10 * (c*assigned*bb[:, :2] - c*anc[:, :2]) / c_anc[:, 2:]
    offset*wh = 5 * d2l.log(eps + c*assigned*bb[:, 2:] / c*anc[:, 2:])
    offset = d2l.concat([offset*xy, offset*wh], axis=1)
    return offset
```

如果一个锚框没有被分配真实边界框，我们只需将锚框的类别标记为*背景*（background）。
背景类别的锚框通常被称为*负类*锚框，其余的被称为*正类*锚框。
我们使用真实边界框（`labels`参数）实现以下`multibox_target`函数，来[**标记锚框的类别和偏移量**]（`anchors`参数）。
此函数将背景类别的索引设置为零，然后将新类别的整数索引递增一。

```{.python .input}
# @save
def multibox_target(anchors, labels):
    """使用真实边界框标记锚框"""
    batch_size, anchors = labels.shape[0], anchors.squeeze(0)
    batch*offset, batch*mask, batch*class*labels = [], [], []
    device, num_anchors = anchors.ctx, anchors.shape[0]
    for i in range(batch_size):
        label = labels[i, :, :]
        anchors*bbox*map = assign*anchor*to_bbox(
            label[:, 1:], anchors, device)
        bbox*mask = np.tile((np.expand*dims((anchors*bbox*map >= 0),
                                            axis=-1)), (1, 4)).astype('int32')
        # 将类标签和分配的边界框坐标初始化为零
        class*labels = d2l.zeros(num*anchors, dtype=np.int32, ctx=device)
        assigned*bb = d2l.zeros((num*anchors, 4), dtype=np.float32,
                                ctx=device)
        # 使用真实边界框来标记锚框的类别。
        # 如果一个锚框没有被分配，标记其为背景（值为零）
        indices*true = np.nonzero(anchors*bbox_map >= 0)[0]
        bb*idx = anchors*bbox*map[indices*true]
        class*labels[indices*true] = label[bb_idx, 0].astype('int32') + 1
        assigned*bb[indices*true] = label[bb_idx, 1:]
        # 偏移量转换
        offset = offset*boxes(anchors, assigned*bb) * bbox_mask
        batch_offset.append(offset.reshape(-1))
        batch*mask.append(bbox*mask.reshape(-1))
        batch*class*labels.append(class_labels)
    bbox*offset = d2l.stack(batch*offset)
    bbox*mask = d2l.stack(batch*mask)
    class*labels = d2l.stack(batch*class_labels)
    return (bbox*offset, bbox*mask, class_labels)
```

```{.python .input}
# @tab pytorch
# @save
def multibox_target(anchors, labels):
    """使用真实边界框标记锚框"""
    batch_size, anchors = labels.shape[0], anchors.squeeze(0)
    batch*offset, batch*mask, batch*class*labels = [], [], []
    device, num_anchors = anchors.device, anchors.shape[0]
    for i in range(batch_size):
        label = labels[i, :, :]
        anchors*bbox*map = assign*anchor*to_bbox(
            label[:, 1:], anchors, device)
        bbox*mask = ((anchors*bbox_map >= 0).float().unsqueeze(-1)).repeat(
            1, 4)
        # 将类标签和分配的边界框坐标初始化为零
        class*labels = torch.zeros(num*anchors, dtype=torch.long,
                                   device=device)
        assigned*bb = torch.zeros((num*anchors, 4), dtype=torch.float32,
                                  device=device)
        # 使用真实边界框来标记锚框的类别。
        # 如果一个锚框没有被分配，标记其为背景（值为零）
        indices*true = torch.nonzero(anchors*bbox_map >= 0)
        bb*idx = anchors*bbox*map[indices*true]
        class*labels[indices*true] = label[bb_idx, 0].long() + 1
        assigned*bb[indices*true] = label[bb_idx, 1:]
        # 偏移量转换
        offset = offset*boxes(anchors, assigned*bb) * bbox_mask
        batch_offset.append(offset.reshape(-1))
        batch*mask.append(bbox*mask.reshape(-1))
        batch*class*labels.append(class_labels)
    bbox*offset = torch.stack(batch*offset)
    bbox*mask = torch.stack(batch*mask)
    class*labels = torch.stack(batch*class_labels)
    return (bbox*offset, bbox*mask, class_labels)
```

```{.python .input}
# @tab paddle
# @save
def multibox_target(anchors, labels):
    """使用真实边界框标记锚框"""
    batch_size, anchors = labels.shape[0], anchors.squeeze(0)
    batch*offset, batch*mask, batch*class*labels = [], [], []
    place, num_anchors = anchors.place, anchors.shape[0]
    for i in range(batch_size):
        label = labels[i, :, :]
        anchors*bbox*map = assign*anchor*to_bbox(
            label[:, 1:], anchors, place)
        bbox*mask = paddle.tile(paddle.to*tensor((anchors*bbox*map >= 0), dtype='float32').unsqueeze(-1), (1, 4))
        # 将类标签和分配的边界框坐标初始化为零
        class*labels = paddle.zeros(paddle.to*tensor(num_anchors), dtype=paddle.int64)
        assigned*bb = paddle.zeros(paddle.to*tensor((num_anchors, 4)), dtype=paddle.float32)
        # 使用真实边界框来标记锚框的类别。
        # 如果一个锚框没有被分配，我们标记其为背景（值为零）
        indices*true = paddle.nonzero(anchors*bbox_map >= 0).numpy()
        bb*idx = anchors*bbox*map[indices*true].numpy()
        class*labels[indices*true] = label.numpy()[bb_idx, 0][:] + 1
        assigned*bb[indices*true] = label.numpy()[bb_idx, 1:]
        class*labels = paddle.to*tensor(class_labels)
        assigned*bb = paddle.to*tensor(assigned_bb)
        # 偏移量转换
        offset = offset*boxes(anchors, assigned*bb) * bbox_mask
        batch_offset.append(offset.reshape([-1]))
        batch*mask.append(bbox*mask.reshape([-1]))
        batch*class*labels.append(class_labels)
    bbox*offset = paddle.stack(batch*offset)
    bbox*mask = paddle.stack(batch*mask)
    class*labels = paddle.stack(batch*class_labels)
    return (bbox*offset, bbox*mask, class_labels)
```

## # 一个例子

下面通过一个具体的例子来说明锚框标签。
我们已经为加载图像中的狗和猫定义了真实边界框，其中第一个元素是类别（0代表狗，1代表猫），其余四个元素是左上角和右下角的$(x, y)$轴坐标（范围介于0和1之间）。
我们还构建了五个锚框，用左上角和右下角的坐标进行标记：$A*0, \ldots, A*4$（索引从0开始）。
然后我们[**在图像中绘制这些真实边界框和锚框**]。

```{.python .input}
# @tab all
ground_truth = d2l.tensor([[0, 0.1, 0.08, 0.52, 0.92],
                         [1, 0.55, 0.2, 0.9, 0.88]])
anchors = d2l.tensor([[0, 0.1, 0.2, 0.3], [0.15, 0.2, 0.4, 0.4],
                    [0.63, 0.05, 0.88, 0.98], [0.66, 0.45, 0.8, 0.8],
                    [0.57, 0.3, 0.92, 0.9]])

fig = d2l.plt.imshow(img)
show*bboxes(fig.axes, ground*truth[:, 1:] * bbox_scale, ['dog', 'cat'], 'k')
show*bboxes(fig.axes, anchors * bbox*scale, ['0', '1', '2', '3', '4']);
```

使用上面定义的`multibox_target`函数，我们可以[**根据狗和猫的真实边界框，标注这些锚框的分类和偏移量**]。
在这个例子中，背景、狗和猫的类索引分别为0、1和2。
下面我们为锚框和真实边界框样本添加一个维度。

```{.python .input}
labels = multibox*target(np.expand*dims(anchors, axis=0),
                         np.expand*dims(ground*truth, axis=0))
```

```{.python .input}
# @tab pytorch
labels = multibox_target(anchors.unsqueeze(dim=0),
                         ground_truth.unsqueeze(dim=0))
```

```{.python .input}
# @tab paddle
labels = multibox_target(anchors.unsqueeze(axis=0),
                         ground_truth.unsqueeze(axis=0))
```

返回的结果中有三个元素，都是张量格式。第三个元素包含标记的输入锚框的类别。

让我们根据图像中的锚框和真实边界框的位置来分析下面返回的类别标签。
首先，在所有的锚框和真实边界框配对中，锚框$A_4$与猫的真实边界框的IoU是最大的。
因此，$A_4$的类别被标记为猫。
去除包含$A*4$或猫的真实边界框的配对，在剩下的配对中，锚框$A*1$和狗的真实边界框有最大的IoU。
因此，$A_1$的类别被标记为狗。
接下来，我们需要遍历剩下的三个未标记的锚框：$A*0$、$A*2$和$A_3$。
对于$A_0$，与其拥有最大IoU的真实边界框的类别是狗，但IoU低于预定义的阈值（0.5），因此该类别被标记为背景；
对于$A_2$，与其拥有最大IoU的真实边界框的类别是猫，IoU超过阈值，所以类别被标记为猫；
对于$A_3$，与其拥有最大IoU的真实边界框的类别是猫，但值低于阈值，因此该类别被标记为背景。

```{.python .input}
# @tab all
labels[2]
```

返回的第二个元素是掩码（mask）变量，形状为（批量大小，锚框数的四倍）。
掩码变量中的元素与每个锚框的4个偏移量一一对应。
由于我们不关心对背景的检测，负类的偏移量不应影响目标函数。
通过元素乘法，掩码变量中的零将在计算目标函数之前过滤掉负类偏移量。

```{.python .input}
# @tab all
labels[1]
```

返回的第一个元素包含了为每个锚框标记的四个偏移值。
请注意，负类锚框的偏移量被标记为零。

```{.python .input}
# @tab all
labels[0]
```

# # 使用非极大值抑制预测边界框
:label:`subsec_predicting-bounding-boxes-nms`

在预测时，我们先为图像生成多个锚框，再为这些锚框一一预测类别和偏移量。
一个*预测好的边界框*则根据其中某个带有预测偏移量的锚框而生成。
下面我们实现了`offset_inverse`函数，该函数将锚框和偏移量预测作为输入，并[**应用逆偏移变换来返回预测的边界框坐标**]。

```{.python .input}
# @tab all
# @save
def offset*inverse(anchors, offset*preds):
    """根据带有预测偏移量的锚框来预测边界框"""
    anc = d2l.box*corner*to_center(anchors)
    pred*bbox*xy = (offset_preds[:, :2] * anc[:, 2:] / 10) + anc[:, :2]
    pred*bbox*wh = d2l.exp(offset_preds[:, 2:] / 5) * anc[:, 2:]
    pred*bbox = d2l.concat((pred*bbox*xy, pred*bbox_wh), axis=1)
    predicted*bbox = d2l.box*center*to*corner(pred_bbox)
    return predicted_bbox
```

当有许多锚框时，可能会输出许多相似的具有明显重叠的预测边界框，都围绕着同一目标。
为了简化输出，我们可以使用*非极大值抑制*（non-maximum suppression，NMS）合并属于同一目标的类似的预测边界框。

以下是非极大值抑制的工作原理。
对于一个预测边界框$B$，目标检测模型会计算每个类别的预测概率。
假设最大的预测概率为$p$，则该概率所对应的类别$B$即为预测的类别。
具体来说，我们将$p$称为预测边界框$B$的*置信度*（confidence）。
在同一张图像中，所有预测的非背景边界框都按置信度降序排序，以生成列表$L$。然后我们通过以下步骤操作排序列表$L$。

1. 从$L$中选取置信度最高的预测边界框$B*1$作为基准，然后将所有与$B*1$的IoU超过预定阈值$\epsilon$的非基准预测边界框从$L$中移除。这时，$L$保留了置信度最高的预测边界框，去除了与其太过相似的其他预测边界框。简而言之，那些具有*非极大值*置信度的边界框被*抑制*了。
1. 从$L$中选取置信度第二高的预测边界框$B*2$作为又一个基准，然后将所有与$B*2$的IoU大于$\epsilon$的非基准预测边界框从$L$中移除。
1. 重复上述过程，直到$L$中的所有预测边界框都曾被用作基准。此时，$L$中任意一对预测边界框的IoU都小于阈值$\epsilon$；因此，没有一对边界框过于相似。
1. 输出列表$L$中的所有预测边界框。

[**以下`nms`函数按降序对置信度进行排序并返回其索引**]。

```{.python .input}
# @save
def nms(boxes, scores, iou_threshold):
    """对预测边界框的置信度进行排序"""
    B = scores.argsort()[::-1]
    keep = []  # 保留预测边界框的指标
    while B.size > 0:
        i = B[0]
        keep.append(i)
        if B.size == 1: break
        iou = box_iou(boxes[i, :].reshape(-1, 4),
                      boxes[B[1:], :].reshape(-1, 4)).reshape(-1)
        inds = np.nonzero(iou <= iou_threshold)[0]
        B = B[inds + 1]
    return np.array(keep, dtype=np.int32, ctx=boxes.ctx)
```

```{.python .input}
# @tab pytorch
# @save
def nms(boxes, scores, iou_threshold):
    """对预测边界框的置信度进行排序"""
    B = torch.argsort(scores, dim=-1, descending=True)
    keep = []  # 保留预测边界框的指标
    while B.numel() > 0:
        i = B[0]
        keep.append(i)
        if B.numel() == 1: break
        iou = box_iou(boxes[i, :].reshape(-1, 4),
                      boxes[B[1:], :].reshape(-1, 4)).reshape(-1)
        inds = torch.nonzero(iou <= iou_threshold).reshape(-1)
        B = B[inds + 1]
    return d2l.tensor(keep, device=boxes.device)
```

```{.python .input}
# @tab paddle
# @save
def nms(boxes, scores, iou_threshold):
    """对预测边界框的置信度进行排序"""
    B = paddle.argsort(scores, axis=-1, descending=True)
    keep = []  # 保留预测边界框的指标
    while B.numel().item() > 0:
        i = B[0]
        keep.append(i.item())
        if B.numel().item() == 1: break
        iou = box_iou(boxes[i.numpy(), :].reshape([-1, 4]),
                      paddle.to_tensor(boxes.numpy()[B[1:].numpy(), :]).reshape([-1, 4])).reshape([-1])
        inds = paddle.nonzero(iou <= iou_threshold).numpy().reshape([-1])
        B = paddle.to_tensor(B.numpy()[inds + 1])
    return paddle.to_tensor(keep, place=boxes.place, dtype='int64')
```

我们定义以下`multibox_detection`函数来[**将非极大值抑制应用于预测边界框**]。
这里的实现有点复杂，请不要担心。我们将在实现之后，马上用一个具体的例子来展示它是如何工作的。

```{.python .input}
# @save
def multibox*detection(cls*probs, offset*preds, anchors, nms*threshold=0.5,
                       pos_threshold=0.009999999):
    """使用非极大值抑制来预测边界框"""
    device, batch*size = cls*probs.ctx, cls_probs.shape[0]
    anchors = np.squeeze(anchors, axis=0)
    num*classes, num*anchors = cls*probs.shape[1], cls*probs.shape[2]
    out = []
    for i in range(batch_size):
        cls*prob, offset*pred = cls*probs[i], offset*preds[i].reshape(-1, 4)
        conf, class*id = np.max(cls*prob[1:], 0), np.argmax(cls_prob[1:], 0)
        predicted*bb = offset*inverse(anchors, offset_pred)
        keep = nms(predicted*bb, conf, nms*threshold)

        # 找到所有的non_keep索引，并将类设置为背景
        all*idx = np.arange(num*anchors, dtype=np.int32, ctx=device)
        combined = d2l.concat((keep, all_idx))
        unique, counts = np.unique(combined, return_counts=True)
        non_keep = unique[counts == 1]
        all*id*sorted = d2l.concat((keep, non_keep))
        class*id[non*keep] = -1
        class*id = class*id[all*id*sorted].astype('float32')
        conf, predicted*bb = conf[all*id*sorted], predicted*bb[all*id*sorted]
        # pos_threshold是一个用于非背景预测的阈值
        below*min*idx = (conf < pos_threshold)
        class*id[below*min_idx] = -1
        conf[below*min*idx] = 1 - conf[below*min*idx]
        pred*info = d2l.concat((np.expand*dims(class_id, axis=1),
                                np.expand_dims(conf, axis=1),
                                predicted_bb), axis=1)
        out.append(pred_info)
    return d2l.stack(out)
```

```{.python .input}
# @tab pytorch
# @save
def multibox*detection(cls*probs, offset*preds, anchors, nms*threshold=0.5,
                       pos_threshold=0.009999999):
    """使用非极大值抑制来预测边界框"""
    device, batch*size = cls*probs.device, cls_probs.shape[0]
    anchors = anchors.squeeze(0)
    num*classes, num*anchors = cls*probs.shape[1], cls*probs.shape[2]
    out = []
    for i in range(batch_size):
        cls*prob, offset*pred = cls*probs[i], offset*preds[i].reshape(-1, 4)
        conf, class*id = torch.max(cls*prob[1:], 0)
        predicted*bb = offset*inverse(anchors, offset_pred)
        keep = nms(predicted*bb, conf, nms*threshold)

        # 找到所有的non_keep索引，并将类设置为背景
        all*idx = torch.arange(num*anchors, dtype=torch.long, device=device)
        combined = torch.cat((keep, all_idx))
        uniques, counts = combined.unique(return_counts=True)
        non_keep = uniques[counts == 1]
        all*id*sorted = torch.cat((keep, non_keep))
        class*id[non*keep] = -1
        class*id = class*id[all*id*sorted]
        conf, predicted*bb = conf[all*id*sorted], predicted*bb[all*id*sorted]
        # pos_threshold是一个用于非背景预测的阈值
        below*min*idx = (conf < pos_threshold)
        class*id[below*min_idx] = -1
        conf[below*min*idx] = 1 - conf[below*min*idx]
        pred*info = torch.cat((class*id.unsqueeze(1),
                               conf.unsqueeze(1),
                               predicted_bb), dim=1)
        out.append(pred_info)
    return d2l.stack(out)
```

```{.python .input}
# @tab paddle
# @save
def multibox*detection(cls*probs, offset*preds, anchors, nms*threshold=0.5,
                       pos_threshold=0.009999999):
    """使用非极大值抑制来预测边界框"""
    batch*size = cls*probs.shape[0]
    anchors = anchors.squeeze(0)
    num*classes, num*anchors = cls*probs.shape[1], cls*probs.shape[2]
    out = []
    for i in range(batch_size):
        cls*prob, offset*pred = cls*probs[i], offset*preds[i].reshape([-1, 4])
        conf = paddle.max(cls_prob[1:], 0)
        class*id = paddle.argmax(cls*prob[1:], 0)
        predicted*bb = offset*inverse(anchors, offset_pred)
        keep = nms(predicted*bb, conf, nms*threshold)

        # 找到所有的non_keep索引，并将类设置为背景
        all*idx = paddle.arange(num*anchors, dtype='int64')
        combined = paddle.concat((keep, all_idx))
        uniques, counts = combined.unique(return_counts=True)
        non_keep = uniques[counts == 1]
        all*id*sorted = paddle.concat([keep, non_keep])
        class*id[non*keep.numpy()] = -1
        class*id = class*id[all*id*sorted]
        conf, predicted*bb = conf[all*id*sorted], predicted*bb[all*id*sorted]
        # pos_threshold是一个用于非背景预测的阈值
        below*min*idx = (conf < pos_threshold)
        class*id[below*min_idx.numpy()] = -1
        conf[below*min*idx.numpy()] = 1 - conf[below*min*idx.numpy()]
        pred*info = paddle.concat((paddle.to*tensor(class_id, dtype='float32').unsqueeze(1),
                               paddle.to_tensor(conf, dtype='float32').unsqueeze(1),
                               predicted_bb), axis=1)
        out.append(pred_info)
    return paddle.stack(out)
```

现在让我们[**将上述算法应用到一个带有四个锚框的具体示例中**]。
为简单起见，我们假设预测的偏移量都是零，这意味着预测的边界框即是锚框。
对于背景、狗和猫其中的每个类，我们还定义了它的预测概率。

```{.python .input}
# @tab mxnet, pytorch
anchors = d2l.tensor([[0.1, 0.08, 0.52, 0.92], [0.08, 0.2, 0.56, 0.95],
                      [0.15, 0.3, 0.62, 0.91], [0.55, 0.2, 0.9, 0.88]])
offset_preds = d2l.tensor([0] * d2l.size(anchors))
cls_probs = d2l.tensor([[0] * 4,  # 背景的预测概率
                      [0.9, 0.8, 0.7, 0.1],  # 狗的预测概率
                      [0.1, 0.2, 0.3, 0.9]])  # 猫的预测概率
```

```{.python .input}
# @tab paddle
anchors = d2l.tensor([[0.1, 0.08, 0.52, 0.92], [0.08, 0.2, 0.56, 0.95],
                      [0.15, 0.3, 0.62, 0.91], [0.55, 0.2, 0.9, 0.88]])
offset_preds = d2l.tensor([0] * anchors.numel().item())
cls_probs = d2l.tensor([[0] * 4,  # 背景的预测概率
                      [0.9, 0.8, 0.7, 0.1],  # 狗的预测概率
                      [0.1, 0.2, 0.3, 0.9]])  # 猫的预测概率
```

我们可以[**在图像上绘制这些预测边界框和置信度**]。

```{.python .input}
# @tab all
fig = d2l.plt.imshow(img)
show*bboxes(fig.axes, anchors * bbox*scale,
            ['dog=0.9', 'dog=0.8', 'dog=0.7', 'cat=0.9'])
```

现在我们可以调用`multibox_detection`函数来执行非极大值抑制，其中阈值设置为0.5。
请注意，我们在示例的张量输入中添加了维度。

我们可以看到[**返回结果的形状是（批量大小，锚框的数量，6）**]。
最内层维度中的六个元素提供了同一预测边界框的输出信息。
第一个元素是预测的类索引，从0开始（0代表狗，1代表猫），值-1表示背景或在非极大值抑制中被移除了。
第二个元素是预测的边界框的置信度。
其余四个元素分别是预测边界框左上角和右下角的$(x, y)$轴坐标（范围介于0和1之间）。

```{.python .input}
output = multibox*detection(np.expand*dims(cls_probs, axis=0),
                            np.expand*dims(offset*preds, axis=0),
                            np.expand_dims(anchors, axis=0),
                            nms_threshold=0.5)
output
```

```{.python .input}
# @tab pytorch
output = multibox*detection(cls*probs.unsqueeze(dim=0),
                            offset_preds.unsqueeze(dim=0),
                            anchors.unsqueeze(dim=0),
                            nms_threshold=0.5)
output
```

```{.python .input}
# @tab paddle
output = multibox*detection(cls*probs.unsqueeze(axis=0),
                            offset_preds.unsqueeze(axis=0),
                            anchors.unsqueeze(axis=0),
                            nms_threshold=0.5)
output
```

删除-1类别（背景）的预测边界框后，我们可以[**输出由非极大值抑制保存的最终预测边界框**]。

```{.python .input}
# @tab all
fig = d2l.plt.imshow(img)
for i in d2l.numpy(output[0]):
    if i[0] == -1:
        continue
    label = ('dog=', 'cat=')[int(i[0])] + str(i[1])
    show*bboxes(fig.axes, [d2l.tensor(i[2:]) * bbox*scale], label)
```

实践中，在执行非极大值抑制前，我们甚至可以将置信度较低的预测边界框移除，从而减少此算法中的计算量。
我们也可以对非极大值抑制的输出结果进行后处理。例如，只保留置信度更高的结果作为最终输出。

# # 小结

* 我们以图像的每个像素为中心生成不同形状的锚框。
* 交并比（IoU）也被称为杰卡德系数，用于衡量两个边界框的相似性。它是相交面积与相并面积的比率。
* 在训练集中，我们需要给每个锚框两种类型的标签。一个是与锚框中目标检测的类别，另一个是锚框真实相对于边界框的偏移量。
* 预测期间可以使用非极大值抑制（NMS）来移除类似的预测边界框，从而简化输出。

# # 练习

1. 在`multibox_prior`函数中更改`sizes`和`ratios`的值。生成的锚框有什么变化？
1. 构建并可视化两个IoU为0.5的边界框。它们是怎样重叠的？
1. 在 :numref:`subsec*labeling-anchor-boxes`和 :numref:`subsec*predicting-bounding-boxes-nms`中修改变量`anchors`，结果如何变化？
1. 非极大值抑制是一种贪心算法，它通过*移除*来抑制预测的边界框。是否存在一种可能，被移除的一些框实际上是有用的？如何修改这个算法来柔和地抑制？可以参考Soft-NMS :cite:`Bodla.Singh.Chellappa.ea.2017`。
1. 如果非手动，非最大限度的抑制可以被学习吗？

:begin_tab:`mxnet`
[Discussions](https://discuss.d2l.ai/t/2945)
:end_tab:

:begin_tab:`pytorch`
[Discussions](https://discuss.d2l.ai/t/2946)
:end_tab:

:begin_tab:`paddle`
[Discussions](https://discuss.d2l.ai/t/11804)
:end_tab:
