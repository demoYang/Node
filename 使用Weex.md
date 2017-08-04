
##homebrew
	/usr/local/var/homebrew/linked is not writable. 
	解决办法：sudo chown -R "$USER":admin /usr/local

##使用Weex 
1.安装node  主要安装node.js 同时会帮你安装npm （JavaScript包管理工具）
2.npm install -g weex-toolkit 安装weex-toolkit  库
3.npm install -g webpack 安装webpack
3.weex init awesome-project 创建项目
	项目文件结构
	.build :源码大巴，生成JS Bundle
	.dev ： webpack watch 模式，方便开发
	.serve : 开启静态服务器
	.debug :调试模式
4.cd 到项目文件目录下
5.npm install 安装依赖文件
6.npm run dev ,npm run serve 开启watch 模式 和静态服务器模式。
http://localhost:8080/index.html ：查看界面显示
源码在src/foo.vs