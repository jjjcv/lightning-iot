-- Eclipse Milo OPC UA 边缘协议。
-- 协议 id 必须与 OpcUaEdgeDriverPlugin.OpcUaDriverFactory#getProtocolId() 保持一致。
INSERT INTO `transport_protocol` (
    `id`,
    `name`,
    `description`,
    `status`,
    `configuration`,
    `protocol_type`,
    `create_by`,
    `create_time`,
    `update_by`,
    `update_time`,
    `remark`
) VALUES (
    'opcua',
    'OPC UA',
    '基于 Eclipse Milo 的 OPC UA 边缘采集协议',
    'enable',
    '{
      "id": "opcua",
      "name": "OPC UA",
      "description": "基于 Eclipse Milo 的 OPC UA 边缘采集协议",
      "connectionProperties": [
        {
          "id": "endpoint",
          "name": "服务地址",
          "description": "OPC UA 服务地址，例如 192.168.1.10:4840",
          "required": true,
          "valueType": {"type": "string"}
        },
        {
          "id": "username",
          "name": "用户名",
          "description": "匿名连接时留空",
          "required": false,
          "valueType": {"type": "string"}
        },
        {
          "id": "password",
          "name": "密码",
          "description": "匿名连接时留空",
          "required": false,
          "valueType": {"type": "password"}
        },
        {
          "id": "autoCreatePoints",
          "name": "自动创建点位",
          "description": "连接后浏览OPC UA变量节点并自动创建点位，默认开启",
          "required": false,
          "valueType": {"type": "boolean"}
        },
        {
          "id": "samplingInterval",
          "name": "采样周期(ms)",
          "description": "监控项采样周期，默认1000ms",
          "required": false,
          "valueType": {"type": "int"}
        },
        {
          "id": "publishingInterval",
          "name": "发布周期(ms)",
          "description": "订阅发布周期，默认1000ms",
          "required": false,
          "valueType": {"type": "int"}
        },
        {
          "id": "connectInterval",
          "name": "重连检测周期(ms)",
          "description": "连接状态检测及重连周期，默认30000ms",
          "required": false,
          "valueType": {"type": "int"}
        },
        {
          "id": "requestTimeout",
          "name": "请求超时(ms)",
          "description": "OPC UA请求超时时间，默认5000ms",
          "required": false,
          "valueType": {"type": "int"}
        }
      ],
      "dataPointProperties": [
        {
          "id": "nodeId",
          "name": "NodeId",
          "description": "自动发现时从节点获取；手工新建时填写标准 OPC UA NodeId，例如 ns=2;s=Machine/Temperature",
          "required": true,
          "valueType": {"type": "string"}
        },
        {
          "id": "browseName",
          "name": "浏览名称",
          "description": "自动发现时获取的 OPC UA 节点 BrowseName，例如 Temperature",
          "required": false,
          "valueType": {"type": "string"}
        },
        {
          "id": "displayName",
          "name": "显示名称",
          "description": "自动发现时获取的 OPC UA 节点本地化显示名称，例如 温度",
          "required": false,
          "valueType": {"type": "string"}
        },
        {
          "id": "dataType",
          "name": "数据类型",
          "description": "自动发现时获取的 OPC UA 数据类型名称，例如 Double",
          "required": false,
          "valueType": {"type": "string"}
        },
        {
          "id": "dataTypeNodeId",
          "name": "数据类型 NodeId",
          "description": "自动发现时获取的 OPC UA 数据类型节点标识，例如 ns=0;i=11",
          "required": false,
          "valueType": {"type": "string"}
        },
        {
          "id": "accessLevel",
          "name": "访问级别",
          "description": "自动发现时获取的当前用户 OPC UA 节点访问权限，例如 Read/Write",
          "required": false,
          "valueType": {"type": "string"}
        },
        {
          "id": "writable",
          "name": "可写",
          "description": "自动发现时根据当前用户访问权限判断是否可写",
          "required": false,
          "valueType": {"type": "boolean"}
        }
      ]
    }',
    'edge',
    'admin',
    CURRENT_TIMESTAMP,
    '',
    NULL,
    'edge-opcua PF4J协议插件，协议ID为opcua'
);
