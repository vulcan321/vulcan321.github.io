# Autodesk 2024 Win/Mac系列软件官方下载地址 + 破解补丁 + 破解方法

![](https://www.gfxcamp.com/wp-content/uploads/2023/03/Autodesk-2024-Crack.jpg)

**Autodesk 2024 Win/Mac系列软件官方下载地址 + 破解补丁 + 破解方法**

Win破解方法1：

1.  安装Autodesk 2024需要的软件
2.  管理员身份运行Autodesk License Patcher Installer.exe
3.  启动安装的软件  
    – 选择Use a network license  
    – 选择Single license server  
    \-填写127.0.0.1或者localhost或者27080@127.0.0.1

Win破解方法2：

1.  关闭杀毒，防止误删
2.  安装Autodesk软件，但是不要启动，安装完成后重启电脑
3.  安装NLM.msi，默认安装到C:\\Autodesk\\Network License Manager，停止lmgrd, adskflex等的服务，拷贝adskflex.exe过去替换
4.  拷贝netapi32.dll到C:\\Program Files (x86)\\Common Files\\Autodesk Shared\\AdskLicensing\\Current\\AdskLicensingAgent\\
5.  用记事本打开License.lic，将里面的HOSTNAME 和 MAC修改成自己电脑的计算机名和MAC地址(具体查询方法可以百度，MAC地址中间不用添加-)，保存后放到C:\\Autodesk\\Network License Manager
6.  在C:\\Autodesk\\Network License Manager里启动lmtools.exe
7.  在config services里，Service Name修改成Autodesk  
    Path to the Imgrd.exe file里选择 C:\\Autodesk\\Network License Manager\\lmgrd.exe  
    Path to the license file里选择C:\\Autodesk\\Network License Manager\\lic.dat  
    勾选’start server at power up’ 和 ‘use services’  
    点击Save Service保存
8.  在service/license file选择 configuration using services 勾选LMTOOLS ignore license file path environment variables  
    在start/stop/read点击start server  
    点击ReReadlicense file,如果下面提示出现error之类的错误，表示用户名或者MAC地址写错了  
    – 在server status点击perform status enquiry’
9.  启动软件  
    – 选择Use a network license  
    – 选择Single license server  
    \-填写127.0.0.1或者localhost

Win破解方法3：

-   安装软件
-   拷贝version.dll到C:\\Program Files (x86)\\Common Files\\Autodesk Shared\\AdskLicensing\\Current\\AdskLicensingAgent\\
-   用记事本打开LicenseServer文件夹里面的license.dat，将里面第一行的”this\_host”改成你自己电脑的用户名，保存后关闭，运行lmtools.exe，点选Configuration using License File，然后Broswe，选择license.dat
-   运行Autodesk软件，根据以下信息填写  
    – License type: Use a network license  
    – License server model: Single License Server  
    – Name of the server: 27080@你的用户名 或者 27080@127.0.0.1

Mac破解方法：

1.  安装Autodesk软件
2.  安装nlm11.18.0.0\_ipv4\_ipv6\_mac64.pkg
3.  拷贝libadlmint.dylib到/资源库/Application Support/Autodesk/AdskLicensing/Current/AdskLicensingAgent/AdskLicensingAgent.app/右键 显示包内容/Contents/PlugIns/
4.  关闭电脑的SIP(非必需操作，如要关闭可以百度搜索MAC如何关闭SIP)
5.  在应用程序/实用工具/终端，打开终端，输入cd /usr/local/flexnetserver/ 回车
6.  继续输入hostname，回车，比如我得到的结果是WhiteDeath.local，这个每个人电脑不一样
7.  7输入scutil –get LocalHostName，回车，比如我得到的结果是whitedeath1s-MacBook-Pro
8.  输入scutil –get HostName，回车，比如我得到的结果是hostname is not set
9.  输入sudo scutil –set HostName whitedeath1s-MacBook-Pro.local，后面的whitedeath1s-MacBook-Pro.local是根据你第7步得到的结果后面加.local,输入后回车
10.  在电脑的host文件里(不知道host位置的可以百度MAC Host文件位置)，用记事本打开，加入以下代码(还是会根据你前面的结果来修改)  
    127.0.0.1 whitedeath1s-MacBook-Pro.local whitedeath1s-MacBook-Pro
11.  终端里输入./lmgrd -c后面加个空格，将license.dat拖到终端后回车
12.  运行软件，选择network，27080@localhost

Win破解补丁下载地址：

-   链接：[https://pan.baidu.com/s/14PJLER8zG7wYvwSLMS9UkA?pwd=a17l](https://pan.baidu.com/s/14PJLER8zG7wYvwSLMS9UkA?pwd=a17l) 提取码：a17l

Mac破解补丁下载地址：

-   链接：[https://pan.baidu.com/s/1eKsB6F5dcUWVXeHeJkT-TA?pwd=luje](https://pan.baidu.com/s/1eKsB6F5dcUWVXeHeJkT-TA?pwd=luje) 提取码：luje

Autodesk 2024 系列软件官方下载地址：

**3DS MAX 2024(中英多语言版)**

-   ```
    https://efulfillment.autodesk.com/NetSWDLD/2024/3DSMAX/A54AED8B-2D32-3795-8962-12E42ED4A767/SFX/Autodesk_3ds_Max_2024_EFGJKPS_Win_64bit_001_003.sfx.exe
    ```
    
-   ```
    https://efulfillment.autodesk.com/NetSWDLD/2024/3DSMAX/A54AED8B-2D32-3795-8962-12E42ED4A767/SFX/Autodesk_3ds_Max_2024_EFGJKPS_Win_64bit_002_003.sfx.exe
    ```
    
-   ```
    https://efulfillment.autodesk.com/NetSWDLD/2024/3DSMAX/A54AED8B-2D32-3795-8962-12E42ED4A767/SFX/Autodesk_3ds_Max_2024_EFGJKPS_Win_64bit_003_003.sfx.exe
    ```
    

**Maya 2024 Win(中英多语言版)**

-   ```
    https://efulfillment.autodesk.com/NetSWDLD/2024/MAYA/2FA13C35-AE58-3F58-AD53-C16C22486F9B/SFX/Autodesk_Maya_2024_Windows_64bit_dlm_001_002.sfx.exe
    ```
    
-   ```
    https://efulfillment.autodesk.com/NetSWDLD/2024/MAYA/2FA13C35-AE58-3F58-AD53-C16C22486F9B/SFX/Autodesk_Maya_2024_Windows_64bit_dlm_002_002.sfx.exe
    ```
    

**Maya 2024 Mac(中英多语言版)**

-   ```
    https://dds.autodesk.com/NetSWDLD/2024/MAYA/5DF5A9B6-E255-39CA-AEEC-9D0B8A40BED6/SFX/Autodesk_Maya_2024_0_1_Update_macOS.dmg
    ```
    

**Autodesk CAD 2024(简体中文版)**

-   ```
    https://efulfillment.autodesk.com/NetSWDLD/2024/ACD/C0D3A90A-5925-3283-B826-68A4EAF3698A/SFX/AutoCAD_2024_Simplified_Chinese_Win_64bit_dlm_001_002.sfx.exe
    ```
    
-   ```
    https://efulfillment.autodesk.com/NetSWDLD/2024/ACD/C0D3A90A-5925-3283-B826-68A4EAF3698A/SFX/AutoCAD_2024_Simplified_Chinese_Win_64bit_dlm_002_002.sfx.exe
    ```
    

**Autodesk CAD 2024(繁体中文版)**

-   ```
    https://efulfillment.autodesk.com/NetSWDLD/2024/ACD/DDF43270-FC4E-3B3D-8E58-6AA772EFC4DD/SFX/AutoCAD_2024_Traditional_Chinese_Win_64bit_dlm_001_002.sfx.exe
    ```
    
-   ```
    https://efulfillment.autodesk.com/NetSWDLD/2024/ACD/DDF43270-FC4E-3B3D-8E58-6AA772EFC4DD/SFX/AutoCAD_2024_Traditional_Chinese_Win_64bit_dlm_002_002.sfx.exe
    ```
    

**Autodesk CAD 2024 Win(英文版)**

-   ```
    https://efulfillment.autodesk.com/NetSWDLD/2024/ACD/CC46AD7F-5075-3702-B2BF-CFCC5AB8468B/SFX/AutoCAD_2024_English_Win_64bit_dlm_001_002.sfx.exe
    ```
    
-   ```
    https://efulfillment.autodesk.com/NetSWDLD/2024/ACD/CC46AD7F-5075-3702-B2BF-CFCC5AB8468B/SFX/AutoCAD_2024_English_Win_64bit_dlm_002_002.sfx.exe
    ```
    

**Autodesk CAD 2024 Mac**

-   ```
    https://efulfillment.autodesk.com/NetSWDLD/2024/ACDMAC/4EB37CFC-1C2B-33FC-AE6B-83EEE5EA4C79/ESD/Autodesk_AutoCAD_2024_macOS.dmg
    ```
    

**MotionBuilder 2024**

-   ```
    https://efulfillment.autodesk.com/NetSWDLD/2024/MOBPRO/03A3363B-79B3-3095-84AF-B252188A0631/SFX/Autodesk_MotionBuilder_2024_Windows_64bit_dlm.sfx.exe
    ```
    

**MudBox 2024**

-   ```
    https://efulfillment.autodesk.com/NetSWDLD/2024/MBXPRO/A82CD984-57D0-38C3-BA61-F1FF058DF928/SFX/Autodesk_Mudbox_2024_Windows_64bit_dlm.sfx.exe
    ```
    

**Inventor Pro 2024(中文版)**

-   ```
    https://efulfillment.autodesk.com/NetSWDLD/2024/INVPROSA/6A358503-3AE7-35FF-BDC5-5B39F75B2E88/SFX/Inventor_Pro_2024_Simplified_Chinese_Win_64bit_Dlm_001_003.sfx.exe
    ```
    
-   ```
    https://efulfillment.autodesk.com/NetSWDLD/2024/INVPROSA/6A358503-3AE7-35FF-BDC5-5B39F75B2E88/SFX/Inventor_Pro_2024_Simplified_Chinese_Win_64bit_Dlm_002_003.sfx.exe
    ```
    
-   ```
    https://efulfillment.autodesk.com/NetSWDLD/2024/INVPROSA/6A358503-3AE7-35FF-BDC5-5B39F75B2E88/SFX/Inventor_Pro_2024_Simplified_Chinese_Win_64bit_Dlm_003_003.sfx.exe
    ```
    

**Inventor Pro 2024(英文版)**

-   ```
    https://efulfillment.autodesk.com/NetSWDLD/2024/INVPROSA/0B739F57-E75B-3A3D-B2A3-BFB7B2346754/SFX/Inventor_Pro_2024_English_Win_64bit_Dlm_001_003.sfx.exe
    ```
    
-   ```
    https://efulfillment.autodesk.com/NetSWDLD/2024/INVPROSA/0B739F57-E75B-3A3D-B2A3-BFB7B2346754/SFX/Inventor_Pro_2024_English_Win_64bit_Dlm_002_003.sfx.exe
    ```
    
-   ```
    https://efulfillment.autodesk.com/NetSWDLD/2024/INVPROSA/0B739F57-E75B-3A3D-B2A3-BFB7B2346754/SFX/Inventor_Pro_2024_English_Win_64bit_Dlm_003_003.sfx.exe
    ```
    

**Navisworks Manage 2024**

-   ```
    https://efulfillment.autodesk.com/NetSWDLD/2024/NAVMAN/1BB907BC-4F14-3ED2-950C-39A3D99D2EFE/SFX/Autodesk_Navisworks_Manage_2024_Win_64bit_dlm_001_002.sfx.exe
    ```
    
-   ```
    https://efulfillment.autodesk.com/NetSWDLD/2024/NAVMAN/1BB907BC-4F14-3ED2-950C-39A3D99D2EFE/SFX/Autodesk_Navisworks_Manage_2024_Win_64bit_dlm_002_002.sfx.exe
    ```
    

**Revit 2024**

-   ```
    http://dds.autodesk.com/NetSWDLD/2024/RVT/E7F68AA6-4954-3ACE-8543-D2FCC9B0A356/SFX/Revit_2024_G1_Win_64bit_dlm_001_005.sfx.exe
    ```
    
-   ```
    http://dds.autodesk.com/NetSWDLD/2024/RVT/E7F68AA6-4954-3ACE-8543-D2FCC9B0A356/SFX/Revit_2024_G1_Win_64bit_dlm_002_005.sfx.exe
    ```
    
-   ```
    http://dds.autodesk.com/NetSWDLD/2024/RVT/E7F68AA6-4954-3ACE-8543-D2FCC9B0A356/SFX/Revit_2024_G1_Win_64bit_dlm_003_005.sfx.exe
    ```
    
-   ```
    http://dds.autodesk.com/NetSWDLD/2024/RVT/E7F68AA6-4954-3ACE-8543-D2FCC9B0A356/SFX/Revit_2024_G1_Win_64bit_dlm_004_005.sfx.exe
    ```
    
-   ```
    http://dds.autodesk.com/NetSWDLD/2024/RVT/E7F68AA6-4954-3ACE-8543-D2FCC9B0A356/SFX/Revit_2024_G1_Win_64bit_dlm_005_005.sfx.exe
    ```
    

**Civil 3D 2024(中文版)**

-   ```
    http://dds.autodesk.com/NetSWDLD/2024/CIV3D/7F836E27-9361-3B37-8668-761FAA962B4E/SFX/Autodesk_Civil_3D_2024_Chinese_Simplified_Win_64bit_dlm_001_003.sfx.exe
    ```
    
-   ```
    http://dds.autodesk.com/NetSWDLD/2024/CIV3D/7F836E27-9361-3B37-8668-761FAA962B4E/SFX/Autodesk_Civil_3D_2024_Chinese_Simplified_Win_64bit_dlm_002_003.sfx.exe
    ```
    
-   ```
    http://dds.autodesk.com/NetSWDLD/2024/CIV3D/7F836E27-9361-3B37-8668-761FAA962B4E/SFX/Autodesk_Civil_3D_2024_Chinese_Simplified_Win_64bit_dlm_003_003.sfx.exe
    ```


## 系统要求

AutoCAD2023/AutoCAD2022：Windows 10 及更高版64位  
AutoCAD2021/AutoCAD2020：仅64位版，开始不再提供32位  
2019-2021：Windows 7(KB4019990) , Windows 10 1803 及更高版64位  
2015-2019：Windows 7 及更高版；2004-2014：Windows XP 及更高版

## 下载地址

AutoCAD 2024.1.2 中文破解版 (最新CAD2024中文破解版)

https://www.123pan.com/s/A6cA-Wl9Jh

https://pan.baidu.com/s/1\_nrPgNnUBdz6qKNvDLutCw?pwd=2023

___

Autodesk AutoCAD 2024.1.2 Update 23年11月更新补丁  
https://up1.autodesk.com/2024/ACD/C60FCE98-51FF-3F06-82DE-4F3E660B3292/AutoCAD\_2024.1.2\_Update.exe

Autodesk AutoCAD 2024 官方简体中文版完整离线安装包  
https://efulfillment.autodesk.com/NetSWDLD/2024/ACD/C0D3A90A-5925-3283-B826-68A4EAF3698A/SFX/AutoCAD\_2024\_Simplified\_Chinese\_Win\_64bit\_dlm\_001\_002.sfx.exe
https://efulfillment.autodesk.com/NetSWDLD/2024/ACD/C0D3A90A-5925-3283-B826-68A4EAF3698A/SFX/AutoCAD\_2024\_Simplified\_Chinese\_Win\_64bit\_dlm\_002\_002.sfx.exe

Autodesk AutoCAD LT 2024.1.2 Update 23年11月更新补丁  
https://up1.autodesk.com/2024/ACDLT/9FE27715-D515-3200-99DD-6A2DE87700BE/AutoCAD\_LT\_2024.1.2\_Update.exe

Autodesk AutoCAD LT 2024 官方简体中文版完整离线安装包  
https://trial2.autodesk.com/NetSWDLD/2024/ACDLT/73E6C25F-EEFD-3C10-8F94-27C090847201/SFX/AutoCAD\_LT\_2024\_Simplified\_Chinese\_Win\_64bit\_dlm.sfx.exe

___

AutoCAD2024-2021 Patch - KarMa 最新CAD2024破解补丁通用版  
https://pan.lanzouu.com/iqQW307vlqbc

AutoCADLT2024-2021 Patch - KarMa CADLT2024破解补丁通用版  
https://pan.lanzouu.com/iLLB907vlqab

欧特克2024-2021系列网络许可管理器激活补丁简化步骤全自动通用版  
::管理员身份运行AdskNLM.exe等待完毕,  启动软件->选网络许可->完  
﹂Autodesk NLM Cracked (MAGNiTUDE method) (2023/10/14)  
https://pan.lanzouu.com/iL4NR1ehz0jc

___

适用AutoCAD 2024 VBA模块64位安装包官方下载地址  
https://damassets.autodesk.net/content/dam/autodesk/external-assets/support-articles/download-the-microsoft-vba-module-for-autocad/Autodesk\_AutoCAD\_2024\_VBA\_Enabler.exe

AutoCAD 的 Microsoft VBA模块所有支持版本下载页面  
https://www.autodesk.com.cn/support/technical/article/caas/tsarticles/tsarticles/CHS/ts/3kxk0RyvfWTfSfAIrcmsLQ.html