# Steam平台的Don't Starve Together 服务器自动化脚本及搭建教学
## 1、介绍
本人因为和小伙伴一起玩饥荒，但是每次服务器构建都很麻烦，换个服务器又得重新构建输入一堆shell命令，每次更新开启关闭服务器需要操作一堆代码，真的很头疼，所以就自己写了饥荒steam服务器的自动化构建脚本。
## 2、使用
- 方法一：
  * 步骤1： 使用root账户登录你的linux服务器
  * 步骤2： 运行shell命令到指定目录下  
       			 mkdir -p /home/dstserver/bin && cd /home/dstserver/bin   
  * 步骤3： 创建dontstarve.sh自动化脚本  
     			   vim dontstarve.sh  （或nano dontstarve.sh）  
      			 本项目的dontstarve.sh文件内容复制进去即可  
  * 步骤4： 运行脚本  
             chmod +x dontstarve.sh  
             ./dontstarve.sh  
- 方法二:
  * 步骤1： 克隆本项目，或者github下载dontstarve.sh自动化脚本到自己电脑上即可。  
         		 克隆命令：git clone https://github.com/shendongjun/dontstarve.git
  * 步骤2： 运行shell命令到指定目录下  
       			 mkdir -p /home/dstserver/bin && cd /home/dstserver/bin 
  * 步骤3： 使用xftp等工具将文件复制到你的服务器上。  
  * 步骤4： 运行脚本  
        chmod +x dontstarve.sh  
        ./dontstarve.sh   
## 3、不使用脚本创建和管理饥荒服务器

## 4、问题
作者qq:2582107004@qq.com
注意：
* 目前脚本在centos7上可正常运行，ubuntu/debian还没测试过，不过我认为是没问题的，有问题可找我
* 脚本目前安装只支持centos7，后续看大家需求，如果有人想在ubuntu/debian系统使用，我有空会补上脚本安装程序。
