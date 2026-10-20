# Lightning Lite IoT 模块

`lightning-iot` 是 Lightning Lite 的物联网业务模块，连接产品模型、设备、协议接入、实时状态和历史数据服务。它由 `lightning-admin` 装配运行，不是独立启动的应用。

## 主要能力

| 模块 | 说明 |
| --- | --- |
| 产品与模型 | 产品分类、产品模板和属性定义 |
| 设备与网关 | 设备、边缘网关、分组、区域与绑定关系 |
| 点位与属性 | 网关数据点位、属性绑定、读写与分组批量下置 |
| 标签与单位 | 设备和点位标签、单位及单位分类 |
| 数据处理 | 设备状态更新、历史数据写入与查询 |
| 告警日志 | 已有告警日志的查询 |
| 接入扩展 | MQTT 消息编解码及边缘协议驱动插件 |

Lite 的范围不包括能源管理业务模块、可视化大屏编辑器和完整的告警规则配置与场景联动。

两版业务范围详见[Lite 与完整版功能对比](../README.md#lite-与完整版功能对比)。

## 数据流

```text
MQTT 设备 → Broker → 消息编解码器 ─┐
                                ├→ 设备属性与状态 → 历史存储 / 查询 / 页面更新
现场设备 → 协议驱动 → 网关数据点位 ─┘
                         ↑
                    设备属性绑定
```

属性下置通过设备属性绑定找到对应网关点位，由驱动执行。可写能力取决于驱动、点位类型和设备自身权限。

## 接入第一个设备

建议先用一台设备或一个模拟服务完成单点联调，再扩展设备规模。

1. 创建产品分类和产品，配置产品模板及需要采集的属性。
2. 创建设备，确认产品 ID、设备 ID 和属性标识。
3. 选择 MQTT 接入，或安装对应边缘驱动并创建网关。
4. 边缘接入需要创建或发现点位，将设备属性绑定到网关点位；MQTT 接入需要配置产品编解码器。
5. 启用接入并产生数据，检查设备实时状态和属性值。
6. 按产品和设备的历史采集设置产生历史记录，再到历史页面按设备及时间范围查询。
7. 如需验证写入，选择支持写入的测试点位，并检查设备返回结果。

## MQTT 设备接入

### 准备条件

- 部署可访问的 MQTT Broker。
- 在后端 `application.yml` 中将 `mqtt.enabled` 改为 `true`，配置 `host`、`port`、`username`、`password` 和唯一的 `client-id`。
- 构建并安装 `codec-default` 插件，为产品配置编解码器 ID `DefaultCodec`；自定义消息格式则安装对应的自定义编解码器。
- 先创建产品和设备，保证上报的 ID 与平台记录一致。

### Topic 与消息

默认订阅模式为 `/+/+/properties/report`，设备上报 Topic 为：

```text
/{productId}/{deviceId}/properties/report
```

默认 JSON 编解码器将消息转换为平台的 `DeviceState`，消息需包含匹配的 `productId`、`deviceId`、`properties` 等状态数据。`properties` 中每个属性使用平台 `DataPoint` 结构，不能直接把任意传感器 JSON 当作默认协议。

现有上报示例见 [`DeviceContinuousReportMain`](src/main/java/com/ruoyi/iot/mqtt/DeviceContinuousReportMain.java)。运行前需修改 Broker 连接、产品与设备 ID、设备数量和上报间隔，使其与测试环境一致；该程序用于模拟上报，不代表平台容量或性能承诺。

自定义设备报文可通过实现 `DeviceMessageCodec` 扩展，接口源码见 [`lightning-plugin-api`](../lightning-plugin-api)。

## 边缘协议接入

仓库包含以下驱动模块，使用前需构建安装并核对现场协议配置：

| 驱动 | 源码或文档 |
| --- | --- |
| Modbus TCP | [`edge-modbus`](../lightning-plugins/edge-modbus) |
| OPC UA | [连接、安全与点位配置](../lightning-plugins/edge-opcua/README.md) |
| KNX | [驱动说明](../lightning-plugins/edge-knx/README.md) |
| BACnet | [驱动说明](../lightning-plugins/edge-bacnet/README.md) |
| PLC4X | [`edge-plc4x`](../lightning-plugins/edge-plc4x) |

插件构建和安装方法见[后端 README](../README.md#构建与安装插件)。驱动源码的存在不代表所有厂商、型号和协议变体均已验证。

## 历史数据存储

历史存储由 `device.history.storage.strategy` 选择：

- `mysql`：使用 MySQL 存储，首次体验可选择此方式，并关闭 `influxdb.enabled`。
- `influxdb`：使用 InfluxDB 2.x，需启用 `influxdb.enabled` 并配置 URL、Token、组织和 Bucket。

仓库当前默认选择 InfluxDB。切换策略只改变读写使用的存储后端，不会自动迁移历史数据。

## 相关文档

- [后端环境与启动](../README.md)
- [设备分组批量属性下置 API](../doc/device-batch-write-api.md)
- [消息编解码器源码](../lightning-plugins/codec-default)
- [协议插件接口](../lightning-plugin-api)
