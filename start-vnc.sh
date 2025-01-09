#!/bin/bash

# 后台运行 danted 监控
(
  MONITOR_TUN0=1
  while [ $MONITOR_TUN0 -eq 1 ]; do
    if ip link show tun0 >/dev/null 2>&1; then
      if ip -4 addr show tun0 | grep -q 'inet' >/dev/null 2>&1; then
        if ! pgrep danted >/dev/null; then
          echo "tun0 with IPv4 detected, starting danted..."
          su daemon -s /etc/init.d/danted start
          MONITOR_TUN0=0
        fi
      fi
    fi
    sleep 1
  done
) &

iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE

VNC_USER=${USER:-vncuser}
PASSWORD=${PASSWORD:-password}
PROTOCOL=${PROTOCOL:-http}

# 清理可能存在的旧锁文件
rm -f /tmp/.X1-lock
rm -f /tmp/.X11-unix/X1

# 创建 KasmVNC 用户
echo "Creating KasmVNC user: $VNC_USER"
echo -e "$PASSWORD\n$PASSWORD\n" | kasmvncpasswd -u $VNC_USER -w -r

# 写入 KasmVNC 默认配置
mkdir -p $HOME/.vnc
echo "network:
  protocol: $PROTOCOL
  websocket_port: 5901
  ssl:
    require_ssl: false
command_line:
  prompt: false
" | tee $HOME/.vnc/kasmvnc.yaml

# 启动 KasmVNC
echo "Starting KasmVNC server..."
kasmvncserver :1 -geometry 1280x720 -depth 24

export DISPLAY=:1

# 启动 fluxbox 窗口管理器
echo "Starting fluxbox..."
fluxbox &
sleep 1 # 等待fluxbox启动

# 启动 iNodeClient
echo "Starting iNodeClient..."
/etc/init.d/iNodeAuthService restart
if [ "$(uname -m)" = "x86_64" ]; then
  /opt/apps/com.client.inode.amd/files/.iNode/iNodeClient
else
  /opt/apps/com.client.inode.arm/files/.iNode/iNodeClient
fi
