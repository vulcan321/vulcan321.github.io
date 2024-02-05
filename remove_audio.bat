@echo on  
setlocal enabledelayedexpansion  
  
:: 设置源文件夹和目标文件夹  
set "SOURCE_DIR=D:\20231120\111\"  
set "DEST_DIR=D:\20231120\222\"  
echo SOURCE_DIR=%SOURCE_DIR%
echo DEST_DIR=%DEST_DIR%
:: 遍历源文件夹中的所有.mp4文件  
for %%F in ("%SOURCE_DIR%*.mp4") do (  
    set "FILE_NAME=%%~nF"
    set "FILE_EXT=%%~xF"
    set "FULL_PATH=%%F"

    :: 删除音频并保存为新的文件名  
    ffmpeg -i "!FULL_PATH!" -an "!DEST_DIR!\!FILE_NAME!!FILE_EXT!"  
)  
  
echo Finished!
pause