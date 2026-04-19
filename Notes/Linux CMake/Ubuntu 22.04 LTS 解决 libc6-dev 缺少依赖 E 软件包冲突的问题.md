# Ubuntu 22.04 LTS 解决 libc6-dev 缺少依赖 E: 软件包冲突的问题

昨天装verilator，但是执行

```
    sudo  apt-get install g++
```

的时候，总是报错，libc6-dev 这个库必须依赖 libc6 这个库，但是只支持 libc6\_2.35-0ubuntu3版本，而我的电脑已经装上了 2.35-0ubuntu3.1 这个版本，于是执行

```bash
sudo apt install libc6=2.35-0ubuntu3 
```

这个命令指定了安装的版本，从而实现了版本降级，之后再次安装 g++  
就能成功安装，如果是其他版本也可以如法炮制

另外，网上很多缺依赖或者软件包冲突问题，给出了更新源的解决方案，是不适用于这种情况的，如果上述命令执行不成功，还是应该回过头去先看一下源版本的问题。

先执行

```bash
sudo apt-get update
```

更新一下源  
再执行

```bash
sudo apt-get upgrade
```

更新本地软件  
这样理论上所有软件都是最新的了，这时候再执行之前的命令，应该就是好使的了