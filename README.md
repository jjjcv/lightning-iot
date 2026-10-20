# Lightning Lite

面向设备接入与管理的轻量物联网平台。

Lightning Lite 基于 Java 21、Spring Boot 和 Vue 3，提供产品建模、设备与网关管理、数据点位、属性读写和历史数据查询能力。通过协议驱动与消息编解码插件，可以按项目需要扩展设备接入方式。

适合物联网项目原型验证、协议接入开发，以及设备管理系统的二次开发。

[后端部署](lightning-lite/README.md) · [前端启动](lightning-vue3-lite/README.md) · [IoT 模块说明](lightning-lite/lightning-iot/README.md)

## 核心能力

| 能力 | 说明 |
| --- | --- |
| 产品与模型 | 产品分类、产品模板及设备属性建模 |
| 设备管理 | 设备、网关、分组、标签、区域与绑定关系 |
| 点位与读写 | 网关数据点位、设备属性绑定、属性下置与分组批量下置 |
| 数据查询 | 设备实时状态、历史数据和告警日志查询 |
| 协议扩展 | MQTT 消息接入，以及 Modbus TCP、OPC UA、KNX、BACnet、PLC4X 驱动插件源码 |
| 平台管理 | 用户、角色、菜单、字典、日志、定时任务、代码生成与系统备份 |

协议接入需要安装对应插件并配置现场参数。具体设备、数据类型和读写能力以各驱动实现及实际联调结果为准。

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

## 项目组成

```text
lightning-project-lite/
├── lightning-lite/          # Java 后端、协议插件、数据库脚本
└── lightning-vue3-lite/     # Vue 3 管理端
```

前后端应使用配套版本。分别发布仓库时，请保留相同的版本标签，便于部署和问题定位。

## 从哪里开始

1. 按[后端说明](lightning-lite/README.md#快速开始)准备 MySQL 和 Redis，导入数据库并启动后端。
2. 首次体验可选择 MySQL 历史存储；使用 InfluxDB 时再启用并配置时序数据库。
3. 按[前端说明](lightning-vue3-lite/README.md#快速开始)安装依赖，启动管理端。
4. 创建产品、设备与属性绑定，按[设备接入说明](lightning-lite/lightning-iot/README.md#接入第一个设备)验证数据采集和查询。

默认后端地址为 `http://localhost:8080`，前端开发地址为 `http://localhost:80`；端口冲突时以前端终端实际输出为准。

## 文档

- [后端环境、配置与启动](lightning-lite/README.md)
- [前端开发与部署](lightning-vue3-lite/README.md)
- [IoT 数据流与接入方式](lightning-lite/lightning-iot/README.md)
- [设备分组批量属性下置 API](lightning-lite/doc/device-batch-write-api.md)
- [OPC UA 驱动](lightning-lite/lightning-plugins/edge-opcua/README.md)
- [KNX 驱动](lightning-lite/lightning-plugins/edge-knx/README.md)
- [BACnet 驱动](lightning-lite/lightning-plugins/edge-bacnet/README.md)

## 参与贡献

欢迎提交问题反馈、文档改进和代码贡献。报告问题时，请提供前后端版本、运行环境、复现步骤、预期结果及脱敏后的日志。涉及设备协议时，请补充协议类型和必要的模拟数据。

## 许可证与致谢

后端与前端采用 MIT 许可证，分别见[后端 LICENSE](lightning-lite/LICENSE)和[前端 LICENSE](lightning-vue3-lite/LICENSE)。使用和分发时请保留相应版权及许可声明，第三方依赖遵循各自的许可证。

项目基于 RuoYi 等开源项目开发，感谢上游作者和所有贡献者。
