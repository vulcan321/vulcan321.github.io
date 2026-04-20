# Pretraining BERT
:label:`sec_bert-pretraining`

With the BERT model implemented in :numref:`sec_bert`
and the pretraining examples generated from the WikiText-2 dataset in :numref:`sec_bert-dataset`, we will pretrain BERT on the WikiText-2 dataset in this section.

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

To start, we load the WikiText-2 dataset as minibatches
of pretraining examples for masked language modeling and next sentence prediction.
The batch size is 512 and the maximum length of a BERT input sequence is 64.
Note that in the original BERT model, the maximum length is 512.

```{.python .input}
# @tab all
batch*size, max*len = 512, 64
train*iter, vocab = d2l.load*data*wiki(batch*size, max_len)
```

# # Pretraining BERT

The original BERT has two versions of different model sizes :cite:`Devlin.Chang.Lee.ea.2018`.
The base model ($\text{BERT}_{\text{BASE}}$) uses 12 layers (transformer encoder blocks)
with 768 hidden units (hidden size) and 12 self-attention heads.
The large model ($\text{BERT}_{\text{LARGE}}$) uses 24 layers
with 1024 hidden units and 16 self-attention heads.
Notably, the former has 110 million parameters while the latter has 340 million parameters.
For demonstration with ease,
we define a small BERT, using 2 layers, 128 hidden units, and 2 self-attention heads.

```{.python .input}
net = d2l.BERTModel(len(vocab), num*hiddens=128, ffn*num_hiddens=256,
                    num*heads=2, num*layers=2, dropout=0.2)
devices = d2l.try*all*gpus()
net.initialize(init.Xavier(), ctx=devices)
loss = gluon.loss.SoftmaxCELoss()
```

```{.python .input}
# @tab pytorch
net = d2l.BERTModel(len(vocab), num*hiddens=128, norm*shape=[128],
                    ffn*num*input=128, ffn*num*hiddens=256, num_heads=2,
                    num*layers=2, dropout=0.2, key*size=128, query_size=128,
                    value*size=128, hid*in*features=128, mlm*in_features=128,
                    nsp*in*features=128)
devices = d2l.try*all*gpus()
loss = nn.CrossEntropyLoss()
```

Before defining the training loop,
we define a helper function `*get*batch*loss*bert`.
Given the shard of training examples,
this function computes the loss for both the masked language modeling and next sentence prediction tasks.
Note that the final loss of BERT pretraining
is just the sum of both the masked language modeling loss
and the next sentence prediction loss.

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
        # Forward pass
        *, mlm*Y*hat, nsp*Y_hat = net(
            tokens*X*shard, segments*X*shard, valid*lens*x_shard.reshape(-1),
            pred*positions*X_shard)
        # Compute masked language model loss
        mlm_l = loss(
            mlm*Y*hat.reshape((-1, vocab*size)), mlm*Y_shard.reshape(-1),
            mlm*weights*X_shard.reshape((-1, 1)))
        mlm*l = mlm*l.sum() / (mlm*weights*X_shard.sum() + 1e-8)
        # Compute next sentence prediction loss
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
    # Forward pass
    *, mlm*Y*hat, nsp*Y*hat = net(tokens*X, segments_X,
                                  valid*lens*x.reshape(-1),
                                  pred*positions*X)
    # Compute masked language model loss
    mlm*l = loss(mlm*Y*hat.reshape(-1, vocab*size), mlm_Y.reshape(-1)) *\
    mlm*weights*X.reshape(-1, 1)
    mlm*l = mlm*l.sum() / (mlm*weights*X.sum() + 1e-8)
    # Compute next sentence prediction loss
    nsp*l = loss(nsp*Y*hat, nsp*y)
    l = mlm*l + nsp*l
    return mlm*l, nsp*l, l
```

Invoking the two aforementioned helper functions,
the following `train_bert` function
defines the procedure to pretrain BERT (`net`) on the WikiText-2 (`train_iter`) dataset.
Training BERT can take very long.
Instead of specifying the number of epochs for training
as in the `train*ch13` function (see :numref:`sec*image_augmentation`),
the input `num_steps` of the following function
specifies the number of iteration steps for training.

```{.python .input}
def train*bert(train*iter, net, loss, vocab*size, devices, num*steps):
    trainer = gluon.Trainer(net.collect_params(), 'adam',
                            {'learning_rate': 1e-3})
    step, timer = 0, d2l.Timer()
    animator = d2l.Animator(xlabel='step', ylabel='loss',
                            xlim=[1, num_steps], legend=['mlm', 'nsp'])
    # Sum of masked language modeling losses, sum of next sentence prediction
    # losses, no. of sentence pairs, count
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
    trainer = torch.optim.Adam(net.parameters(), lr=1e-3)
    step, timer = 0, d2l.Timer()
    animator = d2l.Animator(xlabel='step', ylabel='loss',
                            xlim=[1, num_steps], legend=['mlm', 'nsp'])
    # Sum of masked language modeling losses, sum of next sentence prediction
    # losses, no. of sentence pairs, count
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

We can plot both the masked language modeling loss and the next sentence prediction loss
during BERT pretraining.

```{.python .input}
# @tab all
train*bert(train*iter, net, loss, len(vocab), devices, 50)
```

# # Representing Text with BERT

After pretraining BERT,
we can use it to represent single text, text pairs, or any token in them.
The following function returns the BERT (`net`) representations for all tokens
in `tokens*a` and `tokens*b`.

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

Consider the sentence "a crane is flying".
Recall the input representation of BERT as discussed in :numref:`subsec*bert*input_rep`.
After inserting special tokens “&lt;cls&gt;” (used for classification)
and “&lt;sep&gt;” (used for separation),
the BERT input sequence has a length of six.
Since zero is the index of the “&lt;cls&gt;” token,
`encoded_text[:, 0, :]` is the BERT representation of the entire input sentence.
To evaluate the polysemy token "crane",
we also print out the first three elements of the BERT representation of the token.

```{.python .input}
# @tab all
tokens_a = ['a', 'crane', 'is', 'flying']
encoded*text = get*bert*encoding(net, tokens*a)
# Tokens: '<cls>', 'a', 'crane', 'is', 'flying', '<sep>'
encoded*text*cls = encoded_text[:, 0, :]
encoded*text*crane = encoded_text[:, 2, :]
encoded*text.shape, encoded*text*cls.shape, encoded*text_crane[0][:3]
```

Now consider a sentence pair
"a crane driver came" and "he just left".
Similarly, `encoded_pair[:, 0, :]` is the encoded result of the entire sentence pair from the pretrained BERT.
Note that the first three elements of the polysemy token "crane" are different from those when the context is different.
This supports that BERT representations are context-sensitive.

```{.python .input}
# @tab all
tokens*a, tokens*b = ['a', 'crane', 'driver', 'came'], ['he', 'just', 'left']
encoded*pair = get*bert*encoding(net, tokens*a, tokens_b)
# Tokens: '<cls>', 'a', 'crane', 'driver', 'came', '<sep>', 'he', 'just',
# 'left', '<sep>'
encoded*pair*cls = encoded_pair[:, 0, :]
encoded*pair*crane = encoded_pair[:, 2, :]
encoded*pair.shape, encoded*pair*cls.shape, encoded*pair_crane[0][:3]
```

In :numref:`chap*nlp*app`, we will fine-tune a pretrained BERT model
for downstream natural language processing applications.


# # Summary

* The original BERT has two versions, where the base model has 110 million parameters and the large model has 340 million parameters.
* After pretraining BERT, we can use it to represent single text, text pairs, or any token in them.
* In the experiment, the same token has different BERT representation when their contexts are different. This supports that BERT representations are context-sensitive.

# # Exercises

1. In the experiment, we can see that the masked language modeling loss is significantly higher than the next sentence prediction loss. Why?
2. Set the maximum length of a BERT input sequence to be 512 (same as the original BERT model). Use the configurations of the original BERT model such as $\text{BERT}_{\text{LARGE}}$. Do you encounter any error when running this section? Why?

:begin_tab:`mxnet`
[Discussions](https://discuss.d2l.ai/t/390)
:end_tab:

:begin_tab:`pytorch`
[Discussions](https://discuss.d2l.ai/t/1497)
:end_tab:
