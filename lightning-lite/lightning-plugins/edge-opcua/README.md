# edge-opcua

基于 Eclipse Milo 1.1.6 的 OPC UA 客户端型边缘驱动。插件协议 ID 为 `opcua`，支持批量读写、
Subscription/MonitoredItem 数据采集、订阅失败回退轮询、断线检测重连、用户名认证和安全端点。

## 网关配置

常用连接只需要一个参数；省略端口时使用 OPC UA 默认端口 `4840`：

```json
{
  "endpoint": "192.168.1.10"
}
```

用户名认证也只有三个参数：

```json
{
  "endpoint": "192.168.1.10:4840",
  "username": "operator",
  "password": "change-me"
}
```

连接成功后，驱动默认浏览 OPC UA `Objects` 目录下的非系统变量节点，并自动创建尚不存在的边缘网关
数据点位。点位以标准 `nodeId` 幂等去重，重连不会重复创建；如需关闭，可设置：

```json
{
  "endpoint": "192.168.1.10:4840",
  "autoCreatePoints": false
}
```

自动创建的点位名称使用节点层级路径，数据类型根据 OPC UA 内建类型转换，读写类型根据节点访问权限确定。
新点位会立即加入订阅，无需重启网关。

驱动默认使用无加密端点、5 秒请求超时、1 秒订阅周期和 30 秒重连检测；订阅不可用时自动回退轮询，
这些参数无需在普通连接中配置。

需要调整采集节奏和超时时，可在连接配置中设置：

```json
{
  "endpoint": "192.168.1.10:4840",
  "samplingInterval": 1000,
  "publishingInterval": 1000,
  "connectInterval": 30000,
  "requestTimeout": 5000
}
```

以上单位均为毫秒，并作用于整个 OPC UA 连接；单个点位不再重复配置这些参数。

安全端点属于高级配置。`security` 已同时确定安全策略与默认的 `SignAndEncrypt` 模式：

```json
{
  "endpoint": "192.168.1.10:4840",
  "security": "Basic256Sha256",
  "application_uri": "urn:lightning:edge:opcua:gateway-01",
  "key_store_path": "conf/opcua/client.p12",
  "key_store_type": "PKCS12",
  "key_store_password": "change-me",
  "key_alias": "client",
  "key_password": "change-me",
  "trust_list_path": "conf/opcua/pki"
}
```

`trust_list_path` 采用 Milo 的文件信任列表目录结构。调试时可显式设置 `trust_all: true`，生产环境不建议使用。
对于安全端点，证书中的 Application URI 应与 `application_uri` 一致。

如服务器只提供 `Sign` 模式，可额外配置 `security_mode: "Sign"`。旧的 `endpoint_url`、
`host`/`port` 以及 `opcua:tcp://...` `connection_string` 仍然兼容。

## 点位配置

推荐直接使用 OPC UA 标准可解析 NodeId。自动发现点位时，驱动会同时保存节点名称、OPC UA 数据类型
和访问权限：

```json
{
  "nodeId": "ns=3;i=1002",
  "browseName": "Temperature",
  "displayName": "温度",
  "dataType": "Double",
  "dataTypeNodeId": "ns=0;i=11",
  "accessLevel": "Read/Write",
  "writable": true
}
```

只有 `nodeId` 是连接读写所需的必填属性，其余属性是自动发现时记录的节点元数据。读写值转换仍以平台
`DataPoint.type` 为准。旧配置中的 `node_id`、`address`、`tag_address` 继续兼容。

## 构建

```shell
mvn -pl lightning-plugins/edge-opcua -am clean package
```

构建结果 `lightning-plugins/edge-opcua/target/edge-opcua-3.9.2.jar` 是包含 Milo 运行依赖的 PF4J 插件包。
