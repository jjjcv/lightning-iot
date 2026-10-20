# edge-knx

基于 Calimero 3.0-M2 的 KNXnet/IP 客户端型边缘驱动。插件协议 ID 为 `knx`，固定使用 KNXnet/IP
Tunneling，支持标准 KNX DPT 编解码、点位主动读写、GroupValueWrite/GroupValueResponse
事件采集及断线重连。

## 网关连接属性

| 属性 | 必填 | 说明 |
| --- | --- | --- |
| `ipAddress` | 是 | KNXnet/IP 接口或路由器的 IPv4 地址 |
| `port` | 是 | KNXnet/IP Tunneling UDP 端口，通常为 `3671` |

连接配置：

```json
{
  "ipAddress": "192.168.1.20",
  "port": 3671
}
```

连接模式固定为 Tunneling，不需要配置。驱动内部使用 `0.0.0` 客户端个体地址、5 秒读取响应超时和
30 秒重连检测周期。

## 网关点位属性

每个点位只需要 KNX 组地址和标准 DPT。读写权限使用平台点位的 `operationType`，无需在协议配置中重复：

```json
{
  "groupAddress": "1/2/3",
  "dpt": "9.001"
}
```

- `groupAddress`：必填，支持三段式（`1/2/3`）、两段式或自由式 KNX 组地址。
- `dpt`：必填，标准 KNX DPT 标识。子类型会自动规范为三位，例如 `9.1` 规范为 `9.001`。

常用 DPT 示例：

| 用途 | DPT | 建议平台类型 |
| --- | --- | --- |
| 开关 | `1.001` | `boolean` |
| 调光百分比 | `5.001` | `int` |
| 无符号计数 | `5.010` | `int` |
| 温度 | `9.001` | `double` |
| 14 字符文本 | `16.001` | `string` |
| 日期时间 | `19.001` | `date` |

KNX 总线无法仅通过运行时电报可靠发现完整组地址、DPT 和语义，因此本驱动不自动创建点位；点位应来自 ETS
工程配置并由平台维护。

## 构建

```shell
mvn -pl lightning-plugins/edge-knx -am clean package
```

构建结果 `lightning-plugins/edge-knx/target/edge-knx-3.9.2.jar` 是包含 Calimero 运行依赖的 PF4J 插件包。
