#!/bin/bash

# 获取操作系统名称
os=$(uname -s)
# 判断当前操作系统是否可以运行该脚本（目前仅支持centos7,后续如有别的os需求可加作者qq:2582107004）
if [ "$os" = "Linux" ]; then
    #支持Linux系统
	# 检查是否为CentOS 7
    if [ -f "/etc/centos-release" ]; then
        grep -q "CentOS Linux release 7" /etc/centos-release
        if [ $? -ne 0 ]; then
            #支持centos7
			exit 0
        fi
    fi
    # 检查是否为Ubuntu
    if [ -f "/etc/lsb-release" ]; then
        grep -q "DISTRIB_ID=Ubuntu" /etc/lsb-release
        if [ $? -eq 0 ]; then
            #不支持Ubuntu
            exit 0
        fi
    fi
    # 检查是否为Debian
    if [ -f "/etc/os-release" ]; then
        grep -q "ID=debian" /etc/os-release
        if [ $? -eq 0 ]; then
            #不支持Debian
            exit 0
        fi
    fi
elif [ "$os" = "Darwin" ]; then
    # 不支持Darwin
	exit 0
elif [ "$os" = "FreeBSD" ]; then
    # 不支持FreeBSD
	exit 0
else
    echo "不支持的操作系统"
    exit 1
fi  


#是否是有效的选择，false代表无效的选择，需要重新选
valid_choice=false

while [ "$valid_choice" = false ]; do
	# 提示用户输入选择
	echo "1. 开启饥荒服务器"
	echo "2. 关闭饥荒服务器"
	echo "3. 更新饥荒服务器"
	echo "4. 单独开启饥荒大世界服务器"
	echo "5. 单独开启饥荒洞穴服务器"
	echo "6. 单独关闭饥荒大世界服务器"
	echo "7. 单独关闭饥荒洞穴服务器"
	echo "8. 更新steam服务器"
	echo "9. 更新模组"
	echo "10. 安装饥荒服务器"
	echo "11. 卸载饥荒服务器"
	echo "12. 更新并重启服务器"
	echo "13. 退出"
	echo "请选择操作："
	read choice

	# 条件判断
	if [ "$choice" = "1" ]; then
		echo "正在启动饥荒服务器......"
		#=========开启大世界start=========
		# 检查screen会话是否存在，如果不存在则创建一个新的会话
		screen -ls | grep dontstarve-master >/dev/null
		if [ $? -ne 0 ]; then
			screen -dmS dontstarve-master
		fi
		# 在screen会话中开启主世界
		screen -S dontstarve-master -X eval "stuff '/home/dontstarve/dstserver/bin/dontstarve_dedicated_server_nullrenderer -console  -persistent_storage_root /home/dontstarve/dstsave -conf_dir dst -cluster World1 -shard Master'\015"
		#=========开启大世界end=========
		#=========开启洞穴start=========
		# 检查screen会话是否存在，如果不存在则创建一个新的会话
		screen -ls | grep dontstarve-caves >/dev/null
		if [ $? -ne 0 ]; then
			screen -dmS dontstarve-caves
		fi
		# 在screen会话中开启洞穴
		screen -S dontstarve-caves -X eval "stuff '/home/dontstarve/dstserver/bin/dontstarve_dedicated_server_nullrenderer -console  -persistent_storage_root /home/dontstarve/dstsave -conf_dir dst -cluster World1 -shard Caves'\015"
		#=========开启洞穴end=========
		sleep 3s
		echo "饥荒服务器启动成功！"
		echo "注：服务器有启动过程，依据你的服务器和模组配置启动时间为几十秒到几分钟不等，请稍等片刻，祝游戏愉快~"
		valid_choice=true
	elif [ "$choice" = "2" ]; then
		echo "正在保存并关闭饥荒服务器......"
		#=========关闭洞穴start=========
		# 检查screen会话是否存在，如果不存在则不用关闭世界
		screen -ls | grep dontstarve-caves >/dev/null
		if [ $? -ne 0 ]; then
			echo "洞穴服务器不存在，无需关闭~"
		else
			# 在会话中保存并关闭服务器命令
			screen -S dontstarve-caves -X eval "stuff 'c_shutdown(true)'\015"
		fi
		#=========关闭洞穴end=========
		#=========关闭大世界start=========
		# 检查screen会话是否存在，如果不存在则不用关闭世界
		screen -ls | grep dontstarve-master >/dev/null
		if [ $? -ne 0 ]; then
			echo "大世界服务器不存在，无需关闭~"
		else
			# 在会话中保存并关闭服务器命令
			screen -S dontstarve-master -X eval "stuff 'c_shutdown(true)'\015"
		fi
		#=========关闭大世界end=========
		sleep 3s
		#删除screen 会话
		screen -X -S dontstarve-caves quit
		screen -X -S dontstarve-master quit
		echo "饥荒服务器已关闭！"
		valid_choice=true
	elif [ "$choice" = "3" ]; then
		echo "正在更新饥荒服务器......"
		#=========更新steam服务器=========
		/home/dontstarve/steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/dontstarve/dstserver +app_update 343050 validate +quit &
		updatepid[0]=$!
		#=========更新模组=========
		/home/dontstarve/dstserver/bin/dontstarve_dedicated_server_nullrenderer -only_update_server_mods &
		updatepid[1]=$!
		# 等待所有命令执行结束
		for i in "${updatepid[@]}"; do
			wait "$i"
		done
		echo "饥荒服务器更新操作完成,快启动服务器愉快玩耍吧~"
		valid_choice=true
	elif [ "$choice" = "4" ]; then
		echo "正在启动饥荒大世界服务器......"
		#=========开启大世界start=========
		# 检查screen会话是否存在，如果不存在则创建一个新的会话
		screen -ls | grep dontstarve-master >/dev/null
		if [ $? -ne 0 ]; then
			screen -dmS dontstarve-master
		fi
		# 在会话中执行开启主世界命令
		screen -S dontstarve-master -X eval "stuff '/home/dontstarve/dstserver/bin/dontstarve_dedicated_server_nullrenderer -console  -persistent_storage_root /home/dontstarve/dstserver -conf_dir dst -cluster World1 -shard Master'\015"
		#=========开启大世界end=========
		sleep 3s
		echo "饥荒大世界服务器启动成功！"
		echo "注：服务器有启动过程，依据你的服务器和模组配置启动时间为几十秒到几分钟不等，请稍等片刻，祝游戏愉快~"
		valid_choice=true
	elif [ "$choice" = "5" ]; then
		echo "正在启动饥荒洞穴服务器......"
		#=========开启洞穴start=========
		# 检查screen会话是否存在，如果不存在则创建一个新的会话
		screen -ls | grep dontstarve-caves >/dev/null
		if [ $? -ne 0 ]; then
			screen -dmS dontstarve-caves
		fi
		# 在会话中执行命令
		screen -S dontstarve-caves -X eval "stuff '/home/dontstarve/dstserver/bin/dontstarve_dedicated_server_nullrenderer -console -persistent_storage_root /home/dontstarve/dstsave -conf_dir dst -cluster World1 -shard Caves'\015"
		#=========开启洞穴end=========
		sleep 3s
		echo "饥荒洞穴服务器启动成功！"
		echo "注：服务器有启动过程，依据你的服务器和模组配置启动时间为几十秒到几分钟不等，请稍等片刻，祝游戏愉快~"
		valid_choice=true
	elif [ "$choice" = "6" ]; then
		echo "正在关闭饥荒大世界服务器......"
		#=========关闭大世界start=========
		# 检查screen会话是否存在，如果不存在则不用关闭世界
		screen -ls | grep dontstarve-master >/dev/null
		if [ $? -ne 0 ]; then
			echo "大世界服务器不存在，无需关闭~"
		else
			# 在mysession会话中执行命令
			screen -S dontstarve-master -X eval "stuff 'c_shutdown(true)'\015"
		fi
		#=========关闭大世界end=========
		sleep 1s
		#删除screen 会话
		screen -X -S dontstarve-master quit
		echo "饥荒大世界服务器关闭操作完成！"
		valid_choice=true
	elif [ "$choice" = "7" ]; then
		echo "正在关闭饥荒洞穴服务器......"
		#=========关闭洞穴start=========
		# 检查screen会话是否存在，如果不存在则不用关闭世界
		screen -ls | grep dontstarve-caves >/dev/null
		if [ $? -ne 0 ]; then
			echo "洞穴服务器不存在，无需关闭~"
		else
			# 在mysession会话中保存并关闭服务器命令
			screen -S dontstarve-caves -X eval "stuff 'c_shutdown(true)'\015"
		fi
		#=========关闭洞穴end=========
		sleep 1s
		#删除screen 会话
		screen -X -S dontstarve-caves quit
		echo "饥荒洞穴服务器关闭操作完成！"
		valid_choice=true
	elif [ "$choice" = "8" ]; then
		echo "正在更新steam服务器......"
		#=========更新steam服务器=========
		/home/dontstarve/steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/dontstarve/dstserver +app_update 343050 validate +quit &
		updatesteampid=$!
		wait "$updatesteampid"
		echo "更新steam服务器成功,快启动服务器愉快玩耍吧~"
		valid_choice=true
	elif [ "$choice" = "9" ]; then
		echo "正在更新模组......"
		#=========更新模组=========
		/home/dontstarve/dstserver/bin/dontstarve_dedicated_server_nullrenderer -only_update_server_mods &
		updatemodpid=$!
		wait "$updatemodpid"
		echo "更新模组成功,快启动服务器愉快玩耍吧~"
		valid_choice=true
	elif [ "$choice" = "10" ]; then
		echo "开始安装饥荒服务器......"
		#1安装服务器的基本条件
		yum update &
		installpid1=$!
		wait "$installpid1"
		yum -y install glibc.i686 libstdc++.i686 libcurl4-gnutls-dev.i686 libcurl.i686 screen &
		installpid2=$!
		wait "$installpid2"
		#2安装SteamCMD
		mkdir -p /home/dontstarve/steamcmd && cd /home/dontstarve/steamcmd
		wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz &
		installpid3=$!
		wait "$installpid3"
		tar -xvzf steamcmd_linux.tar.gz &
		installpid4=$!
		wait "$installpid4"
		/home/dontstarve/steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/dontstarve/dstserver +app_update 343050 validate +quit &
		installpid5=$!
		wait "$installpid5"
		#3关键的组件libcurl-gnutls.so.4
		ln -s /usr/lib/libcurl.so.4 /home/dontstarve/dstserver/bin/lib32/libcurl-gnutls.so.4
		#4 配置token
		echo "请输入服务器token:"
		read user_input_token
		mkdir -p /home/dontstarve/dstsave/dst/World1/
		echo $user_input_token > /home/dontstarve/dstsave/dst/World1/cluster_token.txt
		echo "饥荒服务器安装好了！
		注意：请在目录 /home/dontstarve/dstsave/dst/World1/ 放入你配置好的世界。
		在/home/dontstarve/dstserver/mods/dedicated_server_mods_setup.lua 输入mod信息，例如ServerModSetup("模组1id")。
		以上如果没配置以上内容，服务器开启也没用哦，配置好后用脚本选择1开启服务器即可，祝游戏愉快~"
		valid_choice=true
	elif [ "$choice" = "11" ]; then
		echo "开始卸载饥荒服务器......"
		#删除screen 会话
		screen -ls | grep dontstarve-caves >/dev/null
		if [ $? -ne 0 ]; then
			screen -X -S dontstarve-caves quit
		fi
		screen -ls | grep dontstarve-master >/dev/null
		if [ $? -ne 0 ]; then
			screen -X -S dontstarve-master quit
		fi
		screen -ls | grep dontstarve-test-m >/dev/null
		if [ $? -ne 0 ]; then
			screen -X -S dontstarve-test-m quit
		fi
		screen -ls | grep dontstarve-test-c >/dev/null
		if [ $? -ne 0 ]; then
			screen -X -S dontstarve-test-c quit
		fi
		#删除安装文件
		rm -rf /home/dontstarve/
		valid_choice=true
	elif [ "$choice" = "12" ]; then
		echo "开始更新重启服务器......"
		echo "正在保存并关闭饥荒服务器......"
		#=========关闭服务器start=========
		# 检查screen会话是否存在，如果不存在则不用关闭世界
		screen -ls | grep dontstarve-caves >/dev/null
		if [ $? -ne 0 ]; then
			echo "洞穴服务器不存在，无需关闭~"
		else
			screen -S dontstarve-caves -X eval "stuff 'c_shutdown(true)'\015"
		fi
		screen -ls | grep dontstarve-master >/dev/null
		if [ $? -ne 0 ]; then
			echo "大世界服务器不存在，无需关闭~"
		else
			screen -S dontstarve-master -X eval "stuff 'c_shutdown(true)'\015"
		fi
		echo "关闭服务器成功！接下来将更新服务器......"
		#=========关闭服务器end=========
		sleep 3s
		#删除screen 会话
		screen -X -S dontstarve-caves quit
		screen -X -S dontstarve-master quit
		#=========更新服务器end=========
		/home/dontstarve/steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/dontstarve/dstserver +app_update 343050 validate +quit &
		updatepid[0]=$!
		/home/dontstarve/dstserver/bin/dontstarve_dedicated_server_nullrenderer -only_update_server_mods &
		updatepid[1]=$!
		for i in "${updatepid[@]}"; do
			wait "$i"
		done
		echo "饥荒服务器更新操作完成!接下来将启动服务器......"
		#=========更新服务器end=========
		sleep 3s
		#=========开启服务器start=========
		echo "正在启动饥荒服务器......"
		screen -ls | grep dontstarve-master >/dev/null
		if [ $? -ne 0 ]; then
			screen -dmS dontstarve-master
		fi
		screen -S dontstarve-master -X eval "stuff '/home/dontstarve/dstserver/bin/dontstarve_dedicated_server_nullrenderer -console -persistent_storage_root /home/dontstarve/dstsave -conf_dir dst -cluster World1 -shard Master'\015"
		screen -ls | grep dontstarve-caves >/dev/null
		if [ $? -ne 0 ]; then
			screen -dmS dontstarve-caves
		fi
		screen -S dontstarve-caves -X eval "stuff '/home/dontstarve/dstserver/bin/dontstarve_dedicated_server_nullrenderer -console -persistent_storage_root /home/dontstarve/dstsave -conf_dir dst -cluster World1 -shard Caves'\015"
		#=========开启服务器end=========
		sleep 3s
		echo "饥荒服务器启动成功！"
		echo "注：服务器有启动过程，依据你的服务器和模组配置启动时间为几十秒到几分钟不等，请稍等片刻，祝游戏愉快~"
		valid_choice=true
	elif [ "$choice" = "13" ]; then
		#退出
		valid_choice=true
	else
		echo "无效选择，请重新选择"
	fi
done
