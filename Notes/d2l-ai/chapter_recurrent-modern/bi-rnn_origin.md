# Bidirectional Recurrent Neural Networks
:label:`sec*bi*rnn`

In sequence learning,
so far we assumed that our goal is to model the next output given what we have seen so far, e.g., in the context of a time series or in the context of a language model. While this is a typical scenario, it is not the only one we might encounter. To illustrate the issue, consider the following three tasks of filling in the blank in a text sequence:

* I am `___`.
* I am `___` hungry.
* I am `___` hungry, and I can eat half a pig.

Depending on the amount of information available, we might fill in the blanks with very different words such as "happy", "not", and "very".
Clearly the end of the phrase (if available) conveys significant information about which word to pick.
A sequence model that is incapable of taking advantage of this will perform poorly on related tasks.
For instance, to do well in named entity recognition (e.g., to recognize whether "Green" refers to "Mr. Green" or to the color)
longer-range context is equally vital.
To get some inspiration for addressing the problem let us take a detour to probabilistic graphical models.


# # Dynamic Programming in Hidden Markov Models

This subsection serves to illustrate the dynamic programming problem. The specific technical details do not matter for understanding the deep learning models
but they help in motivating why one might use deep learning and why one might pick specific architectures.

If we want to solve the problem using probabilistic graphical models we could for instance design a latent variable model as follows.
At any time step $t$,
we assume that there exists some latent variable $h*t$ that governs our observed emission $x*t$ via $P(x*t \mid h*t)$.
Moreover, any transition $h*t \to h*{t+1}$ is given by some state transition probability $P(h*{t+1} \mid h*{t})$. This probabilistic graphical model is then a *hidden Markov model*  as in :numref:`fig_hmm`.

![A hidden Markov model.](../img/hmm.svg)
:label:`fig_hmm`

Thus,
for a sequence of $T$ observations we have the following joint probability distribution over the observed and hidden states:

$$P(x*1, \ldots, x*T, h*1, \ldots, h*T) = \prod*{t=1}^T P(h*t \mid h*{t-1}) P(x*t \mid h*t), \text{ where } P(h*1 \mid h*0) = P(h*1).$$
:eqlabel:`eq*hmm*jointP`


Now assume that we observe all $x*i$ with the exception of some $x*j$ and it is our goal to compute $P(x*j \mid x*{-j})$, where $x*{-j} = (x*1, \ldots, x*{j-1}, x*{j+1}, \ldots, x_{T})$.
Since there is no latent variable
in $P(x*j \mid x*{-j})$,
we consider summing over
all the possible combinations of choices for $h*1, \ldots, h*T$.
In case any $h_i$ can take on $k$ distinct values (a finite number of states), this means that we need to sum over $k^T$ terms---usually mission impossible! Fortunately there is an elegant solution for this: *dynamic programming*.

To see how it works,
consider summing over latent variables
$h*1, \ldots, h*T$ in turn.
According to :eqref:`eq*hmm*jointP`,
this yields:

$$\begin{aligned}
    &P(x*1, \ldots, x*T) \\
    =& \sum*{h*1, \ldots, h*T} P(x*1, \ldots, x*T, h*1, \ldots, h_T) \\
    =& \sum*{h*1, \ldots, h*T} \prod*{t=1}^T P(h*t \mid h*{t-1}) P(x*t \mid h*t) \\
    =& \sum*{h*2, \ldots, h*T} \underbrace{\left[\sum*{h*1} P(h*1) P(x*1 \mid h*1) P(h*2 \mid h*1)\right]}*{\pi*2(h_2) \stackrel{\mathrm{def}}{=}}
    P(x*2 \mid h*2) \prod*{t=3}^T P(h*t \mid h*{t-1}) P(x*t \mid h_t) \\
    =& \sum*{h*3, \ldots, h*T} \underbrace{\left[\sum*{h*2} \pi*2(h*2) P(x*2 \mid h*2) P(h*3 \mid h*2)\right]}*{\pi*3(h*3)\stackrel{\mathrm{def}}{=}}
    P(x*3 \mid h*3) \prod*{t=4}^T P(h*t \mid h*{t-1}) P(x*t \mid h_t)\\
    =& \dots \\
    =& \sum*{h*T} \pi*T(h*T) P(x*T \mid h*T).
\end{aligned}$$

In general we have the *forward recursion* as

$$\pi*{t+1}(h*{t+1}) = \sum*{h*t} \pi*t(h*t) P(x*t \mid h*t) P(h*{t+1} \mid h*t).$$

The recursion is initialized as $\pi*1(h*1) = P(h*1)$. In abstract terms this can be written as $\pi*{t+1} = f(\pi*t, x*t)$, where $f$ is some learnable function. This looks very much like the update equation in the latent variable models we discussed so far in the context of RNNs! 

Entirely analogously to the forward recursion,
we can also 
sum over the same set of latent variables with a backward recursion. This yields:

$$\begin{aligned}
    & P(x*1, \ldots, x*T) \\
     =& \sum*{h*1, \ldots, h*T} P(x*1, \ldots, x*T, h*1, \ldots, h_T) \\
    =& \sum*{h*1, \ldots, h*T} \prod*{t=1}^{T-1} P(h*t \mid h*{t-1}) P(x*t \mid h*t) \cdot P(h*T \mid h*{T-1}) P(x*T \mid h*T) \\
    =& \sum*{h*1, \ldots, h*{T-1}} \prod*{t=1}^{T-1} P(h*t \mid h*{t-1}) P(x*t \mid h*t) \cdot
    \underbrace{\left[\sum*{h*T} P(h*T \mid h*{T-1}) P(x*T \mid h*T)\right]}*{\rho*{T-1}(h_{T-1})\stackrel{\mathrm{def}}{=}} \\
    =& \sum*{h*1, \ldots, h*{T-2}} \prod*{t=1}^{T-2} P(h*t \mid h*{t-1}) P(x*t \mid h*t) \cdot
    \underbrace{\left[\sum*{h*{T-1}} P(h*{T-1} \mid h*{T-2}) P(x*{T-1} \mid h*{T-1}) \rho*{T-1}(h*{T-1}) \right]}*{\rho*{T-2}(h_{T-2})\stackrel{\mathrm{def}}{=}} \\
    =& \ldots \\
    =& \sum*{h*1} P(h*1) P(x*1 \mid h*1)\rho*{1}(h_{1}).
\end{aligned}$$


We can thus write the *backward recursion* as

$$\rho*{t-1}(h*{t-1})= \sum*{h*{t}} P(h*{t} \mid h*{t-1}) P(x*{t} \mid h*{t}) \rho*{t}(h*{t}),$$

with initialization $\rho*T(h*T) = 1$. 
Both the forward and backward recursions allow us to sum over $T$ latent variables in $\mathcal{O}(kT)$ (linear) time over all values of $(h*1, \ldots, h*T)$ rather than in exponential time.
This is one of the great benefits of the probabilistic inference with graphical models.
It is 
also a very special instance of 
a general message passing algorithm :cite:`Aji.McEliece.2000`.
Combining both forward and backward recursions, we are able to compute

$$P(x*j \mid x*{-j}) \propto \sum*{h*j} \pi*j(h*j) \rho*j(h*j) P(x*j \mid h*j).$$

Note that in abstract terms the backward recursion can be written as $\rho*{t-1} = g(\rho*t, x_t)$, where $g$ is a learnable function. Again, this looks very much like an update equation, just running backwards unlike what we have seen so far in RNNs. Indeed, hidden Markov models benefit from knowing future data when it is available. Signal processing scientists distinguish between the two cases of knowing and not knowing future observations as interpolation v.s. extrapolation.
See the introductory chapter of the book on sequential Monte Carlo algorithms for more details :cite:`Doucet.De-Freitas.Gordon.2001`.


# # Bidirectional Model

If we want to have a mechanism in RNNs that offers comparable look-ahead ability as in hidden Markov models, we need to modify the RNN design that we have seen so far. Fortunately, this is easy conceptually. Instead of running an RNN only in the forward mode starting from the first token, we start another one from the last token running from back to front. 
*Bidirectional RNNs* add a hidden layer that passes information in a backward direction to more flexibly process such information. :numref:`fig_birnn` illustrates the architecture of a bidirectional RNN with a single hidden layer.

![Architecture of a bidirectional RNN.](../img/birnn.svg)
:label:`fig_birnn`

In fact, this is not too dissimilar to the forward and backward recursions in the dynamic programing of hidden Markov models. 
The main distinction is that in the previous case these equations had a specific statistical meaning.
Now they are devoid of such easily accessible interpretations and we can just treat them as 
generic and learnable functions.
This transition epitomizes many of the principles guiding the design of modern deep networks: first, use the type of functional dependencies of classical statistical models, and then parameterize them in a generic form.


## # Definition

Bidirectional RNNs were introduced by :cite:`Schuster.Paliwal.1997`. 
For a detailed discussion of the various architectures see also the paper :cite:`Graves.Schmidhuber.2005`.
Let us look at the specifics of such a network.


For any time step $t$, 
given a minibatch input $\mathbf{X}*t \in \mathbb{R}^{n \times d}$ (number of examples: $n$, number of inputs in each example: $d$) and let the hidden layer activation function be $\phi$. In the bidirectional architecture, we assume that the forward and backward hidden states for this time step are $\overrightarrow{\mathbf{H}}*t  \in \mathbb{R}^{n \times h}$ and $\overleftarrow{\mathbf{H}}_t  \in \mathbb{R}^{n \times h}$, respectively,
where $h$ is the number of hidden units.
The forward and backward hidden state updates are as follows:


$$
\begin{aligned}
\overrightarrow{\mathbf{H}}*t &= \phi(\mathbf{X}*t \mathbf{W}*{xh}^{(f)} + \overrightarrow{\mathbf{H}}*{t-1} \mathbf{W}*{hh}^{(f)}  + \mathbf{b}*h^{(f)}),\\
\overleftarrow{\mathbf{H}}*t &= \phi(\mathbf{X}*t \mathbf{W}*{xh}^{(b)} + \overleftarrow{\mathbf{H}}*{t+1} \mathbf{W}*{hh}^{(b)}  + \mathbf{b}*h^{(b)}),
\end{aligned}
$$

where the weights $\mathbf{W}*{xh}^{(f)} \in \mathbb{R}^{d \times h}, \mathbf{W}*{hh}^{(f)} \in \mathbb{R}^{h \times h}, \mathbf{W}*{xh}^{(b)} \in \mathbb{R}^{d \times h}, \text{ and } \mathbf{W}*{hh}^{(b)} \in \mathbb{R}^{h \times h}$, and biases $\mathbf{b}*h^{(f)} \in \mathbb{R}^{1 \times h} \text{ and } \mathbf{b}*h^{(b)} \in \mathbb{R}^{1 \times h}$ are all the model parameters.

Next, we concatenate the forward and backward hidden states $\overrightarrow{\mathbf{H}}*t$ and $\overleftarrow{\mathbf{H}}*t$
to obtain the hidden state $\mathbf{H}_t \in \mathbb{R}^{n \times 2h}$ to be fed into the output layer.
In deep bidirectional RNNs with multiple hidden layers,
such information
is passed on as *input* to the next bidirectional layer. Last, the output layer computes the output $\mathbf{O}_t \in \mathbb{R}^{n \times q}$ (number of outputs: $q$):

$$\mathbf{O}*t = \mathbf{H}*t \mathbf{W}*{hq} + \mathbf{b}*q.$$

Here, the weight matrix $\mathbf{W}*{hq} \in \mathbb{R}^{2h \times q}$ and the bias $\mathbf{b}*q \in \mathbb{R}^{1 \times q}$ are the model parameters of the output layer. In fact, the two directions can have different numbers of hidden units.

## # Computational Cost and Applications

One of the key features of a bidirectional RNN is that information from both ends of the sequence is used to estimate the output. That is, we use information from both future and past observations to predict the current one. 
In the case of next token prediction this is not quite what we want.
After all, we do not have the luxury of knowing the next to next token when predicting the next one. Hence, if we were to use a bidirectional RNN naively we would not get a very good accuracy: during training we have past and future data to estimate the present. During test time we only have past data and thus poor accuracy. We will illustrate this in an experiment below.

To add insult to injury, bidirectional RNNs are also exceedingly slow.
The main reasons for this are that 
the forward propagation
requires both forward and backward recursions
in bidirectional layers
and that the backpropagation is dependent on the outcomes of the forward propagation. Hence, gradients will have a very long dependency chain.

In practice bidirectional layers are used very sparingly and only for a narrow set of applications, such as filling in missing words, annotating tokens (e.g., for named entity recognition), and encoding sequences wholesale as a step in a sequence processing pipeline (e.g., for machine translation).
In :numref:`sec*bert` and :numref:`sec*sentiment_rnn`,
we will introduce how to use bidirectional RNNs
to encode text sequences.



# # Training a Bidirectional RNN for a Wrong Application

If we were to ignore all advice regarding the fact that bidirectional RNNs use past and future data and simply apply it to language models, 
we will get estimates with acceptable perplexity. Nonetheless, the ability of the model to predict future tokens is severely compromised as the experiment below illustrates. 
Despite reasonable perplexity, it only generates gibberish even after many iterations.
We include the code below as a cautionary example against using them in the wrong context.

```{.python .input}
from d2l import mxnet as d2l
from mxnet import npx
from mxnet.gluon import rnn
npx.set_np()

# Load data
batch*size, num*steps, device = 32, 35, d2l.try_gpu()
train*iter, vocab = d2l.load*data*time*machine(batch*size, num*steps)
# Define the bidirectional LSTM model by setting `bidirectional=True`
vocab*size, num*hiddens, num_layers = len(vocab), 256, 2
lstm*layer = rnn.LSTM(num*hiddens, num_layers, bidirectional=True)
model = d2l.RNNModel(lstm_layer, len(vocab))
# Train the model
num_epochs, lr = 500, 1
d2l.train*ch8(model, train*iter, vocab, lr, num_epochs, device)
```

```{.python .input}
# @tab pytorch
from d2l import torch as d2l
import torch
from torch import nn

# Load data
batch*size, num*steps, device = 32, 35, d2l.try_gpu()
train*iter, vocab = d2l.load*data*time*machine(batch*size, num*steps)
# Define the bidirectional LSTM model by setting `bidirectional=True`
vocab*size, num*hiddens, num_layers = len(vocab), 256, 2
num*inputs = vocab*size
lstm*layer = nn.LSTM(num*inputs, num*hiddens, num*layers, bidirectional=True)
model = d2l.RNNModel(lstm_layer, len(vocab))
model = model.to(device)
# Train the model
num_epochs, lr = 500, 1
d2l.train*ch8(model, train*iter, vocab, lr, num_epochs, device)
```

The output is clearly unsatisfactory for the reasons described above. 
For a
discussion of more effective uses of bidirectional RNNs, please see the sentiment
analysis application 
in :numref:`sec*sentiment*rnn`.

# # Summary

* In bidirectional RNNs, the hidden state for each time step is simultaneously determined by the data prior to and after the current time step.
* Bidirectional RNNs bear a striking resemblance with the forward-backward algorithm in probabilistic graphical models.
* Bidirectional RNNs are mostly useful for sequence encoding and the estimation of observations given bidirectional context.
* Bidirectional RNNs are very costly to train due to long gradient chains.

# # Exercises

1. If the different directions use a different number of hidden units, how will the shape of $\mathbf{H}_t$ change?
1. Design a bidirectional RNN with multiple hidden layers.
1. Polysemy is common in natural languages. For example, the word "bank" has different meanings in contexts “i went to the bank to deposit cash” and “i went to the bank to sit down”. How can we design a neural network model such that given a context sequence and a word, a vector representation of the word in the context will be returned? What type of neural architectures is preferred for handling polysemy?


:begin_tab:`mxnet`
[Discussions](https://discuss.d2l.ai/t/339)
:end_tab:

:begin_tab:`pytorch`
[Discussions](https://discuss.d2l.ai/t/1059)
:end_tab:
