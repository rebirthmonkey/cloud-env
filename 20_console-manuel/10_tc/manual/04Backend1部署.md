# 04 Backend1 部署

## 部署CLB

部署 be-clb



## 部署弹性伸缩组
AS 部署见 02Frontend部署，弹性伸缩组部分

启动脚本

```bash
#!/bin/bash

mkdir -p /usr/local/bin/app1/configs
wget "https://ruan-1251956900.cos.ap-guangzhou.myqcloud.com/app1/app1" -O /usr/local/bin/app1/app1
chmod +x /usr/local/bin/app1/app1

wget "https://ruan-1251956900.cos.ap-guangzhou.myqcloud.com/app1/config.yaml" -O /usr/local/bin/app1/configs/config.yaml

systemctl stop app1

cat >  /etc/systemd/system/app1.service <<EOF
[Unit]
Description=Go Application Service

[Service]
ExecStart=/bin/bash -c '/usr/local/bin/app1/app1 -c /usr/local/bin/app1/configs/config.yaml >> /tmp/app1.log 2>&1'
WorkingDirectory=/usr/local/bin/
User=root
Restart=always
Type=simple
KillMode=mixed

[Install]
WantedBy=multi-user.target
EOF

systemctl enable app1
systemctl daemon-reload
echo "app1 enabled, now starting..."
systemctl start app1
```


### 验证弹性伸缩组

绑定 app2.tamlab.net 至 clb IP 地址，测试方法与 02 Frontend 验证方法相同

```bash
 ab -c 30 -t 300 -n 30000 app2.tamlab.net
```



