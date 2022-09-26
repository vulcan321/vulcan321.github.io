# [Qt Installer Framework 使用说明（二）](https://www.cnblogs.com/oloroso/p/6775243.html)

目录

-   [4、教程: 创建一个安装程序](https://www.cnblogs.com/oloroso/p/6775243.html#4教程-创建一个安装程序)
    -   [创建软件包目录](https://www.cnblogs.com/oloroso/p/6775243.html#创建软件包目录)
    -   [创建配置文件](https://www.cnblogs.com/oloroso/p/6775243.html#创建配置文件)
    -   [创建程序包信息文件](https://www.cnblogs.com/oloroso/p/6775243.html#创建程序包信息文件)
    -   [指定组件信息](https://www.cnblogs.com/oloroso/p/6775243.html#指定组件信息)
    -   [指定安装程序版本](https://www.cnblogs.com/oloroso/p/6775243.html#指定安装程序版本)
    -   [添加许可证](https://www.cnblogs.com/oloroso/p/6775243.html#添加许可证)
    -   [选择默认内容](https://www.cnblogs.com/oloroso/p/6775243.html#选择默认内容)
    -   [创建安装程序内容](https://www.cnblogs.com/oloroso/p/6775243.html#创建安装程序内容)
    -   [创建安装程序二进制文件](https://www.cnblogs.com/oloroso/p/6775243.html#创建安装程序二进制文件)
-   [5、创建安装程序 Creating Installers](https://www.cnblogs.com/oloroso/p/6775243.html#5创建安装程序-creating-installers)
    -   [创建离线安装程序 Creating Offline Installers](https://www.cnblogs.com/oloroso/p/6775243.html#创建离线安装程序-creating-offline-installers)
    -   [创建在线安装程序 Creating Online Installers](https://www.cnblogs.com/oloroso/p/6775243.html#创建在线安装程序-creating-online-installers)
        -   [创建存储库 Creating Repositories](https://www.cnblogs.com/oloroso/p/6775243.html#创建存储库-creating-repositories)
        -   [配置存储库 Configuring Repositories](https://www.cnblogs.com/oloroso/p/6775243.html#配置存储库-configuring-repositories)
        -   [创建安装程序二进制文件 Creating Installer Binaries](https://www.cnblogs.com/oloroso/p/6775243.html#创建安装程序二进制文件-creating-installer-binaries)
        -   [减少安装程序文件大小 Reducing Installer Size](https://www.cnblogs.com/oloroso/p/6775243.html#减少安装程序文件大小-reducing-installer-size)
    -   [促进更新 Promoting Updates](https://www.cnblogs.com/oloroso/p/6775243.html#促进更新-promoting-updates)
        -   [配置更新 Configuring Updates](https://www.cnblogs.com/oloroso/p/6775243.html#配置更新-configuring-updates)
        -   [重新创建存储库 Recreating Repositories](https://www.cnblogs.com/oloroso/p/6775243.html#重新创建存储库-recreating-repositories)
        -   [部分更新存储库](https://www.cnblogs.com/oloroso/p/6775243.html#部分更新存储库)
        -   [创建部分更新 Creating Partial Updates](https://www.cnblogs.com/oloroso/p/6775243.html#创建部分更新-creating-partial-updates)
        -   [上传部分更新 Uploading Partial Updates](https://www.cnblogs.com/oloroso/p/6775243.html#上传部分更新-uploading-partial-updates)
        -   [更改存储库 Changing Repositories](https://www.cnblogs.com/oloroso/p/6775243.html#更改存储库-changing-repositories)
            -   [添加存储库 Adding Repositories](https://www.cnblogs.com/oloroso/p/6775243.html#添加存储库-adding-repositories)
            -   [删除存储库 Removing Repositories](https://www.cnblogs.com/oloroso/p/6775243.html#删除存储库-removing-repositories)
            -   [替换存储库 Replacing Repositories](https://www.cnblogs.com/oloroso/p/6775243.html#替换存储库-replacing-repositories)
    -   [自定义安装程序 Customizing Installers](https://www.cnblogs.com/oloroso/p/6775243.html#自定义安装程序-customizing-installers)
        -   [添加操作 Adding Operations](https://www.cnblogs.com/oloroso/p/6775243.html#添加操作-adding-operations)
        -   [添加页面 Adding Pages](https://www.cnblogs.com/oloroso/p/6775243.html#添加页面-adding-pages)
            -   [使用组件脚本添加页面 Using Component Scripts to Add Pages](https://www.cnblogs.com/oloroso/p/6775243.html#使用组件脚本添加页面-using-component-scripts-to-add-pages)
            -   [使用控制脚本添加页面 Using Control Scripts to Add Pages](https://www.cnblogs.com/oloroso/p/6775243.html#使用控制脚本添加页面-using-control-scripts-to-add-pages)
        -   [添加小部件 Adding Widgets](https://www.cnblogs.com/oloroso/p/6775243.html#添加小部件-adding-widgets)
        -   [与安装程序功能交互](https://www.cnblogs.com/oloroso/p/6775243.html#与安装程序功能交互)
        -   [翻译页面 Translating Pages](https://www.cnblogs.com/oloroso/p/6775243.html#翻译页面-translating-pages)

# 4、教程: 创建一个安装程序

本教程介绍如何为小项目创建简单的安装程序：

[![安装起始页面](https://images2015.cnblogs.com/blog/693958/201704/693958-20170427171829006-301333699.png)](https://images2015.cnblogs.com/blog/693958/201704/693958-20170427171829006-301333699.png)

本节介绍以下创建安装程序 **必须** 完成的任务：

1.  创建一个包(package)目录，其中将包含所有配置文件和可安装的包。
2.  创建包含有关如何构建安装程序二进制文件和联机存储库的信息的配置文件。
3.  创建包信息文件，其中包含有关可安装组件的信息。
4.  创建安装程序内容并将其复制到软件包(package)目录中。
5.  使用`binarycreator`工具创建安装程序。  
    安装程序页面是使用您在配置和程序包信息文件中提供的信息创建的。

示例文件位于Qt Installer Framework资源库中的`examples\tutorial`目录中。

## 创建软件包目录[#](https://www.cnblogs.com/oloroso/p/6775243.html#3785518846)

创建一个反映安装程序设计的目录结构，并允许将来扩展安装程序。 该目录必须包含`config`和`packages`的子目录。

[![包目录结构](https://images2015.cnblogs.com/blog/693958/201704/693958-20170427171851319-862661983.png)](https://images2015.cnblogs.com/blog/693958/201704/693958-20170427171851319-862661983.png)

有关软件包目录的详细信息，请参阅[Package Directory](http://doc.qt.io/qtinstallerframework/ifw-component-description.html)。

## 创建配置文件[#](https://www.cnblogs.com/oloroso/p/6775243.html#4277701837)

在`config`目录中，创建一个名为`config.xml`的文件，其中包含以下内容：

```
Copy Highlighter-hljs<?xml version="1.0" encoding="UTF-8"?>
<Installer>
    <Name>Your application</Name>
    <Version>1.0.0</Version>
    <Title>Your application Installer</Title>
    <Publisher>Your vendor</Publisher>
    <StartMenuDir>Super App</StartMenuDir>
    <TargetDir>@HomeDir@/InstallationDirectory</TargetDir>
</Installer>

```

该配置文件指定介绍页面上显示以下信息：

`<Title`元素指定显示在标题栏 _(下图\[1\])_ 上的安装程序名称。  
`<Name`元素指定添加到页面名称和简介文本 _(下图\[2\])_ 的应用程序名称。

[![介绍页面](https://images2015.cnblogs.com/blog/693958/201704/693958-20170427171921506-1927411748.png)](https://images2015.cnblogs.com/blog/693958/201704/693958-20170427171921506-1927411748.png)

其他元素用于自定义安装程序的行为：

-   `<Version>`元素指定应用程序版本号。
-   `<Publisher>`元素指定软件的发布者（例如，在Windows控制面板中所示）。
-   `<StartMenuDir>`元素指定Windows开始菜单中产品的默认程序组的名称。
-   `<TargetDir>`元素指定显示给用户的默认目标目录是当前用户的主目录中的InstallationDirectory（因为预定义变量@HomeDir@用作值的一部分）。 有关详细信息，请参阅预定义变量。

有关配置文件格式和可用元素的详细信息，请参阅[Configuration File](http://doc.qt.io/qtinstallerframework/ifw-globalconfig.html)。

## 创建程序包信息文件[#](https://www.cnblogs.com/oloroso/p/6775243.html#644046411)

在这种简单的情况下，安装程序只处理一个名为`com.vendor.product`的组件。 要向安装程序提供有关组件的信息，请创建一个名为`package.xml`的文件，其中包含以下内容，并将其放在`meta`目录中：

```
Copy Highlighter-hljs<?xml version="1.0" encoding="UTF-8"?>
<Package>
    <DisplayName>The root component</DisplayName>
    <Description>Install this example.</Description>
    <Version>0.1.0-1</Version>
    <ReleaseDate>2010-09-21</ReleaseDate>
    <Licenses>
        <License name="Beer Public License Agreement" file="license.txt" />
    </Licenses>
    <Default>script</Default>
    <Script>installscript.qs</Script>
    <UserInterfaces>
        <UserInterface>page.ui</UserInterface>
    </UserInterfaces>
</Package>

```

下面更详细地描述示例文件中的元素。  
有关软件包信息文件的详细信息，请参阅[Package Information File Syntax](http://doc.qt.io/qtinstallerframework/ifw-component-description.html#package-information-file-syntax)

## 指定组件信息[#](https://www.cnblogs.com/oloroso/p/6775243.html#3365732183)

来自以下元素的信息显示在组件选择页面上：

`<DisplayName>`元素指定组件列表中组件的名称 _(下图\[1\])_ 。  
`<Description>`元素指定在选择组件时显示的文本 _(下图\[2\])_ 。

[![组件选择](https://images2015.cnblogs.com/blog/693958/201704/693958-20170427171943990-720833375.png)](https://images2015.cnblogs.com/blog/693958/201704/693958-20170427171943990-720833375.png)

## 指定安装程序版本[#](https://www.cnblogs.com/oloroso/p/6775243.html#1506818465)

`<Versionss>`元素使您能够在用户有可用更新时提醒用户进行更新。

## 添加许可证[#](https://www.cnblogs.com/oloroso/p/6775243.html#1393867187)

`<License>`元素指定包含许可协议文本 _(下图\[1\])_ 的文件名称，该文本显示在许可检查页上：

[![许可证检查](https://images2015.cnblogs.com/blog/693958/201704/693958-20170427172009725-352890100.png)](https://images2015.cnblogs.com/blog/693958/201704/693958-20170427172009725-352890100.png)

## 选择默认内容[#](https://www.cnblogs.com/oloroso/p/6775243.html#1218499022)

`<Default>`元素指定默认情况下是否选择组件。值为`true`的组件将设置为选定。 在此示例中，我们使用脚本在运行时解析值。 JavaScript脚本文件`installscript.qs`的名称在`<Script>`元素中指定。

## 创建安装程序内容[#](https://www.cnblogs.com/oloroso/p/6775243.html#4249463289)

要安装的内容存储在组件的`data`目录中。 因为只有一个组件，请将数据放在`packages/com.vendor.product/data`目录中。 该示例已包含用于测试目的的文件，但您基本上可以将任何文件放在目录中。

有关打包规则和选项的详细信息，请参阅数据目录。

## 创建安装程序二进制文件[#](https://www.cnblogs.com/oloroso/p/6775243.html#1175988457)

您现在可以创建您的第一个安装程序。 在命令行上切换到`examples\tutorial`目录。 要创建一个名为`YourInstaller.exe`一个安装程序，其中包含`com.vendor.product`标识的包，输入以下命令：

**在Windows上:**

```
Copy Highlighter-hljs..\..\bin\binarycreator.exe -c config\config.xml -p packages YourInstaller.exe

```

**在Linux 或 OS 上:**

```
Copy Highlighter-hljs../../bin/binarycreator -c config/config.xml -p packages YourInstaller

```

安装程序会在当前目录中创建，你可以提供给最终用户。

有关使用binarycreator工具的更多信息，请参阅[binarycreator](http://doc.qt.io/qtinstallerframework/ifw-tools.html#binarycreator)。

注意：如果在运行教程安装程序时显示错误消息，请检查是否使用静态构建的Qt创建安装程序。 有关更多信息，请参阅[Configuring Qt](http://doc.qt.io/qtinstallerframework/ifw-getting-started.html#configuring-qt)。

# 5、创建安装程序 Creating Installers

创建离线和联机安装程序需要以下步骤：

-   1.  为可安装组件创建包目录。相关相信信息，请参阅[Package Directory](http://doc.qt.io/qtinstallerframework/ifw-component-description.html)
-   2.  在config目录中创建一个名为`config.xml`的配置文件。 它包含有关如何构建安装程序二进制文件和联机存储库的信息。 有关文件格式和可用设置的详细信息，请参阅[Configuration File](http://doc.qt.io/qtinstallerframework/ifw-globalconfig.html)
-   3.  在`config\meta`目录中创建一个名为`package.xml`的包信息文件。 它包含部署和安装过程的设置。 有关详细信息，请参阅[Meta Directory](http://doc.qt.io/qtinstallerframework/ifw-component-description.html#meta-directory)
-   4.  创建安装程序内容并将其复制到软件包目录中。 有关详细信息，请参阅[Data Directory](http://doc.qt.io/qtinstallerframework/ifw-component-description.html#data-directory)
-   5.  对于联机安装程序，请使用`repogen`工具创建包含可安装内容的存储库，并将存储库上载到Web服务器。
-   6.  使用binarycreator工具创建安装程序。 有关详细信息，请参阅[Tools](http://doc.qt.io/qtinstallerframework/ifw-tools.html)

有关如何创建使用预定义安装程序页面的简单安装程序的示例，请参阅[Tutorial: Creating an Installer](https://www.cnblogs.com/oloroso/p/6775243.html#4)

以下部分介绍如何创建不同类型的安装程序：

## 创建离线安装程序 Creating Offline Installers[#](https://www.cnblogs.com/oloroso/p/6775243.html#2829267986)

在安装期间， **离线安装程序** 根本不尝试连接到联机存储库。 但是，元数据配置（config.xml）中可以设置允许用户在线添加和更新组件。

离线安装程序在公司防火墙不允许最终用户连接到Web服务器的情况下尤其有用。 网络管理员可以在网络中设置本地更新服务。

要创建离线安装程序，请使用`binarycreator`工具的`--offline-only`选项。

要在Windows中创建离线安装程序，请输入以下命令：

```
Copy Highlighter-hljs<location-of-ifw>\binarycreator.exe --offline-only -t <location-of-ifw>\installerbase.exe -p <package_directory> -c <config_directory>\<config_file> <installer_name>

```

译注:`<location-of-ifw>`表示`binarycreator`程序所在目录。

某些选项具有默认值，所以，可以忽略它们。例如，输入以下命令来创建名为SDKInstaller.exe的安装程序二进制文件，其中包含由org.qt-project.sdk标识的软件包及其依赖关系：

```
Copy Highlighter-hljsbinarycreator.exe --offline-only -c installer-config -p installer-packes SDKInstaller.exe

```

## 创建在线安装程序 Creating Online Installers[#](https://www.cnblogs.com/oloroso/p/6775243.html#3472187709)

联机安装程序获取一个不在二进制文件中的存储库描述`(Update.xml)`。创建存储库并将其上传到Web服务器。 然后在用于创建安装程序的config.xml文件中指定存储库的位置。

### 创建存储库 Creating Repositories[#](https://www.cnblogs.com/oloroso/p/6775243.html#3112189972)

使用`repogen`工具创建一个软件包目录的所有软件包的联机存储库：

```
Copy Highlighter-hljsrepogen.exe -p <package_directory> <repository_directory>

```

例如，要创建只包含`org.qt-project.sdk.qt`和`org.qt-project.sdk.qtcreator`的存储库，请输入以下命令：  
\`

```
Copy Highlighter-hljsrepogen.exe -p packages -i org.qt-project.sdk.qt,org.qt-project.sdk.qtcreator repository

```

创建存储库后，将其上传到Web服务器。 您必须在安装程序配置文件(config.xml)中指定存储库的位置。

### 配置存储库 Configuring Repositories[#](https://www.cnblogs.com/oloroso/p/6775243.html#348989408)

安装程序配置文件`(config.xml)`中的`<RemoteRepositories>`元素可以包含多个存储库列表。 每个存储库都可以有以下设置项：

-   `<Url>`, 指向可用组件列表。
-   `<Enabled>`, 0表示禁用此存储库。
-   `<Username>`, 用于受保护存储库验证的用户名。
-   `<Password>`, 用于受保护存储库验证的密码。
-   `<DisplayName>`, 可选，设置要显示的字符串，而不是URL。

URL需要指向列出可用组件的Updates.xml文件。 例如：

```
Copy Highlighter-hljs<RemoteRepositories>
     <Repository>
             <Url>http://www.example.com/packages</Url>
             <Enabled>1</Enabled>
             <Username>user</Username>
             <Password>password</Password>
             <DisplayName>Example repository</DisplayName>
     </Repository>
</RemoteRepositories>

```

仅当安装程序 **可以访问存储库** 时，安装程序才会继续。 如果在安装后访问存储库，维护工具将拒绝安装。 但是，卸载后可再次安装。 默认情况下可以启用或禁用存储库。 对于需要验证的存储库，也可以在此处设置详细信息，但在此输入密码通常不可取，因为它以纯文本保存。 若此处未设置身份验证详细信息，将在 **运行时通过对话框获取** 。 用户可以在运行时解决这些设置。

### 创建安装程序二进制文件 Creating Installer Binaries[#](https://www.cnblogs.com/oloroso/p/6775243.html#4007650954)

要使用binarycreator工具创建联机安装程序，请输入以下命令：

```
Copy Highlighter-hljs<location-of-ifw>\binarycreator.exe -t <location-of-ifw>\installerbase.exe -p <package_directory> -c <config_directory>\<config_file> -e <packages> <installer_name>

```

例如，输入以下命令以创建名为`SDKInstaller.exe`的安装程序二进制文件，其中 **不包含** `org.qt-project.sdk.qt`和`org.qt-project.qtcreator`的数据，因为这些软件包是 **从远程存储库下载** 的：

```
Copy Highlighter-hljsbinarycreator.exe -p installer-packages -c installer-config\config.xml -e org.qt-project.sdk.qt,org.qt-project.qtcreator SDKInstaller.exe

```

### 减少安装程序文件大小 Reducing Installer Size[#](https://www.cnblogs.com/oloroso/p/6775243.html#587993663)

即使组件从Web服务器获取，`binarycreator` **仍然会将它们添加到安装程序二进制文件** 中。 但是，当安装程序检查Web服务器上的更新时，如果新版本不可用，则最终用户可以免于下载。

或者，您可以创建不包含任何数据仅从Web服务器获取所有数据的联机安装程序。 使用`binarycreator`工具的`-n`参数，并且只将`根(root)组件`添加到安装程序。 通常根(root)组件是空的，因此只添加根(root)的XML描述。

更多相关选项的详细信息，请参阅[Summary of binarycreator Parameters](http://doc.qt.io/qtinstallerframework/ifw-tools.html#summary-of-binarycreator-parameters)

## 促进更新 Promoting Updates[#](https://www.cnblogs.com/oloroso/p/6775243.html#2485127214)

促进更新这是一个很别扭的翻译，这里的意思是在运行联机安装程序的时候，会去读取存储库中的`Update.xml`文件来判断是否需要下载更新。

创建在联机程序，以便能够向最终安装产品用户促进更新。

需要以下步骤来促进更新：

-   1.  复制要更新的内容到软件包目录。
-   2.  增加`package.xml`文件中已更新组件的`<Version>`元素的值。
-   3.  使用`repogen`工具重新创建具有更新内容的联机存储库，并在存储库的根目录中生成`Updates.xml`文件。
-   4.  将存储库上传到Web服务器。
-   5.  使用`binarycreator`工具创建安装程序。

### 配置更新 Configuring Updates[#](https://www.cnblogs.com/oloroso/p/6775243.html#2337610198)

安装程序在启动时下载`Updates.xml`文件，并将安装的版本与文件中的版本进行比较。 如果联机版本号大于本地版本号，安装程序将在可用更新列表中显示它。

增加`package.xml`文件中组件的`<Version>`元素的值。

### 重新创建存储库 Recreating Repositories[#](https://www.cnblogs.com/oloroso/p/6775243.html#2842259713)

提供更新的最简单方法是重新创建资源库，并上传到Web服务器。 有关更多信息，请参阅[创建存储库 Creating Repositories](https://www.cnblogs.com/oloroso/p/6775243.html#5_2_1)

### 部分更新存储库[#](https://www.cnblogs.com/oloroso/p/6775243.html#2102796661)

整个库完全更新可能不是最优的，如果：

-   存储库非常大，因为上传需要很长时间。
-   你想只提供更新的组件。

**注意：** `repogen`会在每次调用时重新创建7zip存档。 由于7zip存储所包含的文件的时间戳（在此过程中被移动或复制时改变），每个归档的SHA值将改变。 SHA校验和值用于验证下载的存档，因此需要匹配7zip的SHA值。 由于SHA值存储在Updates.xml文件中，因此将强制您上传完整存储库。 这可以通过使用`repogen`的`--update`选项来规避。

### 创建部分更新 Creating Partial Updates[#](https://www.cnblogs.com/oloroso/p/6775243.html#2108562226)

在重新创建联机存储库时，请使用`--update`参数。 它将现有存储库作为输入，并仅更改附加参数指定的组件。 那些SHA值在全局配置中也被改变。

### 上传部分更新 Uploading Partial Updates[#](https://www.cnblogs.com/oloroso/p/6775243.html#2403043224)

上传下列项目到Web服务器：

-   组件目录（通常类似于com.vendor.product.updatedpart）。
-   全局Updates.xml存储在联机存储库的根目录中。

**注意：** 上传项目的顺序非常重要。 如果在实时服务器上更新存储库，请首先更新组件，然后更新`Updates.xml`。 软件包名称包括版本号，因此，在新软件包完全上传前，最终用户会收到旧软件包。

### 更改存储库 Changing Repositories[#](https://www.cnblogs.com/oloroso/p/6775243.html#3436661400)

要使当前更新存储库指向其他存储库，请编辑当前存储库中的`Updates.xml`文件。 您可以`添加`，`替换`或`删除`存储库。

```
Copy Highlighter-hljs<RepositoryUpdate>
  <Repository action="..." OPTIONS />
  <Repository action="..." OPTIONS />
</RepositoryUpdate>

```

#### 添加存储库 Adding Repositories[#](https://www.cnblogs.com/oloroso/p/6775243.html#1026714598)

要更新(原文是Update，猜测应该是添加)存储库，请将 **具有以下选项** `<Repository>`子元素添加到`<RepositoryUpdate>`元素中：

```
Copy Highlighter-hljs<Repository action="add" url="http://www.example.com/repository" name="user" password="password"
             displayname="Example Repository" />

```

#### 删除存储库 Removing Repositories[#](https://www.cnblogs.com/oloroso/p/6775243.html#2929906812)

要删除存储库，请将 **具有以下选项** `<Repository>`子元素添加到`<RepositoryUpdate>`元素中：

```
Copy Highlighter-hljs<Repository action="remove" url="http://www.example.com/repository" />

```

#### 替换存储库 Replacing Repositories[#](https://www.cnblogs.com/oloroso/p/6775243.html#2409328822)

要用一个存储库替换另一个，请将 **具有以下选项** `<Repository>`子元素添加到`<RepositoryUpdate>`元素中：

```
Copy Highlighter-hljs<Repository action="replace" oldurl="http://www.example.com/repository"
            newurl="http://www.example.com/newrepository" name="user" password="password"
            displayname="New Example Repository" />

```

## 自定义安装程序 Customizing Installers[#](https://www.cnblogs.com/oloroso/p/6775243.html#1569397000)

您可以使用脚本通过以下方式自定义安装程序：

-   添加由脚本编译的Qt Installer Framework 操作，并由安装程序来执行。
-   在`package.xml`文件中指定添加的新页面，并存放到`package`目录中。
-   通过修改现有页面，将自定义的用户界面元素作为单个widgets小部件插入其中。
-   添加语言(variants)

您可以使用`组件脚本(component scripts)`和`控制脚本(control script)`来自定义安装程序。组件脚本在组件的`package.xml`文件的`<Script>`元素中指定，与特定组件相关联。在 **获取组件的元数据时加载脚本** 。有关组件脚本的更多信息，请参阅[组件脚本Controller Scripting](http://doc.qt.io/qtinstallerframework/noninteractive.html)。

有关可在组件和控制脚本中使用的全局JavaScript对象的更多信息，请参阅[Scripting API](http://doc.qt.io/qtinstallerframework/scripting-qmlmodule.html)。

### 添加操作 Adding Operations[#](https://www.cnblogs.com/oloroso/p/6775243.html#778973937)

您可以使用组件脚本在安装过程中执行Qt Installer Framework操作。 通常，通过`移动`，`复制`或`修补`来操作文件。 使用[`QInstaller::Component::addOperation`](http://doc.qt.io/qtinstallerframework/qinstaller-component.html#addOperation)或[`QInstaller::Component::addElevatedOperation`](http://doc.qt.io/qtinstallerframework/qinstaller-component.html#addElevatedOperation)函数添加操作。 有关更多信息，请参阅[向组件添加操作 Adding Operations to Components](http://doc.qt.io/qtinstallerframework/scripting.html#adding-operations-to-components)。

此外，您可以通过派生[`KDUpdater::UpdateOperation`](http://doc.qt.io/qtinstallerframework/kdupdater-updateoperation.html)来实现在安装程序中注册自定义安装操作的方法。 有关详细信息，请参阅[注册自定义操作 Registering Custom Operations](http://doc.qt.io/qtinstallerframework/scripting.html#registering-custom-operations)。

有关可用操作的信息，请参阅[操作Operations](http://doc.qt.io/qtinstallerframework/operations.html)。

### 添加页面 Adding Pages[#](https://www.cnblogs.com/oloroso/p/6775243.html#4253550112)

组件可以包含一个或多个用户界面文件，这些文件由组件或控制脚本放置到安装程序中(在安装程序执行时加载)。 安装程序将自动加载`package.xml`文件的`UserInterfaces`元素中列出的所有用户界面文件。

#### 使用组件脚本添加页面 Using Component Scripts to Add Pages[#](https://www.cnblogs.com/oloroso/p/6775243.html#1250062924)

要向安装程序添加新页面，请使用[`installer::addWizardPage()`](http://doc.qt.io/qtinstallerframework/scripting-installer.html#addWizardPage-method)方法并指定新页面的位置。 例如，以下代码在 **准备安装页面** 之前添加了一个`MyPage`的实例：

```
Copy Highlighter-hljsinstaller.addWizardPage( component, "MyPage", QInstaller.ReadyForInstallation );

```

您可以使用组件脚本通过调用[`component::userInterface()`](http://doc.qt.io/qtinstallerframework/scripting-component.html#userInterface-method)方法访问加载的小部件的类名，如下面的代码段所示：

```
Copy Highlighter-hljscomponent.userInterface( "MyPage" ).checkbox.checked = true;

```

#### 使用控制脚本添加页面 Using Control Scripts to Add Pages[#](https://www.cnblogs.com/oloroso/p/6775243.html#1050832078)

要注册自定义页面，请使用`installer::addWizardPage()`方法和U并文件中设置的对象名称（例如“MyPage”）。 然后调用`Dynamic${ObjectName}Callback()`函数（例如，`DynamicMyPageCallback()`）：

```
Copy Highlighter-hljsfunction Controller()
{
    installer.addWizardPage(component, "MyPage", QInstaller.TargetDirectory)
}

Controller.prototype.DynamicMyPageCallback()
{
    var page = gui.pageWidgetByObjectName("DynamicMyPage");
    page.myButton.click,
    page.myWidget.subWidget.setText("hello")
}

```

您可以通过使用在UI文件中设置的对象名称来访问窗口小部件。 例如，在上面的代码中`myButton`和`myWidget`就是控件对象名称。

### 添加小部件 Adding Widgets[#](https://www.cnblogs.com/oloroso/p/6775243.html#667512307)

您可以使用组件或控制脚本将自定义用户界面元素作为单个窗口小部件（例如复选框）插入到安装程序中。

要插入单个窗口小部件，请使用[`installer::addWizardPageItem`](http://doc.qt.io/qtinstallerframework/scripting-installer.html#addWizardPageItem-method)方法。 例如，以下代码片段从脚本中将`MyWidget`的实例添加到 **组件选择页面** ：

```
Copy Highlighter-hljsinstaller.addWizardPageItem( component, "MyWidget", QInstaller.ComponentSelection );

```

### 与安装程序功能交互[#](https://www.cnblogs.com/oloroso/p/6775243.html#3463603461)

例如，您可以使用控制脚本在测试中自动执行安装程序功能。 以下代码段说明如何自动单击目标目录选择页上的 **下一步(Next)** 按钮：

```
Copy Highlighter-hljsController.prototype.TargetDirectoryPageCallback = function()
{
    gui.clickButton(buttons.NextButton);
}

```

### 翻译页面 Translating Pages[#](https://www.cnblogs.com/oloroso/p/6775243.html#3633248958)

安装程序使用`Qt Translation`系统支持将用户可读输出转换为多种语言。 要向最终用户提供组件脚本和用户界面中包含的字符串的 **本地化版本** ，请创建随组件一起加载的`QTranslator`文件。 安装程序加载与当前系统区域设置匹配的翻译文件。 例如，如果系统语言环境是德语，则会加载de.qm文件。 此外，如果找到，将显示本地化license\_de.txt而不是默认的license.txt。

需要将翻译添加到激活组件的`package.xml`文件中：

```
Copy Highlighter-hljs<Translations>
    <Translation>de.qm</Translation>
</Translations>

```

对脚本中的文本文本使用`qsTr()`函数。 此外，您可以将`Component.prototype.retranslateUi`方法添加到脚本。 当安装程序的语言更改并加载翻译文件时调用。

当在翻译用户界面时使用`qsTr`或`UI文件的类名`,用于翻译的上下文是脚本文件的基本名称。例如，如果脚本文件被称为`installscript.qs`，上下文将是`installscript`。

注意：翻译系统也可用于自定义UI。 使用例如一个`en.ts`文件作为自定义英语版本替换安装程序中的任何文本。