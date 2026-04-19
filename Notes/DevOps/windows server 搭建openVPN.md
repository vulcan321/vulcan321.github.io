# Windows server 2012、2016、2019上搭建openVPN

## 步骤一：安装OpenVPN服务[](https://javabase.cn/docs/devops/windows/install-openvpn-server//#步骤一安装openvpn服务 "Direct link to heading")

下载最新版本的OpenVPN服务端，可以从这个地址下载：

[Community Downloads | OpenVPN](https://openvpn.net/community-downloads/)

下载的文件名为：OpenVPN-2.5.5-I602-amd64.msi双击安装，选择“Customize”

![1.png](https://oss.javabase.cn/1665971106834?watermark/4/text/amF2YWJhc2UuY24=/rotate/-20/font/6buR5L2T/fontsize/200/fill/I0ZGRkZGRg==/dissolve/50/dx/100/dy/100)

默认情况下不会安装的两个特性，我们需要在安装过程中进行选择。

-   OpenVPN Service
-   OpenSSL Utilities

![1.png](https://oss.javabase.cn/1665971263362?watermark/4/text/amF2YWJhc2UuY24=/rotate/-20/font/6buR5L2T/fontsize/200/fill/I0ZGRkZGRg==/dissolve/50/dx/100/dy/100)

![2.png](https://oss.javabase.cn/1665971270076?watermark/4/text/amF2YWJhc2UuY24=/rotate/-20/font/6buR5L2T/fontsize/200/fill/I0ZGRkZGRg==/dissolve/50/dx/100/dy/100)

点击install now,安装完成后,点击close。

这时会弹出一个提醒框，提示没有找到可连接的配置文件，现在不用管它，点击ok即可。

我们打开网络和共享中心，点击更改适配器设置，可以看到多了两个网络连接

![1.png](https://oss.javabase.cn/1665971353089?watermark/4/text/amF2YWJhc2UuY24=/rotate/-20/font/6buR5L2T/fontsize/200/fill/I0ZGRkZGRg==/dissolve/50/dx/100/dy/100)

## 步骤二：设置CA证书、生成服务端和客户端的证书和私钥等[](https://javabase.cn/docs/devops/windows/install-openvpn-server//#步骤二设置ca证书生成服务端和客户端的证书和私钥等 "Direct link to heading")

找到目录“C:\\Program Files\\OpenVPN\\easy-rsa”，将文件vars.example复制一份改名为vars，“vars”文件包含内置的Easy-RSA配置设置。可以保持默认设置，也可以自定义更改。

| 属性 | 默认值 | 作用 |
| --- | --- | --- |
| set\_var EASYRSA | C:\\Program Files\\OpenVPN\\easy-rsa | Defines the folder location of easy-rsa scripts |
| set\_var EASYRSA\_OPENSSL | C:\\Program Files\\OpenVPN\\bin\\openssl.exe | Defines the OpenSSL binary path |
| set\_var EASYRSA\_PKI | C:\\Program Files\\OpenVPN\\easy-rsa\\pki | The folder location of SSL/TLS file exists after creation |
| set\_var EASYRSA\_DN | cn\_only | This is used to adjust what elements are included in the Subject field as the DN |
| set\_var EASYRSA\_REQ\_COUNTRY | “US” | Our Organisation Country |
| set\_var EASYRSA\_REQ\_PROVINCE | “California” | Our Organisation Province |
| set\_var EASYRSA\_REQ\_CITY | “San Francisco” | Our Organisation City |
| set\_var EASYRSA\_REQ\_ORG | “Copyleft Certificate Co” | Our Organisation Name |
| set\_var EASYRSA\_REQ\_EMAIL | “[me@example.net](mailto:me@example.net)” | Our Organisation contact email |
| set\_var EASYRSA\_REQ\_OU | “My Organizational Unit” | Our Organisation Unit name |
| set\_var EASYRSA\_KEY\_SIZE | 2048 | Define the key pair size in bits |
| set\_var EASYRSA\_ALGO | rsa | The default crypt mode |
| set\_var EASYRSA\_CA\_EXPIRE | 3650 | The CA key expire days |
| set\_var EASYRSA\_CERT\_EXPIRE | 825 | The Server certificate key expire days |
| set\_var EASYRSA\_NS\_SUPPORT | “no” | Support deprecated Netscape extension |
| set\_var EASYRSA\_NS\_COMMENT | “HAKASE-LABS CERTIFICATE AUTHORITY” | Defines NS comment |
| set\_var EASYRSA\_EXT\_DIR | "$EASYRSA/x509-types" | Defines the x509 extension directory |
| set\_var EASYRSA\_SSL\_CONF | "$EASYRSA/openssl-easyrsa.cnf" | Defines the openssl config file location |
| set\_var EASYRSA\_DIGEST | "sha256" | Defines the cryptographic digest to use |

如没有特殊要求，则vars文件保持默认即可。

现在打开cmd（管理员权限），切换到“C:\\Program Files\\OpenVPN\\easy-rsa”目录下

```
cd C:\Program Files\OpenVPN\easy-rsaEasyRSA-Start.bat
```

输入EasyRSA-Start.bat回车后，我们会进入到easy-rsa3的shell会话

![1.png](https://oss.javabase.cn/1665971777523?watermark/4/text/amF2YWJhc2UuY24=/rotate/-20/font/6buR5L2T/fontsize/200/fill/I0ZGRkZGRg==/dissolve/50/dx/100/dy/100)

执行init-pki来创建pki目录

```
./easyrsa init-pki
```

![1.png](https://oss.javabase.cn/1665971814511?watermark/4/text/amF2YWJhc2UuY24=/rotate/-20/font/6buR5L2T/fontsize/200/fill/I0ZGRkZGRg==/dissolve/50/dx/100/dy/100)

现在，使用下面的命令构建证书颁发机构(CA)密钥。这个CA根证书文件稍后将用于签署其他证书和密钥。我们使用的“nopass”选项用于禁用密码。

```
./easyrsa build-ca nopass
```

命令将被要求输入通用名称。这里我输入的VPN服务器主机名是OPENVPNSERVER，这是一种常见的做法。在这里，我们可以自由使用任何名称或值。同时创建的CA证书将被保存到文件夹“C:\\Program Files\\OpenVPN\\easy-rsa\\pki”，文件名为“ca .crt”。请参考下面的截图。

![1.png](https://oss.javabase.cn/1665971866009?watermark/4/text/amF2YWJhc2UuY24=/rotate/-20/font/6buR5L2T/fontsize/200/fill/I0ZGRkZGRg==/dissolve/50/dx/100/dy/100)

现在使用下面的命令构建一个服务器证书和密钥。这里将< SERVER >替换为您自己的服务器名。我还使用Option nopass来禁用密码。

```
./easyrsa build-server-full <SERVER> nopass
./easyrsa build-server-full vulcan321 nopass
```

颁发的服务器证书将在“C:\\Program Files\\OpenVPN\\easy-rsa\\pki\\issued”文件夹中，文件名为SERVER .crt。

![1.png](https://oss.javabase.cn/1665971909144?watermark/4/text/amF2YWJhc2UuY24=/rotate/-20/font/6buR5L2T/fontsize/200/fill/I0ZGRkZGRg==/dissolve/50/dx/100/dy/100)

这里可以使用以下命令进行验证，返回ok就没问题

```
openssl verify -CAfile pki/ca.crt pki/issued/SERVER.crt
```

现在，使用下面的命令构建客户端证书和密钥。将< CLIENT >替换为您的客户端名称。也使用选项nopass来禁用密码。

```
./easyrsa build-client-full <CLIENT> nopass
./easyrsa build-client-full vulcan321_client01 nopass
```

颁发的客户端证书也会被保存到“C:\\Program Files\\OpenVPN\\easy-rsa\\pki\\issued”文件夹中，文件名为“CLIENT.crt”。

![1.png](https://oss.javabase.cn/1665971967427?watermark/4/text/amF2YWJhc2UuY24=/rotate/-20/font/6buR5L2T/fontsize/200/fill/I0ZGRkZGRg==/dissolve/50/dx/100/dy/100)

同样这里可以使用以下命令进行验证，返回ok就没问题

```
openssl verify -CAfile pki/ca.crt pki/issued/CLIENT.crt
```

#### 到这里就完成了CA证书，服务器和客户端证书的生成和密钥。这些密钥将用于OpenVPN服务器和客户端之间的身份验证。现在生成一个用于标准RSA证书/密钥之外的共享密钥。文件名为tls-auth.key。[](https://javabase.cn/docs/devops/windows/install-openvpn-server//#到这里就完成了ca证书服务器和客户端证书的生成和密钥这些密钥将用于openvpn服务器和客户端之间的身份验证现在生成一个用于标准rsa证书密钥之外的共享密钥文件名为tls-authkey "Direct link to heading")

> 使用这个密钥，我们启用TLS -auth指令，它添加一个额外的HMAC签名到所有SSL/TLS握手包的完整性验证。任何不带有正确HMAC签名的UDP包可以被丢弃而无需进一步处理。 启用tls-auth可以保护我们免受：
> 
> -   OpenVPN UDP端口上的DoS攻击或端口泛洪。
> -   端口扫描，以确定哪些服务器UDP端口处于侦听状态。
> -   SSL/TLS实现中的缓冲区溢出漏洞。
> -   从未经授权的机器发起SSL/TLS握手。

#### 首先使用GitHub链接[https://github.com/TinCanTech/easy-tls](https://github.com/TinCanTech/easy-tls)下载Easy-TLS。它是一个Easy-RSA扩展工具，我们正在使用它来生成tls-auth密钥。单击code选项卡下的Download zip选项。请参考下面的截图。[](https://javabase.cn/docs/devops/windows/install-openvpn-server//#首先使用github链接httpsgithubcomtincantecheasy-tls下载easy-tls它是一个easy-rsa扩展工具我们正在使用它来生成tls-auth密钥单击code选项卡下的download-zip选项请参考下面的截图 "Direct link to heading")

![1.png](https://oss.javabase.cn/1665972224805?watermark/4/text/amF2YWJhc2UuY24=/rotate/-20/font/6buR5L2T/fontsize/200/fill/I0ZGRkZGRg==/dissolve/50/dx/100/dy/100)

然后解压“easy-tls-master”文件夹，将“easytls”和“easytls-openssl.cnf”文件拷贝到“C:\\Program files \\OpenVPN\\easy-rsa”目录下。查看下面的截图作为参考。

![image-20220120182324122.png](https://oss.javabase.cn/1665972254174?watermark/4/text/amF2YWJhc2UuY24=/rotate/-20/font/6buR5L2T/fontsize/200/fill/I0ZGRkZGRg==/dissolve/50/dx/100/dy/100)

#### 现在回到EasyRSA shell提示符并输入下面的命令。初始化easy-tls脚本程序。[](https://javabase.cn/docs/devops/windows/install-openvpn-server//#现在回到easyrsa-shell提示符并输入下面的命令初始化easy-tls脚本程序 "Direct link to heading")

```
./easytls init-tls
```

#### 现在，使用下面的命令生成tls-auth密钥。[](https://javabase.cn/docs/devops/windows/install-openvpn-server//#现在使用下面的命令生成tls-auth密钥 "Direct link to heading")

```
./easytls build-tls-auth
```

#### 该命令将生成名为“tls-auth”的密钥文件。在“C:\\Program Files\\OpenVPN\\easy-rsa\\pki\\easytls”文件夹下。请参考下面的截图。[](https://javabase.cn/docs/devops/windows/install-openvpn-server//#该命令将生成名为tls-auth的密钥文件在cprogram-filesopenvpneasy-rsapkieasytls文件夹下请参考下面的截图 "Direct link to heading")

![1.png](https://oss.javabase.cn/1665972330196?watermark/4/text/amF2YWJhc2UuY24=/rotate/-20/font/6buR5L2T/fontsize/200/fill/I0ZGRkZGRg==/dissolve/50/dx/100/dy/100)

现在我们需要生成Diffie Hellman参数

> OpenVPN服务器必须要生成Diffie Hellman参数
> 
> 这些参数定义了OpenSSL如何执行Diffie-Hellman (DH)密钥交换。Diffie-Hellman密钥交换是一种通过公共信道安全地交换密码密钥的方法

发出下面的命令，从EasyRSA shell生成Diffie Hellman参数(这个过程可能需要1分钟左右时间)

```
./easyrsa gen-dh
```

该命令将在“C:\\Program Files\\OpenVPN\\easy-rsa\\pki”文件夹下创建dh文件，文件名为“dh .pem”。请参考下面的截图。

![1.png](https://oss.javabase.cn/1665972412743?watermark/4/text/amF2YWJhc2UuY24=/rotate/-20/font/6buR5L2T/fontsize/200/fill/I0ZGRkZGRg==/dissolve/50/dx/100/dy/100)

这就完成了OpenVPN服务所需的SSL/TLS密钥文件的生成。我们将能够在下面的文件夹中找到创建的文件。

| 目录 | 内容 |
| --- | --- |
| C:\\Program Files\\OpenVPN\\easy-rsa\\pki | CA file, DH file and other OpenSSL related files like config file |
| C:\\Program Files\\OpenVPN\\easy-rsa\\pki\\private | Include the private key files of CA, Server and Client certificates |
| C:\\Program Files\\OpenVPN\\easy-rsa\\pki\\easytls | Contains the tls-auth key |
| C:\\Program Files\\OpenVPN\\easy-rsa\\pki\\issued | Contains issued Server and Client certificates |

![1.png](https://oss.javabase.cn/1665972478026?watermark/4/text/amF2YWJhc2UuY24=/rotate/-20/font/6buR5L2T/fontsize/200/fill/I0ZGRkZGRg==/dissolve/50/dx/100/dy/100)

下面是有关文件的简短说明

| Filename | Needed By | Purpose | Secret |
| --- | --- | --- | --- |
| ca.crt | server + all | clients Root CA certificate | No |
| ca.key | Server Only | Root CA key | YES |
| dh.pem | server only | Diffie Hellman parameters | No |
| SERVER.crt | server only | Server Certificate | No |
| SERVER.key | server only | Server Key | Yes |
| CLIENT.crt | Client only | Client Certificate | No |
| CLIENT.key | Client only | Client Key | Yes |
| tls-auth.key | server + all | clients Used for tls-auth directive | No |

## 步骤三：配置ip转发和网络共享[](https://javabase.cn/docs/devops/windows/install-openvpn-server//#步骤三配置ip转发和网络共享 "Direct link to heading")

打开注册表，win+R，输入regedit.exe，依次找到：HKEY\_LOCAL\_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\Tcpip\\Parameters将IPEableRouter值改为1，如下图

![1.png](https://oss.javabase.cn/1665972652297?watermark/4/text/amF2YWJhc2UuY24=/rotate/-20/font/6buR5L2T/fontsize/200/fill/I0ZGRkZGRg==/dissolve/50/dx/100/dy/100)

然后打开控制面板，找到“控制面板\\网络和 Internet\\网络连接”，右键点击“以太网”，点击“属性”，在“共享”中钩上“允许其他网络用户通过此计算机的internet连接来连接”，并选择“OpenVPN TAP-Windows6”，点击确定。

![1.png](https://oss.javabase.cn/1665972682730?watermark/4/text/amF2YWJhc2UuY24=/rotate/-20/font/6buR5L2T/fontsize/200/fill/I0ZGRkZGRg==/dissolve/50/dx/100/dy/100)

![1.png](https://oss.javabase.cn/1665972701099?watermark/4/text/amF2YWJhc2UuY24=/rotate/-20/font/6buR5L2T/fontsize/200/fill/I0ZGRkZGRg==/dissolve/50/dx/100/dy/100)

## 步骤四：创建服务端配置文件[](https://javabase.cn/docs/devops/windows/install-openvpn-server//#步骤四创建服务端配置文件 "Direct link to heading")

首先打开Windows资源管理器，进入C:\\Program Files\\OpenVPN\\sample-config文件夹，将server.ovpn文件复制一份到C:\\Program Files\\OpenVPN\\config目录下。

同时将以下文件一并复制到C:\\Program Files\\OpenVPN\\config目录下

-   ca.crt
-   dh.pem
-   SERVER.crt
-   SERVER.key
-   tls-auth.key

![1.png](https://oss.javabase.cn/1665972746200?watermark/4/text/amF2YWJhc2UuY24=/rotate/-20/font/6buR5L2T/fontsize/200/fill/I0ZGRkZGRg==/dissolve/50/dx/100/dy/100)

编辑server.ovpn文件，修改以下地方，其他保持默认即可

```
local x.x.x.x  # 这个是服务器的内网IP地址，或者保持默认
ca ca.crt
cert SERVER.crt
key SERVER.key
dh dh.pem
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 114.114.114.114" # 可以改成其他的DNS服务器
push "dhcp-option DNS 8.8.8.8"
tls-auth tls-auth.key 0 # This file is secret
cipher AES-256-GCM
```

点击连接，图标变绿就正常。

![1.png](https://oss.javabase.cn/1665972820715?watermark/4/text/amF2YWJhc2UuY24=/rotate/-20/font/6buR5L2T/fontsize/200/fill/I0ZGRkZGRg==/dissolve/50/dx/100/dy/100)

## 配置客户端[](https://javabase.cn/docs/devops/windows/install-openvpn-server//#配置客户端 "Direct link to heading")

复制以下文件到你的客户端，并且在同一目录下

-   ca.crt
-   CLIENT.crt
-   CLIENT.key
-   tls-auth.key
-   client.ovpn（“C:\\Program Files\\OpenVPN\\sample-config”）

编辑client.ovpn，修改以下参数，其他保持默认

```
remote *.*.*.* 1194 # 服务器公网IP地址
ca ca.crt
cert CLIENT.crt
key CLIENT.key
tls-auth tls-auth.key 1
cipher AES-256-GCM
```

下载对应系统的客户端

[OpenVPN Connect Client | Our Official VPN Client | OpenVPN](https://openvpn.net/vpn-client/)

如windows系统，将client.ovpn文件拖入客户端界面即可，如下

![1.png](https://oss.javabase.cn/1665972925634?watermark/4/text/amF2YWJhc2UuY24=/rotate/-20/font/6buR5L2T/fontsize/200/fill/I0ZGRkZGRg==/dissolve/50/dx/100/dy/100)

随后点击连接，出现如下界面则表示连接成功

![1.png](https://oss.javabase.cn/1665972947451?watermark/4/text/amF2YWJhc2UuY24=/rotate/-20/font/6buR5L2T/fontsize/200/fill/I0ZGRkZGRg==/dissolve/50/dx/100/dy/100)

这时ping一下10.8.0.1测试是否连通，ping下百度测试DNS是否正常。

![1.png](https://oss.javabase.cn/1665972971604?watermark/4/text/amF2YWJhc2UuY24=/rotate/-20/font/6buR5L2T/fontsize/200/fill/I0ZGRkZGRg==/dissolve/50/dx/100/dy/100)

这就成功了。

## 吊销客户端证书[](https://javabase.cn/docs/devops/windows/install-openvpn-server//#吊销客户端证书 "Direct link to heading")

当我们创建了多个用户使用，然后某些原因，个别用户需要禁用的时候，我们就可以使用吊销证书的方式来处理。

首先在你的OpenVPN服务器上，打开cmd管理员权限窗口，进入目录“C:\\Program Files\\OpenVPN\\easy-rsa\\”

```
cd "C:\Program Files\OpenVPN\easy-rsa"
EasyRSA-Start.bat
```

进入easyrsa的shell界面

![1.png](https://oss.javabase.cn/1665973033987?watermark/4/text/amF2YWJhc2UuY24=/rotate/-20/font/6buR5L2T/fontsize/200/fill/I0ZGRkZGRg==/dissolve/50/dx/100/dy/100)

输入以下命令

```
# 你要吊销的客户端名
./easyrsa revoke <client>  
# 生成crl.pem文件，用来记录吊销的证书
./easyrsa gen-crl 
```

![1.png](https://oss.javabase.cn/1665973077723?watermark/4/text/amF2YWJhc2UuY24=/rotate/-20/font/6buR5L2T/fontsize/200/fill/I0ZGRkZGRg==/dissolve/50/dx/100/dy/100)

编辑server.ovpn（“C:\\Program Files\\OpenVPN\\config”下），在行尾加入一行

```
crl-verify "C:\\Program Files\\OpenVPN\\easy-rsa\\pki\\crl.pem" # 用来告知服务端有哪些证书是被吊销的
```

这一步如果不做则不会生效，添加了这行之后，服务端重连一下即可。