# Long Short-Term Memory (LSTM)
:label:`sec_lstm`

The challenge to address long-term information preservation and short-term input
skipping in latent variable models has existed for a long time. One of the
earliest approaches to address this was the
long short-term memory (LSTM) :cite:`Hochreiter.Schmidhuber.1997`. It shares many of the properties of the
GRU.
Interestingly, LSTMs have a slightly more complex
design than GRUs but predates GRUs by almost two decades.



# # Gated Memory Cell

Arguably LSTM's design is inspired
by logic gates of a computer.
LSTM introduces a *memory cell* (or *cell* for short)
that has the same shape as the hidden state
(some literatures consider the memory cell
as a special type of the hidden state),
engineered to record additional information.
To control the memory cell
we need a number of gates.
One gate is needed to read out the entries from the
cell.
We will refer to this as the
*output gate*.
A second gate is needed to decide when to read data into the
cell.
We refer to this as the *input gate*.
Last, we need a mechanism to reset
the content of the cell, governed by a *forget gate*.
The motivation for such a
design is the same as that of GRUs,
namely to be able to decide when to remember and
when to ignore inputs in the hidden state via a dedicated mechanism. Let us see
how this works in practice.


## # Input Gate, Forget Gate, and Output Gate

Just like in GRUs,
the data feeding into the LSTM gates are
the input at the current time step and
the hidden state of the previous time step,
as illustrated in :numref:`lstm_0`.
They are processed by
three fully-connected layers with a sigmoid activation function to compute the values of
the input, forget. and output gates.
As a result, values of the three gates
are in the range of $(0, 1)$.

![Computing the input gate, the forget gate, and the output gate in an LSTM model.](../img/lstm-0.svg)
:label:`lstm_0`

Mathematically,
suppose that there are $h$ hidden units, the batch size is $n$, and the number of inputs is $d$.
Thus, the input is $\mathbf{X}*t \in \mathbb{R}^{n \times d}$ and the hidden state of the previous time step is $\mathbf{H}*{t-1} \in \mathbb{R}^{n \times h}$. Correspondingly, the gates at time step $t$
are defined as follows: the input gate is $\mathbf{I}*t \in \mathbb{R}^{n \times h}$, the forget gate is $\mathbf{F}*t \in \mathbb{R}^{n \times h}$, and the output gate is $\mathbf{O}_t \in \mathbb{R}^{n \times h}$. They are calculated as follows:

$$
\begin{aligned}
\mathbf{I}*t &= \sigma(\mathbf{X}*t \mathbf{W}*{xi} + \mathbf{H}*{t-1} \mathbf{W}*{hi} + \mathbf{b}*i),\\
\mathbf{F}*t &= \sigma(\mathbf{X}*t \mathbf{W}*{xf} + \mathbf{H}*{t-1} \mathbf{W}*{hf} + \mathbf{b}*f),\\
\mathbf{O}*t &= \sigma(\mathbf{X}*t \mathbf{W}*{xo} + \mathbf{H}*{t-1} \mathbf{W}*{ho} + \mathbf{b}*o),
\end{aligned}
$$

where $\mathbf{W}*{xi}, \mathbf{W}*{xf}, \mathbf{W}*{xo} \in \mathbb{R}^{d \times h}$ and $\mathbf{W}*{hi}, \mathbf{W}*{hf}, \mathbf{W}*{ho} \in \mathbb{R}^{h \times h}$ are weight parameters and $\mathbf{b}*i, \mathbf{b}*f, \mathbf{b}_o \in \mathbb{R}^{1 \times h}$ are bias parameters.

## # Candidate Memory Cell

Next we design the memory cell. Since we have not specified the action of the various gates yet, we first introduce the *candidate* memory cell $\tilde{\mathbf{C}}_t \in \mathbb{R}^{n \times h}$. Its computation is similar to that of the three gates described above, but using a $\tanh$ function with a value range for $(-1, 1)$ as the activation function. This leads to the following equation at time step $t$:

$$\tilde{\mathbf{C}}*t = \text{tanh}(\mathbf{X}*t \mathbf{W}*{xc} + \mathbf{H}*{t-1} \mathbf{W}*{hc} + \mathbf{b}*c),$$

where $\mathbf{W}*{xc} \in \mathbb{R}^{d \times h}$ and $\mathbf{W}*{hc} \in \mathbb{R}^{h \times h}$ are weight parameters and $\mathbf{b}_c \in \mathbb{R}^{1 \times h}$ is a bias parameter.

A quick illustration of the candidate memory cell is shown in :numref:`lstm_1`.

![Computing the candidate memory cell in an LSTM model.](../img/lstm-1.svg)
:label:`lstm_1`

## # Memory Cell

In GRUs, we have a mechanism to govern input and forgetting (or skipping).
Similarly,
in LSTMs we have two dedicated gates for such purposes: the input gate $\mathbf{I}*t$ governs how much we take new data into account via $\tilde{\mathbf{C}}*t$ and the forget gate $\mathbf{F}*t$ addresses how much of the old memory cell content $\mathbf{C}*{t-1} \in \mathbb{R}^{n \times h}$ we retain. Using the same pointwise multiplication trick as before, we arrive at the following update equation:

$$\mathbf{C}*t = \mathbf{F}*t \odot \mathbf{C}*{t-1} + \mathbf{I}*t \odot \tilde{\mathbf{C}}_t.$$

If the forget gate is always approximately 1 and the input gate is always approximately 0, the past memory cells $\mathbf{C}_{t-1}$ will be saved over time and passed to the current time step.
This design is introduced to alleviate the vanishing gradient problem and to better capture
long range dependencies within sequences.

We thus arrive at the flow diagram in :numref:`lstm_2`.

![Computing the memory cell in an LSTM model.](../img/lstm-2.svg)

:label:`lstm_2`


## # Hidden State

Last, we need to define how to compute the hidden state $\mathbf{H}_t \in \mathbb{R}^{n \times h}$. This is where the output gate comes into play. In LSTM it is simply a gated version of the $\tanh$ of the memory cell.
This ensures that the values of $\mathbf{H}_t$ are always in the interval $(-1, 1)$.

$$\mathbf{H}*t = \mathbf{O}*t \odot \tanh(\mathbf{C}_t).$$


Whenever the output gate approximates 1 we effectively pass all memory information through to the predictor, whereas for the output gate close to 0 we retain all the information only within the memory cell and perform no further processing.



:numref:`lstm_3` has a graphical illustration of the data flow.

![Computing the hidden state in an LSTM model.](../img/lstm-3.svg)
:label:`lstm_3`



# # Implementation from Scratch

Now let us implement an LSTM from scratch.
As same as the experiments in :numref:`sec*rnn*scratch`,
we first load the time machine dataset.

```{.python .input}
from d2l import mxnet as d2l
from mxnet import np, npx
from mxnet.gluon import rnn
npx.set_np()

batch*size, num*steps = 32, 35
train*iter, vocab = d2l.load*data*time*machine(batch*size, num*steps)
```

```{.python .input}
# @tab pytorch
from d2l import torch as d2l
import torch
from torch import nn

batch*size, num*steps = 32, 35
train*iter, vocab = d2l.load*data*time*machine(batch*size, num*steps)
```

## # Initializing Model Parameters

Next we need to define and initialize the model parameters. As previously, the hyperparameter `num_hiddens` defines the number of hidden units. We initialize weights following a Gaussian distribution with 0.01 standard deviation, and we set the biases to 0.

```{.python .input}
def get*lstm*params(vocab*size, num*hiddens, device):
    num*inputs = num*outputs = vocab_size

    def normal(shape):
        return np.random.normal(scale=0.01, size=shape, ctx=device)

    def three():
        return (normal((num*inputs, num*hiddens)),
                normal((num*hiddens, num*hiddens)),
                np.zeros(num_hiddens, ctx=device))

    W*xi, W*hi, b_i = three()  # Input gate parameters
    W*xf, W*hf, b_f = three()  # Forget gate parameters
    W*xo, W*ho, b_o = three()  # Output gate parameters
    W*xc, W*hc, b_c = three()  # Candidate memory cell parameters
    # Output layer parameters
    W*hq = normal((num*hiddens, num_outputs))
    b*q = np.zeros(num*outputs, ctx=device)
    # Attach gradients
    params = [W*xi, W*hi, b*i, W*xf, W*hf, b*f, W*xo, W*ho, b*o, W*xc, W_hc,
              b*c, W*hq, b_q]
    for param in params:
        param.attach_grad()
    return params
```

```{.python .input}
# @tab pytorch
def get*lstm*params(vocab*size, num*hiddens, device):
    num*inputs = num*outputs = vocab_size

    def normal(shape):
        return torch.randn(size=shape, device=device)*0.01

    def three():
        return (normal((num*inputs, num*hiddens)),
                normal((num*hiddens, num*hiddens)),
                d2l.zeros(num_hiddens, device=device))

    W*xi, W*hi, b_i = three()  # Input gate parameters
    W*xf, W*hf, b_f = three()  # Forget gate parameters
    W*xo, W*ho, b_o = three()  # Output gate parameters
    W*xc, W*hc, b_c = three()  # Candidate memory cell parameters
    # Output layer parameters
    W*hq = normal((num*hiddens, num_outputs))
    b*q = d2l.zeros(num*outputs, device=device)
    # Attach gradients
    params = [W*xi, W*hi, b*i, W*xf, W*hf, b*f, W*xo, W*ho, b*o, W*xc, W_hc,
              b*c, W*hq, b_q]
    for param in params:
        param.requires*grad*(True)
    return params
```

## # Defining the Model

In the initialization function, the hidden state of the LSTM needs to return an *additional* memory cell with a value of 0 and a shape of (batch size, number of hidden units). Hence we get the following state initialization.

```{.python .input}
def init*lstm*state(batch*size, num*hiddens, device):
    return (np.zeros((batch*size, num*hiddens), ctx=device),
            np.zeros((batch*size, num*hiddens), ctx=device))
```

```{.python .input}
# @tab pytorch
def init*lstm*state(batch*size, num*hiddens, device):
    return (torch.zeros((batch*size, num*hiddens), device=device),
            torch.zeros((batch*size, num*hiddens), device=device))
```

The actual model is defined just like what we discussed before: providing three gates and an auxiliary memory cell. Note that only the hidden state is passed to the output layer. The memory cell $\mathbf{C}_t$ does not directly participate in the output computation.

```{.python .input}
def lstm(inputs, state, params):
    [W*xi, W*hi, b*i, W*xf, W*hf, b*f, W*xo, W*ho, b*o, W*xc, W*hc, b*c,
     W*hq, b*q] = params
    (H, C) = state
    outputs = []
    for X in inputs:
        I = npx.sigmoid(np.dot(X, W*xi) + np.dot(H, W*hi) + b_i)
        F = npx.sigmoid(np.dot(X, W*xf) + np.dot(H, W*hf) + b_f)
        O = npx.sigmoid(np.dot(X, W*xo) + np.dot(H, W*ho) + b_o)
        C*tilda = np.tanh(np.dot(X, W*xc) + np.dot(H, W*hc) + b*c)
        C = F * C + I * C_tilda
        H = O * np.tanh(C)
        Y = np.dot(H, W*hq) + b*q
        outputs.append(Y)
    return np.concatenate(outputs, axis=0), (H, C)
```

```{.python .input}
# @tab pytorch
def lstm(inputs, state, params):
    [W*xi, W*hi, b*i, W*xf, W*hf, b*f, W*xo, W*ho, b*o, W*xc, W*hc, b*c,
     W*hq, b*q] = params
    (H, C) = state
    outputs = []
    for X in inputs:
        I = torch.sigmoid((X @ W*xi) + (H @ W*hi) + b_i)
        F = torch.sigmoid((X @ W*xf) + (H @ W*hf) + b_f)
        O = torch.sigmoid((X @ W*xo) + (H @ W*ho) + b_o)
        C*tilda = torch.tanh((X @ W*xc) + (H @ W*hc) + b*c)
        C = F * C + I * C_tilda
        H = O * torch.tanh(C)
        Y = (H @ W*hq) + b*q
        outputs.append(Y)
    return torch.cat(outputs, dim=0), (H, C)
```

## # Training and Prediction

Let us train an LSTM as same as what we did in :numref:`sec*gru`, by instantiating the `RNNModelScratch` class as introduced in :numref:`sec*rnn_scratch`.

```{.python .input}
# @tab all
vocab*size, num*hiddens, device = len(vocab), 256, d2l.try_gpu()
num_epochs, lr = 500, 1
model = d2l.RNNModelScratch(len(vocab), num*hiddens, device, get*lstm_params,
                            init*lstm*state, lstm)
d2l.train*ch8(model, train*iter, vocab, lr, num_epochs, device)
```

# # Concise Implementation

Using high-level APIs,
we can directly instantiate an `LSTM` model.
This encapsulates all the configuration details that we made explicit above. The code is significantly faster as it uses compiled operators rather than Python for many details that we spelled out in detail before.

```{.python .input}
lstm*layer = rnn.LSTM(num*hiddens)
model = d2l.RNNModel(lstm_layer, len(vocab))
d2l.train*ch8(model, train*iter, vocab, lr, num_epochs, device)
```

```{.python .input}
# @tab pytorch
num*inputs = vocab*size
lstm*layer = nn.LSTM(num*inputs, num_hiddens)
model = d2l.RNNModel(lstm_layer, len(vocab))
model = model.to(device)
d2l.train*ch8(model, train*iter, vocab, lr, num_epochs, device)
```

LSTMs are the prototypical latent variable autoregressive model with nontrivial state control.
Many variants thereof have been proposed over the years, e.g., multiple layers, residual connections, different types of regularization. However, training LSTMs and other sequence models (such as GRUs) are quite costly due to the long range dependency of the sequence.
Later we will encounter alternative models such as Transformers that can be used in some cases.


# # Summary

* LSTMs have three types of gates: input gates, forget gates, and output gates that control the flow of information.
* The hidden layer output of LSTM includes the hidden state and the memory cell. Only the hidden state is passed into the output layer. The memory cell is entirely internal.
* LSTMs can alleviate vanishing and exploding gradients.


# # Exercises

1. Adjust the hyperparameters and analyze the their influence on running time, perplexity, and the output sequence.
1. How would you need to change the model to generate proper words as opposed to sequences of characters?
1. Compare the computational cost for GRUs, LSTMs, and regular RNNs for a given hidden dimension. Pay special attention to the training and inference cost.
1. Since the candidate memory cell ensures that the value range is between $-1$ and $1$ by  using the $\tanh$ function, why does the hidden state need to use the $\tanh$ function again to ensure that the output value range is between $-1$ and $1$?
1. Implement an LSTM model for time series prediction rather than character sequence prediction.

:begin_tab:`mxnet`
[Discussions](https://discuss.d2l.ai/t/343)
:end_tab:

:begin_tab:`pytorch`
[Discussions](https://discuss.d2l.ai/t/1057)
:end_tab:
