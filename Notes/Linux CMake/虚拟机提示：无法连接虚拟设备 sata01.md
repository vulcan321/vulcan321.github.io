虚拟机提示：无法连接虚拟设备 sata0:1,因为主机上没有相对应的设备……



Ubuntu 点击自己安装的Ubuntu，右键打开虚拟机设置，CD/DVD里面选择自己安装的镜像文件就行了

![](E:\Source\Repos\vulcan321.github.io\Linux\images\20200709201516177.png)



有的方法在把sata改为镜像文件时，会发现安装VMtool又会报错。

以下为个人解决办法：

1.在虚拟机设置中添加通用SCSI设备。如图

![](E:\Source\Repos\vulcan321.github.io\Linux\images\20200709201718156.png)

2.设置启动连接，和节点，点击确定。

![](E:\Source\Repos\vulcan321.github.io\Linux\images\20200709204620223.png)

3.关闭SATA的连接与启动连接



4.重启后不会有问题。

5.个人认为可能是在安装Ubuntu时，硬盘选择的是SCSI。但是安装完后系统却并没有通用SCSI，只有一个sata。但里面链接的是我们之前安装时用的iso文件。所以导致报错。