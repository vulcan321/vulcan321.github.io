Powershell one liner将删除字符串中与Microsoft的任何凭据。
cmdkey /list | ForEach-Object{if($_ -like "*Target:*" -and $_ -like "*microsoft*"){cmdkey /del:($_ -replace " ","" -replace "Target:","")}} 

cmdkey /list | ForEach-Object{if($_ -like "*Target: LegacyGeneric:target=vscodevscode.microsoft-authentication/f8cdef31-a31e-4b4a-93e4-5f571e91255a*"){cmdkey /del:($_ -replace " ","" -replace "Target:","")}} 

批量、提升的命令提示：
要找到主要的，请列出具有MS.O、Micro和teams的所有项目
for /f "tokens=1-4 Delims=:=" %A in ('cmdkey /list  ^| findstr Target: ^| findstr /i "MS.O Micro Teams"') do @echo %D

此删除团队的所有条目
for /f "tokens=1-4 Delims=:=" %A in ('cmdkey /list ^| findstr /i teams') do @cmdkey /delete:%D