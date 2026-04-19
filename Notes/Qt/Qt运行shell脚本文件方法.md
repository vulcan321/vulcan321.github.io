# qt运行终端shell脚本文件方法



## 目录

-   [方法1：system](https://blog.csdn.net/xx970829/article/details/116463167#1system_1)
-   [方法2：QProcess::startDetached](https://blog.csdn.net/xx970829/article/details/116463167#2QProcessstartDetached_35)
-   [方法3：QProcess::start](https://blog.csdn.net/xx970829/article/details/116463167#3QProcessstart_52)
-   -   [完整代码](https://blog.csdn.net/xx970829/article/details/116463167#_70)
    -   [向sh文件输入参数](https://blog.csdn.net/xx970829/article/details/116463167#sh_186)
    -   [运行ros指令的sh脚本注意事项](https://blog.csdn.net/xx970829/article/details/116463167#rossh_220)

## 方法1：system

```c++
system("gnome-terminal -- bash -c '/home/xx/myssh/my.sh'&");//chmod a+x /home/xx/my.sh;
```

**my.sh**

```sh
#!/bin/bash
cd /home/xx/myssh
./helloworld
echo "sleep：4秒"
sleep 4
exit 0
```

**helloworld.cpp**

```c++
#include<iostream>
using namespace std;

int main(){

    cout<<"hello world"<<endl;
    return 0;
}

```

然后运行：

```sh
g++ helloworld.cpp -o helloworld
```

## 方法2：QProcess::startDetached

它与start不同，它是以分离进程的方式启动 没有子父进程关系

```c++
QProcess::startDetached("/home/xx/myssh/bash.sh");
```

**bash.sh**

```sh
#!/bin/bash
gnome-terminal -- bash -c 'source /home/xx/catkin_ws/devel/setup.bash && rosrun cam_laser_calib pcd_points_gps 1 0 111.pcd'&
#source /home/xx/catkin_ws/devel/setup.bash 
#rosrun cam_laser_calib pcd_points_gps 1 0 111.pcd
exit 0
```

## 方法3：QProcess::start

```c++
    process->start("bash");                      //启动终端(Windows下改为cmd)
    process->waitForStarted();                   //等待启动完成
    process->write("/home/xx/myssh/my.sh\n");    //向终端写入命令，注意尾部的“\n”不可省略
    process->write("ifconfig\n");
```

**将输出信息读取到编辑框**

```c++
ui->textEdit->append(process->readAllStandardOutput().data());   
```

### 完整代码

除了上述所用到的my.sh与bash.sh外，剩下的主要是qt代码

**mainwindow.h**

```c++
#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include<QProcess>
QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_pushButton_clicked();

    void on_pushButton_2_clicked();

    void on_pushButton_3_clicked();

    void readoutput();

    void readerror();

private:
    Ui::MainWindow *ui;
    QProcess *process;
};
#endif // MAINWINDOW_H

```

**mainwindow.cpp**

```c++
#include "mainwindow.h"
#include "ui_mainwindow.h"
#include<QProcess>
#include<QMessageBox>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    process = new QProcess(this);
    connect(process , &QProcess::readyReadStandardOutput, this , &MainWindow::readoutput);
    connect(process , &QProcess::readyReadStandardError, this , &MainWindow::readerror);

}

MainWindow::~MainWindow()
{
    delete ui;
    if(process)
    {
          process->close();
          process->waitForFinished();
    }
}
void MainWindow::readoutput()
{
    ui->textEdit->append(process->readAllStandardOutput().data());   //将输出信息读取到编辑框
}
void MainWindow::readerror()
{
    QMessageBox::information(0, "Error", process->readAllStandardError().data());   //弹出信息框提示错误信息
}

void MainWindow::on_pushButton_clicked()
{
    system("gnome-terminal -- bash -c '/home/xx/myssh/my.sh'&");//chmod a+x /home/xx/my.sh;
}

void MainWindow::on_pushButton_2_clicked()
{
    QProcess::startDetached("/home/xx/myssh/bash.sh");//以分离进程的方式启动 没有子父进程关系
}

void MainWindow::on_pushButton_3_clicked()
{
    process->start("bash");                      //启动终端(Windows下改为cmd)
    process->waitForStarted();                   //等待启动完成
    process->write("/home/xx/myssh/my.sh\n");    //向终端写入命令，注意尾部的“\n”不可省略
    process->write("ifconfig\n");
}

```

**main.cpp**

```c++
#include "mainwindow.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    return a.exec();
}

```
## 调用shell脚本并监控返回的方法

```c++
QProcess process =new QProcess(this);

//调用过程输出的监控
    connect(process, SIGNAL(readyRead()), this, SLOT(readProcess()));
    connect(process, SIGNAL(finished(int)), this, SLOT(finishedProcess()));
```

然后在readProcess()和finishedProcess()中进行分析
```c++
void MainWindow::executeProcess(const char *shell){
    shellOutput="";
    process->start(shell);
}

void MainWindow::readProcess(){
    QString output=process->readAll();
     shellOutput+=output;
     //do something
}

void MainWindow::finishedProcess(){
    qDebug()<<shellOutput;
     //do something
}
```
## 向sh文件输入参数

有时需要向sh文件中输入参数，这时可以用‘$1’’$2’等占位  
如**改my.sh文件**

```sh
#!/bin/bash
cd /home/xx/myssh
./helloworld
time=$1
echo "sleep：$time秒"
sleep $time
exit 0
```

【time=$1：是设置了变量‘time’，而time的值来于输入的第一个参数‘$1’，后面在用这个变量‘time’时也要写成‘ $time’的形式】

对**qt的更改**  
**需求1：直接在后面输入参数**  
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210507081716691.png)  
或  
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210507081755498.png)  
**需求2：获取在qt界面输入的参数作为输入**

先获取‘lineEdit’输入的参数，然后将整个QString 指令转成char类型，然后写入process：

```c++
    QString strget=ui->lineEdit->text();
    QString str=QString("/home/xx/myssh/my.sh %1\n").arg(strget);
    char *n;
    QByteArray m=str.toLatin1();
    n=m.data();
    process->write(n);    
```

### 运行ros指令的sh脚本注意事项

在运行含ros指令的sh脚本时如：“rosbag play xxx.bag”需要注意两点  
**1.“xxx.bag”路径要全**:如“/home/xx/catkin\_ws/xxx.bag”，或者先进入该文件夹“cd /home/xx/catkin\_ws”  
**2.与运行roscore一样，要先设置环境变量**:即在运行“rosbag play”指令前先要加“ source /opt/ros/kinetic/setup.bash”。同理，在运行自己写的“rosrun xxx xxx”时也要先source一下如：“source /home/xx/catkin\_ws/devel/setup.bash”

例如：  
**bagplay.sh**

```sh
#!/bin/bash
#source /opt/ros/melodic/setup.bash
rosbag play /home/$1/$2
sleep 20
exit 0
```

如果不加“source /opt/ros/melodic/setup.bash”  
虽然能直接在终端运行bagplay.sh  
但是通过qt运行时会报错


