# Qt QDomDocument xml 中文乱码解决方法

Qt中实现对xml读写操作的类是QDomDocument相关的类，一般情况下需要包含下列三个头文件：

```cpp
#include <QFile>   
#include <QtXml\QtXml>
#include <QtXml\QDomDocument>
```
1.写入xml

```cpp
QDomDocument doc;
QDomProcessingInstruction instruction = doc.createProcessingInstruction("xml", "version=\"1.0\" encoding=\"UTF-8\"");
doc.appendChild(instruction);
 
QDomElement root = doc.createElement("HInfoData");//创建根节点
doc.appendChild(root);//添加根节点
 
QDomElement strMac = doc.createElement("Mac");//创建元素节点
root.appendChild(strMac);//添加元素节点到根节点
QDomText strMacNodeText = doc.createTextNode(data._strMac);//创建元素文本
strMac.appendChild(strMacNodeText);//添加元素文本到元素节点
```
保存成xml文件
```cpp
QFile file("./test.xml");
if (!file.open(QIODevice::WriteOnly | QIODevice::Truncate | QIODevice::Text))
	return false;
QTextStream out(&file);
out.setCodec("UTF-8");
doc.save(out, 4, QDomNode::EncodingFromTextStream);
file.close();
```

```cpp
    // 保存 XML 文件
    QFile wfile(fileName);
    // 只写模式打开文件
    if (wfile.open(QFile::ReadWrite | QFile::Text))
    {
        QTextStream out(&wfile);
        doc.save(out, QDomNode::EncodingFromDocument);
        wfile.close();
    }
```

2.读XML

```cpp
    // qt 读取xml文件中文问题
    // 1、保存文件格式为UTF-8
    // 2、文件流打开时设置
     
    //相对路径、绝对路径、资源路径都可以
    QFile file(currentFile); 
    if(!file.open(QFile::ReadWrite)) //可以用QIODevice，Truncate表示清空原来的内容
        return;

    QTextStream stream(&file);
    QTextCodec *codec = QTextCodec::codecForName("UTF-8");
    stream.setCodec(codec);

    QString content = stream.readAll();
    file.close();

    QDomDocument doc;
    if(!doc.setContent(content))
    {
        file.close();
        return;
    }
    file.close();
    //返回根节点
    QDomElement root=doc.documentElement();
```

```cpp
QDomDocument doc;
QFile file("./test.xml");
if (!file.open(QIODevice::ReadOnly))
	return false;
 
if (!doc.setContent(&file)) 
{
	file.close();
	return false;
}
file.close();
 
QDomElement root = doc.documentElement();//读取根节点
QDomNode node = root.firstChild();//读取第一个子节点
while (!node.isNull())
{
	QString tagName = node.toElement().tagName();
	if (tagName.compare("Mac") == 0) //节点标记查找
		infodata._strMac = node.toElement().text();//读取节点文本
	else if (tagName.compare("System") == 0)
		infodata._strSystem = node.toElement().text();

	node = node.nextSibling();//读取下一个兄弟节点
}
```
Qt中QDomDocument实现XML读写大致就这些内容，剩下一些细节可以查看Qt Assistant。