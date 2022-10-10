### 用**git pull**来更新代码的时候，遇到了下面的问题：

```javascript
error:
Your local changes to the following files would be overwritten by merge:
xxx/xxx/xxx.(冲突的文件)
Please, commit your changes or stash them before you can merge. Aborting
```

从sourceTree打开终端，可以直接进入你当前项目所在目录下，在终端输入下面代码：

```javascript
git stash 
git pull
git stash pop
```

### 参考文献：

1.https://juejin.cn/post/6844904105404547086

2.https://www.jianshu.com/p/920ad324fe64

3.https://blog.csdn.net/qq_32452623/article/details/75645578