# Adam
:label:`sec_adam`

In the discussions leading up to this section we encountered a number of techniques for efficient optimization. Let's recap them in detail here:

* We saw that :numref:`sec_sgd` is more effective than Gradient Descent when solving optimization problems, e.g., due to its inherent resilience to redundant data. 
* We saw that :numref:`sec*minibatch*sgd` affords significant additional efficiency arising from vectorization, using larger sets of observations in one minibatch. This is the key to efficient multi-machine, multi-GPU and overall parallel processing. 
* :numref:`sec_momentum` added a mechanism for aggregating a history of past gradients to accelerate convergence.
* :numref:`sec_adagrad` used per-coordinate scaling to allow for a computationally efficient preconditioner. 
* :numref:`sec_rmsprop` decoupled per-coordinate scaling from a learning rate adjustment. 

Adam :cite:`Kingma.Ba.2014` combines all these techniques into one efficient learning algorithm. As expected, this is an algorithm that has become rather popular as one of the more robust and effective optimization algorithms to use in deep learning. It is not without issues, though. In particular, :cite:`Reddi.Kale.Kumar.2019` show that there are situations where Adam can diverge due to poor variance control. In a follow-up work :cite:`Zaheer.Reddi.Sachan.ea.2018` proposed a hotfix to Adam, called Yogi which addresses these issues. More on this later. For now let's review the Adam algorithm. 

# # The Algorithm

One of the key components of Adam is that it uses exponential weighted moving averages (also known as leaky averaging) to obtain an estimate of both the momentum and also the second moment of the gradient. That is, it uses the state variables

$$\begin{aligned}
    \mathbf{v}*t & \leftarrow \beta*1 \mathbf{v}*{t-1} + (1 - \beta*1) \mathbf{g}_t, \\
    \mathbf{s}*t & \leftarrow \beta*2 \mathbf{s}*{t-1} + (1 - \beta*2) \mathbf{g}_t^2.
\end{aligned}$$

Here $\beta*1$ and $\beta*2$ are nonnegative weighting parameters. Common choices for them are $\beta*1 = 0.9$ and $\beta*2 = 0.999$. That is, the variance estimate moves *much more slowly* than the momentum term. Note that if we initialize $\mathbf{v}*0 = \mathbf{s}*0 = 0$ we have a significant amount of bias initially towards smaller values. This can be addressed by using the fact that $\sum_{i=0}^t \beta^i = \frac{1 - \beta^t}{1 - \beta}$ to re-normalize terms. Correspondingly the normalized state variables are given by 

$$\hat{\mathbf{v}}*t = \frac{\mathbf{v}*t}{1 - \beta*1^t} \text{ and } \hat{\mathbf{s}}*t = \frac{\mathbf{s}*t}{1 - \beta*2^t}.$$

Armed with the proper estimates we can now write out the update equations. First, we rescale the gradient in a manner very much akin to that of RMSProp to obtain

$$\mathbf{g}*t' = \frac{\eta \hat{\mathbf{v}}*t}{\sqrt{\hat{\mathbf{s}}_t} + \epsilon}.$$

Unlike RMSProp our update uses the momentum $\hat{\mathbf{v}}*t$ rather than the gradient itself. Moreover, there is a slight cosmetic difference as the rescaling happens using $\frac{1}{\sqrt{\hat{\mathbf{s}}*t} + \epsilon}$ instead of $\frac{1}{\sqrt{\hat{\mathbf{s}}_t + \epsilon}}$. The former works arguably slightly better in practice, hence the deviation from RMSProp. Typically we pick $\epsilon = 10^{-6}$ for a good trade-off between numerical stability and fidelity. 

Now we have all the pieces in place to compute updates. This is slightly anticlimactic and we have a simple update of the form

$$\mathbf{x}*t \leftarrow \mathbf{x}*{t-1} - \mathbf{g}_t'.$$

Reviewing the design of Adam its inspiration is clear. Momentum and scale are clearly visible in the state variables. Their rather peculiar definition forces us to debias terms (this could be fixed by a slightly different initialization and update condition). Second, the combination of both terms is pretty straightforward, given RMSProp. Last, the explicit learning rate $\eta$ allows us to control the step length to address issues of convergence. 

# # Implementation 

Implementing Adam from scratch is not very daunting. For convenience we store the time step counter $t$ in the `hyperparams` dictionary. Beyond that all is straightforward.

```{.python .input}
%matplotlib inline
from d2l import mxnet as d2l
from mxnet import np, npx
npx.set_np()

def init*adam*states(feature_dim):
    v*w, v*b = d2l.zeros((feature_dim, 1)), d2l.zeros(1)
    s*w, s*b = d2l.zeros((feature_dim, 1)), d2l.zeros(1)
    return ((v*w, s*w), (v*b, s*b))

def adam(params, states, hyperparams):
    beta1, beta2, eps = 0.9, 0.999, 1e-6
    for p, (v, s) in zip(params, states):
        v[:] = beta1 * v + (1 - beta1) * p.grad
        s[:] = beta2 * s + (1 - beta2) * np.square(p.grad)
        v*bias*corr = v / (1 - beta1 ** hyperparams['t'])
        s*bias*corr = s / (1 - beta2 ** hyperparams['t'])
        p[:] -= hyperparams['lr'] * v*bias*corr / (np.sqrt(s*bias*corr) + eps)
    hyperparams['t'] += 1
```

```{.python .input}
# @tab pytorch
%matplotlib inline
from d2l import torch as d2l
import torch

def init*adam*states(feature_dim):
    v*w, v*b = d2l.zeros((feature_dim, 1)), d2l.zeros(1)
    s*w, s*b = d2l.zeros((feature_dim, 1)), d2l.zeros(1)
    return ((v*w, s*w), (v*b, s*b))

def adam(params, states, hyperparams):
    beta1, beta2, eps = 0.9, 0.999, 1e-6
    for p, (v, s) in zip(params, states):
        with torch.no_grad():
            v[:] = beta1 * v + (1 - beta1) * p.grad
            s[:] = beta2 * s + (1 - beta2) * torch.square(p.grad)
            v*bias*corr = v / (1 - beta1 ** hyperparams['t'])
            s*bias*corr = s / (1 - beta2 ** hyperparams['t'])
            p[:] -= hyperparams['lr'] * v*bias*corr / (torch.sqrt(s*bias*corr)
                                                       + eps)
        p.grad.data.zero_()
    hyperparams['t'] += 1
```

```{.python .input}
# @tab tensorflow
%matplotlib inline
from d2l import tensorflow as d2l
import tensorflow as tf

def init*adam*states(feature_dim):
    v*w = tf.Variable(d2l.zeros((feature*dim, 1)))
    v_b = tf.Variable(d2l.zeros(1))
    s*w = tf.Variable(d2l.zeros((feature*dim, 1)))
    s_b = tf.Variable(d2l.zeros(1))
    return ((v*w, s*w), (v*b, s*b))

def adam(params, grads, states, hyperparams):
    beta1, beta2, eps = 0.9, 0.999, 1e-6
    for p, (v, s), grad in zip(params, states, grads):
        v[:].assign(beta1 * v  + (1 - beta1) * grad)
        s[:].assign(beta2 * s + (1 - beta2) * tf.math.square(grad))
        v*bias*corr = v / (1 - beta1 ** hyperparams['t'])
        s*bias*corr = s / (1 - beta2 ** hyperparams['t'])
        p[:].assign(p - hyperparams['lr'] * v*bias*corr  
                    / tf.math.sqrt(s*bias*corr) + eps)
```

We are ready to use Adam to train the model. We use a learning rate of $\eta = 0.01$.

```{.python .input}
# @tab all
data*iter, feature*dim = d2l.get*data*ch11(batch_size=10)
d2l.train*ch11(adam, init*adam*states(feature*dim),
               {'lr': 0.01, 't': 1}, data*iter, feature*dim);
```

A more concise implementation is straightforward since `adam` is one of the algorithms provided as part of the Gluon `trainer` optimization library. Hence we only need to pass configuration parameters for an implementation in Gluon.

```{.python .input}
d2l.train*concise*ch11('adam', {'learning*rate': 0.01}, data*iter)
```

```{.python .input}
# @tab pytorch
trainer = torch.optim.Adam
d2l.train*concise*ch11(trainer, {'lr': 0.01}, data_iter)
```

```{.python .input}
# @tab tensorflow
trainer = tf.keras.optimizers.Adam
d2l.train*concise*ch11(trainer, {'learning*rate': 0.01}, data*iter)
```

# # Yogi

One of the problems of Adam is that it can fail to converge even in convex settings when the second moment estimate in $\mathbf{s}*t$ blows up. As a fix :cite:`Zaheer.Reddi.Sachan.ea.2018` proposed a refined update (and initialization) for $\mathbf{s}*t$. To understand what's going on, let's rewrite the Adam update as follows:

$$\mathbf{s}*t \leftarrow \mathbf{s}*{t-1} + (1 - \beta*2) \left(\mathbf{g}*t^2 - \mathbf{s}_{t-1}\right).$$

Whenever $\mathbf{g}*t^2$ has high variance or updates are sparse, $\mathbf{s}*t$ might forget past values too quickly. A possible fix for this is to replace $\mathbf{g}*t^2 - \mathbf{s}*{t-1}$ by $\mathbf{g}*t^2 \odot \mathop{\mathrm{sgn}}(\mathbf{g}*t^2 - \mathbf{s}_{t-1})$. Now the magnitude of the update no longer depends on the amount of deviation. This yields the Yogi updates

$$\mathbf{s}*t \leftarrow \mathbf{s}*{t-1} + (1 - \beta*2) \mathbf{g}*t^2 \odot \mathop{\mathrm{sgn}}(\mathbf{g}*t^2 - \mathbf{s}*{t-1}).$$

The authors furthermore advise to initialize the momentum on a larger initial batch rather than just initial pointwise estimate. We omit the details since they are not material to the discussion and since even without this convergence remains pretty good.

```{.python .input}
def yogi(params, states, hyperparams):
    beta1, beta2, eps = 0.9, 0.999, 1e-3
    for p, (v, s) in zip(params, states):
        v[:] = beta1 * v + (1 - beta1) * p.grad
        s[:] = s + (1 - beta2) * np.sign(
            np.square(p.grad) - s) * np.square(p.grad)
        v*bias*corr = v / (1 - beta1 ** hyperparams['t'])
        s*bias*corr = s / (1 - beta2 ** hyperparams['t'])
        p[:] -= hyperparams['lr'] * v*bias*corr / (np.sqrt(s*bias*corr) + eps)
    hyperparams['t'] += 1

data*iter, feature*dim = d2l.get*data*ch11(batch_size=10)
d2l.train*ch11(yogi, init*adam*states(feature*dim),
               {'lr': 0.01, 't': 1}, data*iter, feature*dim);
```

```{.python .input}
# @tab pytorch
def yogi(params, states, hyperparams):
    beta1, beta2, eps = 0.9, 0.999, 1e-3
    for p, (v, s) in zip(params, states):
        with torch.no_grad():
            v[:] = beta1 * v + (1 - beta1) * p.grad
            s[:] = s + (1 - beta2) * torch.sign(
                torch.square(p.grad) - s) * torch.square(p.grad)
            v*bias*corr = v / (1 - beta1 ** hyperparams['t'])
            s*bias*corr = s / (1 - beta2 ** hyperparams['t'])
            p[:] -= hyperparams['lr'] * v*bias*corr / (torch.sqrt(s*bias*corr)
                                                       + eps)
        p.grad.data.zero_()
    hyperparams['t'] += 1

data*iter, feature*dim = d2l.get*data*ch11(batch_size=10)
d2l.train*ch11(yogi, init*adam*states(feature*dim),
               {'lr': 0.01, 't': 1}, data*iter, feature*dim);
```

```{.python .input}
# @tab tensorflow
def yogi(params, grads, states, hyperparams):
    beta1, beta2, eps = 0.9, 0.999, 1e-6
    for p, (v, s), grad in zip(params, states, grads):
        v[:].assign(beta1 * v  + (1 - beta1) * grad)
        s[:].assign(s + (1 - beta2) * tf.math.sign(
                   tf.math.square(grad) - s) * tf.math.square(grad))
        v*bias*corr = v / (1 - beta1 ** hyperparams['t'])
        s*bias*corr = s / (1 - beta2 ** hyperparams['t'])
        p[:].assign(p - hyperparams['lr'] * v*bias*corr  
                    / tf.math.sqrt(s*bias*corr) + eps)
    hyperparams['t'] += 1

data*iter, feature*dim = d2l.get*data*ch11(batch_size=10)
d2l.train*ch11(yogi, init*adam*states(feature*dim),
               {'lr': 0.01, 't': 1}, data*iter, feature*dim);
```

# # Summary

* Adam combines features of many optimization algorithms into a fairly robust update rule. 
* Created on the basis of RMSProp, Adam also uses EWMA on the minibatch stochastic gradient.
* Adam uses bias correction to adjust for a slow startup when estimating momentum and a second moment. 
* For gradients with significant variance we may encounter issues with convergence. They can be amended by using larger minibatches or by switching to an improved estimate for $\mathbf{s}_t$. Yogi offers such an alternative. 

# # Exercises

1. Adjust the learning rate and observe and analyze the experimental results.
1. Can you rewrite momentum and second moment updates such that it does not require bias correction?
1. Why do you need to reduce the learning rate $\eta$ as we converge?
1. Try to construct a case for which Adam diverges and Yogi converges?

:begin_tab:`mxnet`
[Discussions](https://discuss.d2l.ai/t/358)
:end_tab:

:begin_tab:`pytorch`
[Discussions](https://discuss.d2l.ai/t/1078)
:end_tab:


:begin_tab:`tensorflow`
[Discussions](https://discuss.d2l.ai/t/1079)
:end_tab:
