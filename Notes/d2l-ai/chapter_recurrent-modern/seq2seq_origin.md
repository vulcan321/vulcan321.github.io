#  Sequence to Sequence Learning
:label:`sec_seq2seq`

As we have seen in :numref:`sec*machine*translation`,
in machine translation
both the input and output are a variable-length sequence.
To address this type of problem,
we have designed a general encoder-decoder architecture
in :numref:`sec_encoder-decoder`.
In this section,
we will
use two RNNs to design
the encoder and the decoder of
this architecture
and apply it to *sequence to sequence* learning
for machine translation
:cite:`Sutskever.Vinyals.Le.2014,Cho.Van-Merrienboer.Gulcehre.ea.2014`.

Following the design principle
of the encoder-decoder architecture,
the RNN encoder can
take a variable-length sequence as the input and transforms it into a fixed-shape hidden state.
In other words,
information of the input (source) sequence
is *encoded* in the hidden state of the RNN encoder.
To generate the output sequence token by token,
a separate RNN decoder
can predict the next token based on
what tokens have been seen (such as in language modeling) or generated,
together with the encoded information of the input sequence.
:numref:`fig_seq2seq` illustrates
how to use two RNNs
for sequence to sequence learning
in machine translation.


![Sequence to sequence learning with an RNN encoder and an RNN decoder.](../img/seq2seq.svg)
:label:`fig_seq2seq`

In :numref:`fig_seq2seq`,
the special "&lt;eos&gt;" token
marks the end of the sequence.
The model can stop making predictions
once this token is generated.
At the initial time step of the RNN decoder,
there are two special design decisions.
First, the special beginning-of-sequence "&lt;bos&gt;" token is an input.
Second,
the final hidden state of the RNN encoder is used
to initiate the hidden state of the decoder.
In designs such as :cite:`Sutskever.Vinyals.Le.2014`,
this is exactly
how the encoded input sequence information
is fed into the decoder for generating the output (target) sequence.
In some other designs such as :cite:`Cho.Van-Merrienboer.Gulcehre.ea.2014`,
the final hidden state of the encoder
is also fed into the decoder as
part of the inputs
at every time step as shown in :numref:`fig_seq2seq`.
Similar to the training of language models in
:numref:`sec*language*model`,
we can allow the labels to be the original output sequence,
shifted by one token:
"&lt;bos&gt;", "Ils", "regardent", "." $\rightarrow$
"Ils", "regardent", ".", "&lt;eos&gt;".


In the following,
we will explain the design of :numref:`fig_seq2seq`
in greater detail.
We will train this model for machine translation
on the English-French dataset as introduced in
:numref:`sec*machine*translation`.

```{.python .input}
import collections
from d2l import mxnet as d2l
import math
from mxnet import np, npx, init, gluon, autograd
from mxnet.gluon import nn, rnn
npx.set_np()
```

```{.python .input}
# @tab pytorch
import collections
from d2l import torch as d2l
import math
import torch
from torch import nn
```

# # Encoder

Technically speaking,
the encoder transforms an input sequence of variable length into a fixed-shape *context variable* $\mathbf{c}$, and encodes the input sequence information in this context variable.
As depicted in :numref:`fig_seq2seq`,
we can use an RNN to design the encoder.

Let us consider a sequence example (batch size: 1).
Suppose that
the input sequence is $x*1, \ldots, x*T$, such that $x_t$ is the $t^{\mathrm{th}}$ token in the input text sequence.
At time step $t$, the RNN transforms
the input feature vector $\mathbf{x}*t$ for $x*t$
and the hidden state $\mathbf{h} _{t-1}$ from the previous time step
into the current hidden state $\mathbf{h}_t$.
We can use a function $f$ to express the transformation of the RNN's recurrent layer:

$$\mathbf{h}*t = f(\mathbf{x}*t, \mathbf{h}_{t-1}). $$

In general,
the encoder transforms the hidden states at
all the time steps
into the context variable through a customized function $q$:

$$\mathbf{c} =  q(\mathbf{h}*1, \ldots, \mathbf{h}*T).$$

For example, when choosing $q(\mathbf{h}*1, \ldots, \mathbf{h}*T) = \mathbf{h}*T$ such as in :numref:`fig*seq2seq`,
the context variable is just the hidden state $\mathbf{h}_T$
of the input sequence at the final time step.

So far we have used a unidirectional RNN
to design the encoder,
where
a hidden state only depends on
the input subsequence at and before the time step of the hidden state.
We can also construct encoders using bidirectional RNNs. In this case, a hidden state depends on
the subsequence before and after the time step (including the input at the current time step), which encodes the information of the entire sequence.


Now let us implement the RNN encoder.
Note that we use an *embedding layer*
to obtain the feature vector for each token in the input sequence.
The weight
of an embedding layer
is a matrix
whose number of rows equals to the size of the input vocabulary (`vocab_size`)
and number of columns equals to the feature vector's dimension (`embed_size`).
For any input token index $i$,
the embedding layer
fetches the $i^{\mathrm{th}}$ row (starting from 0) of the weight matrix
to return its feature vector.
Besides,
here we choose a multilayer GRU to
implement the encoder.

```{.python .input}
# @save
class Seq2SeqEncoder(d2l.Encoder):
    """The RNN encoder for sequence to sequence learning."""
    def **init**(self, vocab*size, embed*size, num*hiddens, num*layers,
                 dropout=0, **kwargs):
        super(Seq2SeqEncoder, self).**init**(**kwargs)
        # Embedding layer
        self.embedding = nn.Embedding(vocab*size, embed*size)
        self.rnn = rnn.GRU(num*hiddens, num*layers, dropout=dropout)

    def forward(self, X, *args):
        # The output `X` shape: (`batch*size`, `num*steps`, `embed_size`)
        X = self.embedding(X)
        # In RNN models, the first axis corresponds to time steps
        X = X.swapaxes(0, 1)
        state = self.rnn.begin*state(batch*size=X.shape[1], ctx=X.ctx)
        output, state = self.rnn(X, state)
        # `output` shape: (`num*steps`, `batch*size`, `num_hiddens`)
        # `state[0]` shape: (`num*layers`, `batch*size`, `num_hiddens`)
        return output, state
```

```{.python .input}
# @tab pytorch
# @save
class Seq2SeqEncoder(d2l.Encoder):
    """The RNN encoder for sequence to sequence learning."""
    def **init**(self, vocab*size, embed*size, num*hiddens, num*layers,
                 dropout=0, **kwargs):
        super(Seq2SeqEncoder, self).**init**(**kwargs)
        # Embedding layer
        self.embedding = nn.Embedding(vocab*size, embed*size)
        self.rnn = nn.GRU(embed*size, num*hiddens, num_layers,
                          dropout=dropout)

    def forward(self, X, *args):
        # The output `X` shape: (`batch*size`, `num*steps`, `embed_size`)
        X = self.embedding(X)
        # In RNN models, the first axis corresponds to time steps
        X = X.permute(1, 0, 2)
        # When state is not mentioned, it defaults to zeros
        output, state = self.rnn(X)
        # `output` shape: (`num*steps`, `batch*size`, `num_hiddens`)
        # `state` shape: (`num*layers`, `batch*size`, `num_hiddens`)
        return output, state
```

The returned variables of recurrent layers
have been explained in :numref:`sec_rnn-concise`.
Let us still use a concrete example
to illustrate the above encoder implementation.
Below
we instantiate a two-layer GRU encoder
whose number of hidden units is 16.
Given
a minibatch of sequence inputs `X`
(batch size: 4, number of time steps: 7),
the hidden states of the last layer
at all the time steps
(`output` return by the encoder's recurrent layers)
are a tensor
of shape
(number of time steps, batch size, number of hidden units).

```{.python .input}
encoder = Seq2SeqEncoder(vocab*size=10, embed*size=8, num_hiddens=16,
                         num_layers=2)
encoder.initialize()
X = d2l.zeros((4, 7))
output, state = encoder(X)
output.shape
```

```{.python .input}
# @tab pytorch
encoder = Seq2SeqEncoder(vocab*size=10, embed*size=8, num_hiddens=16,
                         num_layers=2)
encoder.eval()
X = d2l.zeros((4, 7), dtype=torch.long)
output, state = encoder(X)
output.shape
```

Since a GRU is employed here,
the shape of the multilayer hidden states
at the final time step
is
(number of hidden layers, batch size, number of hidden units).
If an LSTM is used,
memory cell information will also be contained in `state`.

```{.python .input}
len(state), state[0].shape
```

```{.python .input}
# @tab pytorch
state.shape
```

# # Decoder
:label:`sec*seq2seq*decoder`

As we just mentioned,
the context variable $\mathbf{c}$ of the encoder's output encodes the entire input sequence $x*1, \ldots, x*T$. Given the output sequence $y*1, y*2, \ldots, y_{T'}$ from the training dataset,
for each time step $t'$
(the symbol differs from the time step $t$ of input sequences or encoders),
the probability of the decoder output $y_{t'}$
is conditional
on the previous output subsequence
$y*1, \ldots, y*{t'-1}$ and
the context variable $\mathbf{c}$, i.e., $P(y*{t'} \mid y*1, \ldots, y_{t'-1}, \mathbf{c})$.

To model this conditional probability on sequences,
we can use another RNN as the decoder.
At any time step $t^\prime$ on the output sequence,
the RNN takes the output $y_{t^\prime-1}$ from the previous time step
and the context variable $\mathbf{c}$ as its input,
then transforms
them and
the previous hidden state $\mathbf{s}_{t^\prime-1}$
into the
hidden state $\mathbf{s}_{t^\prime}$ at the current time step.
As a result, we can use a function $g$ to express the transformation of the decoder's hidden layer:

$$\mathbf{s}*{t^\prime} = g(y*{t^\prime-1}, \mathbf{c}, \mathbf{s}_{t^\prime-1}).$$
:eqlabel:`eq*seq2seq*s_t`

After obtaining the hidden state of the decoder,
we can use an output layer and the softmax operation to compute the conditional probability distribution
$P(y*{t^\prime} \mid y*1, \ldots, y_{t^\prime-1}, \mathbf{c})$ for the output at time step $t^\prime$.

Following :numref:`fig_seq2seq`,
when implementing the decoder as follows,
we directly use the hidden state at the final time step
of the encoder
to initialize the hidden state of the decoder.
This requires that the RNN encoder and the RNN decoder have the same number of layers and hidden units.
To further incorporate the encoded input sequence information,
the context variable is concatenated
with the decoder input at all the time steps.
To predict the probability distribution of the output token,
a fully-connected layer is used to transform
the hidden state at the final layer of the RNN decoder.

```{.python .input}
class Seq2SeqDecoder(d2l.Decoder):
    """The RNN decoder for sequence to sequence learning."""
    def **init**(self, vocab*size, embed*size, num*hiddens, num*layers,
                 dropout=0, **kwargs):
        super(Seq2SeqDecoder, self).**init**(**kwargs)
        self.embedding = nn.Embedding(vocab*size, embed*size)
        self.rnn = rnn.GRU(num*hiddens, num*layers, dropout=dropout)
        self.dense = nn.Dense(vocab_size, flatten=False)

    def init*state(self, enc*outputs, *args):
        return enc_outputs[1]

    def forward(self, X, state):
        # The output `X` shape: (`num*steps`, `batch*size`, `embed_size`)
        X = self.embedding(X).swapaxes(0, 1)
        # `context` shape: (`batch*size`, `num*hiddens`)
        context = state[0][-1]
        # Broadcast `context` so it has the same `num_steps` as `X`
        context = np.broadcast_to(context, (
            X.shape[0], context.shape[0], context.shape[1]))
        X*and*context = d2l.concat((X, context), 2)
        output, state = self.rnn(X*and*context, state)
        output = self.dense(output).swapaxes(0, 1)
        # `output` shape: (`batch*size`, `num*steps`, `vocab_size`)
        # `state[0]` shape: (`num*layers`, `batch*size`, `num_hiddens`)
        return output, state
```

```{.python .input}
# @tab pytorch
class Seq2SeqDecoder(d2l.Decoder):
    """The RNN decoder for sequence to sequence learning."""
    def **init**(self, vocab*size, embed*size, num*hiddens, num*layers,
                 dropout=0, **kwargs):
        super(Seq2SeqDecoder, self).**init**(**kwargs)
        self.embedding = nn.Embedding(vocab*size, embed*size)
        self.rnn = nn.GRU(embed*size + num*hiddens, num*hiddens, num*layers,
                          dropout=dropout)
        self.dense = nn.Linear(num*hiddens, vocab*size)

    def init*state(self, enc*outputs, *args):
        return enc_outputs[1]

    def forward(self, X, state):
        # The output `X` shape: (`num*steps`, `batch*size`, `embed_size`)
        X = self.embedding(X).permute(1, 0, 2)
        # Broadcast `context` so it has the same `num_steps` as `X`
        context = state[-1].repeat(X.shape[0], 1, 1)
        X*and*context = d2l.concat((X, context), 2)
        output, state = self.rnn(X*and*context, state)
        output = self.dense(output).permute(1, 0, 2)
        # `output` shape: (`batch*size`, `num*steps`, `vocab_size`)
        # `state` shape: (`num*layers`, `batch*size`, `num_hiddens`)
        return output, state
```

To illustrate the implemented decoder,
below we instantiate it with the same hyperparameters from the aforementioned encoder.
As we can see, the output shape of the decoder becomes (batch size, number of time steps, vocabulary size),
where the last dimension of the tensor stores the predicted token distribution.

```{.python .input}
decoder = Seq2SeqDecoder(vocab*size=10, embed*size=8, num_hiddens=16,
                         num_layers=2)
decoder.initialize()
state = decoder.init_state(encoder(X))
output, state = decoder(X, state)
output.shape, len(state), state[0].shape
```

```{.python .input}
# @tab pytorch
decoder = Seq2SeqDecoder(vocab*size=10, embed*size=8, num_hiddens=16,
                         num_layers=2)
decoder.eval()
state = decoder.init_state(encoder(X))
output, state = decoder(X, state)
output.shape, state.shape
```

To summarize,
the layers in the above RNN encoder-decoder model are illustrated in :numref:`fig*seq2seq*details`.

![Layers in an RNN encoder-decoder model.](../img/seq2seq-details.svg)
:label:`fig*seq2seq*details`

# # Loss Function

At each time step, the decoder
predicts a probability distribution for the output tokens.
Similar to language modeling,
we can apply softmax to obtain the distribution
and calculate the cross-entropy loss for optimization.
Recall :numref:`sec*machine*translation`
that the special padding tokens
are appended to the end of sequences
so sequences of varying lengths
can be efficiently loaded
in minibatches of the same shape.
However,
prediction of padding tokens
should be excluded from loss calculations.

To this end,
we can use the following
`sequence_mask` function
to mask irrelevant entries with zero values
so later
multiplication of any irrelevant prediction
with zero equals to zero.
For example,
if the valid length of two sequences
excluding padding tokens
are one and two, respectively,
the remaining entries after
the first one
and the first two entries are cleared to zeros.

```{.python .input}
X = np.array([[1, 2, 3], [4, 5, 6]])
npx.sequence_mask(X, np.array([1, 2]), True, axis=1)
```

```{.python .input}
# @tab pytorch
# @save
def sequence*mask(X, valid*len, value=0):
    """Mask irrelevant entries in sequences."""
    maxlen = X.size(1)
    mask = torch.arange((maxlen), dtype=torch.float32,
                        device=X.device)[None, :] < valid_len[:, None]
    X[~mask] = value
    return X

X = torch.tensor([[1, 2, 3], [4, 5, 6]])
sequence_mask(X, torch.tensor([1, 2]))
```

We can also mask all the entries across the last
few axes.
If you like, you may even specify
to replace such entries with a non-zero value.

```{.python .input}
X = d2l.ones((2, 3, 4))
npx.sequence_mask(X, np.array([1, 2]), True, value=-1, axis=1)
```

```{.python .input}
# @tab pytorch
X = d2l.ones(2, 3, 4)
sequence_mask(X, torch.tensor([1, 2]), value=-1)
```

Now we can extend the softmax cross-entropy loss
to allow the masking of irrelevant predictions.
Initially,
masks for all the predicted tokens are set to one.
Once the valid length is given,
the mask corresponding to any padding token
will be cleared to zero.
In the end,
the loss for all the tokens
will be multipled by the mask to filter out
irrelevant predictions of padding tokens in the loss.

```{.python .input}
# @save
class MaskedSoftmaxCELoss(gluon.loss.SoftmaxCELoss):
    """The softmax cross-entropy loss with masks."""
    # `pred` shape: (`batch*size`, `num*steps`, `vocab_size`)
    # `label` shape: (`batch*size`, `num*steps`)
    # `valid*len` shape: (`batch*size`,)
    def forward(self, pred, label, valid_len):
        # `weights` shape: (`batch*size`, `num*steps`, 1)
        weights = np.expand*dims(np.ones*like(label), axis=-1)
        weights = npx.sequence*mask(weights, valid*len, True, axis=1)
        return super(MaskedSoftmaxCELoss, self).forward(pred, label, weights)
```

```{.python .input}
# @tab pytorch
# @save
class MaskedSoftmaxCELoss(nn.CrossEntropyLoss):
    """The softmax cross-entropy loss with masks."""
    # `pred` shape: (`batch*size`, `num*steps`, `vocab_size`)
    # `label` shape: (`batch*size`, `num*steps`)
    # `valid*len` shape: (`batch*size`,)
    def forward(self, pred, label, valid_len):
        weights = torch.ones_like(label)
        weights = sequence*mask(weights, valid*len)
        self.reduction='none'
        unweighted_loss = super(MaskedSoftmaxCELoss, self).forward(
            pred.permute(0, 2, 1), label)
        weighted*loss = (unweighted*loss * weights).mean(dim=1)
        return weighted_loss
```

For a sanity check, we can create three identical sequences.
Then we can
specify that the valid lengths of these sequences
are 4, 2, and 0, respectively.
As a result,
the loss of the first sequence
should be twice as large as that of the second sequence,
while the third sequence should have a zero loss.

```{.python .input}
loss = MaskedSoftmaxCELoss()
loss(d2l.ones((3, 4, 10)), d2l.ones((3, 4)), np.array([4, 2, 0]))
```

```{.python .input}
# @tab pytorch
loss = MaskedSoftmaxCELoss()
loss(d2l.ones(3, 4, 10), d2l.ones((3, 4), dtype=torch.long),
     torch.tensor([4, 2, 0]))
```

# # Training
:label:`sec*seq2seq*training`

In the following training loop,
we concatenate the special beginning-of-sequence token
and the original output sequence excluding the final token as
the input to the decoder, as shown in :numref:`fig_seq2seq`.
This is called *teacher forcing* because
the original output sequence (token labels) is fed into the decoder.
Alternatively,
we could also feed the *predicted* token
from the previous time step
as the current input to the decoder.

```{.python .input}
# @save
def train*seq2seq(net, data*iter, lr, num*epochs, tgt*vocab, device):
    """Train a model for sequence to sequence."""
    net.initialize(init.Xavier(), force_reinit=True, ctx=device)
    trainer = gluon.Trainer(net.collect_params(), 'adam',
                            {'learning_rate': lr})
    loss = MaskedSoftmaxCELoss()
    animator = d2l.Animator(xlabel='epoch', ylabel='loss',
                            xlim=[10, num_epochs])
    for epoch in range(num_epochs):
        timer = d2l.Timer()
        metric = d2l.Accumulator(2)  # Sum of training loss, no. of tokens
        for batch in data_iter:
            X, X*valid*len, Y, Y*valid*len = [
                x.as*in*ctx(device) for x in batch]
            bos = np.array(
                [tgt_vocab['<bos>']] * Y.shape[0], ctx=device).reshape(-1, 1)
            dec_input = d2l.concat([bos, Y[:, :-1]], 1)  # Teacher forcing
            with autograd.record():
                Y*hat, * = net(X, dec*input, X*valid_len)
                l = loss(Y*hat, Y, Y*valid_len)
            l.backward()
            d2l.grad_clipping(net, 1)
            num*tokens = Y*valid_len.sum()
            trainer.step(num_tokens)
            metric.add(l.sum(), num_tokens)
        if (epoch + 1) % 10 == 0:
            animator.add(epoch + 1, (metric[0] / metric[1],))
    print(f'loss {metric[0] / metric[1]:.3f}, {metric[1] / timer.stop():.1f} '
          f'tokens/sec on {str(device)}')
```

```{.python .input}
# @tab pytorch
# @save
def train*seq2seq(net, data*iter, lr, num*epochs, tgt*vocab, device):
    """Train a model for sequence to sequence."""
    def xavier*init*weights(m):
        if type(m) == nn.Linear:
            nn.init.xavier*uniform*(m.weight)
        if type(m) == nn.GRU:
            for param in m.*flat*weights_names:
                if "weight" in param:
                    nn.init.xavier*uniform*(m._parameters[param])
    net.apply(xavier*init*weights)
    net.to(device)
    optimizer = torch.optim.Adam(net.parameters(), lr=lr)
    loss = MaskedSoftmaxCELoss()
    net.train()
    animator = d2l.Animator(xlabel='epoch', ylabel='loss',
                            xlim=[10, num_epochs])
    for epoch in range(num_epochs):
        timer = d2l.Timer()
        metric = d2l.Accumulator(2)  # Sum of training loss, no. of tokens
        for batch in data_iter:
            X, X*valid*len, Y, Y*valid*len = [x.to(device) for x in batch]
            bos = torch.tensor([tgt_vocab['<bos>']] * Y.shape[0],
                               device=device).reshape(-1, 1)
            dec_input = d2l.concat([bos, Y[:, :-1]], 1)  # Teacher forcing
            Y*hat, * = net(X, dec*input, X*valid_len)
            l = loss(Y*hat, Y, Y*valid_len)
            l.sum().backward()  # Make the loss scalar for `backward`
            d2l.grad_clipping(net, 1)
            num*tokens = Y*valid_len.sum()
            optimizer.step()
            with torch.no_grad():
                metric.add(l.sum(), num_tokens)
        if (epoch + 1) % 10 == 0:
            animator.add(epoch + 1, (metric[0] / metric[1],))
    print(f'loss {metric[0] / metric[1]:.3f}, {metric[1] / timer.stop():.1f} '
          f'tokens/sec on {str(device)}')
```

Now we can create and train an RNN encoder-decoder model
for sequence to sequence learning on the machine translation dataset.

```{.python .input}
# @tab all
embed*size, num*hiddens, num_layers, dropout = 32, 32, 2, 0.1
batch*size, num*steps = 64, 10
lr, num*epochs, device = 0.005, 300, d2l.try*gpu()

train*iter, src*vocab, tgt*vocab = d2l.load*data*nmt(batch*size, num_steps)
encoder = Seq2SeqEncoder(
    len(src*vocab), embed*size, num*hiddens, num*layers, dropout)
decoder = Seq2SeqDecoder(
    len(tgt*vocab), embed*size, num*hiddens, num*layers, dropout)
net = d2l.EncoderDecoder(encoder, decoder)
train*seq2seq(net, train*iter, lr, num*epochs, tgt*vocab, device)
```

# # Prediction

To predict the output sequence
token by token,
at each decoder time step
the predicted token from the previous
time step is fed into the decoder as an input.
Similar to training,
at the initial time step
the beginning-of-sequence ("&lt;bos&gt;") token
is fed into the decoder.
This prediction process
is illustrated in :numref:`fig*seq2seq*predict`.
When the end-of-sequence ("&lt;eos&gt;") token is predicted,
the prediction of the output sequence is complete.


![Predicting the output sequence token by token using an RNN encoder-decoder.](../img/seq2seq-predict.svg)
:label:`fig*seq2seq*predict`

We will introduce different
strategies for sequence generation in
:numref:`sec_beam-search`.

```{.python .input}
# @save
def predict*seq2seq(net, src*sentence, src*vocab, tgt*vocab, num_steps,
                    device, save*attention*weights=False):
    """Predict for sequence to sequence."""
    src*tokens = src*vocab[src_sentence.lower().split(' ')] + [
        src_vocab['<eos>']]
    enc*valid*len = np.array([len(src_tokens)], ctx=device)
    src*tokens = d2l.truncate*pad(src*tokens, num*steps, src_vocab['<pad>'])
    # Add the batch axis
    enc*X = np.expand*dims(np.array(src_tokens, ctx=device), axis=0)
    enc*outputs = net.encoder(enc*X, enc*valid*len)
    dec*state = net.decoder.init*state(enc*outputs, enc*valid_len)
    # Add the batch axis
    dec*X = np.expand*dims(np.array([tgt_vocab['<bos>']], ctx=device), axis=0)
    output*seq, attention*weight_seq = [], []
    for * in range(num*steps):
        Y, dec*state = net.decoder(dec*X, dec_state)
        # We use the token with the highest prediction likelihood as the input
        # of the decoder at the next time step
        dec_X = Y.argmax(axis=2)
        pred = dec_X.squeeze(axis=0).astype('int32').item()
        # Save attention weights (to be covered later)
        if save*attention*weights:
            attention*weight*seq.append(net.decoder.attention_weights)
        # Once the end-of-sequence token is predicted, the generation of the
        # output sequence is complete
        if pred == tgt_vocab['<eos>']:
            break
        output_seq.append(pred)
    return ' '.join(tgt*vocab.to*tokens(output*seq)), attention*weight_seq
```

```{.python .input}
# @tab pytorch
# @save
def predict*seq2seq(net, src*sentence, src*vocab, tgt*vocab, num_steps,
                    device, save*attention*weights=False):
    """Predict for sequence to sequence."""
    # Set `net` to eval mode for inference
    net.eval()
    src*tokens = src*vocab[src_sentence.lower().split(' ')] + [
        src_vocab['<eos>']]
    enc*valid*len = torch.tensor([len(src_tokens)], device=device)
    src*tokens = d2l.truncate*pad(src*tokens, num*steps, src_vocab['<pad>'])
    # Add the batch axis
    enc_X = torch.unsqueeze(
        torch.tensor(src_tokens, dtype=torch.long, device=device), dim=0)
    enc*outputs = net.encoder(enc*X, enc*valid*len)
    dec*state = net.decoder.init*state(enc*outputs, enc*valid_len)
    # Add the batch axis
    dec_X = torch.unsqueeze(torch.tensor(
        [tgt_vocab['<bos>']], dtype=torch.long, device=device), dim=0)
    output*seq, attention*weight_seq = [], []
    for * in range(num*steps):
        Y, dec*state = net.decoder(dec*X, dec_state)
        # We use the token with the highest prediction likelihood as the input
        # of the decoder at the next time step
        dec_X = Y.argmax(dim=2)
        pred = dec_X.squeeze(dim=0).type(torch.int32).item()
        # Save attention weights (to be covered later)
        if save*attention*weights:
            attention*weight*seq.append(net.decoder.attention_weights)
        # Once the end-of-sequence token is predicted, the generation of the
        # output sequence is complete
        if pred == tgt_vocab['<eos>']:
            break
        output_seq.append(pred)
    return ' '.join(tgt*vocab.to*tokens(output*seq)), attention*weight_seq
```

# # Evaluation of Predicted Sequences

We can evaluate a predicted sequence
by comparing it with the
label sequence (the ground-truth).
BLEU (Bilingual Evaluation Understudy),
though originally proposed for evaluating
machine translation results :cite:`Papineni.Roukos.Ward.ea.2002`,
has been extensively used in measuring
the quality of output sequences for different applications.
In principle, for any $n$-grams in the predicted sequence,
BLEU evaluates whether this $n$-grams appears
in the label sequence.

Denote by $p_n$
the precision of $n$-grams,
which is
the ratio of
the number of matched $n$-grams in
the predicted and label sequences
to
the number of $n$-grams in the predicted sequence.
To explain,
given a label sequence $A$, $B$, $C$, $D$, $E$, $F$,
and a predicted sequence $A$, $B$, $B$, $C$, $D$,
we have $p*1 = 4/5$,  $p*2 = 3/4$, $p*3 = 1/3$, and $p*4 = 0$.
Besides,
let $\mathrm{len}*{\text{label}}$ and $\mathrm{len}*{\text{pred}}$
be
the numbers of tokens in the label sequence and the predicted sequence, respectively.
Then, BLEU is defined as

$$ \exp\left(\min\left(0, 1 - \frac{\mathrm{len}*{\text{label}}}{\mathrm{len}*{\text{pred}}}\right)\right) \prod*{n=1}^k p*n^{1/2^n},$$
:eqlabel:`eq_bleu`

where $k$ is the longest $n$-grams for matching.

Based on the definition of BLEU in :eqref:`eq_bleu`,
whenever the predicted sequence is the same as the label sequence, BLEU is 1.
Moreover,
since matching longer $n$-grams is more difficult,
BLEU assigns a greater weight
to a longer $n$-gram precision.
Specifically, when $p_n$ is fixed,
$p*n^{1/2^n}$ increases as $n$ grows (the original paper uses $p*n^{1/n}$).
Furthermore,
since
predicting shorter sequences
tends to obtain a higher $p_n$ value,
the coefficient before the multiplication term in :eqref:`eq_bleu`
penalizes shorter predicted sequences.
For example, when $k=2$,
given the label sequence $A$, $B$, $C$, $D$, $E$, $F$ and the predicted sequence $A$, $B$,
although $p*1 = p*2 = 1$, the penalty factor $\exp(1-6/2) \approx 0.14$ lowers the BLEU.

We implement the BLEU measure as follows.

```{.python .input}
# @tab all
def bleu(pred*seq, label*seq, k):  # @save
    """Compute the BLEU."""
    pred*tokens, label*tokens = pred*seq.split(' '), label*seq.split(' ')
    len*pred, len*label = len(pred*tokens), len(label*tokens)
    score = math.exp(min(0, 1 - len*label / len*pred))
    for n in range(1, k + 1):
        num*matches, label*subs = 0, collections.defaultdict(int)
        for i in range(len_label - n + 1):
            label*subs[''.join(label*tokens[i: i + n])] += 1
        for i in range(len_pred - n + 1):
            if label*subs[''.join(pred*tokens[i: i + n])] > 0:
                num_matches += 1
                label*subs[''.join(pred*tokens[i: i + n])] -= 1
        score *= math.pow(num*matches / (len*pred - n + 1), math.pow(0.5, n))
    return score
```

In the end,
we use the trained RNN encoder-decoder
to translate a few English sentences into French
and compute the BLEU of the results.

```{.python .input}
# @tab all
engs = ['go .', "i lost .", 'he\'s calm .', 'i\'m home .']
fras = ['va !', 'j\'ai perdu .', 'il est calme .', 'je suis chez moi .']
for eng, fra in zip(engs, fras):
    translation, attention*weight*seq = predict_seq2seq(
        net, eng, src*vocab, tgt*vocab, num_steps, device)
    print(f'{eng} => {translation}, bleu {bleu(translation, fra, k=2):.3f}')
```

# # Summary

* Following the design of the encoder-decoder architecture, we can use two RNNs to design a model for sequence to sequence learning.
* When implementing the encoder and the decoder, we can use multilayer RNNs.
* We can use masks to filter out irrelevant computations, such as when calculating the loss.
* In encoder-decoder training, the teacher forcing approach feeds original output sequences (in contrast to predictions) into the decoder.
* BLEU is a popular measure for evaluating output sequences by matching $n$-grams between the predicted sequence and the label sequence.


# # Exercises

1. Can you adjust the hyperparameters to improve the translation results?
1. Rerun the experiment without using masks in the loss calculation. What results do you observe? Why?
1. If the encoder and the decoder differ in the number of layers or the number of hidden units, how can we initialize the hidden state of the decoder?
1. In training, replace teacher forcing with feeding the prediction at the previous time step into the decoder. How does this influence the performance?
1. Rerun the experiment by replacing GRU with LSTM.
1. Are there any other ways to design the output layer of the decoder?

:begin_tab:`mxnet`
[Discussions](https://discuss.d2l.ai/t/345)
:end_tab:

:begin_tab:`pytorch`
[Discussions](https://discuss.d2l.ai/t/1062)
:end_tab:
