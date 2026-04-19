# 统计含中英文混编的NSString 字符串长度
将一个NSString类型字符串获取的长度转换成类似ASCII编码的长度，如汉字2个字节，英文以及符号1个字节这个功能。  
由于使用\[NSString length\]方法调用获取的长度是一个中文和一个英文都是一个字节，而使用

\[NSString lengthOfBytesUsingEncoding:NSASCIIStringEncoding\] 方法无法识别中文编码，真是令人揪心。

于是想获得一个char＊类型的字符串，然后自己遍历一遍，将它整理为类似ASCII编码的格式，这里要用到

\[NSString cStringUsingEncoding:NSUnicodeStringEncoding\]函数获得一个const char＊指针，然后对这个字符串进行遍历，遇/0就跳过，否则length＋1，下面是代码，拿出来与大家分享：

```objc
-  (int)convertToInt:(NSString*)strtemp {

         int strlength = 0;
        char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
        for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
             if (*p) {
                     p++;
                     strlength++;
             }
            else {
                p++;
           }
      }
      return strlength;

}
```