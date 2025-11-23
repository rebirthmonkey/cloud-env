# 05 Backend2 部署

## k8s 部署Backend2

### 创建tcr实例并推送镜像

在相关地区创建tcr实例
![img](figures/tcr1.png)
配置网络及镜像仓库
![img](figures/tcr2.png)

推送镜像需要如下步骤
![img](figures/tcr0.png)

1. 登录镜像仓库: 在已配置的信任网络内服务器上，使用 Docker 客户端执行以下命令，即可登录实例。
指令中的密码是自动生成的临时访问凭证，可替换为长期凭证。
```
docker login tamlab.tencentcloudcr.com --username 200028315052 --password eyJhbGciOiJSUzI1NiIsImtpZCI6IkNETzQ6U0JVMzpEMlVZOjROUVY6N1lBRjpSR1dIOlRYWU46VkVIUDoyUVU0OjI1N1Q6QlVQUzpNNjRVIn0.eyJvd25lclVpbiI6IjEwMDAwOTI5MTE3NSIsIm9wZXJhdG9yVWluIjoiMjAwMDI4MzE1MDUyIiwiZXhwIjoxNzE1ODk5NzY3LCJuYmYiOjE3MTU4OTYxNjcsImlhdCI6MTcxNTg5NjE2N30.mxL5Ntjig9dgrwuM9y4mHUiAuywo3vSnsSJZowvDiPPrKnhOt9-AeesjsPzMSIGpNUhlPfMaZ208k8HIFEkwzqq25n6MM4SfCFaYyAEhIgyQ-Ik5kq4x1XeRTQ2FjHE8AYBLtmpZ2IYd-50BDO8l9JFvRwNGni20yb9m1tJL92xYEJAcJdcXovxN2hTwYrNy2aiL7BXQqszVPA5-KVqi434ViYImncobucH2oHSDM1zqt3EborOU5o5NzSZMOGfEMnPdKrEfASBz0FEqb9s8bTbjNJBmW0---vrsKrZ0kf91nb_W995mS3LoLUlK7RAZb4yZ-XgszzEM4ZXD8gzwKA
```

2. 准备容器镜像:
在Backend App2 /build 目录下运行
```
docker build -t app2:latest .
```

3.推送容器镜像至镜像仓库: 使用 `docker tag` 指令将本地容器镜像重新命名，并使用 `docker push` 指令推送镜像到上步骤配置的镜像仓库内 
```
docker tag app2:latest tamlab.tencentcloudcr.com/app2/backend/app2:latest
docker push tamlab.tencentcloudcr.com/app2/backend/app2:latest
```

4.镜像仓库验证镜像已成功上传
![img](figures/tcr3.png)


### TKE集群拉取镜像部署程序

创建标准tke容器集群，配置集群规格，地域，网络,
![img](figures/tke1.png)

进入集群基本信息页，在工作负载 > Deployment 中单击新建，并选择在上述步骤已完成上传的镜像
![img](figures/tke2.png)