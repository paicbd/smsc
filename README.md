## What is PAiC-BD SMSC?
PAiC BD open source SMSC supports all SMS types and goes beyond traditional text messages with its integration to multiple Social Media Messaging channels, and it also enables access to conversational and generative A.I. via a non-internet dependent SMS channel, and it will support RCS in 2025.

PAiC BD SMSC can connect with telecom operators (MNOs) via multiple protocols, including traditional SMPP and Signaling (SS7/SIGTRAN), as well as HTTP and Diameter (2025), giving it the necessary flexibility to support any use case and type of access.

**Key Points:**

- PAiC-BD SMSC is 100% open source, enabling continuous innovation and use case adaptation
- Able to process 60,000 TPS, allowing for more than 20,000 SMS per second
- No-code Service Creation Environment for faster time-to-market
- Social Media Messaging and A.I (including ChatGPT) integration

## Where to get support:

[PAiC-BD Official Support](https://paic-bd.com/smsc/ "PAiC BD Official Support")

## How to get started?

### Install pre-requisites
- [Docker engine](https://docs.docker.com/engine/install/ "Docker engine")
- [Docker compose](https://docs.docker.com/compose/install/ "Docker compose")
- [Redis](https://redis.io/docs/latest/operate/oss_and_stack/install/install-redis/ "Redis") and [Redis-cluster ](#configure-redis-cluster)
- [PostgreSQL Standalone](https://www.postgresql.org/docs/current/tutorial-install.html "PostgreSQL Standalone") or alternatively [Citus image](https://docs.citusdata.com/en/v8.1/installation/single_machine_docker.html "Citus image")

	#### Configure Redis Cluster
	Once Redis is installed, you need to configure a cluster. The following steps are an example of how this can be achieved with a script:
	##### Create a new Redis cluster directory
	`sudo mkdir -p /opt/paic/redis-cluster`
		
	##### Create sub-directories for each cluster node
	In the example below, each sub-directory is named after the respective port:
	```shell
	sudo mkdir -p /opt/paic/redis-cluster/7000
	sudo mkdir -p /opt/paic/redis-cluster/7001
	sudo mkdir -p /opt/paic/redis-cluster/7002
	sudo mkdir -p /opt/paic/redis-cluster/7003
	sudo mkdir -p /opt/paic/redis-cluster/7004
	sudo mkdir -p /opt/paic/redis-cluster/7005
	sudo mkdir -p /opt/paic/redis-cluster/7006
	sudo mkdir -p /opt/paic/redis-cluster/7007
	sudo mkdir -p /opt/paic/redis-cluster/7008
	sudo mkdir -p /opt/paic/redis-cluster/7009
	```
	##### Create a Redis configuration file for each node
	Below is an example for one of the nodes. You need to change the ports accordingly:

	`sudo vim /opt/paic/smsc/redis-cluster/7000/redis.conf`

	```shell
	port 7000
	cluster-enabled yes
	cluster-config-file nodes.conf
	cluster-node-timeout 5000
	appendonly yes
	protected-mode no
	
	save 900 1
	save 300 10
	save 60 10000
	
	loglevel warning
	logfile "redis-server.log"
	```

	##### Create a script to start the cluster: 
	`sudo vim /opt/paic/smsc/redis-cluster/start-cluster.sh`

	```shell
	cd /opt/paic/redis-cluster/7000
	rm -rf appendonlydir  dump.rdb  nodes.conf
	redis-server ./redis.conf --daemonize yes
	
	cd /opt/paic/redis-cluster/7001
	rm -rf appendonlydir  dump.rdb  nodes.conf
	redis-server ./redis.conf --daemonize yes
	
	cd /opt/paic/redis-cluster/7002
	rm -rf appendonlydir  dump.rdb  nodes.conf
	redis-server ./redis.conf --daemonize yes
	
	cd /opt/paic/redis-cluster/7003
	rm -rf appendonlydir  dump.rdb  nodes.conf
	redis-server ./redis.conf --daemonize yes
	
	cd /opt/paic/redis-cluster/7004
	rm -rf appendonlydir  dump.rdb  nodes.conf
	redis-server ./redis.conf --daemonize yes
	
	cd /opt/paic/redis-cluster/7005
	rm -rf appendonlydir  dump.rdb  nodes.conf
	redis-server ./redis.conf --daemonize yes
	
	cd /opt/paic/redis-cluster/7006
	rm -rf appendonlydir  dump.rdb  nodes.conf
	redis-server ./redis.conf --daemonize yes

	cd /opt/paic/redis-cluster/7007
	rm -rf appendonlydir  dump.rdb  nodes.conf
	redis-server ./redis.conf --daemonize yes
	
	cd /opt/paic/redis-cluster/7008
	rm -rf appendonlydir  dump.rdb  nodes.conf
	redis-server ./redis.conf --daemonize yes
	
	cd /opt/paic/redis-cluster/7009
	rm -rf appendonlydir  dump.rdb  nodes.conf
	redis-server ./redis.conf --daemonize yes
	
	redis-cli --cluster create 127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 127.0.0.1:7006 127.0.0.1:7007 127.0.0.1:7008 127.0.0.1:7009 --cluster-replicas 1
	```
	##### Create a script to clean the Redis data:
	`sudo vim /opt/paic/smsc/redis-cluster/clean-data.sh`
	```shell
	redis-cli -p 7000 FLUSHDB
	redis-cli -p 7001 FLUSHDB
	redis-cli -p 7002 FLUSHDB
	redis-cli -p 7003 FLUSHDB
	redis-cli -p 7004 FLUSHDB
	redis-cli -p 7005 FLUSHDB
	redis-cli -p 7006 FLUSHDB
	redis-cli -p 7007 FLUSHDB
	redis-cli -p 7008 FLUSHDB
	redis-cli -p 7009 FLUSHDB
	```
	##### Provide permissions to the scripts:
	`sudo chmod 755 /opt/paic/redis-cluster/*sh`
	##### Start the cluster and check status:
	```shell
	cd /opt/paic/redis-cluster
	sudo ./start-cluster.sh
	ps -fea | grep redis
	```
	
### Docker deployment

Our SMSC is designed with a modular architecture, allowing you to deploy each module (SMPP, SS7, HTTP, etc.) individually using separate Docker Compose files. This modular approach gives you the flexibility to scale and customize your deployment based on your specific needs. You may combine any modules into a single Docker Compose file for a more integrated setup. 

The following images are published in docker hub for each module:

- [paicbusinessdev/smsc-routing-module](https://hub.docker.com/r/paicbusinessdev/smsc-routing-module/tags)
- [paicbusinessdev/orchestrator-module](https://hub.docker.com/r/paicbusinessdev/orchestrator-module/tags)
- [paicbusinessdev/retries-module](https://hub.docker.com/r/paicbusinessdev/retries-module/tags)
- [paicbusinessdev/db-insert-data](https://hub.docker.com/r/paicbusinessdev/db-insert-data/tags)
- [paicbusinessdev/smpp-server-module](https://hub.docker.com/r/paicbusinessdev/smpp-server-module/tags)
- [paicbusinessdev/smpp-client-module](https://hub.docker.com/r/paicbusinessdev/smpp-client-module/tags)
- [paicbusinessdev/http-server-module](https://hub.docker.com/r/paicbusinessdev/http-server-module/tags)
- [paicbusinessdev/http-client-module](https://hub.docker.com/r/paicbusinessdev/http-client-module/tags)
- [paicbusinessdev/ss7-module](https://hub.docker.com/r/paicbusinessdev/ss7-module/tags)
- [paicbusinessdev/smsc-management-be](https://hub.docker.com/r/paicbusinessdev/smsc-management-be/tags)
- [paicbusinessdev/smsc-management-fe](https://hub.docker.com/r/paicbusinessdev/smsc-management-fe/tags)

An example of a single Docker Compose file for all modules is shown below: 

```yaml
version: '3.8'
services:
  smsc-management-be:
    image: paicbusinessdev/smsc-management-be:latest
    ulimits:
      nofile:
        soft: 1000000
        hard: 1000000
    container_name: smsc-management-be
    healthcheck:
      test: ["CMD-SHELL", "nc -z localhost 8080"]
      interval: 10s
      timeout: 5s
      retries: 10
    environment:
      JVM_XMS: "-Xms4g"  # Default value for -Xms
      JVM_XMX: "-Xmx4g" # Default value for -Xmx
      SERVER_PORT: 8080
      APPLICATION_NAME: "smsc-management-be"
      CLUSTER_NODES: "localhost:7000,localhost:7001,localhost:7002,localhost:7003,localhost:7004,localhost:7005,localhost:7006,localhost:7007,localhost:7008,localhost:7009"
      THREAD_POOL_MAX_TOTAL: 20
      THREAD_POOL_MIN_IDLE: 5
      THREAD_POOL_MAX_IDLE: 10
      THREAD_POOL_BLOCK_WHEN_EXHAUSTED: true
      KEY_GATEWAYS: "gateways"
      KEY_SERVICE_PROVIDERS: "service_providers"
      KEY_ERROR_CODE_MAPPING: "error_code_mapping"
      KEY_SS7_GATEWAYS_HASH: "ss7_gateways"
      KEY_SS7_SETTINGS_HASH: "ss7_settings"
      KEY_ROUTING_RULES: "routing_rules"
      SMPP_SERVER_CONFIGURATION_HASH_NAME: "configurations"
      SMPP_SERVER_KEY_NAME: "smpp_server"
      SMPP_SERVER_VALUE: '{"state":"STARTED"}'
      SERVER_BALANCE_HANDLER_HASH_NAME: "sp_balance_handler"
      SERVER_BALANCE_PERIOD_STORE: 10
      SERVER_API_KEY_HEADER_NAME: "X-API-Key"
      SERVER_API_KEY_VALUE: "Cn62uZGdSUeGqmtVnHmI7iaji3C74bRd"
      GENERAL_SETTINGS: "general_settings"
      GENERAL_SETTINGS_KEY_SMPP_HTTP: "smpp_http"
      GENERAL_SETTINGS_KEY_SMSC_RETRY: "smsc_retry"
      GENERAL_SETTINGS_KEY_DIAMETER_CONFIG: "diameter_config"
      SPRING_DATASOURCE_URL: "jdbc:postgresql://localhost:5432/smsc_management"
      SPRING_DATASOURCE_USERNAME: "postgres"
      SPRING_DATASOURCE_PASSWORD: "1234"
      SPRING_DATASOURCE_DRIVER_CLASS_NAME: "org.postgresql.Driver"
      SPRING_JPA_HIBERNATE_DDL_AUTO: "update"
      SPRING_JPA_SHOW_SQL: "false"
      SPRING_JPA_PROPERTIES_HIBERNATE_FORMAT_SQL: "true"
      SPRING_JPA_PROPERTIES_DATABASE: "postgresql"
      SPRING_JPA_PROPERTIES_DATABASE_PLATFORM: "org.hibernate.dialect.PostgreSQLDialect"
      SPRING_JPA_PROPERTIES_HIBERNATE_JDBC_TIME_ZONE: "America/Managua"
      APP_SECURITY_JWT_SECRET_KEY: "404E635266556A586E3272357538782F413F4428472B4B6250645367566B5970"
      APP_SECURITY_JWT_EXPIRATION: "86400"
      APP_ROOT_USER_USERNAME: "admin"
      APP_ROOT_PASSWORD: "admin"
      WEBSOCKET_HEADER_NAME: "Authorization"
      WEBSOCKET_HEADER_VALUE: "fcb13146-ecd7-46a5-b9cb-a1e75fae9bdc"
      CORS_ALLOWED_ORIGINS: "*"
      # JMX Configuration
      ENABLE_JMX: "true"
      IP_JMX: "{host_ip}"
      JMX_PORT: "9018"
    volumes:
      - /opt/paic/smsc/docker/conf/logs/backend/logback.xml:/opt/paic/SMSC_MANAGEMENT_BACKEND/conf/logback.xml
      - /var/log/paic/smsc/backend:/opt/paic/SMSC_MANAGEMENT_BACKEND/logs
    network_mode: host

  smsc-management-fe:
    image: paicbusinessdev/smsc-management-fe:latest
    container_name: smsc-management-fe
    depends_on:
      smsc-management-be:
        condition: service_healthy
    environment:
        BACKEND_IP: {host_ip}:8080
        NG_APP_PATTERN_SYSTEM_ID: ^[^\,\'\"\}\{\]\[\)\(\\]+$
        NG_APP_PATTERN_SYSTEM_LABEL: ",'}{][)(\"\\"
    ports:
      - "80:80"

  smpp-client-module:
    image: paicbusinessdev/smpp-client-module:latest
    ulimits:
      nofile:
        soft: 1000000
        hard: 1000000
    container_name: smpp-client
    depends_on:
      smsc-management-be:
        condition: service_healthy
    environment:
      JVM_XMS: "-Xms4g"
      JVM_XMX: "-Xms4g"
      SERVER_PORT: 9595
      APPLICATION_NAME: "smpp-client-module"
      #RedisCluster
      CLUSTER_NODES: "localhost:7000,localhost:7001,localhost:7002,localhost:7003,localhost:7004,localhost:7005,localhost:7006,localhost:7007,localhost:7008,localhost:7009"
      THREAD_POOL_MAX_TOTAL: 60
      THREAD_POOL_MAX_IDLE: 50
      THREAD_POOL_MIN_IDLE: 10
      THREAD_POOL_BLOCK_WHEN_EXHAUSTED: true
      #SMPPConnectionConfiguration
      KEY_GATEWAYS: "gateways"
      KEY_SERVICE_PROVIDERS: "service_providers"
      KEY_ERROR_CODE_MAPPING: "error_code_mapping"
      KEY_ROUTING_RULES: "routing_rules"
      CONNECTION_PROCESSOR_DEGREE: 150
      CONNECTION_QUEUE_CAPACITY: 50000
      CONNECTION_TRANSACTION_TIMER: 5000
      CONNECTION_TIME_RETRY: 5000
      #PreDeliver
      SUBMIT_PRE_DELIVER: "preDeliver"
      SUBMIT_PRE_MESSAGE: "preMessage"
      SUBMIT_SM_RESULTS: "submit_sm_result"
      #Redis Retry Messages
      RETRY_MESSAGES_QUEUE: "sms_retry"
      #WorkersPerGateway
      WORKS_PER_GATEWAY: 10
      WORK_FOR_WORKER: 1000
      GATEWAYS_WORK_EXECUTE_EVERY: 1000
      #Websocket
      WEBSOCKET_SERVER_ENABLED: true
      WEBSOCKET_SERVER_HOST: "localhost"
      WEBSOCKET_SERVER_PORT: 8080
      WEBSOCKET_SERVER_PATH: "/ws"
      #time in seconds
      WEBSOCKET_SERVER_RETRY_INTERVAL: 10
      WEBSOCKET_HEADER_NAME: "Authorization"
      WEBSOCKET_HEADER_VALUE: "fcb13146-ecd7-46a5-b9cb-a1e75fae9bdc"
      #VirtualThread
      THREADS_VIRTUAL_ENABLED: true
      # JMX Configuration
      ENABLE_JMX: "true"
      IP_JMX: "{host_ip}"
      JMX_PORT: "9014"
    volumes:
      - /opt/paic/smsc/docker/conf/logs/smpp-client/logback.xml:/opt/paic/SMPP_CLIENT_MODULE/conf/logback.xml
      - /var/log/paic/smsc/smpp-client:/opt/paic/SMPP_CLIENT_MODULE/logs
    network_mode: host


  smpp-server-module:
    image: paicbusinessdev/smpp-server-module:latest
    ulimits:
      nofile:
        soft: 1000000
        hard: 1000000
    container_name: smpp-server
    depends_on:
      smsc-management-be:
        condition: service_healthy
    environment:
      JVM_XMS: "-Xms4g"
      JVM_XMX: "-Xms4g"
      APPLICATION_NAME: "smpp-server-instance-01"
      SERVER_IP: "{host_ip}"
      SERVER_PORT: "9988"
      INITIAL_STATUS: "STARTED"
      PROTOCOL: "SMPP"
      SCHEME: ""
      RATING_REQUEST_API_KEY: "fe34b3ce-877e-4c61-a846-033320a9951f"
      # Redis Cluster and queues
      CLUSTER_NODES: "localhost:7000,localhost:7001,localhost:7002,localhost:7003,localhost:7004,localhost:7005,localhost:7006,localhost:7007,localhost:7008,localhost:7009"
      #SUBMIT_SM_QUEUES: "message,submit_sm_db"
      THREAD_POOL_MAX_TOTAL: 60
      THREAD_POOL_MAX_IDLE: 50
      THREAD_POOL_MIN_IDLE: 10
      THREAD_POOL_BLOCK_WHEN_EXHAUSTED: true
      DELIVER_SM_QUEUE: "smpp_dlr"
      CONSUMER_WORKERS: 11
      CONSUMER_BATCH_SIZE: 10000
      CONSUMER_SCHEDULER: 1000
      # SMPP server configurations
      SMPP_SERVER_IP: "{host_ip}"
      SMPP_SERVER_PORT: 2776
      SMPP_SERVER_TRANSACTION_TIMER: 5000
      SMPP_SERVER_WAIT_FOR_BIND: 5000
      SMPP_SERVER_PROCESSOR_DEGREE: 15
      SMPP_SERVER_QUEUE_CAPACITY: 1000
      # Services Providers Configurations
      SERVICE_PROVIDERS_HASH_NAME: "service_providers"
      # WebSocket server configurations
      WEBSOCKET_SERVER_ENABLED: true
      WEBSOCKET_SERVER_HOST: "localhost"
      WEBSOCKET_SERVER_PORT: 8080
      WEBSOCKET_SERVER_PATH: "/ws"
      #time in seconds
      WEBSOCKET_SERVER_RETRY_INTERVAL: 10
      WEBSOCKET_HEADER_NAME: "Authorization"
      WEBSOCKET_HEADER_VALUE: "fcb13146-ecd7-46a5-b9cb-a1e75fae9bdc"
      # Configuration for SmppServer
      SMPP_SERVER_CONFIGURATIONS_HASH_NAME: "configurations"
      SMPP_SERVER_KEY_NAME: "smpp_server"
      SMPP_SERVER_GENERAL_SETTINGS_HASH: "general_settings"
      SMPP_SERVER_GENERAL_SETTINGS_KEY: "smpp_http"
      # Management
      ENDPOINTS_WEB_EXPOSURE_INCLUDE: "loggers"
      ENDPOINT_LOGGERS_ENABLED: true
      # Configuration for the virtual threads
      THREADS_VIRTUAL_ENABLED: true
      #Process message
      REDIS_PRE_MESSAGE_LIST: "preMessage"
      # JMX Configuration
      ENABLE_JMX: "true"
      IP_JMX: "{host_ip}"
      JMX_PORT: "9013"
    volumes:
      - /opt/paic/smsc/docker/conf/logs/smpp-server/logback.xml:/opt/paic/SMPP_SERVER_MODULE/conf/logback.xml
      - /var/log/paic/smsc/smpp-server:/opt/paic/SMPP_SERVER_MODULE/logs
    network_mode: host

  http-client-module:
    image: paicbusinessdev/http-client-module:latest
    ulimits:
      nofile:
        soft: 1000000
        hard: 1000000
    container_name: http-client
    depends_on:
      smsc-management-be:
        condition: service_healthy
    environment:
      JVM_XMS: "-Xms1g"
      JVM_XMX: "-Xms1g"
      SERVER_PORT: 8000
      APPLICATION_NAME: "http-client-module"
      # RedisCluster
      CLUSTER_NODES: "localhost:7000,localhost:7001,localhost:7002,localhost:7003,localhost:7004,localhost:7005,localhost:7006,localhost:7007,localhost:7008,localhost:7009"
      THREAD_POOL_MAX_TOTAL: 60
      THREAD_POOL_MAX_IDLE: 50
      THREAD_POOL_MIN_IDLE: 10
      THREAD_POOL_BLOCK_WHEN_EXHAUSTED: true
      # SMPPConnectionConfiguration
      KEY_GATEWAYS: "gateways"
      KEY_SERVICE_PROVIDERS: "service_providers"
      KEY_ERROR_CODE_MAPPING: "error_code_mapping"
      KEY_ROUTING_RULES: "routing_rules"
      # SubmitSmQueueConsumer
      SUBMIT_SM_RESULTS: "http_submit_sm_result"
      # Websocket
      WEBSOCKET_SERVER_ENABLED: true
      WEBSOCKET_SERVER_HOST: "localhost"
      WEBSOCKET_SERVER_PORT: 8080
      WEBSOCKET_SERVER_PATH: "/ws"
      WEBSOCKET_SERVER_RETRY_INTERVAL: 10000
      WEBSOCKET_HEADER_NAME: "Authorization"
      WEBSOCKET_HEADER_VALUE: "fcb13146-ecd7-46a5-b9cb-a1e75fae9bdc"
      # HTTP2
      APPLICATION_USE_HTTP2: true
      # VirtualThread
      THREADS_VIRTUAL_ENABLED: true
      # DLRs
      PRE_DELIVER_LIST: "preDeliver"
      #WorkersPerGateway
      WORKS_PER_GATEWAY: 10
      RECORDS_PER_GATEWAY: 10000
      JOB_EXECUTE_EVERY: 1000
      #Redis Retry Messages
      RETRY_MESSAGES_QUEUE: "sms_retry"
      # JMX Configuration
      ENABLE_JMX: "true"
      IP_JMX: "{host_ip}"
      JMX_PORT: "9011"
    volumes:
      - /opt/paic/smsc/docker/conf/logs/http-client/logback.xml:/opt/paic/HTTP_CLIENT_MODULE/conf/logback.xml
      - /var/log/paic/smsc/http-client:/opt/paic/HTTP_CLIENT_MODULE/logs
    network_mode: host

  http-server-module:
    image: paicbusinessdev/http-server-module:latest
    container_name: http-server
    ulimits:
      nofile:
        soft: 1000000
        hard: 1000000
    depends_on:
      smsc-management-be:
        condition: service_healthy
    environment:
      JVM_XMS: "-Xms1g"
      JVM_XMX: "-Xms1g"
      APPLICATION_NAME: "http-server-instance-01"
      SERVER_IP: "{host_ip}"
      SERVER_PORT: 9500
      INITIAL_STATUS: "STARTED"
      # Protocol, for every http-instance must be HTTP
      PROTOCOL: "HTTP"
      SCHEMA: "http"
      RATING_REQUEST_API_KEY: "fe34b3ce-877e-4c61-a846-033320a9951f"
      # Configuration for Redis Cluster - Jedis
      CLUSTER_NODES: "localhost:7000,localhost:7001,localhost:7002,localhost:7003,localhost:7004,localhost:7005,localhost:7006,localhost:7007,localhost:7008,localhost:7009"
      THREAD_POOL_MAX_TOTAL: 60
      THREAD_POOL_MAX_IDLE: 50
      THREAD_POOL_MIN_IDLE: 10
      THREAD_POOL_BLOCK_WHEN_EXHAUSTED: true
      # name of the list in redis where the delivery_sm will be stored.
      DELIVER_SM_QUEUE: "http_dlr"
      CONSUMER_WORKERS: 11
      CONSUMER_BATCH_SIZE: 10000
      CONSUMER_SCHEDULER: 1000
      # WebSocket server configurations
      WEBSOCKET_SERVER_ENABLED: true
      WEBSOCKET_SERVER_HOST: "localhost"
      WEBSOCKET_SERVER_PORT: 8080
      WEBSOCKET_SERVER_PATH: "/ws"
      WEBSOCKET_SERVER_RETRY_INTERVAL: 10000
      WEBSOCKET_HEADER_NAME: "Authorization"
      WEBSOCKET_HEADER_VALUE: "fcb13146-ecd7-46a5-b9cb-a1e75fae9bdc"
      # Hash table in redis to manage the service provider.
      SERVICE_PROVIDERS_HASH_NAME: "service_providers"
      # Configuration for SmppServer
      SMPP_SERVER_CONFIGURATIONS_HASH_NAME: "configurations"
      HTTP_SERVER_GENERAL_SETTINGS_HASH: "general_settings"
      HTTP_SERVER_GENERAL_SETTINGS_KEY: "smpp_http"
      # Management endpoints
      ENDPOINTS_WEB_EXPOSURE_INCLUDE: "loggers"
      ENDPOINT_LOGGERS_ENABLED: true
      # pre deliver
      PRE_MESSAGE_LIST: "preMessage"
      # JMX Configuration
      ENABLE_JMX: "true"
      IP_JMX: "{host_ip}"
      JMX_PORT: "9012"
    volumes:
      - /opt/paic/smsc/docker/conf/logs/http-server/logback.xml:/opt/paic/HTTP_SERVER_MODULE/conf/logback.xml
      - /var/log/paic/smsc/http-server:/opt/paic/HTTP_SERVER_MODULE/logs
    network_mode: host

  ss7-client-module:
    image: paicbusinessdev/ss7-module:latest
    ulimits:
      nofile:
        soft: 1000000
        hard: 1000000
    container_name: ss7
    depends_on:
      smsc-management-be:
        condition: service_healthy
    environment:
      JVM_XMS: "-Xms1g"
      JVM_XMX: "-Xms1g"
      APPLICATION_NAME: "ss7-client-instance-01"
      SERVER_PORT: "9999"
      # Redis
      CLUSTER_NODES: "localhost:7000,localhost:7001,localhost:7002,localhost:7003,localhost:7004,localhost:7005,localhost:7006,localhost:7007,localhost:7008,localhost:7009"
      THREAD_POOL_MAX_TOTALS: 60
      THREAD_POOL_MAX_IDLE: 50
      THREAD_POOL_MIN_IDLE: 10
      THREAD_POOL_BLOCK_WHEN_EXHAUSTED: true
      # SS7 Connection Configuration
      SS7_KEY_GATEWAYS: ss7_gateways
      SS7_KEY_ERROR_CODE_MAPPING: error_code_mapping
      # MessageConsumer
      SS7_WORKER_PER_GATEWAY: 10
      SS7_WORK_FOR_WORKER: 1000
      SS7_GATEWAY_WORK_EXECUTE: 1000
      SS7_TPS_PER_GW: 10000
      # Websocket
      WEBSOCKET_SERVER_ENABLED: true
      WEBSOCKET_SERVER_HOST: "localhost"
      WEBSOCKET_SERVER_PORT: 8080
      WEBSOCKET_SERVER_PATH: "/ws"
      WEBSOCKET_SERVER_RETRY_INTERVAL: 10
      WEBSOCKET_HEADER_NAME: "Authorization"
      WEBSOCKET_HEADER_VALUE: "fcb13146-ecd7-46a5-b9cb-a1e75fae9bdc"
      # Config
      SS7_CONFIG_DIRECTORY: "/opt/paic/ss7_module/conf/"
      THREADS_VIRTUAL_ENABLED: true
      # Redis List
      PRE_MESSAGE_LIST: "preMessage"
      RETRY_MESSAGES_QUEUE: "sms_retry"
      # JMX Configuration
      ENABLE_JMX: "true"
      IP_JMX: "{host_ip}"
      JMX_PORT: "9010"
    volumes:
      - /opt/paic/smsc/docker/conf/logs/ss7/logback.xml:/opt/paic/SS7_MODULE/conf/logback.xml
      - /opt/paic/smsc/docker/conf/logs/ss7/log4j.xml:/opt/paic/SS7_MODULE/conf/log4j.xml
      - /var/log/paic/smsc/ss7:/opt/paic/SS7_MODULE/logs
      - /var/log/paic/smsc/ss7/debug:/opt/paic/SS7_MODULE/bin/logs/ls
    network_mode: host

  retries-module:
    image: paicbusinessdev/retries-module:latest
    ulimits:
      nofile:
        soft: 1000000
        hard: 1000000
    container_name: retries
    depends_on:
      smsc-management-be:
        condition: service_healthy
    environment:
      JVM_XMS: "-Xms1g"
      JVM_XMX: "-Xms1g"
      SERVER_PORT: 9898
      APPLICATION_NAME: "module"
      # About Redis
      CLUSTER_NODES: "localhost:7000,localhost:7001,localhost:7002,localhost:7003,localhost:7004,localhost:7005,localhost:7006,localhost:7007,localhost:7008,localhost:7009"
      THREAD_POOL_MAX_TOTAL: 20
      THREAD_POOL_MAX_IDLE: 20
      THREAD_POOL_MIN_IDLE: 1
      THREAD_POOL_BLOCK_WHEN_EXHAUSTED: true
      # Websocket
      WEBSOCKET_SERVER_ENABLED: true
      WEBSOCKET_SERVER_HOST: "localhost"
      WEBSOCKET_SERVER_PORT: 8080
      WEBSOCKET_SERVER_PATH: "/ws"
      WEBSOCKET_SERVER_RETRY_INTERVAL: 10
      WEBSOCKET_HEADER_NAME: "Authorization"
      WEBSOCKET_HEADER_VALUE: "fcb13146-ecd7-46a5-b9cb-a1e75fae9bdc"
      # About Processors
      RETRY_MESSAGES_QUEUE: "sms_retry"
      RETRY_INTERVAL: 1000
      PROCESSOR_INTERVAL: 1000
      # Lists Name
      SMPP_QUEUE_NAME: "smpp_message"
      HTTP_QUEUE_NAME: "http_message"
      SS7_QUEUE_NAME: "ss7_message"
      DIAMETER_QUEUE_NAME: "diameter_message"
      # For SS7 Validations
      SS7_HASH_TABLE_RETRY: "msisdn_absent_subscriber"
      # JMX Configuration
      ENABLE_JMX: "true"
      IP_JMX: "{host_ip}"
      JMX_PORT: "9017"
    volumes:
      - /opt/paic/smsc/docker/conf/logs/retries/logback.xml:/opt/paic/SMSC_RETRIES_MODULE/conf/logback.xml
      - /var/log/paic/smsc/retries:/opt/paic/SMSC_RETRIES_MODULE/logs
    network_mode: host

  orchestrator-module:
    image: paicbusinessdev/orchestrator-module:latest
    ulimits:
      nofile:
        soft: 1000000
        hard: 1000000
    container_name: orchestrator
    depends_on:
      smsc-management-be:
        condition: service_healthy
    environment:
      JVM_XMS: "-Xms4g"
      JVM_XMX: "-Xms4g"
      SERVER_PORT: 9080
      APPLICATION_NAME: "smsc-orchestrator"
      # About SMPP SubmitSm
      SMPP_SUBMIT_SM_QUEUE: "smpp_message"
      SMPP_SUBMIT_SM_CONSUMER_WORKERS: 10
      SMPP_SUBMIT_SM_CONSUMER_BATCH_SIZE: 5000
      SMPP_SUBMIT_SM_CONSUMER_SCHEDULER: 1000
      # About HTTP SubmitSm
      HTTP_SUBMIT_SM_QUEUE: "http_message"
      HTTP_SUBMIT_SM_CONSUMER_WORKERS: 10
      HTTP_SUBMIT_SM_CONSUMER_BATCH_SIZE: 5000
      HTTP_SUBMIT_SM_CONSUMER_SCHEDULER: 1000
      # About SS7 SubmitSm
      SS7_SUBMIT_SM_QUEUE: "ss7_message"
      SS7_SUBMIT_SM_CONSUMER_WORKERS: 10
      SS7_SUBMIT_SM_CONSUMER_BATCH_SIZE: 5000
      SS7_SUBMIT_SM_CONSUMER_SCHEDULER: 1000
      # Global DLRs Queue
      DELIVER_SM_SMPP_QUEUE: "smpp_dlr"
      DELIVER_SM_HTTP_QUEUE: "http_dlr"
      # About DeliverySmSmpp
      SMPP_DELIVERY_SM_QUEUE: "deliver_sm_pre_process"
      SMPP_DELIVERY_SM_CONSUMER_WORKERS: 10
      SMPP_DELIVERY_SM_CONSUMER_BATCH_SIZE: 5000
      SMPP_DELIVERY_SM_CONSUMER_SCHEDULER: 1000
      SMPP_DELIVERY_SM_RETRY_LIST: "smpp_dlr_retry_list"
      SMPP_DELIVERY_SM_RETRY_EVERY: 300000
      # About DeliverySmHttp
      HTTP_DELIVERY_SM_QUEUE: "http_dlr_request"
      HTTP_DELIVERY_SM_CONSUMER_WORKERS: 10
      HTTP_DELIVERY_SM_CONSUMER_BATCH_SIZE: 5000
      HTTP_DELIVERY_SM_CONSUMER_SCHEDULER: 1000
      HTTP_DELIVERY_SM_RETRY_LIST: "http_dlr_retry_list"
      HTTP_DELIVERY_SM_RETRY_EVERY: 300000
      # About Redis
      CLUSTER_NODES: "localhost:7000,localhost:7001,localhost:7002,localhost:7003,localhost:7004,localhost:7005,localhost:7006,localhost:7007,localhost:7008,localhost:7009"
      THREAD_POOL_MAX_TOTAL: 20
      THREAD_POOL_MAX_IDLE: 20
      THREAD_POOL_MIN_IDLE: 1
      THREAD_POOL_BLOCK_WHEN_EXHAUSTED: true
      # JMX Configuration
      ENABLE_JMX: "true"
      IP_JMX: "{host_ip}"
      JMX_PORT: "9016"
    volumes:
      - /opt/paic/smsc/docker/conf/logs/orchestrator/logback.xml:/opt/paic/ORCHESTRATOR_MODULE/conf/logback.xml
      - /var/log/paic/smsc/orchestrator:/opt/paic/ORCHESTRATOR_MODULE/logs
    network_mode: host

  smsc-routing-module:
    image: paicbusinessdev/smsc-routing-module:latest
    ulimits:
      nofile:
        soft: 1000000
        hard: 1000000
    container_name: routing
    depends_on:
      smsc-management-be:
        condition: service_healthy
    environment:
      JVM_XMS: "-Xms4g"
      JVM_XMX: "-Xms4g"
      SERVER_PORT: 8989
      APPLICATION_NAME: "routing"
      APPLICATION_ADDRESS: "localhost"
      #RedisCluster
      CLUSTER_NODES: "localhost:7000,localhost:7001,localhost:7002,localhost:7003,localhost:7004,localhost:7005,localhost:7006,localhost:7007,localhost:7008,localhost:7009"
      THREAD_POOL_MAX_TOTAL: 60
      THREAD_POOL_MAX_IDLE: 50
      THREAD_POOL_MIN_IDLE: 10
      THREAD_POOL_BLOCK_WHEN_EXHAUSTED: true
      # Process
      REDIS_PRE_MESSAGE_LIST: "preMessage"
      REDIS_PRE_MESSAGE_ITEMS_TO_PROCESS: 1000
      REDIS_PRE_MESSAGE_WORKERS: 10
      REDIS_PRE_DELIVERY_LIST: "preDeliver"
      REDIS_PRE_DELIVERY_ITEMS_TO_PROCESS: 1000
      REDIS_PRE_DELIVERY_WORKERS: 10
      # Lists
      REDIS_SMPP_MESSAGE_LIST: "smpp_message"
      REDIS_HTTP_MESSAGE_LIST: "http_message"
      REDIS_SS7_MESSAGE_LIST: "ss7_message"
      REDIS_SMPP_RESULT: "submit_sm_result"
      REDIS_HTTP_RESULT: "http_submit_sm_result"
      REDIS_SMPP_DLR_LIST: "smpp_dlr"
      REDIS_HTTP_DLR_LIST: "http_dlr"
      # Routing
      APP_ROUTING_RULE_HASH: "routing_rules"
      APP_GENERAL_SETTINGS_HASH: "general_settings"
      APP_SS7_SETTINGS_HASH: "ss7_settings"
      APP_SMPP_HTTP_GSKEY: "smpp_http"
      APP_GATEWAYS: "gateways"
      APP_SERVICE_PROVIDERS: "service_providers"
      # DLR Retries
      SMPP_REDIS_DELIVER_SM_RETRY_LIST: "smpp_dlr_retry_list"
      HTTP_REDIS_DELIVER_SM_RETRY_LIST: "http_dlr_retry_list"
      # Websocket
      WEBSOCKET_SERVER_HOST: "localhost"
      WEBSOCKET_SERVER_PORT: 8080
      WEBSOCKET_SERVER_PATH: "/ws"
      WEBSOCKE_SERVER_RETRY_INTERVAL: 10
      WEBSOCKET_HEADER_NAME: "Authorization"
      WEBSOCKET_HEADER_VALUE: "fcb13146-ecd7-46a5-b9cb-a1e75fae9bdc"
      # Threads
      THREADS_VIRTUAL_ENABLED: true
      # Related to the requests to the backend for notify the rating per service provider per second, the url must end with '/'
      BACKEND_URL: "http://localhost:9000/balance-credit/credit-used/"
      BACKEND_API_KEY: "Cn62uZGdSUeGqmtVnHmI7iaji3C74bRd"
      BACKEND_REQUEST_FREQUENCY: 1000
      # JMX Configuration
      ENABLE_JMX: "true"
      IP_JMX: "{host_ip}"
      JMX_PORT: "9015"
    volumes:
      - /opt/paic/smsc/docker/conf/license/license_paic.txt:/opt/paic/SMSC_ROUTING_MODULE/bin/license/license_paic.txt
      - /opt/paic/smsc/docker/conf/logs/routing/logback.xml:/opt/paic/SMSC_ROUTING_MODULE/conf/logback.xml
      - /var/log/paic/smsc/routing:/opt/paic/SMSC_ROUTING_MODULE/logs
    network_mode: host

  db-insert-data:
    image: paicbusinessdev/db-insert-data:latest
    ulimits:
      nofile:
        soft: 1000000
        hard: 1000000
    depends_on:
      smsc-management-be:
        condition: service_healthy
    environment:
      JVM_XMS: "-Xms4g"
      JVM_XMX: "-Xms4g"
      SERVER_PORT: 8090
      APPLICATION_NAME: "db-insert-data-app"
      DATA_SOURCE_URL: "jdbc:postgresql://localhost:5432/db_insert_data"
      DATA_SOURCE_USER_NAME: "postgres"
      DATA_SOURCE_PASSWORD: 1234
      DATA_SOURCE_DRIVER_CLASS_NAME: "org.postgresql.Driver"
      DATA_SOURCE_HIKARI_PROPERTIES: true
      # List of nodes
      CLUSTER_NODES: "localhost:7000,localhost:7001,localhost:7002,localhost:7003,localhost:7004,localhost:7005,localhost:7006,localhost:7007,localhost:7008,localhost:7009"
      THREAD_POOL_MAX_TOTAL: 20
      THREAD_POOL_MIN_IDLE: 5
      THREAD_POOL_MAX_IDLE: 10
      THREAD_POOL_BLOCK_WHEN_EXHAUSTED: true
      # Lists Names
      CONFIGURATION_CDR: "cdr"
      # Workers for each list is the number of threads that will be created to take records from Redis
      # for example, if submit-workers=5 and submit-batch-size=25000, then every worker will take 25000 records, total 125000 records
      CONFIGURATION_CDR_WORKERS: 5
      # Batch size for each list of workers
      # quantity of records that will be taken from Redis and inserted into the database every schedule
      CONFIGURATION_CDR_BATCH_SIZE: 15000
      # Take records from Redis
      # defines the quantity of records that will be taken from Redis
      CONFIGURATION_CDR_RECORDS_TAKE: 1000000
      CONFIGURATION_INTERNAL_MILLIS: 1000
      # JDBC max retries
      JDBC_MAX_RETRIES: 5
      # Flyway is used to create the tables in the database the first time the application is executed
      FLYWAY_ENABLED: true
      FLYWAY_TABLE: "_flyway_history"
      FLYWAY_CLEAN_DISABLED: false
      FLYWAY_BASELINE_ON_MIGRATE: true
      FLYWAY_CLEAN_ON_VALIDATE_ERROR: true
      # Threads
      THREADS_VIRTUAL_ENABLED: true
      # Mode -> logs/database/kafka default is logs
      APPLICATION_MODE: "logs"
      APPLICATION_CDR_SEPARATOR: "|"
      APPLICATION_CDR_LOCATION: "/var/log/paic/smsc/cdrs"
      # JMX Configuration
      ENABLE_JMX: "true"
      IP_JMX: "{host_ip}"
      JMX_PORT: "9019"
    volumes:
      - /opt/paic/smsc/docker/conf/logs/db-insert-data/logback.xml:/opt/paic/DB_INSERT_DATA/conf/logback.xml
      - /var/log/paic/smsc/db-insert-data:/var/log/paic/smsc
    network_mode: host
```


##### 	Volumes
As shown in the Docker compose file above, volumes can be defined to use files for logging properties or start up scripts.

##### Logging

This is optional and you may use the following as a template for this file.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <conversionRule conversionWord="clr" converterClass="org.springframework.boot.logging.logback.ColorConverter" />
    <conversionRule conversionWord="wex" converterClass="org.springframework.boot.logging.logback.WhitespaceThrowableProxyConverter" />
    <conversionRule conversionWord="wRO" converterClass="org.springframework.boot.logging.logback.ExtendedWhitespaceThrowableProxyConverter" />

    <property name="LOG_FILE" value="../logs/"/>
    <property name="currentDate" value="%d{yyyy-MM-dd}" />

    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_FILE}server.log.%d{yyyy-MM-dd_HH}</fileNamePattern>
            <maxHistory>72</maxHistory>
        </rollingPolicy>
    </appender>

    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <pattern>%clr(%d{yyyy-MM-dd HH:mm:ss.SSS}){faint} %clr(${LOG_LEVEL_PATTERN:-%5p}) %clr(${PID:- }){magenta} %clr(---){faint} %clr([%15.15t]){faint} %clr(%-40.40logger{39}){cyan} %clr(:){faint} %m%n${LOG_EXCEPTION_CONVERSION_WORD:-%wex}</pattern>
        </encoder>
    </appender>

    <logger name="com.paicbd.module" additivity="false" level="warn">
        <appender-ref ref="FILE" />
        <appender-ref ref="CONSOLE"/>
    </logger>

    <logger name="com.paicbd.module.ss7.MessageProcessing" additivity="false" level="error">
        <appender-ref ref="FILE" />
        <appender-ref ref="CONSOLE"/>
    </logger>

    <root level="warn">
        <appender-ref ref="FILE" />
        <appender-ref ref="CONSOLE"/>
    </root>
</configuration>
```
You may run the Docker compose with the following command in the directory where the docker-compose.yml file is located:

`sudo docker compose up -d`

#### GUI Access
Once the SMSC Management FE module is up, you may access the GUI in the host port defined in the Docker compose:

`http://{host}:80` // If the port 80 is used for the Frontend Module in the docker file as the example provided

Credentials are defined in the SMSC Management BE's compose. By default they are set as:
```shell
Username: admin
Password: admin
```

### Getting the Source Code

To obtain the source code for the SMSC, you can execute the provided Bash script:

```shell
chmod +x fork-and-clone-smsc-repos.sh
./fork-and-clone-smsc-repos.sh "<destination_directory>"
```