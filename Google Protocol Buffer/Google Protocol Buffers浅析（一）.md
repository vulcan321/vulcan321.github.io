# [Google Protocol Buffers浅析（一）](https://www.cnblogs.com/royenhome/archive/2010/10/29/1864860.html)

本文主要偏向于介绍怎么使用Google的Protocol Buffer技术来压缩与解析你的数据文件，更加详细的信息请参阅Google开放的开发者网页文档，地址为：[http://code.google.com/apis/protocolbuffers/docs/overview.html](http://code.google.com/apis/protocolbuffers/docs/overview.html) 。

**一、简单的介绍**

当然，在继续本文之前，读者还是需要对Google Protocol Buffers有一些基本的认识。Protocol buffers是一个用来序列化结构化数据的技术，支持多种语言诸如C++、Java以及Python语言，可以使用该技术来持久化数据或者序列化成网络传输的数据。相比较一些其他的XML技术而言，该技术的一个明显特点就是更加节省空间（以二进制流存储）、速度更快以及更加灵活。

通常，编写一个protocol buffers应用需要经历如下三步：

1、定义消息格式文件，最好以proto作为后缀名；

2、使用Google提供的protocol buffers编译器来生成代码文件，一般为.h和.cc文件，主要是对消息格式以特定的语言方式描述；

3、使用protocol buffers库提供的API来编写应用程序；

**二、定义Proto文件** 

proto文件即消息协议原型定义文件，在该文件中我们可以通过使用描述性语言，来良好的定义我们程序中需要用到数据格式。首先我们可以通过Google在线文档上提供的一个电话簿的例子来了解下，不过稍微加了点改动。

```protobuf
message Person {
    required string name = 1;
    required int32 id = 2;
    optional string email = 3;

    enum PhoneType {
        MOBILE = 0;
        HOME = 1;
        WORK = 2;
    }

    message PhoneNumber {
        required string number = 1;
        optional PhoneType type = 2 [default = HOME];
    }

    repeated PhoneNumber phone = 4;
    required bytes  unsure = 5;      //Add byte array here    
}

message AddressBook {
    repeated Person person = 1;
}
```

诚如你看到的一样，消息格式定义很简单，对于每个字段而言都有一个修饰符（required/repeated/optional）、字段类型（bool/string/bytes/int32等）和字段标签(Tag)组成。

三个修饰符从词义上可以很清楚的弄明白，

1）对于required的字段而言，初值是必须要提供的，否则字段的便是未初始化的。在Debug模式的buffer库下编译的话，序列化话的时候可能会失败，而且在反序列化的时候对于该字段的解析会总是失败的。所以，对于修饰符为required的字段，请在序列化的时候务必给予初始化。

2）对于optional的字段而言，如果未进行初始化，那么一个默认值将赋予该字段，当然也可以指定默认值，如上述proto定义中的PhoneType字段类型。

3）对于repeated的字段而言，该字段可以重复多个，google提供的这个addressbook例子便有个很好的该修饰符的应用场景，即每个人可能有多个电话号码。在高级语言里面，我们可以通过数组来实现，而在proto定义文件中可以使用repeated来修饰，从而达到相同目的。当然，出现0次也是包含在内的。      

其中字段标签标示了字段在二进制流中存放的位置，这个是必须的，而且序列化与反序列化的时候相同的字段的Tag值必须对应，否则反序列化会出现意想不到的问题。

**三、编译proto文件，生成特定语言数据的数据定义代码**  

在定义好了proto文件，就可以将该文件作为protocol buffers编译器的输入文件，编译产生特定语言的数据定义代码文件了。本文主要是针对C++语言，所以使用编译器后生成的是.h与.cc的代码文件。对于C++、Java还有Python都有各自的编译器，下载地址：[http://code.google.com/p/protobuf/downloads/list](http://code.google.com/p/protobuf/downloads/list)  

当你下载完了对应的编译器二进制文件后，就可以使用下列命令来完成编译过程：
```
protoc.exe -proto_path=SRC --cpp_out=DST SRC/addressbook.proto 
```
其中--proto\_path指出proto文件所在的目录，--cpp\_out则是生成的代码文件要放的目录，最后的一个参数指出proto文件的路径。如上述命令中可以看出，将SRC目录下的addressbook.proto编译后放在DST目录下，应该会生成addressbook.pb.h和addressbook.pb.cc文件。

通过查看头文件，可以发现针对每个字段都会大致生成如下几种函数，以number为例：

```cpp

 // required string number = 1;
  inline bool has_number() const;
  inline void clear_number();
  inline const ::std::string& number() const;
  inline void set_number(const ::std::string& value);
  inline void set_number(const char* value);
  inline ::std::string* mutable_number();

```

可以看出，对于每个字段会生成一个has函数(has\_number)、clear清除函数(clear\_number)、set函数(set\_number)、get函数(number和mutable\_number)。这儿解释下get函数中的两个函数的区别，对于原型为const std::string &number() const的get函数而言，返回的是常量字段，不能对其值进行修改。但是在有一些情况下，对字段进行修改是必要的，所以提供了一个mutable版的get函数，通过获取字段变量的指针，从而达到改变其值的目的。

 而对于字段修饰符为repeated的字段生成的函数，则稍微有一些不同，如phone字段，则编译器会为其产生如下的代码： 

```cpp
  // repeated .Person.PhoneNumber phone = 4;
  inline int phone_size() const;
  inline void clear_phone();
  inline const ::google::protobuf::RepeatedPtrField< ::Person_PhoneNumber >& phone() const;
  inline ::google::protobuf::RepeatedPtrField< ::Person_PhoneNumber >* mutable_phone();
  inline const ::Person_PhoneNumber& phone(int index) const;
  inline ::Person_PhoneNumber* mutable_phone(int index);
  inline ::Person_PhoneNumber* add_phone();
```


可以看出，set函数变成了add函数，这个其实很好理解。上面也说过，repeated修饰的字段在高级语言中的实现可能是个数组或动态数组，所以当然通过添加的方式来加入新的字段值。而起get函数也变化很大，这个也不用多说了。