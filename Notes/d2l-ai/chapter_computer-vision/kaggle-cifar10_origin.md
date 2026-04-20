# Image Classification (CIFAR-10) on Kaggle
:label:`sec*kaggle*cifar10`

So far, we have been using high-level APIs of deep learning frameworks to directly obtain image datasets in tensor format. 
However, custom image datasets 
often come in the form of image files.
In this section, we will start from 
raw image files, 
and organize, read, then transform them
into tensor format step by step.

We experimented with the CIFAR-10 dataset in :numref:`sec*image*augmentation`,
which is an important dataset in computer vision.
In this section,
we will apply the knowledge we learned 
in previous sections
to practice the Kaggle competition of
CIFAR-10 image classification. 
The web address of the competition is https://www.kaggle.com/c/cifar-10

:numref:`fig*kaggle*cifar10` shows the information on the competition's webpage.
In order to submit the results, 
you need to register a Kaggle account.

![CIFAR-10 image classification competition webpage information. The competition dataset can be obtained by clicking the "Data" tab.](../img/kaggle-cifar10.png)
:width:`600px`
:label:`fig*kaggle*cifar10`

```{.python .input}
import collections
from d2l import mxnet as d2l
import math
from mxnet import gluon, init, npx
from mxnet.gluon import nn
import os
import pandas as pd
import shutil

npx.set_np()
```

```{.python .input}
# @tab pytorch
import collections
from d2l import torch as d2l
import math
import torch
import torchvision
from torch import nn
import os
import pandas as pd
import shutil
```

# # Obtaining and Organizing the Dataset

The competition dataset is divided into 
a training set and a test set,
which contain 50000 and 300000 images, respectively.
In the test set,
10000 images will be used for evaluation, 
while the remaining 290000 images will not 
be evaluated: 
they are included just
to make it hard
to cheat with
*manually* labeled results of the test set.
The images in this dataset
are all png color (RGB channels) image files,
whose height and width are both 32 pixels.
The images cover a total of 10 categories, namely airplanes, cars, birds, cats, deer, dogs, frogs, horses, boats, and trucks.
The upper left corner of :numref:`fig*kaggle*cifar10` shows some images of airplanes, cars, and birds in the dataset.


## # Downloading the Dataset

After logging in to Kaggle, we can click the "Data" tab on the CIFAR-10 image classification competition webpage shown in :numref:`fig*kaggle*cifar10` and download the dataset by clicking the "Download All" button.
After unzipping the downloaded file in `../data`, and unzipping `train.7z` and `test.7z` inside it, you will find the entire dataset in the following paths:

* `../data/cifar-10/train/[1-50000].png`
* `../data/cifar-10/test/[1-300000].png`
* `../data/cifar-10/trainLabels.csv`
* `../data/cifar-10/sampleSubmission.csv`

where the `train` and `test` directories contain the training and testing images, respectively, `trainLabels.csv` provides labels for the training images, and `sample_submission.csv` is a sample submission file.

To make it easier to get started, we provide a small-scale sample of the dataset that
contains the first 1000 training images and 5 random testing images.
To use the full dataset of the Kaggle competition, you need to set the following `demo` variable to `False`.

```{.python .input}
# @tab all
# @save
d2l.DATA*HUB['cifar10*tiny'] = (d2l.DATA*URL + 'kaggle*cifar10_tiny.zip',
                                '2068874e4b9a9f0fb07ebe0ad2b29754449ccacd')

# If you use the full dataset downloaded for the Kaggle competition, set
# `demo` to False
demo = True

if demo:
    data*dir = d2l.download*extract('cifar10_tiny')
else:
    data_dir = '../data/cifar-10/'
```

## # Organizing the Dataset

We need to organize datasets to facilitate model training and testing. 
Let us first read the labels from the csv file.
The following function returns a dictionary that maps
the non-extension part of the filename to its label.

```{.python .input}
# @tab all
# @save
def read*csv*labels(fname):
    """Read `fname` to return a filename to label dictionary."""
    with open(fname, 'r') as f:
        # Skip the file header line (column name)
        lines = f.readlines()[1:]
    tokens = [l.rstrip().split(',') for l in lines]
    return dict(((name, label) for name, label in tokens))

labels = read*csv*labels(os.path.join(data_dir, 'trainLabels.csv'))
print('# training examples:', len(labels))
print('# classes:', len(set(labels.values())))
```

Next, we define the `reorg*train*valid` function to split the validation set out of the original training set.
The argument `valid_ratio` in this function is the ratio of the number of examples in the validation set to the number of examples in the original training set.
More concretely,
let $n$ be the number of images of the class with the least examples, and $r$ be the ratio. 
The validation set will split out
$\max(\lfloor nr\rfloor,1)$ images for each class.
Let us use `valid_ratio=0.1` as an example. Since the original training set has 50000 images,
there will be 45000 images used for training in the path `train*valid*test/train`,
while the other 5000 images will be split out
as validation set in the path `train*valid*test/valid`. After organizing the dataset, images of the same class will be placed under the same folder.

```{.python .input}
# @tab all
# @save
def copyfile(filename, target_dir):
    """Copy a file into a target directory."""
    os.makedirs(target*dir, exist*ok=True)
    shutil.copy(filename, target_dir)

# @save
def reorg*train*valid(data*dir, labels, valid*ratio):
    # The number of examples of the class that has the fewest examples in the
    # training dataset
    n = collections.Counter(labels.values()).most_common()[-1][1]
    # The number of examples per class for the validation set
    n*valid*per*label = max(1, math.floor(n * valid*ratio))
    label_count = {}
    for train*file in os.listdir(os.path.join(data*dir, 'train')):
        label = labels[train_file.split('.')[0]]
        fname = os.path.join(data*dir, 'train', train*file)
        copyfile(fname, os.path.join(data*dir, 'train*valid_test',
                                     'train_valid', label))
        if label not in label*count or label*count[label] < n*valid*per_label:
            copyfile(fname, os.path.join(data*dir, 'train*valid_test',
                                         'valid', label))
            label*count[label] = label*count.get(label, 0) + 1
        else:
            copyfile(fname, os.path.join(data*dir, 'train*valid_test',
                                         'train', label))
    return n*valid*per_label
```

The `reorg_test` function below organizes the testing set for data loading during prediction.

```{.python .input}
# @tab all
# @save
def reorg*test(data*dir):
    for test*file in os.listdir(os.path.join(data*dir, 'test')):
        copyfile(os.path.join(data*dir, 'test', test*file),
                 os.path.join(data*dir, 'train*valid_test', 'test',
                              'unknown'))
```

Finally, we use a function to invoke
the `read*csv*labels`, `reorg*train*valid`, and `reorg_test` functions defined above.

```{.python .input}
# @tab all
def reorg*cifar10*data(data*dir, valid*ratio):
    labels = read*csv*labels(os.path.join(data_dir, 'trainLabels.csv'))
    reorg*train*valid(data*dir, labels, valid*ratio)
    reorg*test(data*dir)
```

Here we only set the batch size to 4 for the small-scale sample of the dataset.
When training and testing
the complete dataset of the Kaggle competition,
`batch_size` should be set to a larger integer, such as 128.
We split out 10% of the training examples as the validation set for tuning hyperparameters.

```{.python .input}
# @tab all
batch_size = 4 if demo else 128
valid_ratio = 0.1
reorg*cifar10*data(data*dir, valid*ratio)
```

# # Image Augmentation

We use image augmentation to address overfitting.
For example, images can be flipped horizontally at random during training.
We can also perform standardization for the three RGB channels of color images. Below lists some of these operations that you can tweak.

```{.python .input}
transform_train = gluon.data.vision.transforms.Compose([
    # Scale the image up to a square of 40 pixels in both height and width
    gluon.data.vision.transforms.Resize(40),
    # Randomly crop a square image of 40 pixels in both height and width to
    # produce a small square of 0.64 to 1 times the area of the original
    # image, and then scale it to a square of 32 pixels in both height and
    # width
    gluon.data.vision.transforms.RandomResizedCrop(32, scale=(0.64, 1.0),
                                                   ratio=(1.0, 1.0)),
    gluon.data.vision.transforms.RandomFlipLeftRight(),
    gluon.data.vision.transforms.ToTensor(),
    # Standardize each channel of the image
    gluon.data.vision.transforms.Normalize([0.4914, 0.4822, 0.4465],
                                           [0.2023, 0.1994, 0.2010])])
```

```{.python .input}
# @tab pytorch
transform_train = torchvision.transforms.Compose([
    # Scale the image up to a square of 40 pixels in both height and width
    torchvision.transforms.Resize(40),
    # Randomly crop a square image of 40 pixels in both height and width to
    # produce a small square of 0.64 to 1 times the area of the original
    # image, and then scale it to a square of 32 pixels in both height and
    # width
    torchvision.transforms.RandomResizedCrop(32, scale=(0.64, 1.0),
                                                   ratio=(1.0, 1.0)),
    torchvision.transforms.RandomHorizontalFlip(),
    torchvision.transforms.ToTensor(),
    # Standardize each channel of the image
    torchvision.transforms.Normalize([0.4914, 0.4822, 0.4465],
                                     [0.2023, 0.1994, 0.2010])])
```

During testing,
we only perform standardization on images
so as to
remove randomness in the evaluation results.

```{.python .input}
transform_test = gluon.data.vision.transforms.Compose([
    gluon.data.vision.transforms.ToTensor(),
    gluon.data.vision.transforms.Normalize([0.4914, 0.4822, 0.4465],
                                           [0.2023, 0.1994, 0.2010])])
```

```{.python .input}
# @tab pytorch
transform_test = torchvision.transforms.Compose([
    torchvision.transforms.ToTensor(),
    torchvision.transforms.Normalize([0.4914, 0.4822, 0.4465],
                                     [0.2023, 0.1994, 0.2010])])
```

# # Reading the Dataset

Next, we read the organized dataset consisting of raw image files. Each example includes an image and a label.

```{.python .input}
train*ds, valid*ds, train*valid*ds, test_ds = [
    gluon.data.vision.ImageFolderDataset(
        os.path.join(data*dir, 'train*valid_test', folder))
    for folder in ['train', 'valid', 'train_valid', 'test']]
```

```{.python .input}
# @tab pytorch
train*ds, train*valid_ds = [torchvision.datasets.ImageFolder(
    os.path.join(data*dir, 'train*valid_test', folder),
    transform=transform*train) for folder in ['train', 'train*valid']]

valid*ds, test*ds = [torchvision.datasets.ImageFolder(
    os.path.join(data*dir, 'train*valid_test', folder),
    transform=transform_test) for folder in ['valid', 'test']]
```

During training,
we need to specify all the image augmentation operations defined above.
When the validation set
is used for model evaluation during hyperparameter tuning,
no randomness from image augmentation should be introduced.
Before final prediction,
we train the model on the combined training set and validation set to make full use of all the labeled data.

```{.python .input}
train*iter, train*valid_iter = [gluon.data.DataLoader(
    dataset.transform*first(transform*train), batch_size, shuffle=True,
    last*batch='discard') for dataset in (train*ds, train*valid*ds)]

valid_iter = gluon.data.DataLoader(
    valid*ds.transform*first(transform*test), batch*size, shuffle=False,
    last_batch='discard')

test_iter = gluon.data.DataLoader(
    test*ds.transform*first(transform*test), batch*size, shuffle=False,
    last_batch='keep')
```

```{.python .input}
# @tab pytorch
train*iter, train*valid_iter = [torch.utils.data.DataLoader(
    dataset, batch*size, shuffle=True, drop*last=True)
    for dataset in (train*ds, train*valid_ds)]

valid*iter = torch.utils.data.DataLoader(valid*ds, batch_size, shuffle=False,
                                         drop_last=True)

test*iter = torch.utils.data.DataLoader(test*ds, batch_size, shuffle=False,
                                        drop_last=False)
```

# # Defining the Model

:begin_tab:`mxnet`
Here, we build the residual blocks based on the `HybridBlock` class, which is
slightly different from the implementation described in
:numref:`sec_resnet`.
This is for improving computational efficiency.
:end_tab:

```{.python .input}
class Residual(nn.HybridBlock):
    def **init**(self, num*channels, use*1x1conv=False, strides=1, **kwargs):
        super(Residual, self).**init**(**kwargs)
        self.conv1 = nn.Conv2D(num*channels, kernel*size=3, padding=1,
                               strides=strides)
        self.conv2 = nn.Conv2D(num*channels, kernel*size=3, padding=1)
        if use_1x1conv:
            self.conv3 = nn.Conv2D(num*channels, kernel*size=1,
                                   strides=strides)
        else:
            self.conv3 = None
        self.bn1 = nn.BatchNorm()
        self.bn2 = nn.BatchNorm()

    def hybrid_forward(self, F, X):
        Y = F.npx.relu(self.bn1(self.conv1(X)))
        Y = self.bn2(self.conv2(Y))
        if self.conv3:
            X = self.conv3(X)
        return F.npx.relu(Y + X)
```

:begin_tab:`mxnet`
Next, we define the ResNet-18 model.
:end_tab:

```{.python .input}
def resnet18(num_classes):
    net = nn.HybridSequential()
    net.add(nn.Conv2D(64, kernel_size=3, strides=1, padding=1),
            nn.BatchNorm(), nn.Activation('relu'))

    def resnet*block(num*channels, num*residuals, first*block=False):
        blk = nn.HybridSequential()
        for i in range(num_residuals):
            if i == 0 and not first_block:
                blk.add(Residual(num*channels, use*1x1conv=True, strides=2))
            else:
                blk.add(Residual(num_channels))
        return blk

    net.add(resnet*block(64, 2, first*block=True),
            resnet_block(128, 2),
            resnet_block(256, 2),
            resnet_block(512, 2))
    net.add(nn.GlobalAvgPool2D(), nn.Dense(num_classes))
    return net
```

:begin_tab:`mxnet`
We use Xavier initialization described in :numref:`subsec_xavier` before training begins.
:end_tab:

:begin_tab:`pytorch`
We define the ResNet-18 model described in
:numref:`sec_resnet`.
:end_tab:

```{.python .input}
def get_net(devices):
    num_classes = 10
    net = resnet18(num_classes)
    net.initialize(ctx=devices, init=init.Xavier())
    return net

loss = gluon.loss.SoftmaxCrossEntropyLoss()
```

```{.python .input}
# @tab pytorch
def get_net():
    num_classes = 10
    net = d2l.resnet18(num_classes, 3)
    return net

loss = nn.CrossEntropyLoss(reduction="none")
```

# # Defining the Training Function

We will select models and tune hyperparameters according to the model's performance on the validation set. 
In the following, we define the model training function `train`.

```{.python .input}
def train(net, train*iter, valid*iter, num*epochs, lr, wd, devices, lr*period,
          lr_decay):
    trainer = gluon.Trainer(net.collect_params(), 'sgd',
                            {'learning_rate': lr, 'momentum': 0.9, 'wd': wd})
    num*batches, timer = len(train*iter), d2l.Timer()
    animator = d2l.Animator(xlabel='epoch', xlim=[1, num_epochs],
                            legend=['train loss', 'train acc', 'valid acc'])
    for epoch in range(num_epochs):
        metric = d2l.Accumulator(3)
        if epoch > 0 and epoch % lr_period == 0:
            trainer.set*learning*rate(trainer.learning*rate * lr*decay)
        for i, (features, labels) in enumerate(train_iter):
            timer.start()
            l, acc = d2l.train*batch*ch13(
                net, features, labels.astype('float32'), loss, trainer,
                devices, d2l.split_batch)
            metric.add(l, acc, labels.shape[0])
            timer.stop()
            if (i + 1) % (num*batches // 5) == 0 or i == num*batches - 1:
                animator.add(epoch + (i + 1) / num_batches,
                             (metric[0] / metric[2], metric[1] / metric[2],
                              None))
        if valid_iter is not None:
            valid*acc = d2l.evaluate*accuracy*gpus(net, valid*iter,
                                                   d2l.split_batch)
            animator.add(epoch + 1, (None, None, valid_acc))
    if valid_iter is not None:
        print(f'loss {metric[0] / metric[2]:.3f}, '
              f'train acc {metric[1] / metric[2]:.3f}, '
              f'valid acc {valid_acc:.3f}')
    else:
        print(f'loss {metric[0] / metric[2]:.3f}, '
              f'train acc {metric[1] / metric[2]:.3f}')
    print(f'{metric[2] * num_epochs / timer.sum():.1f} examples/sec '
          f'on {str(devices)}')
```

```{.python .input}
# @tab pytorch
def train(net, train*iter, valid*iter, num*epochs, lr, wd, devices, lr*period,
          lr_decay):
    trainer = torch.optim.SGD(net.parameters(), lr=lr, momentum=0.9,
                              weight_decay=wd)
    scheduler = torch.optim.lr*scheduler.StepLR(trainer, lr*period, lr_decay)
    num*batches, timer = len(train*iter), d2l.Timer()
    animator = d2l.Animator(xlabel='epoch', xlim=[1, num_epochs],
                            legend=['train loss', 'train acc', 'valid acc'])
    net = nn.DataParallel(net, device_ids=devices).to(devices[0])
    for epoch in range(num_epochs):
        net.train()
        metric = d2l.Accumulator(3)
        for i, (features, labels) in enumerate(train_iter):
            timer.start()
            l, acc = d2l.train*batch*ch13(net, features, labels,
                                          loss, trainer, devices)
            metric.add(l, acc, labels.shape[0])
            timer.stop()
            if (i + 1) % (num*batches // 5) == 0 or i == num*batches - 1:
                animator.add(epoch + (i + 1) / num_batches,
                             (metric[0] / metric[2], metric[1] / metric[2],
                              None))
        if valid_iter is not None:
            valid*acc = d2l.evaluate*accuracy*gpu(net, valid*iter)
            animator.add(epoch + 1, (None, None, valid_acc))
        scheduler.step()
    if valid_iter is not None:
        print(f'loss {metric[0] / metric[2]:.3f}, '
              f'train acc {metric[1] / metric[2]:.3f}, '
              f'valid acc {valid_acc:.3f}')
    else:
        print(f'loss {metric[0] / metric[2]:.3f}, '
              f'train acc {metric[1] / metric[2]:.3f}')
    print(f'{metric[2] * num_epochs / timer.sum():.1f} examples/sec '
          f'on {str(devices)}')
```

# # Training and Validating the Model

Now, we can train and validate the model.
All the following hyperparameters can be tuned.
For example, we can increase the number of epochs.
When `lr*period` and `lr*decay` are set to 50 and 0.1, respectively, the learning rate of the optimization algorithm will be multiplied by 0.1 after every 50 epochs. Just for demonstration,
we only train 5 epochs here.

```{.python .input}
devices, num*epochs, lr, wd = d2l.try*all_gpus(), 5, 0.1, 5e-4
lr*period, lr*decay, net = 50, 0.1, get_net(devices)
net.hybridize()
train(net, train*iter, valid*iter, num*epochs, lr, wd, devices, lr*period,
      lr_decay)
```

```{.python .input}
# @tab pytorch
devices, num*epochs, lr, wd = d2l.try*all_gpus(), 5, 0.1, 5e-4
lr*period, lr*decay, net = 50, 0.1, get_net()
train(net, train*iter, valid*iter, num*epochs, lr, wd, devices, lr*period,
      lr_decay)
```

# # Classifying the Testing Set and Submitting Results on Kaggle

After obtaining a promising model with hyperparameters,
we use all the labeled data (including the validation set) to retrain the model and classify the testing set.

```{.python .input}
net, preds = get_net(devices), []
net.hybridize()
train(net, train*valid*iter, None, num*epochs, lr, wd, devices, lr*period,
      lr_decay)

for X, * in test*iter:
    y*hat = net(X.as*in_ctx(devices[0]))
    preds.extend(y_hat.argmax(axis=1).astype(int).asnumpy())
sorted*ids = list(range(1, len(test*ds) + 1))
sorted_ids.sort(key=lambda x: str(x))
df = pd.DataFrame({'id': sorted_ids, 'label': preds})
df['label'] = df['label'].apply(lambda x: train*valid*ds.synsets[x])
df.to_csv('submission.csv', index=False)
```

```{.python .input}
# @tab pytorch
net, preds = get_net(), []
train(net, train*valid*iter, None, num*epochs, lr, wd, devices, lr*period,
      lr_decay)

for X, * in test*iter:
    y_hat = net(X.to(devices[0]))
    preds.extend(y_hat.argmax(dim=1).type(torch.int32).cpu().numpy())
sorted*ids = list(range(1, len(test*ds) + 1))
sorted_ids.sort(key=lambda x: str(x))
df = pd.DataFrame({'id': sorted_ids, 'label': preds})
df['label'] = df['label'].apply(lambda x: train*valid*ds.classes[x])
df.to_csv('submission.csv', index=False)
```

The above code
will generate a `submission.csv` file,
whose format
meets the requirement of the Kaggle competition.
The method
for submitting results to Kaggle
is similar to that in :numref:`sec*kaggle*house`.

# # Summary

* We can read datasets containing raw image files after organizing them into the required format.
:begin_tab:`mxnet`
* We can use convolutional neural networks, image augmentation, and hybrid programing in an image classification competition.
:end_tab:
:begin_tab:`pytorch`
* We can use convolutional neural networks and image augmentation in an image classification competition.
:end_tab:


# # Exercises

1. Use the complete CIFAR-10 dataset for this Kaggle competition. Change the `batch*size` and number of epochs `num*epochs` to 128 and 100, respectively.  See what accuracy and ranking you can achieve in this competition. Can you further improve them?
1. What accuracy can you get when not using image augmentation?


:begin_tab:`mxnet`
[Discussions](https://discuss.d2l.ai/t/379)
:end_tab:

:begin_tab:`pytorch`
[Discussions](https://discuss.d2l.ai/t/1479)
:end_tab:
