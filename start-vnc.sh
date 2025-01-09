#!/bin/bash

# 启用 IP 转发
echo 1 >/proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE

# 获取当前用户名
CURRENT_USER=$(whoami)
PASSWORD=${PASSWORD:-password}

# 清理可能存在的旧锁文件
rm -f /tmp/.X1-lock
rm -f /tmp/.X11-unix/X1

# 创建 KasmVNC 用户
echo "Creating KasmVNC user: $CURRENT_USER"
echo -e "$PASSWORD\n$PASSWORD\n" | kasmvncpasswd -u $CURRENT_USER -w -r

# 启动 KasmVNC
echo "Starting KasmVNC server..."
kasmvncserver :1 -geometry 1280x720 -depth 24 -noxstartup

export DISPLAY=:1

# 启动 fluxbox 窗口管理器
echo "Starting fluxbox..."
fluxbox &
sleep 1 # 等待fluxbox启动

# 启动 iNodeClient
echo "Starting iNodeClient..."
/etc/init.d/iNodeAuthService restart
/opt/apps/com.client.inode.arm/files/.iNode/iNodeClient
