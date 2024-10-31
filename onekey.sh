#!/bin/sh

somecheck(){
	# 检查是否为ks固件
	if [ ! -d /koolshare/bin/ ]; then
		echo "🔴请在koolcenter下执行，其他环境可能存在问题。"
		exit;
	fi
	# 检查固件脚本目录
	if [ ! -d /rom/etc/koolshare/scripts/ ]; then
		echo "🔴固件脚本目录不存在，无法一键修复。"
		exit;
	fi
}

changeAsd(){
	local file="asd"
	local file_path=$(which "$file")
	local target_dir="/koolshare/bin/"
	# 检查文件是否找到
	if [ -n "$file_path" ]; then
		echo "✅️找到 $file，路径为 $file_path"

		# 构建目标挂载点
		mount_point="$target_dir/$file"

		# 检查是否已fuck
		checkFuck=$(ps |grep asd |grep /bin/sh)
		if [ -n "$checkFuck" ];then
			echo "✅️已处理 $file 无需再次处理！"
			return
		fi

		#生成挂载文件
		echo "#!/bin/sh

while true
do
sleep 86400
done" > $mount_point

		# 赋权
		chmod +x $mount_point

		# 执行挂载
		mount --bind "$mount_point" "$file_path"

		# 杀掉所有命令
		killall $file > /dev/null
		killall $file > /dev/null
		killall $file > /dev/null

		local i=40
		local checkFuck
		until [ -n "${checkFuck}" ]; do
			usleep 250000
			echo "ℹ️检查处理状态中..."
			i=$(($i - 1))
			checkFuck=$(ps |grep asd |grep /bin/sh)
			if [ "$i" -lt 1 ]; then
				echo "🔴处理失败，请稍后再次尝试。"
				return
			fi
		done

		echo "🆗 处理 $file 成功"

		echo "ℹ️ $file 处理重启失效，如果需要持久化，请前往相应群组了解详情。"
	else
		echo "ℹ️ $file 未找到，您不需要处理"
	fi
}

recoverySoftcenter(){
	echo "ℹ️ 恢复软件中心安装脚本"
	# 恢复文件
	cp -rf /rom/etc/koolshare/scripts/* /koolshare/scripts/
	# 文件赋权
	chmod +x /koolshare/scripts/*
	echo "✅ 软件中心安装脚本恢复成功"
}

somecheck
changeAsd
recoverySoftcenter

echo "🆗 enjoy ~"