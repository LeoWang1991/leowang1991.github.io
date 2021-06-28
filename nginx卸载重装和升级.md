---
title: "Nginx卸载重装和升级"
date: 2020-05-28T11:18:26+08:00
draft: false
tags: ['nginx']
categories: ['后端']
img: 'https://tva1.sinaimg.cn/large/006y8mN6ly1g7zvd7vrckj31e70qp1kz.jpg'
---

#### 前言

了解nginx在centos上安装和配置步骤



#### 平滑升级

参考： https://www.jianshu.com/p/097d1f907289

![image-20200528140644676](https://tva1.sinaimg.cn/large/007S8ZIlly1gf84rebbdkj31fs0e24f4.jpg)

步骤如下：

1. 获取编译参数
2. 获取指定版本源码
3. 配置编译
4. 替换升级



**1 获取当前编译参数**

通过`nginx -V`来获取 

```bash
./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx  --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx  --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic -fPIC' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -pie'
```



**2 获取指定版本,并配置参数**

比如想要获取1.9.10版本 去官网下载，在服务器上可以使用wget来下载，然后解压得到

```bash
wget http://nginx.org/download/nginx-1.9.10.tar.gz
tar zxvf nginx-1.9.10
```

然后我们到该目录中采用上面当前的nginx参数进行配置
![image-20200528142229034](https://tva1.sinaimg.cn/large/007S8ZIlly1gf857pedztj30yk06un2z.jpg)

```bash
./configure
--prefix=/etc/nginx
--sbin-path=/usr/sbin/nginx
--conf-path=/etc/nginx/nginx.conf
--error-log-path=/var/log/nginx/error.log
--http-log-path=/var/log/nginx/access.log 
--pid-path=/var/run/nginx.pid
--lock-path=/var/run/nginx.lock
--http-client-body-temp-path=/var/cache/nginx/client_temp
--http-proxy-temp-path=/var/cache/nginx/proxy_temp
--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_tem
--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp
--http-scgi-temp-path=/var/cache/nginx/scgi_temp
--user=nginx
--group=nginx
--with-file-aio
--with-threads
--with-http_addition_module
--with-http_auth_request_module
--with-http_dav_module
--with-http_flv_module
--with-http_gunzip_module
--with-http_gzip_static_module
--with-http_mp4_module
--with-http_random_index_module
--with-http_realip_module
--with-http_secure_link_module
--with-http_slice_module
--with-http_ssl_module
--with-http_stub_status_module
--with-http_sub_module
--with-http_v2_module
--with-mail
--with-mail_ssl_module
--with-stream
--with-stream_realip_module
--with-stream_ssl_module
--with-stream_ssl_preread_module
--with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic -fPIC'
--with-ld-opt='-Wl,-z,relro -Wl,-z,now -pie'
```

遇到的错误：

> ./configure: error: the HTTP rewrite module requires the PCRE library.
>
> ./configure: error: the HTTP gzip module requires the zlib library.
> You can either disable the module by using --without-http_gzip_module
> option, or install the zlib library into the system, or build the zlib library
> statically from the source with nginx by using --with-zlib=<path> option.

![image-20200528143106278](https://tva1.sinaimg.cn/large/007S8ZIlly1gf85gr0pa0j311004kn0m.jpg)

解决办法：安装pcre-devel, zlib-devel 参考:https://www.cnblogs.com/jpdoutop/p/5745230.html

> yum -y install pcre-devel
>
> yum install -y zlib-devel

配置好，然后进行编译`make` 指令



**3 备份老版本nginx**

切换到`/usr/sbin` 目录中

```bash
[root@vm1 sbin]# mv ./nginx ./nginx.old
[root@vm1 nginx-1.9.10]# cp objs/nginx  旧nginx所在目录/sbin
```



**4 替换升级 更改配置项**

测试`nginx -t` 如果有目录缺失比如`logs`或者是默认的`nginx.conf`路径为`/conf/nginx.conf` 那么按这个去补全就行

最后重启下就行了



升级了下数据共享的nginx版本

![image-20200528163514334](../../../blogs/imgs/image-20200528163514334.png)

![image-20200528163526666](../../../blogs/imgs/image-20200528163526666.png)

