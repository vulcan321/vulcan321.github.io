用QXmlQuery解析HTML5


使用**右**命令行html TIDIY确实有效

从以下站点下载html文件：

使用以下命令行：

**tidy.exe-q-b-asxml test.html>test.xml**

使用以下代码在结果xml文件上使用QXmlQuery现在可以正常工作：

```cpp
#include <QFile>
#include <QXmlQuery>
#include <QBuffer>
#include <QXmlFormatter>
#include <QException>
#include <QAbstractMessageHandler>
#include <iostream>
#include <string.h>
#include <QCoreApplication>

using namespace std;

class ParserMsgHandler: public QAbstractMessageHandler
{
    virtual void handleMessage( QtMsgType type, const QString &description, const QUrl &identifier, const QSourceLocation &sourceLocation )
    {
        QString mt = "";
        switch( type )
        {
        case QtDebugMsg:
            mt = "DBG: ";
            break;
        case QtWarningMsg:
            mt = "WRN: ";
            break;
        case QtCriticalMsg:
            mt = "CRT: ";
            break;
        case QtFatalMsg:
            mt = "FTL: ";
            break;
        case QtInfoMsg:
            mt = "INF: ";
            break;
        }

        QString msg = "\r\n" +
                      mt +
                      "Line: " + sourceLocation.line() +
                      ", Column: " + sourceLocation.column() +
                      ", Id: " + identifier.toString() +
                      ", Desc: " + description;
        cout << msg.toUtf8().constData();
    }
};

ParserMsgHandler gHandler;

int main(int argc, char *argv[])
{
    QCoreApplication a( argc, argv );

    try
    {
        QString htmlFilename = a.arguments()[1];
        QString xqueryFilename = a.arguments()[2];
        QFile queryFile( xqueryFilename );
        queryFile.open( QIODevice::ReadOnly );
        const QString queryStr( QString::fromUtf8( queryFile.readAll() ) );
        QXmlQuery query;
        QFile sourceDocument;
        sourceDocument.setFileName( htmlFilename );
        sourceDocument.open( QIODevice::ReadOnly );

        QByteArray outArray;
        QBuffer buffer( &outArray );
        buffer.open( QIODevice::ReadWrite );

        query.bindVariable( "inputDocument", &sourceDocument );
        query.setQuery( queryStr );
        query.setMessageHandler( &gHandler );
        if( !query.isValid() )
        {
            cout << "\r\nError: Bad Query or Document!\r\n";
            return -1;
        }

        QXmlFormatter formatter( query, &buffer );
        if( !query.evaluateTo( &formatter ) )
        {
            cout << "\r\nError: Evaluation Failed!\r\n";
            return -2;
        }

        buffer.close();
        cout << "\r\nOutput:\r\n" << outArray.constData() << "\r\n";
        return a.exec();
    }
    catch( QException e )
    {
        cout << "\r\nExecption: " << e.what() << "\r\n";
    }
    catch( ... )
    {
        cout << "\r\nExecption: Big one...\r\n";
    }

    return 0;
}
```
