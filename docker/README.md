# Lightning 物联网平台 Docker 安装

`docker` 是独立的 Docker 安装目录，包含配置、Dockerfile 和自己的业务文件。
复制整个目录到服务器后，直接使用 Docker Compose 启动六个服务。密码使用配置中的固定值，手动修改即可。

## 启动

安装并启动 Docker Engine / Docker Desktop，Windows 使用 Linux 容器。
需要 Docker Compose v2.20+，建议至少 4 GB 可用内存。首次构建需要访问镜像仓库和 Ubuntu 软件源。

在复制后的 `docker` 目录中执行：

```sh
docker compose up -d --build
```

查看状态和日志：

```sh
docker compose ps
docker compose logs -f --tail=200 backend
```

需要等待所有健康检查通过时使用：

```sh
docker compose up -d --build --wait --wait-timeout 600
```

启动后访问 **http://localhost:8798**，远程访问将 localhost 替换为服务器 IP。
设备连接 `服务器IP:1883`，默认 MQTT 用户名为 `admin`，密码为 `lightningMqtt123`。
平台登录账号由初始化 SQL / 业务版本决定，与数据库和 MQTT 账号不同。

## 独立目录结构

```text
docker/
├── compose.yaml
├── .env.example
├── .env                      # 可选，手动覆盖默认配置
├── backend/
│   ├── Dockerfile
│   ├── application-docker.yml
│   └── logback-spring.xml
├── nginx/
│   ├── Dockerfile
│   └── default.conf
├── nanomq/
│   ├── nanomq.conf
│   └── nanomq_pwd.conf
└── payload/
    ├── app/
    │   ├── lightning-server.jar
    │   ├── plugins/           # 插件目录，未使用插件时可为空
    │   └── license.lic        # 可选，匹配部署环境的授权文件
    ├── html/                 # 前端构建产物，包含 index.html
    └── database/
        └── lightning.sql     # 首次数据库初始化 SQL
```

所有构建路径和挂载路径都在当前目录内。当前工作区已放入 Docker 安装所需的 JAR、插件、前端和 SQL。
分发安装目录时必须包含 `payload` 中的业务文件；这些产物被 Git 忽略，单独获取配置源码时需自行放入。
`.dockerignore` 只允许所需业务文件与容器配置进入镜像构建，不打包 `.env`。

## 配置与密码

`compose.yaml` 提供固定默认凭据，可以直接启动。需要自定义配置时，将 `.env.example` 复制为 `.env` 并手动编辑：

```powershell
# Windows PowerShell，在 docker 目录执行
Copy-Item .env.example .env
```

```sh
# Linux / macOS，在 docker 目录执行
cp .env.example .env
```

`.env` 可修改以下配置：

- `HTTP_PORT` / `MQTT_PORT`：默认 8798 / 1883。
- `MYSQL_DATABASE`、`MYSQL_USERNAME`、`MYSQL_PASSWORD`、`MYSQL_ROOT_PASSWORD`：MySQL 初始化及后端连接。
- `REDIS_PASSWORD`：Redis 与后端共享密码。
- `INFLUX_USERNAME`、`INFLUX_PASSWORD`、`INFLUX_ORG`、`INFLUX_BUCKET`、`INFLUX_TOKEN`：InfluxDB 初始化配置及后端连接。
- `TOKEN_SECRET` / `DRUID_ADMIN_PASSWORD`：后端 Token 密钥及 Druid 控制台密码。
- `NANOMQ_USERNAME` / `NANOMQ_PASSWORD`：后端 MQTT 连接凭据。
- `JAVA_TOOL_OPTIONS`：默认 `-Xms256m -Xmx1024m -Duser.timezone=Asia/Shanghai`。
- 各 `*_IMAGE`：服务镜像版本或仓库地址，InfluxDB 应使用与后端兼容的 2.x。

**MQTT 用户名和密码需同时修改 `nanomq/nanomq_pwd.conf`。**
例如 `.env` 中设置 `NANOMQ_USERNAME=admin`、`NANOMQ_PASSWORD=myMqttPassword`，密码文件对应设置为：

```text
"admin": "myMqttPassword"
```

使用默认值时无需创建 `.env`。生产部署前应将默认凭据替换为自己的固定配置。
数据库首次初始化后，修改 `.env` 不会自动更改数据库中已创建的密码或 InfluxDB Token，需在对应服务中同步修改。

其他配置文件：

- `backend/application-docker.yml`：后端配置，服务地址使用 `mysql`、`redis`、`influxdb` 和 `nanomq`。
- `backend/logback-spring.xml`：日志输出到控制台及 `/opt/lightning/logs`。
- `nginx/default.conf`：前端单页路由、`/prod-api/` 和 API 文档代理。
- `nanomq/nanomq.conf`：MQTT 监听及认证配置。

配置修改后运行：

```sh
docker compose up -d --build --force-recreate
```

后端保留业务授权检查。可以将授权文件放入 `payload/app/license.lic` 随镜像构建，
也可以在 `backend.volumes` 中加入 `./license.lic:/opt/lightning/license.lic:ro`，将当前目录中的授权文件只读挂载到容器。

## 数据与维护

默认仅对外开放 Web 和 MQTT，数据库、缓存及后端在容器网络内通信。
MySQL、Redis、InfluxDB、后端上传文件、日志及备份保存在命名卷中。
MySQL SQL 导入与 InfluxDB 初始化只在空数据卷首次启动时执行。
NanoMQ 未配置消息及会话的磁盘持久化。

```sh
docker compose stop       # 停止服务
docker compose start      # 启动已有容器
docker compose down       # 移除容器和网络，保留数据卷
```

更新当前目录内的 JAR、插件或前端文件后，重新运行 `docker compose up -d --build --force-recreate`。
已有数据库的版本升级需要单独执行迁移，新的初始化 SQL 不会自动重新导入。
升级前备份数据卷和配置；`docker compose down -v` 会删除数据卷。

后端镜像包含 MySQL 8 客户端，用于业务备份与恢复；该功能和设备接入需在部署后验证。
服务的健康检查用于确认启动就绪，不能替代业务功能验证。

如果启动失败，使用 `docker compose logs --tail=200 mysql influxdb nanomq backend` 查看原因。
Docker API / named pipe 连接失败时，先启动 Docker Desktop 并确认 Linux 容器引擎可用。

NanoMQ 日志中的 `Abort finding default config path` / `Set new conf path from env: (null)`
不代表启动失败；本配置使用 `--conf /etc/nanomq.conf` 显式指定配置文件。
仅启用 MQTT TCP 时，0.25.6 还会输出 `Read websocket config failed!` 警告，
无需为了消除该警告启用 WebSocket。请以容器健康状态和 MQTT 连接结果判断是否启动成功。
若 NanoMQ 显示 `unhealthy`，可查看健康检查的实际输出：

```sh
docker inspect --format '{{json .State.Health}}' lightning-iot-nanomq-1
```

项目名自定义时，请替换上述容器名。更新健康检查后，只重建 NanoMQ 容器即可应用：

```sh
docker compose up -d --no-deps --force-recreate --wait --wait-timeout 60 nanomq
```

如果旧镜像启动时出现 `/home/ruoyi/logs/sys-info.log` 等 Logback 错误，更新当前目录的后端 Dockerfile 和日志配置后重新构建：

```sh
docker compose up -d --build --force-recreate backend
docker compose logs -f --tail=200 backend
```

JAR 内置的 `logback.xml` 可能在 Spring 读取 YAML 前加载。后端通过 JVM 参数
`logback.configurationFile` 和 `logging.config`，让两个阶段都使用外部日志配置，
日志写入已配置的数据卷路径 `/opt/lightning/logs`。该 XML 使用原生 Logback 语法，不能加入依赖 Spring 的 `springProperty` 或 `springProfile`。
