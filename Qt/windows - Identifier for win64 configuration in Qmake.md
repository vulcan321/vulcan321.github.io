Identifier for win64 configuration in Qmake

```qml
win32 {

    ## Windows common build here
    !contains(QMAKE_TARGET.arch, x86_64) {
        message("x86 build")
        ## Windows x86 (32bit) specific build here

    } else {
        message("x86_64 build")
        ## Windows x64 (64bit) specific build here
    }
}
```
Since Qt5 you can use QT_ARCH to detect whether your configuration is 32 or 64. When the target is 32-bit, that returns i386 and in case of a 64-bit target it has the value of x86_64. So it can be used like:
```qml
contains(QT_ARCH, i386) {
    message("32-bit")
} else {
    message("64-bit")
}

```

Since very recently, Qt has a way of doing this transparently and easily, without manual hassle:
```qml
win32-g++:contains(QMAKE_HOST.arch, x86_64):{
    do something
}
```