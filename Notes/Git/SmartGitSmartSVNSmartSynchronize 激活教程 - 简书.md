# SmartGit/SmartSVN/SmartSynchronize 激活教程

## 下载

| 名称 | 下载地址 |
| --- | --- |
| SmartGit | [下载地址](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.syntevo.com%2Fsmartgit%2Fdownload%2F) |
| SmartSVN | [下载地址](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.smartsvn.com%2Fdownload%2F) |
| SmartSynchronize | [下载地址](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.syntevo.com%2Fsmartsynchronize%2Fdownload%2F) |

## 激活

1 . 先安装 SmartGit/SmartSVN/SmartSynchronize，安装后运行一下。  
2 . 1. 下载 [激活工具](https://links.jianshu.com/go?to=https%3A%2F%2Fmacwk.lanzoui.com%2Fi8Dsvss9xdg) 然后解压，解压后把 smartgit-agent.jar 放到你喜欢的文件夹中。  
3 . 用编辑器打开 smartgit.vmoptions 文件，此文件可以在以下位置找到：

###### SmartGit

| 平台 | 位置 |
| --- | --- |
| mac | /Library/Preferences/SmartGit/ |
| linux | /.config/smartgit/ |
| windows | %APPDATA%\\syntevo\\SmartGit\\ 或者你直接在bin目录下改。 |

###### SmartSVN

| 平台 | 位置 |
| --- | --- |
| mac | /Library/Preferences/SmartSVN/ |
| linux | /.config/smartsvn/ |
| windows | %APPDATA%\\syntevo\\SmartSVN\\ 或者你直接在bin目录下改。 |

###### SmartSynchronize

| 平台 | 位置 |
| --- | --- |
| mac | /Library/Preferences/SmartSynchronize/ |
| linux | /.config/smartsynchronize/ |
| windows | %APPDATA%\\syntevo\\SmartSynchronize\\ 或者你直接在bin目录下改。 |

4 . 在打开的 smartgit.vmoptions 文件末行添加：-javaagent:/absolute/path/to/smartgit-agent.jar，一定要自己确认好路径，填错会导致SmartGit打不开！！！最好使用绝对路径，不要使用中文路径。

| 平台 | 示例 |
| --- | --- |
| mac | javaagent:/Users/macwk.com/smartgit-agent.jar |
| linux | javaagent:/home/macwk.com/smartgit-agent.jar |
| windows | javaagent:C:\\Users\\macwk.com\\smartgit-agent.jar |

5 . 启动 SmartGit/SmartSVN/SmartSynchronize，注册使用压缩包内的 license.zip 文件（不要解压）。  
6 . 如果提示错误: "Error opening zip file or JAR manifest missing : smartgit-agent.jar" 这种情况请试着填上jar文件的绝对路径。

## SmartSVN 注意

如果使用 SmartSVN 的同学建议用 SmartGit/SmartSynchronize 的 jre 替换 SmartSVN 的 jre，因为 SmartSVN 的 jre 是阉割版的。

解压smartgit-agent.jar到~/.config/smartgit目录  
cd ~/.config/smartgit  
echo -javaagent:/home/"$USER"/.config/smartgit/smartgit-agent.jar >smartgit.vmoptions