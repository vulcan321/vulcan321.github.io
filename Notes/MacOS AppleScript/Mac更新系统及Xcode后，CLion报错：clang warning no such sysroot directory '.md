# Mac更新系统及Xcode后，CLion报错：clang: warning: no such sysroot directory: '/Applications/Xcode.app/Conten...

```bash
$cd /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs
$sudo ln -s MacOSX.sdk MacOSX11.0.sdk
```