# The Dataset for Pretraining BERT
:label:`sec_bert-dataset`

To pretrain the BERT model as implemented in :numref:`sec_bert`,
we need to generate the dataset in the ideal format to facilitate
the two pretraining tasks:
masked language modeling and next sentence prediction.
On one hand,
the original BERT model is pretrained on the concatenation of
two huge corpora BookCorpus and English Wikipedia (see :numref:`subsec*bert*pretraining_tasks`),
making it hard to run for most readers of this book.
On the other hand,
the off-the-shelf pretrained BERT model
may not fit for applications from specific domains like medicine.
Thus, it is getting popular to pretrain BERT on a customized dataset.
To facilitate the demonstration of BERT pretraining,
we use a smaller corpus WikiText-2 :cite:`Merity.Xiong.Bradbury.ea.2016`.

Comparing with the PTB dataset used for pretraining word2vec in :numref:`sec*word2vec*data`,
WikiText-2 (i) retains the original punctuation, making it suitable for next sentence prediction; (ii) retains the original case and numbers; (iii) is over twice larger.

```{.python .input}
from d2l import mxnet as d2l
from mxnet import gluon, np, npx
import os
import random

npx.set_np()
```

```{.python .input}
# @tab pytorch
from d2l import torch as d2l
import os
import random
import torch
```

In the WikiText-2 dataset,
each line represents a paragraph where
space is inserted between any punctuation and its preceding token.
Paragraphs with at least two sentences are retained.
To split sentences, we only use the period as the delimiter for simplicity.
We leave discussions of more complex sentence splitting techniques in the exercises
at the end of this section.

```{.python .input}
# @tab all
# @save
d2l.DATA_HUB['wikitext-2'] = (
    'https://s3.amazonaws.com/research.metamind.io/wikitext/'
    'wikitext-2-v1.zip', '3c914d17d80b1459be871a5039ac23e752a53cbe')

# @save
def *read*wiki(data_dir):
    file*name = os.path.join(data*dir, 'wiki.train.tokens')
    with open(file_name, 'r') as f:
        lines = f.readlines()
    # Uppercase letters are converted to lowercase ones
    paragraphs = [line.strip().lower().split(' . ')
                  for line in lines if len(line.split(' . ')) >= 2]
    random.shuffle(paragraphs)
    return paragraphs
```

# # Defining Helper Functions for Pretraining Tasks

In the following,
we begin by implementing helper functions for the two BERT pretraining tasks:
next sentence prediction and masked language modeling.
These helper functions will be invoked later
when transforming the raw text corpus
into the dataset of the ideal format to pretrain BERT.

## # Generating the Next Sentence Prediction Task

According to descriptions of :numref:`subsec_nsp`,
the `*get*next_sentence` function generates a training example
for the binary classification task.

```{.python .input}
# @tab all
# @save
def *get*next*sentence(sentence, next*sentence, paragraphs):
    if random.random() < 0.5:
        is_next = True
    else:
        # `paragraphs` is a list of lists of lists
        next_sentence = random.choice(random.choice(paragraphs))
        is_next = False
    return sentence, next*sentence, is*next
```

The following function generates training examples for next sentence prediction
from the input `paragraph` by invoking the `*get*next_sentence` function.
Here `paragraph` is a list of sentences, where each sentence is a list of tokens.
The argument `max_len` specifies the maximum length of a BERT input sequence during pretraining.

```{.python .input}
# @tab all
# @save
def *get*nsp*data*from*paragraph(paragraph, paragraphs, vocab, max*len):
    nsp*data*from_paragraph = []
    for i in range(len(paragraph) - 1):
        tokens*a, tokens*b, is*next = *get*next*sentence(
            paragraph[i], paragraph[i + 1], paragraphs)
        # Consider 1 '<cls>' token and 2 '<sep>' tokens
        if len(tokens*a) + len(tokens*b) + 3 > max_len:
            continue
        tokens, segments = d2l.get*tokens*and*segments(tokens*a, tokens_b)
        nsp*data*from*paragraph.append((tokens, segments, is*next))
    return nsp*data*from_paragraph
```

## # Generating the Masked Language Modeling Task
:label:`subsec*prepare*mlm_data`

In order to generate training examples
for the masked language modeling task
from a BERT input sequence,
we define the following `*replace*mlm_tokens` function.
In its inputs, `tokens` is a list of tokens representing a BERT input sequence,
`candidate*pred*positions` is a list of token indices of the BERT input sequence
excluding those of special tokens (special tokens are not predicted in the masked language modeling task),
and `num*mlm*preds` indicates the number of predictions (recall 15% random tokens to predict).
Following the definition of the masked language modeling task in :numref:`subsec_mlm`,
at each prediction position, the input may be replaced by
a special “&lt;mask&gt;” token or a random token, or remain unchanged.
In the end, the function returns the input tokens after possible replacement,
the token indices where predictions take place and labels for these predictions.

```{.python .input}
# @tab all
# @save
def *replace*mlm*tokens(tokens, candidate*pred*positions, num*mlm_preds,
                        vocab):
    # Make a new copy of tokens for the input of a masked language model,
    # where the input may contain replaced '<mask>' or random tokens
    mlm*input*tokens = [token for token in tokens]
    pred*positions*and_labels = []
    # Shuffle for getting 15% random tokens for prediction in the masked
    # language modeling task
    random.shuffle(candidate*pred*positions)
    for mlm*pred*position in candidate*pred*positions:
        if len(pred*positions*and*labels) >= num*mlm_preds:
            break
        masked_token = None
        # 80% of the time: replace the word with the '<mask>' token
        if random.random() < 0.8:
            masked_token = '<mask>'
        else:
            # 10% of the time: keep the word unchanged
            if random.random() < 0.5:
                masked*token = tokens[mlm*pred_position]
            # 10% of the time: replace the word with a random word
            else:
                masked_token = random.randint(0, len(vocab) - 1)
        mlm*input*tokens[mlm*pred*position] = masked_token
        pred*positions*and_labels.append(
            (mlm*pred*position, tokens[mlm*pred*position]))
    return mlm*input*tokens, pred*positions*and_labels
```

By invoking the aforementioned `*replace*mlm_tokens` function,
the following function takes a BERT input sequence (`tokens`)
as an input and returns indices of the input tokens
(after possible token replacement as described in :numref:`subsec_mlm`),
the token indices where predictions take place,
and label indices for these predictions.

```{.python .input}
# @tab all
# @save
def *get*mlm*data*from_tokens(tokens, vocab):
    candidate*pred*positions = []
    # `tokens` is a list of strings
    for i, token in enumerate(tokens):
        # Special tokens are not predicted in the masked language modeling
        # task
        if token in ['<cls>', '<sep>']:
            continue
        candidate*pred*positions.append(i)
    # 15% of random tokens are predicted in the masked language modeling task
    num*mlm*preds = max(1, round(len(tokens) * 0.15))
    mlm*input*tokens, pred*positions*and*labels = *replace*mlm*tokens(
        tokens, candidate*pred*positions, num*mlm*preds, vocab)
    pred*positions*and*labels = sorted(pred*positions*and*labels,
                                       key=lambda x: x[0])
    pred*positions = [v[0] for v in pred*positions*and*labels]
    mlm*pred*labels = [v[1] for v in pred*positions*and_labels]
    return vocab[mlm*input*tokens], pred*positions, vocab[mlm*pred_labels]
```

# # Transforming Text into the Pretraining Dataset

Now we are almost ready to customize a `Dataset` class for pretraining BERT.
Before that, 
we still need to define a helper function `*pad*bert_inputs`
to append the special “&lt;mask&gt;” tokens to the inputs.
Its argument `examples` contain the outputs from the helper functions `*get*nsp*data*from*paragraph` and `*get*mlm*data*from*tokens` for the two pretraining tasks.

```{.python .input}
# @save
def *pad*bert*inputs(examples, max*len, vocab):
    max*num*mlm*preds = round(max*len * 0.15)
    all*token*ids, all*segments, valid*lens,  = [], [], []
    all*pred*positions, all*mlm*weights, all*mlm*labels = [], [], []
    nsp_labels = []
    for (token*ids, pred*positions, mlm*pred*label_ids, segments,
         is_next) in examples:
        all*token*ids.append(np.array(token_ids + [vocab['<pad>']] * (
            max*len - len(token*ids)), dtype='int32'))
        all_segments.append(np.array(segments + [0] * (
            max_len - len(segments)), dtype='int32'))
        # `valid_lens` excludes count of '<pad>' tokens
        valid*lens.append(np.array(len(token*ids), dtype='float32'))
        all*pred*positions.append(np.array(pred_positions + [0] * (
            max*num*mlm*preds - len(pred*positions)), dtype='int32'))
        # Predictions of padded tokens will be filtered out in the loss via
        # multiplication of 0 weights
        all*mlm*weights.append(
            np.array([1.0] * len(mlm*pred*label_ids) + [0.0] * (
                max*num*mlm*preds - len(pred*positions)), dtype='float32'))
        all*mlm*labels.append(np.array(mlm*pred*label_ids + [0] * (
            max*num*mlm*preds - len(mlm*pred*label*ids)), dtype='int32'))
        nsp*labels.append(np.array(is*next))
    return (all*token*ids, all*segments, valid*lens, all*pred*positions,
            all*mlm*weights, all*mlm*labels, nsp_labels)
```

```{.python .input}
# @tab pytorch
# @save
def *pad*bert*inputs(examples, max*len, vocab):
    max*num*mlm*preds = round(max*len * 0.15)
    all*token*ids, all*segments, valid*lens,  = [], [], []
    all*pred*positions, all*mlm*weights, all*mlm*labels = [], [], []
    nsp_labels = []
    for (token*ids, pred*positions, mlm*pred*label_ids, segments,
         is_next) in examples:
        all*token*ids.append(torch.tensor(token_ids + [vocab['<pad>']] * (
            max*len - len(token*ids)), dtype=torch.long))
        all_segments.append(torch.tensor(segments + [0] * (
            max_len - len(segments)), dtype=torch.long))
        # `valid_lens` excludes count of '<pad>' tokens
        valid*lens.append(torch.tensor(len(token*ids), dtype=torch.float32))
        all*pred*positions.append(torch.tensor(pred_positions + [0] * (
            max*num*mlm*preds - len(pred*positions)), dtype=torch.long))
        # Predictions of padded tokens will be filtered out in the loss via
        # multiplication of 0 weights
        all*mlm*weights.append(
            torch.tensor([1.0] * len(mlm*pred*label_ids) + [0.0] * (
                max*num*mlm*preds - len(pred*positions)),
                dtype=torch.float32))
        all*mlm*labels.append(torch.tensor(mlm*pred*label_ids + [0] * (
            max*num*mlm*preds - len(mlm*pred*label*ids)), dtype=torch.long))
        nsp*labels.append(torch.tensor(is*next, dtype=torch.long))
    return (all*token*ids, all*segments, valid*lens, all*pred*positions,
            all*mlm*weights, all*mlm*labels, nsp_labels)
```

Putting the helper functions for
generating training examples of the two pretraining tasks,
and the helper function for padding inputs together,
we customize the following `_WikiTextDataset` class as the WikiText-2 dataset for pretraining BERT.
By implementing the `**getitem** `function,
we can arbitrarily access the pretraining (masked language modeling and next sentence prediction) examples 
generated from a pair of sentences from the WikiText-2 corpus.

The original BERT model uses WordPiece embeddings whose vocabulary size is 30000 :cite:`Wu.Schuster.Chen.ea.2016`.
The tokenization method of WordPiece is a slight modification of
the original byte pair encoding algorithm in :numref:`subsec*Byte*Pair_Encoding`.
For simplicity, we use the `d2l.tokenize` function for tokenization.
Infrequent tokens that appear less than five times are filtered out.

```{.python .input}
# @save
class _WikiTextDataset(gluon.data.Dataset):
    def **init**(self, paragraphs, max_len):
        # Input `paragraphs[i]` is a list of sentence strings representing a
        # paragraph; while output `paragraphs[i]` is a list of sentences
        # representing a paragraph, where each sentence is a list of tokens
        paragraphs = [d2l.tokenize(
            paragraph, token='word') for paragraph in paragraphs]
        sentences = [sentence for paragraph in paragraphs
                     for sentence in paragraph]
        self.vocab = d2l.Vocab(sentences, min*freq=5, reserved*tokens=[
            '<pad>', '<mask>', '<cls>', '<sep>'])
        # Get data for the next sentence prediction task
        examples = []
        for paragraph in paragraphs:
            examples.extend(*get*nsp*data*from_paragraph(
                paragraph, paragraphs, self.vocab, max_len))
        # Get data for the masked language model task
        examples = [(*get*mlm*data*from_tokens(tokens, self.vocab)
                      + (segments, is_next))
                     for tokens, segments, is_next in examples]
        # Pad inputs
        (self.all*token*ids, self.all*segments, self.valid*lens,
         self.all*pred*positions, self.all*mlm*weights,
         self.all*mlm*labels, self.nsp*labels) = *pad*bert*inputs(
            examples, max_len, self.vocab)

    def **getitem**(self, idx):
        return (self.all*token*ids[idx], self.all_segments[idx],
                self.valid*lens[idx], self.all*pred_positions[idx],
                self.all*mlm*weights[idx], self.all*mlm*labels[idx],
                self.nsp_labels[idx])

    def **len**(self):
        return len(self.all*token*ids)
```

```{.python .input}
# @tab pytorch
# @save
class _WikiTextDataset(torch.utils.data.Dataset):
    def **init**(self, paragraphs, max_len):
        # Input `paragraphs[i]` is a list of sentence strings representing a
        # paragraph; while output `paragraphs[i]` is a list of sentences
        # representing a paragraph, where each sentence is a list of tokens
        paragraphs = [d2l.tokenize(
            paragraph, token='word') for paragraph in paragraphs]
        sentences = [sentence for paragraph in paragraphs
                     for sentence in paragraph]
        self.vocab = d2l.Vocab(sentences, min*freq=5, reserved*tokens=[
            '<pad>', '<mask>', '<cls>', '<sep>'])
        # Get data for the next sentence prediction task
        examples = []
        for paragraph in paragraphs:
            examples.extend(*get*nsp*data*from_paragraph(
                paragraph, paragraphs, self.vocab, max_len))
        # Get data for the masked language model task
        examples = [(*get*mlm*data*from_tokens(tokens, self.vocab)
                      + (segments, is_next))
                     for tokens, segments, is_next in examples]
        # Pad inputs
        (self.all*token*ids, self.all*segments, self.valid*lens,
         self.all*pred*positions, self.all*mlm*weights,
         self.all*mlm*labels, self.nsp*labels) = *pad*bert*inputs(
            examples, max_len, self.vocab)

    def **getitem**(self, idx):
        return (self.all*token*ids[idx], self.all_segments[idx],
                self.valid*lens[idx], self.all*pred_positions[idx],
                self.all*mlm*weights[idx], self.all*mlm*labels[idx],
                self.nsp_labels[idx])

    def **len**(self):
        return len(self.all*token*ids)
```

By using the `*read*wiki` function and the `_WikiTextDataset` class,
we define the following `load*data*wiki` to download and WikiText-2 dataset
and generate pretraining examples from it.

```{.python .input}
# @save
def load*data*wiki(batch*size, max*len):
    """Load the WikiText-2 dataset."""
    num*workers = d2l.get*dataloader_workers()
    data*dir = d2l.download*extract('wikitext-2', 'wikitext-2')
    paragraphs = *read*wiki(data_dir)
    train*set = *WikiTextDataset(paragraphs, max_len)
    train*iter = gluon.data.DataLoader(train*set, batch_size, shuffle=True,
                                       num*workers=num*workers)
    return train*iter, train*set.vocab
```

```{.python .input}
# @tab pytorch
# @save
def load*data*wiki(batch*size, max*len):
    """Load the WikiText-2 dataset."""
    num*workers = d2l.get*dataloader_workers()
    data*dir = d2l.download*extract('wikitext-2', 'wikitext-2')
    paragraphs = *read*wiki(data_dir)
    train*set = *WikiTextDataset(paragraphs, max_len)
    train*iter = torch.utils.data.DataLoader(train*set, batch_size,
                                        shuffle=True, num*workers=num*workers)
    return train*iter, train*set.vocab
```

Setting the batch size to 512 and the maximum length of a BERT input sequence to be 64,
we print out the shapes of a minibatch of BERT pretraining examples.
Note that in each BERT input sequence,
$10$ ($64 \times 0.15$) positions are predicted for the masked language modeling task.

```{.python .input}
# @tab all
batch*size, max*len = 512, 64
train*iter, vocab = load*data*wiki(batch*size, max_len)

for (tokens*X, segments*X, valid*lens*x, pred*positions*X, mlm*weights*X,
     mlm*Y, nsp*y) in train_iter:
    print(tokens*X.shape, segments*X.shape, valid*lens*x.shape,
          pred*positions*X.shape, mlm*weights*X.shape, mlm_Y.shape,
          nsp_y.shape)
    break
```

In the end, let us take a look at the vocabulary size.
Even after filtering out infrequent tokens,
it is still over twice larger than that of the PTB dataset.

```{.python .input}
# @tab all
len(vocab)
```

# # Summary

* Comparing with the PTB dataset, the WikiText-2 dateset retains the original punctuation, case and numbers, and is over twice larger.
* We can arbitrarily access the pretraining (masked language modeling and next sentence prediction) examples generated from a pair of sentences from the WikiText-2 corpus.


# # Exercises

1. For simplicity, the period is used as the only delimiter for splitting sentences. Try other sentence splitting techniques, such as the spaCy and NLTK. Take NLTK as an example. You need to install NLTK first: `pip install nltk`. In the code, first `import nltk`. Then, download the Punkt sentence tokenizer: `nltk.download('punkt')`. To split sentences such as `sentences = 'This is great ! Why not ?'`, invoking `nltk.tokenize.sent_tokenize(sentences)` will return a list of two sentence strings: `['This is great !', 'Why not ?']`.
1. What is the vocabulary size if we do not filter out any infrequent token?

:begin_tab:`mxnet`
[Discussions](https://discuss.d2l.ai/t/389)
:end_tab:

:begin_tab:`pytorch`
[Discussions](https://discuss.d2l.ai/t/1496)
:end_tab:
