# The Dataset for Pretraining Word Embeddings
:label:`sec*word2vec*data`

Now that we know the technical details of 
the word2vec models and approximate training methods,
let us walk through their implementations. 
Specifically,
we will take the skip-gram model in :numref:`sec_word2vec`
and negative sampling in :numref:`sec*approx*train`
as an example.
In this section,
we begin with the dataset
for pretraining the word embedding model:
the original format of the data
will be transformed
into minibatches
that can be iterated over during training.

```{.python .input}
from d2l import mxnet as d2l
import math
from mxnet import gluon, np
import os
import random
```

```{.python .input}
# @tab pytorch
from d2l import torch as d2l
import math
import torch
import os
import random
```

# # Reading the Dataset

The dataset that we use here
is [Penn Tree Bank (PTB)]( https://catalog.ldc.upenn.edu/LDC99T42). 
This corpus is sampled
from Wall Street Journal articles,
split into training, validation, and test sets.
In the original format,
each line of the text file
represents a sentence of words that are separated by spaces.
Here we treat each word as a token.

```{.python .input}
# @tab all
# @save
d2l.DATA*HUB['ptb'] = (d2l.DATA*URL + 'ptb.zip',
                       '319d85e578af0cdc590547f26231e4e31cdf1e42')

# @save
def read_ptb():
    """Load the PTB dataset into a list of text lines."""
    data*dir = d2l.download*extract('ptb')
    # Read the training set.
    with open(os.path.join(data_dir, 'ptb.train.txt')) as f:
        raw_text = f.read()
    return [line.split() for line in raw_text.split('\n')]

sentences = read_ptb()
f'# sentences: {len(sentences)}'
```

After reading the training set,
we build a vocabulary for the corpus,
where any word that appears 
less than 10 times is replaced by 
the "&lt;unk&gt;" token.
Note that the original dataset
also contains "&lt;unk&gt;" tokens that represent rare (unknown) words.

```{.python .input}
# @tab all
vocab = d2l.Vocab(sentences, min_freq=10)
f'vocab size: {len(vocab)}'
```

# # Subsampling

Text data
typically have high-frequency words
such as "the", "a", and "in":
they may even occur billions of times in
very large corpora.
However,
these words often co-occur
with many different words in
context windows, providing little useful signals.
For instance,
consider the word "chip" in a context window:
intuitively
its co-occurrence with a low-frequency word "intel"
is more useful in training
than 
the co-occurrence with a high-frequency word "a".
Moreover, training with vast amounts of (high-frequency) words
is slow.
Thus, when training word embedding models, 
high-frequency words can be *subsampled* :cite:`Mikolov.Sutskever.Chen.ea.2013`.
Specifically, 
each indexed word $w_i$ 
in the dataset will be discarded with probability


$$ P(w*i) = \max\left(1 - \sqrt{\frac{t}{f(w*i)}}, 0\right),$$

where $f(w_i)$ is the ratio of 
the number of words $w_i$
to the total number of words in the dataset, 
and the constant $t$ is a hyperparameter
($10^{-4}$ in the experiment). 
We can see that only when
the relative frequency
$f(w*i) > t$  can the (high-frequency) word $w*i$ be discarded, 
and the higher the relative frequency of the word, 
the greater the probability of being discarded.

```{.python .input}
# @tab all
# @save
def subsample(sentences, vocab):
    """Subsample high-frequency words."""
    # Exclude unknown tokens '<unk>'
    sentences = [[token for token in line if vocab[token] != vocab.unk]
                 for line in sentences]
    counter = d2l.count_corpus(sentences)
    num_tokens = sum(counter.values())

    # Return True if `token` is kept during subsampling
    def keep(token):
        return(random.uniform(0, 1) <
               math.sqrt(1e-4 / counter[token] * num_tokens))

    return ([[token for token in line if keep(token)] for line in sentences],
            counter)

subsampled, counter = subsample(sentences, vocab)
```

The following code snippet 
plots the histogram of
the number of tokens per sentence
before and after subsampling.
As expected, 
subsampling significantly shortens sentences
by dropping high-frequency words,
which will lead to training speedup.

```{.python .input}
# @tab all
d2l.show*list*len*pair*hist(['origin', 'subsampled'], '# tokens per sentence',
                            'count', sentences, subsampled);
```

For individual tokens, the sampling rate of the high-frequency word "the" is less than 1/20.

```{.python .input}
# @tab all
def compare_counts(token):
    return (f'# of "{token}": '
            f'before={sum([l.count(token) for l in sentences])}, '
            f'after={sum([l.count(token) for l in subsampled])}')

compare_counts('the')
```

In contrast, 
low-frequency words "join" are completely kept.

```{.python .input}
# @tab all
compare_counts('join')
```

After subsampling, we map tokens to their indices for the corpus.

```{.python .input}
# @tab all
corpus = [vocab[line] for line in subsampled]
corpus[:3]
```

# # Extracting Center Words and Context Words


The following `get*centers*and_contexts`
function extracts all the 
center words and their context words
from `corpus`.
It uniformly samples an integer between 1 and `max*window*size`
at random as the context window size.
For any center word,
those words 
whose distance from it
does not exceed the sampled
context window size
are its context words.

```{.python .input}
# @tab all
# @save
def get*centers*and*contexts(corpus, max*window_size):
    """Return center words and context words in skip-gram."""
    centers, contexts = [], []
    for line in corpus:
        # To form a "center word--context word" pair, each sentence needs to
        # have at least 2 words
        if len(line) < 2:
            continue
        centers += line
        for i in range(len(line)):  # Context window centered at `i`
            window*size = random.randint(1, max*window_size)
            indices = list(range(max(0, i - window_size),
                                 min(len(line), i + 1 + window_size)))
            # Exclude the center word from the context words
            indices.remove(i)
            contexts.append([line[idx] for idx in indices])
    return centers, contexts
```

Next, we create an artificial dataset containing two sentences of 7 and 3 words, respectively. 
Let the maximum context window size be 2 
and print all the center words and their context words.

```{.python .input}
# @tab all
tiny_dataset = [list(range(7)), list(range(7, 10))]
print('dataset', tiny_dataset)
for center, context in zip(*get*centers*and*contexts(tiny*dataset, 2)):
    print('center', center, 'has contexts', context)
```

When training on the PTB dataset,
we set the maximum context window size to 5. 
The following extracts all the center words and their context words in the dataset.

```{.python .input}
# @tab all
all*centers, all*contexts = get*centers*and_contexts(corpus, 5)
f'# center-context pairs: {sum([len(contexts) for contexts in all_contexts])}'
```

# # Negative Sampling

We use negative sampling for approximate training. 
To sample noise words according to 
a predefined distribution,
we define the following `RandomGenerator` class,
where the (possibly unnormalized) sampling distribution is passed
via the argument `sampling_weights`.

```{.python .input}
# @tab all
# @save
class RandomGenerator:
    """Randomly draw among {1, ..., n} according to n sampling weights."""
    def **init**(self, sampling_weights):
        # Exclude 
        self.population = list(range(1, len(sampling_weights) + 1))
        self.sampling*weights = sampling*weights
        self.candidates = []
        self.i = 0

    def draw(self):
        if self.i == len(self.candidates):
            # Cache `k` random sampling results
            self.candidates = random.choices(
                self.population, self.sampling_weights, k=10000)
            self.i = 0
        self.i += 1
        return self.candidates[self.i - 1]
```

For example, 
we can draw 10 random variables $X$
among indices 1, 2, and 3
with sampling probabilities $P(X=1)=2/9, P(X=2)=3/9$, and $P(X=3)=4/9$ as follows.

```{.python .input}
generator = RandomGenerator([2, 3, 4])
[generator.draw() for _ in range(10)]
```

For a pair of center word and context word, 
we randomly sample `K` (5 in the experiment) noise words. According to the suggestions in the word2vec paper,
the sampling probability $P(w)$ of 
a noise word $w$
is 
set to its relative frequency 
in the dictionary
raised to 
the power of 0.75 :cite:`Mikolov.Sutskever.Chen.ea.2013`.

```{.python .input}
# @tab all
# @save
def get*negatives(all*contexts, vocab, counter, K):
    """Return noise words in negative sampling."""
    # Sampling weights for words with indices 1, 2, ... (index 0 is the
    # excluded unknown token) in the vocabulary
    sampling*weights = [counter[vocab.to*tokens(i)]**0.75
                        for i in range(1, len(vocab))]
    all*negatives, generator = [], RandomGenerator(sampling*weights)
    for contexts in all_contexts:
        negatives = []
        while len(negatives) < len(contexts) * K:
            neg = generator.draw()
            # Noise words cannot be context words
            if neg not in contexts:
                negatives.append(neg)
        all_negatives.append(negatives)
    return all_negatives

all*negatives = get*negatives(all_contexts, vocab, counter, 5)
```

# # Loading Training Examples in Minibatches
:label:`subsec_word2vec-minibatch-loading`

After
all the center words
together with their
context words and sampled noise words are extracted,
they will be transformed into 
minibatches of examples
that can be iteratively loaded
during training.



In a minibatch,
the $i^\mathrm{th}$ example includes a center word
and its $n*i$ context words and $m*i$ noise words. 
Due to varying context window sizes,
$n*i+m*i$ varies for different $i$.
Thus,
for each example
we concatenate its context words and noise words in 
the `contexts_negatives` variable,
and pad zeros until the concatenation length
reaches $\max*i n*i+m*i$ (`max*len`).
To exclude paddings
in the calculation of the loss,
we define a mask variable `masks`.
There is a one-to-one correspondence
between elements in `masks` and elements in `contexts_negatives`,
where zeros (otherwise ones) in `masks` correspond to paddings in `contexts_negatives`.


To distinguish between positive and negative examples,
we separate context words from noise words in  `contexts_negatives` via a `labels` variable. 
Similar to `masks`,
there is also a one-to-one correspondence
between elements in `labels` and elements in `contexts_negatives`,
where ones (otherwise zeros) in `labels` correspond to context words (positive examples) in `contexts_negatives`.


The above idea is implemented in the following `batchify` function.
Its input `data` is a list with length
equal to the batch size,
where each element is an example
consisting of
the center word `center`, its context words `context`, and its noise words `negative`.
This function returns 
a minibatch that can be loaded for calculations 
during training,
such as including the mask variable.

```{.python .input}
# @tab all
# @save
def batchify(data):
    """Return a minibatch of examples for skip-gram with negative sampling."""
    max*len = max(len(c) + len(n) for *, c, n in data)
    centers, contexts_negatives, masks, labels = [], [], [], []
    for center, context, negative in data:
        cur_len = len(context) + len(negative)
        centers += [center]
        contexts*negatives += [context + negative + [0] * (max*len - cur_len)]
        masks += [[1] * cur*len + [0] * (max*len - cur_len)]
        labels += [[1] * len(context) + [0] * (max_len - len(context))]
    return (d2l.reshape(d2l.tensor(centers), (-1, 1)), d2l.tensor(
        contexts_negatives), d2l.tensor(masks), d2l.tensor(labels))
```

Let us test this function using a minibatch of two examples.

```{.python .input}
# @tab all
x_1 = (1, [2, 2], [3, 3, 3, 3])
x_2 = (1, [2, 2, 2], [3, 3])
batch = batchify((x*1, x*2))

names = ['centers', 'contexts_negatives', 'masks', 'labels']
for name, data in zip(names, batch):
    print(name, '=', data)
```

# # Putting All Things Together

Last, we define the `load*data*ptb` function that reads the PTB dataset and returns the data iterator and the vocabulary.

```{.python .input}
# @save
def load*data*ptb(batch*size, max*window*size, num*noise_words):
    """Download the PTB dataset and then load it into memory."""
    sentences = read_ptb()
    vocab = d2l.Vocab(sentences, min_freq=10)
    subsampled, counter = subsample(sentences, vocab)
    corpus = [vocab[line] for line in subsampled]
    all*centers, all*contexts = get*centers*and_contexts(
        corpus, max*window*size)
    all*negatives = get*negatives(
        all*contexts, vocab, counter, num*noise_words)
    dataset = gluon.data.ArrayDataset(
        all*centers, all*contexts, all_negatives)
    data_iter = gluon.data.DataLoader(
        dataset, batch*size, shuffle=True,batchify*fn=batchify,
        num*workers=d2l.get*dataloader_workers())
    return data_iter, vocab
```

```{.python .input}
# @tab pytorch
# @save
def load*data*ptb(batch*size, max*window*size, num*noise_words):
    """Download the PTB dataset and then load it into memory."""
    num*workers = d2l.get*dataloader_workers()
    sentences = read_ptb()
    vocab = d2l.Vocab(sentences, min_freq=10)
    subsampled, counter = subsample(sentences, vocab)
    corpus = [vocab[line] for line in subsampled]
    all*centers, all*contexts = get*centers*and_contexts(
        corpus, max*window*size)
    all*negatives = get*negatives(
        all*contexts, vocab, counter, num*noise_words)

    class PTBDataset(torch.utils.data.Dataset):
        def **init**(self, centers, contexts, negatives):
            assert len(centers) == len(contexts) == len(negatives)
            self.centers = centers
            self.contexts = contexts
            self.negatives = negatives

        def **getitem**(self, index):
            return (self.centers[index], self.contexts[index],
                    self.negatives[index])

        def **len**(self):
            return len(self.centers)

    dataset = PTBDataset(all*centers, all*contexts, all_negatives)

    data*iter = torch.utils.data.DataLoader(dataset, batch*size, shuffle=True,
                                      collate_fn=batchify,
                                      num*workers=num*workers)
    return data_iter, vocab
```

Let us print the first minibatch of the data iterator.

```{.python .input}
# @tab all
data*iter, vocab = load*data_ptb(512, 5, 5)
for batch in data_iter:
    for name, data in zip(names, batch):
        print(name, 'shape:', data.shape)
    break
```

# # Summary

* High-frequency words may not be so useful in training. We can subsample them for speedup in training.
* For computational efficiency, we load examples in minibatches. We can define other variables to distinguish paddings from non-paddings, and positive examples from negative ones.



# # Exercises

1. How does the running time of code in this section changes if not using subsampling?
1. The `RandomGenerator` class caches `k` random sampling results. Set `k` to other values and see how it affects the data loading speed.
1. What other hyperparameters in the code of this section may affect the data loading speed?



:begin_tab:`mxnet`
[Discussions](https://discuss.d2l.ai/t/383)
:end_tab:

:begin_tab:`pytorch`
[Discussions](https://discuss.d2l.ai/t/1330)
:end_tab:
