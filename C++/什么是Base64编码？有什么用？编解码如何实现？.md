# 什么是Base64编码？有什么用？编解码如何实现？

发布于2021-08-16 16:02:58阅读 2.8K0

本次为各位小伙伴带来的是一种网络上最常见的用于传输8Bit字节码的编码方式之一，base64编码，基于C语言实现。

  原理性描述摘自：https://www.cnblogs.com/xq1314/p/7909521.html

## **1、Base64编码概述**

  Base64是一种编码方式，这个术语最初是在“MIME内容传输编码规范”中提出的。Base64不是一种加密算法，它实际上是一种“二进制转换到文本”的编码方式，它能够将任意二进制数据转换为ASCII字符串的形式，以便在只支持文本的环境中也能够顺利地传输二进制数据。

（1）base64编码：把二进制数据转为字符；

（2）base64解码：把字符转为二进制数据；

## **2、Base64编码由来**

  因为有些网络传输渠道并不支持所有字节，例如传统的邮件只支持可见字符的传输，像ASCII码的控制字符（ASCII码包含了 128 个字符。其中前 32 个， 0-31 ，即 0x00-0x1F ，都是不可见字符。这些字符，就叫做控制字符。）就不能通过邮件传输。另外，例如图片二进制流的每个字节不可能全部都是可见字符，所以就传送不了。

  最好的方法就是在不改变传统协议的情况下，做一种扩展方案来支持二进制文件的传送，把不可能打印的字符用可打印的字符标识，问题就解决了。Base64编码就应运而生，Base64就是一种基于64个可打印字符来表示二进制数据的表示方法。

## **3、Base64编码原理**

  如下图Base64编码索引表，字符选用了“A-Z 、 a-z 、 0-9、+、 / ”64个可打印字符。数字代表字符索引，这个是标准Base64标准协议规定的，不能更改。64个字节用6个bit位就可以全部表示（32+16+8+4+2+1）就可以全部表示。这里注意一个Base64字符是8个bit，但有效部分只有右边6个bit，左边两个永远是0。

![](https://ask.qcloudimg.com/http-save/yehe-8913398/dcc97d88b04fc0fdbac052d777151c09.png?imageView2/2/w/1620)

  那么怎么用6个有效bit来表示传统字符的8个bit呢？8和6的最小公倍数是24，也就是说3个传统字节可以由4个Base64字符来表示，保证有效位数是一样的，这样就多了1/3的字节数来弥补Base64只有6个有效bit的不足。你也可以说用两个Base64字符也能表示一个传统字符，但是采用最小公倍数的方案其实是最减少浪费的。结合下边的图比较容易理解。Man是三个字符，一共24个有效bit，只好用4个Base64字符来凑齐24个有效位。红框表示的是对应的Base64，6个有效位转化成相应的索引值再对应Base64字符表，查出"Man"对应的Base64字符是"TWFU"。说到这里有个原则不知道你发现了没有，要转换成Base64的最小单位就是三个字节，对一个字符串来说每次都是三个字节三个字节的转换，对应的是Base64的四个字节。这个搞清楚了其实就差不多了。

![](https://ask.qcloudimg.com/http-save/yehe-8913398/5fa946aa35ad0e5bdfb670c0779a3e5e.png?imageView2/2/w/1620)

  但是转换到最后你发现不够三个字节了怎么办呢？愿望终于实现了，我们可以用两个Base64来表示一个字符或用三个Base64表示两个字符，像下图的A对应的第二个Base64的二进制位只有两个，把后边的四个补0就是了。所以A对应的Base64字符就是QQ。上边已经说过了，原则是Base64字符的最小单位是四个字符一组，那这才两个字符，后边补两个"="吧。其实不用"="也不耽误解码，之所以用"="，可能是考虑到多段编码后的Base64字符串拼起来也不会引起混淆。由此可见Base64字符串只可能最后出现一个或两个"="，中间是不可能出现"="的。下图中字符"BC"的编码过程也是一样的。

![](https://ask.qcloudimg.com/http-save/yehe-8913398/52cbac8dde99b39706896d8d66a96116.png?imageView2/2/w/1620)

## **4、Base64编码 c语言代码实现**

```javascript
/******* Base64 Encoding ******************/

static const size_t BASE64_ENCODE_INPUT = 3;
static const size_t BASE64_ENCODE_OUTPUT = 4;
static const char* const BASE64_ENCODE_TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

size_t base64EncodeGetLength( size_t size )
{
    /*
     * output 4 bytes for every 3 input:
     *                1        2        3
     * 1 = --111111 = 111111--
     * 2 = --11XXXX = ------11 XXXX----
     * 3 = --1111XX =          ----1111 XX------
     * 4 = --111111 =                   --111111
     */

    return (((size + BASE64_ENCODE_INPUT - 1) / BASE64_ENCODE_INPUT) * BASE64_ENCODE_OUTPUT) + 1; /*plus terminator*/
}

size_t base64Encode( char* dest, const void* src, size_t size )
{
    if (dest && src)
    {
        unsigned char* pSrc = (unsigned char*)src;
        size_t dwSrcSize = size;
        size_t dwDestSize = 0;
        size_t dwBlockSize = 0;
        unsigned char n1, n2, n3, n4;

        while (dwSrcSize >= 1)
        {
            /* Encode inputs */
            dwBlockSize = (dwSrcSize < BASE64_ENCODE_INPUT ? dwSrcSize : BASE64_ENCODE_INPUT);
            n1 = n2 = n3 = n4 = 0;
            switch (dwBlockSize)
            {
            case 3:
                n4  = (unsigned char)(pSrc[ 2 ] & 0x3f);
                n3  = ((unsigned char)(pSrc[ 2 ] & 0xc0) >> 6);
            case 2:
                n3 |= ((unsigned char)(pSrc[ 1 ] & 0x0f) << 2);
                n2  = ((unsigned char)(pSrc[ 1 ] & 0xf0) >> 4);
            case 1:
                n2 |= ((unsigned char)(pSrc[ 0 ] & 0x03) << 4);
                n1  = ((unsigned char)(pSrc[ 0 ] & 0xfc) >> 2);
                break;

            default:
                assert( 0 );
            }
            pSrc += dwBlockSize;
            dwSrcSize -= dwBlockSize;

            /* Validate */
            assert( n1 <= 63 );
            assert( n2 <= 63 );
            assert( n3 <= 63 );
            assert( n4 <= 63 );

            /* Padding */
            switch (dwBlockSize)
            {
            case 1: n3 = 64;
            case 2: n4 = 64;
            case 3:
                break;

            default:
                assert( 0 );
            }

            /* 4 outputs */
            *dest++ = BASE64_ENCODE_TABLE[ n1 ];
            *dest++ = BASE64_ENCODE_TABLE[ n2 ];
            *dest++ = BASE64_ENCODE_TABLE[ n3 ];
            *dest++ = BASE64_ENCODE_TABLE[ n4 ];
            dwDestSize += BASE64_ENCODE_OUTPUT;
        }
        *dest++ = '\x0'; /*append terminator*/

        return dwDestSize;
    }
    else
        return 0; /*ERROR - null pointer*/
}

```

复制

## **5、Base64解码 c语言代码实现**

```javascript
/****************************** Base64 Decoding ******************************/

static const size_t BASE64_DECODE_INPUT = 4;
static const size_t BASE64_DECODE_OUTPUT = 3;
static const size_t BASE64_DECODE_MAX_PADDING = 2;
static const unsigned char BASE64_DECODE_MAX = 63;
static const unsigned char BASE64_DECODE_TABLE[ 0x80 ] = {
    /*00-07*/ 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    /*08-0f*/ 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    /*10-17*/ 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    /*18-1f*/ 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    /*20-27*/ 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    /*28-2f*/ 0xFF, 0xFF, 0xFF, 0x3e, 0xFF, 0xFF, 0xFF, 0x3f, /*2 = '+' and '/'*/
    /*30-37*/ 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3a, 0x3b, /*8 = '0'-'7'*/
    /*38-3f*/ 0x3c, 0x3d, 0xFF, 0xFF, 0xFF, 0x40, 0xFF, 0xFF, /*2 = '8'-'9' and '='*/
    /*40-47*/ 0xFF, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, /*7 = 'A'-'G'*/
    /*48-4f*/ 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, /*8 = 'H'-'O'*/
    /*50-57*/ 0x0f, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, /*8 = 'P'-'W'*/
    /*58-5f*/ 0x17, 0x18, 0x19, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, /*3 = 'X'-'Z'*/
    /*60-67*/ 0xFF, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f, 0x20, /*7 = 'a'-'g'*/
    /*68-6f*/ 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, /*8 = 'h'-'o'*/
    /*70-77*/ 0x29, 0x2a, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f, 0x30, /*8 = 'p'-'w'*/
    /*78-7f*/ 0x31, 0x32, 0x33, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  /*3 = 'x'-'z'*/
};
int base64Validate( const char* src, size_t size )
{
    /*
     * returns 0 if the source is a valid base64 encoding
     */

    if (size % BASE64_DECODE_INPUT != 0)
        return -1; /*ERROR - size isn't a multiple of 4*/

    for (; size >= 1; --size, ++src)
    {
        unsigned char ch = *src;
        if ((ch >= 0x80) || (BASE64_DECODE_TABLE[ ch ] > BASE64_DECODE_MAX))
            break;
    }
    for (; 1 <= size && size <= BASE64_DECODE_MAX_PADDING; --size, ++src)
    {
        unsigned char ch = *src;
        if ((ch >= 0x80) || (BASE64_DECODE_TABLE[ ch ] != BASE64_DECODE_MAX + 1))
            break;
    }
    if (size != 0)
        return -2; /*ERROR - invalid base64 character*/

    return 0; /*OK*/
}
size_t base64DecodeGetLength( size_t size )
{
    /*
     * output 3 bytes for every 4 input:
     *                1        2        3
     * 1 = --111111 = 111111--
     * 2 = --11XXXX = ------11 XXXX----
     * 3 = --1111XX =          ----1111 XX------
     * 4 = --111111 =                   --111111
     */

    if (size % BASE64_DECODE_INPUT == 0)
        return (((size + BASE64_DECODE_INPUT - 1) / BASE64_DECODE_INPUT) * BASE64_DECODE_OUTPUT) + 1; /*plus terminator*/
    else
        return 0; /*ERROR - size isn't a multiple of 4*/
}
size_t base64Decode( void* dest, const char* src, size_t size )
{
    if (dest && src && (size % BASE64_DECODE_INPUT == 0))
    {
        unsigned char* pDest = (unsigned char*)dest;
        size_t dwSrcSize = size;
        size_t dwDestSize = 0;
        unsigned char in1, in2, in3, in4;

        while (dwSrcSize >= 1)
        {
            /* 4 inputs */
            in1 = *src++;
            in2 = *src++;
            in3 = *src++;
            in4 = *src++;
            dwSrcSize -= BASE64_DECODE_INPUT;

            /* Validate ascii */
            if (in1 >= 0x80 || in2 >= 0x80 || in3 >= 0x80 || in4 >= 0x80)
                return 0; /*ERROR - invalid base64 character*/

            /* Convert ascii to base64 */
            in1 = BASE64_DECODE_TABLE[ in1 ];
            in2 = BASE64_DECODE_TABLE[ in2 ];
            in3 = BASE64_DECODE_TABLE[ in3 ];
            in4 = BASE64_DECODE_TABLE[ in4 ];

            /* Validate base64 */
            if (in1 > BASE64_DECODE_MAX || in2 > BASE64_DECODE_MAX)
                return 0; /*ERROR - invalid base64 character*/
            /*the following can be padding*/
            if ((int)in3 > (int)BASE64_DECODE_MAX + 1 || (int)in4 > (int)BASE64_DECODE_MAX + 1)
                return 0; /*ERROR - invalid base64 character*/

            /* 3 outputs */
            *pDest++ = ((unsigned char)(in1 & 0x3f) << 2) | ((unsigned char)(in2 & 0x30) >> 4);
            *pDest++ = ((unsigned char)(in2 & 0x0f) << 4) | ((unsigned char)(in3 & 0x3c) >> 2);
            *pDest++ = ((unsigned char)(in3 & 0x03) << 6) | (in4 & 0x3f);
            dwDestSize += BASE64_DECODE_OUTPUT;

            /* Padding */
            if (in4 == BASE64_DECODE_MAX + 1)
            {
                --dwDestSize;
                if (in3 == BASE64_DECODE_MAX + 1)
                {
                    --dwDestSize;
                }
            }
        }
        *pDest++ = '\x0'; /*append terminator*/

        return dwDestSize;
    }
    else
        return 0; /*ERROR - null pointer, or size isn't a multiple of 4*/
}

```

复制

## **6、Base64 编解码测试代码**

```javascript
int  main()
{
    printf("qt test hello qt\r\n");

    int i=0,j=0;
    
       unsigned char base64Decodemsg[50] = {0};
       unsigned char base64Eecodemsg[10] = {0x04,0x10,0x83,0x10,0x51,0x87,0x24,0x71,0x85};
       //base64加密后的信息存储
       unsigned char base64Encoded_msg[]={0};

       //base64加解密测试
       //测试网站：http://www.tomeko.net/online_tools/base64.php?lang=en
       base64Encode(base64Encoded_msg,base64Eecodemsg,9);
       printf("base64 encode message is:%s\r\n",base64Encoded_msg);
       base64Decode(base64Decodemsg,"BBCDEFGHJHGF",12);
       printf("base64 decode message is:");

       for(i=0;i<9;i++){
           printf("%0x",base64Decodemsg[i]);
       }


    printf("\r\n");
    return 0;
}
```

复制

## **7、Base64 编解码运行测试结果**

![](https://ask.qcloudimg.com/http-save/yehe-8913398/88c5b104d3a15603ce41483251b6b869.png?imageView2/2/w/1620)

