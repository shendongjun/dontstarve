# Don't Starve Together 饥荒服务器自动化脚本及搭建教学
## 1、介绍
本人因为和小伙伴一起玩饥荒，但是每次服务器构建都很麻烦，换个服务器又得重新构建输入一堆shell命令，每次更新开启关闭服务器需要操作一堆代码，真的很头疼，所以就自己写了饥荒steam服务器的自动化构建脚本。  
## 2、使用
* 步骤1： 使用root账户登录你的linux服务器
* 步骤2： 创建dontstarve.sh自动化脚本  
     			     vim dontstarve.sh  （或nano dontstarve.sh）  
      			    本项目的dontstarve.sh文件内容复制进去即可  
* 步骤3： 运行脚本  
             chmod +x dontstarve.sh  
             ./dontstarve.sh  
 注：如果你在windows上复制代码可能linux上运行不了，解决方法：yum install dos2unix && dos2unix dontstarve.sh  
## 3、创建和管理饥荒服务器(不使用脚本)
未完待续...（有需求在更新）
## 4、其他问题
**注意**：
* 该脚本只使用steam服务器,wegame请找找别人有没有写吧~
* 目前脚本在centos7上可正常运行，ubuntu/debian还没测试过，不过我认为是没问题的，有问题可找我
* 脚本目前安装只支持centos7，后续看大家需求，如果有人想在ubuntu/debian系统使用，我有空会补上脚本安装程序。  
**作者QQ**:  
2582107004@qq.com  
