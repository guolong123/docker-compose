# Deployment Instructions
## Prerequisites

### For Linux
1. Install [docker](https://docs.docker.com/engine/install/)
2. Install [docker-compose](https://docs.docker.com/compose/install/standalone/)

### For Docker on Mac/Windows
1. Install [docker-desktop](https://www.docker.com/products/docker-desktop/)

## Limitations
1. Requires external network access (If not available, you'll need to use offline images).
2. This deployment method supports single-node deployment only (but can have multiple nodes on a single machine).

## Installation Steps
1. Place this directory (docker-compose) under the deployment directory, for example: `${PWD}/docker-compose`.
2. Perform the installation:
   
   a. Modify MySQL password
   ```bash
   cd ~/docker-compose
   # Use the `sed` command to modify the MySQL password
   # For Linux systems:
   sed -i 's/MYSQL_PASSWORD=""/MYSQL_PASSWORD="ChangeThisPassword"/g' .env

   # For Mac systems:
   sed -i '' 's/MYSQL_PASSWORD=""/MYSQL_PASSWORD="ChangeThisPassword"/g' .env
   # You can also manually edit the `.env` file to modify the MySQL password and other related configurations
   vim .env
   ```
   b. Start the installation
   ```bash
   docker-compose up -d
   ```
   c. Wait a moment and access the service. Open the following address in your web browser: http://127.0.0.1:9200

   d. Check the installation result
   ```
   docker-compose ps
   ```
   e. View service logs
   ```
   docker-compose logs -f ketadb
   ```
   f. Uninstall/clean up
   ```bash
   # Stop the services
   docker-compose down
   # Clean up generated data
   rm -rf $(source .env && echo $MYSQL_DATA_PATH)
   rm -rf $(source .env && echo $KETADB_DATA_PATH)
   ```

## Custom Configurations
In the `.env` file, you can define some configurations that can be modified during deployment.

1. Use custom storage paths:
    ```.env
    ...
    # Persistence configurations
    MYSQL_DATA_PATH=./mysql-data
    KETADB_DATA_PATH=./keta-data
    ...
    ```
2. Customize external access ports:
    ```.env
    ...
    # Web page port
    KETADB_WEB_PORT=9200
    # Cluster discovery port (this port needs to be opened for other machines when assembling multiple nodes)
    KETADB_UNICAST_PORT=9300
    # keta-agent connection port
    KETADB_TANSPORT_PORT=9400
    # SPL search RPC port
    KETADB_SEARCH_RPC_PORT=9500
    ...
    ```
3. Others:
    ```env
        
    # Docker repository address
    REPOSITORY=docker.io

    # Docker image addresses
    KETADB_IMAGE_IMAGE=ketaops/ketadb
    KETA_ML_IMAGE_IMAGE=ketaops/ketadb

    # Docker image tags
    KETADB_IMAGE_TAG=latest
    KETA_ML_IMAGE_TAG=latest

    # JVM OPTIONS
    JVM_OPTIONS="-Xmx2g -Xms2g"

    # MYSQL OPTIONS
    MYSQL_USER=keta
    MYSQL_DATABASE=ketadb
    MYSQL_PASSWORD=""  # This password needs to be set
    MYSQL_RANDOM_ROOT_PASSWORD="true"
    ```

## Other Notes
* In the `mysql` configuration, a random password is generated for the root user of MySQL. You can use the command `docker-compose logs mysql | grep "GENERATED ROOT PASSWORD"` to check it.
* Configurations for ketadb and keta-ml are injected via environment variables. Please refer to [Parameter Descriptions](*todo: ketadb and ketaml parameter descriptions*).
* The current deployment method is for single-node deployment and is only recommended for testing and validation. For production deployment, please refer to [k8s Deployment](../helm/Readme.zh.md).
* Regarding the image repository, you can refer to [Docker Hub](https://hub.docker.com/r/ketaops/ketadb).
* Currently, keta-ml does not have an arm64 image, so the AMD64 system platform is specified. This should work fine on Mac M1 chip machines. Other ARM architecture machines cannot currently deploy keta-ml. You can remove the `keta-ml` block from the `docker-compose.yml` file for those machines.
