# Word Embedding with Global Vectors (GloVe)
:label:`sec_glove`


Word-word co-occurrences 
within context windows
may carry rich semantic information.
For example,
in a large corpus
word "solid" is
more likely to co-occur
with "ice" than "steam",
but word "gas"
probably co-occurs with "steam"
more frequently than "ice".
Besides,
global corpus statistics
of such co-occurrences
can be precomputed:
this can lead to more efficient training.
To leverage statistical
information in the entire corpus
for word embedding,
let us first revisit
the skip-gram model in :numref:`subsec_skip-gram`,
but interpreting it
using global corpus statistics
such as co-occurrence counts.

# # Skip-Gram with Global Corpus Statistics
:label:`subsec_skipgram-global`

Denoting by $q_{ij}$
the conditional probability
$P(w*j\mid w*i)$
of word $w*j$ given word $w*i$
in the skip-gram model,
we have

$$q*{ij}=\frac{\exp(\mathbf{u}*j^\top \mathbf{v}*i)}{ \sum*{k \in \mathcal{V}} \text{exp}(\mathbf{u}*k^\top \mathbf{v}*i)},$$

where 
for any index $i$
vectors $\mathbf{v}*i$ and $\mathbf{u}*i$
represent word $w_i$
as the center word and context word,
respectively, and $\mathcal{V} = \{0, 1, \ldots, |\mathcal{V}|-1\}$ 
is the index set of the vocabulary.

Consider word $w_i$
that may occur multiple times
in the corpus.
In the entire corpus,
all the context words
wherever $w_i$ is taken as their center word
form a *multiset* $\mathcal{C}_i$
of word indices
that *allows for multiple instances of the same element*.
For any element,
its number of instances is called its *multiplicity*.
To illustrate with an example,
suppose that word $w_i$ occurs twice in the corpus
and indices of the context words
that take $w_i$ as their center word
in the two context windows
are 
$k, j, m, k$ and $k, l, k, j$.
Thus, multiset $\mathcal{C}_i = \{j, j, k, k, k, k, l, m\}$, where 
multiplicities of elements $j, k, l, m$
are 2, 4, 1, 1, respectively.

Now let us denote the multiplicity of element $j$ in
multiset $\mathcal{C}*i$ as $x*{ij}$.
This is the global co-occurrence count 
of word $w_j$ (as the context word)
and word $w_i$ (as the center word)
in the same context window
in the entire corpus.
Using such global corpus statistics,
the loss function of the skip-gram model 
is equivalent to

$$-\sum*{i\in\mathcal{V}}\sum*{j\in\mathcal{V}} x*{ij} \log\,q*{ij}.$$
:eqlabel:`eq*skipgram-x*ij`

We further denote by
$x_i$
the number of all the context words
in the context windows
where $w_i$ occurs as their center word,
which is equivalent to $|\mathcal{C}_i|$.
Letting $p_{ij}$
be the conditional probability
$x*{ij}/x*i$ for generating
context word $w*j$ given center word $w*i$,
:eqref:`eq*skipgram-x*ij`
can be rewritten as

$$-\sum*{i\in\mathcal{V}} x*i \sum*{j\in\mathcal{V}} p*{ij} \log\,q_{ij}.$$
:eqlabel:`eq*skipgram-p*ij`

In :eqref:`eq*skipgram-p*ij`, $-\sum*{j\in\mathcal{V}} p*{ij} \log\,q_{ij}$ calculates
the cross-entropy 
of
the conditional distribution $p_{ij}$
of global corpus statistics
and
the
conditional distribution $q_{ij}$
of model predictions.
This loss
is also weighted by $x_i$ as explained above.
Minimizing the loss function in 
:eqref:`eq*skipgram-p*ij`
will allow
the predicted conditional distribution
to get close to
the conditional distribution
from the global corpus statistics.


Though being commonly used
for measuring the distance
between probability distributions,
the cross-entropy loss function may not be a good choice here. 
On one hand, as we mentioned in :numref:`sec*approx*train`, 
the cost of properly normalizing $q_{ij}$
results in the sum over the entire vocabulary,
which can be computationally expensive.
On the other hand, 
a large number of rare 
events from a large corpus
are often modeled by the cross-entropy loss
to be assigned with
too much weight.

# # The GloVe Model

In view of this,
the *GloVe* model makes three changes
to the skip-gram model based on squared loss :cite:`Pennington.Socher.Manning.2014`:

1. Use variables $p'*{ij}=x*{ij}$ and $q'*{ij}=\exp(\mathbf{u}*j^\top \mathbf{v}_i)$ 
that are not probability distributions
and take the logarithm of both, so the squared loss term is $\left(\log\,p'*{ij} - \log\,q'*{ij}\right)^2 = \left(\mathbf{u}*j^\top \mathbf{v}*i - \log\,x_{ij}\right)^2$.
2. Add two scalar model parameters for each word $w*i$: the center word bias $b*i$ and the context word bias $c_i$.
3. Replace the weight of each loss term with the weight function $h(x_{ij})$, where $h(x)$ is increasing in the interval of $[0, 1]$.

Putting all things together, training GloVe is to minimize the following loss function:

$$\sum*{i\in\mathcal{V}} \sum*{j\in\mathcal{V}} h(x*{ij}) \left(\mathbf{u}*j^\top \mathbf{v}*i + b*i + c*j - \log\,x*{ij}\right)^2.$$
:eqlabel:`eq_glove-loss`

For the weight function, a suggested choice is: 
$h(x) = (x/c) ^\alpha$ (e.g $\alpha = 0.75$) if $x < c$ (e.g., $c = 100$); otherwise $h(x) = 1$.
In this case,
because $h(0)=0$,
the squared loss term for any $x_{ij}=0$ can be omitted
for computational efficiency.
For example,
when using minibatch stochastic gradient descent for training, 
at each iteration
we randomly sample a minibatch of *non-zero* $x_{ij}$ 
to calculate gradients
and update the model parameters. 
Note that these non-zero $x_{ij}$ are precomputed 
global corpus statistics;
thus, the model is called GloVe
for *Global Vectors*.

It should be emphasized that
if word $w_i$ appears in the context window of 
word $w_j$, then *vice versa*. 
Therefore, $x*{ij}=x*{ji}$. 
Unlike word2vec
that fits the asymmetric conditional probability
$p_{ij}$,
GloVe fits the symmetric $\log \, x_{ij}$.
Therefore, the center word vector and
the context word vector of any word are mathematically equivalent in the GloVe model. 
However in practice, owing to different initialization values,
the same word may still get different values
in these two vectors after training:
GloVe sums them up as the output vector.



# # Interpreting GloVe from the Ratio of Co-occurrence Probabilities


We can also interpret the GloVe model from another perspective. 
Using the same notation in 
:numref:`subsec_skipgram-global`,
let $p*{ij} \stackrel{\mathrm{def}}{=} P(w*j \mid w*i)$ be the conditional probability of generating the context word $w*j$ given $w_i$ as the center word in the corpus. 
:numref:`tab_glove`
lists several co-occurrence probabilities
given words "ice" and "steam"
and their ratios based on  statistics from a large corpus.


:Word-word co-occurrence probabilities and their ratios from a large corpus (adapted from Table 1 in :cite:`Pennington.Socher.Manning.2014`:)


|$w_k$=|solid|gas|water|fashion|
|:--|:-|:-|:-|:-|
|$p*1=P(w*k\mid \text{ice})$|0.00019|0.000066|0.003|0.000017|
|$p*2=P(w*k\mid\text{steam})$|0.000022|0.00078|0.0022|0.000018|
|$p*1/p*2$|8.9|0.085|1.36|0.96|
:label:`tab_glove`


We can observe the following from :numref:`tab_glove`:

* For a word $w*k$ that is related to "ice" but unrelated to "steam", such as $w*k=\text{solid}$, we expect a larger ratio of co-occurence probabilities, such as 8.9.
* For a word $w*k$ that is related to "steam" but unrelated to "ice", such as $w*k=\text{gas}$, we expect a smaller ratio of co-occurence probabilities, such as 0.085.
* For a word $w*k$ that is related to both "ice" and "steam", such as $w*k=\text{water}$, we expect a ratio of co-occurence probabilities that is close to 1, such as 1.36.
* For a word $w*k$ that is unrelated to both "ice" and "steam", such as $w*k=\text{fashion}$, we expect a ratio of co-occurence probabilities that is close to 1, such as 0.96.




It can be seen that the ratio
of co-occurrence probabilities
can intuitively express
the relationship between words. 
Thus, we can design a function
of three word vectors
to fit this ratio.
For the ratio of co-occurrence probabilities
${p*{ij}}/{p*{ik}}$
with $w_i$ being the center word
and $w*j$ and $w*k$ being the context words,
we want to fit this ratio
using some function $f$:

$$f(\mathbf{u}*j, \mathbf{u}*k, {\mathbf{v}}*i) \approx \frac{p*{ij}}{p_{ik}}.$$
:eqlabel:`eq_glove-f`

Among many possible designs for $f$,
we only pick a reasonable choice in the following.
Since the ratio of co-occurrence probabilities
is a scalar,
we require that
$f$ be a scalar function, such as
$f(\mathbf{u}*j, \mathbf{u}*k, {\mathbf{v}}*i) = f\left((\mathbf{u}*j - \mathbf{u}*k)^\top {\mathbf{v}}*i\right)$. 
Switching word indices
$j$ and $k$ in :eqref:`eq_glove-f`,
it must hold that
$f(x)f(-x)=1$,
so one possibility is $f(x)=\exp(x)$,
i.e., 

$$f(\mathbf{u}*j, \mathbf{u}*k, {\mathbf{v}}*i) = \frac{\exp\left(\mathbf{u}*j^\top {\mathbf{v}}*i\right)}{\exp\left(\mathbf{u}*k^\top {\mathbf{v}}*i\right)} \approx \frac{p*{ij}}{p_{ik}}.$$

Now let us pick
$\exp\left(\mathbf{u}*j^\top {\mathbf{v}}*i\right) \approx \alpha p_{ij}$,
where $\alpha$ is a constant.
Since $p*{ij}=x*{ij}/x*i$, after taking the logarithm on both sides we get $\mathbf{u}*j^\top {\mathbf{v}}*i \approx \log\,\alpha + \log\,x*{ij} - \log\,x_i$. 
We may use additional bias terms to fit $- \log\, \alpha + \log\, x*i$, such as the center word bias $b*i$ and the context word bias $c_j$:

$$\mathbf{u}*j^\top \mathbf{v}*i + b*i + c*j \approx \log\, x_{ij}.$$
:eqlabel:`eq_glove-square`

Measuring the squared error of
:eqref:`eq_glove-square` with weights,
the GloVe loss function in
:eqref:`eq_glove-loss` is obtained.



# # Summary

* The skip-gram model can be interpreted using global corpus statistics such as word-word co-occurrence counts.
* The cross-entropy loss may not be a good choice for measuring the difference of two probability distributions, especially for a large corpus. GloVe uses squared loss to fit precomputed global corpus statistics.
* The center word vector and the context word vector are mathematically equivalent for any word in GloVe.
* GloVe can be interpreted from the ratio of word-word co-occurrence probabilities.


# # Exercises

1. If words $w*i$ and $w*j$ co-occur in the same context window, how can we use their   distance in the text sequence to redesign the method for  calculating the conditional probability $p_{ij}$? Hint: see Section 4.2 of the GloVe paper :cite:`Pennington.Socher.Manning.2014`.
1. For any word, are its center word bias  and context word bias mathematically equivalent in GloVe? Why?


[Discussions](https://discuss.d2l.ai/t/385)
