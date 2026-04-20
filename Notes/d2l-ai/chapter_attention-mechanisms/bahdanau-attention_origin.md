# Bahdanau Attention
:label:`sec*seq2seq*attention`

We studied the machine translation
problem in :numref:`sec_seq2seq`,
where we designed
an encoder-decoder architecture based on two RNNs
for sequence to sequence learning.
Specifically,
the RNN encoder 
transforms
a variable-length sequence
into a fixed-shape context variable,
then
the RNN decoder
generates the output (target) sequence token by token
based on the generated tokens and the context variable.
However,
even though not all the input (source) tokens
are useful for decoding a certain token,
the *same* context variable
that encodes the entire input sequence
is still used at each decoding step.


In a separate but related
challenge of handwriting generation for a given text sequence,
Graves designed a differentiable attention model
to align text characters with the much longer pen trace,
where the alignment moves only in one direction :cite:`Graves.2013`.
Inspired by the idea of learning to align,
Bahdanau et al. proposed a differentiable attention model
without the severe unidirectional alignment limitation :cite:`Bahdanau.Cho.Bengio.2014`.
When predicting a token,
if not all the input tokens are relevant,
the model aligns (or attends)
only to parts of the input sequence that are relevant to the current prediction.
This is achieved
by treating the context variable as an output of attention pooling.

# # Model

When describing 
Bahdanau attention
for the RNN encoder-decoder below,
we will follow the same notation in
:numref:`sec_seq2seq`.
The new attention-based model
is the same as that
in :numref:`sec_seq2seq`
except that
the context variable
$\mathbf{c}$
in 
:eqref:`eq*seq2seq*s_t`
is replaced by
$\mathbf{c}_{t'}$
at any decoding time step $t'$.
Suppose that
there are $T$ tokens in the input sequence,
the context variable at the decoding time step $t'$
is the output of attention pooling:

$$\mathbf{c}*{t'} = \sum*{t=1}^T \alpha(\mathbf{s}*{t' - 1}, \mathbf{h}*t) \mathbf{h}_t,$$

where the decoder hidden state
$\mathbf{s}_{t' - 1}$ at time step $t' - 1$
is the query,
and the encoder hidden states $\mathbf{h}_t$
are both the keys and values,
and the attention weight $\alpha$
is computed as in
:eqref:`eq_attn-scoring-alpha`
using the additive attention scoring function
defined by
:eqref:`eq_additive-attn`.


Slightly different from 
the vanilla RNN encoder-decoder architecture 
in :numref:`fig*seq2seq*details`,
the same architecture
with Bahdanau attention is depicted in 
:numref:`fig*s2s*attention_details`.

![Layers in an RNN encoder-decoder model with Bahdanau attention.](../img/seq2seq-attention-details.svg)
:label:`fig*s2s*attention_details`

```{.python .input}
from d2l import mxnet as d2l
from mxnet import np, npx
from mxnet.gluon import rnn, nn
npx.set_np()
```

```{.python .input}
# @tab pytorch
from d2l import torch as d2l
import torch
from torch import nn
```

# # Defining the Decoder with Attention

To implement the RNN encoder-decoder
with Bahdanau attention,
we only need to redefine the decoder.
To visualize the learned attention weights more conveniently,
the following `AttentionDecoder` class
defines the base interface for 
decoders with attention mechanisms.

```{.python .input}
# @tab all
# @save
class AttentionDecoder(d2l.Decoder):
    """The base attention-based decoder interface."""
    def **init**(self, **kwargs):
        super(AttentionDecoder, self).**init**(**kwargs)

    @property
    def attention_weights(self):
        raise NotImplementedError
```

Now let us implement
the RNN decoder with Bahdanau attention
in the following `Seq2SeqAttentionDecoder` class.
The state of the decoder
is initialized with 
i) the encoder final-layer hidden states at all the time steps (as keys and values of the attention);
ii) the encoder all-layer hidden state at the final time step (to initialize the hidden state of the decoder);
and iii) the encoder valid length (to exclude the padding tokens in attention pooling).
At each decoding time step,
the decoder final-layer hidden state at the previous time step is used as the query of the attention.
As a result, both the attention output
and the input embedding are concatenated
as the input of the RNN decoder.

```{.python .input}
class Seq2SeqAttentionDecoder(AttentionDecoder):
    def **init**(self, vocab*size, embed*size, num*hiddens, num*layers,
                 dropout=0, **kwargs):
        super(Seq2SeqAttentionDecoder, self).**init**(**kwargs)
        self.attention = d2l.AdditiveAttention(num_hiddens, dropout)
        self.embedding = nn.Embedding(vocab*size, embed*size)
        self.rnn = rnn.GRU(num*hiddens, num*layers, dropout=dropout)
        self.dense = nn.Dense(vocab_size, flatten=False)

    def init*state(self, enc*outputs, enc*valid*lens, *args):
        # Shape of `outputs`: (`num*steps`, `batch*size`, `num_hiddens`).
        # Shape of `hidden*state[0]`: (`num*layers`, `batch_size`,
        # `num_hiddens`)
        outputs, hidden*state = enc*outputs
        return (outputs.swapaxes(0, 1), hidden*state, enc*valid_lens)

    def forward(self, X, state):
        # Shape of `enc*outputs`: (`batch*size`, `num*steps`, `num*hiddens`).
        # Shape of `hidden*state[0]`: (`num*layers`, `batch_size`,
        # `num_hiddens`)
        enc*outputs, hidden*state, enc*valid*lens = state
        # Shape of the output `X`: (`num*steps`, `batch*size`, `embed_size`)
        X = self.embedding(X).swapaxes(0, 1)
        outputs, self.*attention*weights = [], []
        for x in X:
            # Shape of `query`: (`batch*size`, 1, `num*hiddens`)
            query = np.expand*dims(hidden*state[0][-1], axis=1)
            # Shape of `context`: (`batch*size`, 1, `num*hiddens`)
            context = self.attention(
                query, enc*outputs, enc*outputs, enc*valid*lens)
            # Concatenate on the feature dimension
            x = np.concatenate((context, np.expand_dims(x, axis=1)), axis=-1)
            # Reshape `x` as (1, `batch*size`, `embed*size` + `num_hiddens`)
            out, hidden*state = self.rnn(x.swapaxes(0, 1), hidden*state)
            outputs.append(out)
            self.*attention*weights.append(self.attention.attention_weights)
        # After fully-connected layer transformation, shape of `outputs`:
        # (`num*steps`, `batch*size`, `vocab_size`)
        outputs = self.dense(np.concatenate(outputs, axis=0))
        return outputs.swapaxes(0, 1), [enc*outputs, hidden*state,
                                        enc*valid*lens]

    @property
    def attention_weights(self):
        return self.*attention*weights
```

```{.python .input}
# @tab pytorch
class Seq2SeqAttentionDecoder(AttentionDecoder):
    def **init**(self, vocab*size, embed*size, num*hiddens, num*layers,
                 dropout=0, **kwargs):
        super(Seq2SeqAttentionDecoder, self).**init**(**kwargs)
        self.attention = d2l.AdditiveAttention(
            num*hiddens, num*hiddens, num_hiddens, dropout)
        self.embedding = nn.Embedding(vocab*size, embed*size)
        self.rnn = nn.GRU(
            embed*size + num*hiddens, num*hiddens, num*layers,
            dropout=dropout)
        self.dense = nn.Linear(num*hiddens, vocab*size)

    def init*state(self, enc*outputs, enc*valid*lens, *args):
        # Shape of `outputs`: (`num*steps`, `batch*size`, `num_hiddens`).
        # Shape of `hidden*state[0]`: (`num*layers`, `batch_size`,
        # `num_hiddens`)
        outputs, hidden*state = enc*outputs
        return (outputs.permute(1, 0, 2), hidden*state, enc*valid_lens)

    def forward(self, X, state):
        # Shape of `enc*outputs`: (`batch*size`, `num*steps`, `num*hiddens`).
        # Shape of `hidden*state[0]`: (`num*layers`, `batch_size`,
        # `num_hiddens`)
        enc*outputs, hidden*state, enc*valid*lens = state
        # Shape of the output `X`: (`num*steps`, `batch*size`, `embed_size`)
        X = self.embedding(X).permute(1, 0, 2)
        outputs, self.*attention*weights = [], []
        for x in X:
            # Shape of `query`: (`batch*size`, 1, `num*hiddens`)
            query = torch.unsqueeze(hidden_state[-1], dim=1)
            # Shape of `context`: (`batch*size`, 1, `num*hiddens`)
            context = self.attention(
                query, enc*outputs, enc*outputs, enc*valid*lens)
            # Concatenate on the feature dimension
            x = torch.cat((context, torch.unsqueeze(x, dim=1)), dim=-1)
            # Reshape `x` as (1, `batch*size`, `embed*size` + `num_hiddens`)
            out, hidden*state = self.rnn(x.permute(1, 0, 2), hidden*state)
            outputs.append(out)
            self.*attention*weights.append(self.attention.attention_weights)
        # After fully-connected layer transformation, shape of `outputs`:
        # (`num*steps`, `batch*size`, `vocab_size`)
        outputs = self.dense(torch.cat(outputs, dim=0))
        return outputs.permute(1, 0, 2), [enc*outputs, hidden*state,
                                          enc*valid*lens]
    
    @property
    def attention_weights(self):
        return self.*attention*weights
```

In the following, we test the implemented 
decoder with Bahdanau attention
using a minibatch of 4 sequence inputs
of 7 time steps.

```{.python .input}
encoder = d2l.Seq2SeqEncoder(vocab*size=10, embed*size=8, num_hiddens=16,
                             num_layers=2)
encoder.initialize()
decoder = Seq2SeqAttentionDecoder(vocab*size=10, embed*size=8, num_hiddens=16,
                                  num_layers=2)
decoder.initialize()
X = d2l.zeros((4, 7))  # (`batch*size`, `num*steps`)
state = decoder.init_state(encoder(X), None)
output, state = decoder(X, state)
output.shape, len(state), state[0].shape, len(state[1]), state[1][0].shape
```

```{.python .input}
# @tab pytorch
encoder = d2l.Seq2SeqEncoder(vocab*size=10, embed*size=8, num_hiddens=16,
                             num_layers=2)
encoder.eval()
decoder = Seq2SeqAttentionDecoder(vocab*size=10, embed*size=8, num_hiddens=16,
                                  num_layers=2)
decoder.eval()
X = d2l.zeros((4, 7), dtype=torch.long)  # (`batch*size`, `num*steps`)
state = decoder.init_state(encoder(X), None)
output, state = decoder(X, state)
output.shape, len(state), state[0].shape, len(state[1]), state[1][0].shape
```

# # Training


Similar to :numref:`sec*seq2seq*training`,
here we specify hyperparemeters,
instantiate
an encoder and a decoder with Bahdanau attention,
and train this model for machine translation.
Due to the newly added attention mechanism,
this training is much slower than
that in :numref:`sec*seq2seq*training` without attention mechanisms.

```{.python .input}
# @tab all
embed*size, num*hiddens, num_layers, dropout = 32, 32, 2, 0.1
batch*size, num*steps = 64, 10
lr, num*epochs, device = 0.005, 250, d2l.try*gpu()

train*iter, src*vocab, tgt*vocab = d2l.load*data*nmt(batch*size, num_steps)
encoder = d2l.Seq2SeqEncoder(
    len(src*vocab), embed*size, num*hiddens, num*layers, dropout)
decoder = Seq2SeqAttentionDecoder(
    len(tgt*vocab), embed*size, num*hiddens, num*layers, dropout)
net = d2l.EncoderDecoder(encoder, decoder)
d2l.train*seq2seq(net, train*iter, lr, num*epochs, tgt*vocab, device)
```

After the model is trained,
we use it to translate a few English sentences
into French and compute their BLEU scores.

```{.python .input}
# @tab all
engs = ['go .', "i lost .", 'he\'s calm .', 'i\'m home .']
fras = ['va !', 'j\'ai perdu .', 'il est calme .', 'je suis chez moi .']
for eng, fra in zip(engs, fras):
    translation, dec*attention*weight*seq = d2l.predict*seq2seq(
        net, eng, src*vocab, tgt*vocab, num_steps, device, True)
    print(f'{eng} => {translation}, ',
          f'bleu {d2l.bleu(translation, fra, k=2):.3f}')
```

```{.python .input}
# @tab all
attention_weights = d2l.reshape(
    d2l.concat([step[0][0][0] for step in dec*attention*weight_seq], 0),
    (1, 1, -1, num_steps))
```

By visualizing the attention weights
when translating the last English sentence,
we can see that each query assigns non-uniform weights
over key-value pairs.
It shows that at each decoding step,
different parts of the input sequences 
are selectively aggregated in the attention pooling.

```{.python .input}
# Plus one to include the end-of-sequence token
d2l.show_heatmaps(
    attention_weights[:, :, :, :len(engs[-1].split()) + 1],
    xlabel='Key posistions', ylabel='Query posistions')
```

```{.python .input}
# @tab pytorch
# Plus one to include the end-of-sequence token
d2l.show_heatmaps(
    attention_weights[:, :, :, :len(engs[-1].split()) + 1].cpu(),
    xlabel='Key posistions', ylabel='Query posistions')
```

# # Summary

* When predicting a token, if not all the input tokens are relevant, the RNN encoder-decoder with Bahdanau attention selectively aggregates different parts of the input sequence. This is achieved by treating the context variable as an output of additive attention pooling.
* In the RNN encoder-decoder, Bahdanau attention treats the decoder hidden state at the previous time step as the query, and the encoder hidden states at all the time steps as both the keys and values.


# # Exercises

1. Replace GRU with LSTM in the experiment.
1. Modify the experiment to replace the additive attention scoring function with the scaled dot-product. How does it influence the training efficiency?


:begin_tab:`mxnet`
[Discussions](https://discuss.d2l.ai/t/347)
:end_tab:

:begin_tab:`pytorch`
[Discussions](https://discuss.d2l.ai/t/1065)
:end_tab:
