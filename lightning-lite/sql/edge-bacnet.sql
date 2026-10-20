-- BACnet4J BACnet/IP 边缘协议。
-- 协议 id 必须与 BacnetEdgeDriverPlugin.BacnetDriverFactory#getProtocolId() 保持一致。
INSERT INTO `transport_protocol` (
    `id`, `name`, `description`, `status`, `configuration`, `protocol_type`,
    `create_by`, `create_time`, `update_by`, `update_time`, `remark`
) VALUES (
    'bacnet',
    'BACnet/IP',
    '基于 BACnet4J 6.1.1 的 BACnet/IP 边缘采集协议',
    'enable',
    '{
      "id": "bacnet",
      "name": "BACnet/IP",
      "description": "基于 BACnet4J 6.1.1 的 BACnet/IP 边缘采集协议",
      "connectionProperties": [
        {"id":"localDeviceInstance","name":"本地设备实例","description":"本网关的BACnet设备实例，0-4194302且网络内唯一","required":true,"valueType":{"type":"int"}},
        {"id":"localIp","name":"本机IPv4地址","description":"可选；多网卡主机建议指定，广播地址和网络前缀自动读取","required":false,"valueType":{"type":"string"}},
        {"id":"deviceInstances","name":"设备实例白名单","description":"逗号分隔的远端设备实例；留空发现全部","required":false,"valueType":{"type":"string"}},
        {"id":"pollingInterval","name":"轮询周期(ms)","description":"默认5000ms","required":false,"valueType":{"type":"int"}}
      ],
      "dataPointProperties": [
        {"id":"deviceInstance","name":"远端设备实例","description":"BACnet Device实例，0-4194302","required":true,"valueType":{"type":"int"}},
        {"id":"objectType","name":"对象类型","description":"当前驱动支持的BACnet标准对象类型","required":true,"valueType":{"type":"enum","valueType":{"type":"string"},"elements":[{"value":"analogInput","text":"模拟量输入"},{"value":"analogOutput","text":"模拟量输出"},{"value":"analogValue","text":"模拟量值"},{"value":"binaryInput","text":"二进制输入"},{"value":"binaryOutput","text":"二进制输出"},{"value":"binaryValue","text":"二进制值"},{"value":"multiStateInput","text":"多状态输入"},{"value":"multiStateOutput","text":"多状态输出"},{"value":"multiStateValue","text":"多状态值"},{"value":"accumulator","text":"累加器"},{"value":"pulseConverter","text":"脉冲转换器"},{"value":"integerValue","text":"整数值"},{"value":"positiveIntegerValue","text":"正整数值"},{"value":"largeAnalogValue","text":"大模拟量值"},{"value":"characterstringValue","text":"字符串值"}]}},
        {"id":"objectInstance","name":"对象实例","description":"BACnet对象实例，0-4194302","required":true,"valueType":{"type":"int"}},
        {"id":"writePriority","name":"写优先级","description":"可选，范围1-16，仅写点位使用","required":false,"valueType":{"type":"int"}}
      ]
    }',
    'edge', 'admin', CURRENT_TIMESTAMP, '', NULL,
    'edge-bacnet PF4J协议插件，协议ID为bacnet'
);
