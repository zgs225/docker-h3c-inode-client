# H3C iNode VPN 客户端 Docker 镜像

这是一个支持多架构（amd64/arm64）的 H3C iNode VPN 客户端 Docker 镜像，基于 Ubuntu 20.04 构建，包含 KasmVNC 远程桌面服务。

## 功能特性
- 支持 x86_64 和 arm64 架构
- 内置 H3C iNode 客户端
- 集成 KasmVNC 远程桌面
- 自动配置 Dante SOCKS5 代理
- 支持 VPN 连接信息持久化存储


## 环境变量
| 变量名       | 默认值    | 说明                          |
|--------------|-----------|-------------------------------|
| USER         | vncuser   | VNC 登录用户名                |
| PASSWORD     | password  | VNC 登录密码                  |
| PROTOCOL     | http      | VNC 连接协议 (http/vnc)       |

## 端口说明
- 5901: KasmVNC 远程桌面端口，支持 WebSocket 和 HTTP 协议
- 1080: Dante SOCKS5 代理端口，用于通过 VPN 隧道转发流量

## 使用方法

### Docker 运行示例
```bash
docker run -d \
  --name h3c-inode \
  -p 5901:5901 \
  -p 1080:1080 \
  -e USER=myuser \
  -e PASSWORD=mypassword \
  -v /path/to/vpn_data:/opt/apps/com.client.inode.arm/files/clientfiles/7000 \
  --cap-add=NET_ADMIN \
  --device /dev/net/tun \
  ghcr.io/zgs225/h3c-inode-client:latest
```

### docker-compose 示例
```yaml
version: '3'
services:
  h3c-inode:
    image: ghcr.io/zgs225/h3c-inode-client:latest
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun
    ports:
      - "5901:5901"
      - "1080:1080"
    environment:
      - USER=myuser
      - PASSWORD=mypassword
    volumes:
      - ./vpn_data:/opt/apps/com.client.inode.arm/files/clientfiles/7000
    restart: unless-stopped
```

## 连接说明
1. 容器启动后，使用 VNC 客户端连接
2. 地址：`http://<服务器IP>:5901`
3. 使用设置的用户名和密码登录
4. 在远程桌面中运行 iNode 客户端进行 VPN 连接

## 开发与构建
本项目支持多架构构建，使用 GitHub Actions 自动构建和推送镜像。

## 许可证
MIT License
