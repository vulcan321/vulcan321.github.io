# Backpropagation Through Time
:label:`sec_bptt`

So far we have repeatedly alluded to things like
*exploding gradients*,
*vanishing gradients*,
and the need to
*detach the gradient* for RNNs.
For instance, in :numref:`sec*rnn*scratch`
we invoked the `detach` function on the sequence.
None of this was really fully
explained, in the interest of being able to build a model quickly and
to see how it works.
In this section,
we will delve a bit more deeply
into the details of backpropagation for sequence models and why (and how) the mathematics works.

We encountered some of the effects of gradient explosion when we first
implemented RNNs (:numref:`sec*rnn*scratch`).
In
particular,
if you solved the exercises,
you would
have seen that gradient clipping is vital to ensure proper
convergence.
To provide a better understanding of this issue, this
section will review how gradients are computed for sequence models.
Note
that there is nothing conceptually new in how it works. After all, we are still merely applying the chain rule to compute gradients. Nonetheless, it is
worth while reviewing backpropagation (:numref:`sec_backprop`) again.


We have described forward and backward propagations
and computational graphs
in MLPs in :numref:`sec_backprop`.
Forward propagation in an RNN is relatively
straightforward.
*Backpropagation through time* is actually a specific
application of backpropagation
in RNNs :cite:`Werbos.1990`.
It
requires us to expand the 
computational graph of an RNN
one time step at a time to
obtain the dependencies
among model variables and parameters.
Then,
based on the chain rule,
we apply backpropagation to compute and
store gradients.
Since sequences can be rather long, the dependency can be rather lengthy.
For instance, for a sequence of 1000 characters, 
the first token could potentially have significant influence on the token at the final position.
This is not really computationally feasible
(it takes too long and requires too much memory) and it requires over 1000 matrix products before we would arrive at that very elusive gradient.
This is a process fraught with computational and statistical uncertainty.
In the following we will elucidate what happens
and how to address this in practice.

# # Analysis of Gradients in RNNs
:label:`subsec*bptt*analysis`

We start with a simplified model of how an RNN works.
This model ignores details about the specifics of the hidden state and how it is updated.
The mathematical notation here
does not explicitly distinguish
scalars, vectors, and matrices as it used to do.
These details are immaterial to the analysis
and would only serve to clutter the notation
in this subsection.

In this simplified model,
we denote $h_t$ as the hidden state,
$x*t$ as the input, and $o*t$ as the output
at time step $t$.
Recall our discussions in
:numref:`subsec*rnn*w*hidden*states`
that the input and the hidden state
can be concatenated to
be multiplied by one weight variable in the hidden layer.
Thus, we use $w*h$ and $w*o$ to
indicate the weights of the hidden layer and the output layer, respectively.
As a result, the hidden states and outputs at each time steps can be explained as

$$\begin{aligned}h*t &= f(x*t, h*{t-1}, w*h),\\o*t &= g(h*t, w_o),\end{aligned}$$
:eqlabel:`eq*bptt*ht_ot`

where $f$ and $g$ are transformations
of the hidden layer and the output layer, respectively.
Hence, we have a chain of values $\{\ldots, (x*{t-1}, h*{t-1}, o*{t-1}), (x*{t}, h*{t}, o*t), \ldots\}$ that depend on each other via recurrent computation.
The forward propagation is fairly straightforward.
All we need is to loop through the $(x*t, h*t, o_t)$ triples one time step at a time.
The discrepancy between output $o*t$ and the desired label $y*t$ is then evaluated by an objective function
across all the $T$ time steps
as

$$L(x*1, \ldots, x*T, y*1, \ldots, y*T, w*h, w*o) = \frac{1}{T}\sum*{t=1}^T l(y*t, o_t).$$



For backpropagation, matters are a bit trickier, especially when we compute the gradients with regard to the parameters $w_h$ of the objective function $L$. To be specific, by the chain rule,

$$\begin{aligned}\frac{\partial L}{\partial w*h}  & = \frac{1}{T}\sum*{t=1}^T \frac{\partial l(y*t, o*t)}{\partial w*h}  \\& = \frac{1}{T}\sum*{t=1}^T \frac{\partial l(y*t, o*t)}{\partial o*t} \frac{\partial g(h*t, w*h)}{\partial h*t}  \frac{\partial h*t}{\partial w*h}.\end{aligned}$$
:eqlabel:`eq*bptt*partial*L*wh`

The first and the second factors of the
product in :eqref:`eq*bptt*partial*L*wh`
are easy to compute.
The third factor $\partial h*t/\partial w*h$ is where things get tricky, since we need to recurrently compute the effect of the parameter $w*h$ on $h*t$.
According to the recurrent computation
in :eqref:`eq*bptt*ht_ot`,
$h*t$ depends on both $h*{t-1}$ and $w_h$,
where computation of $h_{t-1}$
also depends on $w_h$.
Thus,
using the chain rule yields

$$\frac{\partial h*t}{\partial w*h}= \frac{\partial f(x*{t},h*{t-1},w*h)}{\partial w*h} +\frac{\partial f(x*{t},h*{t-1},w*h)}{\partial h*{t-1}} \frac{\partial h*{t-1}}{\partial w*h}.$$
:eqlabel:`eq*bptt*partial*ht*wh_recur`


To derive the above gradient, assume that we have three sequences $\{a*{t}\},\{b*{t}\},\{c_{t}\}$ satisfying
$a*{0}=0$ and $a*{t}=b*{t}+c*{t}a_{t-1}$ for $t=1, 2,\ldots$.
Then for $t\geq 1$, it is easy to show

$$a*{t}=b*{t}+\sum*{i=1}^{t-1}\left(\prod*{j=i+1}^{t}c*{j}\right)b*{i}.$$
:eqlabel:`eq*bptt*at`

By substituting $a*t$, $b*t$, and $c_t$
according to

$$\begin{aligned}a*t &= \frac{\partial h*t}{\partial w_h},\\
b*t &= \frac{\partial f(x*{t},h*{t-1},w*h)}{\partial w_h}, \\
c*t &= \frac{\partial f(x*{t},h*{t-1},w*h)}{\partial h_{t-1}},\end{aligned}$$

the gradient computation in :eqref:`eq*bptt*partial*ht*wh_recur` satisfies
$a*{t}=b*{t}+c*{t}a*{t-1}$.
Thus,
per :eqref:`eq*bptt*at`,
we can remove the recurrent computation in :eqref:`eq*bptt*partial*ht*wh_recur`
with

$$\frac{\partial h*t}{\partial w*h}=\frac{\partial f(x*{t},h*{t-1},w*h)}{\partial w*h}+\sum*{i=1}^{t-1}\left(\prod*{j=i+1}^{t} \frac{\partial f(x*{j},h*{j-1},w*h)}{\partial h*{j-1}} \right) \frac{\partial f(x*{i},h*{i-1},w*h)}{\partial w*h}.$$
:eqlabel:`eq*bptt*partial*ht*wh_gen`

While we can use the chain rule to compute $\partial h*t/\partial w*h$ recursively, this chain can get very long whenever $t$ is large. Let us discuss a number of strategies for dealing with this problem.

## # Full Computation ## # 

Obviously,
we can just compute the full sum in
:eqref:`eq*bptt*partial*ht*wh_gen`.
However,
this is very slow and gradients can blow up,
since subtle changes in the initial conditions can potentially affect the outcome a lot.
That is, we could see things similar to the butterfly effect where minimal changes in the initial conditions lead to disproportionate changes in the outcome.
This is actually quite undesirable in terms of the model that we want to estimate.
After all, we are looking for robust estimators that generalize well. Hence this strategy is almost never used in practice.

## # Truncating Time Steps## #

Alternatively,
we can truncate the sum in
:eqref:`eq*bptt*partial*ht*wh_gen`
after $\tau$ steps. 
This is what we have been discussing so far,
such as when we detached the gradients in :numref:`sec*rnn*scratch`. 
This leads to an *approximation* of the true gradient, simply by terminating the sum at 
$\partial h*{t-\tau}/\partial w*h$. 
In practice this works quite well. It is what is commonly referred to as truncated backpropgation through time :cite:`Jaeger.2002`.
One of the consequences of this is that the model focuses primarily on short-term influence rather than long-term consequences. This is actually *desirable*, since it biases the estimate towards simpler and more stable models.

## # Randomized Truncation ## # 

Last, we can replace $\partial h*t/\partial w*h$
by a random variable which is correct in expectation but  truncates the sequence.
This is achieved by using a sequence of $\xi_t$
with predefined $0 \leq \pi_t \leq 1$,
where $P(\xi*t = 0) = 1-\pi*t$ and  $P(\xi*t = \pi*t^{-1}) = \pi*t$, thus $E[\xi*t] = 1$.
We use this to replace the gradient
$\partial h*t/\partial w*h$
in :eqref:`eq*bptt*partial*ht*wh_recur`
with

$$z*t= \frac{\partial f(x*{t},h*{t-1},w*h)}{\partial w*h} +\xi*t \frac{\partial f(x*{t},h*{t-1},w*h)}{\partial h*{t-1}} \frac{\partial h*{t-1}}{\partial w*h}.$$


It follows from the definition of $\xi*t$ that $E[z*t] = \partial h*t/\partial w*h$.
Whenever $\xi_t = 0$ the recurrent computation
terminates at that time step $t$.
This leads to a weighted sum of sequences of varying lengths where long sequences are rare but appropriately overweighted. 
This idea was proposed by Tallec and Ollivier
:cite:`Tallec.Ollivier.2017`.

## # Comparing Strategies

![Comparing strategies for computing gradients in RNNs. From top to bottom: randomized truncation, regular truncation, and full computation.](../img/truncated-bptt.svg)
:label:`fig*truncated*bptt`


:numref:`fig*truncated*bptt` illustrates the three strategies when analyzing the first few characters of *The Time Machine* book using backpropagation through time for RNNs:

* The first row is the randomized truncation that partitions the text into segments of varying lengths.
* The second row is the regular truncation that breaks the text into subsequences of the same length. This is what we have been doing in RNN experiments.
* The third row is the full backpropagation through time that leads to a computationally infeasible expression.


Unfortunately, while appealing in theory, randomized truncation does not work much better than regular truncation, most likely due to a number of factors.
First, the effect of an observation after a number of backpropagation steps into the past is quite sufficient to capture dependencies in practice. 
Second, the increased variance counteracts the fact that the gradient is more accurate with more steps. 
Third, we actually *want* models that have only a short range of interactions. Hence, regularly truncated backpropagation through time has a slight regularizing effect that can be desirable.

# # Backpropagation Through Time in Detail

After discussing the general principle,
let us discuss backpropagation through time in detail.
Different from the analysis in
:numref:`subsec*bptt*analysis`,
in the following
we will show
how to compute
the gradients of the objective function
with respect to all the decomposed model parameters.
To keep things simple, we consider 
an RNN without bias parameters,
whose 
activation function
in the hidden layer
uses the identity mapping ($\phi(x)=x$).
For time step $t$,
let the single example input and the label be
$\mathbf{x}*t \in \mathbb{R}^d$ and $y*t$, respectively. 
The hidden state $\mathbf{h}_t \in \mathbb{R}^h$ 
and the output $\mathbf{o}_t \in \mathbb{R}^q$
are computed as

$$\begin{aligned}\mathbf{h}*t &= \mathbf{W}*{hx} \mathbf{x}*t + \mathbf{W}*{hh} \mathbf{h}_{t-1},\\
\mathbf{o}*t &= \mathbf{W}*{qh} \mathbf{h}_{t},\end{aligned}$$

where $\mathbf{W}*{hx} \in \mathbb{R}^{h \times d}$, $\mathbf{W}*{hh} \in \mathbb{R}^{h \times h}$, and
$\mathbf{W}_{qh} \in \mathbb{R}^{q \times h}$
are the weight parameters.
Denote by $l(\mathbf{o}*t, y*t)$
the loss at time step $t$. 
Our objective function,
the loss over $T$ time steps
from the beginning of the sequence
is thus

$$L = \frac{1}{T} \sum*{t=1}^T l(\mathbf{o}*t, y_t).$$


In order to visualize the dependencies among
model variables and parameters during computation
of the RNN,
we can draw a computational graph for the model,
as shown in :numref:`fig*rnn*bptt`.
For example, the computation of the hidden states of time step 3, $\mathbf{h}*3$, depends on the model parameters $\mathbf{W}*{hx}$ and $\mathbf{W}_{hh}$,
the hidden state of the last time step $\mathbf{h}_2$,
and the input of the current time step $\mathbf{x}_3$.

![Computational graph showing dependencies for an RNN model with three time steps. Boxes represent variables (not shaded) or parameters (shaded) and circles represent operators.](../img/rnn-bptt.svg)
:label:`fig*rnn*bptt`

As just mentioned, the model parameters in :numref:`fig*rnn*bptt` are $\mathbf{W}*{hx}$, $\mathbf{W}*{hh}$, and $\mathbf{W}_{qh}$. 
Generally,
training this model
requires 
gradient computation with respect to these parameters
$\partial L/\partial \mathbf{W}*{hx}$, $\partial L/\partial \mathbf{W}*{hh}$, and $\partial L/\partial \mathbf{W}_{qh}$.
According to the dependencies in :numref:`fig*rnn*bptt`,
we can traverse 
in the opposite direction of the arrows
to calculate and store the gradients in turn.
To flexibly express the multiplication
of matrices, vectors, and scalars of different shapes
in the chain rule,
we continue to use 
the 
$\text{prod}$ operator as described in
:numref:`sec_backprop`.


First of all,
differentiating the objective function
with respect to the model output
at any time step $t$
is fairly straightforward:

$$\frac{\partial L}{\partial \mathbf{o}*t} =  \frac{\partial l (\mathbf{o}*t, y*t)}{T \cdot \partial \mathbf{o}*t} \in \mathbb{R}^q.$$
:eqlabel:`eq*bptt*partial*L*ot`

Now, we can calculate the gradient of the objective function
with respect to
the parameter $\mathbf{W}_{qh}$
in the output layer:
$\partial L/\partial \mathbf{W}*{qh} \in \mathbb{R}^{q \times h}$. Based on :numref:`fig*rnn_bptt`, 
the objective function
$L$ depends on $\mathbf{W}*{qh}$ via $\mathbf{o}*1, \ldots, \mathbf{o}_T$. Using the chain rule yields

$$
\frac{\partial L}{\partial \mathbf{W}_{qh}}
= \sum*{t=1}^T \text{prod}\left(\frac{\partial L}{\partial \mathbf{o}*t}, \frac{\partial \mathbf{o}*t}{\partial \mathbf{W}*{qh}}\right)
= \sum*{t=1}^T \frac{\partial L}{\partial \mathbf{o}*t} \mathbf{h}_t^\top,
$$

where $\partial L/\partial \mathbf{o}_t$
is given by :eqref:`eq*bptt*partial*L*ot`.

Next, as shown in :numref:`fig*rnn*bptt`,
at the final time step $T$
the objective function
$L$ depends on the hidden state $\mathbf{h}*T$ only via $\mathbf{o}*T$.
Therefore, we can easily find
the gradient 
$\partial L/\partial \mathbf{h}_T \in \mathbb{R}^h$
using the chain rule:

$$\frac{\partial L}{\partial \mathbf{h}*T} = \text{prod}\left(\frac{\partial L}{\partial \mathbf{o}*T}, \frac{\partial \mathbf{o}*T}{\partial \mathbf{h}*T} \right) = \mathbf{W}*{qh}^\top \frac{\partial L}{\partial \mathbf{o}*T}.$$
:eqlabel:`eq*bptt*partial*L*hT*final*step`

It gets trickier for any time step $t < T$,
where the objective function $L$ depends on $\mathbf{h}*t$ via $\mathbf{h}*{t+1}$ and $\mathbf{o}_t$.
According to the chain rule,
the gradient of the hidden state
$\partial L/\partial \mathbf{h}_t \in \mathbb{R}^h$
at any time step $t < T$ can be recurrently computed as:


$$\frac{\partial L}{\partial \mathbf{h}*t} = \text{prod}\left(\frac{\partial L}{\partial \mathbf{h}*{t+1}}, \frac{\partial \mathbf{h}*{t+1}}{\partial \mathbf{h}*t} \right) + \text{prod}\left(\frac{\partial L}{\partial \mathbf{o}*t}, \frac{\partial \mathbf{o}*t}{\partial \mathbf{h}*t} \right) = \mathbf{W}*{hh}^\top \frac{\partial L}{\partial \mathbf{h}*{t+1}} + \mathbf{W}*{qh}^\top \frac{\partial L}{\partial \mathbf{o}_t}.$$
:eqlabel:`eq*bptt*partial*L*ht_recur`

For analysis,
expanding the recurrent computation
for any time step $1 \leq t \leq T$
gives

$$\frac{\partial L}{\partial \mathbf{h}*t}= \sum*{i=t}^T {\left(\mathbf{W}*{hh}^\top\right)}^{T-i} \mathbf{W}*{qh}^\top \frac{\partial L}{\partial \mathbf{o}_{T+t-i}}.$$
:eqlabel:`eq*bptt*partial*L*ht`

We can see from :eqref:`eq*bptt*partial*L*ht` that
this simple linear example already
exhibits some key problems of long sequence models: it involves potentially very large powers of $\mathbf{W}_{hh}^\top$.
In it, eigenvalues smaller than 1 vanish
and eigenvalues larger than 1 diverge.
This is numerically unstable,
which manifests itself in the form of vanishing 
and exploding gradients.
One way to address this is to truncate the time steps
at a computationally convenient size as discussed in :numref:`subsec*bptt*analysis`. 
In practice, this truncation is effected by detaching the gradient after a given number of time steps.
Later on 
we will see how more sophisticated sequence models such as long short-term memory can alleviate this further. 

Finally,
:numref:`fig*rnn*bptt` shows that
the objective function
$L$ depends on model parameters
$\mathbf{W}*{hx}$ and $\mathbf{W}*{hh}$
in the hidden layer
via hidden states
$\mathbf{h}*1, \ldots, \mathbf{h}*T$.
To compute gradients
with respect to such parameters
$\partial L / \partial \mathbf{W}*{hx} \in \mathbb{R}^{h \times d}$ and $\partial L / \partial \mathbf{W}*{hh} \in \mathbb{R}^{h \times h}$,
we apply the chain rule that gives

$$
\begin{aligned}
\frac{\partial L}{\partial \mathbf{W}_{hx}}
&= \sum*{t=1}^T \text{prod}\left(\frac{\partial L}{\partial \mathbf{h}*t}, \frac{\partial \mathbf{h}*t}{\partial \mathbf{W}*{hx}}\right)
= \sum*{t=1}^T \frac{\partial L}{\partial \mathbf{h}*t} \mathbf{x}_t^\top,\\
\frac{\partial L}{\partial \mathbf{W}_{hh}}
&= \sum*{t=1}^T \text{prod}\left(\frac{\partial L}{\partial \mathbf{h}*t}, \frac{\partial \mathbf{h}*t}{\partial \mathbf{W}*{hh}}\right)
= \sum*{t=1}^T \frac{\partial L}{\partial \mathbf{h}*t} \mathbf{h}_{t-1}^\top,
\end{aligned}
$$

where
$\partial L/\partial \mathbf{h}_t$
that is recurrently computed by
:eqref:`eq*bptt*partial*L*hT*final*step`
and
:eqref:`eq*bptt*partial*L*ht_recur`
is the key quantity
that affects the numerical stability.



Since backpropagation through time
is the application of backpropagation in RNNs,
as we have explained in :numref:`sec_backprop`,
training RNNs
alternates forward propagation with
backpropagation through time.
Besides,
backpropagation through time
computes and stores the above gradients
in turn.
Specifically,
stored intermediate values
are reused
to avoid duplicate calculations,
such as storing 
$\partial L/\partial \mathbf{h}_t$
to be used in computation of both $\partial L / \partial \mathbf{W}*{hx}$ and $\partial L / \partial \mathbf{W}*{hh}$.


# # Summary

* Backpropagation through time is merely an application of backpropagation to sequence models with a hidden state.
* Truncation is needed for computational convenience and numerical stability, such as regular truncation and randomized truncation.
* High powers of matrices can lead to divergent or vanishing eigenvalues. This manifests itself in the form of exploding or vanishing gradients.
* For efficient computation, intermediate values are cached during backpropagation through time.



# # Exercises

1. Assume that we have a symmetric matrix $\mathbf{M} \in \mathbb{R}^{n \times n}$ with eigenvalues $\lambda*i$ whose corresponding eigenvectors are $\mathbf{v}*i$ ($i = 1, \ldots, n$). Without loss of generality, assume that they are ordered in the order $|\lambda*i| \geq |\lambda*{i+1}|$. 
   1. Show that $\mathbf{M}^k$ has eigenvalues $\lambda_i^k$.
   1. Prove that for a random vector $\mathbf{x} \in \mathbb{R}^n$, with high probability $\mathbf{M}^k \mathbf{x}$ will be very much aligned with the eigenvector $\mathbf{v}_1$ 
of $\mathbf{M}$. Formalize this statement.
   1. What does the above result mean for gradients in RNNs?
1. Besides gradient clipping, can you think of any other methods to cope with gradient explosion in recurrent neural networks?

[Discussions](https://discuss.d2l.ai/t/334)
