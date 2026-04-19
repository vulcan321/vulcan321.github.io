# OpenSSL支持的算法有哪些？


<iframe id="aswift_0" style="height: 1px !important; max-height: 1px !important; max-width: 1px !important; width: 1px !important;"><iframe id="google_ads_frame0"></iframe> (adsbygoogle = window.adsbygoogle || \[\]).push({});

### OpenSSL支持的对称加密算法

OpenSSL一共提供了8种对称加密算法，其中7种是分组加密算法，仅有一种流加密算法是RC4。7种分组加密算法分别是AES、DES、Blowfish、CAST、IDEA、RC2、RC4、RC5，都支持电子密码本模式（ECB）、加密分组链接模式（CBC）、加密反馈模式（CFB）和输出反馈模式（OFB）这4种常用的分组密码加密模式。其中，AES使用的加密反馈模式（CFB）和输出反馈模式（OFB）的分组长度是128位，其他算法使用的是64位。事实上，DES算法里面不仅仅是常用的DES算法，还支持三个密钥和两个密钥3DES算法。OpenSSL还使用EVP封装了所有的对称加密算法，使得各种对称加密算法能够使用统一的API接口EVP\_Encrypt和EVP\_Decrypt进行数据的加密和解密，大大提高了代码的可重用性。

### OpenSSL支持的非对称加密算法

OpenSSL一共实现了4种非对称加密算法，包括DH算法、RSA算法、DSA算法和椭圆曲线算法（ECC）。DH算法一般用于密钥交换。RSA算法既可以用于密钥交换，也可以用于数字签名，如果你能够忍受其缓慢的速度，那么也可以用于数据加解密。DSA算法一般只用于数字签名。

跟对称加密算法相似，OpenSSL也使用EVP技术对不同功能的非对称加密算法进行封装，提供了统一的API接口。如果使用非对称加密算法进行密钥交换或者密钥加密，就使用EVPSeal和EVPOpen进行加密和解密；如果使用非对称加密算法进行数字签名，就使用EVP\_Sign和EVP\_Verify进行签名和验证。

### OpenSSL支持的信息摘要算法

OpenSSL实现了5种信息摘要算法，分别是MD2、MD5、MDC2、SHA（SHA1）和RIPEMD。SHA算法事实上包括SHA和SHA1两种信息摘要算法。此外，OpenSSL还实现了DSS标准中规定的两种信息摘要算法：DSS和DSS1。

OpenSSL采用EVPDigest接口作为信息摘要算法统一的EVP接口，对所有信息摘要算法进行封装，提供了代码的重用性。当然，跟对称加密算法和非对称加密算法不一样，信息摘要算法是不可逆的，不需要一个解密的逆函数。