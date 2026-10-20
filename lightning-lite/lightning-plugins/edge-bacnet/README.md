# edge-bacnet

基于 BACnet4J `6.1.1` 的 BACnet/IP 客户端型边缘驱动，插件协议 ID 为 `bacnet`。支持 IPv4 广播发现、
自动创建常用 `presentValue` 点位、轮询读取、标准点位写入、BACnet 写优先级和本地传输重建。

> BACnet4J 开源版本采用 GPLv3。闭源商业分发前应确认许可证兼容性，或向 Radix IoT 获取商业许可。

## 网关连接属性

连接配置仅包含以下四个属性：

| 属性 | 必填 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `localDeviceInstance` | 是 | - | 本网关的 BACnet 设备实例，范围 0～4194302，同一 BACnet 网络内必须唯一 |
| `localIp` | 否 | 自动 | 本机网卡 IPv4 地址；配置后自动读取该网卡的广播地址和网络前缀 |
| `deviceInstances` | 否 | 空（全部） | 自动建点设备白名单，使用逗号分隔，例如 `1001,1002` |
| `pollingInterval` | 否 | `5000` | 全部点位轮询周期，单位毫秒 |

端口固定为 BACnet/IP 默认端口 `47808`，自动建点默认开启。请求超时、分段超时、重试、发现等待和重建周期
由驱动使用内置参数，不再暴露为配置。

最小配置：

```json
{
  "localDeviceInstance": 390001
}
```

多网卡并限制目标设备时：

```json
{
  "localDeviceInstance": 390001,
  "localIp": "192.168.10.20",
  "deviceInstances": "1001,1002",
  "pollingInterval": 5000
}
```

## 网关点位属性

普通点位只有三个必填属性；写点位可以增加写优先级：

| 属性 | 必填 | 说明 |
| --- | --- | --- |
| `deviceInstance` | 是 | 远端 BACnet Device 实例号，范围 0～4194302 |
| `objectType` | 是 | BACnet 对象类型，配置界面使用枚举选择 |
| `objectInstance` | 是 | BACnet 对象实例号，范围 0～4194302 |
| `writePriority` | 否 | BACnet 命令优先级，范围 1～16，仅写入时使用 |

模拟量输入：

```json
{
  "deviceInstance": 1001,
  "objectType": "analogInput",
  "objectInstance": 7
}
```

带优先级的模拟量输出：

```json
{
  "deviceInstance": 1001,
  "objectType": "analogOutput",
  "objectInstance": 3,
  "writePriority": 8
}
```

`objectType` 仅允许选择当前驱动支持的 BACnet 标准对象类型，例如 `analogInput`、`binaryOutput`、
`multiStateValue`。所有点位固定访问标准 `presentValue`，不再支持紧凑 `objectId`、数值对象类型、
单独配置属性标识、数组下标或私有属性编码类型。

自动创建目前覆盖模拟量、二进制、多状态、整数、大模拟量、字符值、累加器和脉冲转换器对象。BACnet/IP
使用 UDP，驱动的在线状态表示本地 BACnet 传输已启动；单台远端设备超时不会将整个网关判定为离线。

## 点位自动创建

网关启用并成功启动 BACnet/IP 传输后，会自动广播发现远端设备、读取设备的 `objectList`，并为驱动支持的
标准 `presentValue` 对象创建平台点位。`deviceInstances` 非空时只为白名单中的设备创建点位；单次最多处理
2000 个对象。

自动创建的配置只包含 `deviceInstance`、`objectType`、`objectInstance` 三个必填属性。点位稳定键为
`设备实例/对象类型/对象实例/presentValue`，再次启用或重连后发现相同对象时会复用已有点位，不会重复入库。
输入类对象创建为只读点位，支持命令写入的输出/值对象创建为可写点位。

## 构建

```shell
mvn -pl lightning-plugins/edge-bacnet -am clean package
```

构建结果 `lightning-plugins/edge-bacnet/target/edge-bacnet-3.9.2.jar` 是包含 BACnet4J 运行依赖的 PF4J 插件包。
