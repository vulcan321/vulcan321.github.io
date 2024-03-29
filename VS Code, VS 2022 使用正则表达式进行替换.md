# 正则表达式

正则表达式在处理一些字符串的查找与替换有着十分强大的作用。

## 1 常用字符

> 正则表达式相关的资料有很多，以及大量的说明样例，不做赘述。  
> 以下简单列举一些

| 字符 | 匹配项 |
| --- | :-- |
| \\n | 换行符 |
| \\s | 匹配任何空白字符，包括空格、制表符等 |
| + | 匹配前面的子表达式一次或多次。 |
| \* | 匹配前面的子表达式零次或多次。 |

## 2.VS 2022使用正则表达式替换

> 在正则表达式替换章节十分详细的文档说明  
> [正则表达式替换](https://docs.microsoft.com/zh-cn/dotnet/standard/base-types/substitutions-in-regular-expressions)

### 2.1 替换符号

> 以下说明较为常用的部分
> 
> 1.  $ number  
>     按顺序直接匹配，将要匹配的正则首尾加括号，之后在替换时直接使用$加数字即可
> 2.  $ {name}  
>     按照名称匹配，将要匹配的正则首尾加括号，并以?<name>的形式命名，替换时  
>     使用$ {name}的形式
> 3.  $$  
>     用于需要添加一个$号
> 4.  $&  
>     用于匹配整个匹配项，一般用作将子字符串添加至匹配字符串的开头或末尾。  
>       
>     
> 
> 其余匹配可以参考详细文档  
>   
> 
> 举例:  
> 所有举例用于说明替换符号，仅使用较为简单的正则表达式来说明查询

| 替换符 | 匹配项(正则) | 替换项 | 结果 |
| :-- | :-- | :-- | :-- |
| $ number | “aaa” : “111”  
“bbb” : “222”  
“(.+)” : (“.+”) | $1 - $2 | aaa - “111”  
bbb - “222” |
| ${ name } | “aaa” : “111”  
“bbb” : “222”  
“(?<para1>.+)” : (?<para2>“.+”) | ${para1} - ${para2} | aaa - “111”  
bbb - “222” |
| $$ | “aaa” : “111”  
“bbb” : “222”  
“(.+)” : (“.+”) | $1 - $$ $2 | aaa - $ “111”  
bbb - $ “222” |
| $& | “aaa” : “111”  
“bbb” : “222”  
“(.+)” : (“.+”) | prefix($&) | prefix(“aaa” : “111”)  
prefix(“bbb” : “222”) |

## 2.2 VS Code使用正则表达式替换

> VS code大部分替换遵循上方的规则，但通过$ {name}的名称匹配会失效，命名后  
> 也可以通过数字来进行替换  
> 例如：  
> “(?<para1>.+)” : (?<para2>“.+”)  
> 也可以通过  
> $1 - $2  
> 进行替换