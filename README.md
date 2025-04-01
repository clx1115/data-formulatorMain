# Data-Formulator Linux部署指南

本文档提供在Linux环境下部署Data-Formulator的详细步骤。

## 系统要求

- Linux操作系统 (推荐Ubuntu 20.04或更高版本)
- Python 3.8或更高版本
- pip包管理器
- Git

## 方法一：直接部署

1. 创建部署目录和用户
```bash
# 创建系统用户
sudo useradd -r -s /bin/bash data-formulator
# 创建部署目录
sudo mkdir -p /opt/data-formulator
sudo chown data-formulator:data-formulator /opt/data-formulator
```

2. 复制部署文件
```bash
# 复制所有文件到部署目录
sudo cp -r * /opt/data-formulator/
sudo chown -R data-formulator:data-formulator /opt/data-formulator/
```

3. 创建并激活虚拟环境
```bash
cd /opt/data-formulator
python -m venv venv
source venv/bin/activate
```

4. 安装依赖
```bash
pip install -r requirements.txt
```

5. 配置环境变量
```bash
cp .env.example .env
# 根据需要编辑.env文件
```

6. 设置系统服务
```bash
# 复制服务文件
sudo cp data-formulator.service /etc/systemd/system/
# 重新加载systemd
sudo systemctl daemon-reload
# 启动服务
sudo systemctl start data-formulator
# 设置开机自启
sudo systemctl enable data-formulator
```

7. 检查服务状态
```bash
sudo systemctl status data-formulator
```

## 方法二：使用Docker部署

1. 构建Docker镜像
```bash
docker build -t data-formulator .
```

2. 运行容器
```bash
docker run -d \
  --name data-formulator \
  -p 6000:5000 \
  -v $(pwd)/data:/app/data \
  data-formulator
```

## 访问应用

部署完成后，可以通过以下地址访问应用：
- 直接部署：http://your-server-ip:5000
- Docker部署：http://your-server-ip:5000

## 常见问题排查

1. 服务无法启动
   - 检查日志：`sudo journalctl -u data-formulator`
   - 确认端口未被占用：`sudo lsof -i :5000`
   - 检查权限：`ls -la /opt/data-formulator`

2. 无法访问应用
   - 检查防火墙设置：`sudo ufw status`
   - 确认服务运行状态：`sudo systemctl status data-formulator`
   - 验证端口监听：`netstat -tulpn | grep 5000`

3. 性能问题
   - 检查系统资源：`top`, `htop`
   - 查看磁盘空间：`df -h`
   - 监控内存使用：`free -m`

## 备份和维护

1. 定期备份
```bash
# 备份配置文件
sudo cp /opt/data-formulator/.env /backup/
# 备份数据目录
sudo tar -czf /backup/data-formulator-$(date +%Y%m%d).tar.gz /opt/data-formulator/data/
```

2. 更新应用
```bash
cd /opt/data-formulator
source venv/bin/activate
pip install --upgrade data-formulator
sudo systemctl restart data-formulator
```

## 安全建议

1. 始终使用最新版本
2. 定期更新系统和依赖包
3. 使用防火墙限制访问
4. 配置SSL证书实现HTTPS访问
5. 定期检查日志文件

## 支持和帮助

如果遇到问题，可以：
1. 查看官方文档：https://github.com/microsoft/data-formulator
2. 提交Issue：https://github.com/microsoft/data-formulator/issues
3. 检查系统日志：`sudo journalctl -u data-formulator`
