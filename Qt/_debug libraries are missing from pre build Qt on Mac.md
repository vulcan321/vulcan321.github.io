The small helper for those which suffer from this problem with the vanilla Qt builds is

```
cd <QTDIR>/clang_64/lib/
ln -s libQt5UiTools.a libQt5UiTools_debug.a

```

It's not the worlds end but of course boring to do that on each new sub release of Qt.