#!/bin/bash

#是否是有效的选择，false代表无效的选择，需要重新选
valid_choice=false

while [ "$valid_choice" = false ]; do
	# 提示用户输入选择
	echo "请选择操作："
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
	read choice

	# 条件判断
	if [ "$choice" = "1" ]; then
		echo "正在启动饥荒服务器......"
		#=========开启大世界start=========
		# 检查screen会话是否存在，如果不存在则创建一个新的会话
		screen -ls | grep jihuang-master >/dev/null
		if [ $? -ne 0 ]; then
			screen -dmS jihuang-master
		fi
		# 在mysession会话中执行开启主世界命令
		screen -S jihuang-master -X eval "stuff './dontstarve_dedicated_server_nullrenderer -console -persistent_storage_root /home/dstsave -conf_dir dst -cluster World1 -shard Master'\015"
		#=========开启大世界end=========
		#=========开启洞穴start=========
		# 检查screen会话是否存在，如果不存在则创建一个新的会话
		screen -ls | grep jihuang-caves >/dev/null
		if [ $? -ne 0 ]; then
			screen -dmS jihuang-caves
		fi
		# 在mysession会话中执行命令
		screen -S jihuang-caves -X eval "stuff './dontstarve_dedicated_server_nullrenderer -console -persistent_storage_root /home/dstsave -conf_dir dst -cluster World1 -shard Caves'\015"
		#=========开启洞穴end=========
		sleep 3s
		echo "饥荒服务器启动成功！"
		echo "注：服务器有启动过程，依据你的服务器和模组配置启动时间为几十秒到几分钟不等，请稍等片刻，祝游戏愉快~"
		valid_choice=true
	elif [ "$choice" = "2" ]; then
		echo "正在保存并关闭饥荒服务器......"
		#=========关闭洞穴start=========
		# 检查screen会话是否存在，如果不存在则不用关闭世界
		screen -ls | grep jihuang-caves >/dev/null
		if [ $? -ne 0 ]; then
			echo "洞穴服务器不存在，无需关闭~"
		else
			# 在mysession会话中保存并关闭服务器命令
			screen -S jihuang-caves -X eval "stuff 'c_shutdown(true)'\015"
		fi
		#=========关闭洞穴end=========
		#=========关闭大世界start=========
		# 检查screen会话是否存在，如果不存在则不用关闭世界
		screen -ls | grep jihuang-master >/dev/null
		if [ $? -ne 0 ]; then
			echo "大世界服务器不存在，无需关闭~"
		else
			# 在mysession会话中执行命令
			screen -S jihuang-master -X eval "stuff 'c_shutdown(true)'\015"
		fi
		#=========关闭大世界end=========
		sleep 3s
		echo "饥荒服务器已关闭！"
		valid_choice=true
	elif [ "$choice" = "3" ]; then
		echo "正在更新饥荒服务器......"

		#=========更新steam服务器=========
		/home/steam/steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/steam/dst +app_update 343050 validate +quit &
		updatepid[0]=$!
		#=========更新模组=========
		/home/dstserver/bin/dontstarve_dedicated_server_nullrenderer -only_update_server_mods &
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
		screen -ls | grep jihuang-master >/dev/null
		if [ $? -ne 0 ]; then
			screen -dmS jihuang-master
		fi
		# 在mysession会话中执行开启主世界命令
		screen -S jihuang-master -X eval "stuff './dontstarve_dedicated_server_nullrenderer -console -persistent_storage_root /home/dstsave -conf_dir dst -cluster World1 -shard Master'\015"
		#=========开启大世界end=========
		sleep 3s
		echo "饥荒大世界服务器启动成功！"
		echo "注：服务器有启动过程，依据你的服务器和模组配置启动时间为几十秒到几分钟不等，请稍等片刻，祝游戏愉快~"
		valid_choice=true
	elif [ "$choice" = "5" ]; then
		echo "正在启动饥荒洞穴服务器......"
		#=========开启洞穴start=========
		# 检查screen会话是否存在，如果不存在则创建一个新的会话
		screen -ls | grep jihuang-caves >/dev/null
		if [ $? -ne 0 ]; then
			screen -dmS jihuang-caves
		fi
		# 在mysession会话中执行命令
		screen -S jihuang-caves -X eval "stuff './dontstarve_dedicated_server_nullrenderer -console -persistent_storage_root /home/dstsave -conf_dir dst -cluster World1 -shard Caves'\015"
		#=========开启洞穴end=========
		sleep 3s
		echo "饥荒洞穴服务器启动成功！"
		echo "注：服务器有启动过程，依据你的服务器和模组配置启动时间为几十秒到几分钟不等，请稍等片刻，祝游戏愉快~"
		valid_choice=true
	elif [ "$choice" = "6" ]; then
		echo "正在关闭饥荒大世界服务器......"
		#=========关闭大世界start=========
		# 检查screen会话是否存在，如果不存在则不用关闭世界
		screen -ls | grep jihuang-master >/dev/null
		if [ $? -ne 0 ]; then
			echo "大世界服务器不存在，无需关闭~"
		else
			# 在mysession会话中执行命令
			screen -S jihuang-master -X eval "stuff 'c_shutdown(true)'\015"
		fi
		#=========关闭大世界end=========
		echo "饥荒大世界服务器关闭操作完成！"
		valid_choice=true
	elif [ "$choice" = "7" ]; then
		echo "正在关闭饥荒洞穴服务器......"
		#=========关闭洞穴start=========
		# 检查screen会话是否存在，如果不存在则不用关闭世界
		screen -ls | grep jihuang-caves >/dev/null
		if [ $? -ne 0 ]; then
			echo "洞穴服务器不存在，无需关闭~"
		else
			# 在mysession会话中保存并关闭服务器命令
			screen -S jihuang-caves -X eval "stuff 'c_shutdown(true)'\015"
		fi
		#=========关闭洞穴end=========
		echo "饥荒洞穴服务器关闭操作完成！"
		valid_choice=true
	elif [ "$choice" = "8" ]; then
		echo "正在更新steam服务器......"
		#=========更新steam服务器=========
		/home/steam/steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/steam/dst +app_update 343050 validate +quit &
		updatesteampid=$!
		wait "$updatesteampid"
		echo "更新steam服务器成功,快启动服务器愉快玩耍吧~"
		valid_choice=true
	elif [ "$choice" = "9" ]; then
		echo "正在更新模组......"
		#=========更新模组=========
		/home/dstserver/bin/dontstarve_dedicated_server_nullrenderer -only_update_server_mods &
		updatemodpid=$!
		wait "$updatemodpid"
		echo "更新模组成功,快启动服务器愉快玩耍吧~"
		valid_choice=true
	elif [ "$choice" = "10" ]; then
		echo "该操作暂时未实现，请重新选择"
    
	elif [ "$choice" = "11" ]; then
		echo "该操作暂时未实现，请重新选择"
	elif [ "$choice" = "12" ]; then
		echo "开始更新重启服务器......"
		echo "正在保存并关闭饥荒服务器......"
		#=========关闭服务器start=========
		# 检查screen会话是否存在，如果不存在则不用关闭世界
		screen -ls | grep jihuang-caves >/dev/null
		if [ $? -ne 0 ]; then
			echo "洞穴服务器不存在，无需关闭~"
		else
			screen -S jihuang-caves -X eval "stuff 'c_shutdown(true)'\015"
		fi
		screen -ls | grep jihuang-master >/dev/null
		if [ $? -ne 0 ]; then
			echo "大世界服务器不存在，无需关闭~"
		else
			screen -S jihuang-master -X eval "stuff 'c_shutdown(true)'\015"
		fi
		echo "关闭服务器成功！接下来将更新服务器......"
		#=========关闭服务器end=========
		sleep 3s
		#=========更新服务器end=========
		/home/steam/steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/steam/dst +app_update 343050 validate +quit &
		updatepid[0]=$!
		/home/dstserver/bin/dontstarve_dedicated_server_nullrenderer -only_update_server_mods &
		updatepid[1]=$!
		for i in "${updatepid[@]}"; do
			wait "$i"
		done
		echo "饥荒服务器更新操作完成!接下来将启动服务器......"
		#=========更新服务器end=========
		sleep 3s
		#=========开启服务器start=========
		echo "正在启动饥荒服务器......"
		screen -ls | grep jihuang-master >/dev/null
		if [ $? -ne 0 ]; then
			screen -dmS jihuang-master
		fi
		screen -S jihuang-master -X eval "stuff './dontstarve_dedicated_server_nullrenderer -console -persistent_storage_root /home/dstsave -conf_dir dst -cluster World1 -shard Master'\015"
		screen -ls | grep jihuang-caves >/dev/null
		if [ $? -ne 0 ]; then
			screen -dmS jihuang-caves
		fi
		screen -S jihuang-caves -X eval "stuff './dontstarve_dedicated_server_nullrenderer -console -persistent_storage_root /home/dstsave -conf_dir dst -cluster World1 -shard Caves'\015"
		#=========开启服务器end=========
		sleep 3s
		echo "饥荒服务器启动成功！"
		echo "注：服务器有启动过程，依据你的服务器和模组配置启动时间为几十秒到几分钟不等，请稍等片刻，祝游戏愉快~"
		valid_choice=true
	elif [ "$choice" = "13" ]; then
		valid_choice=true
	else
		echo "无效选择，请重新选择"
	fi
done
