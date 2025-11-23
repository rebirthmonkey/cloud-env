#!/bin/bash

# curl -fsSL https://get.docker.com/ | sh

curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
yum install -y wget yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
sudo sed -i 's+download.docker.com+mirrors.aliyun.com/docker-ce+' /etc/yum.repos.d/docker-ce.repo
sudo yum -y install docker-ce
systemctl enable docker
systemctl start docker


wget -c https://tmigrate-overseas-1258685193.cos.ap-singapore.myqcloud.com/downloads/nginx_purge_linux.tgz -O /data/nginx_purge_linux.tgz
docker load -i /data/nginx_purge_linux.tgz

cat > /data/nginx.conf << 'EOF'
# load_module /usr/lib/nginx/modules/ngx_http_cache_purge_module.so;
# user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log notice;
pid        /run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - [$upstream_cache_status] $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    log_format  proxy  '$remote_addr - [$upstream_cache_status] $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=edgeone:10m
                         inactive=60m use_temp_path=off max_size=1g;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    include /etc/nginx/conf.d/*.conf;
}

EOF

cat > /data/domains.conf << 'EOF'
server {
    listen       8080;
    server_name  cdn.tmigrate.com;

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    # error_page   500 502 503 504  /50x.html;
    #location = /50x.html {
    #    root   /usr/share/nginx/html;
    #}

    location ~ /502 {
        proxy_pass   http://127.0.0.1:9999;
    }

    location / {
       proxy_pass   http://127.0.0.1:9090;
       proxy_cache  edgeone;
       proxy_cache_bypass $http_pragma;       # 当请求头含 Pragma:no-cache 时跳过缓存
       proxy_no_cache $http_cookie $arg_nocache;  # 当请求含 Cookie 或 ?nocache=1 时不缓存
       proxy_cache_revalidate on;  # 使用 If-Modified-Since/If-None-Match 验证过期缓存
       proxy_cache_background_update on;  # 后台更新缓存（不阻塞客户端请求）

       proxy_read_timeout 3;

       proxy_cache_key "$scheme$host$request_uri";
       # 设置不同响应码的缓存时间
       proxy_cache_valid 200 302 10m;   # 成功和重定向缓存10分钟
       proxy_cache_valid 404      1m;   # 404缓存1分钟
       proxy_cache_valid any      5s;    # 其他响应码缓存5秒

       # 缓存锁定（防止多个请求同时更新缓存）
       proxy_cache_lock on;
       proxy_cache_lock_timeout 5s;

       # 透传后端服务器生成的缓存头（如Cache-Control）
       # proxy_ignore_headers Cache-Control;

       proxy_cache_purge  PURGE from 127.0.0.1 192.168.127.1;

       add_header X-Proxy-Cache $upstream_cache_status;

    }

    #location ~ /purge(/.*) {
    ##    allow              127.0.0.1;
     #   allow              192.168.127.1;
     #   deny               all;
     #   proxy_cache        edgeone;
     #   proxy_cache_key    "$scheme$host$1";
    #   #  proxy_cache_purge  edgeone $scheme$host$1;
   # }


}

server {
    listen       9090;
    server_name  cdn.tmigrate.com origin.tmigrate.com;

    location /index.html {
        echo "<html>Hello TAM</html>";
    }
    location /sleep1 {
       echo_sleep 5;
       echo world;
    }
    location /no-store {
        add_header Cache-Control no-store;
        echo "no-store";
        add_header Content-Type "text/html; charset=utf-8" always;
    }
    location /no-cache {
        add_header Cache-Control "no-cache";
        echo "no-cache";
        add_header Content-Type "text/html; charset=utf-8" always;
    }
    location /max-age {
        add_header Cache-Control "max-age=5";
        echo "max-age";
        add_header Content-Type "text/html; charset=utf-8" always;
    }
    location /expires {
        expires 5s;
        echo "expires";
        add_header Content-Type "text/html; charset=utf-8" always;
    }
    location /etag {
        add_header Etag 12345678;
        echo "etag";
        add_header Content-Type "text/html; charset=utf-8" always;
    }
    location /etag-max-age {
        add_header Etag 12345678;
        add_header Cache-Control "max-age=5";
        echo "etag";
        add_header Content-Type "text/html; charset=utf-8" always;
    }
}

EOF

mkdir -p /data/cache
mkdir -p /data/html

docker run \
-ti -d --name nginx \
-v /data/nginx.conf:/etc/nginx/nginx.conf \
-v /data/domains.conf:/etc/nginx/conf.d/default.conf \
-v /data/cache:/var/cache/nginx \
--net=host \
-v /data/html:/usr/share/nginx/html \
localhost/nginx:purge_linux