# Anchor Boxes
:label:`sec_anchor`


Object detection algorithms usually
sample a large number of regions in the input image, determine whether these regions contain
objects of interest, and adjust the boundaries
of the regions so as to predict the
*ground-truth bounding boxes*
of the objects more accurately.
Different models may adopt
different region sampling schemes. 
Here we introduce one of such methods:
it generates multiple bounding boxes with varying scales and aspect ratios centered on each pixel. 
These bounding boxes are called *anchor boxes*.
We will design an object detection model
based on anchor boxes in :numref:`sec_ssd`.

First, let us modify the printing accuracy
just for more concise outputs.

```{.python .input}
%matplotlib inline
from d2l import mxnet as d2l
from mxnet import gluon, image, np, npx

np.set_printoptions(2)  # Simplify printing accuracy
npx.set_np()
```

```{.python .input}
# @tab pytorch
%matplotlib inline
from d2l import torch as d2l
import torch

torch.set_printoptions(2)  # Simplify printing accuracy
```

# # Generating Multiple Anchor Boxes

Suppose that the input image has a height of $h$ and width of $w$. 
We generate anchor boxes with different shapes centered on each pixel of the image.
Let the *scale* be $s\in (0, 1]$ and
the *aspect ratio* (ratio of width to height) is $r > 0$. 
Then the width and height of the anchor box are $ws\sqrt{r}$ and $hs/\sqrt{r}$, respectively. 
Note that when the center position is given, an anchor box with known width and height is determined.

To generate multiple anchor boxes with different shapes,
let us set a series of scales
$s*1,\ldots, s*n$ and 
a series of aspect ratios $r*1,\ldots, r*m$.
When using all the combinations of these scales and aspect ratios with each pixel as the center,
the input image will have a total of $whnm$ anchor boxes. Although these anchor boxes may cover all the
ground-truth bounding boxes, the computational complexity is easily too high.
In practice,
we can only consider those combinations
containing $s*1$ or $r*1$:

$$(s*1, r*1), (s*1, r*2), \ldots, (s*1, r*m), (s*2, r*1), (s*3, r*1), \ldots, (s*n, r*1).$$

That is to say, the number of anchor boxes centered on the same pixel is $n+m-1$. For the entire input image, we will generate a total of $wh(n+m-1)$ anchor boxes.

The above method of generating anchor boxes is implemented in the following `multibox_prior` function. We specify the input image, a list of scales, and a list of aspect ratios, then this function will return all the anchor boxes.

```{.python .input}
# @save
def multibox_prior(data, sizes, ratios):
    """Generate anchor boxes with different shapes centered on each pixel."""
    in*height, in*width = data.shape[-2:]
    device, num*sizes, num*ratios = data.ctx, len(sizes), len(ratios)
    boxes*per*pixel = (num*sizes + num*ratios - 1)
    size_tensor = d2l.tensor(sizes, ctx=device)
    ratio_tensor = d2l.tensor(ratios, ctx=device)
    # Offsets are required to move the anchor to the center of a pixel. Since
    # a pixel has height=1 and width=1, we choose to offset our centers by 0.5
    offset*h, offset*w = 0.5, 0.5
    steps*h = 1.0 / in*height  # Scaled steps in y-axis
    steps*w = 1.0 / in*width  # Scaled steps in x-axis

    # Generate all center points for the anchor boxes
    center*h = (d2l.arange(in*height, ctx=device) + offset*h) * steps*h
    center*w = (d2l.arange(in*width, ctx=device) + offset*w) * steps*w
    shift*x, shift*y = d2l.meshgrid(center*w, center*h)
    shift*x, shift*y = shift*x.reshape(-1), shift*y.reshape(-1)

    # Generate `boxes*per*pixel` number of heights and widths that are later
    # used to create anchor box corner coordinates (xmin, xmax, ymin, ymax)
    w = np.concatenate((size*tensor * np.sqrt(ratio*tensor[0]),
                        sizes[0] * np.sqrt(ratio_tensor[1:]))) \
                        * in*height / in*width  # Handle rectangular inputs
    h = np.concatenate((size*tensor / np.sqrt(ratio*tensor[0]),
                        sizes[0] / np.sqrt(ratio_tensor[1:])))
    # Divide by 2 to get half height and half width
    anchor_manipulations = np.tile(np.stack((-w, -h, w, h)).T,
                                   (in*height * in*width, 1)) / 2

    # Each center point will have `boxes*per*pixel` number of anchor boxes, so
    # generate a grid of all anchor box centers with `boxes*per*pixel` repeats
    out*grid = d2l.stack([shift*x, shift*y, shift*x, shift_y],
                         axis=1).repeat(boxes*per*pixel, axis=0)
    output = out*grid + anchor*manipulations
    return np.expand_dims(output, axis=0)
```

```{.python .input}
# @tab pytorch
# @save
def multibox_prior(data, sizes, ratios):
    """Generate anchor boxes with different shapes centered on each pixel."""
    in*height, in*width = data.shape[-2:]
    device, num*sizes, num*ratios = data.device, len(sizes), len(ratios)
    boxes*per*pixel = (num*sizes + num*ratios - 1)
    size_tensor = d2l.tensor(sizes, device=device)
    ratio_tensor = d2l.tensor(ratios, device=device)
    # Offsets are required to move the anchor to the center of a pixel. Since
    # a pixel has height=1 and width=1, we choose to offset our centers by 0.5
    offset*h, offset*w = 0.5, 0.5
    steps*h = 1.0 / in*height  # Scaled steps in y axis
    steps*w = 1.0 / in*width  # Scaled steps in x axis

    # Generate all center points for the anchor boxes
    center*h = (torch.arange(in*height, device=device) + offset*h) * steps*h
    center*w = (torch.arange(in*width, device=device) + offset*w) * steps*w
    shift*y, shift*x = torch.meshgrid(center*h, center*w)
    shift*y, shift*x = shift*y.reshape(-1), shift*x.reshape(-1)

    # Generate `boxes*per*pixel` number of heights and widths that are later
    # used to create anchor box corner coordinates (xmin, xmax, ymin, ymax)
    w = torch.cat((size*tensor * torch.sqrt(ratio*tensor[0]),
                   sizes[0] * torch.sqrt(ratio_tensor[1:])))\
                   * in*height / in*width  # Handle rectangular inputs
    h = torch.cat((size*tensor / torch.sqrt(ratio*tensor[0]),
                   sizes[0] / torch.sqrt(ratio_tensor[1:])))
    # Divide by 2 to get half height and half width
    anchor_manipulations = torch.stack((-w, -h, w, h)).T.repeat(
                                        in*height * in*width, 1) / 2

    # Each center point will have `boxes*per*pixel` number of anchor boxes, so
    # generate a grid of all anchor box centers with `boxes*per*pixel` repeats
    out*grid = torch.stack([shift*x, shift*y, shift*x, shift_y],
                dim=1).repeat*interleave(boxes*per_pixel, dim=0)
    output = out*grid + anchor*manipulations
    return output.unsqueeze(0)
```

We can see that the shape of the returned anchor box variable `Y` is
(batch size, number of anchor boxes, 4).

```{.python .input}
img = image.imread('../img/catdog.jpg').asnumpy()
h, w = img.shape[:2]

print(h, w)
X = np.random.uniform(size=(1, 3, h, w))  # Construct input data
Y = multibox_prior(X, sizes=[0.75, 0.5, 0.25], ratios=[1, 2, 0.5])
Y.shape
```

```{.python .input}
# @tab pytorch
img = d2l.plt.imread('../img/catdog.jpg')
h, w = img.shape[:2]

print(h, w)
X = torch.rand(size=(1, 3, h, w))  # Construct input data
Y = multibox_prior(X, sizes=[0.75, 0.5, 0.25], ratios=[1, 2, 0.5])
Y.shape
```

After changing the shape of the anchor box variable `Y` to (image height, image width, number of anchor boxes centered on the same pixel, 4),
we can obtain all the anchor boxes centered on a specified pixel position.
In the following,
we access the first anchor box centered on (250, 250). It has four elements: the $(x, y)$-axis coordinates at the upper-left corner and the $(x, y)$-axis coordinates at the lower-right corner of the anchor box.
The coordinate values of both axes
are divided by the width and height of the image, respectively; thus, the range is between 0 and 1.

```{.python .input}
# @tab all
boxes = Y.reshape(h, w, 5, 4)
boxes[250, 250, 0, :]
```

In order to show all the anchor boxes centered on one pixel in the image,
we define the following `show_bboxes` function to draw multiple bounding boxes on the image.

```{.python .input}
# @tab all
# @save
def show_bboxes(axes, bboxes, labels=None, colors=None):
    """Show bounding boxes."""
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

As we just saw, the coordinate values of the $x$ and $y$ axes in the variable `boxes` have been divided by the width and height of the image, respectively.
When drawing anchor boxes,
we need to restore their original coordinate values;
thus, we define variable `bbox_scale` below. 
Now, we can draw all the anchor boxes centered on (250, 250) in the image.
As you can see, the blue anchor box with a scale of 0.75 and an aspect ratio of 1 well
surrounds the dog in the image.

```{.python .input}
# @tab all
d2l.set_figsize()
bbox_scale = d2l.tensor((w, h, w, h))
fig = d2l.plt.imshow(img)
show*bboxes(fig.axes, boxes[250, 250, :, :] * bbox*scale,
            ['s=0.75, r=1', 's=0.5, r=1', 's=0.25, r=1', 's=0.75, r=2',
             's=0.75, r=0.5'])
```

# # Intersection over Union (IoU)

We just mentioned that an anchor box "well" surrounds the dog in the image.
If the ground-truth bounding box of the object is known, how can "well" here be quantified?
Intuitively, we can measure the similarity between
the anchor box and the ground-truth bounding box.
We know that the *Jaccard index* can measure the similarity between two sets. Given sets $\mathcal{A}$ and $\mathcal{B}$, their Jaccard index is the size of their intersection divided by the size of their union:

$$J(\mathcal{A},\mathcal{B}) = \frac{\left|\mathcal{A} \cap \mathcal{B}\right|}{\left| \mathcal{A} \cup \mathcal{B}\right|}.$$


In fact, we can consider the pixel area of any bounding box as a set of pixels. 
In this way, we can measure the similarity of the two bounding boxes by the Jaccard index of their pixel sets. For two bounding boxes, we usually refer their Jaccard index as *intersection over union* (*IoU*), which is the ratio of their intersection area to their union area, as shown in :numref:`fig_iou`.
The range of an IoU is between 0 and 1:
0 means that two bounding boxes do not overlap at all,
while 1 indicates that the two bounding boxes are equal.

![IoU is the ratio of the intersection area to the union area of two bounding boxes.](../img/iou.svg)
:label:`fig_iou`

For the remainder of this section, we will use IoU to measure the similarity between anchor boxes and ground-truth bounding boxes, and between different anchor boxes.
Given two lists of anchor or bounding boxes,
the following `box_iou` computes their pairwise IoU
across these two lists.

```{.python .input}
# @save
def box_iou(boxes1, boxes2):
    """Compute pairwise IoU across two lists of anchor or bounding boxes."""
    box_area = lambda boxes: ((boxes[:, 2] - boxes[:, 0]) *
                              (boxes[:, 3] - boxes[:, 1]))
    # Shape of `boxes1`, `boxes2`, `areas1`, `areas2`: (no. of boxes1, 4),
    # (no. of boxes2, 4), (no. of boxes1,), (no. of boxes2,)
    areas1 = box_area(boxes1)
    areas2 = box_area(boxes2)
    # Shape of `inter*upperlefts`, `inter*lowerrights`, `inters`: (no. of
    # boxes1, no. of boxes2, 2)
    inter_upperlefts = np.maximum(boxes1[:, None, :2], boxes2[:, :2])
    inter_lowerrights = np.minimum(boxes1[:, None, 2:], boxes2[:, 2:])
    inters = (inter*lowerrights - inter*upperlefts).clip(min=0)
    # Shape of `inter*areas` and `union*areas`: (no. of boxes1, no. of boxes2)
    inter_areas = inters[:, :, 0] * inters[:, :, 1]
    union*areas = areas1[:, None] + areas2 - inter*areas
    return inter*areas / union*areas
```

```{.python .input}
# @tab pytorch
# @save
def box_iou(boxes1, boxes2):
    """Compute pairwise IoU across two lists of anchor or bounding boxes."""
    box_area = lambda boxes: ((boxes[:, 2] - boxes[:, 0]) *
                              (boxes[:, 3] - boxes[:, 1]))
    # Shape of `boxes1`, `boxes2`, `areas1`, `areas2`: (no. of boxes1, 4),
    # (no. of boxes2, 4), (no. of boxes1,), (no. of boxes2,)
    areas1 = box_area(boxes1)
    areas2 = box_area(boxes2)
    # Shape of `inter*upperlefts`, `inter*lowerrights`, `inters`: (no. of
    # boxes1, no. of boxes2, 2)
    inter_upperlefts = torch.max(boxes1[:, None, :2], boxes2[:, :2])
    inter_lowerrights = torch.min(boxes1[:, None, 2:], boxes2[:, 2:])
    inters = (inter*lowerrights - inter*upperlefts).clamp(min=0)
    # Shape of `inter*areas` and `union*areas`: (no. of boxes1, no. of boxes2)
    inter_areas = inters[:, :, 0] * inters[:, :, 1]
    union*areas = areas1[:, None] + areas2 - inter*areas
    return inter*areas / union*areas
```

# # Labeling Anchor Boxes in Training Data
:label:`subsec_labeling-anchor-boxes`


In a training dataset,
we consider each anchor box as a training example.
In order to train an object detection model,
we need *class* and *offset* labels for each anchor box,
where the former is
the class of the object relevant to the anchor box
and the latter is the offset
of the ground-truth bounding box relative to the anchor box.
During the prediction,
for each image
we generate multiple anchor boxes,
predict classes and offsets for all the anchor boxes,
adjust their positions according to the predicted offsets to obtain the predicted bounding boxes,
and finally only output those 
predicted bounding boxes that satisfy certain criteria.


As we know, an object detection training set
comes with labels for
locations of *ground-truth bounding boxes*
and classes of their surrounded objects.
To label any generated *anchor box*,
we refer to the labeled
location and class of its *assigned* ground-truth bounding box that is closet to the anchor box.
In the following,
we describe an algorithm for assigning
closest ground-truth bounding boxes to anchor boxes. 

## # Assigning Ground-Truth Bounding Boxes to Anchor Boxes

Given an image,
suppose that the anchor boxes are $A*1, A*2, \ldots, A*{n*a}$ and the ground-truth bounding boxes are $B*1, B*2, \ldots, B*{n*b}$, where $n*a \geq n*b$.
Let us define a matrix $\mathbf{X} \in \mathbb{R}^{n*a \times n*b}$, whose element $x*{ij}$ in the $i^\mathrm{th}$ row and $j^\mathrm{th}$ column is the IoU of the anchor box $A*i$ and the ground-truth bounding box $B_j$. The algorithm consists of the following steps:

1. Find the largest element in matrix $\mathbf{X}$ and denote its row and column indices as $i*1$ and $j*1$, respectively. Then the ground-truth bounding box $B*{j*1}$ is assigned to the anchor box $A*{i*1}$. This is quite intuitive because $A*{i*1}$ and $B*{j*1}$ are the closet among all the pairs of anchor boxes and ground-truth bounding boxes. After the first assignment, discard all the elements in the ${i*1}^\mathrm{th}$ row and the ${j*1}^\mathrm{th}$ column in matrix $\mathbf{X}$. 
1. Find the largest of the remaining elements in matrix $\mathbf{X}$ and denote its row and column indices as $i*2$ and $j*2$, respectively. We assign ground-truth bounding box $B*{j*2}$ to anchor box $A*{i*2}$ and discard all the elements in the ${i*2}^\mathrm{th}$ row and the ${j*2}^\mathrm{th}$ column in matrix $\mathbf{X}$.
1. At this point, elements in two rows and two columns in  matrix $\mathbf{X}$ have been discarded. We proceed until all elements in $n*b$ columns in matrix $\mathbf{X}$ are discarded. At this time, we have assigned a ground-truth bounding box to each of $n*b$ anchor boxes.
1. Only traverse through the remaining $n*a - n*b$ anchor boxes. For example, given any anchor box $A*i$, find the ground-truth bounding box $B*j$ with the largest IoU with $A*i$ throughout the $i^\mathrm{th}$ row of matrix $\mathbf{X}$, and assign $B*j$ to $A_i$ only if this IoU is greater than a predefined threshold.

Let us illustrate the above algorithm using a concrete
example.
As shown in :numref:`fig*anchor*label` (left), assuming that the maximum value in matrix $\mathbf{X}$ is $x*{23}$, we assign the ground-truth bounding box $B*3$ to the anchor box $A_2$.
Then, we discard all the elements in row 2 and column 3 of the matrix, find the largest $x*{71}$ in the remaining  elements (shaded area), and assign the ground-truth bounding box $B*1$ to the anchor box $A_7$. 
Next, as shown in :numref:`fig*anchor*label` (middle), discard all the elements in row 7 and column 1 of the matrix, find the largest $x*{54}$ in the remaining  elements (shaded area), and assign the ground-truth bounding box $B*4$ to the anchor box $A_5$. 
Finally, as shown in :numref:`fig*anchor*label` (right), discard all the elements in row 5 and column 4 of the matrix, find the largest $x*{92}$ in the remaining elements (shaded area), and assign the ground-truth bounding box $B*2$ to the anchor box $A_9$.
After that, we only need to traverse through
the remaining anchor boxes $A*1, A*3, A*4, A*6, A_8$ and determine whether to assign them ground-truth bounding boxes according to the threshold.

![Assigning ground-truth bounding boxes to anchor boxes.](../img/anchor-label.svg)
:label:`fig*anchor*label`

This algorithm is implemented in the following `assign*anchor*to_bbox` function.

```{.python .input}
# @save
def assign*anchor*to*bbox(ground*truth, anchors, device, iou_threshold=0.5):
    """Assign closest ground-truth bounding boxes to anchor boxes."""
    num*anchors, num*gt*boxes = anchors.shape[0], ground*truth.shape[0]
    # Element x_ij in the i-th row and j-th column is the IoU of the anchor
    # box i and the ground-truth bounding box j
    jaccard = box*iou(anchors, ground*truth)
    # Initialize the tensor to hold the assigned ground-truth bounding box for
    # each anchor
    anchors*bbox*map = np.full((num_anchors,), -1, dtype=np.int32, ctx=device)
    # Assign ground-truth bounding boxes according to the threshold
    max_ious, indices = np.max(jaccard, axis=1), np.argmax(jaccard, axis=1)
    anc*i = np.nonzero(max*ious >= 0.5)[0]
    box*j = indices[max*ious >= 0.5]
    anchors*bbox*map[anc*i] = box*j
    col*discard = np.full((num*anchors,), -1)
    row*discard = np.full((num*gt_boxes,), -1)
    for * in range(num*gt_boxes):
        max_idx = np.argmax(jaccard)  # Find the largest IoU
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
    """Assign closest ground-truth bounding boxes to anchor boxes."""
    num*anchors, num*gt*boxes = anchors.shape[0], ground*truth.shape[0]
    # Element x_ij in the i-th row and j-th column is the IoU of the anchor
    # box i and the ground-truth bounding box j
    jaccard = box*iou(anchors, ground*truth)
    # Initialize the tensor to hold the assigned ground-truth bounding box for
    # each anchor
    anchors*bbox*map = torch.full((num_anchors,), -1, dtype=torch.long,
                                  device=device)
    # Assign ground-truth bounding boxes according to the threshold
    max_ious, indices = torch.max(jaccard, dim=1)
    anc*i = torch.nonzero(max*ious >= 0.5).reshape(-1)
    box*j = indices[max*ious >= 0.5]
    anchors*bbox*map[anc*i] = box*j
    col*discard = torch.full((num*anchors,), -1)
    row*discard = torch.full((num*gt_boxes,), -1)
    for * in range(num*gt_boxes):
        max_idx = torch.argmax(jaccard)  # Find the largest IoU
        box*idx = (max*idx % num*gt*boxes).long()
        anc*idx = (max*idx / num*gt*boxes).long()
        anchors*bbox*map[anc*idx] = box*idx
        jaccard[:, box*idx] = col*discard
        jaccard[anc*idx, :] = row*discard
    return anchors*bbox*map
```

## # Labeling Classes and Offsets

Now we can label the class and offset for each anchor box. Suppose that an anchor box $A$ is assigned
a ground-truth bounding box $B$. 
On one hand,
the class of the anchor box $A$ will be
labeled as that of $B$.
On the other hand,
the offset of the anchor box $A$ 
will be labeled according to the 
relative position between
the central coordinates of $B$ and $A$
together with the relative size between
these two boxes.
Given varying
positions and sizes of different boxes in the dataset,
we can apply transformations
to those relative positions and sizes
that may lead to 
more uniformly distributed offsets
that are easier to fit.
Here we describe a common transformation.
Given the central coordinates of $A$ and $B$ as $(x*a, y*a)$ and $(x*b, y*b)$, 
their widths as $w*a$ and $w*b$, 
and their heights as $h*a$ and $h*b$, respectively. 
We may label the offset of $A$ as

$$\left( \frac{ \frac{x*b - x*a}{w*a} - \mu*x }{\sigma_x},
\frac{ \frac{y*b - y*a}{h*a} - \mu*y }{\sigma_y},
\frac{ \log \frac{w*b}{w*a} - \mu*w }{\sigma*w},
\frac{ \log \frac{h*b}{h*a} - \mu*h }{\sigma*h}\right),$$

where default values of the constants are $\mu*x = \mu*y = \mu*w = \mu*h = 0, \sigma*x=\sigma*y=0.1$, and $\sigma*w=\sigma*h=0.2$.
This transformation is implemented below in the `offset_boxes` function.

```{.python .input}
# @tab all
# @save
def offset*boxes(anchors, assigned*bb, eps=1e-6):
    """Transform for anchor box offsets."""
    c*anc = d2l.box*corner*to*center(anchors)
    c*assigned*bb = d2l.box*corner*to*center(assigned*bb)
    offset*xy = 10 * (c*assigned*bb[:, :2] - c*anc[:, :2]) / c_anc[:, 2:]
    offset*wh = 5 * d2l.log(eps + c*assigned*bb[:, 2:] / c*anc[:, 2:])
    offset = d2l.concat([offset*xy, offset*wh], axis=1)
    return offset
```

If an anchor box is not assigned a ground-truth bounding box, we just label the class of the anchor box as "background".
Anchor boxes whose classes are background are often referred to as *negative* anchor boxes,
and the rest are called *positive* anchor boxes.
We implement the following `multibox_target` function
to label classes and offsets for anchor boxes (the `anchors` argument) using ground-truth bounding boxes (the `labels` argument).
This function sets the background class to zero and increments the integer index of a new class by one.

```{.python .input}
# @save
def multibox_target(anchors, labels):
    """Label anchor boxes using ground-truth bounding boxes."""
    batch_size, anchors = labels.shape[0], anchors.squeeze(0)
    batch*offset, batch*mask, batch*class*labels = [], [], []
    device, num_anchors = anchors.ctx, anchors.shape[0]
    for i in range(batch_size):
        label = labels[i, :, :]
        anchors*bbox*map = assign*anchor*to_bbox(
            label[:, 1:], anchors, device)
        bbox*mask = np.tile((np.expand*dims((anchors*bbox*map >= 0),
                                            axis=-1)), (1, 4)).astype('int32')
        # Initialize class labels and assigned bounding box coordinates with
        # zeros
        class*labels = d2l.zeros(num*anchors, dtype=np.int32, ctx=device)
        assigned*bb = d2l.zeros((num*anchors, 4), dtype=np.float32,
                                ctx=device)
        # Label classes of anchor boxes using their assigned ground-truth
        # bounding boxes. If an anchor box is not assigned any, we label its
        # class as background (the value remains zero)
        indices*true = np.nonzero(anchors*bbox_map >= 0)[0]
        bb*idx = anchors*bbox*map[indices*true]
        class*labels[indices*true] = label[bb_idx, 0].astype('int32') + 1
        assigned*bb[indices*true] = label[bb_idx, 1:]
        # Offset transformation
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
    """Label anchor boxes using ground-truth bounding boxes."""
    batch_size, anchors = labels.shape[0], anchors.squeeze(0)
    batch*offset, batch*mask, batch*class*labels = [], [], []
    device, num_anchors = anchors.device, anchors.shape[0]
    for i in range(batch_size):
        label = labels[i, :, :]
        anchors*bbox*map = assign*anchor*to_bbox(
            label[:, 1:], anchors, device)
        bbox*mask = ((anchors*bbox_map >= 0).float().unsqueeze(-1)).repeat(
            1, 4)
        # Initialize class labels and assigned bounding box coordinates with
        # zeros
        class*labels = torch.zeros(num*anchors, dtype=torch.long,
                                   device=device)
        assigned*bb = torch.zeros((num*anchors, 4), dtype=torch.float32,
                                  device=device)
        # Label classes of anchor boxes using their assigned ground-truth
        # bounding boxes. If an anchor box is not assigned any, we label its
        # class as background (the value remains zero)
        indices*true = torch.nonzero(anchors*bbox_map >= 0)
        bb*idx = anchors*bbox*map[indices*true]
        class*labels[indices*true] = label[bb_idx, 0].long() + 1
        assigned*bb[indices*true] = label[bb_idx, 1:]
        # Offset transformation
        offset = offset*boxes(anchors, assigned*bb) * bbox_mask
        batch_offset.append(offset.reshape(-1))
        batch*mask.append(bbox*mask.reshape(-1))
        batch*class*labels.append(class_labels)
    bbox*offset = torch.stack(batch*offset)
    bbox*mask = torch.stack(batch*mask)
    class*labels = torch.stack(batch*class_labels)
    return (bbox*offset, bbox*mask, class_labels)
```

## # An Example

Let us illustrate anchor box labeling
via a concrete example.
We define ground-truth bounding boxes for the dog and cat in the loaded image,
where the first element is the class (0 for dog and 1 for cat) and the remaining four elements are the
$(x, y)$-axis coordinates
at the upper-left corner and the lower-right corner
(range is between 0 and 1). 
We also construct five anchor boxes to be labeled
using the coordinates of
the upper-left corner and the lower-right corner:
$A*0, \ldots, A*4$ (the index starts from 0).
Then we plot these ground-truth bounding boxes 
and anchor boxes 
in the image.

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

Using the `multibox_target` function defined above,
we can label classes and offsets
of these anchor boxes based on
the ground-truth bounding boxes for the dog and cat.
In this example, indices of
the background, dog, and cat classes
are 0, 1, and 2, respectively. 
Below we add an dimension for examples of anchor boxes and ground-truth bounding boxes.

```{.python .input}
labels = multibox*target(np.expand*dims(anchors, axis=0),
                         np.expand*dims(ground*truth, axis=0))
```

```{.python .input}
# @tab pytorch
labels = multibox_target(anchors.unsqueeze(dim=0),
                         ground_truth.unsqueeze(dim=0))
```

There are three items in the returned result, all of which are in the tensor format.
The third item contains the labeled classes of the input anchor boxes.

Let us analyze the returned class labels below based on
anchor box and ground-truth bounding box positions in the image.
First, among all the pairs of anchor boxes
and ground-truth bounding boxes,
the IoU of the anchor box $A_4$ and the ground-truth bounding box of the cat is the largest. 
Thus, the class of $A_4$ is labeled as the cat.
Taking out 
pairs containing $A_4$ or the ground-truth bounding box of the cat, among the rest 
the pair of the anchor box $A_1$ and the ground-truth bounding box of the dog has the largest IoU.
So the class of $A_1$ is labeled as the dog.
Next, we need to traverse through the remaining three unlabeled anchor boxes: $A*0$, $A*2$, and $A_3$.
For $A_0$,
the class of the ground-truth bounding box with the largest IoU is the dog,
but the IoU is below the predefined threshold (0.5),
so the class is labeled as background;
for $A_2$,
the class of the ground-truth bounding box with the largest IoU is the cat and the IoU exceeds the threshold, so the class is labeled as the cat;
for $A_3$,
the class of the ground-truth bounding box with the largest IoU is the cat, but the value is below the threshold, so the class is labeled as background.

```{.python .input}
# @tab all
labels[2]
```

The second returned item is a mask variable of the shape (batch size, four times the number of anchor boxes).
Every four elements in the mask variable 
correspond to the four offset values of each anchor box.
Since we do not care about background detection,
offsets of this negative class should not affect the objective function.
Through elementwise multiplications, zeros in the mask variable will filter out negative class offsets before calculating the objective function.

```{.python .input}
# @tab all
labels[1]
```

The first returned item contains the four offset values labeled for each anchor box.
Note that the offsets of negative-class anchor boxes are labeled as zeros.

```{.python .input}
# @tab all
labels[0]
```

# # Predicting Bounding Boxes with Non-Maximum Suppression
:label:`subsec_predicting-bounding-boxes-nms`

During prediction,
we generate multiple anchor boxes for the image and predict classes and offsets for each of them.
A *predicted bounding box*
is thus obtained according to 
an anchor box with its predicted offset.
Below we implement the `offset_inverse` function
that takes in anchors and
offset predictions as inputs and applies inverse offset transformations to
return the predicted bounding box coordinates.

```{.python .input}
# @tab all
# @save
def offset*inverse(anchors, offset*preds):
    """Predict bounding boxes based on anchor boxes with predicted offsets."""
    anc = d2l.box*corner*to_center(anchors)
    pred*bbox*xy = (offset_preds[:, :2] * anc[:, 2:] / 10) + anc[:, :2]
    pred*bbox*wh = d2l.exp(offset_preds[:, 2:] / 5) * anc[:, 2:]
    pred*bbox = d2l.concat((pred*bbox*xy, pred*bbox_wh), axis=1)
    predicted*bbox = d2l.box*center*to*corner(pred_bbox)
    return predicted_bbox
```

When there are many anchor boxes,
many similar (with significant overlap)
predicted bounding boxes 
can be potentially output for surrounding the same object.
To simplify the output,
we can merge similar predicted bounding boxes
that belong to the same object
by using *non-maximum suppression* (NMS).

Here is how non-maximum suppression works.
For a predicted bounding box $B$,
the object detection model calculates the predicted likelihood
for each class.
Denoting by $p$ the largest predicted likelihood,
the class corresponding to this probability is the predicted class for $B$.
Specifically, we refer to $p$ as the *confidence* (score) of the predicted bounding box $B$.
On the same image,
all the predicted non-background bounding boxes 
are sorted by confidence in descending order
to generate a list $L$.
Then we manipulate the sorted list $L$ in the following steps:

1. Select the predicted bounding box $B*1$ with the highest confidence from $L$ as a basis and remove all non-basis predicted bounding boxes whose IoU with $B*1$ exceeds a predefined threshold $\epsilon$ from $L$. At this point, $L$ keeps the predicted bounding box with the highest confidence but drops others that are too similar to it. In a nutshell, those with *non-maximum* confidence scores are *suppressed*.
1. Select the predicted bounding box $B*2$ with the second highest confidence from $L$ as another basis and remove all non-basis predicted bounding boxes whose IoU with $B*2$ exceeds $\epsilon$ from $L$.
1. Repeat the above process until all the predicted bounding boxes in $L$ have been used as a basis. At this time, the IoU of any pair of predicted bounding boxes in $L$ is below the threshold $\epsilon$; thus, no pair is too similar with each other. 
1. Output all the predicted bounding boxes in the list $L$.

The following `nms` function sorts confidence scores in descending order and returns their indices.

```{.python .input}
# @save
def nms(boxes, scores, iou_threshold):
    """Sort confidence scores of predicted bounding boxes."""
    B = scores.argsort()[::-1]
    keep = []  # Indices of predicted bounding boxes that will be kept
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
    """Sort confidence scores of predicted bounding boxes."""
    B = torch.argsort(scores, dim=-1, descending=True)
    keep = []  # Indices of predicted bounding boxes that will be kept
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

We define the following `multibox_detection`
to apply non-maximum suppression
to predicting bounding boxes.
Do not worry if you find the implementation
a bit complicated: we will show how it works
with a concrete example right after the implementation.

```{.python .input}
# @save
def multibox*detection(cls*probs, offset*preds, anchors, nms*threshold=0.5,
                       pos_threshold=0.009999999):
    """Predict bounding boxes using non-maximum suppression."""
    device, batch*size = cls*probs.ctx, cls_probs.shape[0]
    anchors = np.squeeze(anchors, axis=0)
    num*classes, num*anchors = cls*probs.shape[1], cls*probs.shape[2]
    out = []
    for i in range(batch_size):
        cls*prob, offset*pred = cls*probs[i], offset*preds[i].reshape(-1, 4)
        conf, class*id = np.max(cls*prob[1:], 0), np.argmax(cls_prob[1:], 0)
        predicted*bb = offset*inverse(anchors, offset_pred)
        keep = nms(predicted*bb, conf, nms*threshold)
        # Find all non-`keep` indices and set the class to background
        all*idx = np.arange(num*anchors, dtype=np.int32, ctx=device)
        combined = d2l.concat((keep, all_idx))
        unique, counts = np.unique(combined, return_counts=True)
        non_keep = unique[counts == 1]
        all*id*sorted = d2l.concat((keep, non_keep))
        class*id[non*keep] = -1
        class*id = class*id[all*id*sorted].astype('float32')
        conf, predicted*bb = conf[all*id*sorted], predicted*bb[all*id*sorted]
        # Here `pos_threshold` is a threshold for positive (non-background)
        # predictions
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
    """Predict bounding boxes using non-maximum suppression."""
    device, batch*size = cls*probs.device, cls_probs.shape[0]
    anchors = anchors.squeeze(0)
    num*classes, num*anchors = cls*probs.shape[1], cls*probs.shape[2]
    out = []
    for i in range(batch_size):
        cls*prob, offset*pred = cls*probs[i], offset*preds[i].reshape(-1, 4)
        conf, class*id = torch.max(cls*prob[1:], 0)
        predicted*bb = offset*inverse(anchors, offset_pred)
        keep = nms(predicted*bb, conf, nms*threshold)
        # Find all non-`keep` indices and set the class to background
        all*idx = torch.arange(num*anchors, dtype=torch.long, device=device)
        combined = torch.cat((keep, all_idx))
        uniques, counts = combined.unique(return_counts=True)
        non_keep = uniques[counts == 1]
        all*id*sorted = torch.cat((keep, non_keep))
        class*id[non*keep] = -1
        class*id = class*id[all*id*sorted]
        conf, predicted*bb = conf[all*id*sorted], predicted*bb[all*id*sorted]
        # Here `pos_threshold` is a threshold for positive (non-background)
        # predictions
        below*min*idx = (conf < pos_threshold)
        class*id[below*min_idx] = -1
        conf[below*min*idx] = 1 - conf[below*min*idx]
        pred*info = torch.cat((class*id.unsqueeze(1),
                               conf.unsqueeze(1),
                               predicted_bb), dim=1)
        out.append(pred_info)
    return d2l.stack(out)
```

Now let us apply the above implementations
to a concrete example with four anchor boxes.
For simplicity, we assume that the
predicted offsets are all zeros.
This means that the predicted bounding boxes are anchor boxes. 
For each class among the background, dog, and cat,
we also define its predicted likelihood.

```{.python .input}
# @tab all
anchors = d2l.tensor([[0.1, 0.08, 0.52, 0.92], [0.08, 0.2, 0.56, 0.95],
                      [0.15, 0.3, 0.62, 0.91], [0.55, 0.2, 0.9, 0.88]])
offset_preds = d2l.tensor([0] * d2l.size(anchors))
cls_probs = d2l.tensor([[0] * 4,  # Predicted background likelihood 
                      [0.9, 0.8, 0.7, 0.1],  # Predicted dog likelihood 
                      [0.1, 0.2, 0.3, 0.9]])  # Predicted cat likelihood
```

We can plot these predicted bounding boxes with their confidence on the image.

```{.python .input}
# @tab all
fig = d2l.plt.imshow(img)
show*bboxes(fig.axes, anchors * bbox*scale,
            ['dog=0.9', 'dog=0.8', 'dog=0.7', 'cat=0.9'])
```

Now we can invoke the `multibox_detection` function
to perform non-maximum suppression,
where the threshold is set to 0.5.
Note that we add
a dimension for examples in the tensor input.

We can see that the shape of the returned result is
(batch size, number of anchor boxes, 6).
The six elements in the innermost dimension
gives the output information for the same predicted bounding box.
The first element is the predicted class index, which starts from 0 (0 is dog and 1 is cat). The value -1 indicates background or removal in non-maximum suppression.
The second element is the confidence of the predicted bounding box.
The remaining four elements are the $(x, y)$-axis coordinates of the upper-left corner and 
the lower-right corner of the predicted bounding box, respectively (range is between 0 and 1).

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

After removing those predicted bounding boxes
of class -1, 
we can output the final predicted bounding box
kept by non-maximum suppression.

```{.python .input}
# @tab all
fig = d2l.plt.imshow(img)
for i in d2l.numpy(output[0]):
    if i[0] == -1:
        continue
    label = ('dog=', 'cat=')[int(i[0])] + str(i[1])
    show*bboxes(fig.axes, [d2l.tensor(i[2:]) * bbox*scale], label)
```

In practice, we can remove predicted bounding boxes with lower confidence even before performing non-maximum suppression, thereby reducing computation in this algorithm.
We may also post-process the output of non-maximum suppression, for example, by only keeping
results with higher confidence
in the final output.


# # Summary

* We generate anchor boxes with different shapes centered on each pixel of the image.
* Intersection over union (IoU), also known as Jaccard index, measures the similarity of two bounding boxes. It is the ratio of their intersection area to their union area.
* In a training set, we need two types of labels for each anchor box. One is the class of the object relevant to the anchor box and the other is the offset of the ground-truth bounding box relative to the anchor box.
* During prediction, we can use non-maximum suppression (NMS) to remove similar predicted bounding boxes, thereby simplifying the output.


# # Exercises

1. Change values of `sizes` and `ratios` in the `multibox_prior` function. What are the changes to the generated anchor boxes?
1. Construct and visualize two bounding boxes with an IoU of 0.5. How do they overlap with each other?
1. Modify the variable `anchors` in :numref:`subsec*labeling-anchor-boxes` and :numref:`subsec*predicting-bounding-boxes-nms`. How do the results change?
1. Non-maximum suppression is a greedy algorithm that suppresses predicted bounding boxes by *removing* them. Is it possible that some of these removed ones are actually useful? How can this algorithm be modified to suppress *softly*? You may refer to Soft-NMS :cite:`Bodla.Singh.Chellappa.ea.2017`.
1. Rather than being hand-crafted, can non-maximum suppression be learned?

:begin_tab:`mxnet`
[Discussions](https://discuss.d2l.ai/t/370)
:end_tab:

:begin_tab:`pytorch`
[Discussions](https://discuss.d2l.ai/t/1603)
:end_tab:
