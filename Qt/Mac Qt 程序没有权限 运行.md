Windows系统，MSVC编译器

例如 程序中需要对系统文件进行删除，但因为没有管理员权限或用户未选择以管理员权限运行，删除文件操作执行失败 

在Qt pro文件中增加一下一条语句

```
QMAKE_LFLAGS += /MANIFESTUAC:\"level=\'requireAdministrator\' uiAccess=\'false\'\"
```

重新编译，之后以管理员权限启动qt creator 否则无法debug