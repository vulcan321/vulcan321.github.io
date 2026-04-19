# Objective-C文件和目录操作,IOS文件操作,NSFileManager使用文件操作


 

**Objective-C文件和目录操作,IOS文件操作,NSFileManager使用文件操作:**

  

objective-c通过使用NSFileManager类来管理和操作文件、目录，NSFileManager,文件或目录是使用文件的路径名的唯一标示。每个路径名都是一个NSString对象。

NSFileManager对象通过defaultManager方法来创建实例  
列如：

NSFileManager \*fm = \[NSFileManager defaultManager\];  

  

删除某个文件  
\[fm removeItemAtPath:@"filename" error:NULL\];  

error:参数是一个指向NSError对象的指针，能够提供错误的信息。如果指定为NULL的话就会使用默认的行为，返回值是BOOL类型的方法，操作成功返回YES反之返回NO

  

判断文件是否被删除  
if(\[fm removeItemAtPath:@"filename" error:NULL\]==NO){  
NSLog(@"文件删除失败");  
return 1;  
}  

  

NSFileManager常用的文件方法：  
  
\-(NSData\*)contentsAtPath:path 从一个文件中读取数据  
  
\-(BOLL)createFileAtPath:path contents:(NSData\*)data attributes: attr 向一个文件写入数据  
  
\-(BOOL)removeItemAtPath:path error:err 删除一个文件  
  
\-(BOOL)moveItemAtPath:from toPath:to error:err 重命名或移动一个文件(to 不能是已存在的)  
  
\-(BOOL)copyItemAtPath:from toPath:to error:err 复制文件(to 不能是已存在的)  
  
\-(BOOL)contentsEqualAtPath:path1 andPath:path2 比较这两个文件的内容  
  
\-(BOOL)fileExistsAtPath:path 测试文件是否存在  
  
\-(BOOL)isReadableFileAtPath:path 测试文件是否存在，并且是否能执行读操作  
  
\-(BOOL)isWritableFileAtPath:path 测试文件是否存在，并且是否能执行写操作  
  
\-(NSDictionary\*)attributesOfItemAtPath:path error:err 获取文件的属性  

属性字典允许你指定要创建的文件的权限，如果将该参数指定为nil，该文件会被设置为默认权限。  

  

1、通过一段程序来对文件进行操作：

```cpp
//
//  main.m
//  NSFileManager_01
//
//  Created by swinglife on 13-11-10.
//  Copyright (c) 2013年 swinglife. All rights reserved.
//
 
#import <Foundation/Foundation.h>
 
int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        //文件名
        NSString *fileName = @"testFile";
        NSString *fileContent = @"这是文件内容!!!!";
        NSData *fileData = [fileContent dataUsingEncoding:NSUTF8StringEncoding];
        
        //创建NSFileManager实例
        NSFileManager *fm = [NSFileManager defaultManager];
        
        //创建文件
        [fm createFileAtPath:fileName contents:fileData attributes:nil];
        
        //判断文件是否存在 不存在就结束程序
        if([fm fileExistsAtPath:fileName]==NO){
            NSLog(@"文件不存在");
            return 1;
        }
        
        //拷贝文件
        if([fm copyItemAtPath:fileName toPath:@"newFile" error:NULL]==NO){
            NSLog(@"复制失败");
            return 2;
        }
        
        //测试两个文件是否相同
        if([fm contentsEqualAtPath:fileName andPath:@"newFile"]==NO){
            NSLog(@"文件不相同");
            return 3;
        }
        
        //重命名newFile
        [fm moveItemAtPath:@"newFile" toPath:@"newFile2" error:NULL];
        
        //获取newFile2的大小
        NSDictionary *fileAttr = [fm attributesOfItemAtPath:@"newFile2" error:NULL];
        if(fileAttr!=nil){
            NSLog(@"文件大小:%llu bytes",[[fileAttr objectForKey:NSFileSize] unsignedLongLongValue]);
        }
        
        //删除文件
        [fm removeItemAtPath:fileName error:NULL];
        
        //显示newFile2的内容
        NSString *data = [NSString stringWithContentsOfFile:@"newFile2" encoding:NSUTF8StringEncoding error:NULL];
        NSLog(@"%@",data);
        
        
    }
    return 0;
}
```

  

NSFileManager常用的目录方法

  
\-(NSString\*)currentDirectoryPath 获取当前目录  
  
\-(BOOL)changeCurrentDirectoryPath:path 更改当前目录  
  
\-(BOOL)copyItemAtPath:from toPath:to error:err 复制目录结构  
  
\-(BOOL)createDirectoryAtPath:path withIntermediateDirectories:(BOOL)flag attributes:attr 创建一个新目录  
  
\-(BOOL)fileExistsAtPath:path isDirectory:(BOOL\*)flag 测试文件是不是目录(flag中存储结果)  
  
\-(NSArray\*)contentsOfDirectoryAtPath:path error:err 列出目录内容  
  
\-(NSDirectoryEnumerator\*)enumeratorAtPath:path 枚举目录的内容  
  
\-(BOOL)removeItemAtPath:path error:err 删除空目录  
  
\-(BOOL)moveItemAtPath:from toPath:to error:err 重命名或移动一个目录

  

2、通过一段程序来对目录进行操作：

```cpp
//
//  main.m
//  NSFileManager_02
//
//  Created by swinglife on 13-11-10.
//  Copyright (c) 2013年 swinglife. All rights reserved.
//
 
#import <Foundation/Foundation.h>
 
int main(int argc, const char * argv[])
{
 
    @autoreleasepool {
        //文件目录
        NSString *dirName = @"testDir";
        
        //创建NSFileManager实例
        NSFileManager *fm = [NSFileManager defaultManager];
        
        //获取当前目录
        NSString *path = [fm currentDirectoryPath];
        NSLog(@"Path:%@",path);
        
        //创建新目录
        [fm createDirectoryAtPath:dirName withIntermediateDirectories:YES attributes:nil error:NULL];
        
        //重命名新的目录
        [fm moveItemAtPath:dirName toPath:@"newDir" error:NULL];
        
        //更改当前目录到新的目录
        [fm changeCurrentDirectoryPath:@"newDir"];
        
        //获取当前工作目录
        path = [fm currentDirectoryPath];
        NSLog(@"Path:%@",path);
        
    }
    return 0;
}
```