升级
conda update conda
conda update anaconda
conda update anaconda-navigator    //update最新版本的anaconda-navigator
   
Anaconda更新和第三方包更新
更新Anaconda和它所包含的包
1、打开cmd，切换到Anaconda的Scripts目录下：./Anaconda3/Scripts
2、更新Anaconda
conda update conda
3、更新包：
conda update --all
指定升级某一个库，例如 pandas：conda update pandas
自动检测并升级 Anaconda 管理器中的所有可升级的库：conda update --all

另外，既然使用 Anaconda 进行库的管理，就可以不使用 pip 的命令了.使用 pip 升级包之后可能在 Anaconda 中仍然检测不到更新，导致版本混乱，并且同一个包在 pip 和 Anaconda 下所供升级的版本可能是不同的，就更凌乱了。
如果需要用到某些特别的包，在 Anaconda 中下载不到，但是 pip 中能看到，那就用 pip 进行安装好了。
卸载
计算机控制面板->程序与应用->卸载        //windows
rm -rf anaconda    //ubuntu
最后，建议清理下.bashrc中的Anaconda路径。 conda环境使用基本命令：
conda update -n base conda        //update最新版本的conda
conda create -n xxxx python=3.5   //创建python3.5的xxxx虚拟环境
conda activate xxxx               //开启xxxx环境
conda deactivate                  //关闭环境
conda env list                    //显示所有的虚拟环境
anaconda安装最新的TensorFlow版本
参考：https://blog.csdn.net/qq_35203425/article/details/79965389
1. 打开anaconda-prompt
2. 查看tensorflow各个版本：（查看会发现有一大堆TensorFlow源，但是不能随便选，选择可以用查找命令定位） anaconda search -t conda tensorflow 
3. 找到自己安装环境对应的最新TensorFlow后（可以在终端搜索anaconda，定位到那一行），然后查看指定包 anaconda show <USER/PACKAGE> 
4. 查看tensorflow版本信息 anaconda show anaconda/tensorflow 
5. 第4步会提供一个下载地址，使用下面命令就可安装1.8.0版本tensorflow
conda install --channel https://conda.anaconda.org/anaconda tensorflow=1.8.0
更新，卸载安装包：
conda list #查看已经安装的文件包
conda update xxx   #更新xxx文件包
conda uninstall xxx   #卸载xxx文件包
删除虚拟环境
conda remove -n xxxx --all //创建xxxx虚拟环境
清理（conda瘦身）
conda clean就可以轻松搞定！第一步：通过conda clean -p来删除一些没用的包，这个命令会检查哪些包没有在包缓存中被硬依赖到其他地方，并删除它们。第二步：通过conda clean -t可以将conda保存下来的tar包。
conda clean -p      //删除没有用的包
conda clean -t      //tar打包
参考：https://blog.csdn.net/menc15/article/details/71477949
jupyter notebook默认工作目录设置
参考：https://blog.csdn.net/liwei1205/article/details/78818568 1）在Anaconda Prompt终端中输入下面命令，查看你的notebook配置文件在哪里：
jupyter notebook --generate-config
//会生成文件C:\Users\用户\.jupyter\jupyter_notebook_config.py
2）打开jupyter_notebook_config.py文件通过搜索关键词：c.NotebookApp.notebook_dir，修改如下
c.NotebookApp.notebook_dir = 'E:\\tf_models'     //修改到自定义文件夹
3）然后重启notebook服务器就可以了 注：其它方法直接命令到指定目录，Anaconda Prompt终端中输：jupyter notebook 目录地址

您可以使用以下命令在conda中将python版本更新为3.8
conda install -c anaconda python=3.8



来自 <https://cloud.tencent.com/developer/article/1351778> 

