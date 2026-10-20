-- Calimero KNXnet/IP 边缘协议。
-- 协议 id 必须与 KnxEdgeDriverPlugin.KnxDriverFactory#getProtocolId() 保持一致。
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
    'knx',
    'KNXnet/IP',
    '基于 Calimero 的 KNXnet/IP 边缘采集协议',
    'enable',
    '{
      "id": "knx",
      "name": "KNXnet/IP",
      "description": "基于 Calimero 的 KNXnet/IP 边缘采集协议",
      "connectionProperties": [
        {
          "id": "ipAddress",
          "name": "IP地址",
          "description": "KNXnet/IP 接口或路由器的 IPv4 地址，例如 192.168.1.20",
          "required": true,
          "valueType": {"type": "string"}
        },
        {
          "id": "port",
          "name": "连接端口",
          "description": "KNXnet/IP Tunneling UDP 端口，通常为 3671",
          "required": true,
          "valueType": {"type": "int"}
        }
      ],
      "dataPointProperties": [
        {
          "id": "groupAddress",
          "name": "KNX 组地址",
          "description": "例如 1/2/3",
          "required": true,
          "valueType": {"type": "string"}
        },
        {
          "id": "dpt",
          "name": "KNX DPT",
          "description": "标准 DPT，例如开关 1.001、温度 9.001",
          "required": true,
          "valueType": {"type": "string"}
        }
      ]
    }',
    'edge',
    'admin',
    CURRENT_TIMESTAMP,
    '',
    NULL,
    'edge-knx PF4J协议插件，协议ID为knx'
);
