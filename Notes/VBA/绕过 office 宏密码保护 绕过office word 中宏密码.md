在分析一些宏病毒时，按下Alt+F11尝试查看宏代码，但是往往会遇到密码保护


可以将文件在任意一款十六[进制](https://so.csdn.net/so/search?q=%E8%BF%9B%E5%88%B6&spm=1001.2101.3001.7020)编辑工具中打开该文件，比如010 editor，搜索DPB字符串，改成DPX

![](https://img-blog.csdnimg.cn/20190916173644477.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0NvZHlfUmVu,size_16,color_FFFFFF,t_70)

注意不要减少或者增加其他字符，保存退出

![](https://img-blog.csdnimg.cn/20190916173812130.png)

重新打开文件，Alt + F11打开

![](https://img-blog.csdnimg.cn/20190916173905786.png)

右键打开属性，设置一个密码保存，重新打开文件Alt + F11输入密码即可查看宏代码

![](https://img-blog.csdnimg.cn/20190916174128798.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0NvZHlfUmVu,size_16,color_FFFFFF,t_70)

更简单的方法，用Office Key工具可以直接查看。

![](https://img-blog.csdnimg.cn/20190921172804530.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0NvZHlfUmVu,size_16,color_FFFFFF,t_70)

有的office文档通过上面的方法无法绕过宏，则可以使用下面的神器 VBA ByPasser，用该软件加载文档，然后打开文档，即可不需要密码直接查看宏代码(该软件需要注册：Username: JekG     Serial: 000014-RE613W-5D877U-KDNY8V-ZZFZZZ-ZZZZZZ-ZWCJP9-51VJ00-800000-000000)。

![](https://img-blog.csdnimg.cn/2019120910424763.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0NvZHlfUmVu,size_16,color_FFFFFF,t_70)