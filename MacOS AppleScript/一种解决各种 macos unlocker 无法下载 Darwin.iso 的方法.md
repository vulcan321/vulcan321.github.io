# 一种解决各种 macos unlocker 无法下载 Darwin.iso 的方法

### 解决思路

将Darwin 文件集成到源程序下载目录，并修改相应文件

# 修改完成版

[链接](https://pan.baidu.com/s/1RHWQm5MGX7KnA3klxG8www) 提取码: t8ur

## 具体步骤

1.点击[官方下载](https://softwareupdate.vmware.com/cds/vmw-desktop/fusion/12.1.0/17195230/core/com.vmware.fusion.zip.tar)或[镜像](https://cowtransfer.com/s/9f0ba16df0764d)下载[vmware](https://so.csdn.net/so/search?q=vmware&spm=1001.2101.3001.7020)提供的com.vmware.fusion.zip.tar。并放到unlocker的tools文件下。  
2.删除gettools.py的main函数  
3复制下述代码在原来main.py处

# 注意保存 特别是用[vscode](https://so.csdn.net/so/search?q=vscode&spm=1001.2101.3001.7020)

```python
def main():

	dest = os.path.dirname(os.path.abspath(__file__))

	# Re-create the tools folder
	

	# Last published version doesn't ship with darwin tools
	# so in case of error get it from the core.vmware.fusion.tar
	print('Trying to get tools from the packages folder...')

	# Setup url and file paths
	# Get the list of Fusion releases
	# And get the last item in the ul/li tags
	
		
	print('Extracting com.vmware.fusion.zip.tar...')
	tar = tarfile.open(convertpath(dest + '/tools/com.vmware.fusion.zip.tar'), 'r')
	tar.extract('com.vmware.fusion.zip', path=convertpath(dest + '/tools/'))
	tar.close()
		
	print('Extracting files from com.vmware.fusion.zip...')
	cdszip = zipfile.ZipFile(convertpath(dest + '/tools/com.vmware.fusion.zip'), 'r')
	cdszip.extract('payload/VMware Fusion.app/Contents/Library/isoimages/darwin.iso', path=convertpath(dest + '/tools/'))
	cdszip.extract('payload/VMware Fusion.app/Contents/Library/isoimages/darwinPre15.iso', path=convertpath(dest + '/tools/'))
	cdszip.close()
		
		# Move the iso and sig files to tools folder
	shutil.move(convertpath(dest + '/tools/payload/VMware Fusion.app/Contents/Library/isoimages/darwin.iso'), convertpath(dest + '/tools/darwin.iso'))
	shutil.move(convertpath(dest + '/tools/payload/VMware Fusion.app/Contents/Library/isoimages/darwinPre15.iso'), convertpath(dest + '/tools/darwinPre15.iso'))
		
		# Cleanup working files and folders
	shutil.rmtree(convertpath(dest + '/tools/payload'), True)
	os.remove(convertpath(dest + '/tools/com.vmware.fusion.zip.tar'))
	os.remove(convertpath(dest + '/tools/com.vmware.fusion.zip'))
		
	print('Tools retrieved successfully')
	return
	
	# Tools have been found, go with the normal way
	
	# Extract the tar to zip
	tar = tarfile.open(convertpath(dest + '/tools/com.vmware.fusion.tools.darwin.zip.tar'), 'r')
	tar.extract('com.vmware.fusion.tools.darwin.zip', path=convertpath(dest + '/tools/'))
	tar.close()

	# Extract the iso and sig files from zip
	cdszip = zipfile.ZipFile(convertpath(dest + '/tools/com.vmware.fusion.tools.darwin.zip'), 'r')
	cdszip.extract('payload/darwin.iso', path=convertpath(dest + '/tools/'))
	cdszip.extract('payload/darwin.iso.sig', path=convertpath(dest + '/tools/'))
	cdszip.close()

	# Move the iso and sig files to tools folder
	shutil.move(convertpath(dest + '/tools/payload/darwin.iso'), convertpath(dest + '/tools/darwin.iso'))
	shutil.move(convertpath(dest + '/tools/payload/darwin.iso.sig'), convertpath(dest + '/tools/darwin.iso.sig'))

	# Cleanup working files and folders
	shutil.rmtree(convertpath(dest + '/tools/payload'), True)
	os.remove(convertpath(dest + '/tools/com.vmware.fusion.tools.darwin.zip.tar'))
	os.remove(convertpath(dest + '/tools/com.vmware.fusion.tools.darwin.zip'))

	# Download the darwinPre15.iso tgz file
	print('Retrieving DarwinPre15 tools from: ' + urlpre15)
	urlretrieve(urlpre15, convertpath(dest + '/tools/com.vmware.fusion.tools.darwinPre15.zip.tar'))

	# Extract the tar to zip
	tar = tarfile.open(convertpath(dest + '/tools/com.vmware.fusion.tools.darwinPre15.zip.tar'), 'r')
	tar.extract('com.vmware.fusion.tools.darwinPre15.zip', path=convertpath(dest + '/tools/'))
	tar.close()

	# Extract the iso and sig files from zip
	cdszip = zipfile.ZipFile(convertpath(dest + '/tools/com.vmware.fusion.tools.darwinPre15.zip'), 'r')
	cdszip.extract('payload/darwinPre15.iso', path=convertpath(dest + '/tools/'))
	cdszip.extract('payload/darwinPre15.iso.sig', path=convertpath(dest + '/tools/'))
	cdszip.close()

	# Move the iso and sig files to tools folder
	shutil.move(convertpath(dest + '/tools/payload/darwinPre15.iso'),
				convertpath(dest + '/tools/darwinPre15.iso'))
	shutil.move(convertpath(dest + '/tools/payload/darwinPre15.iso.sig'),
				convertpath(dest + '/tools/darwinPre15.iso.sig'))

	# Cleanup working files and folders
	shutil.rmtree(convertpath(dest + '/tools/payload'), True)
	os.remove(convertpath(dest + '/tools/com.vmware.fusion.tools.darwinPre15.zip.tar'))
	os.remove(convertpath(dest + '/tools/com.vmware.fusion.tools.darwinPre15.zip'))

```

# 注意保存 特别是用vscode