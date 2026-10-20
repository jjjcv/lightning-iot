-- BMS/EMS 常见产品、示例设备及 Modbus TCP 驱动种子数据（MySQL 8+）。
--
-- 说明：
-- 1. 本脚本只写入产品、物模型、示例设备、网关点位和绑定关系，不创建真实现场设备。
-- 2. 示例网关默认 disable，执行后请把 edge-bms-modbus-demo 的 IP、端口和从站号
--    修改为现场参数，再启用网关。
-- 3. Modbus offset 使用 0-based 地址；不同厂家寄存器表可能使用 30001/40001 形式，
--    导入前请按厂家手册换算为 0-based 地址。
-- 4. 示例点位采用常见的数据类型和地址布局，仅用于快速搭建演示模型，不能替代设备寄存器表。

SET NAMES utf8mb4;


-- -----------------------------------------------------------------------------
-- 2. 产品分类
-- -----------------------------------------------------------------------------
INSERT INTO `product_categories` (
    `parent_id`, `ancestors`, `category_name`, `order_num`, `description`,
    `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`
)
SELECT NULL, '0', 'BMS楼宇自控', 10, '暖通空调、照明及楼宇机电设备', '0', '0',
       'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM `product_categories`
    WHERE `category_name` = 'BMS楼宇自控' AND `parent_id` IS NULL AND `del_flag` = '0'
);

INSERT INTO `product_categories` (
    `parent_id`, `ancestors`, `category_name`, `order_num`, `description`,
    `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`
)
SELECT NULL, '0', 'EMS能源管理', 20, '电、水、热及可再生能源计量与变流设备', '0', '0',
       'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM `product_categories`
    WHERE `category_name` = 'EMS能源管理' AND `parent_id` IS NULL AND `del_flag` = '0'
);

-- -----------------------------------------------------------------------------
-- 3. BMS/EMS 常见产品
-- -----------------------------------------------------------------------------
INSERT INTO `products` (
    `id`, `name`, `description`, `product_category_id`, `protocol_id`,
    `transport_codec_id`, `storage_interval`, `data_expiration`, `device_type`,
    `status`, `create_by`, `create_time`, `update_by`, `update_time`
) VALUES
('bms-chiller', '冷水机组', '冷水机组运行状态、温度、压力、功率及设定值', (SELECT `category_id` FROM `product_categories` WHERE `category_name` = 'BMS楼宇自控' AND `del_flag` = '0' ORDER BY `category_id` LIMIT 1), 'modbus', NULL, 5000, 31536000000, 'gatewayS', 'enable', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bms-ahu', '空气处理机组', 'AHU送回风温度、风机及阀门控制点位', (SELECT `category_id` FROM `product_categories` WHERE `category_name` = 'BMS楼宇自控' AND `del_flag` = '0' ORDER BY `category_id` LIMIT 1), 'modbus', NULL, 5000, 31536000000, 'gatewayS', 'enable', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bms-fcu', '风机盘管', 'FCU运行、房间温度、风速及温度设定', (SELECT `category_id` FROM `product_categories` WHERE `category_name` = 'BMS楼宇自控' AND `del_flag` = '0' ORDER BY `category_id` LIMIT 1), 'modbus', NULL, 5000, 31536000000, 'gatewayS', 'enable', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bms-cooling-tower', '冷却塔', '冷却塔运行、进出水温度、风机速度及功率', (SELECT `category_id` FROM `product_categories` WHERE `category_name` = 'BMS楼宇自控' AND `del_flag` = '0' ORDER BY `category_id` LIMIT 1), 'modbus', NULL, 5000, 31536000000, 'gatewayS', 'enable', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bms-pump', '水泵', '冷冻水泵/冷却水泵频率、压力、流量及功率', (SELECT `category_id` FROM `product_categories` WHERE `category_name` = 'BMS楼宇自控' AND `del_flag` = '0' ORDER BY `category_id` LIMIT 1), 'modbus', NULL, 5000, 31536000000, 'gatewayS', 'enable', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bms-room-sensor', '室内环境传感器', '室内温湿度、CO2及PM2.5环境数据', (SELECT `category_id` FROM `product_categories` WHERE `category_name` = 'BMS楼宇自控' AND `del_flag` = '0' ORDER BY `category_id` LIMIT 1), 'modbus', NULL, 10000, 31536000000, 'gatewayS', 'enable', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bms-lighting-controller', '照明控制器', '照明开关、调光、功率及用电量', (SELECT `category_id` FROM `product_categories` WHERE `category_name` = 'BMS楼宇自控' AND `del_flag` = '0' ORDER BY `category_id` LIMIT 1), 'modbus', NULL, 5000, 31536000000, 'gatewayS', 'enable', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('ems-electric-meter', '智能电表', '电压、电流、有功功率、功率因数、频率及电能', (SELECT `category_id` FROM `product_categories` WHERE `category_name` = 'EMS能源管理' AND `del_flag` = '0' ORDER BY `category_id` LIMIT 1), 'modbus', NULL, 15000, 63072000000, 'gatewayS', 'enable', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('ems-water-meter', '智能水表', '瞬时流量、压力、累计流量及漏水告警', (SELECT `category_id` FROM `product_categories` WHERE `category_name` = 'EMS能源管理' AND `del_flag` = '0' ORDER BY `category_id` LIMIT 1), 'modbus', NULL, 60000, 63072000000, 'gatewayS', 'enable', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('ems-heat-meter', '热量表', '供回水温度、流量、热功率及累计热量', (SELECT `category_id` FROM `product_categories` WHERE `category_name` = 'EMS能源管理' AND `del_flag` = '0' ORDER BY `category_id` LIMIT 1), 'modbus', NULL, 15000, 63072000000, 'gatewayS', 'enable', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('ems-pv-inverter', '光伏逆变器', '直流侧、交流侧、发电量及并网运行状态', (SELECT `category_id` FROM `product_categories` WHERE `category_name` = 'EMS能源管理' AND `del_flag` = '0' ORDER BY `category_id` LIMIT 1), 'modbus', NULL, 15000, 63072000000, 'gatewayS', 'enable', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `description` = VALUES(`description`),
    `product_category_id` = VALUES(`product_category_id`),
    `protocol_id` = VALUES(`protocol_id`),
    `transport_codec_id` = VALUES(`transport_codec_id`),
    `storage_interval` = VALUES(`storage_interval`),
    `data_expiration` = VALUES(`data_expiration`),
    `device_type` = VALUES(`device_type`),
    `status` = VALUES(`status`),
    `update_by` = VALUES(`update_by`),
    `update_time` = CURRENT_TIMESTAMP;

-- -----------------------------------------------------------------------------
-- 4. 各产品物模型
--    define 是产品属性定义；点位的 Modbus 地址在 edge_data_point.config 中维护。
-- -----------------------------------------------------------------------------
INSERT INTO `product_templates` (
    `id`, `product_id`, `classify`, `name`, `telemetry_key`, `description`,
    `type`, `operationTpye`, `define`, `create_by`, `create_time`, `update_by`, `update_time`
) VALUES
-- 冷水机组
('pt-bms-chiller-run-status', 'bms-chiller', 'property', '运行状态', 'run_status', '机组是否运行', 'boolean', 'r', '{"id":"run_status","name":"运行状态","description":"机组是否运行","required":false,"valueType":{"type":"boolean"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-chiller-fault-alarm', 'bms-chiller', 'property', '故障告警', 'fault_alarm', '机组故障告警', 'boolean', 'r', '{"id":"fault_alarm","name":"故障告警","description":"机组故障告警","required":false,"valueType":{"type":"boolean"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-chiller-leaving-water-temp', 'bms-chiller', 'property', '出水温度', 'leaving_water_temp', '冷冻水出水温度，℃', 'float', 'r', '{"id":"leaving_water_temp","name":"出水温度","description":"冷冻水出水温度","required":false,"valueType":{"type":"float"},"expands":{"unit":"℃"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-chiller-entering-water-temp', 'bms-chiller', 'property', '回水温度', 'entering_water_temp', '冷冻水回水温度，℃', 'float', 'r', '{"id":"entering_water_temp","name":"回水温度","description":"冷冻水回水温度","required":false,"valueType":{"type":"float"},"expands":{"unit":"℃"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-chiller-outlet-pressure', 'bms-chiller', 'property', '出水压力', 'outlet_pressure', '冷冻水出水压力，kPa', 'float', 'r', '{"id":"outlet_pressure","name":"出水压力","description":"冷冻水出水压力","required":false,"valueType":{"type":"float"},"expands":{"unit":"kPa"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-chiller-power', 'bms-chiller', 'property', '实时功率', 'power', '机组实时有功功率，kW', 'float', 'r', '{"id":"power","name":"实时功率","description":"机组实时有功功率","required":false,"valueType":{"type":"float"},"expands":{"unit":"kW"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-chiller-energy-total', 'bms-chiller', 'property', '累计电量', 'energy_total', '机组累计电能，kWh', 'double', 'r', '{"id":"energy_total","name":"累计电量","description":"机组累计电能","required":false,"valueType":{"type":"double"},"expands":{"unit":"kWh"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-chiller-setpoint-temp', 'bms-chiller', 'property', '出水温度设定', 'setpoint_temp', '冷冻水出水温度设定值，℃', 'float', 'w', '{"id":"setpoint_temp","name":"出水温度设定","description":"冷冻水出水温度设定值","required":false,"valueType":{"type":"float"},"expands":{"unit":"℃"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),

-- 空气处理机组
('pt-bms-ahu-run-status', 'bms-ahu', 'property', '运行状态', 'run_status', 'AHU是否运行', 'boolean', 'r', '{"id":"run_status","name":"运行状态","description":"AHU是否运行","required":false,"valueType":{"type":"boolean"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-ahu-fault-alarm', 'bms-ahu', 'property', '故障告警', 'fault_alarm', 'AHU故障告警', 'boolean', 'r', '{"id":"fault_alarm","name":"故障告警","description":"AHU故障告警","required":false,"valueType":{"type":"boolean"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-ahu-supply-air-temp', 'bms-ahu', 'property', '送风温度', 'supply_air_temp', '送风温度，℃', 'float', 'r', '{"id":"supply_air_temp","name":"送风温度","description":"送风温度","required":false,"valueType":{"type":"float"},"expands":{"unit":"℃"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-ahu-return-air-temp', 'bms-ahu', 'property', '回风温度', 'return_air_temp', '回风温度，℃', 'float', 'r', '{"id":"return_air_temp","name":"回风温度","description":"回风温度","required":false,"valueType":{"type":"float"},"expands":{"unit":"℃"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-ahu-supply-fan-speed', 'bms-ahu', 'property', '送风机频率', 'supply_fan_speed', '送风机运行频率，Hz', 'float', 'r', '{"id":"supply_fan_speed","name":"送风机频率","description":"送风机运行频率","required":false,"valueType":{"type":"float"},"expands":{"unit":"Hz"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-ahu-valve-output', 'bms-ahu', 'property', '水阀开度', 'valve_output', '冷冻水阀开度，%', 'float', 'w', '{"id":"valve_output","name":"水阀开度","description":"冷冻水阀开度","required":false,"valueType":{"type":"float"},"expands":{"unit":"%"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-ahu-temp-setpoint', 'bms-ahu', 'property', '送风温度设定', 'temp_setpoint', '送风温度设定值，℃', 'float', 'w', '{"id":"temp_setpoint","name":"送风温度设定","description":"送风温度设定值","required":false,"valueType":{"type":"float"},"expands":{"unit":"℃"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),

-- 风机盘管
('pt-bms-fcu-run-status', 'bms-fcu', 'property', '运行状态', 'run_status', 'FCU是否运行', 'boolean', 'r', '{"id":"run_status","name":"运行状态","description":"FCU是否运行","required":false,"valueType":{"type":"boolean"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-fcu-fault-alarm', 'bms-fcu', 'property', '故障告警', 'fault_alarm', 'FCU故障告警', 'boolean', 'r', '{"id":"fault_alarm","name":"故障告警","description":"FCU故障告警","required":false,"valueType":{"type":"boolean"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-fcu-room-temp', 'bms-fcu', 'property', '房间温度', 'room_temp', '房间温度，℃', 'float', 'r', '{"id":"room_temp","name":"房间温度","description":"房间温度","required":false,"valueType":{"type":"float"},"expands":{"unit":"℃"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-fcu-setpoint-temp', 'bms-fcu', 'property', '温度设定', 'setpoint_temp', '房间温度设定值，℃', 'float', 'w', '{"id":"setpoint_temp","name":"温度设定","description":"房间温度设定值","required":false,"valueType":{"type":"float"},"expands":{"unit":"℃"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-fcu-fan-speed', 'bms-fcu', 'property', '风速档位', 'fan_speed', '风机档位，0-3', 'int', 'w', '{"id":"fan_speed","name":"风速档位","description":"风机档位，0-3","required":false,"valueType":{"type":"int"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),

-- 冷却塔
('pt-bms-cooling-tower-run-status', 'bms-cooling-tower', 'property', '运行状态', 'run_status', '冷却塔是否运行', 'boolean', 'r', '{"id":"run_status","name":"运行状态","description":"冷却塔是否运行","required":false,"valueType":{"type":"boolean"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-cooling-tower-fault-alarm', 'bms-cooling-tower', 'property', '故障告警', 'fault_alarm', '冷却塔故障告警', 'boolean', 'r', '{"id":"fault_alarm","name":"故障告警","description":"冷却塔故障告警","required":false,"valueType":{"type":"boolean"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-cooling-tower-entering-water-temp', 'bms-cooling-tower', 'property', '进水温度', 'entering_water_temp', '冷却水进水温度，℃', 'float', 'r', '{"id":"entering_water_temp","name":"进水温度","description":"冷却水进水温度","required":false,"valueType":{"type":"float"},"expands":{"unit":"℃"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-cooling-tower-leaving-water-temp', 'bms-cooling-tower', 'property', '出水温度', 'leaving_water_temp', '冷却水出水温度，℃', 'float', 'r', '{"id":"leaving_water_temp","name":"出水温度","description":"冷却水出水温度","required":false,"valueType":{"type":"float"},"expands":{"unit":"℃"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-cooling-tower-fan-speed', 'bms-cooling-tower', 'property', '风机频率', 'fan_speed', '冷却塔风机频率，Hz', 'float', 'r', '{"id":"fan_speed","name":"风机频率","description":"冷却塔风机频率","required":false,"valueType":{"type":"float"},"expands":{"unit":"Hz"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-cooling-tower-power', 'bms-cooling-tower', 'property', '实时功率', 'power', '冷却塔实时功率，kW', 'float', 'r', '{"id":"power","name":"实时功率","description":"冷却塔实时功率","required":false,"valueType":{"type":"float"},"expands":{"unit":"kW"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),

-- 水泵
('pt-bms-pump-run-status', 'bms-pump', 'property', '运行状态', 'run_status', '水泵是否运行', 'boolean', 'r', '{"id":"run_status","name":"运行状态","description":"水泵是否运行","required":false,"valueType":{"type":"boolean"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-pump-fault-alarm', 'bms-pump', 'property', '故障告警', 'fault_alarm', '水泵故障告警', 'boolean', 'r', '{"id":"fault_alarm","name":"故障告警","description":"水泵故障告警","required":false,"valueType":{"type":"boolean"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-pump-frequency', 'bms-pump', 'property', '运行频率', 'frequency', '水泵运行频率，Hz', 'float', 'r', '{"id":"frequency","name":"运行频率","description":"水泵运行频率","required":false,"valueType":{"type":"float"},"expands":{"unit":"Hz"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-pump-inlet-pressure', 'bms-pump', 'property', '入口压力', 'inlet_pressure', '水泵入口压力，kPa', 'float', 'r', '{"id":"inlet_pressure","name":"入口压力","description":"水泵入口压力","required":false,"valueType":{"type":"float"},"expands":{"unit":"kPa"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-pump-outlet-pressure', 'bms-pump', 'property', '出口压力', 'outlet_pressure', '水泵出口压力，kPa', 'float', 'r', '{"id":"outlet_pressure","name":"出口压力","description":"水泵出口压力","required":false,"valueType":{"type":"float"},"expands":{"unit":"kPa"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-pump-flow-rate', 'bms-pump', 'property', '流量', 'flow_rate', '水泵流量，m³/h', 'float', 'r', '{"id":"flow_rate","name":"流量","description":"水泵流量","required":false,"valueType":{"type":"float"},"expands":{"unit":"m³/h"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-pump-power', 'bms-pump', 'property', '实时功率', 'power', '水泵实时功率，kW', 'float', 'r', '{"id":"power","name":"实时功率","description":"水泵实时功率","required":false,"valueType":{"type":"float"},"expands":{"unit":"kW"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),

-- 室内环境传感器
('pt-bms-room-sensor-room-temp', 'bms-room-sensor', 'property', '室内温度', 'room_temp', '室内温度，℃', 'float', 'r', '{"id":"room_temp","name":"室内温度","description":"室内温度","required":false,"valueType":{"type":"float"},"expands":{"unit":"℃"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-room-sensor-humidity', 'bms-room-sensor', 'property', '相对湿度', 'humidity', '相对湿度，%RH', 'float', 'r', '{"id":"humidity","name":"相对湿度","description":"相对湿度","required":false,"valueType":{"type":"float"},"expands":{"unit":"%RH"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-room-sensor-co2', 'bms-room-sensor', 'property', '二氧化碳', 'co2', 'CO2浓度，ppm', 'int', 'r', '{"id":"co2","name":"二氧化碳","description":"CO2浓度","required":false,"valueType":{"type":"int"},"expands":{"unit":"ppm"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-room-sensor-pm25', 'bms-room-sensor', 'property', 'PM2.5', 'pm25', 'PM2.5浓度，μg/m³', 'int', 'r', '{"id":"pm25","name":"PM2.5","description":"PM2.5浓度","required":false,"valueType":{"type":"int"},"expands":{"unit":"μg/m³"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),

-- 照明控制器
('pt-bms-lighting-on-status', 'bms-lighting-controller', 'property', '开关状态', 'on_status', '照明回路开关状态', 'boolean', 'r', '{"id":"on_status","name":"开关状态","description":"照明回路开关状态","required":false,"valueType":{"type":"boolean"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-lighting-fault-alarm', 'bms-lighting-controller', 'property', '故障告警', 'fault_alarm', '照明控制器故障告警', 'boolean', 'r', '{"id":"fault_alarm","name":"故障告警","description":"照明控制器故障告警","required":false,"valueType":{"type":"boolean"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-lighting-dimming', 'bms-lighting-controller', 'property', '调光值', 'dimming', '调光百分比，0-100%', 'int', 'w', '{"id":"dimming","name":"调光值","description":"调光百分比，0-100","required":false,"valueType":{"type":"int"},"expands":{"unit":"%"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-lighting-power', 'bms-lighting-controller', 'property', '实时功率', 'power', '照明实时功率，kW', 'float', 'r', '{"id":"power","name":"实时功率","description":"照明实时功率","required":false,"valueType":{"type":"float"},"expands":{"unit":"kW"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-bms-lighting-energy-total', 'bms-lighting-controller', 'property', '累计电量', 'energy_total', '照明累计电能，kWh', 'double', 'r', '{"id":"energy_total","name":"累计电量","description":"照明累计电能","required":false,"valueType":{"type":"double"},"expands":{"unit":"kWh"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),

-- 智能电表
('pt-ems-electric-voltage', 'ems-electric-meter', 'property', '电压', 'voltage', '线电压/相电压，V', 'float', 'r', '{"id":"voltage","name":"电压","description":"线电压或相电压","required":false,"valueType":{"type":"float"},"expands":{"unit":"V"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-ems-electric-current', 'ems-electric-meter', 'property', '电流', 'current', '回路电流，A', 'float', 'r', '{"id":"current","name":"电流","description":"回路电流","required":false,"valueType":{"type":"float"},"expands":{"unit":"A"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-ems-electric-active-power', 'ems-electric-meter', 'property', '有功功率', 'active_power', '实时有功功率，kW', 'float', 'r', '{"id":"active_power","name":"有功功率","description":"实时有功功率","required":false,"valueType":{"type":"float"},"expands":{"unit":"kW"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-ems-electric-power-factor', 'ems-electric-meter', 'property', '功率因数', 'power_factor', '功率因数', 'float', 'r', '{"id":"power_factor","name":"功率因数","description":"功率因数","required":false,"valueType":{"type":"float"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-ems-electric-frequency', 'ems-electric-meter', 'property', '频率', 'frequency', '交流频率，Hz', 'float', 'r', '{"id":"frequency","name":"频率","description":"交流频率","required":false,"valueType":{"type":"float"},"expands":{"unit":"Hz"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-ems-electric-forward-energy', 'ems-electric-meter', 'property', '正向有功电能', 'forward_energy', '正向累计有功电能，kWh', 'double', 'r', '{"id":"forward_energy","name":"正向有功电能","description":"正向累计有功电能","required":false,"valueType":{"type":"double"},"expands":{"unit":"kWh"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-ems-electric-reverse-energy', 'ems-electric-meter', 'property', '反向有功电能', 'reverse_energy', '反向累计有功电能，kWh', 'double', 'r', '{"id":"reverse_energy","name":"反向有功电能","description":"反向累计有功电能","required":false,"valueType":{"type":"double"},"expands":{"unit":"kWh"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),

-- 智能水表
('pt-ems-water-flow-rate', 'ems-water-meter', 'property', '瞬时流量', 'flow_rate', '瞬时流量，m³/h', 'float', 'r', '{"id":"flow_rate","name":"瞬时流量","description":"瞬时流量","required":false,"valueType":{"type":"float"},"expands":{"unit":"m³/h"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-ems-water-pressure', 'ems-water-meter', 'property', '管网压力', 'pressure', '管网压力，kPa', 'float', 'r', '{"id":"pressure","name":"管网压力","description":"管网压力","required":false,"valueType":{"type":"float"},"expands":{"unit":"kPa"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-ems-water-total-flow', 'ems-water-meter', 'property', '累计流量', 'total_flow', '累计用水量，m³', 'double', 'r', '{"id":"total_flow","name":"累计流量","description":"累计用水量","required":false,"valueType":{"type":"double"},"expands":{"unit":"m³"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-ems-water-leak-alarm', 'ems-water-meter', 'property', '漏水告警', 'leak_alarm', '漏水或异常用水告警', 'boolean', 'r', '{"id":"leak_alarm","name":"漏水告警","description":"漏水或异常用水告警","required":false,"valueType":{"type":"boolean"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),

-- 热量表
('pt-ems-heat-supply-temp', 'ems-heat-meter', 'property', '供水温度', 'supply_temp', '供水温度，℃', 'float', 'r', '{"id":"supply_temp","name":"供水温度","description":"供水温度","required":false,"valueType":{"type":"float"},"expands":{"unit":"℃"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-ems-heat-return-temp', 'ems-heat-meter', 'property', '回水温度', 'return_temp', '回水温度，℃', 'float', 'r', '{"id":"return_temp","name":"回水温度","description":"回水温度","required":false,"valueType":{"type":"float"},"expands":{"unit":"℃"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-ems-heat-flow-rate', 'ems-heat-meter', 'property', '流量', 'flow_rate', '热水流量，m³/h', 'float', 'r', '{"id":"flow_rate","name":"流量","description":"热水流量","required":false,"valueType":{"type":"float"},"expands":{"unit":"m³/h"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-ems-heat-power', 'ems-heat-meter', 'property', '热功率', 'heat_power', '瞬时热功率，kW', 'float', 'r', '{"id":"heat_power","name":"热功率","description":"瞬时热功率","required":false,"valueType":{"type":"float"},"expands":{"unit":"kW"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-ems-heat-total', 'ems-heat-meter', 'property', '累计热量', 'heat_total', '累计热量，GJ', 'double', 'r', '{"id":"heat_total","name":"累计热量","description":"累计热量","required":false,"valueType":{"type":"double"},"expands":{"unit":"GJ"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-ems-heat-alarm', 'ems-heat-meter', 'property', '故障告警', 'alarm', '热量表故障告警', 'boolean', 'r', '{"id":"alarm","name":"故障告警","description":"热量表故障告警","required":false,"valueType":{"type":"boolean"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),

-- 光伏逆变器
('pt-ems-pv-run-status', 'ems-pv-inverter', 'property', '运行状态', 'run_status', '逆变器是否并网运行', 'boolean', 'r', '{"id":"run_status","name":"运行状态","description":"逆变器是否并网运行","required":false,"valueType":{"type":"boolean"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-ems-pv-fault-alarm', 'ems-pv-inverter', 'property', '故障告警', 'fault_alarm', '逆变器故障告警', 'boolean', 'r', '{"id":"fault_alarm","name":"故障告警","description":"逆变器故障告警","required":false,"valueType":{"type":"boolean"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-ems-pv-dc-voltage', 'ems-pv-inverter', 'property', '直流电压', 'dc_voltage', '光伏侧直流电压，V', 'float', 'r', '{"id":"dc_voltage","name":"直流电压","description":"光伏侧直流电压","required":false,"valueType":{"type":"float"},"expands":{"unit":"V"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-ems-pv-dc-current', 'ems-pv-inverter', 'property', '直流电流', 'dc_current', '光伏侧直流电流，A', 'float', 'r', '{"id":"dc_current","name":"直流电流","description":"光伏侧直流电流","required":false,"valueType":{"type":"float"},"expands":{"unit":"A"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-ems-pv-ac-power', 'ems-pv-inverter', 'property', '交流功率', 'ac_power', '逆变器交流侧功率，kW', 'float', 'r', '{"id":"ac_power","name":"交流功率","description":"逆变器交流侧功率","required":false,"valueType":{"type":"float"},"expands":{"unit":"kW"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-ems-pv-daily-energy', 'ems-pv-inverter', 'property', '日发电量', 'daily_energy', '当日发电量，kWh', 'double', 'r', '{"id":"daily_energy","name":"日发电量","description":"当日发电量","required":false,"valueType":{"type":"double"},"expands":{"unit":"kWh"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-ems-pv-total-energy', 'ems-pv-inverter', 'property', '累计发电量', 'total_energy', '累计发电量，kWh', 'double', 'r', '{"id":"total_energy","name":"累计发电量","description":"累计发电量","required":false,"valueType":{"type":"double"},"expands":{"unit":"kWh"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('pt-ems-pv-grid-frequency', 'ems-pv-inverter', 'property', '并网频率', 'grid_frequency', '并网交流频率，Hz', 'float', 'r', '{"id":"grid_frequency","name":"并网频率","description":"并网交流频率","required":false,"valueType":{"type":"float"},"expands":{"unit":"Hz"}}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE
    `product_id` = VALUES(`product_id`),
    `classify` = VALUES(`classify`),
    `name` = VALUES(`name`),
    `telemetry_key` = VALUES(`telemetry_key`),
    `description` = VALUES(`description`),
    `type` = VALUES(`type`),
    `operationTpye` = VALUES(`operationTpye`),
    `define` = VALUES(`define`),
    `update_by` = VALUES(`update_by`),
    `update_time` = CURRENT_TIMESTAMP;

-- -----------------------------------------------------------------------------
-- 5. 示例 Modbus TCP 网关和常见设备
--    一个网关对应一个 Modbus TCP 服务器/Unit ID；实际多从站场景建议按从站拆分网关。
-- -----------------------------------------------------------------------------
INSERT INTO `edge_device` (
    `id`, `name`, `status`, `link_status`, `protocol_id`, `configuration`,
    `description`, `status_time`, `create_by`, `create_time`, `update_by`, `update_time`
) VALUES (
    'edge-bms-modbus-demo',
    'BMS/EMS Modbus TCP示例网关',
    'disable',
    'offline',
    'modbus',
    '{"ip_address":"127.0.0.1","port":502,"slave_id":1,"timeout":3000,"refresh_interval":5000,"connect_interval":30000,"max_block_size":125,"max_bit_block_size":2000,"max_block_gap":2,"max_in_flight_requests":1,"retry_attempts":2,"retry_backoff":200,"byte_order":"BIG_ENDIAN"}',
    '示例网关；请修改IP、端口和Unit ID后再启用',
    NULL,
    'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP
)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `status` = VALUES(`status`),
    `protocol_id` = VALUES(`protocol_id`),
    `configuration` = VALUES(`configuration`),
    `description` = VALUES(`description`),
    `update_by` = VALUES(`update_by`),
    `update_time` = CURRENT_TIMESTAMP;

INSERT INTO `devices` (
    `id`, `name`, `alias`, `product_id`, `description`, `status`, `ext`,
    `gateway_id`, `device_type`, `link_status`, `create_by`, `create_time`,
    `update_by`, `update_time`
) VALUES
('device-bms-chiller-01', '1号冷水机组', 'CH-01', 'bms-chiller', 'BMS示例冷水机组', 'enable', '{"manufacturer":"示例","model":"CHILLER-DEMO","slave_id":1}', 'edge-bms-modbus-demo', 'gatewayS', 'offline', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('device-bms-ahu-01', '1号空气处理机组', 'AHU-01', 'bms-ahu', 'BMS示例空气处理机组', 'enable', '{"manufacturer":"示例","model":"AHU-DEMO","slave_id":1}', 'edge-bms-modbus-demo', 'gatewayS', 'offline', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('device-bms-fcu-01', '101房间风机盘管', 'FCU-101', 'bms-fcu', 'BMS示例风机盘管', 'enable', '{"manufacturer":"示例","model":"FCU-DEMO","slave_id":1}', 'edge-bms-modbus-demo', 'gatewayS', 'offline', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('device-bms-cooling-tower-01', '1号冷却塔', 'CT-01', 'bms-cooling-tower', 'BMS示例冷却塔', 'enable', '{"manufacturer":"示例","model":"CT-DEMO","slave_id":1}', 'edge-bms-modbus-demo', 'gatewayS', 'offline', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('device-bms-pump-01', '1号冷冻水泵', 'P-CHW-01', 'bms-pump', 'BMS示例水泵', 'enable', '{"manufacturer":"示例","model":"PUMP-DEMO","slave_id":1}', 'edge-bms-modbus-demo', 'gatewayS', 'offline', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('device-bms-room-sensor-101', '101房间环境传感器', 'RS-101', 'bms-room-sensor', 'BMS示例室内环境传感器', 'enable', '{"manufacturer":"示例","model":"SENSOR-DEMO","slave_id":1}', 'edge-bms-modbus-demo', 'gatewayS', 'offline', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('device-bms-lighting-1f', '1层照明控制器', 'LC-1F', 'bms-lighting-controller', 'BMS示例照明控制器', 'enable', '{"manufacturer":"示例","model":"LIGHT-DEMO","slave_id":1}', 'edge-bms-modbus-demo', 'gatewayS', 'offline', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('device-ems-electric-meter-01', '总配电房智能电表', 'EM-01', 'ems-electric-meter', 'EMS示例智能电表', 'enable', '{"manufacturer":"示例","model":"METER-E-DEMO","slave_id":1}', 'edge-bms-modbus-demo', 'gatewayS', 'offline', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('device-ems-water-meter-01', '总进水智能水表', 'WM-01', 'ems-water-meter', 'EMS示例智能水表', 'enable', '{"manufacturer":"示例","model":"METER-W-DEMO","slave_id":1}', 'edge-bms-modbus-demo', 'gatewayS', 'offline', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('device-ems-heat-meter-01', '换热站热量表', 'HM-01', 'ems-heat-meter', 'EMS示例热量表', 'enable', '{"manufacturer":"示例","model":"METER-H-DEMO","slave_id":1}', 'edge-bms-modbus-demo', 'gatewayS', 'offline', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('device-ems-pv-inverter-01', '屋顶光伏逆变器', 'PV-INV-01', 'ems-pv-inverter', 'EMS示例光伏逆变器', 'enable', '{"manufacturer":"示例","model":"PV-DEMO","slave_id":1}', 'edge-bms-modbus-demo', 'gatewayS', 'offline', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `alias` = VALUES(`alias`),
    `product_id` = VALUES(`product_id`),
    `description` = VALUES(`description`),
    `status` = VALUES(`status`),
    `ext` = VALUES(`ext`),
    `gateway_id` = VALUES(`gateway_id`),
    `device_type` = VALUES(`device_type`),
    `link_status` = VALUES(`link_status`),
    `update_by` = VALUES(`update_by`),
    `update_time` = CURRENT_TIMESTAMP;

-- -----------------------------------------------------------------------------
-- 6. 示例网关点位
--    float=2个16位寄存器，double=4个16位寄存器，boolean=1个位，int=1个寄存器。
-- -----------------------------------------------------------------------------
INSERT INTO `edge_data_point` (
    `id`, `name`, `protocol_id`, `gateway_id`, `type`, `operationTpye`, `config`,
    `create_by`, `create_time`, `update_by`, `update_time`
) VALUES
-- 冷水机组：coil/discrete/input/holding
('edp-bms-chiller-run-status', '冷水机组运行状态', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{"register_type":"coil","offset":0,"quantity":1}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-chiller-fault-alarm', '冷水机组故障告警', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{"register_type":"discrete","offset":1,"quantity":1}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-chiller-leaving-water-temp', '冷水机组出水温度', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":0,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-chiller-entering-water-temp', '冷水机组回水温度', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":2,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-chiller-outlet-pressure', '冷水机组出水压力', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":4,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-chiller-power', '冷水机组实时功率', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":6,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-chiller-energy-total', '冷水机组累计电量', 'modbus', 'edge-bms-modbus-demo', 'double', 'r', '{"register_type":"input","offset":8,"quantity":4}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-chiller-setpoint-temp', '冷水机组出水温度设定', 'modbus', 'edge-bms-modbus-demo', 'float', 'w', '{"register_type":"holding","offset":12,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
-- 空气处理机组
('edp-bms-ahu-run-status', 'AHU运行状态', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{"register_type":"coil","offset":32,"quantity":1}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-ahu-fault-alarm', 'AHU故障告警', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{"register_type":"discrete","offset":33,"quantity":1}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-ahu-supply-air-temp', 'AHU送风温度', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":32,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-ahu-return-air-temp', 'AHU回风温度', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":34,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-ahu-supply-fan-speed', 'AHU送风机频率', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":36,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-ahu-valve-output', 'AHU水阀开度', 'modbus', 'edge-bms-modbus-demo', 'float', 'w', '{"register_type":"holding","offset":38,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-ahu-temp-setpoint', 'AHU送风温度设定', 'modbus', 'edge-bms-modbus-demo', 'float', 'w', '{"register_type":"holding","offset":40,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
-- 风机盘管
('edp-bms-fcu-run-status', 'FCU运行状态', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{"register_type":"coil","offset":48,"quantity":1}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-fcu-fault-alarm', 'FCU故障告警', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{"register_type":"discrete","offset":49,"quantity":1}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-fcu-room-temp', 'FCU房间温度', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":48,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-fcu-setpoint-temp', 'FCU温度设定', 'modbus', 'edge-bms-modbus-demo', 'float', 'w', '{"register_type":"holding","offset":50,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-fcu-fan-speed', 'FCU风速档位', 'modbus', 'edge-bms-modbus-demo', 'int', 'w', '{"register_type":"holding","offset":52,"quantity":1}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
-- 冷却塔
('edp-bms-cooling-tower-run-status', '冷却塔运行状态', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{"register_type":"coil","offset":56,"quantity":1}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-cooling-tower-fault-alarm', '冷却塔故障告警', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{"register_type":"discrete","offset":57,"quantity":1}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-cooling-tower-entering-water-temp', '冷却塔进水温度', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":56,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-cooling-tower-leaving-water-temp', '冷却塔出水温度', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":58,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-cooling-tower-fan-speed', '冷却塔风机频率', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":60,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-cooling-tower-power', '冷却塔实时功率', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":62,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
-- 水泵
('edp-bms-pump-run-status', '水泵运行状态', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{"register_type":"coil","offset":64,"quantity":1}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-pump-fault-alarm', '水泵故障告警', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{"register_type":"discrete","offset":65,"quantity":1}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-pump-frequency', '水泵运行频率', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":64,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-pump-inlet-pressure', '水泵入口压力', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":66,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-pump-outlet-pressure', '水泵出口压力', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":68,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-pump-flow-rate', '水泵流量', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":70,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-pump-power', '水泵实时功率', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":72,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
-- 室内环境传感器
('edp-bms-room-sensor-room-temp', '101房间室内温度', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":76,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-room-sensor-humidity', '101房间相对湿度', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":78,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-room-sensor-co2', '101房间CO2', 'modbus', 'edge-bms-modbus-demo', 'int', 'r', '{"register_type":"input","offset":80,"quantity":1}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-room-sensor-pm25', '101房间PM2.5', 'modbus', 'edge-bms-modbus-demo', 'int', 'r', '{"register_type":"input","offset":81,"quantity":1}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
-- 照明控制器
('edp-bms-lighting-on-status', '1层照明开关状态', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{"register_type":"coil","offset":80,"quantity":1}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-lighting-fault-alarm', '1层照明故障告警', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{"register_type":"discrete","offset":81,"quantity":1}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-lighting-dimming', '1层照明调光值', 'modbus', 'edge-bms-modbus-demo', 'int', 'w', '{"register_type":"holding","offset":82,"quantity":1}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-lighting-power', '1层照明实时功率', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":83,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-bms-lighting-energy-total', '1层照明累计电量', 'modbus', 'edge-bms-modbus-demo', 'double', 'r', '{"register_type":"input","offset":85,"quantity":4}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
-- 智能电表
('edp-ems-electric-voltage', '总表电压', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":90,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-ems-electric-current', '总表电流', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":92,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-ems-electric-active-power', '总表有功功率', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":94,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-ems-electric-power-factor', '总表功率因数', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":96,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-ems-electric-frequency', '总表频率', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":98,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-ems-electric-forward-energy', '总表正向有功电能', 'modbus', 'edge-bms-modbus-demo', 'double', 'r', '{"register_type":"input","offset":100,"quantity":4}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-ems-electric-reverse-energy', '总表反向有功电能', 'modbus', 'edge-bms-modbus-demo', 'double', 'r', '{"register_type":"input","offset":104,"quantity":4}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
-- 智能水表
('edp-ems-water-flow-rate', '总进水瞬时流量', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":108,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-ems-water-pressure', '总进水管网压力', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":110,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-ems-water-total-flow', '总进水累计流量', 'modbus', 'edge-bms-modbus-demo', 'double', 'r', '{"register_type":"input","offset":112,"quantity":4}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-ems-water-leak-alarm', '总进水漏水告警', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{"register_type":"discrete","offset":83,"quantity":1}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
-- 热量表
('edp-ems-heat-supply-temp', '换热站供水温度', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":116,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-ems-heat-return-temp', '换热站回水温度', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":118,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-ems-heat-flow-rate', '换热站流量', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":120,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-ems-heat-power', '换热站热功率', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":122,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-ems-heat-total', '换热站累计热量', 'modbus', 'edge-bms-modbus-demo', 'double', 'r', '{"register_type":"input","offset":124,"quantity":4}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-ems-heat-alarm', '热量表故障告警', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{"register_type":"discrete","offset":84,"quantity":1}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
-- 光伏逆变器
('edp-ems-pv-run-status', '逆变器运行状态', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{"register_type":"coil","offset":88,"quantity":1}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-ems-pv-fault-alarm', '逆变器故障告警', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{"register_type":"discrete","offset":89,"quantity":1}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-ems-pv-dc-voltage', '逆变器直流电压', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":128,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-ems-pv-dc-current', '逆变器直流电流', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":130,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-ems-pv-ac-power', '逆变器交流功率', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":132,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-ems-pv-daily-energy', '逆变器日发电量', 'modbus', 'edge-bms-modbus-demo', 'double', 'r', '{"register_type":"input","offset":134,"quantity":4}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-ems-pv-total-energy', '逆变器累计发电量', 'modbus', 'edge-bms-modbus-demo', 'double', 'r', '{"register_type":"input","offset":138,"quantity":4}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('edp-ems-pv-grid-frequency', '逆变器并网频率', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{"register_type":"input","offset":142,"quantity":2}', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `protocol_id` = VALUES(`protocol_id`),
    `gateway_id` = VALUES(`gateway_id`),
    `type` = VALUES(`type`),
    `operationTpye` = VALUES(`operationTpye`),
    `config` = VALUES(`config`),
    `update_by` = VALUES(`update_by`),
    `update_time` = CURRENT_TIMESTAMP;

-- -----------------------------------------------------------------------------
-- 7. 示例设备属性与 Modbus 点位绑定
-- -----------------------------------------------------------------------------
INSERT INTO `device_binding` (
    `id`, `product_id`, `device_id`, `product_template_id`, `telemetry_key`,
    `gateway_id`, `gateway_name`, `edge_point_id`, `edge_point_name`, `data_type`,
    `unit_symbol`, `create_by`, `create_time`, `update_by`, `update_time`
) VALUES
-- 冷水机组
('bind-bms-chiller-run-status', 'bms-chiller', 'device-bms-chiller-01', 'pt-bms-chiller-run-status', 'run_status', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-chiller-run-status', '冷水机组运行状态', 'boolean', NULL, 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-chiller-fault-alarm', 'bms-chiller', 'device-bms-chiller-01', 'pt-bms-chiller-fault-alarm', 'fault_alarm', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-chiller-fault-alarm', '冷水机组故障告警', 'boolean', NULL, 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-chiller-leaving-water-temp', 'bms-chiller', 'device-bms-chiller-01', 'pt-bms-chiller-leaving-water-temp', 'leaving_water_temp', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-chiller-leaving-water-temp', '冷水机组出水温度', 'float', '℃', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-chiller-entering-water-temp', 'bms-chiller', 'device-bms-chiller-01', 'pt-bms-chiller-entering-water-temp', 'entering_water_temp', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-chiller-entering-water-temp', '冷水机组回水温度', 'float', '℃', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-chiller-outlet-pressure', 'bms-chiller', 'device-bms-chiller-01', 'pt-bms-chiller-outlet-pressure', 'outlet_pressure', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-chiller-outlet-pressure', '冷水机组出水压力', 'float', 'kPa', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-chiller-power', 'bms-chiller', 'device-bms-chiller-01', 'pt-bms-chiller-power', 'power', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-chiller-power', '冷水机组实时功率', 'float', 'kW', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-chiller-energy-total', 'bms-chiller', 'device-bms-chiller-01', 'pt-bms-chiller-energy-total', 'energy_total', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-chiller-energy-total', '冷水机组累计电量', 'double', 'kWh', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-chiller-setpoint-temp', 'bms-chiller', 'device-bms-chiller-01', 'pt-bms-chiller-setpoint-temp', 'setpoint_temp', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-chiller-setpoint-temp', '冷水机组出水温度设定', 'float', '℃', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
-- 空气处理机组
('bind-bms-ahu-run-status', 'bms-ahu', 'device-bms-ahu-01', 'pt-bms-ahu-run-status', 'run_status', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-ahu-run-status', 'AHU运行状态', 'boolean', NULL, 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-ahu-fault-alarm', 'bms-ahu', 'device-bms-ahu-01', 'pt-bms-ahu-fault-alarm', 'fault_alarm', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-ahu-fault-alarm', 'AHU故障告警', 'boolean', NULL, 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-ahu-supply-air-temp', 'bms-ahu', 'device-bms-ahu-01', 'pt-bms-ahu-supply-air-temp', 'supply_air_temp', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-ahu-supply-air-temp', 'AHU送风温度', 'float', '℃', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-ahu-return-air-temp', 'bms-ahu', 'device-bms-ahu-01', 'pt-bms-ahu-return-air-temp', 'return_air_temp', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-ahu-return-air-temp', 'AHU回风温度', 'float', '℃', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-ahu-supply-fan-speed', 'bms-ahu', 'device-bms-ahu-01', 'pt-bms-ahu-supply-fan-speed', 'supply_fan_speed', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-ahu-supply-fan-speed', 'AHU送风机频率', 'float', 'Hz', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-ahu-valve-output', 'bms-ahu', 'device-bms-ahu-01', 'pt-bms-ahu-valve-output', 'valve_output', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-ahu-valve-output', 'AHU水阀开度', 'float', '%', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-ahu-temp-setpoint', 'bms-ahu', 'device-bms-ahu-01', 'pt-bms-ahu-temp-setpoint', 'temp_setpoint', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-ahu-temp-setpoint', 'AHU送风温度设定', 'float', '℃', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
-- 风机盘管
('bind-bms-fcu-run-status', 'bms-fcu', 'device-bms-fcu-01', 'pt-bms-fcu-run-status', 'run_status', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-fcu-run-status', 'FCU运行状态', 'boolean', NULL, 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-fcu-fault-alarm', 'bms-fcu', 'device-bms-fcu-01', 'pt-bms-fcu-fault-alarm', 'fault_alarm', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-fcu-fault-alarm', 'FCU故障告警', 'boolean', NULL, 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-fcu-room-temp', 'bms-fcu', 'device-bms-fcu-01', 'pt-bms-fcu-room-temp', 'room_temp', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-fcu-room-temp', 'FCU房间温度', 'float', '℃', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-fcu-setpoint-temp', 'bms-fcu', 'device-bms-fcu-01', 'pt-bms-fcu-setpoint-temp', 'setpoint_temp', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-fcu-setpoint-temp', 'FCU温度设定', 'float', '℃', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-fcu-fan-speed', 'bms-fcu', 'device-bms-fcu-01', 'pt-bms-fcu-fan-speed', 'fan_speed', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-fcu-fan-speed', 'FCU风速档位', 'int', NULL, 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
-- 冷却塔
('bind-bms-cooling-tower-run-status', 'bms-cooling-tower', 'device-bms-cooling-tower-01', 'pt-bms-cooling-tower-run-status', 'run_status', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-cooling-tower-run-status', '冷却塔运行状态', 'boolean', NULL, 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-cooling-tower-fault-alarm', 'bms-cooling-tower', 'device-bms-cooling-tower-01', 'pt-bms-cooling-tower-fault-alarm', 'fault_alarm', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-cooling-tower-fault-alarm', '冷却塔故障告警', 'boolean', NULL, 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-cooling-tower-entering-water-temp', 'bms-cooling-tower', 'device-bms-cooling-tower-01', 'pt-bms-cooling-tower-entering-water-temp', 'entering_water_temp', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-cooling-tower-entering-water-temp', '冷却塔进水温度', 'float', '℃', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-cooling-tower-leaving-water-temp', 'bms-cooling-tower', 'device-bms-cooling-tower-01', 'pt-bms-cooling-tower-leaving-water-temp', 'leaving_water_temp', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-cooling-tower-leaving-water-temp', '冷却塔出水温度', 'float', '℃', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-cooling-tower-fan-speed', 'bms-cooling-tower', 'device-bms-cooling-tower-01', 'pt-bms-cooling-tower-fan-speed', 'fan_speed', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-cooling-tower-fan-speed', '冷却塔风机频率', 'float', 'Hz', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-cooling-tower-power', 'bms-cooling-tower', 'device-bms-cooling-tower-01', 'pt-bms-cooling-tower-power', 'power', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-cooling-tower-power', '冷却塔实时功率', 'float', 'kW', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
-- 水泵
('bind-bms-pump-run-status', 'bms-pump', 'device-bms-pump-01', 'pt-bms-pump-run-status', 'run_status', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-pump-run-status', '水泵运行状态', 'boolean', NULL, 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-pump-fault-alarm', 'bms-pump', 'device-bms-pump-01', 'pt-bms-pump-fault-alarm', 'fault_alarm', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-pump-fault-alarm', '水泵故障告警', 'boolean', NULL, 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-pump-frequency', 'bms-pump', 'device-bms-pump-01', 'pt-bms-pump-frequency', 'frequency', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-pump-frequency', '水泵运行频率', 'float', 'Hz', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-pump-inlet-pressure', 'bms-pump', 'device-bms-pump-01', 'pt-bms-pump-inlet-pressure', 'inlet_pressure', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-pump-inlet-pressure', '水泵入口压力', 'float', 'kPa', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-pump-outlet-pressure', 'bms-pump', 'device-bms-pump-01', 'pt-bms-pump-outlet-pressure', 'outlet_pressure', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-pump-outlet-pressure', '水泵出口压力', 'float', 'kPa', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-pump-flow-rate', 'bms-pump', 'device-bms-pump-01', 'pt-bms-pump-flow-rate', 'flow_rate', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-pump-flow-rate', '水泵流量', 'float', 'm³/h', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-pump-power', 'bms-pump', 'device-bms-pump-01', 'pt-bms-pump-power', 'power', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-pump-power', '水泵实时功率', 'float', 'kW', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
-- 室内环境传感器
('bind-bms-room-sensor-room-temp', 'bms-room-sensor', 'device-bms-room-sensor-101', 'pt-bms-room-sensor-room-temp', 'room_temp', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-room-sensor-room-temp', '101房间室内温度', 'float', '℃', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-room-sensor-humidity', 'bms-room-sensor', 'device-bms-room-sensor-101', 'pt-bms-room-sensor-humidity', 'humidity', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-room-sensor-humidity', '101房间相对湿度', 'float', '%RH', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-room-sensor-co2', 'bms-room-sensor', 'device-bms-room-sensor-101', 'pt-bms-room-sensor-co2', 'co2', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-room-sensor-co2', '101房间CO2', 'int', 'ppm', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-room-sensor-pm25', 'bms-room-sensor', 'device-bms-room-sensor-101', 'pt-bms-room-sensor-pm25', 'pm25', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-room-sensor-pm25', '101房间PM2.5', 'int', 'μg/m³', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
-- 照明控制器
('bind-bms-lighting-on-status', 'bms-lighting-controller', 'device-bms-lighting-1f', 'pt-bms-lighting-on-status', 'on_status', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-lighting-on-status', '1层照明开关状态', 'boolean', NULL, 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-lighting-fault-alarm', 'bms-lighting-controller', 'device-bms-lighting-1f', 'pt-bms-lighting-fault-alarm', 'fault_alarm', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-lighting-fault-alarm', '1层照明故障告警', 'boolean', NULL, 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-lighting-dimming', 'bms-lighting-controller', 'device-bms-lighting-1f', 'pt-bms-lighting-dimming', 'dimming', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-lighting-dimming', '1层照明调光值', 'int', '%', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-lighting-power', 'bms-lighting-controller', 'device-bms-lighting-1f', 'pt-bms-lighting-power', 'power', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-lighting-power', '1层照明实时功率', 'float', 'kW', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-bms-lighting-energy-total', 'bms-lighting-controller', 'device-bms-lighting-1f', 'pt-bms-lighting-energy-total', 'energy_total', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-lighting-energy-total', '1层照明累计电量', 'double', 'kWh', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
-- 智能电表
('bind-ems-electric-voltage', 'ems-electric-meter', 'device-ems-electric-meter-01', 'pt-ems-electric-voltage', 'voltage', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-electric-voltage', '总表电压', 'float', 'V', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-ems-electric-current', 'ems-electric-meter', 'device-ems-electric-meter-01', 'pt-ems-electric-current', 'current', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-electric-current', '总表电流', 'float', 'A', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-ems-electric-active-power', 'ems-electric-meter', 'device-ems-electric-meter-01', 'pt-ems-electric-active-power', 'active_power', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-electric-active-power', '总表有功功率', 'float', 'kW', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-ems-electric-power-factor', 'ems-electric-meter', 'device-ems-electric-meter-01', 'pt-ems-electric-power-factor', 'power_factor', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-electric-power-factor', '总表功率因数', 'float', NULL, 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-ems-electric-frequency', 'ems-electric-meter', 'device-ems-electric-meter-01', 'pt-ems-electric-frequency', 'frequency', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-electric-frequency', '总表频率', 'float', 'Hz', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-ems-electric-forward-energy', 'ems-electric-meter', 'device-ems-electric-meter-01', 'pt-ems-electric-forward-energy', 'forward_energy', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-electric-forward-energy', '总表正向有功电能', 'double', 'kWh', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-ems-electric-reverse-energy', 'ems-electric-meter', 'device-ems-electric-meter-01', 'pt-ems-electric-reverse-energy', 'reverse_energy', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-electric-reverse-energy', '总表反向有功电能', 'double', 'kWh', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
-- 智能水表
('bind-ems-water-flow-rate', 'ems-water-meter', 'device-ems-water-meter-01', 'pt-ems-water-flow-rate', 'flow_rate', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-water-flow-rate', '总进水瞬时流量', 'float', 'm³/h', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-ems-water-pressure', 'ems-water-meter', 'device-ems-water-meter-01', 'pt-ems-water-pressure', 'pressure', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-water-pressure', '总进水管网压力', 'float', 'kPa', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-ems-water-total-flow', 'ems-water-meter', 'device-ems-water-meter-01', 'pt-ems-water-total-flow', 'total_flow', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-water-total-flow', '总进水累计流量', 'double', 'm³', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-ems-water-leak-alarm', 'ems-water-meter', 'device-ems-water-meter-01', 'pt-ems-water-leak-alarm', 'leak_alarm', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-water-leak-alarm', '总进水漏水告警', 'boolean', NULL, 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
-- 热量表
('bind-ems-heat-supply-temp', 'ems-heat-meter', 'device-ems-heat-meter-01', 'pt-ems-heat-supply-temp', 'supply_temp', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-heat-supply-temp', '换热站供水温度', 'float', '℃', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-ems-heat-return-temp', 'ems-heat-meter', 'device-ems-heat-meter-01', 'pt-ems-heat-return-temp', 'return_temp', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-heat-return-temp', '换热站回水温度', 'float', '℃', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-ems-heat-flow-rate', 'ems-heat-meter', 'device-ems-heat-meter-01', 'pt-ems-heat-flow-rate', 'flow_rate', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-heat-flow-rate', '换热站流量', 'float', 'm³/h', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-ems-heat-power', 'ems-heat-meter', 'device-ems-heat-meter-01', 'pt-ems-heat-power', 'heat_power', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-heat-power', '换热站热功率', 'float', 'kW', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-ems-heat-total', 'ems-heat-meter', 'device-ems-heat-meter-01', 'pt-ems-heat-total', 'heat_total', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-heat-total', '换热站累计热量', 'double', 'GJ', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-ems-heat-alarm', 'ems-heat-meter', 'device-ems-heat-meter-01', 'pt-ems-heat-alarm', 'alarm', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-heat-alarm', '热量表故障告警', 'boolean', NULL, 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
-- 光伏逆变器
('bind-ems-pv-run-status', 'ems-pv-inverter', 'device-ems-pv-inverter-01', 'pt-ems-pv-run-status', 'run_status', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-pv-run-status', '逆变器运行状态', 'boolean', NULL, 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-ems-pv-fault-alarm', 'ems-pv-inverter', 'device-ems-pv-inverter-01', 'pt-ems-pv-fault-alarm', 'fault_alarm', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-pv-fault-alarm', '逆变器故障告警', 'boolean', NULL, 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-ems-pv-dc-voltage', 'ems-pv-inverter', 'device-ems-pv-inverter-01', 'pt-ems-pv-dc-voltage', 'dc_voltage', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-pv-dc-voltage', '逆变器直流电压', 'float', 'V', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-ems-pv-dc-current', 'ems-pv-inverter', 'device-ems-pv-inverter-01', 'pt-ems-pv-dc-current', 'dc_current', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-pv-dc-current', '逆变器直流电流', 'float', 'A', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-ems-pv-ac-power', 'ems-pv-inverter', 'device-ems-pv-inverter-01', 'pt-ems-pv-ac-power', 'ac_power', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-pv-ac-power', '逆变器交流功率', 'float', 'kW', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-ems-pv-daily-energy', 'ems-pv-inverter', 'device-ems-pv-inverter-01', 'pt-ems-pv-daily-energy', 'daily_energy', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-pv-daily-energy', '逆变器日发电量', 'double', 'kWh', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-ems-pv-total-energy', 'ems-pv-inverter', 'device-ems-pv-inverter-01', 'pt-ems-pv-total-energy', 'total_energy', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-pv-total-energy', '逆变器累计发电量', 'double', 'kWh', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP),
('bind-ems-pv-grid-frequency', 'ems-pv-inverter', 'device-ems-pv-inverter-01', 'pt-ems-pv-grid-frequency', 'grid_frequency', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-pv-grid-frequency', '逆变器并网频率', 'float', 'Hz', 'system', CURRENT_TIMESTAMP, 'system', CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE
    `product_id` = VALUES(`product_id`),
    `device_id` = VALUES(`device_id`),
    `product_template_id` = VALUES(`product_template_id`),
    `telemetry_key` = VALUES(`telemetry_key`),
    `gateway_id` = VALUES(`gateway_id`),
    `gateway_name` = VALUES(`gateway_name`),
    `edge_point_id` = VALUES(`edge_point_id`),
    `edge_point_name` = VALUES(`edge_point_name`),
    `data_type` = VALUES(`data_type`),
    `unit_symbol` = VALUES(`unit_symbol`),
    `update_by` = VALUES(`update_by`),
    `update_time` = CURRENT_TIMESTAMP;

-- -----------------------------------------------------------------------------
-- 8. 快速校验
-- -----------------------------------------------------------------------------
SELECT 'transport_protocol' AS `item`, COUNT(*) AS `count` FROM `transport_protocol` WHERE `id` = 'modbus'
UNION ALL
SELECT 'products', COUNT(*) FROM `products` WHERE `id` LIKE 'bms-%' OR `id` LIKE 'ems-%'
UNION ALL
SELECT 'product_templates', COUNT(*) FROM `product_templates` WHERE `product_id` LIKE 'bms-%' OR `product_id` LIKE 'ems-%'
UNION ALL
SELECT 'devices', COUNT(*) FROM `devices` WHERE `id` LIKE 'device-bms-%' OR `id` LIKE 'device-ems-%'
UNION ALL
SELECT 'edge_data_point', COUNT(*) FROM `edge_data_point` WHERE `gateway_id` = 'edge-bms-modbus-demo'
UNION ALL
SELECT 'device_binding', COUNT(*) FROM `device_binding` WHERE `gateway_id` = 'edge-bms-modbus-demo';
