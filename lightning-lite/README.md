# Lightning Lite 后端

Lightning Lite 的服务端，负责设备接入、产品与设备管理、属性读写、历史数据查询及平台基础服务。

后端基于 Java 21、Spring Boot 4、MyBatis 和 Spring Security，使用 MySQL、Redis，并通过 PF4J 扩展协议驱动与消息编解码器。配套管理端目录为 `lightning-vue3-lite`，请使用相同发布版本。

## 功能范围

- **产品与设备**：产品分类、产品模板、设备、网关、分组、标签、区域和绑定关系。
- **点位与读写**：网关点位管理、设备属性绑定、属性下置和设备分组批量下置。
- **数据与状态**：设备消息处理、状态更新、历史查询及告警日志查询。
- **接入扩展**：MQTT 消息接入；Modbus TCP、OPC UA、KNX、BACnet 和 PLC4X 驱动插件源码。
- **平台管理**：用户、角色、部门、菜单、字典、日志、定时任务、代码生成和系统备份。

Lite 不包含能源管理业务模块和可视化大屏编辑器，也不将完整的告警规则配置与场景联动作为本版本功能。

## Lite 与完整版功能对比

Lightning Lite 聚焦设备接入、管理和数据查询；Lightning 完整版在此基础上提供自动化联动、能源管理和可视化能力。

| 功能 | Lightning Lite | Lightning 完整版 |
| --- | --- | --- |
| 产品分类、产品模板与属性建模 | 包含 | 包含 |
| 设备、网关、数据点位与属性绑定 | 包含 | 包含 |
| 标签、单位与建筑区域管理 | 包含 | 包含 |
| 设备属性下置与分组批量下置 | 包含 | 包含 |
| MQTT 消息接入与自定义编解码 | 包含，需配置 Broker 和编解码插件 | 包含，需配置 Broker 和编解码插件 |
| Modbus TCP、OPC UA、KNX、BACnet、PLC4X 驱动插件源码 | 包含，按需构建安装 | 包含，按需构建安装 |
| 设备实时状态与历史数据查询 | 包含 | 包含 |
| MySQL / InfluxDB 历史存储策略 | 包含 | 包含 |
| 告警日志查询 | 包含 | 包含 |
| 规则场景配置、场景联动与执行记录 | 不包含 | 包含 |
| 可视化自动化流设计、发布与运行管理 | 不包含 | 包含 |
| 能源类型、区域、支路、分项与表具管理 | 不包含 | 包含 |
| 能耗统计与报表 | 不包含 | 包含 |
| 电价策略与碳排放因子配置 | 不包含 | 包含 |
| 可视化项目、图表编辑与大屏预览发布 | 不包含 | 包含 |
| 数字孪生场景编辑、资源管理与运行展示 | 不包含 | 包含 |
| 用户、角色、菜单与权限管理 | 包含 | 包含 |
| 日志、定时任务、代码生成与系统备份 | 包含 | 包含 |
| 适用场景 | 协议接入验证、设备管理与二次开发 | 设备接入、自动化、能源管理及可视化综合应用 |

本表按当前版本的业务模块和页面范围整理。“包含”表示提供相应模块；协议适配范围仍需按驱动与现场设备确认。Lite 中保留的告警日志查询不包含完整的告警规则配置与场景联动。前后端、菜单及插件应使用配套版本。

## 环境准备

| 组件 | 用途与要求 |
| --- | --- |
| JDK 21 | 编译、运行后端 |
| Maven | 构建多模块项目，建议使用 3.9.x |
| MySQL 8.0 | 业务数据；初始化脚本使用 `utf8mb4_0900_ai_ci` 排序规则 |
| Redis | 登录会话、缓存等基础服务 |
| InfluxDB 2.x | 可选，用于设备历史数据存储 |
| MQTT Broker | 按需部署，用于 MQTT 设备上报；平台本身不是 Broker |

## 快速开始

以下命令均在后端根目录 `lightning-lite` 执行。

### 1. 初始化数据库

创建 `lightning` 数据库，字符集选择 `utf8mb4`，然后通过 MySQL 客户端导入 [`sql/lightning.sql`](sql/lightning.sql)。

该脚本包含建表与初始化数据，并含有删除重建表的语句，请仅导入专用的空数据库。`sql` 下的升级和协议脚本应先核对已有表结构，再按需执行。

### 2. 配置数据库与缓存

在 [`application-druid.yml`](lightning-admin/src/main/resources/application-druid.yml) 中修改数据源：

```yaml
spring:
  datasource:
    druid:
      master:
        url: jdbc:mysql://127.0.0.1:3306/lightning?useUnicode=true&characterEncoding=utf8&serverTimezone=GMT%2B8
        username: your_database_user
        password: your_database_password
```

在 [`application.yml`](lightning-admin/src/main/resources/application.yml) 中配置 Redis，并为 `token.secret` 设置本次部署独立使用的随机密钥。系统备份使用单独的 `system.backup.mysql` 配置，需要与部署环境保持一致；执行备份还需要可用的 `mysql` 和 `mysqldump` 工具路径。

### 3. 选择历史数据存储

首次体验可使用 MySQL，在 `application.yml` 中将对应配置改为：

```yaml
influxdb:
  enabled: false

device:
  history:
    storage:
      strategy: mysql
```

仓库当前配置启用了 InfluxDB，并选择 `influxdb` 存储策略。保留此模式时，应先准备 InfluxDB 2.x，创建组织和 Bucket，配置 `influxdb.url`、`token`、`org` 和 `bucket`。修改存储策略不会自动迁移已有历史数据。

### 4. 构建并启动

```bash
mvn -pl lightning-admin -am clean package -DskipTests
java -jar lightning-admin/target/lightning-admin.jar
```

上面的命令跳过测试，用于构建应用；执行测试可使用 `mvn test`，其中集成测试可能需要配套服务。

从后端根目录运行可以让插件目录 `./plugins` 与本文后续路径保持一致。后端默认监听 `http://localhost:8080`，API 文档地址为 `http://localhost:8080/swagger-ui.html`，访问权限以实际安全配置为准。

IDE 启动入口为 `lightning-admin` 模块中的 `com.ruoyi.RuoYiApplication`，工作目录同样设置为后端根目录。

### 5. 启动前端

进入配套的 `lightning-vue3-lite` 目录，安装依赖并启动：

```bash
yarn install
yarn dev
```

前端通过 `/dev-api` 代理到 `http://localhost:8080`。登录账号由初始化数据和部署者维护，初始密码应在部署时确认并在首次登录后修改。

## MQTT 与协议插件

### MQTT 消息接入

MQTT 默认关闭。使用 MQTT 设备时，在 `application.yml` 中启用 `mqtt.enabled`，并配置 Broker 地址、端口、认证信息及唯一的客户端 ID。

默认属性上报订阅为：

```text
/+/+/properties/report
```

接入时还需安装消息编解码插件，并为产品指定正确的编解码器。完整准备步骤见 [IoT 模块说明](lightning-iot/README.md#mqtt-设备接入)。

### 构建与安装插件

例如构建默认 JSON 编解码器和 Modbus TCP 驱动：

```bash
mvn -pl lightning-plugins/codec-default,lightning-plugins/edge-modbus -am clean package -DskipTests
```

各插件构建产物位于对应模块的 `target` 目录。父 POM 配置了包含运行依赖的打包流程；部署时使用含 PF4J 插件元信息及运行依赖的 JAR，每个插件只放置一份，避免将普通包、`original-*` 包和 `*-all.jar` 同时复制进去。

将所需插件复制到后端启动工作目录下的 `plugins` 文件夹。以 JAR 方式加载时可显式配置：

```yaml
plugin:
  enabled: true
  mode: deployment
```

模式名称使用 PF4J 的运行模式，参见 [PF4J 模式说明](https://pf4j.org/doc/development-mode.html)。重启后检查日志，确认对应编解码器或边缘驱动已注册。插件加载成功后，还需要配置网关连接、点位和设备属性绑定。

已有协议文档：

- [OPC UA](lightning-plugins/edge-opcua/README.md)
- [KNX](lightning-plugins/edge-knx/README.md)
- [BACnet](lightning-plugins/edge-bacnet/README.md)

## 项目结构

```text
lightning-admin/        应用入口与接口装配
lightning-framework/    安全认证与框架配置
lightning-system/       系统管理与备份
lightning-common/       通用工具与基础类型
lightning-iot/          物联网业务与接入运行时
lightning-plugin-api/   插件接口与公共数据类型
lightning-plugins/      编解码器及协议驱动源码
lightning-quartz/       定时任务
lightning-generator/    代码生成
plugins/               运行时插件目录
sql/                   初始化与升级脚本
doc/                   补充文档
```

## 常见问题

- **数据库或 Redis 连接失败**：核对服务状态、端口、账号和密码，确认当前加载了 `druid` 数据源配置。
- **历史数据没有写入或查询为空**：核对历史存储策略、对应数据库配置，以及产品和设备的历史采集设置。
- **出现 `No codec for id`**：核对默认或自定义编解码插件是否已加载，产品的编解码器 ID 是否匹配。
- **网关未采集到数据**：先确认驱动注册成功，再检查现场地址、协议参数、点位和设备属性绑定。

## 文档与贡献

- [IoT 模块说明](lightning-iot/README.md)
- [设备分组批量属性下置 API](doc/device-batch-write-api.md)

欢迎提交 Issue 和 Pull Request。反馈时请提供版本、运行环境、复现步骤及脱敏日志；协议问题请附必要的连接参数和模拟数据，移除账号密码及客户信息。

## 许可证与致谢

本项目采用 [MIT 许可证](LICENSE)。使用和分发时请保留相应版权及许可声明，第三方依赖遵循各自的许可证。

项目基于 RuoYi 等开源项目开发，感谢上游作者和所有贡献者。
