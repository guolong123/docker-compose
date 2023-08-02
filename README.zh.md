# 部署说明
## 前置条件

### linux
1. 安装 [docker](https://docs.docker.com/engine/install/)
2. 安装 [docker-compose](https://docs.docker.com/compose/install/standalone/)

### docker for mac/windows
1. 安装 [docker-desktop](https://www.docker.com/products/docker-desktop/)

## 限制条件
1. 具有外部网络访问权限（如没有，则需要使用离线镜像）
2. 此方式仅支持单机部署（可单机多节点）

## 安装步骤
1. 将此目录（docker-compose）放到部署目录下，例如：`${PWD}/docker-compose`
3. 执行安装
    
    a. 修改mysql密码
    ```bash
    cd ~/docker-compose
    # 使用 `sed` 命令来修改 MySQL 密码
    # 在 Linux 系统上修改 Mysql 密码
    sed -i 's/MYSQL_PASSWORD=""/MYSQL_PASSWORD="ChangeThisPassword"/g' .env

    # 在 Mac 系统上修改 Mysql 密码
    sed -i '' 's/MYSQL_PASSWORD=""/MYSQL_PASSWORD="ChangeThisPassword"/g' .env
    # 您也可以手动编辑`.env`文件，来修改 MySQL 密码和其它相关配置项
    vim .env
    ```
    b. 开始安装
    ```bash
    docker compose up -d
    ```
    c. 等待片刻(大约1-4分钟)，访问服务，在你的 web 浏览器中打开地址：http://127.0.0.1:8080
    
    d. 检查安装结果
    ```
    docker compose ps
    ```
    e. 查看服务日志
    ```
    docker compose logs -f
    ```
    f. 卸载/清理
    ```bash
    # 停止服务
    docker compose down
    # 停止服务, 清理产生的数据
    docker compose down -v

    ```

## 自定义配置
在`.env`文件中定义了部署可以修改的一些配置

1. 自定义外部访问端口
    ```.env
    ...
    # web页面端口
    KETADB_WEB_PORT=8080
    # 集群发现端口，当需要组装多个节点时这个端口需要开放给其它机器
    KETADB_UNICAST_PORT=9300
    # keta-agent连接端口
    KETADB_TANSPORT_PORT=9400
    # SPL搜索的rpc端口
    KETADB_SEARCH_RPC_PORT=9500
    ...
    ```
2. 其它
    ```env
        
    # docker 仓库地址
    REPOSITORY=docker.io

    # docker 镜像地址
    KETADB_IMAGE_IMAGE=ketaops/ketadb
    KETA_ML_IMAGE_IMAGE=ketaops/ketadb

    # docker 镜像 tag
    KETADB_IMAGE_TAG=latest
    KETA_ML_IMAGE_TAG=latest

    # JVM OPTIONS
    JVM_OPTIONS="-Xmx2g -Xms2g"

    # MYSQL OPTIONS
    MYSQL_USER=keta
    MYSQL_DATABASE=ketadb
    MYSQL_PASSWORD=""  # 这个密码需要设置
    MYSQL_RANDOM_ROOT_PASSWORD="true"
    ```
## 其它说明
* `mysql`的配置中，默认为mysql的root用户生成了随机的密码，可使用命令`docker-compose logs  mysql |grep "GENERATED ROOT PASSWORD"`查看
* ketadb以及keta-ml的配置均通过环境变量的形式注入，各配置参数参考[参数说明](*todo: ketadb以及ketaml参数说明*)
* 当前部署方式为单机部署，仅限于测试验证使用，不推荐作为生产部署方式。生产部署请参考[k8s部署](../helm/Readme.zh.md)
* 关于镜像仓库，可参考[docker hub](https://hub.docker.com/r/ketaops/ketadb)
* 当前 keta-ml 无 arm64 的镜像，强制指定了 amd64 的系统平台，这个预期在 mac m1 芯片机器中是可以正常使用的。其它 arm 架构机器暂时无法部署 keta-ml，请自行去掉`docker-compose.yml`文件中`keta-ml`块.
