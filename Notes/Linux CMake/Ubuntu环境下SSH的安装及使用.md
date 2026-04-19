# Ubuntu环境下SSH的安装及使用

发布于2020-11-24 10:47:16阅读 20.8K0

**Ubuntu环境下SSH的安装及使用**

SSH是指Secure Shell,是一种安全的传输协议，Ubuntu客户端可以通过SSH访问远程[服务器](https://cloud.tencent.com/product/cvm?from=10680) 。SSH的简介和工作机制可参看上篇文章 [SSH简介及工作机制](http://blog.csdn.net/netwalk/article/details/12951031)。

SSH分客户端openssh-client和openssh-server

如果你只是想登陆别的机器的SSH只需要安装openssh-client（ubuntu有默认安装，如果没有则sudoapt-get install openssh-client），如果要使本机开放SSH服务就需要安装openssh-server。

# 一、**安装客户端**

Ubuntu缺省已经安装了ssh client。

sudo apt-get install ssh  或者 sudo apt-get installopenssh-client

 ssh-keygen 

(按回车设置默认值)

按缺省生成id\_rsa和id\_rsa.pub文件，分别是私钥和公钥。

**说明**：如果sudo apt-get insall ssh出错，无法安装可使用sudo apt-get install openssh-client进行安装。

假定服务器ip为192.168.1.1，ssh服务的端口号为22，服务器上有个用户为root；

用ssh登录服务器的命令为：

\>ssh –p 22 root@192.168.1.1

\>输入root用户的密码

# **二、安装服务端**

Ubuntu缺省没有安装SSH Server，使用以下命令安装：

sudo apt-get install openssh-server

然后确认sshserver是否启动了：（或用“netstat -tlp”命令）

ps -e|grep ssh

如果只有ssh-agent那ssh-server还没有启动，需要/etc/init.d/ssh start，如果看到sshd那说明ssh-server已经启动了。 

如果没有则可以这样启动：

sudo/etc/init.d/ssh start

　　事实上如果没什么特别需求，到这里 OpenSSH Server 就算安装好了。但是进一步设置一下，可以让 OpenSSH 登录时间更短，并且更加安全。这一切都是通过修改 openssh 的配置文件 sshd\_config 实现的。

# **三、SSH配置**

ssh-server配置文件位于/etc/ssh/sshd\_config，在这里可以定义SSH的服务端口，默认端口是22，你可以自己定义成其他端口号，如222。然后重启SSH服务：

```javascript
sudo /etc/init.d/sshresart
```

复制

通过修改配置文件/etc/ssh/sshd\_config，可以改ssh登录端口和禁止root登录。改端口可以防止被端口扫描。

```javascript
     sudo cp/etc/ssh/sshd_config /etc/ssh/sshd_config.original
     sudochmod a-w /etc/ssh/sshd_config.original
```

复制

编辑配置文件：

```javascript
gedit /etc/ssh/sshd_config
```

复制

找到#Port 22，去掉注释，修改成一个五位的端口：

Port 22333

找到#PermitRootLogin yes，去掉注释，修改为：

PermitRootLogin no

配置完成后重起：

```javascript
    sudo/etc/init.d/ssh restart
```

复制

复制

# `**四、SSH服务命令**`

`停止服务：sudo /etc/init.d/ssh stop`

`启动服务：sudo /etc/init.d/ssh start`

`重启服务：sudo /etc/init.d/sshresart`

`断开连接：exit`

`登录：ssh``root@192.168.0.100`

    `root为192.168.0.100机器上的用户，需要输入密码。`

# `**五、SSH登录命令**`

`常用格式：ssh [-llogin_name] [-p port] [user@]hostname`

`更详细的可以用ssh -h查看。`

`举例`

`不指定用户：`

```javascript
ssh 192.168.0.1
```

复制

指定用户：

```javascript
ssh -l root 192.168.0.1
ssh root@192.168.0.1 
```

复制

如果修改过ssh登录端口的可以：

```javascript
ssh -p 22333 192.168.0.111
ssh -l root -p 22333 216.230.230.105
ssh -p 22333 root@216.230.230.105
```

复制

# **六、提高登录速度**

　　在远程登录的时候可能会发现，在输入完用户名后需要等很长一段时间才会提示输入密码。其实这是由于 sshd 需要反查客户端的 dns 信息导致的。可以通过禁用这个特性来大幅提高登录的速度。首先，打开 sshd\_config 文件：

```javascript
　　sudo nano /etc/ssh/sshd_config
```

复制

　　找到 GSSAPI options 这一节，将下面两行注释掉：

　　#GSSAPIAuthentication yes #GSSAPIDelegateCredentials no然后重新启动 ssh 服务即可：

```javascript
　　sudo /etc/init.d/ssh restart
```

复制

　　再登录试试，应该非常快了吧

# 七、利用 PuTTy 通过证书认证登录服务器

　　SSH 服务中，所有的内容都是加密传输的，安全性基本有保证。但是如果能使用证书认证的话，安全性将会更上一层楼，而且经过一定的设置，还能实现证书认证自动登录的效果。

　　首先修改 sshd\_config 文件，开启证书认证选项：

　　RSAAuthentication yes PubkeyAuthentication yesAuthorizedKeysFile %h/.ssh/authorized\_keys修改完成后重新启动 ssh 服务。

　　下一步我们需要为 SSH 用户建立私钥和公钥。首先要登录到需要建立密钥的账户下，这里注意退出 root 用户，需要的话用 su 命令切换到其它用户下。然后运行：

```javascript
　　ssh-keygen
```

复制

　　这里，我们将生成的 key 存放在默认目录下即可。建立的过程中会提示输入 passphrase，这相当于给证书加个密码，也是提高安全性的措施，这样即使证书不小心被人拷走也不怕了。当然如果这个留空的话，后面即可实现 PuTTy 通过证书认证的自动登录。

　　ssh-keygen 命令会生成两个密钥，首先我们需要将公钥改名留在服务器上：

```javascript
　　cd ~/.ssh mv id_rsa.pub authorized_keys
```

复制

        然后将私钥 id\_rsa 从服务器上复制出来，并删除掉服务器上的 id\_rsa 文件。

　　服务器上的设置就做完了，下面的步骤需要在客户端电脑上来做。首先，我们需要将 id\_rsa 文件转化为 PuTTy 支持的格式。这里我们需要利用 PuTTyGEN 这个工具：

　　点击 PuTTyGen 界面中的 Load 按钮，选择 id\_rsa 文件，输入 passphrase（如果有的话），然后再点击 Save PrivateKey 按钮，这样 PuTTy 接受的私钥就做好了。

　　打开 PuTTy，在 Session 中输入服务器的 IP 地址，在 Connection->SSH->Auth 下点击 Browse 按钮，选择刚才生成好的私钥。然后回到 Connection 选项，在 Auto-login username 中输入证书所属的用户名。回到 Session 选项卡，输入个名字点 Save 保存下这个 Session。点击底部的 Open 应该就可以通过证书认证登录到服务器了。如果有 passphrase 的话，登录过程中会要求输入 passphrase，否则将会直接登录到服务器上，非常的方便。