# Concise Implementation of Recurrent Neural Networks
:label:`sec_rnn-concise`

While :numref:`sec*rnn*scratch` was instructive to see how RNNs are implemented,
this is not convenient or fast.
This section will show how to implement the same language model more efficiently
using functions provided by high-level APIs
of a deep learning framework.
We begin as before by reading the time machine dataset.

```{.python .input}
from d2l import mxnet as d2l
from mxnet import np, npx
from mxnet.gluon import nn, rnn
npx.set_np()

batch*size, num*steps = 32, 35
train*iter, vocab = d2l.load*data*time*machine(batch*size, num*steps)
```

```{.python .input}
# @tab pytorch
from d2l import torch as d2l
import torch
from torch import nn
from torch.nn import functional as F

batch*size, num*steps = 32, 35
train*iter, vocab = d2l.load*data*time*machine(batch*size, num*steps)
```

# # Defining the Model

High-level APIs provide implementations of recurrent neural networks.
We construct the recurrent neural network layer `rnn_layer` with a single hidden layer and 256 hidden units.
In fact, we have not even discussed yet what it means to have multiple layers---this will happen in :numref:`sec*deep*rnn`.
For now, suffice it to say that multiple layers simply amount to the output of one layer of RNN being used as the input for the next layer of RNN.

```{.python .input}
num_hiddens = 256
rnn*layer = rnn.RNN(num*hiddens)
rnn_layer.initialize()
```

```{.python .input}
# @tab pytorch
num_hiddens = 256
rnn*layer = nn.RNN(len(vocab), num*hiddens)
```

:begin_tab:`mxnet`
Initializing the hidden state is straightforward.
We invoke the member function `begin_state`.
This returns a list (`state`)
that contains
an initial hidden state
for each example in the minibatch,
whose shape is
(number of hidden layers, batch size, number of hidden units).
For some models 
to be introduced later 
(e.g., long short-term memory),
such a list also
contains other information.
:end_tab:

:begin_tab:`pytorch`
We use a tensor to initialize the hidden state,
whose shape is
(number of hidden layers, batch size, number of hidden units).
:end_tab:

```{.python .input}
state = rnn*layer.begin*state(batch*size=batch*size)
len(state), state[0].shape
```

```{.python .input}
# @tab pytorch
state = torch.zeros((1, batch*size, num*hiddens))
state.shape
```

With a hidden state and an input,
we can compute the output with
the updated hidden state.
It should be emphasized that
the "output" (`Y`) of `rnn_layer`
does *not* involve computation of output layers:
it refers to 
the hidden state at *each* time step,
and they can be used as the input
to the subsequent output layer.

:begin_tab:`mxnet`
Besides,
the updated hidden state (`state*new`) returned by `rnn*layer`
refers to the hidden state
at the *last* time step of the minibatch.
It can be used to initialize the 
hidden state for the next minibatch within an epoch
in sequential partitioning.
For multiple hidden layers,
the hidden state of each layer will be stored
in this variable (`state_new`).
For some models 
to be introduced later 
(e.g., long short-term memory),
this variable also
contains other information.
:end_tab:

```{.python .input}
X = np.random.uniform(size=(num*steps, batch*size, len(vocab)))
Y, state*new = rnn*layer(X, state)
Y.shape, len(state*new), state*new[0].shape
```

```{.python .input}
# @tab pytorch
X = torch.rand(size=(num*steps, batch*size, len(vocab)))
Y, state*new = rnn*layer(X, state)
Y.shape, state_new.shape
```

Similar to :numref:`sec*rnn*scratch`,
we define an `RNNModel` class 
for a complete RNN model.
Note that `rnn_layer` only contains the hidden recurrent layers, we need to create a separate output layer.

```{.python .input}
# @save
class RNNModel(nn.Block):
    """The RNN model."""
    def **init**(self, rnn*layer, vocab*size, **kwargs):
        super(RNNModel, self).**init**(**kwargs)
        self.rnn = rnn_layer
        self.vocab*size = vocab*size
        self.dense = nn.Dense(vocab_size)

    def forward(self, inputs, state):
        X = npx.one*hot(inputs.T, self.vocab*size)
        Y, state = self.rnn(X, state)
        # The fully-connected layer will first change the shape of `Y` to
        # (`num*steps` * `batch*size`, `num_hiddens`). Its output shape is
        # (`num*steps` * `batch*size`, `vocab_size`).
        output = self.dense(Y.reshape(-1, Y.shape[-1]))
        return output, state

    def begin_state(self, *args, **kwargs):
        return self.rnn.begin_state(*args, **kwargs)
```

```{.python .input}
# @tab pytorch
# @save
class RNNModel(nn.Module):
    """The RNN model."""
    def **init**(self, rnn*layer, vocab*size, **kwargs):
        super(RNNModel, self).**init**(**kwargs)
        self.rnn = rnn_layer
        self.vocab*size = vocab*size
        self.num*hiddens = self.rnn.hidden*size
        # If the RNN is bidirectional (to be introduced later),
        # `num_directions` should be 2, else it should be 1.
        if not self.rnn.bidirectional:
            self.num_directions = 1
            self.linear = nn.Linear(self.num*hiddens, self.vocab*size)
        else:
            self.num_directions = 2
            self.linear = nn.Linear(self.num*hiddens * 2, self.vocab*size)

    def forward(self, inputs, state):
        X = F.one*hot(inputs.T.long(), self.vocab*size)
        X = X.to(torch.float32)
        Y, state = self.rnn(X, state)
        # The fully connected layer will first change the shape of `Y` to
        # (`num*steps` * `batch*size`, `num_hiddens`). Its output shape is
        # (`num*steps` * `batch*size`, `vocab_size`).
        output = self.linear(Y.reshape((-1, Y.shape[-1])))
        return output, state

    def begin*state(self, device, batch*size=1):
        if not isinstance(self.rnn, nn.LSTM):
            # `nn.GRU` takes a tensor as hidden state
            return  torch.zeros((self.num*directions * self.rnn.num*layers,
                                 batch*size, self.num*hiddens), 
                                device=device)
        else:
            # `nn.LSTM` takes a tuple of hidden states
            return (torch.zeros((
                self.num*directions * self.rnn.num*layers,
                batch*size, self.num*hiddens), device=device),
                    torch.zeros((
                        self.num*directions * self.rnn.num*layers,
                        batch*size, self.num*hiddens), device=device))
```

# # Training and Predicting

Before training the model, let us make a prediction with the a model that has random weights.

```{.python .input}
device = d2l.try_gpu()
model = RNNModel(rnn_layer, len(vocab))
model.initialize(force_reinit=True, ctx=device)
d2l.predict_ch8('time traveller', 10, model, vocab, device)
```

```{.python .input}
# @tab pytorch
device = d2l.try_gpu()
model = RNNModel(rnn*layer, vocab*size=len(vocab))
model = model.to(device)
d2l.predict_ch8('time traveller', 10, model, vocab, device)
```

As is quite obvious, this model does not work at all. Next, we call `train*ch8` with the same hyperparameters defined in :numref:`sec*rnn_scratch` and train our model with high-level APIs.

```{.python .input}
# @tab all
num_epochs, lr = 500, 1
d2l.train*ch8(model, train*iter, vocab, lr, num_epochs, device)
```

Compared with the last section, this model achieves comparable perplexity,
albeit within a shorter period of time, due to the code being more optimized by
high-level APIs of the deep learning framework.


# # Summary

* High-level APIs of the deep learning framework provides an implementation of the RNN layer.
* The RNN layer of high-level APIs returns an output and an updated hidden state, where the output does not involve output layer computation.
* Using high-level APIs leads to faster RNN training than using its implementation from scratch.

# # Exercises

1. Can you make the RNN model overfit using the high-level APIs?
1. What happens if you increase the number of hidden layers in the RNN model? Can you make the model work?
1. Implement the autoregressive model of :numref:`sec_sequence` using an RNN.

:begin_tab:`mxnet`
[Discussions](https://discuss.d2l.ai/t/335)
:end_tab:

:begin_tab:`pytorch`
[Discussions](https://discuss.d2l.ai/t/1053)
:end_tab:
