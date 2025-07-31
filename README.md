# csworkflow
csw（Comprehensive service workflows）	综合服务工作流脚本

bsw（Basic setup workflow）			     基础设置工作流脚本

csw主要针对的是部署各种服务和实现各种功能，或者方便对一些文件或者系统配置进行修改，具体可用功能可以看下方列表。

bsw主要适合批量对系统进行一些网络基础设置，会关闭防火墙、SELinux，同时下载常用软件，可选择性的配置本地dnf源，同时可以对网卡进行开关和基础配置。

再使用csw时需要做好网络基础设置，可以使用bsw脚本进行配置，但是还是请谨慎配置，在我的测试环境中由于脚本逻辑和 Network Manager 的一些bug，在网络设置上可能会出现一些小问题，不过网上有很多解决方式，也可以直接在github中提出问题，我会在issue中进行反馈。

最后是这个shell脚本绝大多数的公式经过了测试，在按照提示进行操作的前提下基本没有什么问题，但不可柔韧的是的脚本的鲁棒性的确不佳，而且没有模块化的设计，所以就有了csw2py的版本，不过由于本人有点懒，所以csw2py的进度比较慢，可能看到的时候也只是开了个头（在csw2py分支中）。

## 测试环境

VMware workstation pro 17.6.1

Rocky Linux 9.4

## 主要功能

### 快速部署服务

- DHCP
    - 基础DHCP服务
    - 保留地址池DHCP
    - DHCP超级作用域
    - DHCP中继器

- DNS
    - 基础(主)DNS服务
    - DNS主从服务器
    - DNS缓存服务器
    - 智能DNS服务器

- FTP
- NFS
- Apache(不完善)
    - Apache - wordpreess项目部署

- Nginx(暂无)
    - 暂无

- Tomcat(不完善)
    - Tomcat - mypress项目部署

- MySQL
    - 主从结构-异步数据库
        - 基础主-从
        - 一主多从(从-主-从)
        - 级联复制(主-从(主)-从)
        - 互为主从(主(从)-从(主))
        - 双活数据中心(主-从-主)

    - MGC同步数据库集群
    - 中间件反向代理(读写分离)

- Redis
    - Redis持久化
    - Redis主从配置
    - Redis Sentinel
    - Redis Cluster
      - 单台多实例
      - 多台

- Mail（配置extmail，部署Apache虚拟主机）

### 其他功能

- 网卡设置set_ens
- ip_forward路由转发功能开关
- Rsync+inotify指定目录实时备份
- 局域网内SSH免密互通
