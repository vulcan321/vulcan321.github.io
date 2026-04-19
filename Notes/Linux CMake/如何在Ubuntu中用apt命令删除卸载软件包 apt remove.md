# apt命令删除/卸载软件包（remove/clean/purge）


在ubuntu中安装一个新的软件包时，直接使用“apt-get install”命令就好。
那么，如果要卸载或者删除一个软件包呢？百度一下，你会发现，在ubuntu下有N多种可以用于卸载软件的方法和命令，比如remove/autoremove/clean/autoclean/purge等，这些命令究竟该怎么使用，各自又有什么优缺点呢？下面我弄了个表格来对比总结一下：

| 命令 | 特点 |
| :-: | :-- |
| apt-get autoremove | 删除为了满足依赖而安装的，但现在不再需要的软件包（包括已安装包），保留配置文件；**高能警告：慎用本命令！！！**  **它会在你不知情的情况下，一股脑删除很多“它认为”你不再使用的软件**； |
| apt-get remove | 删除已安装的软件包（保留配置文件），不会删除依赖软件包，保留配置文件； |
| apt-get purge | 删除已安装的软件包（不保留配置文件)，删除软件包，同时删除相应依赖软件包； |
| apt-get --purge remove | 同apt-get purge |
| apt-get autoclean | 删除为了满足某些依赖安装的，但现在不再需要的软件包；apt的底层包是dpkg, 而dpkg安装软件包时, 会将\*.deb文件放在/var/cache/apt/archives/中；因此本命令会删除该目录下已经过期的deb； |
| apt-get clean | 删除已经安装过的的软件安装包；  
即自动将/var/cache/apt/archives/下的所有deb删掉，相当于清理下载的软件安装包； |

那么如何彻底卸载软件呢？ 如下：

```bash
apt-get --purge remove <package># 删除软件及其配置文件
apt-get autoremove <package># 删除没用的依赖包
dpkg -l |grep ^rc|awk '{print $2}' |sudo xargs dpkg -P # 清理dpkg的列表中有“rc”状态的软件包
```

**附录：dpkg简介**

Ubuntu是基于Debian的Linux系统，而Debian系统的软件是使用APT和dpkg进行管理。dpkg是"Debian Packager"的简写，是一个底层的软件包管理工具。

可以输入dpkg -l来查看软件的状态，输入dpkg -P来卸载软件。因为dpkg --remove只是删除安装的文件，但不删除配置文件。而dpkg --purge则安装文件和配置文件都删除。