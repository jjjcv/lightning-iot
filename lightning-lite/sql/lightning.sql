/*
 Navicat Premium Dump SQL

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80042 (8.0.42)
 Source Host           : localhost:3306
 Source Schema         : lightning

 Target Server Type    : MySQL
 Target Server Version : 80042 (8.0.42)
 File Encoding         : 65001

 Date: 07/09/2026 15:54:58
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for alarm_config
-- ----------------------------
DROP TABLE IF EXISTS `alarm_config`;
CREATE TABLE `alarm_config`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '名称',
  `target_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '告警目标类型',
  `level_id` bigint NULL DEFAULT NULL COMMENT '告警级别id',
  `level_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '告警级别名称',
  `scene_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联场景名称',
  `scene_id` bigint NULL DEFAULT NULL COMMENT '关联场景Id',
  `state` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '状态',
  `scene_trigger_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '场景触发类型',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '说明',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ac_scene_id`(`scene_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '告警配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of alarm_config
-- ----------------------------

-- ----------------------------
-- Table structure for alarm_handle_history
-- ----------------------------
DROP TABLE IF EXISTS `alarm_handle_history`;
CREATE TABLE `alarm_handle_history`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `alarm_config_id` bigint NOT NULL COMMENT '告警配置ID',
  `alarm_record_id` bigint NOT NULL COMMENT '告警记录Id',
  `handle_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '告警处理类型',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '说明',
  `handle_time` datetime NULL DEFAULT NULL COMMENT '处理时间',
  `alarm_time` datetime NULL DEFAULT NULL COMMENT '告警时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_ahh_alarm_record_id`(`alarm_record_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '告警处理记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of alarm_handle_history
-- ----------------------------

-- ----------------------------
-- Table structure for alarm_level
-- ----------------------------
DROP TABLE IF EXISTS `alarm_level`;
CREATE TABLE `alarm_level`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '名称',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '配置信息',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '说明',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '告警级别' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of alarm_level
-- ----------------------------

-- ----------------------------
-- Table structure for alarm_log
-- ----------------------------
DROP TABLE IF EXISTS `alarm_log`;
CREATE TABLE `alarm_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `product_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品id',
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品名称',
  `device_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '设备id',
  `device_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '设备名称',
  `telemetry_key` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物模型（属性）标识',
  `telemetry_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '属性名称',
  `telemetry_value` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '告警触发时属性值',
  `trigger_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '触发条件描述',
  `alarm_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '告警描述',
  `alarm_time` datetime NULL DEFAULT NULL COMMENT '告警时间',
  `handle_message` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '处理说明',
  `handle_time` datetime NULL DEFAULT NULL COMMENT '处理时间',
  `level` tinyint NULL DEFAULT 3 COMMENT '告警等级:1-严重 2-重要 3-一般 4-提示',
  `state` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '告警状态:0-未确认 1-已确认 2-已恢复 3-已关闭',
  `handle_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '告警处理类型：0-未处理 1-自动恢复 2-人工确认 3-人工关闭 4-忽略告警 5-误报 6-转工单 7-自动处理 8-联动处理',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '说明',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '告警记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of alarm_log
-- ----------------------------
INSERT INTO `alarm_log` VALUES (2, 'dimmer', '照明控制', 'test1', 'test1', 'brightness', '亮度值', '10', 'test1属性亮度值==10时触发', 'test1属性亮度值==10时触发，当前值10', '2026-07-29 22:53:58', '啊啊啊啊', '2026-09-30 00:00:00', 3, '1', '3', NULL, '2026-07-29 22:53:58');
INSERT INTO `alarm_log` VALUES (3, 'dimmer', '照明控制', 'test1', 'test1', 'brightness', '亮度值', '10', 'test1属性亮度值==10时触发', 'test1属性亮度值==10时触发，当前值10', '2026-07-29 23:32:36', 'asd', '2026-09-02 00:00:00', 3, '2', '2', NULL, '2026-07-29 23:32:36');
INSERT INTO `alarm_log` VALUES (4, 'dimmer', '照明控制', 'test1', 'test1', 'brightness', '亮度值', '10', 'test1属性亮度值==10时触发', 'test1属性亮度值==10时触发，当前值10', '2026-08-18 22:54:58', NULL, NULL, 3, NULL, '0', NULL, '2026-08-18 22:54:58');

-- ----------------------------
-- Table structure for alarm_record
-- ----------------------------
DROP TABLE IF EXISTS `alarm_record`;
CREATE TABLE `alarm_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `alarm_config_id` bigint NULL DEFAULT NULL COMMENT '告警配置ID',
  `alarm_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '告警配置名称',
  `target_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '告警目标类型',
  `target_id` bigint NULL DEFAULT NULL COMMENT '告警目标Id',
  `target_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '告警目标Key',
  `target_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '告警目标名称',
  `source_id` bigint NULL DEFAULT NULL COMMENT '告警源Id',
  `source_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '告警源类型',
  `source_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '告警源名称',
  `term_spec` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '触发条件',
  `trigger_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '触发条件描述',
  `actual_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '告警原因描述',
  `alarm_time` datetime NULL DEFAULT NULL COMMENT '最近一次告警时间',
  `handle_time` datetime NULL DEFAULT NULL COMMENT '处理时间',
  `level` bigint NULL DEFAULT NULL COMMENT '告警级别',
  `state` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '告警记录状态',
  `handle_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '告警处理类型',
  `alarm_config_source` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '告警配置源',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '说明',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_alarm_rec_t_key`(`target_key` ASC) USING BTREE,
  INDEX `idx_alarm_rec_t_type`(`target_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '告警记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of alarm_record
-- ----------------------------

-- ----------------------------
-- Table structure for buildings
-- ----------------------------
DROP TABLE IF EXISTS `buildings`;
CREATE TABLE `buildings`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `building_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '建筑编码',
  `building_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '建筑名称',
  `building_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '建筑类型',
  `climate_zone` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '气候区',
  `total_area` decimal(12, 2) NULL DEFAULT NULL COMMENT '总面积(m²)',
  `personnel_count` bigint NULL DEFAULT NULL COMMENT '建筑有效人数',
  `floors` int NULL DEFAULT NULL COMMENT '楼层数',
  `construction_year` int NULL DEFAULT NULL COMMENT '建成年份',
  `location` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '地理位置',
  `building_structure` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '结构形式',
  `exterior_wall_insulation_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '外墙保温形式',
  `roof_insulation_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '屋面保温形式',
  `window_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '外窗类型',
  `glass_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '玻璃类型',
  `air_conditioning_area` decimal(12, 2) NULL DEFAULT NULL COMMENT '空调覆盖面积(m²)',
  `air_conditioning_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '空调形式',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_building_code`(`building_code` ASC) USING BTREE,
  CONSTRAINT `ck_building_area` CHECK ((`total_area` is null) or (`total_area` >= 0)),
  CONSTRAINT `ck_building_personnel` CHECK ((`personnel_count` is null) or (`personnel_count` >= 0))
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '建筑基础信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of buildings
-- ----------------------------
INSERT INTO `buildings` VALUES (1, 'B001', '智慧科技办公楼', 'OFFICE', '夏热冬冷地区', 12000.00, 500, 5, 2020, '上海市浦东新区', '钢筋混凝土框架结构', '外墙岩棉保温', '挤塑板保温', '断桥铝合金窗', 'Low-E中空玻璃', 10500.00, '中央空调（水冷螺杆机组）', 'admin', '2026-07-25 19:46:16.801473', '', '2026-07-25 19:46:16.801473', '智慧园区示范办公建筑');

-- ----------------------------
-- Table structure for channel_account
-- ----------------------------
DROP TABLE IF EXISTS `channel_account`;
CREATE TABLE `channel_account`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '账号名称',
  `send_channel` tinyint NOT NULL DEFAULT 0 COMMENT '消息发送渠道：10.IM 20.Push 30.短信 40.Email 50.公众号 60.小程序 70.企业微信 80.钉钉机器人 90.钉钉工作通知 100.企业微信机器人 110.飞书机器人 110. 飞书应用消息 ',
  `account_config` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '账号配置',
  `creator` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Java3y' COMMENT '拥有者',
  `created` int NOT NULL DEFAULT 0 COMMENT '创建时间',
  `updated` int NOT NULL DEFAULT 0 COMMENT '更新时间',
  `is_deleted` tinyint NOT NULL DEFAULT 0 COMMENT '是否删除：0.不删除 1.删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_send_channel`(`send_channel` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '渠道账号信息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of channel_account
-- ----------------------------

-- ----------------------------
-- Table structure for device_alarms
-- ----------------------------
DROP TABLE IF EXISTS `device_alarms`;
CREATE TABLE `device_alarms`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '告警名称',
  `device_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `product_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '告警类型',
  `level` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '告警级别',
  `state` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '告警状态',
  `details` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '详情',
  `time` datetime NULL DEFAULT NULL COMMENT '告警时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '设备告警信息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of device_alarms
-- ----------------------------

-- ----------------------------
-- Table structure for device_binding
-- ----------------------------
DROP TABLE IF EXISTS `device_binding`;
CREATE TABLE `device_binding`  (
  `seq` bigint NOT NULL AUTO_INCREMENT,
  `id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'id',
  `product_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '产品id',
  `device_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '设备id',
  `product_template_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物模型id',
  `telemetry_key` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '物模型（属性）标识',
  `gateway_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '网关唯一id',
  `gateway_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '网关名称',
  `edge_point_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '网关数据点位id',
  `edge_point_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '网关数据点位名称',
  `value` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '点位值',
  `data_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '数据类型',
  `unit_symbol` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '单位符号',
  `last_time` datetime NULL DEFAULT NULL COMMENT '点位值更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`seq` DESC) USING BTREE,
  UNIQUE INDEX `uk_product_device_telemetry`(`product_id` ASC, `device_id` ASC, `telemetry_key` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 74 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '设备属性模板表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of device_binding
-- ----------------------------
INSERT INTO `device_binding` VALUES (73, 'bind-ems-pv-grid-frequency', 'ems-pv-inverter', 'device-ems-pv-inverter-01', 'pt-ems-pv-grid-frequency', 'grid_frequency', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-pv-grid-frequency', '逆变器并网频率', NULL, 'float', 'Hz', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (72, 'bind-ems-pv-total-energy', 'ems-pv-inverter', 'device-ems-pv-inverter-01', 'pt-ems-pv-total-energy', 'total_energy', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-pv-total-energy', '逆变器累计发电量', NULL, 'double', 'kWh', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (71, 'bind-ems-pv-daily-energy', 'ems-pv-inverter', 'device-ems-pv-inverter-01', 'pt-ems-pv-daily-energy', 'daily_energy', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-pv-daily-energy', '逆变器日发电量', NULL, 'double', 'kWh', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (70, 'bind-ems-pv-ac-power', 'ems-pv-inverter', 'device-ems-pv-inverter-01', 'pt-ems-pv-ac-power', 'ac_power', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-pv-ac-power', '逆变器交流功率', NULL, 'float', 'kW', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (69, 'bind-ems-pv-dc-current', 'ems-pv-inverter', 'device-ems-pv-inverter-01', 'pt-ems-pv-dc-current', 'dc_current', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-pv-dc-current', '逆变器直流电流', NULL, 'float', 'A', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (68, 'bind-ems-pv-dc-voltage', 'ems-pv-inverter', 'device-ems-pv-inverter-01', 'pt-ems-pv-dc-voltage', 'dc_voltage', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-pv-dc-voltage', '逆变器直流电压', NULL, 'float', 'V', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (67, 'bind-ems-pv-fault-alarm', 'ems-pv-inverter', 'device-ems-pv-inverter-01', 'pt-ems-pv-fault-alarm', 'fault_alarm', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-pv-fault-alarm', '逆变器故障告警', NULL, 'boolean', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (66, 'bind-ems-pv-run-status', 'ems-pv-inverter', 'device-ems-pv-inverter-01', 'pt-ems-pv-run-status', 'run_status', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-pv-run-status', '逆变器运行状态', NULL, 'boolean', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (65, 'bind-ems-heat-alarm', 'ems-heat-meter', 'device-ems-heat-meter-01', 'pt-ems-heat-alarm', 'alarm', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-heat-alarm', '热量表故障告警', NULL, 'boolean', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (64, 'bind-ems-heat-total', 'ems-heat-meter', 'device-ems-heat-meter-01', 'pt-ems-heat-total', 'heat_total', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-heat-total', '换热站累计热量', NULL, 'double', 'GJ', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (63, 'bind-ems-heat-power', 'ems-heat-meter', 'device-ems-heat-meter-01', 'pt-ems-heat-power', 'heat_power', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-heat-power', '换热站热功率', NULL, 'float', 'kW', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (62, 'bind-ems-heat-flow-rate', 'ems-heat-meter', 'device-ems-heat-meter-01', 'pt-ems-heat-flow-rate', 'flow_rate', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-heat-flow-rate', '换热站流量', NULL, 'float', 'm³/h', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (61, 'bind-ems-heat-return-temp', 'ems-heat-meter', 'device-ems-heat-meter-01', 'pt-ems-heat-return-temp', 'return_temp', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-heat-return-temp', '换热站回水温度', NULL, 'float', '℃', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (60, 'bind-ems-heat-supply-temp', 'ems-heat-meter', 'device-ems-heat-meter-01', 'pt-ems-heat-supply-temp', 'supply_temp', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-heat-supply-temp', '换热站供水温度', NULL, 'float', '℃', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (59, 'bind-ems-water-leak-alarm', 'ems-water-meter', 'device-ems-water-meter-01', 'pt-ems-water-leak-alarm', 'leak_alarm', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-water-leak-alarm', '总进水漏水告警', NULL, 'boolean', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (58, 'bind-ems-water-total-flow', 'ems-water-meter', 'device-ems-water-meter-01', 'pt-ems-water-total-flow', 'total_flow', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-water-total-flow', '总进水累计流量', NULL, 'double', 'm³', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (57, 'bind-ems-water-pressure', 'ems-water-meter', 'device-ems-water-meter-01', 'pt-ems-water-pressure', 'pressure', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-water-pressure', '总进水管网压力', NULL, 'float', 'kPa', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (56, 'bind-ems-water-flow-rate', 'ems-water-meter', 'device-ems-water-meter-01', 'pt-ems-water-flow-rate', 'flow_rate', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-water-flow-rate', '总进水瞬时流量', NULL, 'float', 'm³/h', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (55, 'bind-ems-electric-reverse-energy', 'ems-electric-meter', 'device-ems-electric-meter-01', 'pt-ems-electric-reverse-energy', 'reverse_energy', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-electric-reverse-energy', '总表反向有功电能', NULL, 'double', 'kWh', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (54, 'bind-ems-electric-forward-energy', 'ems-electric-meter', 'device-ems-electric-meter-01', 'pt-ems-electric-forward-energy', 'forward_energy', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-electric-forward-energy', '总表正向有功电能', NULL, 'double', 'kWh', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (53, 'bind-ems-electric-frequency', 'ems-electric-meter', 'device-ems-electric-meter-01', 'pt-ems-electric-frequency', 'frequency', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-electric-frequency', '总表频率', NULL, 'float', 'Hz', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (52, 'bind-ems-electric-power-factor', 'ems-electric-meter', 'device-ems-electric-meter-01', 'pt-ems-electric-power-factor', 'power_factor', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-electric-power-factor', '总表功率因数', NULL, 'float', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (51, 'bind-ems-electric-active-power', 'ems-electric-meter', 'device-ems-electric-meter-01', 'pt-ems-electric-active-power', 'active_power', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-electric-active-power', '总表有功功率', NULL, 'float', 'kW', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (50, 'bind-ems-electric-current', 'ems-electric-meter', 'device-ems-electric-meter-01', 'pt-ems-electric-current', 'current', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-electric-current', '总表电流', NULL, 'float', 'A', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (49, 'bind-ems-electric-voltage', 'ems-electric-meter', 'device-ems-electric-meter-01', 'pt-ems-electric-voltage', 'voltage', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-ems-electric-voltage', '总表电压', NULL, 'float', 'V', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (48, 'bind-bms-lighting-energy-total', 'bms-lighting-controller', 'device-bms-lighting-1f', 'pt-bms-lighting-energy-total', 'energy_total', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-lighting-energy-total', '1层照明累计电量', NULL, 'double', 'kWh', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (47, 'bind-bms-lighting-power', 'bms-lighting-controller', 'device-bms-lighting-1f', 'pt-bms-lighting-power', 'power', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-lighting-power', '1层照明实时功率', NULL, 'float', 'kW', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (46, 'bind-bms-lighting-dimming', 'bms-lighting-controller', 'device-bms-lighting-1f', 'pt-bms-lighting-dimming', 'dimming', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-lighting-dimming', '1层照明调光值', NULL, 'int', '%', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (45, 'bind-bms-lighting-fault-alarm', 'bms-lighting-controller', 'device-bms-lighting-1f', 'pt-bms-lighting-fault-alarm', 'fault_alarm', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-lighting-fault-alarm', '1层照明故障告警', NULL, 'boolean', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (44, 'bind-bms-lighting-on-status', 'bms-lighting-controller', 'device-bms-lighting-1f', 'pt-bms-lighting-on-status', 'on_status', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-lighting-on-status', '1层照明开关状态', NULL, 'boolean', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (43, 'bind-bms-room-sensor-pm25', 'bms-room-sensor', 'device-bms-room-sensor-101', 'pt-bms-room-sensor-pm25', 'pm25', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-room-sensor-pm25', '101房间PM2.5', NULL, 'int', 'μg/m³', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (42, 'bind-bms-room-sensor-co2', 'bms-room-sensor', 'device-bms-room-sensor-101', 'pt-bms-room-sensor-co2', 'co2', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-room-sensor-co2', '101房间CO2', NULL, 'int', 'ppm', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (41, 'bind-bms-room-sensor-humidity', 'bms-room-sensor', 'device-bms-room-sensor-101', 'pt-bms-room-sensor-humidity', 'humidity', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-room-sensor-humidity', '101房间相对湿度', NULL, 'float', '%RH', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (40, 'bind-bms-room-sensor-room-temp', 'bms-room-sensor', 'device-bms-room-sensor-101', 'pt-bms-room-sensor-room-temp', 'room_temp', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-room-sensor-room-temp', '101房间室内温度', NULL, 'float', '℃', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (39, 'bind-bms-pump-power', 'bms-pump', 'device-bms-pump-01', 'pt-bms-pump-power', 'power', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-pump-power', '水泵实时功率', NULL, 'float', 'kW', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (38, 'bind-bms-pump-flow-rate', 'bms-pump', 'device-bms-pump-01', 'pt-bms-pump-flow-rate', 'flow_rate', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-pump-flow-rate', '水泵流量', NULL, 'float', 'm³/h', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (37, 'bind-bms-pump-outlet-pressure', 'bms-pump', 'device-bms-pump-01', 'pt-bms-pump-outlet-pressure', 'outlet_pressure', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-pump-outlet-pressure', '水泵出口压力', NULL, 'float', 'kPa', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (36, 'bind-bms-pump-inlet-pressure', 'bms-pump', 'device-bms-pump-01', 'pt-bms-pump-inlet-pressure', 'inlet_pressure', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-pump-inlet-pressure', '水泵入口压力', NULL, 'float', 'kPa', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (35, 'bind-bms-pump-frequency', 'bms-pump', 'device-bms-pump-01', 'pt-bms-pump-frequency', 'frequency', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-pump-frequency', '水泵运行频率', NULL, 'float', 'Hz', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (34, 'bind-bms-pump-fault-alarm', 'bms-pump', 'device-bms-pump-01', 'pt-bms-pump-fault-alarm', 'fault_alarm', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-pump-fault-alarm', '水泵故障告警', NULL, 'boolean', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (33, 'bind-bms-pump-run-status', 'bms-pump', 'device-bms-pump-01', 'pt-bms-pump-run-status', 'run_status', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-pump-run-status', '水泵运行状态', NULL, 'boolean', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (32, 'bind-bms-cooling-tower-power', 'bms-cooling-tower', 'device-bms-cooling-tower-01', 'pt-bms-cooling-tower-power', 'power', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-cooling-tower-power', '冷却塔实时功率', NULL, 'float', 'kW', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (31, 'bind-bms-cooling-tower-fan-speed', 'bms-cooling-tower', 'device-bms-cooling-tower-01', 'pt-bms-cooling-tower-fan-speed', 'fan_speed', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-cooling-tower-fan-speed', '冷却塔风机频率', NULL, 'float', 'Hz', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (30, 'bind-bms-cooling-tower-leaving-water-temp', 'bms-cooling-tower', 'device-bms-cooling-tower-01', 'pt-bms-cooling-tower-leaving-water-temp', 'leaving_water_temp', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-cooling-tower-leaving-water-temp', '冷却塔出水温度', NULL, 'float', '℃', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (29, 'bind-bms-cooling-tower-entering-water-temp', 'bms-cooling-tower', 'device-bms-cooling-tower-01', 'pt-bms-cooling-tower-entering-water-temp', 'entering_water_temp', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-cooling-tower-entering-water-temp', '冷却塔进水温度', NULL, 'float', '℃', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (28, 'bind-bms-cooling-tower-fault-alarm', 'bms-cooling-tower', 'device-bms-cooling-tower-01', 'pt-bms-cooling-tower-fault-alarm', 'fault_alarm', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-cooling-tower-fault-alarm', '冷却塔故障告警', NULL, 'boolean', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (27, 'bind-bms-cooling-tower-run-status', 'bms-cooling-tower', 'device-bms-cooling-tower-01', 'pt-bms-cooling-tower-run-status', 'run_status', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-cooling-tower-run-status', '冷却塔运行状态', NULL, 'boolean', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (26, 'bind-bms-fcu-fan-speed', 'bms-fcu', 'device-bms-fcu-01', 'pt-bms-fcu-fan-speed', 'fan_speed', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-fcu-fan-speed', 'FCU风速档位', NULL, 'int', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (25, 'bind-bms-fcu-setpoint-temp', 'bms-fcu', 'device-bms-fcu-01', 'pt-bms-fcu-setpoint-temp', 'setpoint_temp', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-fcu-setpoint-temp', 'FCU温度设定', NULL, 'float', '℃', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (24, 'bind-bms-fcu-room-temp', 'bms-fcu', 'device-bms-fcu-01', 'pt-bms-fcu-room-temp', 'room_temp', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-fcu-room-temp', 'FCU房间温度', NULL, 'float', '℃', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (23, 'bind-bms-fcu-fault-alarm', 'bms-fcu', 'device-bms-fcu-01', 'pt-bms-fcu-fault-alarm', 'fault_alarm', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-fcu-fault-alarm', 'FCU故障告警', NULL, 'boolean', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (22, 'bind-bms-fcu-run-status', 'bms-fcu', 'device-bms-fcu-01', 'pt-bms-fcu-run-status', 'run_status', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-fcu-run-status', 'FCU运行状态', NULL, 'boolean', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (21, 'bind-bms-ahu-temp-setpoint', 'bms-ahu', 'device-bms-ahu-01', 'pt-bms-ahu-temp-setpoint', 'temp_setpoint', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-ahu-temp-setpoint', 'AHU送风温度设定', NULL, 'float', '℃', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (20, 'bind-bms-ahu-valve-output', 'bms-ahu', 'device-bms-ahu-01', 'pt-bms-ahu-valve-output', 'valve_output', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-ahu-valve-output', 'AHU水阀开度', NULL, 'float', '%', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (19, 'bind-bms-ahu-supply-fan-speed', 'bms-ahu', 'device-bms-ahu-01', 'pt-bms-ahu-supply-fan-speed', 'supply_fan_speed', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-ahu-supply-fan-speed', 'AHU送风机频率', NULL, 'float', 'Hz', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (18, 'bind-bms-ahu-return-air-temp', 'bms-ahu', 'device-bms-ahu-01', 'pt-bms-ahu-return-air-temp', 'return_air_temp', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-ahu-return-air-temp', 'AHU回风温度', NULL, 'float', '℃', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (17, 'bind-bms-ahu-supply-air-temp', 'bms-ahu', 'device-bms-ahu-01', 'pt-bms-ahu-supply-air-temp', 'supply_air_temp', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-ahu-supply-air-temp', 'AHU送风温度', NULL, 'float', '℃', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (16, 'bind-bms-ahu-fault-alarm', 'bms-ahu', 'device-bms-ahu-01', 'pt-bms-ahu-fault-alarm', 'fault_alarm', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-ahu-fault-alarm', 'AHU故障告警', NULL, 'boolean', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (15, 'bind-bms-ahu-run-status', 'bms-ahu', 'device-bms-ahu-01', 'pt-bms-ahu-run-status', 'run_status', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-ahu-run-status', 'AHU运行状态', NULL, 'boolean', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (14, 'bind-bms-chiller-setpoint-temp', 'bms-chiller', 'device-bms-chiller-01', 'pt-bms-chiller-setpoint-temp', 'setpoint_temp', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-chiller-setpoint-temp', '冷水机组出水温度设定', NULL, 'float', '℃', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (13, 'bind-bms-chiller-energy-total', 'bms-chiller', 'device-bms-chiller-01', 'pt-bms-chiller-energy-total', 'energy_total', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-chiller-energy-total', '冷水机组累计电量', NULL, 'double', 'kWh', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (12, 'bind-bms-chiller-power', 'bms-chiller', 'device-bms-chiller-01', 'pt-bms-chiller-power', 'power', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-chiller-power', '冷水机组实时功率', NULL, 'float', 'kW', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (11, 'bind-bms-chiller-outlet-pressure', 'bms-chiller', 'device-bms-chiller-01', 'pt-bms-chiller-outlet-pressure', 'outlet_pressure', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-chiller-outlet-pressure', '冷水机组出水压力', NULL, 'float', 'kPa', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (10, 'bind-bms-chiller-entering-water-temp', 'bms-chiller', 'device-bms-chiller-01', 'pt-bms-chiller-entering-water-temp', 'entering_water_temp', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-chiller-entering-water-temp', '冷水机组回水温度', NULL, 'float', '℃', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (9, 'bind-bms-chiller-leaving-water-temp', 'bms-chiller', 'device-bms-chiller-01', 'pt-bms-chiller-leaving-water-temp', 'leaving_water_temp', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-chiller-leaving-water-temp', '冷水机组出水温度', NULL, 'float', '℃', NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (8, 'bind-bms-chiller-fault-alarm', 'bms-chiller', 'device-bms-chiller-01', 'pt-bms-chiller-fault-alarm', 'fault_alarm', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-chiller-fault-alarm', '冷水机组故障告警', NULL, 'boolean', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `device_binding` VALUES (7, 'bind-bms-chiller-run-status', 'bms-chiller', 'device-bms-chiller-01', 'pt-bms-chiller-run-status', 'run_status', 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'edp-bms-chiller-run-status', '冷水机组运行状态', NULL, 'boolean', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');

-- ----------------------------
-- Table structure for device_cmd_log
-- ----------------------------
DROP TABLE IF EXISTS `device_cmd_log`;
CREATE TABLE `device_cmd_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `device_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `mode` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `cmd_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `cmd_content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `state` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `response_content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `request_time` datetime NULL DEFAULT NULL,
  `response_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '设备报文历史日志' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of device_cmd_log
-- ----------------------------

-- ----------------------------
-- Table structure for device_group
-- ----------------------------
DROP TABLE IF EXISTS `device_group`;
CREATE TABLE `device_group`  (
  `group_id` bigint NOT NULL AUTO_INCREMENT COMMENT '设备分组id',
  `parent_id` bigint NULL DEFAULT NULL COMMENT '父类id',
  `group_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '设备分组名称',
  `product_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '所属产品ID；存量待整理分组允许为空',
  `order_num` int NULL DEFAULT NULL COMMENT '显示顺序',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品类型说明',
  `status` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`group_id`) USING BTREE,
  INDEX `idx_device_group_product`(`product_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 107 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '设备分组' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of device_group
-- ----------------------------

-- ----------------------------
-- Table structure for device_history
-- ----------------------------
DROP TABLE IF EXISTS `device_history`;
CREATE TABLE `device_history`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `product_id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品ID',
  `device_id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '设备ID',
  `telemetry_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物模型标识',
  `value` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '点位值',
  `data_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '数据类型',
  `quality_flag` tinyint NULL DEFAULT NULL COMMENT '数据质量标识 1-正常 0-异常',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`, `create_time`) USING BTREE,
  INDEX `idx_dev_time`(`device_id` ASC, `create_time` ASC) USING BTREE,
  INDEX `idx_prod_dev_key_time`(`product_id` ASC, `device_id` ASC, `telemetry_key` ASC, `create_time` ASC) USING BTREE,
  INDEX `idx_dev_time_desc`(`device_id` ASC, `create_time` DESC) USING BTREE,
  INDEX `idx_dev_time_val`(`device_id` ASC, `create_time` ASC, `value` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 384824 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC PARTITION BY RANGE (to_days(`create_time`))
PARTITIONS 18
(PARTITION `p202505` VALUES LESS THAN (739768) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p202506` VALUES LESS THAN (739798) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p202507` VALUES LESS THAN (739829) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p202508` VALUES LESS THAN (739860) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p202509` VALUES LESS THAN (739890) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p202510` VALUES LESS THAN (739921) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p202511` VALUES LESS THAN (739951) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p202512` VALUES LESS THAN (739982) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p202601` VALUES LESS THAN (740013) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p202602` VALUES LESS THAN (740041) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p202603` VALUES LESS THAN (740072) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p202604` VALUES LESS THAN (740102) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p202605` VALUES LESS THAN (740133) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p202606` VALUES LESS THAN (740163) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p202607` VALUES LESS THAN (740194) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p202608` VALUES LESS THAN (740225) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p202609` VALUES LESS THAN (740255) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p202610` VALUES LESS THAN (740286) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 )
;

-- ----------------------------
-- Records of device_history
-- ----------------------------

-- ----------------------------
-- Table structure for device_tag
-- ----------------------------
DROP TABLE IF EXISTS `device_tag`;
CREATE TABLE `device_tag`  (
  `device_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '设备ID',
  `tag_id` bigint NOT NULL COMMENT '标签id',
  PRIMARY KEY (`device_id`, `tag_id`) USING BTREE,
  KEY `idx_device_tag_tag_id` (`tag_id`, `device_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '设备标签' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of device_tag
-- ----------------------------

-- ----------------------------
-- Table structure for device_templates
-- ----------------------------
DROP TABLE IF EXISTS `device_templates`;
CREATE TABLE `device_templates`  (
  `id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'id',
  `product_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品id',
  `product_template_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品属性物模型id',
  `device_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '设备id',
  `telemetry_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '属性标识',
  `telemetry_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '属性数据类型',
  `protocol_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '传输协议id',
  `gateway_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '网关唯一id',
  `point_id` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '属性模板配置（配置对应的网关中的数据点）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '设备属性绑定点位表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of device_templates
-- ----------------------------

-- ----------------------------
-- Table structure for devices
-- ----------------------------
DROP TABLE IF EXISTS `devices`;
CREATE TABLE `devices`  (
  `seq` bigint NOT NULL AUTO_INCREMENT,
  `id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '设备ID',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '设备名称',
  `token` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '设备token',
  `alias` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '设备别名',
  `product_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品Id',
  `group_id` bigint NULL DEFAULT NULL COMMENT '设备分组Id',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '设备说明',
  `status` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '启停状态：enable，disable',
  `ext` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '拓展，json格式',
  `gateway_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '所属网关设备id',
  `device_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '设备类型：direct、gateway、gatewayS',
  `link_status` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '连接状态: online, offline',
  `status_time` datetime NULL DEFAULT NULL COMMENT '状态变更时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`seq`) USING BTREE,
  UNIQUE INDEX `uk_devices_id`(`id` ASC) USING BTREE,
  INDEX `fk_devices_product`(`product_id` ASC) USING BTREE,
  INDEX `fk_devices_device_group`(`group_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 235 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '设备表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of devices
-- ----------------------------
INSERT INTO `devices` VALUES (224, 'device-bms-chiller-01', '1号冷水机组', NULL, 'CH-01', 'bms-chiller', NULL, 'BMS示例冷水机组', 'enable', '{\"manufacturer\":\"示例\",\"model\":\"CHILLER-DEMO\",\"slave_id\":1}', 'edge-bms-modbus-demo', 'gatewayS', 'online', NULL, 'system', '2026-09-04 09:35:58', 'system', '2026-09-04 09:35:58');
INSERT INTO `devices` VALUES (225, 'device-bms-ahu-01', '1号空气处理机组', NULL, 'AHU-01', 'bms-ahu', NULL, 'BMS示例空气处理机组', 'enable', '{\"manufacturer\":\"示例\",\"model\":\"AHU-DEMO\",\"slave_id\":1}', 'edge-bms-modbus-demo', 'gatewayS', 'online', NULL, 'system', '2026-09-04 09:35:58', 'system', '2026-09-04 09:35:58');
INSERT INTO `devices` VALUES (226, 'device-bms-fcu-01', '101房间风机盘管', NULL, 'FCU-101', 'bms-fcu', NULL, 'BMS示例风机盘管', 'enable', '{\"manufacturer\":\"示例\",\"model\":\"FCU-DEMO\",\"slave_id\":1}', 'edge-bms-modbus-demo', 'gatewayS', 'online', NULL, 'system', '2026-09-04 09:35:58', 'system', '2026-09-04 09:35:58');
INSERT INTO `devices` VALUES (227, 'device-bms-cooling-tower-01', '1号冷却塔', NULL, 'CT-01', 'bms-cooling-tower', NULL, 'BMS示例冷却塔', 'enable', '{\"manufacturer\":\"示例\",\"model\":\"CT-DEMO\",\"slave_id\":1}', 'edge-bms-modbus-demo', 'gatewayS', 'online', NULL, 'system', '2026-09-04 09:35:58', 'system', '2026-09-04 09:35:58');
INSERT INTO `devices` VALUES (228, 'device-bms-pump-01', '1号冷冻水泵', NULL, 'P-CHW-01', 'bms-pump', NULL, 'BMS示例水泵', 'enable', '{\"manufacturer\":\"示例\",\"model\":\"PUMP-DEMO\",\"slave_id\":1}', 'edge-bms-modbus-demo', 'gatewayS', 'online', NULL, 'system', '2026-09-04 09:35:58', 'system', '2026-09-04 09:35:58');
INSERT INTO `devices` VALUES (229, 'device-bms-room-sensor-101', '101房间环境传感器', NULL, 'RS-101', 'bms-room-sensor', NULL, 'BMS示例室内环境传感器', 'enable', '{\"manufacturer\":\"示例\",\"model\":\"SENSOR-DEMO\",\"slave_id\":1}', 'edge-bms-modbus-demo', 'gatewayS', 'online', NULL, 'system', '2026-09-04 09:35:58', 'system', '2026-09-04 09:35:58');
INSERT INTO `devices` VALUES (230, 'device-bms-lighting-1f', '1层照明控制器', NULL, 'LC-1F', 'bms-lighting-controller', NULL, 'BMS示例照明控制器', 'enable', '{\"manufacturer\":\"示例\",\"model\":\"LIGHT-DEMO\",\"slave_id\":1}', 'edge-bms-modbus-demo', 'gatewayS', 'online', NULL, 'system', '2026-09-04 09:35:58', 'system', '2026-09-04 09:35:58');
INSERT INTO `devices` VALUES (231, 'device-ems-electric-meter-01', '总配电房智能电表', NULL, 'EM-01', 'ems-electric-meter', NULL, 'EMS示例智能电表', 'enable', '{\"manufacturer\":\"示例\",\"model\":\"METER-E-DEMO\",\"slave_id\":1}', 'edge-bms-modbus-demo', 'gatewayS', 'online', NULL, 'system', '2026-09-04 09:35:58', 'system', '2026-09-04 09:35:58');
INSERT INTO `devices` VALUES (232, 'device-ems-water-meter-01', '总进水智能水表', NULL, 'WM-01', 'ems-water-meter', NULL, 'EMS示例智能水表', 'enable', '{\"manufacturer\":\"示例\",\"model\":\"METER-W-DEMO\",\"slave_id\":1}', 'edge-bms-modbus-demo', 'gatewayS', 'online', NULL, 'system', '2026-09-04 09:35:58', 'system', '2026-09-04 09:35:58');
INSERT INTO `devices` VALUES (233, 'device-ems-heat-meter-01', '换热站热量表', NULL, 'HM-01', 'ems-heat-meter', NULL, 'EMS示例热量表', 'enable', '{\"manufacturer\":\"示例\",\"model\":\"METER-H-DEMO\",\"slave_id\":1}', 'edge-bms-modbus-demo', 'gatewayS', 'online', NULL, 'system', '2026-09-04 09:35:58', 'system', '2026-09-04 09:35:58');
INSERT INTO `devices` VALUES (234, 'device-ems-pv-inverter-01', '屋顶光伏逆变器', NULL, 'PV-INV-01', 'ems-pv-inverter', NULL, 'EMS示例光伏逆变器', 'enable', '{\"manufacturer\":\"示例\",\"model\":\"PV-DEMO\",\"slave_id\":1}', 'edge-bms-modbus-demo', 'gatewayS', 'online', NULL, 'system', '2026-09-04 09:35:58', 'system', '2026-09-04 09:35:58');

-- ----------------------------
-- Table structure for edge_data_point
-- ----------------------------
DROP TABLE IF EXISTS `edge_data_point`;
CREATE TABLE `edge_data_point`  (
  `seq` bigint NOT NULL AUTO_INCREMENT,
  `id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'id',
  `name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '数据点位名称',
  `protocol_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '协议id',
  `gateway_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '边缘网关设备id',
  `type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '数据类型：内置数据类型',
  `operationTpye` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '读写类型：r读，w写，p上报',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '数据点位配置',
  `value` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '点位值',
  `last_time` datetime NULL DEFAULT NULL COMMENT '点位值更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`seq`) USING BTREE,
  UNIQUE INDEX `idx_id`(`id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 104 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '网关数据点位表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of edge_data_point
-- ----------------------------
INSERT INTO `edge_data_point` VALUES (37, 'edp-bms-chiller-run-status', '冷水机组运行状态', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{\"register_type\":\"coil\",\"offset\":0,\"quantity\":1}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (38, 'edp-bms-chiller-fault-alarm', '冷水机组故障告警', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{\"register_type\":\"discrete\",\"offset\":1,\"quantity\":1}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (39, 'edp-bms-chiller-leaving-water-temp', '冷水机组出水温度', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":0,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (40, 'edp-bms-chiller-entering-water-temp', '冷水机组回水温度', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":2,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (41, 'edp-bms-chiller-outlet-pressure', '冷水机组出水压力', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":4,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (42, 'edp-bms-chiller-power', '冷水机组实时功率', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":6,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (43, 'edp-bms-chiller-energy-total', '冷水机组累计电量', 'modbus', 'edge-bms-modbus-demo', 'double', 'r', '{\"register_type\":\"input\",\"offset\":8,\"quantity\":4}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (44, 'edp-bms-chiller-setpoint-temp', '冷水机组出水温度设定', 'modbus', 'edge-bms-modbus-demo', 'float', 'w', '{\"register_type\":\"holding\",\"offset\":12,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (45, 'edp-bms-ahu-run-status', 'AHU运行状态', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{\"register_type\":\"coil\",\"offset\":32,\"quantity\":1}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (46, 'edp-bms-ahu-fault-alarm', 'AHU故障告警', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{\"register_type\":\"discrete\",\"offset\":33,\"quantity\":1}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (47, 'edp-bms-ahu-supply-air-temp', 'AHU送风温度', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":32,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (48, 'edp-bms-ahu-return-air-temp', 'AHU回风温度', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":34,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (49, 'edp-bms-ahu-supply-fan-speed', 'AHU送风机频率', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":36,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (50, 'edp-bms-ahu-valve-output', 'AHU水阀开度', 'modbus', 'edge-bms-modbus-demo', 'float', 'w', '{\"register_type\":\"holding\",\"offset\":38,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (51, 'edp-bms-ahu-temp-setpoint', 'AHU送风温度设定', 'modbus', 'edge-bms-modbus-demo', 'float', 'w', '{\"register_type\":\"holding\",\"offset\":40,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (52, 'edp-bms-fcu-run-status', 'FCU运行状态', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{\"register_type\":\"coil\",\"offset\":48,\"quantity\":1}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (53, 'edp-bms-fcu-fault-alarm', 'FCU故障告警', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{\"register_type\":\"discrete\",\"offset\":49,\"quantity\":1}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (54, 'edp-bms-fcu-room-temp', 'FCU房间温度', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":48,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (55, 'edp-bms-fcu-setpoint-temp', 'FCU温度设定', 'modbus', 'edge-bms-modbus-demo', 'float', 'w', '{\"register_type\":\"holding\",\"offset\":50,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (56, 'edp-bms-fcu-fan-speed', 'FCU风速档位', 'modbus', 'edge-bms-modbus-demo', 'int', 'w', '{\"register_type\":\"holding\",\"offset\":52,\"quantity\":1}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (57, 'edp-bms-cooling-tower-run-status', '冷却塔运行状态', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{\"register_type\":\"coil\",\"offset\":56,\"quantity\":1}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (58, 'edp-bms-cooling-tower-fault-alarm', '冷却塔故障告警', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{\"register_type\":\"discrete\",\"offset\":57,\"quantity\":1}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (59, 'edp-bms-cooling-tower-entering-water-temp', '冷却塔进水温度', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":56,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (60, 'edp-bms-cooling-tower-leaving-water-temp', '冷却塔出水温度', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":58,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (61, 'edp-bms-cooling-tower-fan-speed', '冷却塔风机频率', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":60,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (62, 'edp-bms-cooling-tower-power', '冷却塔实时功率', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":62,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (63, 'edp-bms-pump-run-status', '水泵运行状态', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{\"register_type\":\"coil\",\"offset\":64,\"quantity\":1}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (64, 'edp-bms-pump-fault-alarm', '水泵故障告警', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{\"register_type\":\"discrete\",\"offset\":65,\"quantity\":1}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (65, 'edp-bms-pump-frequency', '水泵运行频率', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":64,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (66, 'edp-bms-pump-inlet-pressure', '水泵入口压力', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":66,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (67, 'edp-bms-pump-outlet-pressure', '水泵出口压力', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":68,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (68, 'edp-bms-pump-flow-rate', '水泵流量', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":70,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (69, 'edp-bms-pump-power', '水泵实时功率', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":72,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (70, 'edp-bms-room-sensor-room-temp', '101房间室内温度', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":76,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (71, 'edp-bms-room-sensor-humidity', '101房间相对湿度', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":78,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (72, 'edp-bms-room-sensor-co2', '101房间CO2', 'modbus', 'edge-bms-modbus-demo', 'int', 'r', '{\"register_type\":\"input\",\"offset\":80,\"quantity\":1}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (73, 'edp-bms-room-sensor-pm25', '101房间PM2.5', 'modbus', 'edge-bms-modbus-demo', 'int', 'r', '{\"register_type\":\"input\",\"offset\":81,\"quantity\":1}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (74, 'edp-bms-lighting-on-status', '1层照明开关状态', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{\"register_type\":\"coil\",\"offset\":80,\"quantity\":1}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (75, 'edp-bms-lighting-fault-alarm', '1层照明故障告警', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{\"register_type\":\"discrete\",\"offset\":81,\"quantity\":1}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (76, 'edp-bms-lighting-dimming', '1层照明调光值', 'modbus', 'edge-bms-modbus-demo', 'int', 'w', '{\"register_type\":\"holding\",\"offset\":82,\"quantity\":1}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (77, 'edp-bms-lighting-power', '1层照明实时功率', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":83,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (78, 'edp-bms-lighting-energy-total', '1层照明累计电量', 'modbus', 'edge-bms-modbus-demo', 'double', 'r', '{\"register_type\":\"input\",\"offset\":85,\"quantity\":4}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (79, 'edp-ems-electric-voltage', '总表电压', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":90,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (80, 'edp-ems-electric-current', '总表电流', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":92,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (81, 'edp-ems-electric-active-power', '总表有功功率', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":94,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (82, 'edp-ems-electric-power-factor', '总表功率因数', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":96,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (83, 'edp-ems-electric-frequency', '总表频率', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":98,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (84, 'edp-ems-electric-forward-energy', '总表正向有功电能', 'modbus', 'edge-bms-modbus-demo', 'double', 'r', '{\"register_type\":\"input\",\"offset\":100,\"quantity\":4}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (85, 'edp-ems-electric-reverse-energy', '总表反向有功电能', 'modbus', 'edge-bms-modbus-demo', 'double', 'r', '{\"register_type\":\"input\",\"offset\":104,\"quantity\":4}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (86, 'edp-ems-water-flow-rate', '总进水瞬时流量', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":108,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (87, 'edp-ems-water-pressure', '总进水管网压力', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":110,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (88, 'edp-ems-water-total-flow', '总进水累计流量', 'modbus', 'edge-bms-modbus-demo', 'double', 'r', '{\"register_type\":\"input\",\"offset\":112,\"quantity\":4}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (89, 'edp-ems-water-leak-alarm', '总进水漏水告警', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{\"register_type\":\"discrete\",\"offset\":83,\"quantity\":1}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (90, 'edp-ems-heat-supply-temp', '换热站供水温度', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":116,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (91, 'edp-ems-heat-return-temp', '换热站回水温度', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":118,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (92, 'edp-ems-heat-flow-rate', '换热站流量', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":120,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (93, 'edp-ems-heat-power', '换热站热功率', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":122,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (94, 'edp-ems-heat-total', '换热站累计热量', 'modbus', 'edge-bms-modbus-demo', 'double', 'r', '{\"register_type\":\"input\",\"offset\":124,\"quantity\":4}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (95, 'edp-ems-heat-alarm', '热量表故障告警', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{\"register_type\":\"discrete\",\"offset\":84,\"quantity\":1}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (96, 'edp-ems-pv-run-status', '逆变器运行状态', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{\"register_type\":\"coil\",\"offset\":88,\"quantity\":1}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (97, 'edp-ems-pv-fault-alarm', '逆变器故障告警', 'modbus', 'edge-bms-modbus-demo', 'boolean', 'r', '{\"register_type\":\"discrete\",\"offset\":89,\"quantity\":1}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (98, 'edp-ems-pv-dc-voltage', '逆变器直流电压', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":128,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (99, 'edp-ems-pv-dc-current', '逆变器直流电流', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":130,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (100, 'edp-ems-pv-ac-power', '逆变器交流功率', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":132,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (101, 'edp-ems-pv-daily-energy', '逆变器日发电量', 'modbus', 'edge-bms-modbus-demo', 'double', 'r', '{\"register_type\":\"input\",\"offset\":134,\"quantity\":4}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (102, 'edp-ems-pv-total-energy', '逆变器累计发电量', 'modbus', 'edge-bms-modbus-demo', 'double', 'r', '{\"register_type\":\"input\",\"offset\":138,\"quantity\":4}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');
INSERT INTO `edge_data_point` VALUES (103, 'edp-ems-pv-grid-frequency', '逆变器并网频率', 'modbus', 'edge-bms-modbus-demo', 'float', 'r', '{\"register_type\":\"input\",\"offset\":142,\"quantity\":2}', NULL, NULL, 'system', '2026-09-04 09:35:59', 'system', '2026-09-04 09:35:59');

-- ----------------------------
-- Table structure for edge_device
-- ----------------------------
DROP TABLE IF EXISTS `edge_device`;
CREATE TABLE `edge_device`  (
  `seq` bigint NOT NULL AUTO_INCREMENT,
  `id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '名称',
  `status` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '启停状态：enable，disable',
  `link_status` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '连接状态: online, offline',
  `protocol_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '传输协议id',
  `configuration` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '配置信息',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '说明',
  `status_time` datetime NULL DEFAULT NULL COMMENT '状态变更时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`seq` DESC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '设备接入网关' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of edge_device
-- ----------------------------
INSERT INTO `edge_device` VALUES (6, 'edge-bms-modbus-demo', 'BMS/EMS Modbus TCP示例网关', 'enable', 'online', 'modbus', '{\"ip_address\":\"127.0.0.1\",\"port\":502,\"slave_id\":1,\"timeout\":3000,\"refresh_interval\":5000,\"connect_interval\":30000,\"max_block_size\":125,\"max_bit_block_size\":2000,\"max_block_gap\":2,\"max_in_flight_requests\":1,\"retry_attempts\":2,\"retry_backoff\":200,\"byte_order\":\"BIG_ENDIAN\"}', '示例网关；请修改IP、端口和Unit ID后再启用', '2026-09-04 21:42:42', 'system', 'system', '2026-09-04 09:35:58', '2026-09-04 21:42:42');

-- ----------------------------
-- Table structure for energy_allocation_result
-- ----------------------------
DROP TABLE IF EXISTS `energy_allocation_result`;
CREATE TABLE `energy_allocation_result`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `rule_id` bigint NOT NULL COMMENT '使用的分摊规则ID',
  `source_data_table` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '来源统计表名：energy_line_data_min/hourly/daily/monthly/yearly',
  `source_data_id` bigint NOT NULL COMMENT '来源统计表记录ID',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID快照',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `source_branch_id` bigint NOT NULL COMMENT '来源支路ID快照',
  `target_area_id` bigint NULL DEFAULT NULL COMMENT '目标区域ID，与目标分项ID至少填写一个',
  `target_subitem_id` bigint NULL DEFAULT NULL COMMENT '目标分项ID，与目标区域ID至少填写一个',
  `period_start` datetime(6) NOT NULL COMMENT '分摊周期开始时间',
  `period_end` datetime(6) NOT NULL COMMENT '分摊周期结束时间',
  `allocation_method` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分摊方式快照',
  `source_quantity` decimal(38, 12) NOT NULL COMMENT '本次待分摊能源用量',
  `driver_value` decimal(38, 12) NOT NULL COMMENT '当前分摊目标的驱动值',
  `total_driver_value` decimal(38, 12) NOT NULL COMMENT '本次分摊全部目标驱动值合计',
  `allocation_ratio` decimal(38, 12) NOT NULL COMMENT '分摊比例，通常为driver_value除以total_driver_value',
  `allocated_quantity` decimal(38, 12) NOT NULL COMMENT '当前目标最终分摊用量',
  `result_version` int NOT NULL DEFAULT 1 COMMENT '结果版本号',
  `is_current` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否当前有效版本',
  `current_key` tinyint GENERATED ALWAYS AS ((case when (`is_current` = 1) then 1 else NULL end)) STORED COMMENT '当前版本唯一索引辅助字段' NULL,
  `supersedes_result_id` bigint NULL DEFAULT NULL COMMENT '被本版本替代的结果ID',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '计算批次ID',
  `base_unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '能源标准单位快照',
  `target_area_key` bigint GENERATED ALWAYS AS (ifnull(`target_area_id`,0)) STORED COMMENT '目标区域唯一索引辅助字段' NULL,
  `target_subitem_key` bigint GENERATED ALWAYS AS (ifnull(`target_subitem_id`,0)) STORED COMMENT '目标分项唯一索引辅助字段' NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_allocation_result_version`(`rule_id` ASC, `source_data_table` ASC, `source_data_id` ASC, `target_area_key` ASC, `target_subitem_key` ASC, `result_version` ASC) USING BTREE,
  UNIQUE INDEX `uk_allocation_result_current`(`rule_id` ASC, `source_data_table` ASC, `source_data_id` ASC, `target_area_key` ASC, `target_subitem_key` ASC, `current_key` ASC) USING BTREE,
  INDEX `idx_allocation_result_source`(`source_branch_id` ASC, `energy_type_id` ASC, `period_start` ASC, `period_end` ASC) USING BTREE,
  INDEX `idx_allocation_result_area`(`target_area_id` ASC, `energy_type_id` ASC, `period_start` ASC) USING BTREE,
  INDEX `idx_allocation_result_subitem`(`target_subitem_id` ASC, `energy_type_id` ASC, `period_start` ASC) USING BTREE,
  INDEX `idx_allocation_result_area_subitem`(`target_area_id` ASC, `target_subitem_id` ASC, `energy_type_id` ASC, `period_start` ASC) USING BTREE,
  INDEX `idx_allocation_result_rule`(`rule_id` ASC) USING BTREE,
  INDEX `idx_allocation_result_data`(`source_data_table` ASC, `source_data_id` ASC) USING BTREE,
  INDEX `idx_allocation_result_batch`(`calculation_batch_id` ASC, `created_at` ASC) USING BTREE,
  CONSTRAINT `ck_allocation_result_version` CHECK (`result_version` >= 1)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源分摊计算结果' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_allocation_result
-- ----------------------------

-- ----------------------------
-- Table structure for energy_allocation_rule
-- ----------------------------
DROP TABLE IF EXISTS `energy_allocation_rule`;
CREATE TABLE `energy_allocation_rule`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `rule_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '规则编码',
  `rule_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '规则名称',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `source_branch_id` bigint NOT NULL COMMENT '待分摊能源来源支路ID',
  `allocation_method` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分摊方式：DIRECT直接归属、WEIGHTED权重分摊、RESIDUAL剩余量分摊、CUSTOM自定义',
  `precision_scale` tinyint NOT NULL DEFAULT 12 COMMENT '分摊计算保留小数位数，由应用层限制在0到12之间',
  `rounding_mode` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'HALF_UP' COMMENT '舍入模式：HALF_UP、HALF_EVEN、DOWN、UP等',
  `remainder_policy` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'LARGEST_REMAINDER' COMMENT '分摊余数处理策略：LARGEST_REMAINDER最大余数、FIRST首目标、LAST末目标、IGNORE忽略',
  `formula_config` json NULL COMMENT '自定义分摊公式及参数配置',
  `valid_from` datetime(6) NOT NULL COMMENT '规则生效时间',
  `valid_to` datetime(6) NULL DEFAULT NULL COMMENT '规则失效时间，为空表示长期有效',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'ACTIVE' COMMENT '规则状态：ACTIVE启用、DISABLED停用',
  `created_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_allocation_rule_code`(`rule_code` ASC) USING BTREE,
  INDEX `idx_allocation_rule_source`(`energy_type_id` ASC, `source_branch_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_allocation_rule_effective`(`valid_from` ASC, `valid_to` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源分摊规则' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_allocation_rule
-- ----------------------------

-- ----------------------------
-- Table structure for energy_allocation_rule_target
-- ----------------------------
DROP TABLE IF EXISTS `energy_allocation_rule_target`;
CREATE TABLE `energy_allocation_rule_target`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `rule_id` bigint NOT NULL COMMENT '分摊规则ID',
  `target_area_id` bigint NULL DEFAULT NULL COMMENT '目标区域ID，与目标分项ID至少填写一个',
  `target_subitem_id` bigint NULL DEFAULT NULL COMMENT '目标分项ID，与目标区域ID至少填写一个',
  `driver_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '驱动类型：FIXED固定权重、AREA面积、PERSON人数、RUNTIME运行时长、METER表计用量、CUSTOM自定义',
  `fixed_weight` decimal(38, 12) NULL DEFAULT NULL COMMENT '固定权重；driver_type为FIXED时填写',
  `driver_config` json NULL COMMENT '动态驱动配置，例如面积字段、人数来源、运行时长点位、表计ID等',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '目标排序顺序',
  `target_area_key` bigint GENERATED ALWAYS AS (ifnull(`target_area_id`,0)) STORED COMMENT '目标区域唯一索引辅助字段' NULL,
  `target_subitem_key` bigint GENERATED ALWAYS AS (ifnull(`target_subitem_id`,0)) STORED COMMENT '目标分项唯一索引辅助字段' NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_allocation_rule_target`(`rule_id` ASC, `target_area_key` ASC, `target_subitem_key` ASC) USING BTREE,
  INDEX `idx_allocation_target_area`(`target_area_id` ASC) USING BTREE,
  INDEX `idx_allocation_target_subitem`(`target_subitem_id` ASC) USING BTREE,
  INDEX `idx_allocation_target_rule_sort`(`rule_id` ASC, `sort_order` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源分摊规则目标及驱动配置' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_allocation_rule_target
-- ----------------------------

-- ----------------------------
-- Table structure for energy_anomaly_event
-- ----------------------------
DROP TABLE IF EXISTS `energy_anomaly_event`;
CREATE TABLE `energy_anomaly_event`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `dedup_key` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '本次异常事件幂等键；同一次持续异常保持不变，恢复后再次发生应生成新值',
  `fingerprint` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '异常指纹；由规则、对象、指标和异常类型生成，用于识别同类异常',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `object_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '异常对象类型：METER逻辑计量点、BRANCH支路、AREA区域、SUBITEM分项、BUILDING建筑',
  `object_id` bigint NOT NULL COMMENT '异常对象ID',
  `rule_id` bigint NULL DEFAULT NULL COMMENT '异常规则ID；为空表示系统内置检测或人工创建',
  `metric_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '检测指标编码：CONSUMPTION、READING、AVG_POWER、DEMAND、DATA_MISSING、BALANCE_DEVIATION等',
  `anomaly_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '异常类型：OVER_LIMIT、UNDER_LIMIT、SPIKE、DATA_MISSING、NEGATIVE_USAGE、BALANCE_ERROR等',
  `period_start` datetime(6) NULL DEFAULT NULL COMMENT '异常检测数据周期开始时间',
  `period_end` datetime(6) NULL DEFAULT NULL COMMENT '异常检测数据周期结束时间',
  `first_occurred_at` datetime(6) NOT NULL COMMENT '异常首次发生时间',
  `last_occurred_at` datetime(6) NOT NULL COMMENT '最近一次检测到异常的时间',
  `occurrence_count` int NOT NULL DEFAULT 1 COMMENT '同一次持续异常累计检测次数',
  `anomaly_value` decimal(38, 12) NULL DEFAULT NULL COMMENT '最近一次异常检测值',
  `expected_value` decimal(38, 12) NULL DEFAULT NULL COMMENT '期望值、阈值或预测值',
  `deviation_rate` decimal(18, 8) NULL DEFAULT NULL COMMENT '偏差比例；小数形式，例如0.3表示30%',
  `base_unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '检测指标标准单位快照',
  `severity` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '严重程度：INFO提示、MINOR一般、MAJOR严重、CRITICAL紧急',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'OPEN' COMMENT '异常状态：OPEN待处理、ACKNOWLEDGED已确认、RECOVERED已恢复、CLOSED已关闭',
  `rule_snapshot` json NULL COMMENT '异常发生时的规则配置快照',
  `acknowledged_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '异常确认人',
  `acknowledged_at` datetime(6) NULL DEFAULT NULL COMMENT '异常确认时间',
  `recovered_at` datetime(6) NULL DEFAULT NULL COMMENT '异常恢复时间',
  `closed_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '异常关闭人',
  `closed_at` datetime(6) NULL DEFAULT NULL COMMENT '异常关闭时间',
  `close_reason` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '异常关闭原因',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '异常说明',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建人',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新人',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_anomaly_event_dedup`(`dedup_key` ASC) USING BTREE,
  INDEX `idx_anomaly_event_active`(`status` ASC, `severity` ASC, `last_occurred_at` ASC) USING BTREE,
  INDEX `idx_anomaly_event_fingerprint`(`fingerprint` ASC, `status` ASC) USING BTREE,
  INDEX `idx_anomaly_event_object_time`(`object_type` ASC, `object_id` ASC, `first_occurred_at` ASC) USING BTREE,
  INDEX `idx_anomaly_event_rule_time`(`rule_id` ASC, `first_occurred_at` ASC) USING BTREE,
  INDEX `idx_anomaly_event_energy_time`(`energy_type_id` ASC, `first_occurred_at` ASC) USING BTREE,
  INDEX `idx_anomaly_event_metric_time`(`metric_code` ASC, `anomaly_type` ASC, `first_occurred_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源异常事件；同一次持续异常聚合为一条事件' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_anomaly_event
-- ----------------------------

-- ----------------------------
-- Table structure for energy_anomaly_rule
-- ----------------------------
DROP TABLE IF EXISTS `energy_anomaly_rule`;
CREATE TABLE `energy_anomaly_rule`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `rule_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '规则编码',
  `rule_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '规则名称',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `object_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'METER' COMMENT '检测对象类型：METER逻辑计量点、BRANCH支路、AREA区域、SUBITEM分项、BUILDING建筑',
  `object_id` bigint NULL DEFAULT NULL COMMENT '检测对象ID；为空表示匹配该能源类型下全部同类对象',
  `metric_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '检测指标编码：CONSUMPTION、READING、AVG_POWER、MAX_POWER、DEMAND、DATA_MISSING、BALANCE_DEVIATION等',
  `anomaly_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '异常业务类型：OVER_LIMIT、UNDER_LIMIT、SPIKE、DATA_MISSING、NEGATIVE_USAGE、BALANCE_ERROR等',
  `rule_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '检测算法类型：THRESHOLD阈值检测、STATISTICAL统计检测、ML机器学习检测',
  `rule_config` json NOT NULL COMMENT '规则算法参数配置，例如阈值、比较符、聚合方式和模型参数',
  `evaluation_interval_sec` int NOT NULL DEFAULT 300 COMMENT '规则检测间隔，单位秒',
  `window_minutes` int NULL DEFAULT NULL COMMENT '检测数据时间窗口，单位分钟；为空表示使用当前周期数据',
  `trigger_count` int NOT NULL DEFAULT 1 COMMENT '连续满足异常条件多少次后触发异常事件',
  `recovery_count` int NOT NULL DEFAULT 1 COMMENT '连续满足正常条件多少次后判定异常恢复',
  `cooldown_minutes` int NOT NULL DEFAULT 0 COMMENT '异常恢复或关闭后的冷却时间，单位分钟',
  `severity` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '默认严重程度：INFO提示、MINOR一般、MAJOR严重、CRITICAL紧急',
  `valid_from` datetime(6) NULL DEFAULT NULL COMMENT '规则生效时间；为空表示立即生效',
  `valid_to` datetime(6) NULL DEFAULT NULL COMMENT '规则失效时间；为空表示长期有效',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'ACTIVE' COMMENT '规则状态：ACTIVE启用、DISABLED停用',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '创建人',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新人',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_anomaly_rule_code`(`rule_code` ASC) USING BTREE,
  INDEX `idx_anomaly_rule_match`(`energy_type_id` ASC, `object_type` ASC, `object_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_anomaly_rule_metric`(`metric_code` ASC, `anomaly_type` ASC, `status` ASC) USING BTREE,
  INDEX `idx_anomaly_rule_schedule`(`status` ASC, `valid_from` ASC, `valid_to` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源异常检测规则' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_anomaly_rule
-- ----------------------------

-- ----------------------------
-- Table structure for energy_area
-- ----------------------------
DROP TABLE IF EXISTS `energy_area`;
CREATE TABLE `energy_area`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `parent_area_id` bigint NULL DEFAULT NULL COMMENT '父区域ID；为空表示建筑下的根区域',
  `building_id` bigint NULL DEFAULT NULL COMMENT '所属建筑ID',
  `area_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区域编码；同一建筑下唯一',
  `area_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区域名称',
  `area_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'OTHER' COMMENT '区域类型：FLOOR楼层、ROOM房间、FUNCTIONAL功能区、PUBLIC公共区、EQUIPMENT设备区、OUTDOOR室外区域、OTHER其他',
  `building_area` decimal(16, 4) NULL DEFAULT NULL COMMENT '区域建筑面积，单位平方米；可作为面积分摊驱动值',
  `floor_num` int NULL DEFAULT NULL COMMENT '所在物理楼层编号；地下层可使用负数，跨楼层区域可为空',
  `default_personnel_count` int NULL DEFAULT 0 COMMENT '默认常驻人数；动态人数应从业务系统或设备数据获取',
  `sort_order` int NULL DEFAULT 0 COMMENT '同级区域排序顺序',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'ACTIVE' COMMENT '状态：ACTIVE启用、DISABLED停用',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建人',
  `create_time` datetime(6) NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新人',
  `update_time` datetime(6) NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_area_building_code`(`building_id` ASC, `area_code` ASC) USING BTREE,
  INDEX `idx_area_building_status`(`building_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_area_parent_status_sort`(`parent_area_id` ASC, `status` ASC, `sort_order` ASC) USING BTREE,
  INDEX `idx_area_building_floor`(`building_id` ASC, `floor_num` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源空间区域树；用于区域统计及面积、人数分摊' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_area
-- ----------------------------
INSERT INTO `energy_area` VALUES (1, NULL, 1, 'ROOT', '智慧科技办公楼', 'OTHER', 12000.0000, NULL, 500, 0, 'ACTIVE', 'admin', '2026-07-25 19:46:16.807227', '', '2026-07-26 10:29:05.680207', NULL);
INSERT INTO `energy_area` VALUES (2, 1, 1, 'F1', '一层', 'FLOOR', 2400.0000, 1, 80, 1, 'ACTIVE', 'admin', '2026-07-25 19:46:16.814165', '', '2026-07-25 19:46:16.814165', NULL);
INSERT INTO `energy_area` VALUES (3, 1, 1, 'F2', '二层', 'FLOOR', 2400.0000, 2, 120, 2, 'ACTIVE', 'admin', '2026-07-25 19:46:16.821146', '', '2026-07-25 19:46:16.821146', NULL);
INSERT INTO `energy_area` VALUES (4, 1, 1, 'F3', '三层', 'FLOOR', 2400.0000, 3, 120, 3, 'ACTIVE', 'admin', '2026-07-25 19:46:16.827121', '', '2026-07-25 19:46:16.827121', NULL);
INSERT INTO `energy_area` VALUES (5, 2, 1, 'F1-HALL', '一楼大厅', 'PUBLIC', 300.0000, 1, 20, 0, 'ACTIVE', '', '2026-07-25 19:46:16.832043', '', '2026-07-25 19:46:16.832043', NULL);
INSERT INTO `energy_area` VALUES (6, 2, 1, 'F1-MEETING', '会议室', 'FUNCTIONAL', 200.0000, 1, 50, 0, 'ACTIVE', '', '2026-07-25 19:46:16.837093', '', '2026-07-25 19:46:16.837093', NULL);
INSERT INTO `energy_area` VALUES (7, 3, 1, 'F2-IT', 'IT办公区', 'ROOM', 600.0000, 2, 80, 0, 'ACTIVE', '', '2026-07-25 19:46:16.842027', '', '2026-07-25 19:46:16.842027', NULL);

-- ----------------------------
-- Table structure for energy_area_data_daily
-- ----------------------------
DROP TABLE IF EXISTS `energy_area_data_daily`;
CREATE TABLE `energy_area_data_daily`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `area_id` bigint NOT NULL COMMENT '区域ID',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `data_date` date NOT NULL COMMENT '日期',
  `consumption` decimal(38, 12) NOT NULL COMMENT '日能源用量',
  `peak_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '峰期用量',
  `valley_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '谷期用量',
  `flat_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '平期用量',
  `max_demand` decimal(20, 6) NULL DEFAULT NULL COMMENT '最大需量',
  `avg_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '平均功率',
  `load_factor` decimal(8, 4) NULL DEFAULT NULL COMMENT '负荷率',
  `total_cost` decimal(28, 8) NULL DEFAULT NULL COMMENT '总费用',
  `carbon_emission` decimal(38, 12) NULL DEFAULT NULL COMMENT '碳排放量',
  `temperature_avg` decimal(5, 2) NULL DEFAULT NULL COMMENT '平均温度',
  `humidity_avg` decimal(5, 2) NULL DEFAULT NULL COMMENT '平均湿度',
  `is_holiday` tinyint(1) NULL DEFAULT 0 COMMENT '是否节假日',
  `is_weekend` tinyint(1) NULL DEFAULT 0 COMMENT '是否周末',
  `data_source` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'AGGREGATE' COMMENT '数据来源：METER_CALC表计计算、AGGREGATE聚合、ALLOCATION分摊、CORRECTION修正、MANUAL人工录入、MIXED混合',
  `quality_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'GOOD' COMMENT '数据质量状态：GOOD、PARTIAL、ESTIMATED、INVALID',
  `quality_codes` json NULL COMMENT '数据质量问题编码集合',
  `data_version` int NOT NULL DEFAULT 1 COMMENT '当前统计记录版本号；重算更新时递增',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '最近一次生成或重算该记录的计算批次ID',
  `last_recalc_job_id` bigint NULL DEFAULT NULL COMMENT '最近一次更新该记录的重算编排任务ID',
  `calculation_snapshot` json NULL COMMENT '计算口径、配置版本、来源范围及关键参数快照',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_area_daily_stat`(`area_id` ASC, `energy_type_id` ASC, `direction` ASC, `data_date` ASC) USING BTREE,
  INDEX `idx_area_daily_energy_time`(`energy_type_id` ASC, `direction` ASC, `data_date` ASC, `area_id` ASC) USING BTREE,
  INDEX `idx_area_daily_batch`(`calculation_batch_id` ASC, `area_id` ASC) USING BTREE,
  INDEX `idx_area_daily_recalc`(`last_recalc_job_id` ASC, `area_id` ASC) USING BTREE,
  CONSTRAINT `ck_area_daily_data_version` CHECK (`data_version` >= 1)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '区域日级统计数据' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_area_data_daily
-- ----------------------------

-- ----------------------------
-- Table structure for energy_area_data_hourly
-- ----------------------------
DROP TABLE IF EXISTS `energy_area_data_hourly`;
CREATE TABLE `energy_area_data_hourly`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `area_id` bigint NOT NULL COMMENT '区域ID',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `data_date` date NOT NULL COMMENT '日期',
  `hour_num` tinyint NOT NULL COMMENT '小时(0-23)',
  `consumption` decimal(38, 12) NOT NULL COMMENT '小时能源用量',
  `avg_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '平均功率',
  `max_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '最大功率',
  `min_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '最小功率',
  `cost` decimal(28, 8) NULL DEFAULT NULL COMMENT '费用',
  `carbon_emission` decimal(38, 12) NULL DEFAULT NULL COMMENT '碳排放量',
  `data_source` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'AGGREGATE' COMMENT '数据来源：METER_CALC表计计算、AGGREGATE聚合、ALLOCATION分摊、CORRECTION修正、MANUAL人工录入、MIXED混合',
  `quality_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'GOOD' COMMENT '数据质量状态：GOOD、PARTIAL、ESTIMATED、INVALID',
  `quality_codes` json NULL COMMENT '数据质量问题编码集合',
  `data_version` int NOT NULL DEFAULT 1 COMMENT '当前统计记录版本号；重算更新时递增',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '最近一次生成或重算该记录的计算批次ID',
  `last_recalc_job_id` bigint NULL DEFAULT NULL COMMENT '最近一次更新该记录的重算编排任务ID',
  `calculation_snapshot` json NULL COMMENT '计算口径、配置版本、来源范围及关键参数快照',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_area_hourly_stat`(`area_id` ASC, `energy_type_id` ASC, `direction` ASC, `data_date` ASC, `hour_num` ASC) USING BTREE,
  INDEX `idx_area_hourly_energy_time`(`energy_type_id` ASC, `direction` ASC, `data_date` ASC, `hour_num` ASC, `area_id` ASC) USING BTREE,
  INDEX `idx_area_hourly_batch`(`calculation_batch_id` ASC, `area_id` ASC) USING BTREE,
  INDEX `idx_area_hourly_recalc`(`last_recalc_job_id` ASC, `area_id` ASC) USING BTREE,
  CONSTRAINT `ck_area_hourly_data_version` CHECK (`data_version` >= 1)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '区域小时级统计数据' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_area_data_hourly
-- ----------------------------

-- ----------------------------
-- Table structure for energy_area_data_min
-- ----------------------------
DROP TABLE IF EXISTS `energy_area_data_min`;
CREATE TABLE `energy_area_data_min`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `area_id` bigint NOT NULL COMMENT '区域ID',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `interval_minutes` int NOT NULL COMMENT '统计间隔（分钟）',
  `record_time` datetime(6) NOT NULL COMMENT '统计周期开始时间',
  `consumption` decimal(38, 12) NOT NULL COMMENT '统计周期能源用量',
  `avg_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '平均功率',
  `max_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '最大功率',
  `min_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '最小功率',
  `data_source` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'AGGREGATE' COMMENT '数据来源：METER_CALC表计计算、AGGREGATE聚合、ALLOCATION分摊、CORRECTION修正、MANUAL人工录入、MIXED混合',
  `quality_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'GOOD' COMMENT '数据质量状态：GOOD、PARTIAL、ESTIMATED、INVALID',
  `quality_codes` json NULL COMMENT '数据质量问题编码集合',
  `data_version` int NOT NULL DEFAULT 1 COMMENT '当前统计记录版本号；重算更新时递增',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '最近一次生成或重算该记录的计算批次ID',
  `last_recalc_job_id` bigint NULL DEFAULT NULL COMMENT '最近一次更新该记录的重算编排任务ID',
  `calculation_snapshot` json NULL COMMENT '计算口径、配置版本、来源范围及关键参数快照',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_area_min_stat`(`area_id` ASC, `energy_type_id` ASC, `direction` ASC, `record_time` ASC, `interval_minutes` ASC) USING BTREE,
  INDEX `idx_area_min_energy_time`(`energy_type_id` ASC, `direction` ASC, `record_time` ASC, `interval_minutes` ASC, `area_id` ASC) USING BTREE,
  INDEX `idx_area_min_batch`(`calculation_batch_id` ASC, `area_id` ASC) USING BTREE,
  INDEX `idx_area_min_recalc`(`last_recalc_job_id` ASC, `area_id` ASC) USING BTREE,
  CONSTRAINT `ck_area_min_data_version` CHECK (`data_version` >= 1)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '区域分钟级统计数据；record_time为统计周期开始时间' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_area_data_min
-- ----------------------------

-- ----------------------------
-- Table structure for energy_area_data_monthly
-- ----------------------------
DROP TABLE IF EXISTS `energy_area_data_monthly`;
CREATE TABLE `energy_area_data_monthly`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `area_id` bigint NOT NULL COMMENT '区域ID',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `year_num` int NOT NULL COMMENT '年份',
  `month_num` tinyint NOT NULL COMMENT '月份',
  `consumption` decimal(38, 12) NOT NULL COMMENT '月能源用量',
  `peak_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '峰期用量',
  `valley_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '谷期用量',
  `flat_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '平期用量',
  `max_demand` decimal(20, 6) NULL DEFAULT NULL COMMENT '最大需量',
  `avg_demand` decimal(20, 6) NULL DEFAULT NULL COMMENT '平均需量',
  `load_factor` decimal(8, 4) NULL DEFAULT NULL COMMENT '负荷率',
  `total_cost` decimal(28, 8) NULL DEFAULT NULL COMMENT '总费用',
  `carbon_emission` decimal(38, 12) NULL DEFAULT NULL COMMENT '碳排放量',
  `working_days` int NULL DEFAULT NULL COMMENT '工作日天数',
  `weekend_days` int NULL DEFAULT NULL COMMENT '周末天数',
  `holiday_days` int NULL DEFAULT NULL COMMENT '节假日天数',
  `data_source` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'AGGREGATE' COMMENT '数据来源：METER_CALC表计计算、AGGREGATE聚合、ALLOCATION分摊、CORRECTION修正、MANUAL人工录入、MIXED混合',
  `quality_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'GOOD' COMMENT '数据质量状态：GOOD、PARTIAL、ESTIMATED、INVALID',
  `quality_codes` json NULL COMMENT '数据质量问题编码集合',
  `data_version` int NOT NULL DEFAULT 1 COMMENT '当前统计记录版本号；重算更新时递增',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '最近一次生成或重算该记录的计算批次ID',
  `last_recalc_job_id` bigint NULL DEFAULT NULL COMMENT '最近一次更新该记录的重算编排任务ID',
  `calculation_snapshot` json NULL COMMENT '计算口径、配置版本、来源范围及关键参数快照',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_area_monthly_stat`(`area_id` ASC, `energy_type_id` ASC, `direction` ASC, `year_num` ASC, `month_num` ASC) USING BTREE,
  INDEX `idx_area_monthly_energy_time`(`energy_type_id` ASC, `direction` ASC, `year_num` ASC, `month_num` ASC, `area_id` ASC) USING BTREE,
  INDEX `idx_area_monthly_batch`(`calculation_batch_id` ASC, `area_id` ASC) USING BTREE,
  INDEX `idx_area_monthly_recalc`(`last_recalc_job_id` ASC, `area_id` ASC) USING BTREE,
  CONSTRAINT `ck_area_monthly_data_version` CHECK (`data_version` >= 1)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '区域月级统计数据' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_area_data_monthly
-- ----------------------------

-- ----------------------------
-- Table structure for energy_area_data_yearly
-- ----------------------------
DROP TABLE IF EXISTS `energy_area_data_yearly`;
CREATE TABLE `energy_area_data_yearly`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `area_id` bigint NOT NULL COMMENT '区域ID',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `year_num` int NOT NULL COMMENT '年份',
  `consumption` decimal(38, 12) NOT NULL COMMENT '年能源用量',
  `total_cost` decimal(28, 8) NULL DEFAULT NULL COMMENT '总费用',
  `carbon_emission` decimal(38, 12) NULL DEFAULT NULL COMMENT '碳排放量',
  `unit_area_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '单位面积能耗',
  `unit_person_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '人均能耗',
  `data_source` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'AGGREGATE' COMMENT '数据来源：METER_CALC表计计算、AGGREGATE聚合、ALLOCATION分摊、CORRECTION修正、MANUAL人工录入、MIXED混合',
  `quality_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'GOOD' COMMENT '数据质量状态：GOOD、PARTIAL、ESTIMATED、INVALID',
  `quality_codes` json NULL COMMENT '数据质量问题编码集合',
  `data_version` int NOT NULL DEFAULT 1 COMMENT '当前统计记录版本号；重算更新时递增',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '最近一次生成或重算该记录的计算批次ID',
  `last_recalc_job_id` bigint NULL DEFAULT NULL COMMENT '最近一次更新该记录的重算编排任务ID',
  `calculation_snapshot` json NULL COMMENT '计算口径、配置版本、来源范围及关键参数快照',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_area_yearly_stat`(`area_id` ASC, `energy_type_id` ASC, `direction` ASC, `year_num` ASC) USING BTREE,
  INDEX `idx_area_yearly_energy_time`(`energy_type_id` ASC, `direction` ASC, `year_num` ASC, `area_id` ASC) USING BTREE,
  INDEX `idx_area_yearly_batch`(`calculation_batch_id` ASC, `area_id` ASC) USING BTREE,
  INDEX `idx_area_yearly_recalc`(`last_recalc_job_id` ASC, `area_id` ASC) USING BTREE,
  CONSTRAINT `ck_area_yearly_data_version` CHECK (`data_version` >= 1)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '区域年级统计数据' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_area_data_yearly
-- ----------------------------

-- ----------------------------
-- Table structure for energy_benchmark
-- ----------------------------
DROP TABLE IF EXISTS `energy_benchmark`;
CREATE TABLE `energy_benchmark`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `benchmark_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '基准编码',
  `benchmark_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '基准名称',
  `building_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '建筑类型',
  `climate_zone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '气候时区',
  `floor_area_min` decimal(14, 2) NULL DEFAULT NULL COMMENT '适用建筑面积下限',
  `floor_area_max` decimal(14, 2) NULL DEFAULT NULL COMMENT '适用建筑面积上限',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `benchmark_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'INTERNAL/INDUSTRY/NATIONAL',
  `reference_standard` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '引用标准',
  `unit_consumption` decimal(28, 12) NOT NULL COMMENT '单位能耗基准值',
  `base_unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标准单位',
  `normalized_unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '例如kWh/(m²·a)',
  `source` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '来源',
  `valid_from` date NOT NULL COMMENT '有效起始',
  `valid_to` date NULL DEFAULT NULL COMMENT '有效目标',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'DRAFT' COMMENT '状态',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '创建人',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新人',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_benchmark_code`(`benchmark_code` ASC) USING BTREE,
  INDEX `idx_benchmark_match`(`energy_type_id` ASC, `building_type` ASC, `climate_zone` ASC, `status` ASC) USING BTREE,
  CONSTRAINT `ck_benchmark_area` CHECK ((`floor_area_min` is null) or (`floor_area_max` is null) or (`floor_area_max` > `floor_area_min`)),
  CONSTRAINT `ck_benchmark_range` CHECK ((`valid_to` is null) or (`valid_to` > `valid_from`))
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能效基准' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_benchmark
-- ----------------------------

-- ----------------------------
-- Table structure for energy_benchmark_result
-- ----------------------------
DROP TABLE IF EXISTS `energy_benchmark_result`;
CREATE TABLE `energy_benchmark_result`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `building_id` bigint NOT NULL COMMENT '建筑ID',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `benchmark_id` bigint NOT NULL COMMENT '能效基准ID',
  `data_source_snapshot` json NULL COMMENT '参与基准计算的统计表、记录ID及汇总口径快照',
  `period_start` datetime(6) NOT NULL COMMENT '周期开始',
  `period_end` datetime(6) NOT NULL COMMENT '周期结束',
  `actual_consumption` decimal(38, 12) NOT NULL COMMENT '实际能耗',
  `benchmark_consumption` decimal(38, 12) NOT NULL COMMENT '基准能耗',
  `normalized_actual` decimal(38, 12) NULL DEFAULT NULL COMMENT '归一化实际能耗',
  `normalized_benchmark` decimal(38, 12) NULL DEFAULT NULL COMMENT '归一化基准能耗',
  `normalized_unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '归一化指标单位',
  `result_version` int NOT NULL DEFAULT 1 COMMENT '结果版本号',
  `is_current` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否当前有效版本',
  `current_key` tinyint GENERATED ALWAYS AS ((case when (`is_current` = 1) then 1 else NULL end)) STORED COMMENT '当前版本唯一索引辅助字段' NULL,
  `supersedes_result_id` bigint NULL DEFAULT NULL COMMENT '被本版本替代的基准结果ID',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '计算批次ID',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_benchmark_result_version`(`building_id` ASC, `energy_type_id` ASC, `direction` ASC, `benchmark_id` ASC, `period_start` ASC, `period_end` ASC, `result_version` ASC) USING BTREE,
  UNIQUE INDEX `uk_benchmark_result_current`(`building_id` ASC, `energy_type_id` ASC, `direction` ASC, `benchmark_id` ASC, `period_start` ASC, `period_end` ASC, `current_key` ASC) USING BTREE,
  INDEX `idx_benchmark_result_period`(`building_id` ASC, `energy_type_id` ASC, `period_start` ASC) USING BTREE,
  INDEX `fk_benchmark_result_energy`(`energy_type_id` ASC) USING BTREE,
  INDEX `fk_benchmark_result_benchmark`(`benchmark_id` ASC) USING BTREE,
  INDEX `idx_benchmark_result_batch`(`calculation_batch_id` ASC, `create_time` ASC) USING BTREE,
  CONSTRAINT `ck_benchmark_result_period` CHECK (`period_end` > `period_start`),
  CONSTRAINT `ck_benchmark_result_version` CHECK (`result_version` >= 1)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '可追溯能效基准对比结果' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_benchmark_result
-- ----------------------------

-- ----------------------------
-- Table structure for energy_billing_statement
-- ----------------------------
DROP TABLE IF EXISTS `energy_billing_statement`;
CREATE TABLE `energy_billing_statement`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `statement_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '账单编号',
  `statement_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '账单类型：TRIAL试算、FINAL正式、REVERSAL冲销',
  `statement_version` int NOT NULL DEFAULT 1 COMMENT '账单版本号',
  `is_current` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否当前有效账单版本',
  `current_key` tinyint GENERATED ALWAYS AS ((case when (`is_current` = 1) then 1 else NULL end)) STORED COMMENT '当前账单唯一索引辅助字段' NULL,
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `account_object_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '计费对象类型',
  `account_object_id` bigint NOT NULL COMMENT '计费对象ID',
  `period_start` datetime(6) NOT NULL COMMENT '周期开始',
  `period_end` datetime(6) NOT NULL COMMENT '周期结束',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'TRIAL' COMMENT '状态',
  `currency_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'CNY' COMMENT '货币编码',
  `base_unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标准单位',
  `quantity` decimal(38, 12) NOT NULL COMMENT '用量',
  `amount_ex_tax` decimal(28, 8) NOT NULL COMMENT '未税金额',
  `tax_amount` decimal(28, 8) NOT NULL DEFAULT 0.00000000 COMMENT '税金额',
  `amount_total` decimal(28, 8) NOT NULL COMMENT '含税总金额',
  `tariff_snapshot` json NOT NULL COMMENT '费率政策快照',
  `calculation_detail` json NOT NULL COMMENT '账单计算明细',
  `locked_at` datetime(6) NULL DEFAULT NULL COMMENT '锁定时间',
  `reversal_statement_id` bigint NULL DEFAULT NULL COMMENT '该账单被冲销时，对应的冲销账单ID',
  `supersedes_statement_id` bigint NULL DEFAULT NULL COMMENT '被本账单替代的上一版本账单ID',
  `reversal_of_statement_id` bigint NULL DEFAULT NULL COMMENT '冲销账单对应的原账单ID',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '计费计算批次ID',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_statement_no`(`statement_no` ASC) USING BTREE,
  UNIQUE INDEX `uk_statement_period_version`(`energy_type_id` ASC, `direction` ASC, `account_object_type` ASC, `account_object_id` ASC, `period_start` ASC, `period_end` ASC, `statement_type` ASC, `statement_version` ASC) USING BTREE,
  UNIQUE INDEX `uk_statement_period_current`(`energy_type_id` ASC, `direction` ASC, `account_object_type` ASC, `account_object_id` ASC, `period_start` ASC, `period_end` ASC, `statement_type` ASC, `current_key` ASC) USING BTREE,
  INDEX `idx_statement_period`(`account_object_type` ASC, `account_object_id` ASC, `period_start` ASC, `status` ASC) USING BTREE,
  INDEX `idx_statement_reversal`(`reversal_statement_id` ASC) USING BTREE,
  INDEX `idx_statement_reversal_of`(`reversal_of_statement_id` ASC) USING BTREE,
  INDEX `idx_statement_supersedes`(`supersedes_statement_id` ASC) USING BTREE,
  INDEX `idx_statement_batch`(`calculation_batch_id` ASC, `created_at` ASC) USING BTREE,
  CONSTRAINT `ck_statement_amount` CHECK ((`quantity` >= 0) and (`amount_total` = (`amount_ex_tax` + `tax_amount`))),
  CONSTRAINT `ck_statement_period` CHECK (`period_end` > `period_start`),
  CONSTRAINT `ck_statement_reversal_relation` CHECK (((`statement_type` = _utf8mb4'REVERSAL') and (`reversal_of_statement_id` is not null)) or ((`statement_type` <> _utf8mb4'REVERSAL') and (`reversal_of_statement_id` is null))),
  CONSTRAINT `ck_statement_version` CHECK (`statement_version` >= 1)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源账单头' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_billing_statement
-- ----------------------------

-- ----------------------------
-- Table structure for energy_billing_statement_line
-- ----------------------------
DROP TABLE IF EXISTS `energy_billing_statement_line`;
CREATE TABLE `energy_billing_statement_line`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `statement_id` bigint NOT NULL COMMENT '账单ID',
  `source_data_table` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '来源统计表名；基础费、税费、调整项可为空',
  `source_data_id` bigint NULL DEFAULT NULL COMMENT '来源统计表记录ID；基础费、税费、调整项可为空',
  `tariff_detail_id` bigint NULL DEFAULT NULL COMMENT '费率明细ID',
  `line_type` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'USAGE/PEAK/VALLEY/FLAT/TIER/BASE_FEE/TAX/ADJUSTMENT',
  `period_start` datetime(6) NULL DEFAULT NULL COMMENT '周期开始',
  `period_end` datetime(6) NULL DEFAULT NULL COMMENT '周期结束',
  `quantity` decimal(38, 12) NULL DEFAULT NULL COMMENT '用量',
  `unit_price` decimal(28, 12) NULL DEFAULT NULL COMMENT '单位单价',
  `amount` decimal(28, 8) NOT NULL COMMENT '金额',
  `calculation_snapshot` json NOT NULL COMMENT '明细计算快照',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_statement_line`(`statement_id` ASC, `line_type` ASC) USING BTREE,
  INDEX `fk_statement_line_tariff`(`tariff_detail_id` ASC) USING BTREE,
  INDEX `idx_statement_source_data`(`source_data_table` ASC, `source_data_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '账单峰平谷、阶梯及费用明细' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_billing_statement_line
-- ----------------------------

-- ----------------------------
-- Table structure for energy_branch_dimension_binding
-- ----------------------------
DROP TABLE IF EXISTS `energy_branch_dimension_binding`;
CREATE TABLE `energy_branch_dimension_binding`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `branch_id` bigint NOT NULL COMMENT '能源支路ID',
  `area_id` bigint NULL DEFAULT NULL COMMENT '直接归属区域ID；与sub_item_id至少填写一个',
  `sub_item_id` bigint NULL DEFAULT NULL COMMENT '直接归属能源分项ID；与area_id至少填写一个',
  `area_coverage_scope` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区域覆盖范围：NODE_SELF当前区域自身、SUBTREE_TOTAL当前区域及子区域',
  `sub_item_coverage_scope` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分项覆盖范围：NODE_SELF当前分项自身、SUBTREE_TOTAL当前分项及子分项',
  `valid_from` datetime(6) NOT NULL COMMENT '归属配置生效时间',
  `valid_to` datetime(6) NULL DEFAULT NULL COMMENT '归属配置失效时间；为空表示当前有效',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'ACTIVE' COMMENT '状态：ACTIVE启用、DISABLED停用',
  `binding_source` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'MANUAL' COMMENT '配置来源：BRANCH_LEGACY、METER_LEGACY、MANUAL',
  `area_key` bigint GENERATED ALWAYS AS (ifnull(`area_id`,0)) STORED COMMENT '区域唯一索引辅助字段' NULL,
  `sub_item_key` bigint GENERATED ALWAYS AS (ifnull(`sub_item_id`,0)) STORED COMMENT '分项唯一索引辅助字段' NULL,
  `current_key` tinyint GENERATED ALWAYS AS ((case when ((`status` = _utf8mb4'ACTIVE') and (`valid_to` is null)) then 1 else NULL end)) STORED COMMENT '当前有效归属唯一索引辅助字段' NULL,
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '配置说明',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_branch_dimension_version`(`branch_id` ASC) USING BTREE,
  UNIQUE INDEX `uk_branch_dimension_current`(`branch_id` ASC, `current_key` ASC) USING BTREE,
  UNIQUE INDEX `uk_branch_dimension_target_version`(`branch_id` ASC, `area_key` ASC, `sub_item_key` ASC, `valid_from` ASC) USING BTREE,
  INDEX `idx_branch_dimension_area`(`area_id` ASC, `status` ASC, `valid_from` ASC, `valid_to` ASC) USING BTREE,
  INDEX `idx_branch_dimension_sub_item`(`sub_item_id` ASC, `status` ASC, `valid_from` ASC, `valid_to` ASC) USING BTREE,
  CONSTRAINT `ck_branch_dimension_area_scope` CHECK (((`area_id` is null) and (`area_coverage_scope` is null)) or ((`area_id` is not null) and (`area_coverage_scope` is not null))),
  CONSTRAINT `ck_branch_dimension_range` CHECK ((`valid_to` is null) or (`valid_to` > `valid_from`)),
  CONSTRAINT `ck_branch_dimension_subitem_scope` CHECK (((`sub_item_id` is null) and (`sub_item_coverage_scope` is null)) or ((`sub_item_id` is not null) and (`sub_item_coverage_scope` is not null))),
  CONSTRAINT `ck_branch_dimension_target` CHECK ((`area_id` is not null) or (`sub_item_id` is not null))
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源支路到区域及能源分项的唯一权威归属配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of energy_branch_dimension_binding
-- ----------------------------
INSERT INTO `energy_branch_dimension_binding` VALUES (1, 2, 5, 3, 'NODE_SELF', 'NODE_SELF', '2024-10-01 20:46:24.000000', NULL, 'ACTIVE', 'MANUAL', DEFAULT, DEFAULT, DEFAULT, '', '2024-10-01 20:46:24.000000', '2024-10-01 20:46:24.000000');
INSERT INTO `energy_branch_dimension_binding` VALUES (2, 1, 6, 3, 'NODE_SELF', 'NODE_SELF', '2024-10-01 20:46:24.000000', NULL, 'ACTIVE', 'MANUAL', DEFAULT, DEFAULT, DEFAULT, '', '2024-10-01 20:46:24.000000', '2024-10-01 20:46:24.000000');
INSERT INTO `energy_branch_dimension_binding` VALUES (3, 5, 6, 5, 'NODE_SELF', 'NODE_SELF', '2024-10-01 20:46:24.000000', NULL, 'ACTIVE', 'MANUAL', DEFAULT, DEFAULT, DEFAULT, '', '2024-10-01 20:46:24.000000', '2024-10-01 20:46:24.000000');
INSERT INTO `energy_branch_dimension_binding` VALUES (4, 6, 7, 3, 'NODE_SELF', 'NODE_SELF', '2024-10-01 20:46:24.000000', NULL, 'ACTIVE', 'MANUAL', DEFAULT, DEFAULT, DEFAULT, '', '2024-10-01 20:46:24.000000', '2024-10-01 20:46:24.000000');

-- ----------------------------
-- Table structure for energy_branch_line
-- ----------------------------
DROP TABLE IF EXISTS `energy_branch_line`;
CREATE TABLE `energy_branch_line`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `parent_id` bigint NULL DEFAULT NULL COMMENT '父支路ID',
  `building_id` bigint NULL DEFAULT NULL COMMENT '建筑ID',
  `energy_type_id` bigint NULL DEFAULT NULL COMMENT '能源类型ID',
  `branch_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '支路编码',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '名称',
  `location` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '位置',
  `attribution_mode` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'UNASSIGNED' COMMENT '能耗归属模式：DIRECT使用energy_branch_dimension_binding、ALLOCATE使用分摊规则、UNASSIGNED未配置',
  `sort_order` int NULL DEFAULT 0 COMMENT '同级支路排序顺序',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'ACTIVE' COMMENT '状态',
  `install_date` datetime(6) NULL DEFAULT NULL COMMENT '安装日期',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建人',
  `create_time` datetime(6) NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新人',
  `update_time` datetime(6) NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_branch_code`(`branch_code` ASC) USING BTREE,
  INDEX `idx_branch_building_energy`(`building_id` ASC, `energy_type_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_branch_energy`(`energy_type_id` ASC) USING BTREE,
  INDEX `idx_branch_parent_status_sort`(`parent_id` ASC, `status` ASC, `sort_order` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源支路主数据；parent_id维护输配拓扑，区域和分项归属统一由energy_branch_dimension_binding维护' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_branch_line
-- ----------------------------
INSERT INTO `energy_branch_line` VALUES (1, NULL, 1, 1, 'EL-MAIN', '建筑总进线', '地下配电室', 'DIRECT', 0, 'ACTIVE', NULL, 'admin', '2024-10-01 20:46:24.000000', '', '2024-10-01 20:46:24.000000', NULL);
INSERT INTO `energy_branch_line` VALUES (2, 1, 1, 1, 'EL-F1', '一楼配电', '一楼配电箱', 'DIRECT', 1, 'ACTIVE', NULL, '', '2024-10-01 20:46:24.000000', '', '2024-10-01 20:46:24.000000', NULL);
INSERT INTO `energy_branch_line` VALUES (3, 1, 1, 1, 'EL-F2', '二楼配电', '二楼配电箱', 'DIRECT', 2, 'ACTIVE', NULL, '', '2024-10-01 20:46:24.000000', '', '2024-10-01 20:46:24.000000', NULL);
INSERT INTO `energy_branch_line` VALUES (4, 1, 1, 1, 'EL-HVAC', '中央空调系统', '机房', 'DIRECT', 3, 'ACTIVE', NULL, '', '2024-10-01 20:46:24.000000', '', '2024-10-01 20:46:24.000000', NULL);
INSERT INTO `energy_branch_line` VALUES (5, 2, 1, 1, 'EL-F1-LIGHT', '一楼照明', '一楼配电箱', 'DIRECT', 0, 'ACTIVE', NULL, '', '2024-10-01 20:46:24.000000', '', '2024-10-01 20:46:24.000000', NULL);
INSERT INTO `energy_branch_line` VALUES (6, 2, 1, 1, 'EL-F1-SOCKET', '一楼插座', '一楼配电箱', 'DIRECT', 0, 'ACTIVE', NULL, '', '2024-10-01 20:46:24.000000', '', '2024-10-01 20:46:24.000000', NULL);
INSERT INTO `energy_branch_line` VALUES (7, 3, 1, 1, 'EL-F2-OFFICE', '二楼办公用电', '二楼配电箱', 'DIRECT', 0, 'ACTIVE', NULL, '', '2024-10-01 20:46:24.000000', '', '2024-10-01 20:46:24.000000', NULL);

-- ----------------------------
-- Table structure for energy_carbon_conversion_fact
-- ----------------------------
DROP TABLE IF EXISTS `energy_carbon_conversion_fact`;
CREATE TABLE `energy_carbon_conversion_fact`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `source_data_table` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '来源统计表名',
  `source_data_id` bigint NULL DEFAULT NULL COMMENT '来源统计表记录ID',
  `energy_type_id` bigint NULL DEFAULT NULL COMMENT '能源类型ID快照',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `object_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '统计对象类型：METER、LINE、AREA、ITEM',
  `object_id` bigint NULL DEFAULT NULL COMMENT '统计对象ID',
  `period_start` datetime(6) NULL DEFAULT NULL COMMENT '统计周期开始时间',
  `period_end` datetime(6) NULL DEFAULT NULL COMMENT '统计周期结束时间',
  `factor_id` bigint NULL DEFAULT NULL COMMENT '换算因子ID',
  `factor_type` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '因子类型',
  `accounting_method` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'DEFAULT' COMMENT '核算方法快照：DEFAULT、LOCATION_BASED、MARKET_BASED、SUPPLIER_SPECIFIC',
  `source_quantity` decimal(38, 12) NULL DEFAULT NULL COMMENT '参与换算的能源用量快照',
  `source_unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '参与换算的能源用量单位快照',
  `factor_value` decimal(28, 12) NULL DEFAULT NULL COMMENT '计算时使用的换算因子数值快照',
  `factor_source_unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '换算因子源单位快照',
  `factor_target_unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '换算因子目标单位快照',
  `result_value` decimal(38, 12) NULL DEFAULT NULL COMMENT '换算结果值；正常换算结果应大于等于0，由应用层校验',
  `result_unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '换算结果单位快照',
  `result_version` int NOT NULL DEFAULT 1 COMMENT '换算结果版本号',
  `is_current` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否当前有效版本',
  `current_key` tinyint GENERATED ALWAYS AS ((case when (`is_current` = 1) then 1 else NULL end)) STORED COMMENT '当前版本唯一索引辅助字段' NULL,
  `supersedes_result_id` bigint NULL DEFAULT NULL COMMENT '被本版本替代的换算结果ID',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '计算批次ID',
  `created_at` datetime(6) NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_conversion_source_version`(`source_data_table` ASC, `source_data_id` ASC, `factor_type` ASC, `accounting_method` ASC, `result_version` ASC) USING BTREE,
  UNIQUE INDEX `uk_conversion_source_current`(`source_data_table` ASC, `source_data_id` ASC, `factor_type` ASC, `accounting_method` ASC, `current_key` ASC) USING BTREE,
  INDEX `idx_conversion_factor`(`factor_id` ASC) USING BTREE,
  INDEX `idx_conversion_type_method`(`factor_type` ASC, `accounting_method` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_conversion_object_period`(`object_type` ASC, `object_id` ASC, `energy_type_id` ASC, `period_start` ASC) USING BTREE,
  INDEX `idx_conversion_batch`(`calculation_batch_id` ASC, `created_at` ASC) USING BTREE,
  CONSTRAINT `ck_conversion_result_version` CHECK (`result_version` >= 1)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源用量对应的碳排放或标准煤换算结果；保留用量及因子计算快照' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_carbon_conversion_fact
-- ----------------------------

-- ----------------------------
-- Table structure for energy_carbon_factor
-- ----------------------------
DROP TABLE IF EXISTS `energy_carbon_factor`;
CREATE TABLE `energy_carbon_factor`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `factor_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '因子编码',
  `energy_type_id` bigint NULL DEFAULT NULL COMMENT '能源类型ID',
  `factor_type` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '因子类型：CO2E碳排放、STANDARD_COAL标准煤',
  `accounting_method` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'DEFAULT' COMMENT '核算方法：DEFAULT默认、LOCATION_BASED位置法、MARKET_BASED市场法、SUPPLIER_SPECIFIC供应商特定',
  `region_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区域编码',
  `supplier_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '供应商编码',
  `factor_value` decimal(28, 12) NULL DEFAULT NULL COMMENT '单位能源用量对应的换算因子数值',
  `source_unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '因子源单位，应与能源用量标准单位一致',
  `target_unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '换算目标单位，例如kgCO2e、tCO2e、kgce、tce',
  `source_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '来源名称',
  `priority` int NULL DEFAULT 0 COMMENT '因子匹配优先级；数值越大优先级越高',
  `valid_from` date NULL DEFAULT NULL COMMENT '有效起始',
  `valid_to` date NULL DEFAULT NULL COMMENT '有效结束日期；为空表示长期有效',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'DRAFT' COMMENT '状态：DRAFT草稿、ACTIVE启用、DISABLED停用',
  `approved_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审核人',
  `approved_at` datetime(6) NULL DEFAULT NULL COMMENT '审核时间',
  `created_at` datetime(6) NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_factor_code`(`factor_code` ASC) USING BTREE,
  INDEX `idx_factor_match`(`energy_type_id` ASC, `factor_type` ASC, `accounting_method` ASC, `status` ASC, `region_code` ASC, `supplier_code` ASC, `valid_from` ASC, `valid_to` ASC, `priority` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源碳排放及标准煤换算因子；支持地区、供应商、核算方法和有效期匹配' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_carbon_factor
-- ----------------------------

-- ----------------------------
-- Table structure for energy_config_validation_issue
-- ----------------------------
DROP TABLE IF EXISTS `energy_config_validation_issue`;
CREATE TABLE `energy_config_validation_issue`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `issue_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '问题类型',
  `object_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '问题对象类型：METER、BRANCH、FORMULA等',
  `object_id` bigint NOT NULL COMMENT '问题对象ID',
  `severity` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'ERROR' COMMENT '严重程度：WARNING、ERROR',
  `detail_json` json NULL COMMENT '问题详情',
  `resolved` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已解决：0否、1是',
  `resolved_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '解决人',
  `resolved_at` datetime(6) NULL DEFAULT NULL COMMENT '解决时间',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_energy_config_issue`(`issue_type` ASC, `object_type` ASC, `object_id` ASC, `resolved` ASC) USING BTREE,
  INDEX `idx_energy_config_issue_unresolved`(`resolved` ASC, `severity` ASC, `issue_type` ASC, `created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能耗配置迁移及运行校验问题' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of energy_config_validation_issue
-- ----------------------------

-- ----------------------------
-- Table structure for energy_item_data_daily
-- ----------------------------
DROP TABLE IF EXISTS `energy_item_data_daily`;
CREATE TABLE `energy_item_data_daily`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `item_id` bigint NOT NULL COMMENT '分项ID',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `data_date` date NOT NULL COMMENT '日期',
  `consumption` decimal(38, 12) NOT NULL COMMENT '日能源用量',
  `peak_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '峰期用量',
  `valley_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '谷期用量',
  `flat_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '平期用量',
  `max_demand` decimal(20, 6) NULL DEFAULT NULL COMMENT '最大需量',
  `avg_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '平均功率',
  `load_factor` decimal(8, 4) NULL DEFAULT NULL COMMENT '负荷率',
  `total_cost` decimal(28, 8) NULL DEFAULT NULL COMMENT '总费用',
  `carbon_emission` decimal(38, 12) NULL DEFAULT NULL COMMENT '碳排放量',
  `temperature_avg` decimal(5, 2) NULL DEFAULT NULL COMMENT '平均温度',
  `humidity_avg` decimal(5, 2) NULL DEFAULT NULL COMMENT '平均湿度',
  `is_holiday` tinyint(1) NULL DEFAULT 0 COMMENT '是否节假日',
  `is_weekend` tinyint(1) NULL DEFAULT 0 COMMENT '是否周末',
  `data_source` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'AGGREGATE' COMMENT '数据来源：METER_CALC表计计算、AGGREGATE聚合、ALLOCATION分摊、CORRECTION修正、MANUAL人工录入、MIXED混合',
  `quality_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'GOOD' COMMENT '数据质量状态：GOOD、PARTIAL、ESTIMATED、INVALID',
  `quality_codes` json NULL COMMENT '数据质量问题编码集合',
  `data_version` int NOT NULL DEFAULT 1 COMMENT '当前统计记录版本号；重算更新时递增',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '最近一次生成或重算该记录的计算批次ID',
  `last_recalc_job_id` bigint NULL DEFAULT NULL COMMENT '最近一次更新该记录的重算编排任务ID',
  `calculation_snapshot` json NULL COMMENT '计算口径、配置版本、来源范围及关键参数快照',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_item_daily_stat`(`item_id` ASC, `energy_type_id` ASC, `direction` ASC, `data_date` ASC) USING BTREE,
  INDEX `idx_item_daily_energy_time`(`energy_type_id` ASC, `direction` ASC, `data_date` ASC, `item_id` ASC) USING BTREE,
  INDEX `idx_item_daily_batch`(`calculation_batch_id` ASC, `item_id` ASC) USING BTREE,
  INDEX `idx_item_daily_recalc`(`last_recalc_job_id` ASC, `item_id` ASC) USING BTREE,
  CONSTRAINT `ck_item_daily_data_version` CHECK (`data_version` >= 1)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源分项日级统计数据' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_item_data_daily
-- ----------------------------

-- ----------------------------
-- Table structure for energy_item_data_hourly
-- ----------------------------
DROP TABLE IF EXISTS `energy_item_data_hourly`;
CREATE TABLE `energy_item_data_hourly`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `item_id` bigint NOT NULL COMMENT '分项ID',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `data_date` date NOT NULL COMMENT '日期',
  `hour_num` tinyint NOT NULL COMMENT '小时(0-23)',
  `consumption` decimal(38, 12) NOT NULL COMMENT '小时能源用量',
  `avg_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '平均功率',
  `max_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '最大功率',
  `min_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '最小功率',
  `cost` decimal(28, 8) NULL DEFAULT NULL COMMENT '费用',
  `carbon_emission` decimal(38, 12) NULL DEFAULT NULL COMMENT '碳排放量',
  `data_source` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'AGGREGATE' COMMENT '数据来源：METER_CALC表计计算、AGGREGATE聚合、ALLOCATION分摊、CORRECTION修正、MANUAL人工录入、MIXED混合',
  `quality_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'GOOD' COMMENT '数据质量状态：GOOD、PARTIAL、ESTIMATED、INVALID',
  `quality_codes` json NULL COMMENT '数据质量问题编码集合',
  `data_version` int NOT NULL DEFAULT 1 COMMENT '当前统计记录版本号；重算更新时递增',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '最近一次生成或重算该记录的计算批次ID',
  `last_recalc_job_id` bigint NULL DEFAULT NULL COMMENT '最近一次更新该记录的重算编排任务ID',
  `calculation_snapshot` json NULL COMMENT '计算口径、配置版本、来源范围及关键参数快照',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_item_hourly_stat`(`item_id` ASC, `energy_type_id` ASC, `direction` ASC, `data_date` ASC, `hour_num` ASC) USING BTREE,
  INDEX `idx_item_hourly_energy_time`(`energy_type_id` ASC, `direction` ASC, `data_date` ASC, `hour_num` ASC, `item_id` ASC) USING BTREE,
  INDEX `idx_item_hourly_batch`(`calculation_batch_id` ASC, `item_id` ASC) USING BTREE,
  INDEX `idx_item_hourly_recalc`(`last_recalc_job_id` ASC, `item_id` ASC) USING BTREE,
  CONSTRAINT `ck_item_hourly_data_version` CHECK (`data_version` >= 1)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源分项小时级统计数据' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_item_data_hourly
-- ----------------------------

-- ----------------------------
-- Table structure for energy_item_data_min
-- ----------------------------
DROP TABLE IF EXISTS `energy_item_data_min`;
CREATE TABLE `energy_item_data_min`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `item_id` bigint NOT NULL COMMENT '分项ID',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `interval_minutes` int NOT NULL COMMENT '统计间隔（分钟）',
  `record_time` datetime(6) NOT NULL COMMENT '统计周期开始时间',
  `consumption` decimal(38, 12) NOT NULL COMMENT '统计周期能源用量',
  `avg_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '平均功率',
  `max_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '最大功率',
  `min_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '最小功率',
  `data_source` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'AGGREGATE' COMMENT '数据来源：METER_CALC表计计算、AGGREGATE聚合、ALLOCATION分摊、CORRECTION修正、MANUAL人工录入、MIXED混合',
  `quality_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'GOOD' COMMENT '数据质量状态：GOOD、PARTIAL、ESTIMATED、INVALID',
  `quality_codes` json NULL COMMENT '数据质量问题编码集合',
  `data_version` int NOT NULL DEFAULT 1 COMMENT '当前统计记录版本号；重算更新时递增',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '最近一次生成或重算该记录的计算批次ID',
  `last_recalc_job_id` bigint NULL DEFAULT NULL COMMENT '最近一次更新该记录的重算编排任务ID',
  `calculation_snapshot` json NULL COMMENT '计算口径、配置版本、来源范围及关键参数快照',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_item_min_stat`(`item_id` ASC, `energy_type_id` ASC, `direction` ASC, `record_time` ASC, `interval_minutes` ASC) USING BTREE,
  INDEX `idx_item_min_energy_time`(`energy_type_id` ASC, `direction` ASC, `record_time` ASC, `interval_minutes` ASC, `item_id` ASC) USING BTREE,
  INDEX `idx_item_min_batch`(`calculation_batch_id` ASC, `item_id` ASC) USING BTREE,
  INDEX `idx_item_min_recalc`(`last_recalc_job_id` ASC, `item_id` ASC) USING BTREE,
  CONSTRAINT `ck_item_min_data_version` CHECK (`data_version` >= 1)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源分项分钟级统计数据；record_time为统计周期开始时间' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_item_data_min
-- ----------------------------

-- ----------------------------
-- Table structure for energy_item_data_monthly
-- ----------------------------
DROP TABLE IF EXISTS `energy_item_data_monthly`;
CREATE TABLE `energy_item_data_monthly`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `item_id` bigint NOT NULL COMMENT '分项ID',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `year_num` int NOT NULL COMMENT '年份',
  `month_num` tinyint NOT NULL COMMENT '月份',
  `consumption` decimal(38, 12) NOT NULL COMMENT '月能源用量',
  `peak_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '峰期用量',
  `valley_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '谷期用量',
  `flat_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '平期用量',
  `max_demand` decimal(20, 6) NULL DEFAULT NULL COMMENT '最大需量',
  `avg_demand` decimal(20, 6) NULL DEFAULT NULL COMMENT '平均需量',
  `load_factor` decimal(8, 4) NULL DEFAULT NULL COMMENT '负荷率',
  `total_cost` decimal(28, 8) NULL DEFAULT NULL COMMENT '总费用',
  `carbon_emission` decimal(38, 12) NULL DEFAULT NULL COMMENT '碳排放量',
  `working_days` int NULL DEFAULT NULL COMMENT '工作日天数',
  `weekend_days` int NULL DEFAULT NULL COMMENT '周末天数',
  `holiday_days` int NULL DEFAULT NULL COMMENT '节假日天数',
  `data_source` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'AGGREGATE' COMMENT '数据来源：METER_CALC表计计算、AGGREGATE聚合、ALLOCATION分摊、CORRECTION修正、MANUAL人工录入、MIXED混合',
  `quality_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'GOOD' COMMENT '数据质量状态：GOOD、PARTIAL、ESTIMATED、INVALID',
  `quality_codes` json NULL COMMENT '数据质量问题编码集合',
  `data_version` int NOT NULL DEFAULT 1 COMMENT '当前统计记录版本号；重算更新时递增',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '最近一次生成或重算该记录的计算批次ID',
  `last_recalc_job_id` bigint NULL DEFAULT NULL COMMENT '最近一次更新该记录的重算编排任务ID',
  `calculation_snapshot` json NULL COMMENT '计算口径、配置版本、来源范围及关键参数快照',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_item_monthly_stat`(`item_id` ASC, `energy_type_id` ASC, `direction` ASC, `year_num` ASC, `month_num` ASC) USING BTREE,
  INDEX `idx_item_monthly_energy_time`(`energy_type_id` ASC, `direction` ASC, `year_num` ASC, `month_num` ASC, `item_id` ASC) USING BTREE,
  INDEX `idx_item_monthly_batch`(`calculation_batch_id` ASC, `item_id` ASC) USING BTREE,
  INDEX `idx_item_monthly_recalc`(`last_recalc_job_id` ASC, `item_id` ASC) USING BTREE,
  CONSTRAINT `ck_item_monthly_data_version` CHECK (`data_version` >= 1)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源分项月级统计数据' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_item_data_monthly
-- ----------------------------

-- ----------------------------
-- Table structure for energy_item_data_yearly
-- ----------------------------
DROP TABLE IF EXISTS `energy_item_data_yearly`;
CREATE TABLE `energy_item_data_yearly`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `item_id` bigint NOT NULL COMMENT '分项ID',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `year_num` int NOT NULL COMMENT '年份',
  `consumption` decimal(38, 12) NOT NULL COMMENT '年能源用量',
  `total_cost` decimal(28, 8) NULL DEFAULT NULL COMMENT '总费用',
  `carbon_emission` decimal(38, 12) NULL DEFAULT NULL COMMENT '碳排放量',
  `unit_area_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '单位面积能耗',
  `unit_person_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '人均能耗',
  `data_source` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'AGGREGATE' COMMENT '数据来源：METER_CALC表计计算、AGGREGATE聚合、ALLOCATION分摊、CORRECTION修正、MANUAL人工录入、MIXED混合',
  `quality_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'GOOD' COMMENT '数据质量状态：GOOD、PARTIAL、ESTIMATED、INVALID',
  `quality_codes` json NULL COMMENT '数据质量问题编码集合',
  `data_version` int NOT NULL DEFAULT 1 COMMENT '当前统计记录版本号；重算更新时递增',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '最近一次生成或重算该记录的计算批次ID',
  `last_recalc_job_id` bigint NULL DEFAULT NULL COMMENT '最近一次更新该记录的重算编排任务ID',
  `calculation_snapshot` json NULL COMMENT '计算口径、配置版本、来源范围及关键参数快照',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_item_yearly_stat`(`item_id` ASC, `energy_type_id` ASC, `direction` ASC, `year_num` ASC) USING BTREE,
  INDEX `idx_item_yearly_energy_time`(`energy_type_id` ASC, `direction` ASC, `year_num` ASC, `item_id` ASC) USING BTREE,
  INDEX `idx_item_yearly_batch`(`calculation_batch_id` ASC, `item_id` ASC) USING BTREE,
  INDEX `idx_item_yearly_recalc`(`last_recalc_job_id` ASC, `item_id` ASC) USING BTREE,
  CONSTRAINT `ck_item_yearly_data_version` CHECK (`data_version` >= 1)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源分项年级统计数据' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_item_data_yearly
-- ----------------------------

-- ----------------------------
-- Table structure for energy_line_data_daily
-- ----------------------------
DROP TABLE IF EXISTS `energy_line_data_daily`;
CREATE TABLE `energy_line_data_daily`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `line_id` bigint NOT NULL COMMENT '支线ID',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `data_date` date NOT NULL COMMENT '日期',
  `consumption` decimal(38, 12) NOT NULL COMMENT '日能源用量',
  `peak_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '峰期用量',
  `valley_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '谷期用量',
  `flat_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '平期用量',
  `max_demand` decimal(20, 6) NULL DEFAULT NULL COMMENT '最大需量',
  `avg_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '平均功率',
  `load_factor` decimal(8, 4) NULL DEFAULT NULL COMMENT '负荷率',
  `total_cost` decimal(28, 8) NULL DEFAULT NULL COMMENT '总费用',
  `carbon_emission` decimal(38, 12) NULL DEFAULT NULL COMMENT '碳排放量',
  `temperature_avg` decimal(5, 2) NULL DEFAULT NULL COMMENT '平均温度',
  `humidity_avg` decimal(5, 2) NULL DEFAULT NULL COMMENT '平均湿度',
  `is_holiday` tinyint(1) NULL DEFAULT 0 COMMENT '是否节假日',
  `is_weekend` tinyint(1) NULL DEFAULT 0 COMMENT '是否周末',
  `data_source` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'AGGREGATE' COMMENT '数据来源：METER_CALC表计计算、AGGREGATE聚合、ALLOCATION分摊、CORRECTION修正、MANUAL人工录入、MIXED混合',
  `quality_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'GOOD' COMMENT '数据质量状态：GOOD、PARTIAL、ESTIMATED、INVALID',
  `quality_codes` json NULL COMMENT '数据质量问题编码集合',
  `data_version` int NOT NULL DEFAULT 1 COMMENT '当前统计记录版本号；重算更新时递增',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '最近一次生成或重算该记录的计算批次ID',
  `last_recalc_job_id` bigint NULL DEFAULT NULL COMMENT '最近一次更新该记录的重算编排任务ID',
  `calculation_snapshot` json NULL COMMENT '计算口径、配置版本、来源范围及关键参数快照',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_line_daily_stat`(`line_id` ASC, `energy_type_id` ASC, `direction` ASC, `data_date` ASC) USING BTREE,
  INDEX `idx_line_daily_energy_time`(`energy_type_id` ASC, `direction` ASC, `data_date` ASC, `line_id` ASC) USING BTREE,
  INDEX `idx_line_daily_batch`(`calculation_batch_id` ASC, `line_id` ASC) USING BTREE,
  INDEX `idx_line_daily_recalc`(`last_recalc_job_id` ASC, `line_id` ASC) USING BTREE,
  CONSTRAINT `ck_line_daily_data_version` CHECK (`data_version` >= 1)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源支路日级统计数据' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_line_data_daily
-- ----------------------------

-- ----------------------------
-- Table structure for energy_line_data_hourly
-- ----------------------------
DROP TABLE IF EXISTS `energy_line_data_hourly`;
CREATE TABLE `energy_line_data_hourly`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `line_id` bigint NOT NULL COMMENT '支线ID',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `data_date` date NOT NULL COMMENT '日期',
  `hour_num` tinyint NOT NULL COMMENT '小时(0-23)',
  `consumption` decimal(38, 12) NOT NULL COMMENT '小时能源用量',
  `avg_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '平均功率',
  `max_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '最大功率',
  `min_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '最小功率',
  `cost` decimal(28, 8) NULL DEFAULT NULL COMMENT '费用',
  `carbon_emission` decimal(38, 12) NULL DEFAULT NULL COMMENT '碳排放量',
  `data_source` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'AGGREGATE' COMMENT '数据来源：METER_CALC表计计算、AGGREGATE聚合、ALLOCATION分摊、CORRECTION修正、MANUAL人工录入、MIXED混合',
  `quality_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'GOOD' COMMENT '数据质量状态：GOOD、PARTIAL、ESTIMATED、INVALID',
  `quality_codes` json NULL COMMENT '数据质量问题编码集合',
  `data_version` int NOT NULL DEFAULT 1 COMMENT '当前统计记录版本号；重算更新时递增',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '最近一次生成或重算该记录的计算批次ID',
  `last_recalc_job_id` bigint NULL DEFAULT NULL COMMENT '最近一次更新该记录的重算编排任务ID',
  `calculation_snapshot` json NULL COMMENT '计算口径、配置版本、来源范围及关键参数快照',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_line_hourly_stat`(`line_id` ASC, `energy_type_id` ASC, `direction` ASC, `data_date` ASC, `hour_num` ASC) USING BTREE,
  INDEX `idx_line_hourly_energy_time`(`energy_type_id` ASC, `direction` ASC, `data_date` ASC, `hour_num` ASC, `line_id` ASC) USING BTREE,
  INDEX `idx_line_hourly_batch`(`calculation_batch_id` ASC, `line_id` ASC) USING BTREE,
  INDEX `idx_line_hourly_recalc`(`last_recalc_job_id` ASC, `line_id` ASC) USING BTREE,
  CONSTRAINT `ck_line_hourly_data_version` CHECK (`data_version` >= 1)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源支路小时级统计数据' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_line_data_hourly
-- ----------------------------

-- ----------------------------
-- Table structure for energy_line_data_min
-- ----------------------------
DROP TABLE IF EXISTS `energy_line_data_min`;
CREATE TABLE `energy_line_data_min`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `line_id` bigint NOT NULL COMMENT '支线ID',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `interval_minutes` int NOT NULL COMMENT '统计间隔（分钟）',
  `record_time` datetime(6) NOT NULL COMMENT '统计周期开始时间',
  `consumption` decimal(38, 12) NOT NULL COMMENT '统计周期能源用量',
  `avg_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '平均功率',
  `max_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '最大功率',
  `min_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '最小功率',
  `data_source` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'AGGREGATE' COMMENT '数据来源：METER_CALC表计计算、AGGREGATE聚合、ALLOCATION分摊、CORRECTION修正、MANUAL人工录入、MIXED混合',
  `quality_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'GOOD' COMMENT '数据质量状态：GOOD、PARTIAL、ESTIMATED、INVALID',
  `quality_codes` json NULL COMMENT '数据质量问题编码集合',
  `data_version` int NOT NULL DEFAULT 1 COMMENT '当前统计记录版本号；重算更新时递增',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '最近一次生成或重算该记录的计算批次ID',
  `last_recalc_job_id` bigint NULL DEFAULT NULL COMMENT '最近一次更新该记录的重算编排任务ID',
  `calculation_snapshot` json NULL COMMENT '计算口径、配置版本、来源范围及关键参数快照',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_line_min_stat`(`line_id` ASC, `energy_type_id` ASC, `direction` ASC, `record_time` ASC, `interval_minutes` ASC) USING BTREE,
  INDEX `idx_line_min_energy_time`(`energy_type_id` ASC, `direction` ASC, `record_time` ASC, `interval_minutes` ASC, `line_id` ASC) USING BTREE,
  INDEX `idx_line_min_batch`(`calculation_batch_id` ASC, `line_id` ASC) USING BTREE,
  INDEX `idx_line_min_recalc`(`last_recalc_job_id` ASC, `line_id` ASC) USING BTREE,
  CONSTRAINT `ck_line_min_data_version` CHECK (`data_version` >= 1)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源支路分钟级统计数据；record_time为统计周期开始时间' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_line_data_min
-- ----------------------------

-- ----------------------------
-- Table structure for energy_line_data_monthly
-- ----------------------------
DROP TABLE IF EXISTS `energy_line_data_monthly`;
CREATE TABLE `energy_line_data_monthly`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `line_id` bigint NOT NULL COMMENT '支线ID',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `year_num` int NOT NULL COMMENT '年份',
  `month_num` tinyint NOT NULL COMMENT '月份',
  `consumption` decimal(38, 12) NOT NULL COMMENT '月能源用量',
  `peak_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '峰期用量',
  `valley_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '谷期用量',
  `flat_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '平期用量',
  `max_demand` decimal(20, 6) NULL DEFAULT NULL COMMENT '最大需量',
  `avg_demand` decimal(20, 6) NULL DEFAULT NULL COMMENT '平均需量',
  `load_factor` decimal(8, 4) NULL DEFAULT NULL COMMENT '负荷率',
  `total_cost` decimal(28, 8) NULL DEFAULT NULL COMMENT '总费用',
  `carbon_emission` decimal(38, 12) NULL DEFAULT NULL COMMENT '碳排放量',
  `working_days` int NULL DEFAULT NULL COMMENT '工作日天数',
  `weekend_days` int NULL DEFAULT NULL COMMENT '周末天数',
  `holiday_days` int NULL DEFAULT NULL COMMENT '节假日天数',
  `data_source` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'AGGREGATE' COMMENT '数据来源：METER_CALC表计计算、AGGREGATE聚合、ALLOCATION分摊、CORRECTION修正、MANUAL人工录入、MIXED混合',
  `quality_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'GOOD' COMMENT '数据质量状态：GOOD、PARTIAL、ESTIMATED、INVALID',
  `quality_codes` json NULL COMMENT '数据质量问题编码集合',
  `data_version` int NOT NULL DEFAULT 1 COMMENT '当前统计记录版本号；重算更新时递增',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '最近一次生成或重算该记录的计算批次ID',
  `last_recalc_job_id` bigint NULL DEFAULT NULL COMMENT '最近一次更新该记录的重算编排任务ID',
  `calculation_snapshot` json NULL COMMENT '计算口径、配置版本、来源范围及关键参数快照',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_line_monthly_stat`(`line_id` ASC, `energy_type_id` ASC, `direction` ASC, `year_num` ASC, `month_num` ASC) USING BTREE,
  INDEX `idx_line_monthly_energy_time`(`energy_type_id` ASC, `direction` ASC, `year_num` ASC, `month_num` ASC, `line_id` ASC) USING BTREE,
  INDEX `idx_line_monthly_batch`(`calculation_batch_id` ASC, `line_id` ASC) USING BTREE,
  INDEX `idx_line_monthly_recalc`(`last_recalc_job_id` ASC, `line_id` ASC) USING BTREE,
  CONSTRAINT `ck_line_monthly_data_version` CHECK (`data_version` >= 1)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源支路月级统计数据' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_line_data_monthly
-- ----------------------------

-- ----------------------------
-- Table structure for energy_line_data_yearly
-- ----------------------------
DROP TABLE IF EXISTS `energy_line_data_yearly`;
CREATE TABLE `energy_line_data_yearly`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `line_id` bigint NOT NULL COMMENT '支线ID',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `year_num` int NOT NULL COMMENT '年份',
  `consumption` decimal(38, 12) NOT NULL COMMENT '年能源用量',
  `total_cost` decimal(28, 8) NULL DEFAULT NULL COMMENT '总费用',
  `carbon_emission` decimal(38, 12) NULL DEFAULT NULL COMMENT '碳排放量',
  `unit_area_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '单位面积能耗',
  `unit_person_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '人均能耗',
  `data_source` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'AGGREGATE' COMMENT '数据来源：METER_CALC表计计算、AGGREGATE聚合、ALLOCATION分摊、CORRECTION修正、MANUAL人工录入、MIXED混合',
  `quality_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'GOOD' COMMENT '数据质量状态：GOOD、PARTIAL、ESTIMATED、INVALID',
  `quality_codes` json NULL COMMENT '数据质量问题编码集合',
  `data_version` int NOT NULL DEFAULT 1 COMMENT '当前统计记录版本号；重算更新时递增',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '最近一次生成或重算该记录的计算批次ID',
  `last_recalc_job_id` bigint NULL DEFAULT NULL COMMENT '最近一次更新该记录的重算编排任务ID',
  `calculation_snapshot` json NULL COMMENT '计算口径、配置版本、来源范围及关键参数快照',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_line_yearly_stat`(`line_id` ASC, `energy_type_id` ASC, `direction` ASC, `year_num` ASC) USING BTREE,
  INDEX `idx_line_yearly_energy_time`(`energy_type_id` ASC, `direction` ASC, `year_num` ASC, `line_id` ASC) USING BTREE,
  INDEX `idx_line_yearly_batch`(`calculation_batch_id` ASC, `line_id` ASC) USING BTREE,
  INDEX `idx_line_yearly_recalc`(`last_recalc_job_id` ASC, `line_id` ASC) USING BTREE,
  CONSTRAINT `ck_line_yearly_data_version` CHECK (`data_version` >= 1)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源支路年级统计数据' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_line_data_yearly
-- ----------------------------

-- ----------------------------
-- Table structure for energy_meter
-- ----------------------------
DROP TABLE IF EXISTS `energy_meter`;
CREATE TABLE `energy_meter`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '逻辑表计ID',
  `meter_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '表计编码',
  `meter_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '表计名称',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `meter_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '表计类型',
  `is_virtual` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否虚拟表计：0否、1是',
  `commissioned_at` datetime(6) NOT NULL COMMENT '投入使用时间',
  `decommissioned_at` datetime(6) NULL DEFAULT NULL COMMENT '停用时间；为空表示仍在使用',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'ACTIVE' COMMENT '状态：ACTIVE启用、DISABLED停用',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建人',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新人',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_energy_meter_code`(`meter_code` ASC) USING BTREE,
  INDEX `idx_energy_meter_type_status`(`energy_type_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_energy_meter_virtual_status`(`is_virtual` ASC, `status` ASC) USING BTREE,
  CONSTRAINT `ck_energy_meter_effective_range` CHECK ((`decommissioned_at` is null) or (`decommissioned_at` > `commissioned_at`))
) ENGINE = InnoDB AUTO_INCREMENT = 50 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源逻辑表计主数据；不直接保存设备属性通道和业务归属' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of energy_meter
-- ----------------------------

-- ----------------------------
-- Table structure for energy_meter_branch_binding
-- ----------------------------
DROP TABLE IF EXISTS `energy_meter_branch_binding`;
CREATE TABLE `energy_meter_branch_binding`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `branch_id` bigint NOT NULL COMMENT '能源支路ID',
  `meter_id` bigint NOT NULL COMMENT '逻辑表计ID',
  `meter_role` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'PRIMARY' COMMENT '支路计量角色：PRIMARY主计量、BACKUP备用、CHECK校验',
  `valid_from` datetime(6) NOT NULL COMMENT '绑定生效时间',
  `valid_to` datetime(6) NULL DEFAULT NULL COMMENT '绑定失效时间；为空表示当前有效',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'ACTIVE' COMMENT '状态：ACTIVE启用、DISABLED停用',
  `current_key` tinyint GENERATED ALWAYS AS ((case when ((`status` = _utf8mb4'ACTIVE') and (`valid_to` is null)) then 1 else NULL end)) STORED COMMENT '当前有效绑定唯一索引辅助字段' NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_meter_branch_version`(`meter_id` ASC) USING BTREE,
  UNIQUE INDEX `uk_meter_branch_current`(`meter_id` ASC, `current_key` ASC) USING BTREE,
  INDEX `idx_meter_branch_effective`(`meter_id` ASC, `valid_from` ASC, `valid_to` ASC, `status` ASC) USING BTREE,
  INDEX `idx_branch_meter_role`(`branch_id` ASC, `meter_role` ASC, `status` ASC, `valid_from` ASC, `valid_to` ASC) USING BTREE,
  CONSTRAINT `ck_meter_branch_range` CHECK ((`valid_to` is null) or (`valid_to` > `valid_from`))
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '逻辑表计与能源支路的版本化有效期绑定' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of energy_meter_branch_binding
-- ----------------------------
INSERT INTO `energy_meter_branch_binding` VALUES (5, 5, 1, 'PRIMARY', '2026-07-27 00:00:00.000000', NULL, 'ACTIVE', DEFAULT, '2026-07-27 20:01:33.268078', '2026-07-27 20:01:33.268078');
INSERT INTO `energy_meter_branch_binding` VALUES (6, 5, 2, 'PRIMARY', '2026-07-27 00:00:00.000000', NULL, 'ACTIVE', DEFAULT, '2026-07-27 22:57:39.752235', '2026-07-27 22:57:39.752235');
INSERT INTO `energy_meter_branch_binding` VALUES (7, 6, 3, 'PRIMARY', '2026-07-27 00:00:00.000000', NULL, 'ACTIVE', DEFAULT, '2026-07-27 22:57:53.546548', '2026-07-27 22:57:53.546548');
INSERT INTO `energy_meter_branch_binding` VALUES (8, 7, 4, 'PRIMARY', '2026-07-27 00:00:00.000000', NULL, 'ACTIVE', DEFAULT, '2026-07-27 22:58:05.431035', '2026-07-27 22:58:05.431035');

-- ----------------------------
-- Table structure for energy_meter_channel
-- ----------------------------
DROP TABLE IF EXISTS `energy_meter_channel`;
CREATE TABLE `energy_meter_channel`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '采集通道ID',
  `meter_id` bigint NOT NULL COMMENT '逻辑表计ID',
  `metric_code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '通道编码；同一逻辑表计内稳定唯一',
  `version_no` int NOT NULL DEFAULT 1 COMMENT '通道配置版本号；同一meter_id和channel_code递增',
  `metric_role` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '通道指标角色：ENERGY_READING能源累计量读数、INTERVAL_USAGE区间用量、POWER瞬时功率、VOLTAGE电压、CURRENT电流、POWER_FACTOR功率因数',
  `is_primary_usage` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否作为该表计及流向的主要用量计算通道：0否、1是',
  `product_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'IoT产品ID',
  `device_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'IoT设备ID',
  `telemetry_key` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '设备属性标识',
  `measurement_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '测量类型：\nCUMULATIVE_READING累计读数；\nINTERVAL_USAGE区间用量；\nINSTANT_POWER瞬时功率；\nDEMAND需量',
  `reading_mode` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '读取模式：CUMULATIVE累计值；DELTA增量；INSTANT瞬时值；',
  `source_unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '原始数据单位',
  `multiplier` decimal(28, 12) NOT NULL DEFAULT 1.000000000000 COMMENT '换算倍率',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `rollover_value` decimal(38, 12) NULL DEFAULT NULL COMMENT '累计读数回绕值',
  `reset_policy` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'REJECT' COMMENT '累计读数复位处理策略',
  `sample_period_sec` int NULL DEFAULT NULL COMMENT '期望采样周期，单位秒',
  `valid_from` datetime(6) NOT NULL COMMENT '配置生效时间',
  `valid_to` datetime(6) NULL DEFAULT NULL COMMENT '配置失效时间；为空表示当前有效',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'ACTIVE' COMMENT '状态：ACTIVE启用、DISABLED停用',
  `current_key` tinyint GENERATED ALWAYS AS ((case when ((`status` = _utf8mb4'ACTIVE') and (`valid_to` is null)) then 1 else NULL end)) STORED COMMENT '当前有效通道版本唯一索引辅助字段' NULL,
  `current_primary_usage_key` tinyint GENERATED ALWAYS AS ((case when ((`status` = _utf8mb4'ACTIVE') and (`valid_to` is null) and (`is_primary_usage` = 1)) then 1 else NULL end)) STORED COMMENT '当前主要用量通道唯一索引辅助字段' NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_meter_channel_version`(`meter_id` ASC, `metric_code` ASC, `version_no` ASC) USING BTREE,
  UNIQUE INDEX `uk_meter_channel_current`(`meter_id` ASC, `metric_code` ASC, `current_key` ASC) USING BTREE,
  UNIQUE INDEX `uk_meter_primary_usage_current`(`meter_id` ASC, `direction` ASC, `current_primary_usage_key` ASC) USING BTREE,
  INDEX `idx_meter_channel_history_mapping`(`device_id` ASC, `telemetry_key` ASC, `valid_from` ASC, `valid_to` ASC, `status` ASC) USING BTREE,
  INDEX `idx_meter_channel_metric`(`meter_id` ASC, `metric_role` ASC, `direction` ASC, `valid_from` ASC, `valid_to` ASC, `status` ASC) USING BTREE,
  CONSTRAINT `ck_meter_channel_multiplier` CHECK (`multiplier` > 0),
  CONSTRAINT `ck_meter_channel_range` CHECK ((`valid_to` is null) or (`valid_to` > `valid_from`)),
  CONSTRAINT `ck_meter_channel_sample_period` CHECK ((`sample_period_sec` is null) or (`sample_period_sec` > 0))
) ENGINE = InnoDB AUTO_INCREMENT = 144 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '逻辑表计的设备历史采集通道及有效期配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of energy_meter_channel
-- ----------------------------

-- ----------------------------
-- Table structure for energy_meter_data_daily
-- ----------------------------
DROP TABLE IF EXISTS `energy_meter_data_daily`;
CREATE TABLE `energy_meter_data_daily`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `meter_id` bigint NOT NULL COMMENT '计量设备ID',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `data_date` date NOT NULL COMMENT '日期',
  `consumption` decimal(38, 12) NOT NULL COMMENT '日能源用量',
  `peak_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '峰期用量',
  `valley_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '谷期用量',
  `flat_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '平期用量',
  `max_demand` decimal(20, 6) NULL DEFAULT NULL COMMENT '最大需量',
  `avg_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '平均功率',
  `load_factor` decimal(8, 4) NULL DEFAULT NULL COMMENT '负荷率',
  `total_cost` decimal(28, 8) NULL DEFAULT NULL COMMENT '总费用',
  `carbon_emission` decimal(38, 12) NULL DEFAULT NULL COMMENT '碳排放量',
  `temperature_avg` decimal(5, 2) NULL DEFAULT NULL COMMENT '平均温度',
  `humidity_avg` decimal(5, 2) NULL DEFAULT NULL COMMENT '平均湿度',
  `is_holiday` tinyint(1) NULL DEFAULT 0 COMMENT '是否节假日',
  `is_weekend` tinyint(1) NULL DEFAULT 0 COMMENT '是否周末',
  `data_source` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'METER_CALC' COMMENT '数据来源：METER_CALC表计计算、AGGREGATE聚合、ALLOCATION分摊、CORRECTION修正、MANUAL人工录入、MIXED混合',
  `quality_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'GOOD' COMMENT '数据质量状态：GOOD、PARTIAL、ESTIMATED、INVALID',
  `quality_codes` json NULL COMMENT '数据质量问题编码集合',
  `data_version` int NOT NULL DEFAULT 1 COMMENT '当前统计记录版本号；重算更新时递增',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '最近一次生成或重算该记录的计算批次ID',
  `last_recalc_job_id` bigint NULL DEFAULT NULL COMMENT '最近一次更新该记录的重算编排任务ID',
  `source_channel_id` bigint NULL DEFAULT NULL COMMENT '本次统计使用的energy_meter_channel.id',
  `source_formula_id` bigint NULL DEFAULT NULL COMMENT '本次统计使用的energy_meter_formula.id',
  `source_branch_binding_id` bigint NULL DEFAULT NULL COMMENT '本次统计使用的energy_meter_branch_binding.id',
  `calculation_snapshot` json NULL COMMENT '计算口径、配置版本、来源范围及关键参数快照',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_meter_daily_stat`(`meter_id` ASC, `energy_type_id` ASC, `direction` ASC, `data_date` ASC) USING BTREE,
  INDEX `idx_meter_daily_energy_time`(`energy_type_id` ASC, `direction` ASC, `data_date` ASC, `meter_id` ASC) USING BTREE,
  INDEX `idx_meter_daily_source_config`(`source_channel_id` ASC, `source_formula_id` ASC, `source_branch_binding_id` ASC) USING BTREE,
  INDEX `idx_meter_daily_batch`(`calculation_batch_id` ASC, `meter_id` ASC) USING BTREE,
  INDEX `idx_meter_daily_recalc`(`last_recalc_job_id` ASC, `meter_id` ASC) USING BTREE,
  CONSTRAINT `ck_meter_daily_data_version` CHECK (`data_version` >= 1)
) ENGINE = InnoDB AUTO_INCREMENT = 2011 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '逻辑计量点日级统计数据' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_meter_data_daily
-- ----------------------------

-- ----------------------------
-- Table structure for energy_meter_data_hourly
-- ----------------------------
DROP TABLE IF EXISTS `energy_meter_data_hourly`;
CREATE TABLE `energy_meter_data_hourly`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `meter_id` bigint NOT NULL COMMENT '计量设备ID',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `data_date` date NOT NULL COMMENT '日期',
  `hour_num` tinyint NOT NULL COMMENT '小时(0-23)',
  `consumption` decimal(38, 12) NOT NULL COMMENT '小时能源用量',
  `avg_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '平均功率',
  `max_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '最大功率',
  `min_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '最小功率',
  `cost` decimal(28, 8) NULL DEFAULT NULL COMMENT '费用',
  `carbon_emission` decimal(38, 12) NULL DEFAULT NULL COMMENT '碳排放量',
  `data_source` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'METER_CALC' COMMENT '数据来源：METER_CALC表计计算、AGGREGATE聚合、ALLOCATION分摊、CORRECTION修正、MANUAL人工录入、MIXED混合',
  `quality_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'GOOD' COMMENT '数据质量状态：GOOD、PARTIAL、ESTIMATED、INVALID',
  `quality_codes` json NULL COMMENT '数据质量问题编码集合',
  `data_version` int NOT NULL DEFAULT 1 COMMENT '当前统计记录版本号；重算更新时递增',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '最近一次生成或重算该记录的计算批次ID',
  `last_recalc_job_id` bigint NULL DEFAULT NULL COMMENT '最近一次更新该记录的重算编排任务ID',
  `source_channel_id` bigint NULL DEFAULT NULL COMMENT '本次统计使用的energy_meter_channel.id',
  `source_formula_id` bigint NULL DEFAULT NULL COMMENT '本次统计使用的energy_meter_formula.id',
  `source_branch_binding_id` bigint NULL DEFAULT NULL COMMENT '本次统计使用的energy_meter_branch_binding.id',
  `calculation_snapshot` json NULL COMMENT '计算口径、配置版本、来源范围及关键参数快照',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_meter_hourly_stat`(`meter_id` ASC, `energy_type_id` ASC, `direction` ASC, `data_date` ASC, `hour_num` ASC) USING BTREE,
  INDEX `idx_meter_hourly_energy_time`(`energy_type_id` ASC, `direction` ASC, `data_date` ASC, `hour_num` ASC, `meter_id` ASC) USING BTREE,
  INDEX `idx_meter_hourly_source_config`(`source_channel_id` ASC, `source_formula_id` ASC, `source_branch_binding_id` ASC) USING BTREE,
  INDEX `idx_meter_hourly_batch`(`calculation_batch_id` ASC, `meter_id` ASC) USING BTREE,
  INDEX `idx_meter_hourly_recalc`(`last_recalc_job_id` ASC, `meter_id` ASC) USING BTREE,
  CONSTRAINT `ck_meter_hourly_data_version` CHECK (`data_version` >= 1)
) ENGINE = InnoDB AUTO_INCREMENT = 46549 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '逻辑计量点小时级统计数据' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_meter_data_hourly
-- ----------------------------

-- ----------------------------
-- Table structure for energy_meter_data_min
-- ----------------------------
DROP TABLE IF EXISTS `energy_meter_data_min`;
CREATE TABLE `energy_meter_data_min`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `meter_id` bigint NOT NULL COMMENT '计量表具ID',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `interval_minutes` int NOT NULL COMMENT '统计间隔（分钟）',
  `record_time` datetime(6) NOT NULL COMMENT '统计周期开始时间',
  `current_read` decimal(38, 12) NOT NULL COMMENT '统计周期结束时的累计读数',
  `consumption` decimal(38, 12) NOT NULL COMMENT '统计周期能源用量',
  `avg_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '平均功率',
  `max_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '最大功率',
  `min_power` decimal(20, 6) NULL DEFAULT NULL COMMENT '最小功率',
  `data_source` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'METER_CALC' COMMENT '数据来源：METER_CALC表计计算、AGGREGATE聚合、ALLOCATION分摊、CORRECTION修正、MANUAL人工录入、MIXED混合',
  `quality_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'GOOD' COMMENT '数据质量状态：GOOD、PARTIAL、ESTIMATED、INVALID',
  `quality_codes` json NULL COMMENT '数据质量问题编码集合',
  `data_version` int NOT NULL DEFAULT 1 COMMENT '当前统计记录版本号；重算更新时递增',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '最近一次生成或重算该记录的计算批次ID',
  `last_recalc_job_id` bigint NULL DEFAULT NULL COMMENT '最近一次更新该记录的重算编排任务ID',
  `source_channel_id` bigint NULL DEFAULT NULL COMMENT '本次统计使用的energy_meter_channel.id',
  `source_formula_id` bigint NULL DEFAULT NULL COMMENT '本次统计使用的energy_meter_formula.id',
  `source_branch_binding_id` bigint NULL DEFAULT NULL COMMENT '本次统计使用的energy_meter_branch_binding.id',
  `calculation_snapshot` json NULL COMMENT '计算口径、配置版本、来源范围及关键参数快照',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_meter_min_stat`(`meter_id` ASC, `energy_type_id` ASC, `direction` ASC, `record_time` ASC, `interval_minutes` ASC) USING BTREE,
  INDEX `idx_meter_min_energy_time`(`energy_type_id` ASC, `direction` ASC, `record_time` ASC, `interval_minutes` ASC, `meter_id` ASC) USING BTREE,
  INDEX `idx_meter_min_source_config`(`source_channel_id` ASC, `source_formula_id` ASC, `source_branch_binding_id` ASC) USING BTREE,
  INDEX `idx_meter_min_batch`(`calculation_batch_id` ASC, `meter_id` ASC) USING BTREE,
  INDEX `idx_meter_min_recalc`(`last_recalc_job_id` ASC, `meter_id` ASC) USING BTREE,
  CONSTRAINT `ck_meter_min_data_version` CHECK (`data_version` >= 1)
) ENGINE = InnoDB AUTO_INCREMENT = 680209 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '逻辑计量点分钟级统计数据；record_time为统计周期开始时间' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_meter_data_min
-- ----------------------------

-- ----------------------------
-- Table structure for energy_meter_data_monthly
-- ----------------------------
DROP TABLE IF EXISTS `energy_meter_data_monthly`;
CREATE TABLE `energy_meter_data_monthly`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `meter_id` bigint NOT NULL COMMENT '计量设备ID',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `year_num` int NOT NULL COMMENT '年份',
  `month_num` tinyint NOT NULL COMMENT '月份',
  `consumption` decimal(38, 12) NOT NULL COMMENT '月能源用量',
  `peak_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '峰期用量',
  `valley_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '谷期用量',
  `flat_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '平期用量',
  `max_demand` decimal(20, 6) NULL DEFAULT NULL COMMENT '最大需量',
  `avg_demand` decimal(20, 6) NULL DEFAULT NULL COMMENT '平均需量',
  `load_factor` decimal(8, 4) NULL DEFAULT NULL COMMENT '负荷率',
  `total_cost` decimal(28, 8) NULL DEFAULT NULL COMMENT '总费用',
  `carbon_emission` decimal(38, 12) NULL DEFAULT NULL COMMENT '碳排放量',
  `working_days` int NULL DEFAULT NULL COMMENT '工作日天数',
  `weekend_days` int NULL DEFAULT NULL COMMENT '周末天数',
  `holiday_days` int NULL DEFAULT NULL COMMENT '节假日天数',
  `data_source` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'METER_CALC' COMMENT '数据来源：METER_CALC表计计算、AGGREGATE聚合、ALLOCATION分摊、CORRECTION修正、MANUAL人工录入、MIXED混合',
  `quality_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'GOOD' COMMENT '数据质量状态：GOOD、PARTIAL、ESTIMATED、INVALID',
  `quality_codes` json NULL COMMENT '数据质量问题编码集合',
  `data_version` int NOT NULL DEFAULT 1 COMMENT '当前统计记录版本号；重算更新时递增',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '最近一次生成或重算该记录的计算批次ID',
  `last_recalc_job_id` bigint NULL DEFAULT NULL COMMENT '最近一次更新该记录的重算编排任务ID',
  `source_channel_id` bigint NULL DEFAULT NULL COMMENT '本次统计使用的energy_meter_channel.id',
  `source_formula_id` bigint NULL DEFAULT NULL COMMENT '本次统计使用的energy_meter_formula.id',
  `source_branch_binding_id` bigint NULL DEFAULT NULL COMMENT '本次统计使用的energy_meter_branch_binding.id',
  `calculation_snapshot` json NULL COMMENT '计算口径、配置版本、来源范围及关键参数快照',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_meter_monthly_stat`(`meter_id` ASC, `energy_type_id` ASC, `direction` ASC, `year_num` ASC, `month_num` ASC) USING BTREE,
  INDEX `idx_meter_monthly_energy_time`(`energy_type_id` ASC, `direction` ASC, `year_num` ASC, `month_num` ASC, `meter_id` ASC) USING BTREE,
  INDEX `idx_meter_monthly_source_config`(`source_channel_id` ASC, `source_formula_id` ASC, `source_branch_binding_id` ASC) USING BTREE,
  INDEX `idx_meter_monthly_batch`(`calculation_batch_id` ASC, `meter_id` ASC) USING BTREE,
  INDEX `idx_meter_monthly_recalc`(`last_recalc_job_id` ASC, `meter_id` ASC) USING BTREE,
  CONSTRAINT `ck_meter_monthly_data_version` CHECK (`data_version` >= 1)
) ENGINE = InnoDB AUTO_INCREMENT = 107 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '逻辑计量点月级统计数据' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_meter_data_monthly
-- ----------------------------
INSERT INTO `energy_meter_data_monthly` VALUES (48, 2, 1, 'IMPORT', 2024, 12, 0.000000000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785674126097, NULL, 2, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 2, \"periodEnd\": 1735660800000, \"multiplier\": 1.0, \"periodStart\": 1732982400000, \"effectiveEnd\": 1735660800000, \"endReadingId\": 0, \"effectiveStart\": 1732982400000}', '2026-08-02 20:35:26.112000', '2026-08-02 20:35:26.112000');
INSERT INTO `energy_meter_data_monthly` VALUES (49, 2, 1, 'IMPORT', 2025, 1, 5359.620304000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 2, 1785681498396, NULL, 2, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 2, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 20:35:26.136000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (50, 2, 1, 'IMPORT', 2025, 2, 5248.695283000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785674126144, NULL, 2, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 2, \"periodEnd\": 1740758400000, \"multiplier\": 1.0, \"periodStart\": 1738339200000, \"effectiveEnd\": 1740758400000, \"endReadingId\": 0, \"effectiveStart\": 1738339200000, \"startReadingId\": 0}', '2026-08-02 20:35:26.162000', '2026-08-02 20:35:26.162000');
INSERT INTO `energy_meter_data_monthly` VALUES (51, 2, 1, 'IMPORT', 2025, 3, 6169.487199000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785674126169, NULL, 2, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 2, \"periodEnd\": 1743436800000, \"multiplier\": 1.0, \"periodStart\": 1740758400000, \"effectiveEnd\": 1743436800000, \"endReadingId\": 0, \"effectiveStart\": 1740758400000, \"startReadingId\": 0}', '2026-08-02 20:35:26.183000', '2026-08-02 20:35:26.183000');
INSERT INTO `energy_meter_data_monthly` VALUES (52, 2, 1, 'IMPORT', 2025, 4, 6326.529239000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785674126190, NULL, 2, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 2, \"periodEnd\": 1746028800000, \"multiplier\": 1.0, \"periodStart\": 1743436800000, \"effectiveEnd\": 1746028800000, \"endReadingId\": 0, \"effectiveStart\": 1743436800000, \"startReadingId\": 0}', '2026-08-02 20:35:26.208000', '2026-08-02 20:35:26.208000');
INSERT INTO `energy_meter_data_monthly` VALUES (53, 2, 1, 'IMPORT', 2025, 5, 6497.212918000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785674126214, NULL, 2, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 2, \"periodEnd\": 1748707200000, \"multiplier\": 1.0, \"periodStart\": 1746028800000, \"effectiveEnd\": 1748707200000, \"endReadingId\": 0, \"effectiveStart\": 1746028800000, \"startReadingId\": 0}', '2026-08-02 20:35:26.232000', '2026-08-02 20:35:26.232000');
INSERT INTO `energy_meter_data_monthly` VALUES (54, 2, 1, 'IMPORT', 2025, 6, 6023.432783000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785674126239, NULL, 2, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 2, \"periodEnd\": 1751299200000, \"multiplier\": 1.0, \"periodStart\": 1748707200000, \"effectiveEnd\": 1751299200000, \"endReadingId\": 0, \"effectiveStart\": 1748707200000, \"startReadingId\": 0}', '2026-08-02 20:35:26.257000', '2026-08-02 20:35:26.257000');
INSERT INTO `energy_meter_data_monthly` VALUES (55, 2, 1, 'IMPORT', 2025, 7, 5856.922772000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785674126263, NULL, 2, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 2, \"periodEnd\": 1753977600000, \"multiplier\": 1.0, \"periodStart\": 1751299200000, \"effectiveEnd\": 1753977600000, \"endReadingId\": 0, \"effectiveStart\": 1751299200000, \"startReadingId\": 0}', '2026-08-02 20:35:26.282000', '2026-08-02 20:35:26.282000');
INSERT INTO `energy_meter_data_monthly` VALUES (56, 2, 1, 'IMPORT', 2025, 8, 5232.290103000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785674126290, NULL, 2, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 2, \"periodEnd\": 1756656000000, \"multiplier\": 1.0, \"periodStart\": 1753977600000, \"effectiveEnd\": 1756656000000, \"endReadingId\": 0, \"effectiveStart\": 1753977600000, \"startReadingId\": 0}', '2026-08-02 20:35:26.309000', '2026-08-02 20:35:26.309000');
INSERT INTO `energy_meter_data_monthly` VALUES (57, 2, 1, 'IMPORT', 2025, 9, 4717.192215000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785674126317, NULL, 2, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 2, \"periodEnd\": 1759248000000, \"multiplier\": 1.0, \"periodStart\": 1756656000000, \"effectiveEnd\": 1759248000000, \"endReadingId\": 0, \"effectiveStart\": 1756656000000, \"startReadingId\": 0}', '2026-08-02 20:35:26.338000', '2026-08-02 20:35:26.338000');
INSERT INTO `energy_meter_data_monthly` VALUES (58, 2, 1, 'IMPORT', 2025, 10, 4634.410760000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785674126345, NULL, 2, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 2, \"periodEnd\": 1761926400000, \"multiplier\": 1.0, \"periodStart\": 1759248000000, \"effectiveEnd\": 1761926400000, \"endReadingId\": 0, \"effectiveStart\": 1759248000000, \"startReadingId\": 0}', '2026-08-02 20:35:26.367000', '2026-08-02 20:35:26.367000');
INSERT INTO `energy_meter_data_monthly` VALUES (59, 2, 1, 'IMPORT', 2025, 11, 4384.016170000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785674126374, NULL, 2, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 2, \"periodEnd\": 1764518400000, \"multiplier\": 1.0, \"periodStart\": 1761926400000, \"effectiveEnd\": 1764518400000, \"endReadingId\": 0, \"effectiveStart\": 1761926400000, \"startReadingId\": 0}', '2026-08-02 20:35:26.394000', '2026-08-02 20:35:26.394000');
INSERT INTO `energy_meter_data_monthly` VALUES (60, 2, 1, 'IMPORT', 2025, 12, 4897.689054000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785674126400, NULL, 2, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 2, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1764518400000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1764518400000, \"startReadingId\": 0}', '2026-08-02 20:35:26.421000', '2026-08-02 20:35:26.421000');
INSERT INTO `energy_meter_data_monthly` VALUES (61, 3, 1, 'IMPORT', 2025, 1, 5584.022173000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 5, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 5, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (62, 4, 1, 'IMPORT', 2025, 1, 5809.791537000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 8, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 8, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (63, 5, 1, 'IMPORT', 2025, 1, 6033.475230000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 11, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 11, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (64, 6, 1, 'IMPORT', 2025, 1, 6256.103667000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 14, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 14, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (65, 7, 1, 'IMPORT', 2025, 1, 6479.898829000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 17, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 17, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (66, 8, 1, 'IMPORT', 2025, 1, 6702.340585000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 20, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 20, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (67, 9, 1, 'IMPORT', 2025, 1, 6928.859321000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 23, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 23, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (68, 10, 1, 'IMPORT', 2025, 1, 7153.247173000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 26, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 26, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (69, 11, 1, 'IMPORT', 2025, 1, 7381.460038000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 29, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 29, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (70, 12, 1, 'IMPORT', 2025, 1, 7605.093146000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 32, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 32, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (71, 13, 1, 'IMPORT', 2025, 1, 7832.307745000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 35, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 35, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (72, 14, 1, 'IMPORT', 2025, 1, 8051.922962000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 38, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 38, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (73, 15, 1, 'IMPORT', 2025, 1, 8279.617776000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 41, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 41, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (74, 16, 1, 'IMPORT', 2025, 1, 8499.035172000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 44, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 44, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (75, 17, 1, 'IMPORT', 2025, 1, 8727.300431000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 47, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 47, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (76, 18, 1, 'IMPORT', 2025, 1, 8950.534839000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 50, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 50, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (77, 19, 1, 'IMPORT', 2025, 1, 9180.493158000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 53, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 53, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (78, 20, 1, 'IMPORT', 2025, 1, 9403.165600000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 56, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 56, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (79, 21, 1, 'IMPORT', 2025, 1, 9631.307433000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 59, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 59, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (80, 22, 1, 'IMPORT', 2025, 1, 9849.485792000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 62, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 62, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (81, 23, 1, 'IMPORT', 2025, 1, 10077.748184000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 65, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 65, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (82, 24, 1, 'IMPORT', 2025, 1, 10296.046370000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 68, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 68, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (83, 25, 1, 'IMPORT', 2025, 1, 10522.429202000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 71, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 71, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (84, 26, 1, 'IMPORT', 2025, 1, 10748.001190000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 74, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 74, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (85, 27, 1, 'IMPORT', 2025, 1, 10975.921171000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 77, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 77, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (86, 28, 1, 'IMPORT', 2025, 1, 11201.895866000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 80, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 80, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (87, 29, 1, 'IMPORT', 2025, 1, 11428.082560000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 83, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 83, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (88, 30, 1, 'IMPORT', 2025, 1, 11650.288199000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 86, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 86, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (89, 31, 1, 'IMPORT', 2025, 1, 11873.933887000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498396, NULL, 89, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 89, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (90, 32, 1, 'IMPORT', 2025, 1, 0.000000000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498396, NULL, 92, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 92, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (91, 33, 1, 'IMPORT', 2025, 1, 0.000000000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498396, NULL, 95, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 95, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (92, 34, 1, 'IMPORT', 2025, 1, 0.000000000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498396, NULL, 98, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 98, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (93, 35, 1, 'IMPORT', 2025, 1, 0.000000000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498396, NULL, 101, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 101, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (94, 36, 1, 'IMPORT', 2025, 1, 0.000000000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498396, NULL, 104, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 104, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (95, 37, 1, 'IMPORT', 2025, 1, 0.000000000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498396, NULL, 107, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 107, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (96, 38, 1, 'IMPORT', 2025, 1, 0.000000000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498396, NULL, 110, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 110, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (97, 39, 1, 'IMPORT', 2025, 1, 0.000000000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498396, NULL, 113, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 113, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (98, 40, 1, 'IMPORT', 2025, 1, 0.000000000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498396, NULL, 116, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 116, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (99, 41, 1, 'IMPORT', 2025, 1, 0.000000000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498396, NULL, 119, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 119, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (100, 42, 1, 'IMPORT', 2025, 1, 0.000000000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498396, NULL, 122, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 122, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (101, 43, 1, 'IMPORT', 2025, 1, 0.000000000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498396, NULL, 125, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 125, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (102, 44, 1, 'IMPORT', 2025, 1, 0.000000000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498396, NULL, 128, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 128, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (103, 45, 1, 'IMPORT', 2025, 1, 0.000000000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498396, NULL, 131, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 131, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (104, 46, 1, 'IMPORT', 2025, 1, 0.000000000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498396, NULL, 134, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 134, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (105, 47, 1, 'IMPORT', 2025, 1, 0.000000000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498396, NULL, 137, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 137, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');
INSERT INTO `energy_meter_data_monthly` VALUES (106, 48, 1, 'IMPORT', 2025, 1, 0.000000000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498396, NULL, 140, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 140, \"periodEnd\": 1738339200000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1738339200000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:18.928000', '2026-08-02 22:38:18.928000');

-- ----------------------------
-- Table structure for energy_meter_data_yearly
-- ----------------------------
DROP TABLE IF EXISTS `energy_meter_data_yearly`;
CREATE TABLE `energy_meter_data_yearly`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `meter_id` bigint NOT NULL COMMENT '计量设备ID',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `year_num` int NOT NULL COMMENT '年份',
  `consumption` decimal(38, 12) NOT NULL COMMENT '年能源用量',
  `total_cost` decimal(28, 8) NULL DEFAULT NULL COMMENT '总费用',
  `carbon_emission` decimal(38, 12) NULL DEFAULT NULL COMMENT '碳排放量',
  `unit_area_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '单位面积能耗',
  `unit_person_consumption` decimal(38, 12) NULL DEFAULT NULL COMMENT '人均能耗',
  `data_source` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'METER_CALC' COMMENT '数据来源：METER_CALC表计计算、AGGREGATE聚合、ALLOCATION分摊、CORRECTION修正、MANUAL人工录入、MIXED混合',
  `quality_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'GOOD' COMMENT '数据质量状态：GOOD、PARTIAL、ESTIMATED、INVALID',
  `quality_codes` json NULL COMMENT '数据质量问题编码集合',
  `data_version` int NOT NULL DEFAULT 1 COMMENT '当前统计记录版本号；重算更新时递增',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '最近一次生成或重算该记录的计算批次ID',
  `last_recalc_job_id` bigint NULL DEFAULT NULL COMMENT '最近一次更新该记录的重算编排任务ID',
  `source_channel_id` bigint NULL DEFAULT NULL COMMENT '本次统计使用的energy_meter_channel.id',
  `source_formula_id` bigint NULL DEFAULT NULL COMMENT '本次统计使用的energy_meter_formula.id',
  `source_branch_binding_id` bigint NULL DEFAULT NULL COMMENT '本次统计使用的energy_meter_branch_binding.id',
  `calculation_snapshot` json NULL COMMENT '计算口径、配置版本、来源范围及关键参数快照',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_meter_yearly_stat`(`meter_id` ASC, `energy_type_id` ASC, `direction` ASC, `year_num` ASC) USING BTREE,
  INDEX `idx_meter_yearly_energy_time`(`energy_type_id` ASC, `direction` ASC, `year_num` ASC, `meter_id` ASC) USING BTREE,
  INDEX `idx_meter_yearly_source_config`(`source_channel_id` ASC, `source_formula_id` ASC, `source_branch_binding_id` ASC) USING BTREE,
  INDEX `idx_meter_yearly_batch`(`calculation_batch_id` ASC, `meter_id` ASC) USING BTREE,
  INDEX `idx_meter_yearly_recalc`(`last_recalc_job_id` ASC, `meter_id` ASC) USING BTREE,
  CONSTRAINT `ck_meter_yearly_data_version` CHECK (`data_version` >= 1)
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '逻辑计量点年级统计数据' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_meter_data_yearly
-- ----------------------------
INSERT INTO `energy_meter_data_yearly` VALUES (1, 2, 1, 'IMPORT', 2024, 0.000000000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785674126428, NULL, 2, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 2, \"periodEnd\": 1735660800000, \"multiplier\": 1.0, \"periodStart\": 1704038400000, \"effectiveEnd\": 1735660800000, \"endReadingId\": 0, \"effectiveStart\": 1704038400000}', '2026-08-02 20:35:26.443000', '2026-08-02 20:35:26.443000');
INSERT INTO `energy_meter_data_yearly` VALUES (2, 2, 1, 'IMPORT', 2025, 65347.498800000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 2, 1785681498948, NULL, 2, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 2, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 20:35:26.471000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (3, 3, 1, 'IMPORT', 2025, 68090.673831000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 5, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 5, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (4, 4, 1, 'IMPORT', 2025, 70831.194315000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 8, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 8, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (5, 5, 1, 'IMPORT', 2025, 73568.210583000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 11, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 11, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (6, 6, 1, 'IMPORT', 2025, 76299.401446000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 14, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 14, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (7, 7, 1, 'IMPORT', 2025, 79035.593840000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 17, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 17, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (8, 8, 1, 'IMPORT', 2025, 81769.792176000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 20, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 20, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (9, 9, 1, 'IMPORT', 2025, 84515.744364000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 23, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 23, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (10, 10, 1, 'IMPORT', 2025, 87256.575916000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 26, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 26, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (11, 11, 1, 'IMPORT', 2025, 90004.701013000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 29, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 29, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (12, 12, 1, 'IMPORT', 2025, 92743.339311000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 32, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 32, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (13, 13, 1, 'IMPORT', 2025, 95482.521923000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 35, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 35, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (14, 14, 1, 'IMPORT', 2025, 98210.821562000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 38, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 38, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (15, 15, 1, 'IMPORT', 2025, 100948.987470000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 41, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 41, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (16, 16, 1, 'IMPORT', 2025, 103679.583701000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 44, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 44, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (17, 17, 1, 'IMPORT', 2025, 106428.538446000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 47, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 47, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (18, 18, 1, 'IMPORT', 2025, 109169.273123000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 50, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 50, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (19, 19, 1, 'IMPORT', 2025, 111918.398278000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 53, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 53, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (20, 20, 1, 'IMPORT', 2025, 114658.600465000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 56, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 56, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (21, 21, 1, 'IMPORT', 2025, 117396.277421000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 59, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 59, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (22, 22, 1, 'IMPORT', 2025, 120123.940695000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 62, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 62, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (23, 23, 1, 'IMPORT', 2025, 122859.742049000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 65, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 65, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (24, 24, 1, 'IMPORT', 2025, 125592.277646000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 68, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 68, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (25, 25, 1, 'IMPORT', 2025, 128339.245453000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 71, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 71, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (26, 26, 1, 'IMPORT', 2025, 131083.117884000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 74, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 74, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (27, 27, 1, 'IMPORT', 2025, 133827.652208000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 77, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 77, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (28, 28, 1, 'IMPORT', 2025, 136573.393135000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 80, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 80, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (29, 29, 1, 'IMPORT', 2025, 139305.737320000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 83, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 83, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (30, 30, 1, 'IMPORT', 2025, 142039.168202000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 86, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 86, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (31, 31, 1, 'IMPORT', 2025, 144768.792776000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'GOOD', '[]', 1, 1785681498948, NULL, 89, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 89, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"endReadingId\": 0, \"effectiveStart\": 1735660800000, \"startReadingId\": 0}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (32, 32, 1, 'IMPORT', 2025, 0.000000000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498948, NULL, 92, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 92, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (33, 33, 1, 'IMPORT', 2025, 0.000000000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498948, NULL, 95, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 95, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (34, 34, 1, 'IMPORT', 2025, 0.000000000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498948, NULL, 98, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 98, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (35, 35, 1, 'IMPORT', 2025, 0.000000000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498948, NULL, 101, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 101, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (36, 36, 1, 'IMPORT', 2025, 0.000000000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498948, NULL, 104, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 104, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (37, 37, 1, 'IMPORT', 2025, 0.000000000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498948, NULL, 107, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 107, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (38, 38, 1, 'IMPORT', 2025, 0.000000000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498948, NULL, 110, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 110, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (39, 39, 1, 'IMPORT', 2025, 0.000000000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498948, NULL, 113, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 113, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (40, 40, 1, 'IMPORT', 2025, 0.000000000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498948, NULL, 116, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 116, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (41, 41, 1, 'IMPORT', 2025, 0.000000000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498948, NULL, 119, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 119, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (42, 42, 1, 'IMPORT', 2025, 0.000000000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498948, NULL, 122, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 122, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (43, 43, 1, 'IMPORT', 2025, 0.000000000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498948, NULL, 125, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 125, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (44, 44, 1, 'IMPORT', 2025, 0.000000000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498948, NULL, 128, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 128, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (45, 45, 1, 'IMPORT', 2025, 0.000000000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498948, NULL, 131, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 131, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (46, 46, 1, 'IMPORT', 2025, 0.000000000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498948, NULL, 134, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 134, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (47, 47, 1, 'IMPORT', 2025, 0.000000000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498948, NULL, 137, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 137, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');
INSERT INTO `energy_meter_data_yearly` VALUES (48, 48, 1, 'IMPORT', 2025, 0.000000000000, NULL, NULL, NULL, NULL, 'METER_CALC', 'INVALID', '[\"START_READING_MISSING\"]', 1, 1785681498948, NULL, 140, NULL, NULL, '{\"algorithm\": \"CUMULATIVE_DIFFERENCE\", \"channelId\": 140, \"periodEnd\": 1767196800000, \"multiplier\": 1.0, \"periodStart\": 1735660800000, \"effectiveEnd\": 1767196800000, \"effectiveStart\": 1735660800000}', '2026-08-02 22:38:19.623000', '2026-08-02 22:38:19.623000');

-- ----------------------------
-- Table structure for energy_meter_formula
-- ----------------------------
DROP TABLE IF EXISTS `energy_meter_formula`;
CREATE TABLE `energy_meter_formula`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '虚拟表计公式ID',
  `meter_id` bigint NOT NULL COMMENT '虚拟逻辑表计ID',
  `version_no` int NOT NULL COMMENT '公式版本号；同一表计递增',
  `formula_expression` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公式表达式',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `valid_from` datetime(6) NOT NULL COMMENT '公式生效时间',
  `valid_to` datetime(6) NULL DEFAULT NULL COMMENT '公式失效时间；为空表示当前有效',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'ACTIVE' COMMENT '状态：ACTIVE启用、DISABLED停用',
  `current_key` tinyint GENERATED ALWAYS AS ((case when ((`status` = _utf8mb4'ACTIVE') and (`valid_to` is null)) then 1 else NULL end)) STORED COMMENT '当前有效公式唯一索引辅助字段' NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_meter_formula_version`(`meter_id` ASC, `version_no` ASC) USING BTREE,
  UNIQUE INDEX `uk_meter_formula_current`(`meter_id` ASC, `current_key` ASC) USING BTREE,
  INDEX `idx_meter_formula_effective`(`meter_id` ASC, `valid_from` ASC, `valid_to` ASC, `status` ASC) USING BTREE,
  CONSTRAINT `ck_meter_formula_range` CHECK ((`valid_to` is null) or (`valid_to` > `valid_from`))
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '虚拟逻辑表计公式版本' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of energy_meter_formula
-- ----------------------------

-- ----------------------------
-- Table structure for energy_meter_formula_dependency
-- ----------------------------
DROP TABLE IF EXISTS `energy_meter_formula_dependency`;
CREATE TABLE `energy_meter_formula_dependency`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `formula_id` bigint NOT NULL COMMENT '虚拟表计公式ID',
  `source_meter_id` bigint NOT NULL COMMENT '来源逻辑表计ID',
  `dependency_role` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'INPUT' COMMENT '依赖角色：INPUT输入、REFERENCE参考',
  `coefficient` decimal(28, 12) NOT NULL DEFAULT 1.000000000000 COMMENT '来源表计计算系数',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '计算顺序',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_meter_formula_dependency`(`formula_id` ASC, `source_meter_id` ASC, `dependency_role` ASC) USING BTREE,
  INDEX `idx_formula_dependency_source`(`source_meter_id` ASC, `formula_id` ASC) USING BTREE,
  CONSTRAINT `ck_meter_formula_dependency_self` CHECK (`source_meter_id` > 0)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '虚拟表计公式的结构化依赖关系；用于循环检查和级联重算' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of energy_meter_formula_dependency
-- ----------------------------

-- ----------------------------
-- Table structure for energy_meter_usage_calc_task
-- ----------------------------
DROP TABLE IF EXISTS `energy_meter_usage_calc_task`;
CREATE TABLE `energy_meter_usage_calc_task`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `meter_id` bigint NOT NULL COMMENT '待计算的能源逻辑计量点ID',
  `calc_source_type` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '计算来源：PHYSICAL_CHANNEL物理通道、VIRTUAL_FORMULA虚拟公式、UNRESOLVED待修复',
  `meter_channel_id` bigint NULL DEFAULT NULL COMMENT '物理表计计算使用的energy_meter_channel.id',
  `formula_id` bigint NULL DEFAULT NULL COMMENT '虚拟表计计算使用的energy_meter_formula.id',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `meter_channel_key` bigint GENERATED ALWAYS AS (ifnull(`meter_channel_id`,0)) STORED COMMENT '通道唯一索引辅助字段' NULL,
  `formula_key` bigint GENERATED ALWAYS AS (ifnull(`formula_id`,0)) STORED COMMENT '公式唯一索引辅助字段' NULL,
  `target_data_table` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务成功后写入的表计统计表名',
  `target_data_id` bigint NULL DEFAULT NULL COMMENT '任务成功后写入或更新的统计记录ID',
  `granularity` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '统计粒度：MINUTE、HOUR、DAY、MONTH、YEAR',
  `interval_minutes` int NOT NULL DEFAULT 0 COMMENT '统计间隔分钟数；分钟粒度填写实际分钟数，其他粒度填写0',
  `period_start` datetime(6) NOT NULL COMMENT '周期开始',
  `period_end` datetime(6) NOT NULL COMMENT '周期结束',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'PENDING' COMMENT '任务状态：PENDING待执行、RUNNING执行中、RETRY_WAIT等待重试、SUCCESS成功、FAILED失败、CANCELLED取消',
  `attempts` int NOT NULL DEFAULT 0 COMMENT '已认领执行次数；每次成功认领任务时加1',
  `max_attempts` int NOT NULL DEFAULT 5 COMMENT '最大允许执行次数',
  `next_retry_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '下次允许认领执行的时间',
  `locked_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '当前认领任务的工作节点标识',
  `lock_token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '本次任务认领令牌，用于防止过期工作节点提交结果',
  `locked_at` datetime(6) NULL DEFAULT NULL COMMENT '最近一次任务认领时间',
  `lock_until` datetime(6) NULL DEFAULT NULL COMMENT '任务锁租约到期时间',
  `last_error` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '最近错误',
  `started_at` datetime(6) NULL DEFAULT NULL COMMENT '最近一次开始执行时间',
  `completed_at` datetime(6) NULL DEFAULT NULL COMMENT '任务最终成功或失败时间',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_meter_usage_calc_task`(`meter_id` ASC, `calc_source_type` ASC, `meter_channel_key` ASC, `formula_key` ASC, `direction` ASC, `granularity` ASC, `interval_minutes` ASC, `period_start` ASC, `period_end` ASC) USING BTREE,
  INDEX `idx_meter_usage_task_due`(`status` ASC, `next_retry_at` ASC, `id` ASC) USING BTREE,
  INDEX `idx_meter_usage_task_lock`(`status` ASC, `lock_until` ASC) USING BTREE,
  INDEX `idx_meter_usage_task_period`(`meter_id` ASC, `period_start` ASC, `period_end` ASC) USING BTREE,
  INDEX `idx_meter_usage_task_target`(`target_data_table` ASC, `target_data_id` ASC) USING BTREE,
  INDEX `idx_meter_usage_task_channel`(`meter_channel_id` ASC, `period_start` ASC, `period_end` ASC) USING BTREE,
  INDEX `idx_meter_usage_task_formula`(`formula_id` ASC, `period_start` ASC, `period_end` ASC) USING BTREE,
  CONSTRAINT `ck_meter_usage_calc_source` CHECK (((`calc_source_type` = _utf8mb4'UNRESOLVED') and (`meter_channel_id` is null) and (`formula_id` is null)) or ((`calc_source_type` = _utf8mb4'PHYSICAL_CHANNEL') and (`meter_channel_id` is not null) and (`formula_id` is null)) or ((`calc_source_type` = _utf8mb4'VIRTUAL_FORMULA') and (`formula_id` is not null) and (`meter_channel_id` is null)))
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '表计周期统计计算任务；明确绑定当期有效物理通道或虚拟公式版本' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_meter_usage_calc_task
-- ----------------------------

-- ----------------------------
-- Table structure for energy_meter_usage_recalc_job
-- ----------------------------
DROP TABLE IF EXISTS `energy_meter_usage_recalc_job`;
CREATE TABLE `energy_meter_usage_recalc_job`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `meter_id` bigint NOT NULL COMMENT '需要重新计算用量的能源逻辑计量点ID',
  `trigger_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '重算触发类型：LATE_DATA、HISTORY_UPDATE、HISTORY_DELETE、CHANNEL_CONFIG_CHANGE、BRANCH_BINDING_CHANGE、DIMENSION_BINDING_CHANGE、FORMULA_CHANGE、MANUAL、SYSTEM_REPAIR',
  `trigger_source_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '触发来源类型：DEVICE_HISTORY、METER_CHANNEL、METER_BRANCH_BINDING、BRANCH_DIMENSION_BINDING、VIRTUAL_FORMULA、MANUAL、SYSTEM',
  `trigger_source_id` bigint NULL DEFAULT NULL COMMENT '触发来源记录ID，例如device_history.id',
  `trigger_source_time` datetime(6) NULL DEFAULT NULL COMMENT '触发来源记录时间；关联分区历史数据时用于定位分区',
  `source_changed_at` datetime(6) NOT NULL COMMENT '导致本次重算的源数据或配置实际发生变化的时间',
  `impact_start` datetime(6) NOT NULL COMMENT '重算影响范围开始时间，包含该时间点',
  `impact_end` datetime(6) NOT NULL COMMENT '重算影响范围结束时间，不包含该时间点',
  `recalc_scope` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'METER_ONLY' COMMENT '重算范围：METER_ONLY仅表计统计、STAT_CASCADE级联支路区域分项统计、FULL_CASCADE包含分摊换算计费和异常检测',
  `granularity_scope` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'ALL' COMMENT '重算粒度范围：BASE_ONLY基础分钟粒度、ALL全部粒度、CUSTOM自定义粒度',
  `recalc_config` json NULL COMMENT '重算扩展配置；CUSTOM粒度列表、级联选项及其他执行参数',
  `idempotency_key` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL COMMENT '重算请求幂等键，建议使用SHA-256十六进制字符串',
  `status` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'PENDING' COMMENT '任务状态：PENDING待执行、RUNNING执行中、RETRY_WAIT等待重试、SUCCESS成功、PARTIAL_SUCCESS部分成功、FAILED失败、CANCELLED取消',
  `billing_impact_status` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'UNKNOWN' COMMENT '账单影响状态：NONE无影响、POSSIBLE可能影响、CONFIRMED确认影响、REBILL_REQUIRED需要重新出账、UNKNOWN未分析',
  `billing_impact_detail` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '账单影响说明',
  `preview_json` json NULL COMMENT '重算预览结果',
  `result_json` json NULL COMMENT '重算执行结果',
  `total_task_count` int NOT NULL DEFAULT 0 COMMENT '本次重算关联的周期计算任务总数',
  `success_task_count` int NOT NULL DEFAULT 0 COMMENT '执行成功的周期计算任务数量',
  `failed_task_count` int NOT NULL DEFAULT 0 COMMENT '执行失败的周期计算任务数量',
  `attempts` int NOT NULL DEFAULT 0 COMMENT '已认领执行次数；每次成功认领任务时加1',
  `max_attempts` int NOT NULL DEFAULT 5 COMMENT '最大允许执行次数',
  `next_retry_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '下次允许认领执行的时间',
  `locked_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '当前认领任务的工作节点标识',
  `lock_token` varchar(64) CHARACTER SET ascii COLLATE ascii_bin NULL DEFAULT NULL COMMENT '本次任务认领令牌；防止过期工作节点提交结果',
  `locked_at` datetime(6) NULL DEFAULT NULL COMMENT '最近一次任务认领时间',
  `lock_until` datetime(6) NULL DEFAULT NULL COMMENT '任务锁租约到期时间',
  `last_error` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '最近一次执行错误信息',
  `started_at` datetime(6) NULL DEFAULT NULL COMMENT '最近一次开始执行时间',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  `completed_at` datetime(6) NULL DEFAULT NULL COMMENT '任务最终成功、部分成功或失败时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_recalculation_idempotent`(`idempotency_key` ASC) USING BTREE,
  INDEX `idx_meter_usage_recalc_queue`(`status` ASC, `next_retry_at` ASC, `id` ASC) USING BTREE,
  INDEX `idx_meter_usage_recalc_lock`(`status` ASC, `lock_until` ASC) USING BTREE,
  INDEX `idx_meter_usage_recalc_meter_range`(`meter_id` ASC, `status` ASC, `impact_start` ASC, `impact_end` ASC) USING BTREE,
  INDEX `idx_meter_usage_recalc_source`(`trigger_source_type` ASC, `trigger_source_id` ASC, `trigger_source_time` ASC) USING BTREE,
  INDEX `idx_meter_usage_recalc_created`(`created_at` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源逻辑计量点统计数据重算编排任务；根据影响范围生成并管理多个周期统计计算任务' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_meter_usage_recalc_job
-- ----------------------------

-- ----------------------------
-- Table structure for energy_meter_usage_recalc_job_task
-- ----------------------------
DROP TABLE IF EXISTS `energy_meter_usage_recalc_job_task`;
CREATE TABLE `energy_meter_usage_recalc_job_task`  (
  `recalc_job_id` bigint NOT NULL COMMENT '表计用量重算编排任务ID',
  `calc_task_id` bigint NOT NULL COMMENT '表计周期用量计算任务ID，对应energy_meter_usage_calc_task.id',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '关联关系创建时间',
  PRIMARY KEY (`recalc_job_id`, `calc_task_id`) USING BTREE,
  INDEX `idx_recalc_job_task_calc`(`calc_task_id` ASC, `recalc_job_id` ASC) USING BTREE,
  INDEX `idx_recalc_job_task_created`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '表计用量重算编排任务与具体周期计算任务关联关系' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_meter_usage_recalc_job_task
-- ----------------------------

-- ----------------------------
-- Table structure for energy_reconciliation_result
-- ----------------------------
DROP TABLE IF EXISTS `energy_reconciliation_result`;
CREATE TABLE `energy_reconciliation_result`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `parent_branch_id` bigint NOT NULL COMMENT '参与总分关系对账的父能源支路ID',
  `parent_meter_id` bigint NULL DEFAULT NULL COMMENT '父支路本次对账使用的逻辑计量点ID',
  `parent_data_table` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '父支路来源统计表名',
  `parent_data_id` bigint NOT NULL COMMENT '父支路来源统计记录ID',
  `granularity` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '统计粒度：MINUTE、HOUR、DAY、MONTH、CUSTOM',
  `interval_minutes` int NOT NULL DEFAULT 0 COMMENT '统计间隔分钟数；分钟粒度填写实际分钟数，其他粒度填写0',
  `period_start` datetime(6) NOT NULL COMMENT '周期开始时间，包含该时间点',
  `period_end` datetime(6) NOT NULL COMMENT '周期结束时间，不包含该时间点',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'IMPORT' COMMENT '能源流向：IMPORT输入、EXPORT输出',
  `parent_quantity` decimal(38, 12) NOT NULL COMMENT '父支路统计用量快照',
  `child_quantity` decimal(38, 12) NOT NULL COMMENT '参与对账的有效子支路用量合计',
  `difference_quantity` decimal(38, 12) NOT NULL COMMENT '对账差值，计算方式为父支路用量减去子支路用量合计',
  `deviation_rate` decimal(18, 8) NULL DEFAULT NULL COMMENT '偏差率；通常为差值除以父支路用量，父用量为0时可为空',
  `base_unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '能源用量标准单位快照',
  `expected_child_count` int NOT NULL DEFAULT 0 COMMENT '预期参与对账的子支路数量',
  `actual_child_count` int NOT NULL DEFAULT 0 COMMENT '实际有效参与对账的子支路数量',
  `missing_child_count` int NOT NULL DEFAULT 0 COMMENT '缺少有效统计数据的子支路数量',
  `excluded_child_count` int NOT NULL DEFAULT 0 COMMENT '因停用、方向不一致等原因排除的子支路数量',
  `warning_threshold` decimal(18, 8) NULL DEFAULT NULL COMMENT '本次计算使用的偏差预警阈值快照',
  `abnormal_threshold` decimal(18, 8) NULL DEFAULT NULL COMMENT '本次计算使用的偏差异常阈值快照',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'NORMAL' COMMENT '对账状态：NORMAL正常、WARNING预警、ABNORMAL异常、INCOMPLETE数据不完整、INVALID无效',
  `quality_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'GOOD' COMMENT '对账来源统计数据质量状态：GOOD、PARTIAL、ESTIMATED、INVALID',
  `quality_codes` json NULL COMMENT '数据质量问题编码集合',
  `calculation_snapshot` json NULL COMMENT '本次对账计算公式、阈值和处理策略快照',
  `result_version` int NOT NULL DEFAULT 1 COMMENT '结果版本号',
  `is_current` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否当前有效版本',
  `current_key` tinyint GENERATED ALWAYS AS ((case when (`is_current` = 1) then 1 else NULL end)) STORED COMMENT '当前版本唯一索引辅助字段' NULL,
  `supersedes_result_id` bigint NULL DEFAULT NULL COMMENT '被本版本替代的对账结果ID',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '计算批次ID',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_reconciliation_result_version`(`energy_type_id` ASC, `parent_branch_id` ASC, `granularity` ASC, `interval_minutes` ASC, `period_start` ASC, `period_end` ASC, `direction` ASC, `result_version` ASC) USING BTREE,
  UNIQUE INDEX `uk_reconciliation_result_current`(`energy_type_id` ASC, `parent_branch_id` ASC, `granularity` ASC, `interval_minutes` ASC, `period_start` ASC, `period_end` ASC, `direction` ASC, `current_key` ASC) USING BTREE,
  INDEX `idx_reconciliation_branch_period`(`parent_branch_id` ASC, `energy_type_id` ASC, `granularity` ASC, `period_start` ASC) USING BTREE,
  INDEX `idx_reconciliation_status_period`(`status` ASC, `period_start` ASC) USING BTREE,
  INDEX `idx_reconciliation_parent_data`(`parent_data_table` ASC, `parent_data_id` ASC) USING BTREE,
  INDEX `idx_reconciliation_batch`(`calculation_batch_id` ASC, `created_at` ASC) USING BTREE,
  CONSTRAINT `ck_reconciliation_result_version` CHECK (`result_version` >= 1)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源父支路与下级支路用量的总分关系对账结果' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_reconciliation_result
-- ----------------------------

-- ----------------------------
-- Table structure for energy_reconciliation_result_detail
-- ----------------------------
DROP TABLE IF EXISTS `energy_reconciliation_result_detail`;
CREATE TABLE `energy_reconciliation_result_detail`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `reconciliation_result_id` bigint NOT NULL COMMENT '对账结果ID',
  `child_branch_id` bigint NOT NULL COMMENT '参与对账的子能源支路ID',
  `child_meter_id` bigint NULL DEFAULT NULL COMMENT '子支路本次使用的逻辑计量点ID',
  `child_data_table` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '子支路来源统计表名；缺少统计数据时为空',
  `child_data_id` bigint NULL DEFAULT NULL COMMENT '子支路来源统计记录ID；缺少统计数据时为空',
  `quantity` decimal(38, 12) NULL DEFAULT NULL COMMENT '子支路参与对账的用量快照；缺少数据时为空',
  `base_unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '子支路用量标准单位快照',
  `quality_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '子支路统计数据质量状态快照',
  `included` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否计入子支路用量合计：0否、1是',
  `exclude_reason` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '未计入对账合计的原因',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_reconciliation_detail`(`reconciliation_result_id` ASC, `child_branch_id` ASC) USING BTREE,
  INDEX `idx_reconciliation_detail_branch`(`child_branch_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_reconciliation_detail_data`(`child_data_table` ASC, `child_data_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源总分关系对账结果的子支路明细' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_reconciliation_result_detail
-- ----------------------------

-- ----------------------------
-- Table structure for energy_stat_data_history_lineage
-- ----------------------------
DROP TABLE IF EXISTS `energy_stat_data_history_lineage`;
CREATE TABLE `energy_stat_data_history_lineage`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `stat_data_table` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '目标统计表名，通常为energy_meter_data_min/hourly/daily/monthly/yearly',
  `stat_data_id` bigint NOT NULL COMMENT '目标统计记录ID',
  `meter_id` bigint NOT NULL COMMENT '逻辑计量点ID',
  `history_id` bigint NOT NULL COMMENT 'device_history.id',
  `history_create_time` datetime(6) NOT NULL COMMENT 'device_history.create_time，用于定位时间分区',
  `input_role` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'SOURCE' COMMENT '输入角色：START、END、SOURCE、SAMPLE、REFERENCE',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_stat_history_lineage`(`stat_data_table` ASC, `stat_data_id` ASC, `history_id` ASC, `history_create_time` ASC) USING BTREE,
  INDEX `idx_stat_history_source`(`history_id` ASC, `history_create_time` ASC, `stat_data_table` ASC, `stat_data_id` ASC) USING BTREE,
  INDEX `idx_stat_history_target`(`stat_data_table` ASC, `stat_data_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能耗统计记录与device_history原始记录之间的计算血缘' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of energy_stat_data_history_lineage
-- ----------------------------

-- ----------------------------
-- Table structure for energy_stat_data_lineage
-- ----------------------------
DROP TABLE IF EXISTS `energy_stat_data_lineage`;
CREATE TABLE `energy_stat_data_lineage`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `target_data_table` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '派生目标统计表名',
  `target_data_id` bigint NOT NULL COMMENT '派生目标统计记录ID',
  `source_data_table` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '来源统计表名',
  `source_data_id` bigint NOT NULL COMMENT '来源统计记录ID',
  `input_role` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'COMPONENT' COMMENT '输入角色：COMPONENT组成、DIRECT直接量、CHILD子级量、ALLOCATION分摊来源、CORRECTION修正来源',
  `coefficient` decimal(28, 12) NOT NULL DEFAULT 1.000000000000 COMMENT '计算系数',
  `source_quantity` decimal(38, 12) NULL DEFAULT NULL COMMENT '参与计算的来源用量快照',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_stat_data_lineage`(`target_data_table` ASC, `target_data_id` ASC, `source_data_table` ASC, `source_data_id` ASC, `input_role` ASC) USING BTREE,
  INDEX `idx_stat_lineage_target`(`target_data_table` ASC, `target_data_id` ASC) USING BTREE,
  INDEX `idx_stat_lineage_source`(`source_data_table` ASC, `source_data_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '支路、区域、分项等派生统计记录之间的计算血缘' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of energy_stat_data_lineage
-- ----------------------------

-- ----------------------------
-- Table structure for energy_stat_data_revision
-- ----------------------------
DROP TABLE IF EXISTS `energy_stat_data_revision`;
CREATE TABLE `energy_stat_data_revision`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `stat_data_table` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '统计表名',
  `stat_data_id` bigint NOT NULL COMMENT '统计主表记录ID',
  `data_version` int NOT NULL COMMENT '被归档的数据版本',
  `object_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '统计对象类型：METER、LINE、AREA、ITEM',
  `object_id` bigint NOT NULL COMMENT '统计对象ID',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `direction` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '能源流向',
  `period_start` datetime(6) NOT NULL COMMENT '统计周期开始',
  `period_end` datetime(6) NOT NULL COMMENT '统计周期结束',
  `revision_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'UPDATE' COMMENT '归档类型：UPDATE更新前版本、DELETE删除前版本',
  `data_snapshot` json NOT NULL COMMENT '统计记录完整快照',
  `change_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '变更原因',
  `calculation_batch_id` bigint NULL DEFAULT NULL COMMENT '计算批次ID',
  `recalc_job_id` bigint NULL DEFAULT NULL COMMENT '重算编排任务ID',
  `created_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '归档操作人或工作节点',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '归档时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_stat_data_revision`(`stat_data_table` ASC, `stat_data_id` ASC, `data_version` ASC) USING BTREE,
  INDEX `idx_stat_revision_object_period`(`object_type` ASC, `object_id` ASC, `energy_type_id` ASC, `period_start` ASC) USING BTREE,
  INDEX `idx_stat_revision_recalc`(`recalc_job_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_stat_revision_batch`(`calculation_batch_id` ASC, `created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '20张能耗统计主表的历史版本归档；更新或删除前由应用层同事务写入' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of energy_stat_data_revision
-- ----------------------------

-- ----------------------------
-- Table structure for energy_sub_item
-- ----------------------------
DROP TABLE IF EXISTS `energy_sub_item`;
CREATE TABLE `energy_sub_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID；同一分项树内父子节点能源类型必须一致',
  `parent_id` bigint NULL DEFAULT NULL COMMENT '父级分项ID；为空表示能源类型下的根分项',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分项名称',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分项编码；同一能源类型下唯一',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '同级分项排序顺序',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'ACTIVE' COMMENT '状态：ACTIVE启用、DISABLED停用',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '分项说明',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '创建人',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '更新人',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_sub_item_energy_code`(`energy_type_id` ASC, `code` ASC) USING BTREE,
  INDEX `idx_sub_item_parent_status_sort`(`parent_id` ASC, `status` ASC, `sort_order` ASC) USING BTREE,
  INDEX `idx_sub_item_energy_status`(`energy_type_id` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源分项分类树；描述不同能源类型的使用用途' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_sub_item
-- ----------------------------
INSERT INTO `energy_sub_item` VALUES (1, 1, 0, '电', '01', 0, 'ACTIVE', '建筑用电总分类', '', '2026-07-17 23:18:49.642635', '', '2026-07-28 22:33:16.782874');
INSERT INTO `energy_sub_item` VALUES (2, 1, 1, '照明插座用电', '01A', 0, 'ACTIVE', '建筑物主要功能区域的照明、插座等室内设备用电总称', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (3, 1, 2, '房间照明和插座', '01A1', 0, 'ACTIVE', '包括计算机、打印机等办公设备和风机盘管、分体空调等没有单独供电回路的空调设备', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (4, 1, 2, '公共区域照明', '01A2', 0, 'ACTIVE', '走廊、大堂等公共区域的灯具照明和应急照明', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (5, 1, 2, '室外景观照明', '01A3', 0, 'ACTIVE', '建筑室外的照明灯具、室外景观等', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (6, 1, 1, '采暖空调用电', '01B', 0, 'ACTIVE', '为建筑物提供空调、采暖服务的设备用电总称', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (7, 1, 6, '冷热源系统', '01B1', 0, 'ACTIVE', '冷水机组、冷却泵、冷却塔、电锅炉、采暖循环泵、补水泵、定压泵等', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (8, 1, 6, '空调水系统', '01B2', 0, 'ACTIVE', '一次冷冻泵、二次冷冻泵、冷冻水加压泵等', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (9, 1, 6, '空调风系统', '01B3', 0, 'ACTIVE', '空调机组、新风机组、变风量末端、热回收机组等', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (10, 1, 6, '分散式空调', '01B4', 0, 'ACTIVE', '分体式空调、变制冷剂流量多联式空调机组、电热膜设备', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (11, 1, 1, '动力用电', '01C', 0, 'ACTIVE', '集中提供各种动力服务的设备用电总称', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (12, 1, 11, '电梯', '01C1', 0, 'ACTIVE', '包括货梯、客梯、消防梯、扶梯及其附属设备、专用空调等', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (13, 1, 11, '水泵', '01C2', 0, 'ACTIVE', '包括给水泵、生活热水泵、排污泵、中水泵等', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (14, 1, 11, '通风机', '01C3', 0, 'ACTIVE', '包括地下室通风机、车库通风机、厕所排风机等', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (15, 1, 1, '特殊用电', '01D', 0, 'ACTIVE', '高耗能密度、占总电耗比重大的特殊区域及设备用电', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (16, 1, 15, '信息机房', '01D1', 0, 'ACTIVE', '包括通信、网络和计算机设备及机房空调设备等', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (17, 1, 15, '洗衣房', '01D2', 0, 'ACTIVE', '包括洗衣机、脱水机、烘干机、烫平机等', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (18, 1, 15, '厨房餐厅', '01D3', 0, 'ACTIVE', '包括厨房专用设备、厨房专用空调和通风机等', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (19, 1, 15, '游泳池', '01D4', 0, 'ACTIVE', '包括采暖、空调、通风和水处理等设备', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (20, 1, 15, '健身房', '01D5', 0, 'ACTIVE', '包括健身器械、空调和通风等', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (21, 1, 15, '洁净室', '01D6', 0, 'ACTIVE', '包括净化空调、工艺设备等', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (22, 1, 15, '其他', '01D7', 0, 'ACTIVE', '包括开水器、电热水器、充电桩、太阳能热水系统辅助电加热等', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (23, 2, 0, '水', '02', 0, 'ACTIVE', '建筑用水总分类', '', '2026-07-17 23:18:49.642635', '', '2026-07-28 22:33:19.456330');
INSERT INTO `energy_sub_item` VALUES (24, 2, 23, '市政自来水', '02A', 0, 'ACTIVE', '城市市政供水管网供应的水资源', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (25, 2, 24, '生活用水量', '02A1', 0, 'ACTIVE', '包括生活饮用水、生活热水、厨房餐厅用水、洗衣房用水等', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (26, 2, 24, '游泳池用水量', '02A2', 0, 'ACTIVE', '游泳池补充水', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (27, 2, 24, '供暖空调系统用水量', '02A3', 0, 'ACTIVE', '冷冻水补水、冷却水补水、锅炉房补水、换热站补水', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (28, 2, 24, '景观水体用水量', '02A4', 0, 'ACTIVE', '洗车及道路用水、绿化用水', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (29, 2, 24, '消防系统用水', '02A5', 0, 'ACTIVE', '消防用水、消防补水', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (30, 2, 23, '市政中水', '02B', 0, 'ACTIVE', '城市中水利用系统供应的非饮用水', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (31, 2, 30, '生活用水量', '02B1', 0, 'ACTIVE', '主要用于冲厕用水', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (32, 2, 30, '供暖空调系统用水量', '02B2', 0, 'ACTIVE', '空调系统补充用水', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (33, 2, 30, '洗车及道路用水', '02B3', 0, 'ACTIVE', '洗车用水、道路冲洗用水', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (34, 2, 30, '景观水体用水量', '02B4', 0, 'ACTIVE', '景观补水、绿化用水', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (35, 2, 23, '非市政供水', '02C', 0, 'ACTIVE', '建筑自备水源供应的水资源', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (36, 2, 35, '自制中水', '02C1', 0, 'ACTIVE', '建筑内部处理的中水系统', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (37, 2, 35, '雨水', '02C2', 0, 'ACTIVE', '雨水收集利用系统', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (38, 2, 35, '自然水源', '02C3', 0, 'ACTIVE', '地下水、地表水等自然水源', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (39, 2, 35, '其他水源', '02C4', 0, 'ACTIVE', '其他非市政供水来源', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (40, 3, 0, '天然气', '03', 0, 'ACTIVE', '管道天然气供应', '', '2026-07-17 23:18:49.642635', '', '2026-07-28 22:33:23.237065');
INSERT INTO `energy_sub_item` VALUES (41, 3, 40, '厨房餐厅', '03A1', 0, 'ACTIVE', '厨房用气', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (42, 3, 40, '冷热源', '03A2', 0, 'ACTIVE', '燃气锅炉、燃气机组等用气', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (43, 3, 40, '生活热水', '03A3', 0, 'ACTIVE', '燃气热水器用气', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (44, 3, 40, '其他用途', '03A4', 0, 'ACTIVE', '其他燃气用途', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (45, 4, 0, '液化石油气', '04', 0, 'ACTIVE', '瓶装或储罐液化石油气供应', '', '2026-07-17 23:18:49.642635', '', '2026-07-28 22:33:25.354994');
INSERT INTO `energy_sub_item` VALUES (46, 4, 45, '厨房餐厅', '04A1', 0, 'ACTIVE', '厨房用气', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (47, 4, 45, '冷热源', '04A2', 0, 'ACTIVE', '燃气锅炉等用气', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (48, 4, 45, '生活热水', '04A3', 0, 'ACTIVE', '生活热水用气', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (49, 4, 45, '其他用途', '04A4', 0, 'ACTIVE', '其他用气', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (50, 5, 0, '人工煤气', '05', 0, 'ACTIVE', '煤气站供应的人工煤气', '', '2026-07-17 23:18:49.642635', '', '2026-07-28 22:33:26.224115');
INSERT INTO `energy_sub_item` VALUES (51, 5, 50, '厨房餐厅', '05A1', 0, 'ACTIVE', '厨房用气', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (52, 5, 50, '冷热源', '05A2', 0, 'ACTIVE', '燃气设备用气', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (53, 5, 50, '生活热水', '05A3', 0, 'ACTIVE', '生活热水用气', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (54, 5, 50, '其他用途', '05A4', 0, 'ACTIVE', '其他用气', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (55, 6, 0, '集中供热量', '06', 0, 'ACTIVE', '区域或小区集中热网供应', '', '2026-07-17 23:18:49.642635', '', '2026-07-28 22:33:26.900996');
INSERT INTO `energy_sub_item` VALUES (56, 6, 55, '楼栋供热量', '06A1', 0, 'ACTIVE', '整栋建筑集中供热用量', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (57, 6, 55, '分层供热量', '06A2', 0, 'ACTIVE', '按楼层分项计量的供热用量', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (58, 6, 55, '分户供热量', '06A3', 0, 'ACTIVE', '按户计量的供热用量', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (59, 7, 0, '集中供冷量', '07', 0, 'ACTIVE', '区域集中供冷系统供应', '', '2026-07-17 23:18:49.642635', '', '2026-07-28 22:33:28.042999');
INSERT INTO `energy_sub_item` VALUES (60, 7, 59, '楼栋供冷量', '07A1', 0, 'ACTIVE', '整栋建筑集中供冷用量', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (61, 7, 59, '分层供冷量', '07A2', 0, 'ACTIVE', '按楼层分项计量的供冷用量', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (62, 7, 59, '分户供冷量', '07A3', 0, 'ACTIVE', '按户计量的供冷用量', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (63, 8, 0, '太阳能光热', '12', 0, 'ACTIVE', '太阳能热利用系统', '', '2026-07-17 23:18:49.642635', '', '2026-07-28 22:33:29.401481');
INSERT INTO `energy_sub_item` VALUES (64, 8, 63, '太阳能热水', '12A', 0, 'ACTIVE', '太阳能热水系统采集量', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (65, 8, 63, '太阳能供热采暖', '12B', 0, 'ACTIVE', '太阳能供热采暖系统采集量', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (66, 8, 63, '太阳能供热制冷', '12C', 0, 'ACTIVE', '太阳能制冷系统采集量', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (67, 8, 63, '其他太阳能光热利用', '12D', 0, 'ACTIVE', '其他太阳能光热应用', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (68, 9, 0, '太阳能光伏', '13', 0, 'ACTIVE', '太阳能光伏发电系统', '', '2026-07-17 23:18:49.642635', '', '2026-07-28 22:33:30.628429');
INSERT INTO `energy_sub_item` VALUES (69, 9, 68, '光伏发电量', '13A', 0, 'ACTIVE', '光伏系统总发电量', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (70, 10, 0, '浅层地热能', '14', 0, 'ACTIVE', '浅层地热能利用系统', '', '2026-07-17 23:18:49.642635', '', '2026-07-28 22:33:31.988224');
INSERT INTO `energy_sub_item` VALUES (71, 10, 70, '浅层地热能采暖', '14A', 0, 'ACTIVE', '浅层地热采暖系统供热量', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (72, 10, 70, '浅层地热能制冷', '14B', 0, 'ACTIVE', '浅层地热制冷系统供冷量', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (73, 10, 70, '其他浅层地热能利用', '14C', 0, 'ACTIVE', '其他浅层地热应用', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (74, 11, 0, '中深层地热能', '15', 0, 'ACTIVE', '中深层地热能利用系统', '', '2026-07-17 23:18:49.642635', '', '2026-07-28 22:33:33.661823');
INSERT INTO `energy_sub_item` VALUES (75, 11, 74, '中深层地热能采暖', '15A', 0, 'ACTIVE', '中深层地热采暖供热量', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (76, 11, 74, '中深层地热能制冷', '15B', 0, 'ACTIVE', '中深层地热制冷供冷量', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (77, 11, 74, '其他中深层地热能利用', '15C', 0, 'ACTIVE', '其他中深层地热应用', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (78, 12, 0, '风能发电', '16', 0, 'ACTIVE', '风力发电系统', '', '2026-07-17 23:18:49.642635', '', '2026-07-28 22:33:35.016889');
INSERT INTO `energy_sub_item` VALUES (79, 12, 78, '风能发电量', '16A', 0, 'ACTIVE', '风力发电系统总发电量', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (80, 13, 0, '生物质能', '17', 0, 'ACTIVE', '生物质能供应系统', '', '2026-07-17 23:18:49.642635', '', '2026-07-28 22:33:36.153145');
INSERT INTO `energy_sub_item` VALUES (81, 13, 80, '生物质采暖系统', '17A', 0, 'ACTIVE', '生物质燃料采暖系统', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (82, 13, 80, '生物质餐厨利用', '17B', 0, 'ACTIVE', '生物质燃料厨房利用', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (83, 13, 80, '生物质其他技术', '17C', 0, 'ACTIVE', '其他生物质能应用', '', '2026-07-17 23:18:49.642635', '', '2026-07-17 23:18:49.642635');
INSERT INTO `energy_sub_item` VALUES (84, 14, 0, '其他可再生能源', '18', 0, 'ACTIVE', '其他形式的可再生能源', '', '2026-07-17 23:18:49.642635', '', '2026-07-28 22:33:39.047754');
INSERT INTO `energy_sub_item` VALUES (85, 15, 0, '其他能源', '19', 0, 'ACTIVE', '其他类型能源', '', '2026-07-17 23:18:49.642635', '', '2026-07-28 22:33:40.024573');

-- ----------------------------
-- Table structure for energy_tariff_detail
-- ----------------------------
DROP TABLE IF EXISTS `energy_tariff_detail`;
CREATE TABLE `energy_tariff_detail`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `policy_id` bigint NOT NULL COMMENT '政策ID',
  `line_type` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'USAGE（用电量/实际用量）、PEAK（高峰/尖峰时段）、VALLEY（低谷时段）、FLAT（平段/平时段）、TIER（档位/阶梯档）、BASE_FEE（基本费/基础月费）、DEMAND（需量/最大需量）',
  `season_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '季节编码（如：SPRING春季/SUMMER夏季/AUTUMN秋季/WINTER冬季，可根据业务自定义扩展）',
  `start_time` time NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` time NULL DEFAULT NULL COMMENT '结束时间',
  `tier_min` decimal(38, 12) NULL DEFAULT NULL COMMENT '阶梯下限',
  `tier_max` decimal(38, 12) NULL DEFAULT NULL COMMENT '阶梯上限',
  `price` decimal(28, 12) NOT NULL COMMENT '单价',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序顺序',
  `detail_config` json NULL COMMENT '明细配置',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '创建人',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_tariff_detail_policy`(`policy_id` ASC, `line_type` ASC, `sort_order` ASC) USING BTREE,
  CONSTRAINT `ck_tariff_price` CHECK (`price` >= 0),
  CONSTRAINT `ck_tariff_tier` CHECK ((`tier_min` is null) or (`tier_max` is null) or (`tier_max` > `tier_min`))
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '统一能源计费策略明细' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_tariff_detail
-- ----------------------------

-- ----------------------------
-- Table structure for energy_tariff_policie
-- ----------------------------
DROP TABLE IF EXISTS `energy_tariff_policie`;
CREATE TABLE `energy_tariff_policie`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `policy_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '政策编码',
  `energy_type_id` bigint NOT NULL COMMENT '能源类型ID',
  `policy_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '政策名称',
  `policy_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'FLAT（固定费率/单一电价）、TIME_OF_USE（分时电价/峰谷电价）、TIERED（阶梯电价/分级电价）、SEASONAL（季节性电价）、COMPOSITE（组合电价/综合电价）',
  `currency_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'CNY' COMMENT '货币编码',
  `tax_rate` decimal(12, 8) NOT NULL DEFAULT 0.00000000 COMMENT '税比例',
  `applicable_object_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '适用对象类型',
  `applicable_object_id` bigint NULL DEFAULT NULL COMMENT '适用对象ID',
  `priority` int NOT NULL DEFAULT 0 COMMENT '优先级',
  `valid_from` datetime(6) NOT NULL COMMENT '有效起始',
  `valid_to` datetime(6) NULL DEFAULT NULL COMMENT '有效目标',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'DRAFT' COMMENT '状态',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '说明',
  `approved_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审核人',
  `approved_at` datetime(6) NULL DEFAULT NULL COMMENT '审核时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '创建人',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新人',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tariff_policy_code`(`policy_code` ASC) USING BTREE,
  INDEX `idx_tariff_match`(`energy_type_id` ASC, `applicable_object_type` ASC, `applicable_object_id` ASC, `valid_from` ASC, `valid_to` ASC, `priority` ASC) USING BTREE,
  CONSTRAINT `ck_tariff_range` CHECK ((`valid_to` is null) or (`valid_to` > `valid_from`)),
  CONSTRAINT `ck_tariff_tax` CHECK (`tax_rate` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '统一能源计费策略' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_tariff_policie
-- ----------------------------

-- ----------------------------
-- Table structure for energy_type
-- ----------------------------
DROP TABLE IF EXISTS `energy_type`;
CREATE TABLE `energy_type`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `type_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '能源类型编码，例如ELECTRICITY、WATER、NATURAL_GAS',
  `type_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '能源类型名称',
  `base_unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '能源用量标准单位，例如kWh、m³、Nm³、t、GJ',
  `display_precision` tinyint NOT NULL DEFAULT 2 COMMENT '展示小数位数，仅用于页面和报表展示，应用层限制为0到12',
  `billable` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否默认支持费用核算：0否、1是',
  `include_comprehensive` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否默认计入综合能耗；实际折算需使用有效折算因子',
  `include_carbon` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否默认计入碳排放；实际核算需使用有效排放因子',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '能源类型展示排序',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'ACTIVE' COMMENT '状态：ACTIVE启用、DISABLED停用',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '能源类型说明',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '创建人',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '更新人',
  `update_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_energy_type_code`(`type_code` ASC) USING BTREE,
  INDEX `idx_energy_type_status_sort`(`status` ASC, `sort_order` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '能源类型字典；定义能源介质、标准用量单位及默认核算属性' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of energy_type
-- ----------------------------
INSERT INTO `energy_type` VALUES (1, '01', '电', 'kWh', 2, 1, 1, 1, 0, 'ACTIVE', '交流电，标准电压380V/220V，折标准煤系数0.1229 kgce/kWh', '', '2026-07-17 23:25:41.861882', '', '2026-07-17 23:25:41.861882');
INSERT INTO `energy_type` VALUES (2, '02', '水', 't', 2, 1, 0, 0, 0, 'ACTIVE', '市政自来水，1立方米=1吨，0碳排放', '', '2026-07-17 23:25:41.861882', '', '2026-07-17 23:25:41.861882');
INSERT INTO `energy_type` VALUES (3, '03', '天然气', 'm³', 2, 1, 1, 1, 0, 'ACTIVE', '管道天然气，折标准煤1.1000-1.3300 kgce/m³', '', '2026-07-17 23:25:41.861882', '', '2026-07-17 23:25:41.861882');
INSERT INTO `energy_type` VALUES (4, '04', '液化石油气', 'kg', 2, 1, 1, 1, 0, 'ACTIVE', '液化石油气（LPG），折标准煤1.7572 kgce/kg', '', '2026-07-17 23:25:41.861882', '', '2026-07-17 23:25:41.861882');
INSERT INTO `energy_type` VALUES (5, '05', '人工煤气', 'm³', 2, 1, 1, 1, 0, 'ACTIVE', '人工煤气，折标准煤0.3571-1.2143 kgce/m³', '', '2026-07-17 23:25:41.861882', '', '2026-07-17 23:25:41.861882');
INSERT INTO `energy_type` VALUES (6, '06', '集中供热量', 'MJ', 2, 1, 1, 1, 0, 'ACTIVE', '区域或小区集中热网供热，折标准煤0.03412 kgce/MJ', '', '2026-07-17 23:25:41.861882', '', '2026-07-17 23:25:41.861882');
INSERT INTO `energy_type` VALUES (7, '07', '集中供冷量', 'MJ', 2, 1, 1, 1, 0, 'ACTIVE', '区域集中供冷系统，按热量折算', '', '2026-07-17 23:25:41.861882', '', '2026-07-17 23:25:41.861882');
INSERT INTO `energy_type` VALUES (8, '08', '原煤', 'kg', 2, 1, 1, 1, 0, 'ACTIVE', '烟煤或无烟煤，折标准煤0.7143 kgce/kg', '', '2026-07-17 23:25:41.861882', '', '2026-07-17 23:25:41.861882');
INSERT INTO `energy_type` VALUES (9, '09', '汽油', 'kg', 2, 1, 1, 1, 0, 'ACTIVE', '车用汽油，折标准煤1.4714 kgce/kg', '', '2026-07-17 23:25:41.861882', '', '2026-07-17 23:25:41.861882');
INSERT INTO `energy_type` VALUES (10, '10', '煤油', 'kg', 2, 1, 1, 1, 0, 'ACTIVE', '煤油/灯油，折标准煤1.4714 kgce/kg', '', '2026-07-17 23:25:41.861882', '', '2026-07-17 23:25:41.861882');
INSERT INTO `energy_type` VALUES (11, '11', '柴油', 'kg', 2, 1, 1, 1, 0, 'ACTIVE', '车用柴油，折标准煤1.4571 kgce/kg', '', '2026-07-17 23:25:41.861882', '', '2026-07-17 23:25:41.861882');
INSERT INTO `energy_type` VALUES (12, '12', '太阳能光热', 'MJ', 2, 0, 0, 0, 0, 'ACTIVE', '太阳能热水系统，0碳排放，可再生能源', '', '2026-07-17 23:25:41.861882', '', '2026-07-17 23:25:41.861882');
INSERT INTO `energy_type` VALUES (13, '13', '太阳能光伏发电', 'kWh', 2, 0, 0, 0, 0, 'ACTIVE', '光伏发电系统发电量，0碳排放，可再生能源', '', '2026-07-17 23:25:41.861882', '', '2026-07-17 23:25:41.861882');
INSERT INTO `energy_type` VALUES (14, '14', '浅层地热能', 'MJ', 2, 0, 0, 1, 0, 'ACTIVE', '浅层地热能采暖/制冷，低碳排放', '', '2026-07-17 23:25:41.861882', '', '2026-07-17 23:25:41.861882');
INSERT INTO `energy_type` VALUES (15, '15', '中深层地热能', 'MJ', 2, 0, 0, 0, 0, 'ACTIVE', '中深层地热能采暖/制冷，0碳排放，可再生能源', '', '2026-07-17 23:25:41.861882', '', '2026-07-17 23:25:41.861882');
INSERT INTO `energy_type` VALUES (16, '16', '风能发电', 'kWh', 2, 0, 0, 1, 0, 'ACTIVE', '风力发电系统发电量，低碳排放', '', '2026-07-17 23:25:41.861882', '', '2026-07-17 23:25:41.861882');
INSERT INTO `energy_type` VALUES (17, '17', '生物质能', 't', 2, 1, 1, 1, 0, 'ACTIVE', '生物质颗粒或秸秆，低碳排放', '', '2026-07-17 23:25:41.861882', '', '2026-07-17 23:25:41.861882');
INSERT INTO `energy_type` VALUES (18, '18', '其他可再生能源', 'MJ', 2, 0, 0, 0, 0, 'ACTIVE', '其他可再生能源类型，具体参数待定', '', '2026-07-17 23:25:41.861882', '', '2026-07-17 23:25:41.861882');
INSERT INTO `energy_type` VALUES (19, '19', '其他能源', 'MJ', 2, 0, 0, 0, 0, 'ACTIVE', '其他特殊能源类型', '', '2026-07-17 23:25:41.861882', '', '2026-07-17 23:25:41.861882');

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `form_col_num` int NULL DEFAULT 1 COMMENT '表单布局（单列 双列 三列）',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 191 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES (143, 'energy_meter_data_monthly', '逻辑计量点月级统计数据', NULL, NULL, 'EnergyMeterDataMonthly', 'crud', 'element-plus', 'com.ruoyi.energy', 'energy', 'energyMeterDataMonthly', '逻辑计量点月级统计数据', 'ruoyi', 1, '0', '/', '{\"genView\":\"1\",\"parentMenuId\":2176}', 'admin', '2026-07-22 01:40:54', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (144, 'energy_meter_data_yearly', '逻辑计量点年级统计数据', NULL, NULL, 'EnergyMeterDataYearly', 'crud', 'element-plus', 'com.ruoyi.energy', 'energy', 'energyMeterDataYearly', '逻辑计量点年级统计数据', 'ruoyi', 1, '0', '/', '{\"genView\":\"1\",\"parentMenuId\":2176}', 'admin', '2026-07-22 01:40:54', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (151, 'energy_area', '能源空间区域树；用于区域统计及面积、人数分摊', '', '', 'EnergyArea', 'tree', 'element-plus', 'com.ruoyi.energy', 'energy', 'energyArea', '能源空间区域树；用于区域统计及面积、人数分摊', 'ruoyi', 1, '0', '/', '{\"genView\":\"1\",\"treeCode\":\"id\",\"treeName\":\"area_name\",\"treeParentCode\":\"parent_area_id\",\"parentMenuId\":2176}', 'admin', '2026-07-22 01:41:02', '', '2026-07-24 18:27:49', NULL);
INSERT INTO `gen_table` VALUES (159, 'energy_branch_dimension_binding', '能源支路到区域及能源分项的唯一权威归属配置', NULL, NULL, 'EnergyBranchDimensionBinding', 'crud', 'element-plus', 'com.ruoyi.energy', 'energy', 'energyBranchDimBinding', '能源支路到区域及能源分项的唯一权威归属配置', 'ruoyi', 1, '0', '/', '{\"genView\":\"1\",\"parentMenuId\":2176}', 'admin', '2026-07-22 01:41:02', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (160, 'energy_branch_line', '能源支路主数据；parent_id维护输配拓扑，区域和分项归属统一由energy_branch_dimension_binding维护', '', '', 'EnergyBranchLine', 'tree', 'element-plus', 'com.ruoyi.energy', 'energy', 'energyBranchLine', '能源支路主数据；parent_id维护输配拓扑，区域和分项归属统一由energy_branch_dimension_binding维护', 'ruoyi', 1, '0', '/', '{\"genView\":\"1\",\"treeCode\":\"id\",\"treeName\":\"name\",\"treeParentCode\":\"parent_id\",\"parentMenuId\":2176}', 'admin', '2026-07-22 01:41:02', '', '2026-07-24 18:28:13', NULL);
INSERT INTO `gen_table` VALUES (171, 'energy_meter', '能源逻辑表计主数据；不直接保存设备属性通道和业务归属', NULL, NULL, 'EnergyMeter', 'crud', 'element-plus', 'com.ruoyi.energy', 'energy', 'energyMeter', '能源逻辑计主数据；不直接保存设备属性通道和业务归属', 'ruoyi', 1, '0', '/', '{\"genView\":\"1\",\"parentMenuId\":2176}', 'admin', '2026-07-22 01:41:02', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (172, 'energy_meter_branch_binding', '逻辑表计与能源支路的版本化有效期绑定', NULL, NULL, 'EnergyMeterBranchBinding', 'crud', 'element-plus', 'com.ruoyi.energy', 'energy', 'energyMeterBranchBinding', '逻辑计与能源支路的版本化有效期绑定', 'ruoyi', 1, '0', '/', '{\"genView\":\"1\",\"parentMenuId\":2176}', 'admin', '2026-07-22 01:41:02', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (173, 'energy_meter_channel', '逻辑表计的设备历史采集通道及有效期配置', NULL, NULL, 'EnergyMeterChannel', 'crud', 'element-plus', 'com.ruoyi.energy', 'energy', 'energyMeterChannel', '逻辑计的设备历史采集通道及有效期配置', 'ruoyi', 1, '0', '/', '{\"genView\":\"1\",\"parentMenuId\":2176}', 'admin', '2026-07-22 01:41:02', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (174, 'energy_meter_data_daily', '逻辑计量点日级统计数据', NULL, NULL, 'EnergyMeterDataDaily', 'crud', 'element-plus', 'com.ruoyi.energy', 'energy', 'energyMeterDataDaily', '逻辑计量点日级统计数据', 'ruoyi', 1, '0', '/', '{\"genView\":\"1\",\"parentMenuId\":2176}', 'admin', '2026-07-22 01:41:02', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (175, 'energy_meter_data_hourly', '逻辑计量点小时级统计数据', NULL, NULL, 'EnergyMeterDataHourly', 'crud', 'element-plus', 'com.ruoyi.energy', 'energy', 'energyMeterDataHourly', '逻辑计量点小时级统计数据', 'ruoyi', 1, '0', '/', '{\"genView\":\"1\",\"parentMenuId\":2176}', 'admin', '2026-07-22 01:41:02', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (176, 'energy_meter_data_min', '逻辑计量点分钟级统计数据；record_time为统计周期开始时间', NULL, NULL, 'EnergyMeterDataMin', 'crud', 'element-plus', 'com.ruoyi.energy', 'energy', 'energyMeterDataMin', '逻辑计量点分钟级统计数据；record_time为统计周期开始时间', 'ruoyi', 1, '0', '/', '{\"genView\":\"1\",\"parentMenuId\":2176}', 'admin', '2026-07-22 01:41:02', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (185, 'energy_sub_item', '能源分项分类树；描述不同能源类型的使用用途', '', '', 'EnergySubItem', 'tree', 'element-plus', 'com.ruoyi.energy', 'energy', 'energySubItem', '能源分项分类树；描述不同能源类型的使用用途', 'ruoyi', 1, '0', '/', '{\"genView\":\"1\",\"treeCode\":\"id\",\"treeName\":\"name\",\"treeParentCode\":\"parent_id\",\"parentMenuId\":2176}', 'admin', '2026-07-22 01:41:03', '', '2026-07-28 22:36:40', NULL);
INSERT INTO `gen_table` VALUES (188, 'energy_type', '能源类型字典；定义能源介质、标准用量单位及默认核算属性', NULL, NULL, 'EnergyType', 'crud', 'element-plus', 'com.ruoyi.energy', 'energy', 'energyType', '能源类型字典', 'ruoyi', 2, '0', '/', '{\"genView\":\"1\",\"parentMenuId\":2176}', 'admin', '2026-07-22 01:41:03', '', '2026-07-22 02:07:52', NULL);
INSERT INTO `gen_table` VALUES (190, 'device_group', '设备分组', '', '', 'DeviceGroup', 'tree', 'element-plus', 'com.ruoyi.iot', 'iot', 'deviceGroup', '设备分组', 'ruoyi', 1, '0', '/', '{\"genView\":\"1\",\"treeCode\":\"group_id\",\"treeName\":\"group_name\",\"treeParentCode\":\"parent_id\",\"parentMenuId\":0}', 'admin', '2026-07-24 19:48:43', '', '2026-07-24 19:49:33', NULL);

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3267 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------

-- ----------------------------
-- Table structure for message_template
-- ----------------------------
DROP TABLE IF EXISTS `message_template`;
CREATE TABLE `message_template`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '标题',
  `audit_status` tinyint NOT NULL DEFAULT 0 COMMENT '当前消息审核状态： 10.待审核 20.审核成功 30.被拒绝',
  `flow_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '工单ID',
  `msg_status` tinyint NOT NULL DEFAULT 0 COMMENT '当前消息状态：10.新建 20.停用 30.启用 40.等待发送 50.发送中 60.发送成功 70.发送失败',
  `cron_task_id` bigint NULL DEFAULT NULL COMMENT '定时任务Id (xxl-job-admin返回)',
  `cron_crowd_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '定时发送人群的文件路径',
  `expect_push_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '期望发送时间：0:立即发送 定时任务以及周期任务:cron表达式',
  `id_type` tinyint NOT NULL DEFAULT 0 COMMENT '消息的发送ID类型：10. userId 20.did 30.手机号 40.openId 50.email 60.企业微信userId',
  `send_channel` int NOT NULL DEFAULT 0 COMMENT '消息发送渠道：10.IM 20.Push 30.短信 40.Email 50.公众号 60.小程序 70.企业微信 80.钉钉机器人 90.钉钉工作通知 100.企业微信机器人 110.飞书机器人 110. 飞书应用消息 ',
  `template_type` tinyint NOT NULL DEFAULT 0 COMMENT '10.运营类 20.技术类接口调用',
  `msg_type` tinyint NOT NULL DEFAULT 0 COMMENT '10.通知类消息 20.营销类消息 30.验证码类消息',
  `shield_type` tinyint NOT NULL DEFAULT 0 COMMENT '10.夜间不屏蔽 20.夜间屏蔽 30.夜间屏蔽(次日早上9点发送)',
  `msg_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '消息内容 占位符用{$var}表示',
  `send_account` int NOT NULL DEFAULT 0 COMMENT '发送账号 一个渠道下可存在多个账号',
  `creator` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '创建者',
  `updator` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '更新者',
  `auditor` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '审核人',
  `team` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '业务方团队',
  `proposer` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '业务方',
  `is_deleted` tinyint NOT NULL DEFAULT 0 COMMENT '是否删除：0.不删除 1.删除',
  `created` int NOT NULL DEFAULT 0 COMMENT '创建时间',
  `updated` int NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_channel`(`send_channel` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '消息模板信息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of message_template
-- ----------------------------

-- ----------------------------
-- Table structure for product_categories
-- ----------------------------
DROP TABLE IF EXISTS `product_categories`;
CREATE TABLE `product_categories`  (
  `category_id` bigint NOT NULL AUTO_INCREMENT COMMENT '产品类型id',
  `parent_id` bigint NULL DEFAULT NULL COMMENT '父类id',
  `ancestors` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '祖级列表',
  `category_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品类型名称',
  `order_num` int NULL DEFAULT NULL COMMENT '显示顺序',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品类型说明',
  `status` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`category_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 110 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of product_categories
-- ----------------------------
INSERT INTO `product_categories` VALUES (100, 0, '0', '智慧物联', 0, '', '0', '0', 'admin', '2025-02-10 10:28:40', '', NULL);
INSERT INTO `product_categories` VALUES (101, 100, '0,100', '智能家具', 1, '', '0', '0', 'admin', '2025-02-10 10:28:40', '', NULL);
INSERT INTO `product_categories` VALUES (102, 100, '0,100', '工业设备', 2, '', '0', '0', 'admin', '2025-02-10 10:28:40', '', NULL);
INSERT INTO `product_categories` VALUES (103, 100, '0,100', '农业监控', 3, NULL, '0', '0', '', '2025-03-05 20:34:14', '', NULL);
INSERT INTO `product_categories` VALUES (104, 101, '0,100,101', '暖通空调', 1, NULL, '0', '0', '', '2025-03-06 11:09:52', 'admin', '2025-03-06 14:52:30');
INSERT INTO `product_categories` VALUES (105, 101, '0,100,101', '智能照明', 2, NULL, '0', '0', '', '2025-03-06 11:10:04', 'admin', '2025-03-06 14:52:36');
INSERT INTO `product_categories` VALUES (106, 100, '0,100', '轨道交通', 4, NULL, '0', '0', 'admin', '2025-03-06 14:52:54', '', NULL);
INSERT INTO `product_categories` VALUES (107, 100, '0,100', '智慧城市', 5, NULL, '0', '0', 'admin', '2025-03-06 14:53:20', '', NULL);
INSERT INTO `product_categories` VALUES (108, NULL, '0', 'BMS楼宇自控', 10, '暖通空调、照明及楼宇机电设备', '0', '0', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_categories` VALUES (109, NULL, '0', 'EMS能源管理', 20, '电、水、热及可再生能源计量与变流设备', '0', '0', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');

-- ----------------------------
-- Table structure for product_tag
-- ----------------------------
DROP TABLE IF EXISTS `product_tag`;
CREATE TABLE `product_tag`  (
  `product_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '产品ID',
  `tag_id` bigint NOT NULL COMMENT '标签id',
  PRIMARY KEY (`product_id`, `tag_id`) USING BTREE,
  KEY `idx_product_tag_tag_id` (`tag_id`, `product_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '产品标签' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of product_tag
-- ----------------------------

-- ----------------------------
-- Table structure for product_templates
-- ----------------------------
DROP TABLE IF EXISTS `product_templates`;
CREATE TABLE `product_templates`  (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `product_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品Id',
  `classify` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '模型归类：property，function，event',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '名称',
  `telemetry_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标识',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '属性说明',
  `type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '数据类型',
  `operationTpye` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '读写类型：r读，w写，p上报',
  `define` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '数据定义',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '产品物模型' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of product_templates
-- ----------------------------
INSERT INTO `product_templates` VALUES ('pt-bms-ahu-fault-alarm', 'bms-ahu', 'property', '故障告警', 'fault_alarm', 'AHU故障告警', 'boolean', 'r', '{\"id\":\"fault_alarm\",\"name\":\"故障告警\",\"description\":\"AHU故障告警\",\"required\":false,\"valueType\":{\"type\":\"boolean\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-ahu-return-air-temp', 'bms-ahu', 'property', '回风温度', 'return_air_temp', '回风温度，℃', 'float', 'r', '{\"id\":\"return_air_temp\",\"name\":\"回风温度\",\"description\":\"回风温度\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"℃\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-ahu-run-status', 'bms-ahu', 'property', '运行状态', 'run_status', 'AHU是否运行', 'boolean', 'r', '{\"id\":\"run_status\",\"name\":\"运行状态\",\"description\":\"AHU是否运行\",\"required\":false,\"valueType\":{\"type\":\"boolean\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-ahu-supply-air-temp', 'bms-ahu', 'property', '送风温度', 'supply_air_temp', '送风温度，℃', 'float', 'r', '{\"id\":\"supply_air_temp\",\"name\":\"送风温度\",\"description\":\"送风温度\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"℃\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-ahu-supply-fan-speed', 'bms-ahu', 'property', '送风机频率', 'supply_fan_speed', '送风机运行频率，Hz', 'float', 'r', '{\"id\":\"supply_fan_speed\",\"name\":\"送风机频率\",\"description\":\"送风机运行频率\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"Hz\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-ahu-temp-setpoint', 'bms-ahu', 'property', '送风温度设定', 'temp_setpoint', '送风温度设定值，℃', 'float', 'w', '{\"id\":\"temp_setpoint\",\"name\":\"送风温度设定\",\"description\":\"送风温度设定值\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"℃\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-ahu-valve-output', 'bms-ahu', 'property', '水阀开度', 'valve_output', '冷冻水阀开度，%', 'float', 'w', '{\"id\":\"valve_output\",\"name\":\"水阀开度\",\"description\":\"冷冻水阀开度\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"%\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-chiller-energy-total', 'bms-chiller', 'property', '累计电量', 'energy_total', '机组累计电能，kWh', 'double', 'r', '{\"id\":\"energy_total\",\"name\":\"累计电量\",\"description\":\"机组累计电能\",\"required\":false,\"valueType\":{\"type\":\"double\"},\"expands\":{\"unit\":\"kWh\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-chiller-entering-water-temp', 'bms-chiller', 'property', '回水温度', 'entering_water_temp', '冷冻水回水温度，℃', 'float', 'r', '{\"id\":\"entering_water_temp\",\"name\":\"回水温度\",\"description\":\"冷冻水回水温度\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"℃\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-chiller-fault-alarm', 'bms-chiller', 'property', '故障告警', 'fault_alarm', '机组故障告警', 'boolean', 'r', '{\"id\":\"fault_alarm\",\"name\":\"故障告警\",\"description\":\"机组故障告警\",\"required\":false,\"valueType\":{\"type\":\"boolean\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-chiller-leaving-water-temp', 'bms-chiller', 'property', '出水温度', 'leaving_water_temp', '冷冻水出水温度，℃', 'float', 'r', '{\"id\":\"leaving_water_temp\",\"name\":\"出水温度\",\"description\":\"冷冻水出水温度\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"℃\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-chiller-outlet-pressure', 'bms-chiller', 'property', '出水压力', 'outlet_pressure', '冷冻水出水压力，kPa', 'float', 'r', '{\"id\":\"outlet_pressure\",\"name\":\"出水压力\",\"description\":\"冷冻水出水压力\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"kPa\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-chiller-power', 'bms-chiller', 'property', '实时功率', 'power', '机组实时有功功率，kW', 'float', 'r', '{\"id\":\"power\",\"name\":\"实时功率\",\"description\":\"机组实时有功功率\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"kW\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-chiller-run-status', 'bms-chiller', 'property', '运行状态', 'run_status', '机组是否运行', 'boolean', 'r', '{\"id\":\"run_status\",\"name\":\"运行状态\",\"description\":\"机组是否运行\",\"required\":false,\"valueType\":{\"type\":\"boolean\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-chiller-setpoint-temp', 'bms-chiller', 'property', '出水温度设定', 'setpoint_temp', '冷冻水出水温度设定值，℃', 'float', 'w', '{\"id\":\"setpoint_temp\",\"name\":\"出水温度设定\",\"description\":\"冷冻水出水温度设定值\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"℃\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-cooling-tower-entering-water-temp', 'bms-cooling-tower', 'property', '进水温度', 'entering_water_temp', '冷却水进水温度，℃', 'float', 'r', '{\"id\":\"entering_water_temp\",\"name\":\"进水温度\",\"description\":\"冷却水进水温度\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"℃\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-cooling-tower-fan-speed', 'bms-cooling-tower', 'property', '风机频率', 'fan_speed', '冷却塔风机频率，Hz', 'float', 'r', '{\"id\":\"fan_speed\",\"name\":\"风机频率\",\"description\":\"冷却塔风机频率\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"Hz\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-cooling-tower-fault-alarm', 'bms-cooling-tower', 'property', '故障告警', 'fault_alarm', '冷却塔故障告警', 'boolean', 'r', '{\"id\":\"fault_alarm\",\"name\":\"故障告警\",\"description\":\"冷却塔故障告警\",\"required\":false,\"valueType\":{\"type\":\"boolean\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-cooling-tower-leaving-water-temp', 'bms-cooling-tower', 'property', '出水温度', 'leaving_water_temp', '冷却水出水温度，℃', 'float', 'r', '{\"id\":\"leaving_water_temp\",\"name\":\"出水温度\",\"description\":\"冷却水出水温度\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"℃\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-cooling-tower-power', 'bms-cooling-tower', 'property', '实时功率', 'power', '冷却塔实时功率，kW', 'float', 'r', '{\"id\":\"power\",\"name\":\"实时功率\",\"description\":\"冷却塔实时功率\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"kW\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-cooling-tower-run-status', 'bms-cooling-tower', 'property', '运行状态', 'run_status', '冷却塔是否运行', 'boolean', 'r', '{\"id\":\"run_status\",\"name\":\"运行状态\",\"description\":\"冷却塔是否运行\",\"required\":false,\"valueType\":{\"type\":\"boolean\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-fcu-fan-speed', 'bms-fcu', 'property', '风速档位', 'fan_speed', '风机档位，0-3', 'int', 'w', '{\"id\":\"fan_speed\",\"name\":\"风速档位\",\"description\":\"风机档位，0-3\",\"required\":false,\"valueType\":{\"type\":\"int\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-fcu-fault-alarm', 'bms-fcu', 'property', '故障告警', 'fault_alarm', 'FCU故障告警', 'boolean', 'r', '{\"id\":\"fault_alarm\",\"name\":\"故障告警\",\"description\":\"FCU故障告警\",\"required\":false,\"valueType\":{\"type\":\"boolean\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-fcu-room-temp', 'bms-fcu', 'property', '房间温度', 'room_temp', '房间温度，℃', 'float', 'r', '{\"id\":\"room_temp\",\"name\":\"房间温度\",\"description\":\"房间温度\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"℃\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-fcu-run-status', 'bms-fcu', 'property', '运行状态', 'run_status', 'FCU是否运行', 'boolean', 'r', '{\"id\":\"run_status\",\"name\":\"运行状态\",\"description\":\"FCU是否运行\",\"required\":false,\"valueType\":{\"type\":\"boolean\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-fcu-setpoint-temp', 'bms-fcu', 'property', '温度设定', 'setpoint_temp', '房间温度设定值，℃', 'float', 'w', '{\"id\":\"setpoint_temp\",\"name\":\"温度设定\",\"description\":\"房间温度设定值\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"℃\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-lighting-dimming', 'bms-lighting-controller', 'property', '调光值', 'dimming', '调光百分比，0-100%', 'int', 'w', '{\"id\":\"dimming\",\"name\":\"调光值\",\"description\":\"调光百分比，0-100\",\"required\":false,\"valueType\":{\"type\":\"int\"},\"expands\":{\"unit\":\"%\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-lighting-energy-total', 'bms-lighting-controller', 'property', '累计电量', 'energy_total', '照明累计电能，kWh', 'double', 'r', '{\"id\":\"energy_total\",\"name\":\"累计电量\",\"description\":\"照明累计电能\",\"required\":false,\"valueType\":{\"type\":\"double\"},\"expands\":{\"unit\":\"kWh\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-lighting-fault-alarm', 'bms-lighting-controller', 'property', '故障告警', 'fault_alarm', '照明控制器故障告警', 'boolean', 'r', '{\"id\":\"fault_alarm\",\"name\":\"故障告警\",\"description\":\"照明控制器故障告警\",\"required\":false,\"valueType\":{\"type\":\"boolean\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-lighting-on-status', 'bms-lighting-controller', 'property', '开关状态', 'on_status', '照明回路开关状态', 'boolean', 'r', '{\"id\":\"on_status\",\"name\":\"开关状态\",\"description\":\"照明回路开关状态\",\"required\":false,\"valueType\":{\"type\":\"boolean\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-lighting-power', 'bms-lighting-controller', 'property', '实时功率', 'power', '照明实时功率，kW', 'float', 'r', '{\"id\":\"power\",\"name\":\"实时功率\",\"description\":\"照明实时功率\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"kW\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-pump-fault-alarm', 'bms-pump', 'property', '故障告警', 'fault_alarm', '水泵故障告警', 'boolean', 'r', '{\"id\":\"fault_alarm\",\"name\":\"故障告警\",\"description\":\"水泵故障告警\",\"required\":false,\"valueType\":{\"type\":\"boolean\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-pump-flow-rate', 'bms-pump', 'property', '流量', 'flow_rate', '水泵流量，m³/h', 'float', 'r', '{\"id\":\"flow_rate\",\"name\":\"流量\",\"description\":\"水泵流量\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"m³/h\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-pump-frequency', 'bms-pump', 'property', '运行频率', 'frequency', '水泵运行频率，Hz', 'float', 'r', '{\"id\":\"frequency\",\"name\":\"运行频率\",\"description\":\"水泵运行频率\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"Hz\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-pump-inlet-pressure', 'bms-pump', 'property', '入口压力', 'inlet_pressure', '水泵入口压力，kPa', 'float', 'r', '{\"id\":\"inlet_pressure\",\"name\":\"入口压力\",\"description\":\"水泵入口压力\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"kPa\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-pump-outlet-pressure', 'bms-pump', 'property', '出口压力', 'outlet_pressure', '水泵出口压力，kPa', 'float', 'r', '{\"id\":\"outlet_pressure\",\"name\":\"出口压力\",\"description\":\"水泵出口压力\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"kPa\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-pump-power', 'bms-pump', 'property', '实时功率', 'power', '水泵实时功率，kW', 'float', 'r', '{\"id\":\"power\",\"name\":\"实时功率\",\"description\":\"水泵实时功率\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"kW\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-pump-run-status', 'bms-pump', 'property', '运行状态', 'run_status', '水泵是否运行', 'boolean', 'r', '{\"id\":\"run_status\",\"name\":\"运行状态\",\"description\":\"水泵是否运行\",\"required\":false,\"valueType\":{\"type\":\"boolean\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-room-sensor-co2', 'bms-room-sensor', 'property', '二氧化碳', 'co2', 'CO2浓度，ppm', 'int', 'r', '{\"id\":\"co2\",\"name\":\"二氧化碳\",\"description\":\"CO2浓度\",\"required\":false,\"valueType\":{\"type\":\"int\"},\"expands\":{\"unit\":\"ppm\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-room-sensor-humidity', 'bms-room-sensor', 'property', '相对湿度', 'humidity', '相对湿度，%RH', 'float', 'r', '{\"id\":\"humidity\",\"name\":\"相对湿度\",\"description\":\"相对湿度\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"%RH\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-room-sensor-pm25', 'bms-room-sensor', 'property', 'PM2.5', 'pm25', 'PM2.5浓度，μg/m³', 'int', 'r', '{\"id\":\"pm25\",\"name\":\"PM2.5\",\"description\":\"PM2.5浓度\",\"required\":false,\"valueType\":{\"type\":\"int\"},\"expands\":{\"unit\":\"μg/m³\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-bms-room-sensor-room-temp', 'bms-room-sensor', 'property', '室内温度', 'room_temp', '室内温度，℃', 'float', 'r', '{\"id\":\"room_temp\",\"name\":\"室内温度\",\"description\":\"室内温度\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"℃\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-ems-electric-active-power', 'ems-electric-meter', 'property', '有功功率', 'active_power', '实时有功功率，kW', 'float', 'r', '{\"id\":\"active_power\",\"name\":\"有功功率\",\"description\":\"实时有功功率\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"kW\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-ems-electric-current', 'ems-electric-meter', 'property', '电流', 'current', '回路电流，A', 'float', 'r', '{\"id\":\"current\",\"name\":\"电流\",\"description\":\"回路电流\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"A\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-ems-electric-forward-energy', 'ems-electric-meter', 'property', '正向有功电能', 'forward_energy', '正向累计有功电能，kWh', 'double', 'r', '{\"id\":\"forward_energy\",\"name\":\"正向有功电能\",\"description\":\"正向累计有功电能\",\"required\":false,\"valueType\":{\"type\":\"double\"},\"expands\":{\"unit\":\"kWh\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-ems-electric-frequency', 'ems-electric-meter', 'property', '频率', 'frequency', '交流频率，Hz', 'float', 'r', '{\"id\":\"frequency\",\"name\":\"频率\",\"description\":\"交流频率\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"Hz\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-ems-electric-power-factor', 'ems-electric-meter', 'property', '功率因数', 'power_factor', '功率因数', 'float', 'r', '{\"id\":\"power_factor\",\"name\":\"功率因数\",\"description\":\"功率因数\",\"required\":false,\"valueType\":{\"type\":\"float\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-ems-electric-reverse-energy', 'ems-electric-meter', 'property', '反向有功电能', 'reverse_energy', '反向累计有功电能，kWh', 'double', 'r', '{\"id\":\"reverse_energy\",\"name\":\"反向有功电能\",\"description\":\"反向累计有功电能\",\"required\":false,\"valueType\":{\"type\":\"double\"},\"expands\":{\"unit\":\"kWh\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-ems-electric-voltage', 'ems-electric-meter', 'property', '电压', 'voltage', '线电压/相电压，V', 'float', 'r', '{\"id\":\"voltage\",\"name\":\"电压\",\"description\":\"线电压或相电压\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"V\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-ems-heat-alarm', 'ems-heat-meter', 'property', '故障告警', 'alarm', '热量表故障告警', 'boolean', 'r', '{\"id\":\"alarm\",\"name\":\"故障告警\",\"description\":\"热量表故障告警\",\"required\":false,\"valueType\":{\"type\":\"boolean\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-ems-heat-flow-rate', 'ems-heat-meter', 'property', '流量', 'flow_rate', '热水流量，m³/h', 'float', 'r', '{\"id\":\"flow_rate\",\"name\":\"流量\",\"description\":\"热水流量\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"m³/h\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-ems-heat-power', 'ems-heat-meter', 'property', '热功率', 'heat_power', '瞬时热功率，kW', 'float', 'r', '{\"id\":\"heat_power\",\"name\":\"热功率\",\"description\":\"瞬时热功率\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"kW\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-ems-heat-return-temp', 'ems-heat-meter', 'property', '回水温度', 'return_temp', '回水温度，℃', 'float', 'r', '{\"id\":\"return_temp\",\"name\":\"回水温度\",\"description\":\"回水温度\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"℃\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-ems-heat-supply-temp', 'ems-heat-meter', 'property', '供水温度', 'supply_temp', '供水温度，℃', 'float', 'r', '{\"id\":\"supply_temp\",\"name\":\"供水温度\",\"description\":\"供水温度\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"℃\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-ems-heat-total', 'ems-heat-meter', 'property', '累计热量', 'heat_total', '累计热量，GJ', 'double', 'r', '{\"id\":\"heat_total\",\"name\":\"累计热量\",\"description\":\"累计热量\",\"required\":false,\"valueType\":{\"type\":\"double\"},\"expands\":{\"unit\":\"GJ\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-ems-pv-ac-power', 'ems-pv-inverter', 'property', '交流功率', 'ac_power', '逆变器交流侧功率，kW', 'float', 'r', '{\"id\":\"ac_power\",\"name\":\"交流功率\",\"description\":\"逆变器交流侧功率\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"kW\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-ems-pv-daily-energy', 'ems-pv-inverter', 'property', '日发电量', 'daily_energy', '当日发电量，kWh', 'double', 'r', '{\"id\":\"daily_energy\",\"name\":\"日发电量\",\"description\":\"当日发电量\",\"required\":false,\"valueType\":{\"type\":\"double\"},\"expands\":{\"unit\":\"kWh\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-ems-pv-dc-current', 'ems-pv-inverter', 'property', '直流电流', 'dc_current', '光伏侧直流电流，A', 'float', 'r', '{\"id\":\"dc_current\",\"name\":\"直流电流\",\"description\":\"光伏侧直流电流\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"A\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-ems-pv-dc-voltage', 'ems-pv-inverter', 'property', '直流电压', 'dc_voltage', '光伏侧直流电压，V', 'float', 'r', '{\"id\":\"dc_voltage\",\"name\":\"直流电压\",\"description\":\"光伏侧直流电压\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"V\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-ems-pv-fault-alarm', 'ems-pv-inverter', 'property', '故障告警', 'fault_alarm', '逆变器故障告警', 'boolean', 'r', '{\"id\":\"fault_alarm\",\"name\":\"故障告警\",\"description\":\"逆变器故障告警\",\"required\":false,\"valueType\":{\"type\":\"boolean\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-ems-pv-grid-frequency', 'ems-pv-inverter', 'property', '并网频率', 'grid_frequency', '并网交流频率，Hz', 'float', 'r', '{\"id\":\"grid_frequency\",\"name\":\"并网频率\",\"description\":\"并网交流频率\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"Hz\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-ems-pv-run-status', 'ems-pv-inverter', 'property', '运行状态', 'run_status', '逆变器是否并网运行', 'boolean', 'r', '{\"id\":\"run_status\",\"name\":\"运行状态\",\"description\":\"逆变器是否并网运行\",\"required\":false,\"valueType\":{\"type\":\"boolean\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-ems-pv-total-energy', 'ems-pv-inverter', 'property', '累计发电量', 'total_energy', '累计发电量，kWh', 'double', 'r', '{\"id\":\"total_energy\",\"name\":\"累计发电量\",\"description\":\"累计发电量\",\"required\":false,\"valueType\":{\"type\":\"double\"},\"expands\":{\"unit\":\"kWh\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-ems-water-flow-rate', 'ems-water-meter', 'property', '瞬时流量', 'flow_rate', '瞬时流量，m³/h', 'float', 'r', '{\"id\":\"flow_rate\",\"name\":\"瞬时流量\",\"description\":\"瞬时流量\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"m³/h\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-ems-water-leak-alarm', 'ems-water-meter', 'property', '漏水告警', 'leak_alarm', '漏水或异常用水告警', 'boolean', 'r', '{\"id\":\"leak_alarm\",\"name\":\"漏水告警\",\"description\":\"漏水或异常用水告警\",\"required\":false,\"valueType\":{\"type\":\"boolean\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-ems-water-pressure', 'ems-water-meter', 'property', '管网压力', 'pressure', '管网压力，kPa', 'float', 'r', '{\"id\":\"pressure\",\"name\":\"管网压力\",\"description\":\"管网压力\",\"required\":false,\"valueType\":{\"type\":\"float\"},\"expands\":{\"unit\":\"kPa\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('pt-ems-water-total-flow', 'ems-water-meter', 'property', '累计流量', 'total_flow', '累计用水量，m³', 'double', 'r', '{\"id\":\"total_flow\",\"name\":\"累计流量\",\"description\":\"累计用水量\",\"required\":false,\"valueType\":{\"type\":\"double\"},\"expands\":{\"unit\":\"m³\"}}', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `product_templates` VALUES ('test.qwewq', 'test', 'property', 'edwqe', 'qwewq', 'qweqwe', 'int', 'rw', '{\"valueType\":{\"type\":\"int\",\"unit\":\"m\",\"min\":null,\"max\":null}}', '', '2025-06-22 23:38:23', '', NULL);

-- ----------------------------
-- Table structure for products
-- ----------------------------
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products`  (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品名称',
  `photo_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片地址',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品说明',
  `product_category_id` bigint NULL DEFAULT NULL COMMENT '产品类型Id',
  `protocol_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '传输协议id',
  `transport_codec_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '消息解析器',
  `storage_interval` bigint NULL DEFAULT NULL COMMENT '数据存储间隔（ms）',
  `data_expiration` bigint NULL DEFAULT NULL COMMENT '数据过期时间（ms）',
  `device_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '设备类型：direct(直连)、gateway(网关)、gatewayS(网关子设备)',
  `status` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '启停状态：enable，disable',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_products_product_category`(`product_category_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '产品信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of products
-- ----------------------------
INSERT INTO `products` VALUES ('bms-ahu', '空气处理机组', NULL, 'AHU送回风温度、风机及阀门控制点位', 108, 'modbus', NULL, 5000, 31536000000, 'gatewayS', 'enable', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `products` VALUES ('bms-chiller', '冷水机组', NULL, '冷水机组运行状态、温度、压力、功率及设定值', 108, 'modbus', NULL, 5000, 31536000000, 'gatewayS', 'enable', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `products` VALUES ('bms-cooling-tower', '冷却塔', NULL, '冷却塔运行、进出水温度、风机速度及功率', 108, 'modbus', NULL, 5000, 31536000000, 'gatewayS', 'enable', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `products` VALUES ('bms-fcu', '风机盘管', NULL, 'FCU运行、房间温度、风速及温度设定', 108, 'modbus', NULL, 5000, 31536000000, 'gatewayS', 'enable', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `products` VALUES ('bms-lighting-controller', '照明控制器', NULL, '照明开关、调光、功率及用电量', 108, 'modbus', NULL, 5000, 31536000000, 'gatewayS', 'enable', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `products` VALUES ('bms-pump', '水泵', NULL, '冷冻水泵/冷却水泵频率、压力、流量及功率', 108, 'modbus', NULL, 5000, 31536000000, 'gatewayS', 'enable', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `products` VALUES ('bms-room-sensor', '室内环境传感器', NULL, '室内温湿度、CO2及PM2.5环境数据', 108, 'modbus', NULL, 10000, 31536000000, 'gatewayS', 'enable', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `products` VALUES ('ems-electric-meter', '智能电表', NULL, '电压、电流、有功功率、功率因数、频率及电能', 109, 'modbus', NULL, 15000, 63072000000, 'gatewayS', 'enable', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `products` VALUES ('ems-heat-meter', '热量表', NULL, '供回水温度、流量、热功率及累计热量', 109, 'modbus', NULL, 15000, 63072000000, 'gatewayS', 'enable', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `products` VALUES ('ems-pv-inverter', '光伏逆变器', NULL, '直流侧、交流侧、发电量及并网运行状态', 109, 'modbus', NULL, 15000, 63072000000, 'gatewayS', 'enable', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');
INSERT INTO `products` VALUES ('ems-water-meter', '智能水表', NULL, '瞬时流量、压力、累计流量及漏水告警', 109, 'modbus', NULL, 60000, 63072000000, 'gatewayS', 'enable', 'system', '2026-09-04 09:33:17', 'system', '2026-09-04 09:33:17');

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Blob类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '日历信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Cron类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '已触发的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '任务详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '存储的悲观锁信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '暂停的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '调度器状态表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name` ASC, `job_name` ASC, `job_group` ASC) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '触发器详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for report_records
-- ----------------------------
DROP TABLE IF EXISTS `report_records`;
CREATE TABLE `report_records`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `template_id` bigint NOT NULL,
  `report_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `report_period` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '报表周期',
  `start_date` date NULL DEFAULT NULL,
  `end_date` date NULL DEFAULT NULL,
  `file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件路径',
  `file_format` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件格式',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'pending' COMMENT '生成状态',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `template_id`(`template_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of report_records
-- ----------------------------

-- ----------------------------
-- Table structure for report_templates
-- ----------------------------
DROP TABLE IF EXISTS `report_templates`;
CREATE TABLE `report_templates`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `template_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `template_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '报表类型：daily/weekly/monthly/yearly',
  `template_config` json NULL COMMENT '模板配置',
  `chart_config` json NULL COMMENT '图表配置',
  `is_system` tinyint(1) NULL DEFAULT 0 COMMENT '是否系统模板',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of report_templates
-- ----------------------------

-- ----------------------------
-- Table structure for rule_scene
-- ----------------------------
DROP TABLE IF EXISTS `rule_scene`;
CREATE TABLE `rule_scene`  (
  `seq` bigint NOT NULL AUTO_INCREMENT,
  `id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '场景联动名称',
  `condition_logic` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '触发条件逻辑：AND，OR',
  `triggers` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '触发器',
  `conditions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '触发条件',
  `action_parallel` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否并行执行动作',
  `actions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '执行动作',
  `start_time` datetime NULL DEFAULT NULL COMMENT '启动时间',
  `state` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '状态',
  `options` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '扩展配置',
  `features` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '场景特性',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '说明',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`seq`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '规则场景表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of rule_scene
-- ----------------------------
INSERT INTO `rule_scene` VALUES (2, 'scene_mtjjahry_z9tm3', '123', 'AND', '[{\"triggerType\":\"DEVICE\",\"targetType\":\"DEVICE\",\"productId\":\"dimmer\",\"deviceId\":\"dimmer1\",\"groupId\":null,\"property\":\"brightness\",\"operator\":\"==\",\"value\":\"1\",\"alarm\":\"disable\",\"debounceDelay\":0,\"requiredConsecutiveMatches\":1,\"cronExpression\":\"\"}]', '[]', 'true', '[{\"actionType\":\"DEVICE_PROPERTY\",\"targetType\":\"DEVICE\",\"productId\":\"dimmer\",\"deviceId\":\"dimmer1\",\"groupId\":null,\"property\":\"brightness\",\"value\":\"123\",\"delaySeconds\":1,\"retryCount\":0,\"retryInterval\":0,\"message\":\"\"}]', NULL, 'disable', NULL, NULL, '', '', '2026-09-02 11:26:16', '', NULL);

-- ----------------------------
-- Table structure for rule_scene_log
-- ----------------------------
DROP TABLE IF EXISTS `rule_scene_log`;
CREATE TABLE `rule_scene_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `rule_scene_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '场景联动ID',
  `scene_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '场景联动名称',
  `product_id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品id',
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品名称',
  `device_id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '设备id',
  `device_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '设备名称',
  `telemetry_key` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物模型（属性）标识',
  `telemetry_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '属性名称',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '记录类型：trigger，action，time',
  `detail` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '配置详情',
  `execute_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '执行状态：success，failed，partial',
  `error_message` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '错误信息',
  `value` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '点位值：触发时点位值，动作下至的点位值',
  `happen_time` datetime NULL DEFAULT NULL COMMENT '执行时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_rule_scene_id`(`rule_scene_id` ASC) USING BTREE,
  INDEX `idx_trigger_time`(`happen_time` DESC) USING BTREE,
  INDEX `idx_rule_scene_trigger_time`(`rule_scene_id` ASC, `happen_time` DESC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '场景联动历史记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of rule_scene_log
-- ----------------------------
INSERT INTO `rule_scene_log` VALUES (10, 'scene_mrqhlbsp_ydxt5', 'test', 'dimmer', '照明控制', 'test1', 'test1', 'brightness', '亮度值', 'trigger', 'test1属性亮度值==10时触发', NULL, NULL, '10', NULL, '2026-07-29 22:53:58');
INSERT INTO `rule_scene_log` VALUES (11, 'scene_mrqhlbsp_ydxt5', 'test', 'dimmer', '照明控制', 'test1', 'test1', 'colorTemperature', '色温值', 'action', 'test1属性色温值下发为88,点位下置成功', NULL, NULL, '88', NULL, '2026-07-29 22:53:58');
INSERT INTO `rule_scene_log` VALUES (12, 'scene_mrqhlbsp_ydxt5', 'test', 'dimmer', '照明控制', 'test1', 'test1', 'brightness', '亮度值', 'trigger', 'test1属性亮度值==10时触发', NULL, NULL, '10', NULL, '2026-07-29 23:32:36');
INSERT INTO `rule_scene_log` VALUES (13, 'scene_mrqhlbsp_ydxt5', 'test', 'dimmer', '照明控制', 'test1', 'test1', 'colorTemperature', '色温值', 'action', 'test1属性色温值下发为88,点位下置成功', NULL, NULL, '88', NULL, '2026-07-29 23:32:36');
INSERT INTO `rule_scene_log` VALUES (14, 'scene_mrqhlbsp_ydxt5', 'test', 'dimmer', '照明控制', 'test1', 'test1', 'brightness', '亮度值', 'trigger', 'test1属性亮度值==10时触发', NULL, NULL, '10', NULL, '2026-08-18 22:54:58');
INSERT INTO `rule_scene_log` VALUES (15, 'scene_mrqhlbsp_ydxt5', 'test', 'dimmer', '照明控制', 'test1', 'test1', 'colorTemperature', '色温值', 'action', 'test1属性色温值下发为88,点位下置成功', NULL, NULL, '88', NULL, '2026-08-18 22:54:58');

-- ----------------------------
-- Table structure for s_alarm_rule_bind
-- ----------------------------
DROP TABLE IF EXISTS `s_alarm_rule_bind`;
CREATE TABLE `s_alarm_rule_bind`  (
  `id` bigint NOT NULL COMMENT 'id',
  `alarm_id` bigint NOT NULL COMMENT '告警ID',
  `rule_id` bigint NOT NULL COMMENT '场景规则ID',
  `branch_index` bigint NOT NULL COMMENT '规则条件分支ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_alarm_rule_aid`(`alarm_id` ASC) USING BTREE,
  INDEX `idx_alarm_rule_rid`(`rule_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '告警规则绑定信息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of s_alarm_rule_bind
-- ----------------------------

-- ----------------------------
-- Table structure for sms_record
-- ----------------------------
DROP TABLE IF EXISTS `sms_record`;
CREATE TABLE `sms_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `message_template_id` bigint NOT NULL DEFAULT 0 COMMENT '消息模板ID',
  `phone` bigint NOT NULL DEFAULT 0 COMMENT '手机号',
  `supplier_id` tinyint NOT NULL DEFAULT 0 COMMENT '发送短信渠道商的ID',
  `supplier_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '发送短信渠道商的名称',
  `msg_content` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '短信发送的内容',
  `series_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '下发批次的ID',
  `charging_num` tinyint NOT NULL DEFAULT 0 COMMENT '计费条数',
  `report_content` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '回执内容',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '短信状态： 10.发送 20.成功 30.失败',
  `send_date` int NOT NULL DEFAULT 0 COMMENT '发送日期：20211112',
  `created` int NOT NULL DEFAULT 0 COMMENT '创建时间',
  `updated` int NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_send_date`(`send_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '短信记录信息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sms_record
-- ----------------------------

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '参数配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2026-06-26 10:30:29', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2026-06-26 10:30:29', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2026-06-26 10:30:29', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2026-06-26 10:30:29', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2026-06-26 10:30:29', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2026-06-26 10:30:29', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
INSERT INTO `sys_config` VALUES (7, '用户管理-初始密码修改策略', 'sys.account.initPasswordModify', '1', 'Y', 'admin', '2026-06-26 10:30:29', '', NULL, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (8, '用户管理-账号密码更新周期', 'sys.account.passwordValidateDays', '0', 'Y', 'admin', '2026-06-26 10:30:29', '', NULL, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (9, '用户管理-密码字符范围', 'sys.account.chrtype', '0', 'Y', 'admin', '2026-06-26 10:30:29', '', NULL, '默认任意字符范围，0任意（密码可以输入任意字符），1数字（密码只能为0-9数字），2英文字母（密码只能为a-z和A-Z字母），3字母和数字（密码必须包含字母，数字）,4字母数字和特殊字符（目前支持的特殊字符包括：~!@#$%^&*()-=_+）');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 200 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '若依科技', 0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-06-26 10:30:29', '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-06-26 10:30:29', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-06-26 10:30:29', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-06-26 10:30:29', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-06-26 10:30:29', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-06-26 10:30:29', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-06-26 10:30:29', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-06-26 10:30:29', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-06-26 10:30:29', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-06-26 10:30:29', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 133 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (100, 0, '网关子设备', 'gatewayS', 'device_type', NULL, 'default', 'N', '0', 'admin', '2025-02-25 18:57:40', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (101, 1, '直连设备', 'direct', 'device_type', NULL, 'default', 'N', '0', 'admin', '2025-02-25 18:58:58', 'admin', '2025-02-25 19:02:11', NULL);
INSERT INTO `sys_dict_data` VALUES (102, 0, '启用', 'enable', 'enable_status', NULL, 'default', 'N', '0', 'admin', '2025-02-25 18:59:58', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (103, 1, '停用', 'disable', 'enable_status', NULL, 'default', 'N', '0', 'admin', '2025-02-25 19:00:19', 'admin', '2025-02-25 19:01:46', NULL);
INSERT INTO `sys_dict_data` VALUES (104, 0, '在线', 'online', 'link_status', NULL, 'default', 'N', '0', 'admin', '2025-02-25 19:01:17', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (105, 1, '离线', 'offline', 'link_status', NULL, 'default', 'N', '0', 'admin', '2025-02-25 19:01:28', 'admin', '2025-02-25 19:01:37', NULL);
INSERT INTO `sys_dict_data` VALUES (106, 0, '网关协议', 'edge', 'protocol_type', NULL, 'default', 'N', '0', 'admin', '2025-02-27 14:09:28', 'admin', '2026-08-31 13:29:18', NULL);
INSERT INTO `sys_dict_data` VALUES (107, 0, '包含设备信息的协议', 'DeviceAware', 'protocol_type', NULL, 'default', 'N', '0', 'admin', '2025-02-27 14:09:47', 'admin', '2026-08-31 13:28:16', NULL);
INSERT INTO `sys_dict_data` VALUES (108, 0, '属性', 'property', 'thing_model_type', NULL, 'default', 'N', '0', 'admin', '2025-03-10 10:43:08', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (109, 0, '功能', 'function', 'thing_model_type', NULL, 'default', 'N', '0', 'admin', '2025-03-10 10:43:14', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (110, 0, '事件', 'event', 'thing_model_type', NULL, 'default', 'N', '0', 'admin', '2025-03-10 10:43:33', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (111, 0, '只读', 'r', 'data_type', NULL, 'default', 'N', '0', 'admin', '2025-03-10 10:45:16', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (112, 1, '只写', 'w', 'data_type', NULL, 'default', 'N', '0', 'admin', '2025-03-10 10:45:25', 'admin', '2025-04-03 11:49:24', NULL);
INSERT INTO `sys_dict_data` VALUES (113, 2, '读写', 'rw', 'data_type', NULL, 'default', 'N', '0', 'admin', '2025-03-10 10:45:35', 'admin', '2025-04-03 11:49:28', NULL);
INSERT INTO `sys_dict_data` VALUES (114, 1, '整型', 'int', 'value_type', NULL, 'default', 'N', '0', 'admin', '2025-04-03 11:48:52', 'admin', '2025-04-03 11:49:08', NULL);
INSERT INTO `sys_dict_data` VALUES (115, 2, '长整型', 'long', 'value_type', NULL, 'default', 'N', '0', 'admin', '2025-04-03 11:49:04', 'admin', '2025-04-03 11:49:12', NULL);
INSERT INTO `sys_dict_data` VALUES (116, 3, '单精度浮点型', 'float', 'value_type', NULL, 'default', 'N', '0', 'admin', '2025-04-03 11:49:45', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (117, 4, '双精度浮点型', 'double', 'value_type', NULL, 'default', 'N', '0', 'admin', '2025-04-03 11:49:57', 'admin', '2025-06-22 14:41:39', NULL);
INSERT INTO `sys_dict_data` VALUES (118, 5, '布尔类型', 'boolean', 'value_type', NULL, 'default', 'N', '0', 'admin', '2025-04-03 11:50:13', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (119, 6, '字符类型', 'string', 'value_type', NULL, 'default', 'N', '0', 'admin', '2025-04-03 11:50:27', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (120, 7, '枚举类型', 'enum', 'value_type', NULL, 'default', 'N', '0', 'admin', '2025-04-03 11:50:38', 'admin', '2025-04-03 11:50:45', NULL);
INSERT INTO `sys_dict_data` VALUES (121, 8, '时间类型', 'date', 'value_type', NULL, 'default', 'N', '0', 'admin', '2025-04-03 11:51:05', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (122, 9, '密码类型', 'password', 'value_type', NULL, 'default', 'N', '0', 'admin', '2025-04-03 11:51:17', 'admin', '2025-04-03 11:51:23', NULL);
INSERT INTO `sys_dict_data` VALUES (123, 10, '文件类型', 'file', 'value_type', NULL, 'default', 'N', '0', 'admin', '2025-04-03 11:51:54', 'admin', '2025-04-03 11:51:59', NULL);
INSERT INTO `sys_dict_data` VALUES (124, 11, '数组（集合）类型', 'array', 'value_type', NULL, 'default', 'N', '0', 'admin', '2025-04-03 11:53:39', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (125, 12, '对象（结构体）类型', 'object', 'value_type', NULL, 'default', 'N', '0', 'admin', '2025-04-03 11:53:57', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (126, 13, '地理位置类型', 'geoPoint', 'value_type', NULL, 'default', 'N', '0', 'admin', '2025-04-03 11:54:11', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (127, 1, '整型', 'int', 'point_value_type', NULL, 'default', 'N', '0', 'admin', '2025-06-22 14:38:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (128, 2, '长整型', 'long', 'point_value_type', NULL, 'default', 'N', '0', 'admin', '2025-06-22 14:39:01', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (129, 3, '单精度浮点型', 'float', 'point_value_type', NULL, 'default', 'N', '0', 'admin', '2025-06-22 14:39:14', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (130, 4, '双精度浮点型', 'double', 'point_value_type', NULL, 'default', 'N', '0', 'admin', '2025-06-22 14:39:36', 'admin', '2025-06-22 14:39:48', NULL);
INSERT INTO `sys_dict_data` VALUES (131, 5, '布尔类型', 'boolean', 'point_value_type', NULL, 'default', 'N', '0', 'admin', '2025-06-22 14:58:35', 'admin', '2025-06-22 22:21:51', NULL);
INSERT INTO `sys_dict_data` VALUES (132, 6, '字符类型', 'string', 'point_value_type', NULL, 'default', 'N', '0', 'admin', '2025-06-22 14:58:47', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 108 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '登录状态列表');
INSERT INTO `sys_dict_type` VALUES (100, '设备类型', 'device_type', '0', 'admin', '2025-02-25 18:56:48', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (101, '启停状态', 'enable_status', '0', 'admin', '2025-02-25 18:59:34', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (102, '连接状态', 'link_status', '0', 'admin', '2025-02-25 19:00:57', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (103, '传输协议类型', 'protocol_type', '0', 'admin', '2025-02-27 14:00:18', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (104, '物模型类型', 'thing_model_type', '0', 'admin', '2025-03-10 10:42:06', 'admin', '2025-03-10 10:42:20', '物模型类型列表');
INSERT INTO `sys_dict_type` VALUES (105, '读写类型', 'data_type', '0', 'admin', '2025-03-10 10:45:05', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (106, '设备属性数据类型', 'value_type', '0', 'admin', '2025-04-03 11:43:51', 'admin', '2025-06-22 14:25:58', NULL);
INSERT INTO `sys_dict_type` VALUES (107, '网关点位数据类型', 'point_value_type', '0', 'admin', '2025-06-22 14:38:12', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2026-06-26 10:30:29', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '异常信息',
  `start_time` datetime NULL DEFAULT NULL COMMENT '执行开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '执行结束时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 271 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统访问记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '127.0.0.1', '内网IP', 'Chrome 149', 'Windows10', '0', '登录成功', '2026-06-26 10:37:06');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '127.0.0.1', '内网IP', 'Chrome 149', 'Windows10', '0', '登录成功', '2026-06-26 12:44:24');
INSERT INTO `sys_logininfor` VALUES (102, 'admin', '127.0.0.1', '内网IP', 'Chrome 149', 'Windows10', '0', '登录成功', '2026-06-26 14:46:32');
INSERT INTO `sys_logininfor` VALUES (103, 'admin', '127.0.0.1', '内网IP', 'Chrome 149', 'Windows10', '0', '登录成功', '2026-06-26 16:00:25');
INSERT INTO `sys_logininfor` VALUES (104, 'admin', '127.0.0.1', '内网IP', 'Chrome 149', 'Windows10', '0', '退出成功', '2026-06-26 17:14:24');
INSERT INTO `sys_logininfor` VALUES (105, 'admin', '127.0.0.1', '内网IP', 'Chrome 149', 'Windows10', '0', '登录成功', '2026-06-26 17:14:27');
INSERT INTO `sys_logininfor` VALUES (106, 'admin', '127.0.0.1', '内网IP', 'Chrome 149', 'Windows10', '0', '登录成功', '2026-06-27 14:40:15');
INSERT INTO `sys_logininfor` VALUES (107, 'admin', '127.0.0.1', '内网IP', 'Chrome 149', 'Windows10', '0', '登录成功', '2026-06-27 18:51:03');
INSERT INTO `sys_logininfor` VALUES (108, 'admin', '127.0.0.1', '内网IP', 'Chrome 149', 'Windows10', '0', '登录成功', '2026-06-28 10:11:40');
INSERT INTO `sys_logininfor` VALUES (109, 'admin', '127.0.0.1', '内网IP', 'Chrome 149', 'Windows10', '0', '登录成功', '2026-06-28 10:14:49');
INSERT INTO `sys_logininfor` VALUES (110, 'admin', '127.0.0.1', '内网IP', 'Chrome 149', 'Windows10', '0', '登录成功', '2026-06-28 11:23:53');
INSERT INTO `sys_logininfor` VALUES (111, 'admin', '127.0.0.1', '内网IP', 'Chrome 149', 'Windows10', '0', '登录成功', '2026-06-28 15:11:28');
INSERT INTO `sys_logininfor` VALUES (112, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-11 10:32:34');
INSERT INTO `sys_logininfor` VALUES (113, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-11 13:56:08');
INSERT INTO `sys_logininfor` VALUES (114, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-14 09:47:01');
INSERT INTO `sys_logininfor` VALUES (115, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-14 10:09:35');
INSERT INTO `sys_logininfor` VALUES (116, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-14 10:12:21');
INSERT INTO `sys_logininfor` VALUES (117, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-14 20:49:00');
INSERT INTO `sys_logininfor` VALUES (118, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-14 20:49:12');
INSERT INTO `sys_logininfor` VALUES (119, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-15 10:52:45');
INSERT INTO `sys_logininfor` VALUES (120, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-15 11:06:21');
INSERT INTO `sys_logininfor` VALUES (121, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-15 12:30:46');
INSERT INTO `sys_logininfor` VALUES (122, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-15 15:08:50');
INSERT INTO `sys_logininfor` VALUES (123, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-15 21:59:17');
INSERT INTO `sys_logininfor` VALUES (124, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '1', '验证码已失效', '2026-07-16 10:13:36');
INSERT INTO `sys_logininfor` VALUES (125, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-16 10:13:37');
INSERT INTO `sys_logininfor` VALUES (126, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '1', '验证码错误', '2026-07-16 11:27:32');
INSERT INTO `sys_logininfor` VALUES (127, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '1', '验证码错误', '2026-07-16 11:27:34');
INSERT INTO `sys_logininfor` VALUES (128, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-16 11:27:36');
INSERT INTO `sys_logininfor` VALUES (129, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-16 19:20:21');
INSERT INTO `sys_logininfor` VALUES (130, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '1', '验证码错误', '2026-07-18 13:46:09');
INSERT INTO `sys_logininfor` VALUES (131, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '1', '验证码错误', '2026-07-18 13:46:10');
INSERT INTO `sys_logininfor` VALUES (132, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-18 13:46:14');
INSERT INTO `sys_logininfor` VALUES (133, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-18 17:57:32');
INSERT INTO `sys_logininfor` VALUES (134, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-18 21:10:57');
INSERT INTO `sys_logininfor` VALUES (135, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-18 22:16:43');
INSERT INTO `sys_logininfor` VALUES (136, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-18 22:48:41');
INSERT INTO `sys_logininfor` VALUES (137, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-19 11:07:56');
INSERT INTO `sys_logininfor` VALUES (138, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-19 11:17:37');
INSERT INTO `sys_logininfor` VALUES (139, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-19 12:26:19');
INSERT INTO `sys_logininfor` VALUES (140, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-19 12:48:55');
INSERT INTO `sys_logininfor` VALUES (141, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-19 17:54:44');
INSERT INTO `sys_logininfor` VALUES (142, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-19 18:25:41');
INSERT INTO `sys_logininfor` VALUES (143, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-19 21:25:16');
INSERT INTO `sys_logininfor` VALUES (144, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-19 23:48:28');
INSERT INTO `sys_logininfor` VALUES (145, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-20 09:59:04');
INSERT INTO `sys_logininfor` VALUES (146, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-20 22:53:41');
INSERT INTO `sys_logininfor` VALUES (147, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-20 23:05:40');
INSERT INTO `sys_logininfor` VALUES (148, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-20 23:34:04');
INSERT INTO `sys_logininfor` VALUES (149, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-20 23:36:41');
INSERT INTO `sys_logininfor` VALUES (150, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-20 23:36:46');
INSERT INTO `sys_logininfor` VALUES (151, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-20 23:41:13');
INSERT INTO `sys_logininfor` VALUES (152, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-20 23:42:03');
INSERT INTO `sys_logininfor` VALUES (153, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-20 23:42:11');
INSERT INTO `sys_logininfor` VALUES (154, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-20 23:42:33');
INSERT INTO `sys_logininfor` VALUES (155, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-20 23:49:10');
INSERT INTO `sys_logininfor` VALUES (156, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-21 16:08:03');
INSERT INTO `sys_logininfor` VALUES (157, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-21 16:11:24');
INSERT INTO `sys_logininfor` VALUES (158, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '退出成功', '2026-07-21 16:22:09');
INSERT INTO `sys_logininfor` VALUES (159, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-21 16:22:19');
INSERT INTO `sys_logininfor` VALUES (160, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-21 16:23:27');
INSERT INTO `sys_logininfor` VALUES (161, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-21 16:29:55');
INSERT INTO `sys_logininfor` VALUES (162, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-21 16:30:33');
INSERT INTO `sys_logininfor` VALUES (163, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-21 16:49:32');
INSERT INTO `sys_logininfor` VALUES (164, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-21 16:49:39');
INSERT INTO `sys_logininfor` VALUES (165, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-21 17:27:29');
INSERT INTO `sys_logininfor` VALUES (166, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-21 17:28:23');
INSERT INTO `sys_logininfor` VALUES (167, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-21 17:28:28');
INSERT INTO `sys_logininfor` VALUES (168, 'admin', '127.0.0.1', '内网IP', 'WindowsPowerShell 5.1.19041.6456', 'Windows 10.0', '0', '登录成功', '2026-07-21 17:32:07');
INSERT INTO `sys_logininfor` VALUES (169, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-21 17:35:39');
INSERT INTO `sys_logininfor` VALUES (170, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '1', '验证码错误', '2026-07-21 23:23:23');
INSERT INTO `sys_logininfor` VALUES (171, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-21 23:23:25');
INSERT INTO `sys_logininfor` VALUES (172, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-22 01:37:38');
INSERT INTO `sys_logininfor` VALUES (173, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-22 11:49:44');
INSERT INTO `sys_logininfor` VALUES (174, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-22 14:26:46');
INSERT INTO `sys_logininfor` VALUES (175, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-22 16:21:28');
INSERT INTO `sys_logininfor` VALUES (176, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-24 00:08:58');
INSERT INTO `sys_logininfor` VALUES (177, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '退出成功', '2026-07-24 00:21:19');
INSERT INTO `sys_logininfor` VALUES (178, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-24 00:21:25');
INSERT INTO `sys_logininfor` VALUES (179, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '退出成功', '2026-07-24 00:31:15');
INSERT INTO `sys_logininfor` VALUES (180, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-24 00:31:17');
INSERT INTO `sys_logininfor` VALUES (181, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-24 10:15:31');
INSERT INTO `sys_logininfor` VALUES (182, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-24 11:37:59');
INSERT INTO `sys_logininfor` VALUES (183, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-24 16:04:33');
INSERT INTO `sys_logininfor` VALUES (184, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-24 17:11:46');
INSERT INTO `sys_logininfor` VALUES (185, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-24 18:22:38');
INSERT INTO `sys_logininfor` VALUES (186, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-24 19:24:11');
INSERT INTO `sys_logininfor` VALUES (187, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-25 09:25:38');
INSERT INTO `sys_logininfor` VALUES (188, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-25 16:20:34');
INSERT INTO `sys_logininfor` VALUES (189, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-25 16:53:54');
INSERT INTO `sys_logininfor` VALUES (190, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-25 17:54:34');
INSERT INTO `sys_logininfor` VALUES (191, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-25 19:46:44');
INSERT INTO `sys_logininfor` VALUES (192, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-25 21:27:03');
INSERT INTO `sys_logininfor` VALUES (193, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-26 10:40:00');
INSERT INTO `sys_logininfor` VALUES (194, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-26 11:22:56');
INSERT INTO `sys_logininfor` VALUES (195, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-26 16:51:50');
INSERT INTO `sys_logininfor` VALUES (196, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '1', '验证码已失效', '2026-07-27 00:18:04');
INSERT INTO `sys_logininfor` VALUES (197, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-27 00:18:04');
INSERT INTO `sys_logininfor` VALUES (198, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-27 17:05:18');
INSERT INTO `sys_logininfor` VALUES (199, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-27 18:12:49');
INSERT INTO `sys_logininfor` VALUES (200, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-27 19:21:22');
INSERT INTO `sys_logininfor` VALUES (201, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-27 20:23:18');
INSERT INTO `sys_logininfor` VALUES (202, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-28 10:00:33');
INSERT INTO `sys_logininfor` VALUES (203, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-28 17:00:25');
INSERT INTO `sys_logininfor` VALUES (204, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-28 21:05:21');
INSERT INTO `sys_logininfor` VALUES (205, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-28 22:25:02');
INSERT INTO `sys_logininfor` VALUES (206, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-29 01:11:55');
INSERT INTO `sys_logininfor` VALUES (207, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-29 01:22:46');
INSERT INTO `sys_logininfor` VALUES (208, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '1', '验证码已失效', '2026-07-29 19:27:59');
INSERT INTO `sys_logininfor` VALUES (209, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-29 19:28:00');
INSERT INTO `sys_logininfor` VALUES (210, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-29 22:40:06');
INSERT INTO `sys_logininfor` VALUES (211, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-31 16:52:34');
INSERT INTO `sys_logininfor` VALUES (212, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-31 17:00:11');
INSERT INTO `sys_logininfor` VALUES (213, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-31 17:06:47');
INSERT INTO `sys_logininfor` VALUES (214, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-31 17:08:08');
INSERT INTO `sys_logininfor` VALUES (215, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-31 18:03:10');
INSERT INTO `sys_logininfor` VALUES (216, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '退出成功', '2026-07-31 18:04:20');
INSERT INTO `sys_logininfor` VALUES (217, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-31 18:04:23');
INSERT INTO `sys_logininfor` VALUES (218, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-31 18:06:06');
INSERT INTO `sys_logininfor` VALUES (219, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-31 18:06:52');
INSERT INTO `sys_logininfor` VALUES (220, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-31 19:06:35');
INSERT INTO `sys_logininfor` VALUES (221, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-31 19:07:07');
INSERT INTO `sys_logininfor` VALUES (222, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-07-31 19:40:48');
INSERT INTO `sys_logininfor` VALUES (223, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-08-02 13:55:47');
INSERT INTO `sys_logininfor` VALUES (224, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '1', '验证码错误', '2026-08-02 14:56:10');
INSERT INTO `sys_logininfor` VALUES (225, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-08-02 14:56:10');
INSERT INTO `sys_logininfor` VALUES (226, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-08-02 17:51:09');
INSERT INTO `sys_logininfor` VALUES (227, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-08-02 18:52:00');
INSERT INTO `sys_logininfor` VALUES (228, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-08-02 19:53:04');
INSERT INTO `sys_logininfor` VALUES (229, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-08-02 22:15:27');
INSERT INTO `sys_logininfor` VALUES (230, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-08-03 23:10:46');
INSERT INTO `sys_logininfor` VALUES (231, 'admin', '127.0.0.1', '内网IP', 'Chrome 150', 'Windows10', '0', '登录成功', '2026-08-03 23:48:24');
INSERT INTO `sys_logininfor` VALUES (232, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-10 17:04:19');
INSERT INTO `sys_logininfor` VALUES (233, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-10 22:30:53');
INSERT INTO `sys_logininfor` VALUES (234, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-11 09:45:27');
INSERT INTO `sys_logininfor` VALUES (235, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '1', '验证码错误', '2026-08-11 11:26:43');
INSERT INTO `sys_logininfor` VALUES (236, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-11 11:26:46');
INSERT INTO `sys_logininfor` VALUES (237, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-11 13:24:54');
INSERT INTO `sys_logininfor` VALUES (238, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '退出成功', '2026-08-11 13:37:02');
INSERT INTO `sys_logininfor` VALUES (239, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-11 13:37:04');
INSERT INTO `sys_logininfor` VALUES (240, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '退出成功', '2026-08-11 13:53:50');
INSERT INTO `sys_logininfor` VALUES (241, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-11 13:53:53');
INSERT INTO `sys_logininfor` VALUES (242, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-11 15:06:31');
INSERT INTO `sys_logininfor` VALUES (243, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-11 15:37:50');
INSERT INTO `sys_logininfor` VALUES (244, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-12 13:46:30');
INSERT INTO `sys_logininfor` VALUES (245, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-12 14:11:26');
INSERT INTO `sys_logininfor` VALUES (246, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-14 14:24:00');
INSERT INTO `sys_logininfor` VALUES (247, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-14 14:44:03');
INSERT INTO `sys_logininfor` VALUES (248, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-14 15:27:47');
INSERT INTO `sys_logininfor` VALUES (249, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-15 11:38:48');
INSERT INTO `sys_logininfor` VALUES (250, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-16 15:40:43');
INSERT INTO `sys_logininfor` VALUES (251, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-16 19:07:31');
INSERT INTO `sys_logininfor` VALUES (252, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '退出成功', '2026-08-16 19:09:26');
INSERT INTO `sys_logininfor` VALUES (253, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-16 19:09:28');
INSERT INTO `sys_logininfor` VALUES (254, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-18 22:02:46');
INSERT INTO `sys_logininfor` VALUES (255, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-20 16:24:46');
INSERT INTO `sys_logininfor` VALUES (256, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '1', '验证码已失效', '2026-08-20 16:35:36');
INSERT INTO `sys_logininfor` VALUES (257, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-20 16:35:38');
INSERT INTO `sys_logininfor` VALUES (258, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-24 10:30:29');
INSERT INTO `sys_logininfor` VALUES (259, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '退出成功', '2026-08-24 10:51:14');
INSERT INTO `sys_logininfor` VALUES (260, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-24 10:51:18');
INSERT INTO `sys_logininfor` VALUES (261, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-27 16:35:33');
INSERT INTO `sys_logininfor` VALUES (262, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-30 22:13:40');
INSERT INTO `sys_logininfor` VALUES (263, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-31 13:40:50');
INSERT INTO `sys_logininfor` VALUES (264, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-31 13:47:28');
INSERT INTO `sys_logininfor` VALUES (265, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-08-31 16:24:20');
INSERT INTO `sys_logininfor` VALUES (266, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-09-01 14:44:13');
INSERT INTO `sys_logininfor` VALUES (267, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-09-01 16:00:38');
INSERT INTO `sys_logininfor` VALUES (268, 'admin', '127.0.0.1', '内网IP', 'Chrome 151', 'Windows10', '0', '登录成功', '2026-09-01 16:44:06');
INSERT INTO `sys_logininfor` VALUES (269, 'admin', '127.0.0.1', '内网IP', 'Chrome 152', 'Windows10', '0', '登录成功', '2026-09-02 11:22:11');
INSERT INTO `sys_logininfor` VALUES (270, 'admin', '127.0.0.1', '内网IP', 'Chrome 152', 'Windows10', '0', '登录成功', '2026-09-04 21:42:59');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮 V大屏）',
  `project_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '大屏项目ID',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2417 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '菜单权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 100, 'system', NULL, '', '', 1, 0, 'M', NULL, '0', '0', '', 'system', 'admin', '2026-06-26 10:30:29', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 101, 'monitor', NULL, '', '', 1, 0, 'M', NULL, '0', '0', '', 'monitor', 'admin', '2026-06-26 10:30:29', '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 102, 'tool', NULL, '', '', 1, 0, 'M', NULL, '0', '0', '', 'tool', 'admin', '2026-06-26 10:30:29', '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', NULL, '0', '0', 'system:user:list', 'user', 'admin', '2026-06-26 10:30:29', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', NULL, '0', '0', 'system:role:list', 'peoples', 'admin', '2026-06-26 10:30:29', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', NULL, '0', '0', 'system:menu:list', 'tree-table', 'admin', '2026-06-26 10:30:29', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', NULL, '0', '0', 'system:dept:list', 'tree', 'admin', '2026-06-26 10:30:29', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', NULL, '0', '0', 'system:post:list', 'post', 'admin', '2026-06-26 10:30:29', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', NULL, '0', '0', 'system:dict:list', 'dict', 'admin', '2026-06-26 10:30:29', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', NULL, '0', '0', 'system:config:list', 'edit', 'admin', '2026-06-26 10:30:29', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', NULL, '0', '0', 'system:notice:list', 'message', 'admin', '2026-06-26 10:30:29', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', NULL, '0', '0', '', 'log', 'admin', '2026-06-26 10:30:29', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', NULL, '0', '0', 'monitor:online:list', 'online', 'admin', '2026-06-26 10:30:29', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', NULL, '0', '0', 'monitor:job:list', 'job', 'admin', '2026-06-26 10:30:29', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', NULL, '0', '0', 'monitor:druid:list', 'druid', 'admin', '2026-06-26 10:30:29', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', NULL, '0', '0', 'monitor:server:list', 'server', 'admin', '2026-06-26 10:30:29', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', NULL, '0', '0', 'monitor:cache:list', 'redis', 'admin', '2026-06-26 10:30:29', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', NULL, '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2026-06-26 10:30:29', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', NULL, '0', '0', 'tool:build:list', 'build', 'admin', '2026-06-26 10:30:29', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', NULL, '0', '0', 'tool:gen:list', 'code', 'admin', '2026-06-26 10:30:29', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', NULL, '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2026-06-26 10:30:29', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', NULL, '0', '0', 'monitor:operlog:list', 'form', 'admin', '2026-06-26 10:30:29', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', NULL, '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2026-06-26 10:30:29', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:user:query', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:user:add', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:user:edit', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:user:remove', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:user:export', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:user:import', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:user:resetPwd', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:role:query', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:role:add', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:role:edit', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:role:remove', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:role:export', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:menu:query', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:menu:add', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:menu:edit', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:menu:remove', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:dept:query', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:dept:add', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:dept:edit', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:dept:remove', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:post:query', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:post:add', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:post:edit', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:post:remove', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:post:export', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:dict:query', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:dict:add', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:dict:edit', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:dict:remove', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:dict:export', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:config:query', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:config:add', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:config:edit', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:config:remove', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:config:export', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:notice:query', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:notice:add', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:notice:edit', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'system:notice:remove', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'monitor:operlog:query', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'monitor:operlog:remove', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'monitor:operlog:export', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'monitor:logininfor:query', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'monitor:logininfor:export', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'monitor:online:query', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'monitor:job:query', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'monitor:job:add', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'monitor:job:edit', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'monitor:job:remove', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'monitor:job:export', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'tool:gen:query', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'tool:gen:edit', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'tool:gen:remove', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'tool:gen:import', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'tool:gen:preview', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', NULL, '0', '0', 'tool:gen:code', '#', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2060, '设备中心', 0, 2, 'device', NULL, NULL, '', 1, 0, 'M', NULL, '0', '0', '', 'system', 'admin', '2025-02-10 20:06:21', 'admin', '2026-06-26 11:11:43', '');
INSERT INTO `sys_menu` VALUES (2061, '边缘网关', 0, 2, 'edge', NULL, NULL, '', 1, 0, 'M', NULL, '0', '0', NULL, 'system', 'admin', '2025-02-12 13:38:10', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2110, '透传消息解析器', 2061, 1, 'transparentCodec', 'iot/transparentCodec/index', NULL, '', 1, 0, 'C', NULL, '0', '0', 'iot:transparentCodec:list', '#', 'admin', '2025-02-19 16:50:33', '', NULL, '透传消息解析器菜单');
INSERT INTO `sys_menu` VALUES (2111, '透传消息解析器查询', 2110, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:transparentCodec:query', '#', 'admin', '2025-02-19 16:50:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2112, '透传消息解析器新增', 2110, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:transparentCodec:add', '#', 'admin', '2025-02-19 16:50:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2113, '透传消息解析器修改', 2110, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:transparentCodec:edit', '#', 'admin', '2025-02-19 16:50:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2114, '透传消息解析器删除', 2110, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:transparentCodec:remove', '#', 'admin', '2025-02-19 16:50:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2115, '透传消息解析器导出', 2110, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:transparentCodec:export', '#', 'admin', '2025-02-19 16:50:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2116, '传输协议', 2061, 1, 'protocol', 'iot/protocol/index', NULL, '', 1, 0, 'C', NULL, '0', '0', 'iot:protocol:list', '#', 'admin', '2025-02-19 16:50:41', '', NULL, '传输协议菜单');
INSERT INTO `sys_menu` VALUES (2117, '传输协议查询', 2116, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:protocol:query', '#', 'admin', '2025-02-19 16:50:41', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2118, '传输协议新增', 2116, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:protocol:add', '#', 'admin', '2025-02-19 16:50:41', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2119, '传输协议修改', 2116, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:protocol:edit', '#', 'admin', '2025-02-19 16:50:41', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2120, '传输协议删除', 2116, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:protocol:remove', '#', 'admin', '2025-02-19 16:50:41', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2121, '传输协议导出', 2116, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:protocol:export', '#', 'admin', '2025-02-19 16:50:41', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2122, '网关数据点位', 2061, 1, 'edgeDataPoint', 'iot/edgeDataPoint/index', NULL, '', 1, 0, 'C', NULL, '0', '0', 'iot:edgeDataPoint:list', '#', 'admin', '2025-02-19 16:50:45', '', NULL, '网关数据点位菜单');
INSERT INTO `sys_menu` VALUES (2123, '网关数据点位查询', 2122, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:edgeDataPoint:query', '#', 'admin', '2025-02-19 16:50:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2124, '网关数据点位新增', 2122, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:edgeDataPoint:add', '#', 'admin', '2025-02-19 16:50:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2125, '网关数据点位修改', 2122, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:edgeDataPoint:edit', '#', 'admin', '2025-02-19 16:50:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2126, '网关数据点位删除', 2122, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:edgeDataPoint:remove', '#', 'admin', '2025-02-19 16:50:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2127, '网关数据点位导出', 2122, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:edgeDataPoint:export', '#', 'admin', '2025-02-19 16:50:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2128, '设备接入网关', 2061, 1, 'edgeDevice', 'iot/edgeDevice/index', NULL, '', 1, 0, 'C', NULL, '0', '0', 'iot:edgeDevice:list', '#', 'admin', '2025-02-19 16:50:48', '', NULL, '设备接入网关菜单');
INSERT INTO `sys_menu` VALUES (2129, '设备接入网关查询', 2128, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:edgeDevice:query', '#', 'admin', '2025-02-19 16:50:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2130, '设备接入网关新增', 2128, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:edgeDevice:add', '#', 'admin', '2025-02-19 16:50:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2131, '设备接入网关修改', 2128, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:edgeDevice:edit', '#', 'admin', '2025-02-19 16:50:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2132, '设备接入网关删除', 2128, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:edgeDevice:remove', '#', 'admin', '2025-02-19 16:50:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2133, '设备接入网关导出', 2128, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:edgeDevice:export', '#', 'admin', '2025-02-19 16:50:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2134, '设备属性关联', 2060, 3, 'binding', 'iot/binding/index', NULL, '', 1, 0, 'C', NULL, '1', '1', 'iot:binding:list', '#', 'admin', '2025-02-25 16:12:13', 'admin', '2025-03-20 14:13:44', '设备属性模板菜单');
INSERT INTO `sys_menu` VALUES (2135, '设备属性模板查询', 2134, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:binding:query', '#', 'admin', '2025-02-25 16:12:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2136, '设备属性模板新增', 2134, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:binding:add', '#', 'admin', '2025-02-25 16:12:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2137, '设备属性模板修改', 2134, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:binding:edit', '#', 'admin', '2025-02-25 16:12:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2138, '设备属性模板删除', 2134, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:binding:remove', '#', 'admin', '2025-02-25 16:12:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2139, '设备属性模板导出', 2134, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:binding:export', '#', 'admin', '2025-02-25 16:12:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2140, '设备管理', 2060, 1, 'devices', 'iot/devices/index', NULL, '', 1, 0, 'C', NULL, '0', '0', 'iot:devices:list', '#', 'admin', '2025-02-25 16:12:17', 'admin', '2025-02-25 16:13:34', '设备菜单');
INSERT INTO `sys_menu` VALUES (2141, '设备查询', 2140, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:devices:query', '#', 'admin', '2025-02-25 16:12:17', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2142, '设备新增', 2140, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:devices:add', '#', 'admin', '2025-02-25 16:12:17', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2143, '设备修改', 2140, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:devices:edit', '#', 'admin', '2025-02-25 16:12:17', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2144, '设备删除', 2140, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:devices:remove', '#', 'admin', '2025-02-25 16:12:17', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2145, '设备导出', 2140, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:devices:export', '#', 'admin', '2025-02-25 16:12:17', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2146, '产品信息', 2309, 1, 'products', 'iot/products/index', NULL, '', 1, 0, 'C', NULL, '0', '0', 'iot:products:list', '#', 'admin', '2025-02-25 16:12:22', 'admin', '2026-06-26 11:23:36', '产品信息菜单');
INSERT INTO `sys_menu` VALUES (2147, '产品信息查询', 2146, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:products:query', '#', 'admin', '2025-02-25 16:12:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2148, '产品信息新增', 2146, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:products:add', '#', 'admin', '2025-02-25 16:12:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2149, '产品信息修改', 2146, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:products:edit', '#', 'admin', '2025-02-25 16:12:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2150, '产品信息删除', 2146, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:products:remove', '#', 'admin', '2025-02-25 16:12:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2151, '产品信息导出', 2146, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:products:export', '#', 'admin', '2025-02-25 16:12:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2152, '产品物模型', 2309, 2, 'productTemplates', 'iot/productTemplates/index', NULL, '', 1, 0, 'C', NULL, '1', '1', 'iot:productTemplates:list', '#', 'admin', '2025-02-25 16:12:26', 'admin', '2026-06-26 11:23:41', '产品物模型菜单');
INSERT INTO `sys_menu` VALUES (2153, '产品物模型查询', 2152, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:productTemplates:query', '#', 'admin', '2025-02-25 16:12:26', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2154, '产品物模型新增', 2152, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:productTemplates:add', '#', 'admin', '2025-02-25 16:12:26', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2155, '产品物模型修改', 2152, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:productTemplates:edit', '#', 'admin', '2025-02-25 16:12:26', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2156, '产品物模型删除', 2152, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:productTemplates:remove', '#', 'admin', '2025-02-25 16:12:26', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2157, '产品物模型导出', 2152, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:productTemplates:export', '#', 'admin', '2025-02-25 16:12:26', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2158, '产品类型', 2309, 3, 'productCategories', 'iot/productCategories/index', NULL, '', 1, 0, 'C', NULL, '0', '0', 'iot:productCategories:list', '#', 'admin', '2025-03-05 19:29:33', 'admin', '2026-06-26 11:23:46', '产品类型菜单');
INSERT INTO `sys_menu` VALUES (2159, '产品类型查询', 2158, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:productCategories:query', '#', 'admin', '2025-03-05 19:29:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2160, '产品类型新增', 2158, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:productCategories:add', '#', 'admin', '2025-03-05 19:29:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2161, '产品类型修改', 2158, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:productCategories:edit', '#', 'admin', '2025-03-05 19:29:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2162, '产品类型删除', 2158, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:productCategories:remove', '#', 'admin', '2025-03-05 19:29:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2163, '产品类型导出', 2158, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:productCategories:export', '#', 'admin', '2025-03-05 19:29:33', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2164, '设备历史记录', 2060, 4, 'deviceHistory', 'iot/deviceHistory/index', NULL, '', 1, 0, 'C', NULL, '1', '1', 'iot:deviceHistory:list', '#', 'admin', '2025-03-11 18:56:28', 'admin', '2026-09-02 11:24:08', 'DeviceHistory菜单');
INSERT INTO `sys_menu` VALUES (2165, 'DeviceHistory查询', 2164, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:deviceHistory:query', '#', 'admin', '2025-03-11 18:56:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2166, 'DeviceHistory新增', 2164, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:deviceHistory:add', '#', 'admin', '2025-03-11 18:56:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2167, 'DeviceHistory修改', 2164, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:deviceHistory:edit', '#', 'admin', '2025-03-11 18:56:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2168, 'DeviceHistory删除', 2164, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:deviceHistory:remove', '#', 'admin', '2025-03-11 18:56:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2169, 'DeviceHistory导出', 2164, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:deviceHistory:export', '#', 'admin', '2025-03-11 18:56:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2171, '规则场景查询', 2170, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:ruleScene:query', '#', 'admin', '2025-03-20 13:36:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2172, '规则场景新增', 2170, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:ruleScene:add', '#', 'admin', '2025-03-20 13:36:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2173, '规则场景修改', 2170, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:ruleScene:edit', '#', 'admin', '2025-03-20 13:36:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2174, '规则场景删除', 2170, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:ruleScene:remove', '#', 'admin', '2025-03-20 13:36:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2175, '规则场景导出', 2170, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:ruleScene:export', '#', 'admin', '2025-03-20 13:36:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2176, '能耗管理', 0, 10, 'ems', NULL, NULL, '', 1, 0, 'M', NULL, '0', '0', NULL, 'example', 'admin', '2025-08-26 21:12:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2195, '建筑基础信息', 2312, 1, 'buildings', 'iot/buildings/index', NULL, '', 1, 0, 'C', NULL, '0', '0', 'iot:buildings:list', '#', 'admin', '2025-08-26 21:42:29', 'admin', '2026-07-16 19:34:22', '建筑基础信息菜单');
INSERT INTO `sys_menu` VALUES (2196, '建筑基础信息查询', 2195, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:buildings:query', '#', 'admin', '2025-08-26 21:42:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2197, '建筑基础信息新增', 2195, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:buildings:add', '#', 'admin', '2025-08-26 21:42:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2198, '建筑基础信息修改', 2195, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:buildings:edit', '#', 'admin', '2025-08-26 21:42:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2199, '建筑基础信息删除', 2195, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:buildings:remove', '#', 'admin', '2025-08-26 21:42:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2200, '建筑基础信息导出', 2195, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:buildings:export', '#', 'admin', '2025-08-26 21:42:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2231, '单位类型', 2312, 1, 'categoryUnit', 'iot/categoryUnit/index', NULL, '', 1, 0, 'C', NULL, '0', '0', 'iot:categoryUnit:list', '#', 'admin', '2025-08-28 19:54:47', 'admin', '2026-06-26 11:24:40', '单位类型菜单');
INSERT INTO `sys_menu` VALUES (2232, '单位类型查询', 2231, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:categoryUnit:query', '#', 'admin', '2025-08-28 19:54:47', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2233, '单位类型新增', 2231, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:categoryUnit:add', '#', 'admin', '2025-08-28 19:54:47', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2234, '单位类型修改', 2231, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:categoryUnit:edit', '#', 'admin', '2025-08-28 19:54:47', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2235, '单位类型删除', 2231, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:categoryUnit:remove', '#', 'admin', '2025-08-28 19:54:47', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2236, '单位类型导出', 2231, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:categoryUnit:export', '#', 'admin', '2025-08-28 19:54:47', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2237, '单位信息', 2312, 1, 'unit', 'iot/unit/index', NULL, '', 1, 0, 'C', NULL, '0', '0', 'iot:unit:list', '#', 'admin', '2025-08-28 19:54:51', 'admin', '2026-06-26 11:24:49', '单位信息菜单');
INSERT INTO `sys_menu` VALUES (2238, '单位信息查询', 2237, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:unit:query', '#', 'admin', '2025-08-28 19:54:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2239, '单位信息新增', 2237, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:unit:add', '#', 'admin', '2025-08-28 19:54:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2240, '单位信息修改', 2237, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:unit:edit', '#', 'admin', '2025-08-28 19:54:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2241, '单位信息删除', 2237, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:unit:remove', '#', 'admin', '2025-08-28 19:54:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2242, '单位信息导出', 2237, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:unit:export', '#', 'admin', '2025-08-28 19:54:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2256, '设备分组查询', 2255, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:deviceGroup:query', '#', 'admin', '2025-09-10 19:38:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2257, '设备分组新增', 2255, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:deviceGroup:add', '#', 'admin', '2025-09-10 19:38:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2258, '设备分组修改', 2255, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:deviceGroup:edit', '#', 'admin', '2025-09-10 19:38:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2259, '设备分组删除', 2255, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:deviceGroup:remove', '#', 'admin', '2025-09-10 19:38:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2260, '设备分组导出', 2255, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:deviceGroup:export', '#', 'admin', '2025-09-10 19:38:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2262, '场景联动历史记录查询', 2261, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:ruleSceneLog:query', '#', 'admin', '2025-09-10 19:43:37', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2263, '场景联动历史记录新增', 2261, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:ruleSceneLog:add', '#', 'admin', '2025-09-10 19:43:37', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2264, '场景联动历史记录修改', 2261, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:ruleSceneLog:edit', '#', 'admin', '2025-09-10 19:43:37', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2265, '场景联动历史记录删除', 2261, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:ruleSceneLog:remove', '#', 'admin', '2025-09-10 19:43:37', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2266, '场景联动历史记录导出', 2261, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:ruleSceneLog:export', '#', 'admin', '2025-09-10 19:43:37', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2267, '告警记录', 2311, 1, 'alarmLog', 'iot/alarmLog/index', NULL, '', 1, 0, 'C', NULL, '0', '0', 'iot:alarmLog:list', '#', 'admin', '2025-09-10 19:43:42', 'admin', '2026-06-26 11:24:19', '告警记录菜单');
INSERT INTO `sys_menu` VALUES (2268, '告警记录查询', 2267, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:alarmLog:query', '#', 'admin', '2025-09-10 19:43:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2269, '告警记录新增', 2267, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:alarmLog:add', '#', 'admin', '2025-09-10 19:43:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2270, '告警记录修改', 2267, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:alarmLog:edit', '#', 'admin', '2025-09-10 19:43:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2271, '告警记录删除', 2267, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:alarmLog:remove', '#', 'admin', '2025-09-10 19:43:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2272, '告警记录导出', 2267, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:alarmLog:export', '#', 'admin', '2025-09-10 19:43:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2279, '标签详情', 2311, 1, 'tagDetail', 'iot/tagDetail/index', NULL, '', 1, 0, 'C', NULL, '0', '0', 'iot:tagDetail:list', '#', 'admin', '2025-10-23 20:16:05', 'admin', '2026-06-26 11:24:25', '标签详情菜单');
INSERT INTO `sys_menu` VALUES (2280, '标签详情查询', 2279, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:tagDetail:query', '#', 'admin', '2025-10-23 20:16:05', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2281, '标签详情新增', 2279, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:tagDetail:add', '#', 'admin', '2025-10-23 20:16:05', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2282, '标签详情修改', 2279, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:tagDetail:edit', '#', 'admin', '2025-10-23 20:16:05', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2283, '标签详情删除', 2279, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:tagDetail:remove', '#', 'admin', '2025-10-23 20:16:05', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2284, '标签详情导出', 2279, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'iot:tagDetail:export', '#', 'admin', '2025-10-23 20:16:05', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2309, '产品中心', 0, 1, 'product', NULL, NULL, '', 1, 0, 'M', NULL, '0', '0', '', 'system', 'admin', '2026-06-26 11:09:15', 'admin', '2026-06-26 11:11:21', '');
INSERT INTO `sys_menu` VALUES (2310, '规则引擎', 0, 3, 'rule', NULL, NULL, '', 1, 0, 'M', NULL, '0', '0', '', 'system', 'admin', '2026-06-26 11:19:32', 'admin', '2026-06-26 11:20:30', '');
INSERT INTO `sys_menu` VALUES (2311, '运维告警', 0, 4, 'alarm', NULL, NULL, '', 1, 0, 'M', NULL, '0', '0', '', 'system', 'admin', '2026-06-26 11:20:01', 'admin', '2026-06-26 11:22:03', '');
INSERT INTO `sys_menu` VALUES (2312, '基础数据', 0, 5, 'base', NULL, NULL, '', 1, 0, 'M', NULL, '0', '0', NULL, 'system', 'admin', '2026-06-26 11:22:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2313, '组态管理', 0, 6, 'view', NULL, NULL, '', 1, 0, 'M', NULL, '0', '0', '', 'example', 'admin', '2026-07-19 12:26:41', 'admin', '2026-07-31 18:01:11', '');
INSERT INTO `sys_menu` VALUES (2316, '能源类型字典查询', 2315, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyType:query', '#', 'admin', '2026-07-22 01:59:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2317, '能源类型字典新增', 2315, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyType:add', '#', 'admin', '2026-07-22 01:59:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2318, '能源类型字典修改', 2315, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyType:edit', '#', 'admin', '2026-07-22 01:59:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2319, '能源类型字典删除', 2315, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyType:remove', '#', 'admin', '2026-07-22 01:59:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2320, '能源类型字典导出', 2315, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyType:export', '#', 'admin', '2026-07-22 01:59:57', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2322, '区域树查询', 2321, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyArea:query', '#', 'admin', '2026-07-24 18:31:35', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2323, '区域树新增', 2321, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyArea:add', '#', 'admin', '2026-07-24 18:31:35', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2324, '区域树修改', 2321, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyArea:edit', '#', 'admin', '2026-07-24 18:31:35', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2325, '区域树删除', 2321, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyArea:remove', '#', 'admin', '2026-07-24 18:31:35', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2326, '区域树导出', 2321, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyArea:export', '#', 'admin', '2026-07-24 18:31:35', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2328, '通道配置查询', 2327, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyMeterChannel:query', '#', 'admin', '2026-07-24 18:31:41', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2329, '通道配置新增', 2327, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyMeterChannel:add', '#', 'admin', '2026-07-24 18:31:41', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2330, '通道配置修改', 2327, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyMeterChannel:edit', '#', 'admin', '2026-07-24 18:31:41', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2331, '通道配置删除', 2327, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyMeterChannel:remove', '#', 'admin', '2026-07-24 18:31:41', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2332, '通道配置导出', 2327, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyMeterChannel:export', '#', 'admin', '2026-07-24 18:31:41', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2334, '支路归属查询', 2333, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyBranchDimBinding:query', '#', 'admin', '2026-07-24 18:32:34', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2335, '支路归属新增', 2333, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyBranchDimBinding:add', '#', 'admin', '2026-07-24 18:32:34', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2336, '支路归属修改', 2333, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyBranchDimBinding:edit', '#', 'admin', '2026-07-24 18:32:34', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2337, '支路归属删除', 2333, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyBranchDimBinding:remove', '#', 'admin', '2026-07-24 18:32:34', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2338, '支路归属导出', 2333, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyBranchDimBinding:export', '#', 'admin', '2026-07-24 18:32:34', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2340, '逻辑绑定查询', 2339, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyMeterBranchBinding:query', '#', 'admin', '2026-07-24 18:32:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2341, '逻辑绑定新增', 2339, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyMeterBranchBinding:add', '#', 'admin', '2026-07-24 18:32:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2342, '逻辑绑定修改', 2339, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyMeterBranchBinding:edit', '#', 'admin', '2026-07-24 18:32:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2343, '逻辑绑定删除', 2339, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyMeterBranchBinding:remove', '#', 'admin', '2026-07-24 18:32:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2344, '逻辑绑定导出', 2339, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyMeterBranchBinding:export', '#', 'admin', '2026-07-24 18:32:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2376, '逻辑计查询', 2375, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyMeter:query', '#', 'admin', '2026-07-24 18:33:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2377, '逻辑计新增', 2375, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyMeter:add', '#', 'admin', '2026-07-24 18:33:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2378, '逻辑计修改', 2375, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyMeter:edit', '#', 'admin', '2026-07-24 18:33:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2379, '逻辑计删除', 2375, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyMeter:remove', '#', 'admin', '2026-07-24 18:33:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2380, '逻辑计导出', 2375, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyMeter:export', '#', 'admin', '2026-07-24 18:33:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2382, '分项树查询', 2381, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energySubItem:query', '#', 'admin', '2026-07-24 18:33:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2383, '分项树新增', 2381, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energySubItem:add', '#', 'admin', '2026-07-24 18:33:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2384, '分项树修改', 2381, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energySubItem:edit', '#', 'admin', '2026-07-24 18:33:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2385, '分项树删除', 2381, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energySubItem:remove', '#', 'admin', '2026-07-24 18:33:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2386, '分项树导出', 2381, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energySubItem:export', '#', 'admin', '2026-07-24 18:33:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2388, '能源支路查询', 2387, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyBranchLine:query', '#', 'admin', '2026-07-25 18:08:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2389, '能源支路新增', 2387, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyBranchLine:add', '#', 'admin', '2026-07-25 18:08:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2390, '能源支路修改', 2387, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyBranchLine:edit', '#', 'admin', '2026-07-25 18:08:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2391, '能源支路删除', 2387, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyBranchLine:remove', '#', 'admin', '2026-07-25 18:08:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2392, '能源支路导出', 2387, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:energyBranchLine:export', '#', 'admin', '2026-07-25 18:08:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2396, '新增大屏', 2394, 1, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'view:project:add', '#', 'admin', '2026-08-11 11:53:08', '', NULL, '新增大屏');
INSERT INTO `sys_menu` VALUES (2397, '查询大屏', 2394, 2, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'view:project:query', '#', 'admin', '2026-08-11 11:53:08', '', NULL, '查询大屏');
INSERT INTO `sys_menu` VALUES (2398, '编辑大屏', 2394, 3, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'view:project:edit', '#', 'admin', '2026-08-11 11:53:08', '', NULL, '编辑大屏');
INSERT INTO `sys_menu` VALUES (2399, '删除大屏', 2394, 4, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'view:project:remove', '#', 'admin', '2026-08-11 11:53:08', '', NULL, '删除大屏');
INSERT INTO `sys_menu` VALUES (2400, '发布大屏', 2394, 5, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'view:project:publish', '#', 'admin', '2026-08-11 11:53:08', '', NULL, '发布大屏');
INSERT INTO `sys_menu` VALUES (2401, '上传资源', 2394, 6, '', '', '', '', 1, 0, 'F', NULL, '0', '0', 'view:project:upload', '#', 'admin', '2026-08-11 11:53:08', '', NULL, '上传资源');
INSERT INTO `sys_menu` VALUES (2406, '费用策略查询', 2405, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:tariffPolicy:query', '#', 'admin', '2026-09-07 00:00:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2407, '费用策略新增', 2405, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:tariffPolicy:add', '#', 'admin', '2026-09-07 00:00:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2408, '费用策略修改', 2405, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:tariffPolicy:edit', '#', 'admin', '2026-09-07 00:00:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2409, '费用策略删除', 2405, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:tariffPolicy:remove', '#', 'admin', '2026-09-07 00:00:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2410, '费用策略导出', 2405, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:tariffPolicy:export', '#', 'admin', '2026-09-07 00:00:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2412, '碳因子查询', 2411, 1, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:carbonFactor:query', '#', 'admin', '2026-09-07 00:00:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2413, '碳因子新增', 2411, 2, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:carbonFactor:add', '#', 'admin', '2026-09-07 00:00:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2414, '碳因子修改', 2411, 3, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:carbonFactor:edit', '#', 'admin', '2026-09-07 00:00:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2415, '碳因子删除', 2411, 4, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:carbonFactor:remove', '#', 'admin', '2026-09-07 00:00:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2416, '碳因子导出', 2411, 5, '#', '', NULL, '', 1, 0, 'F', NULL, '0', '0', 'energy:carbonFactor:export', '#', 'admin', '2026-09-07 00:00:00', '', NULL, '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '通知公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------

-- ----------------------------
-- Table structure for sys_notice_read
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice_read`;
CREATE TABLE `sys_notice_read`  (
  `read_id` bigint NOT NULL AUTO_INCREMENT COMMENT '已读主键',
  `notice_id` int NOT NULL COMMENT '公告id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `read_time` datetime NOT NULL COMMENT '阅读时间',
  PRIMARY KEY (`read_id`) USING BTREE,
  UNIQUE INDEX `uk_user_notice`(`user_id` ASC, `notice_id` ASC) USING BTREE COMMENT '同一用户同一公告只记录一次'
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '公告已读记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_notice_read
-- ----------------------------

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 921 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (100, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-06-26 10:30:29\",\"icon\":\"guide\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":4,\"menuName\":\"若依官网\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"http://ruoyi.vip\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 10:37:37', 31);
INSERT INTO `sys_oper_log` VALUES (101, '保存菜单排序', 2, 'com.ruoyi.web.controller.system.SysMenuController.updateSort()', 'PUT', 1, 'admin', '研发部门', '/system/menu/updateSort', '127.0.0.1', '内网IP', '{\"menuIds\":\"1,2,3,4,2060,2061,2176\",\"orderNums\":\"4,5,6,7,1,2,3\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 11:08:03', 177);
INSERT INTO `sys_oper_log` VALUES (102, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"产品管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"aa\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 11:09:15', 16);
INSERT INTO `sys_oper_log` VALUES (103, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-06-26 11:09:15\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2309,\"menuName\":\"产品管理\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"aa\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 11:09:23', 13);
INSERT INTO `sys_oper_log` VALUES (104, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-06-26 11:09:15\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2309,\"menuName\":\"产品管理\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"product\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 11:09:56', 13);
INSERT INTO `sys_oper_log` VALUES (105, '保存菜单排序', 2, 'com.ruoyi.web.controller.system.SysMenuController.updateSort()', 'PUT', 1, 'admin', '研发部门', '/system/menu/updateSort', '127.0.0.1', '内网IP', '{\"menuIds\":\"1,2,3,4\",\"orderNums\":\"100,101,102,103\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 11:10:23', 12);
INSERT INTO `sys_oper_log` VALUES (106, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-06-26 11:09:15\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2309,\"menuName\":\"产品中心\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"product\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 11:11:21', 13);
INSERT INTO `sys_oper_log` VALUES (107, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2025-02-10 20:06:21\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2060,\"menuName\":\"设备中心\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"device\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 11:11:43', 14);
INSERT INTO `sys_oper_log` VALUES (108, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"规则引擎\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"rule\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 11:19:32', 15);
INSERT INTO `sys_oper_log` VALUES (109, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"运维告警\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"base\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 11:20:01', 10);
INSERT INTO `sys_oper_log` VALUES (110, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-06-26 11:19:32\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2310,\"menuName\":\"规则引擎\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"rule\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 11:20:30', 14);
INSERT INTO `sys_oper_log` VALUES (111, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"基础数据\",\"menuType\":\"M\",\"orderNum\":5,\"params\":{},\"parentId\":0,\"path\":\"base\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"新增菜单\'基础数据\'失败，路由名称或地址已存在\",\"code\":500}', 0, NULL, '2026-06-26 11:21:44', 13);
INSERT INTO `sys_oper_log` VALUES (112, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-06-26 11:20:01\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2311,\"menuName\":\"运维告警\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"alarm\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 11:22:03', 12);
INSERT INTO `sys_oper_log` VALUES (113, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"基础数据\",\"menuType\":\"M\",\"orderNum\":6,\"params\":{},\"parentId\":0,\"path\":\"base\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 11:22:24', 11);
INSERT INTO `sys_oper_log` VALUES (114, '保存菜单排序', 2, 'com.ruoyi.web.controller.system.SysMenuController.updateSort()', 'PUT', 1, 'admin', '研发部门', '/system/menu/updateSort', '127.0.0.1', '内网IP', '{\"menuIds\":\"2060,2310,2311,2312\",\"orderNums\":\"2,3,4,5\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 11:23:06', 10);
INSERT INTO `sys_oper_log` VALUES (115, '保存菜单排序', 2, 'com.ruoyi.web.controller.system.SysMenuController.updateSort()', 'PUT', 1, 'admin', '研发部门', '/system/menu/updateSort', '127.0.0.1', '内网IP', '{\"menuIds\":\"2176\",\"orderNums\":\"10\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 11:23:15', 5);
INSERT INTO `sys_oper_log` VALUES (116, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"iot/products/index\",\"createTime\":\"2025-02-25 16:12:22\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2146,\"menuName\":\"产品信息\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2309,\"path\":\"products\",\"perms\":\"iot:products:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 11:23:36', 11);
INSERT INTO `sys_oper_log` VALUES (117, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"iot/productTemplates/index\",\"createTime\":\"2025-02-25 16:12:26\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2152,\"menuName\":\"产品物模型\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2309,\"path\":\"productTemplates\",\"perms\":\"iot:productTemplates:list\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 11:23:41', 10);
INSERT INTO `sys_oper_log` VALUES (118, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"iot/productCategories/index\",\"createTime\":\"2025-03-05 19:29:33\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2158,\"menuName\":\"产品类型\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2309,\"path\":\"productCategories\",\"perms\":\"iot:productCategories:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 11:23:46', 11);
INSERT INTO `sys_oper_log` VALUES (119, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"iot/ruleScene/index\",\"createTime\":\"2025-03-20 13:36:31\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2170,\"menuName\":\"规则场景\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2310,\"path\":\"ruleScene\",\"perms\":\"iot:ruleScene:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 11:23:59', 10);
INSERT INTO `sys_oper_log` VALUES (120, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"iot/ruleSceneLog/index\",\"createTime\":\"2025-09-10 19:43:37\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2261,\"menuName\":\"场景联动历史\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2310,\"path\":\"ruleSceneLog\",\"perms\":\"iot:ruleSceneLog:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 11:24:11', 14);
INSERT INTO `sys_oper_log` VALUES (121, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"iot/alarmLog/index\",\"createTime\":\"2025-09-10 19:43:42\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2267,\"menuName\":\"告警记录\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2311,\"path\":\"alarmLog\",\"perms\":\"iot:alarmLog:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 11:24:19', 10);
INSERT INTO `sys_oper_log` VALUES (122, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"iot/tagDetail/index\",\"createTime\":\"2025-10-23 20:16:05\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2279,\"menuName\":\"标签详情\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2311,\"path\":\"tagDetail\",\"perms\":\"iot:tagDetail:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 11:24:25', 12);
INSERT INTO `sys_oper_log` VALUES (123, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"iot/categoryUnit/index\",\"createTime\":\"2025-08-28 19:54:47\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2231,\"menuName\":\"单位类型\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2312,\"path\":\"categoryUnit\",\"perms\":\"iot:categoryUnit:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 11:24:40', 11);
INSERT INTO `sys_oper_log` VALUES (124, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"iot/unit/index\",\"createTime\":\"2025-08-28 19:54:51\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2237,\"menuName\":\"单位信息\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2312,\"path\":\"unit\",\"perms\":\"iot:unit:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 11:24:49', 11);
INSERT INTO `sys_oper_log` VALUES (125, '保存菜单排序', 2, 'com.ruoyi.web.controller.system.SysMenuController.updateSort()', 'PUT', 1, 'admin', '研发部门', '/system/menu/updateSort', '127.0.0.1', '内网IP', '{\"menuIds\":\"2134,2164,2255\",\"orderNums\":\"3,4,2\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 11:25:12', 8);
INSERT INTO `sys_oper_log` VALUES (126, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"aasd\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"123\"} ', NULL, 1, '边缘网关不存在或着离线！', '2026-06-26 13:11:31', 21);
INSERT INTO `sys_oper_log` VALUES (127, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"aasd\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"123\"} ', NULL, 1, '边缘网关不存在或着离线！', '2026-06-26 13:11:32', 2);
INSERT INTO `sys_oper_log` VALUES (128, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"aasd\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.colorTemperature\",\"telemetryKey\":\"colorTemperature\",\"value\":\"0\"} ', NULL, 1, '边缘网关不存在或着离线！', '2026-06-26 13:11:34', 2);
INSERT INTO `sys_oper_log` VALUES (129, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"aasd\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.colorTemperature\",\"telemetryKey\":\"colorTemperature\",\"value\":\"asda\"} ', NULL, 1, '边缘网关不存在或着离线！', '2026-06-26 13:11:36', 1);
INSERT INTO `sys_oper_log` VALUES (130, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"aasd\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"0\"} ', NULL, 1, '边缘网关不存在或着离线！', '2026-06-26 13:14:56', 1);
INSERT INTO `sys_oper_log` VALUES (131, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"aasd\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"123\"} ', NULL, 1, '边缘网关不存在或着离线！', '2026-06-26 13:14:59', 1);
INSERT INTO `sys_oper_log` VALUES (132, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"aasd\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"77\"} ', NULL, 1, '边缘网关不存在或着离线！', '2026-06-26 13:16:11', 2);
INSERT INTO `sys_oper_log` VALUES (133, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"aasd\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"123\"} ', NULL, 1, '边缘网关不存在或着离线！', '2026-06-26 13:16:16', 1);
INSERT INTO `sys_oper_log` VALUES (134, '产品物模型', 2, 'com.ruoyi.iot.controller.ProductTemplatesController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/productTemplates', '127.0.0.1', '内网IP', '{\"classify\":\"property\",\"createBy\":\"\",\"createTime\":\"2025-02-25 18:33:08\",\"define\":\"{\\\"id\\\":\\\"colorTemperature\\\",\\\"name\\\":\\\"色温值\\\",\\\"valueType\\\":{\\\"type\\\":\\\"int\\\",\\\"max\\\":2000,\\\"min\\\":6500,\\\"unit\\\":\\\"K\\\"}}\",\"description\":\"\\\"色温值，单位为开尔文，范围为2000K到6500K\\\"\",\"id\":\"dimmer.colorTemperature\",\"name\":\"色温值\",\"operationTpye\":\"rw\",\"params\":{},\"productId\":\"dimmer\",\"telemetryKey\":\"colorTemperature\",\"type\":\"int\",\"updateBy\":\"\",\"updateTime\":\"2026-06-26 13:16:48\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 13:16:48', 29);
INSERT INTO `sys_oper_log` VALUES (135, '产品物模型', 2, 'com.ruoyi.iot.controller.ProductTemplatesController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/productTemplates', '127.0.0.1', '内网IP', '{\"classify\":\"property\",\"createBy\":\"\",\"createTime\":\"2025-02-25 18:33:56\",\"define\":\"{\\\"id\\\":\\\"status\\\",\\\"name\\\":\\\"工作状态\\\",\\\"valueType\\\":{\\\"elements\\\":[{\\\"description\\\":\\\"正在运行\\\",\\\"text\\\":\\\"正在运行\\\",\\\"value\\\":\\\"1\\\"},{\\\"description\\\":\\\"无法运行\\\",\\\"text\\\":\\\"无法运行\\\",\\\"value\\\":\\\"2\\\"},{\\\"description\\\":\\\"未知\\\",\\\"text\\\":\\\"未知\\\",\\\"value\\\":\\\"3\\\"},{\\\"description\\\":\\\"超载\\\",\\\"text\\\":\\\"超载\\\",\\\"value\\\":\\\"4\\\"}],\\\"type\\\":\\\"enum\\\"}}\",\"description\":\"设备的工作状态（如：开，关，故障等）\",\"id\":\"dimmer.status\",\"name\":\"工作状态\",\"operationTpye\":\"rw\",\"params\":{},\"productId\":\"dimmer\",\"telemetryKey\":\"status\",\"type\":\"enum\",\"updateBy\":\"\",\"updateTime\":\"2026-06-26 13:17:08\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 13:17:08', 8);
INSERT INTO `sys_oper_log` VALUES (136, '设备', 3, 'com.ruoyi.iot.controller.DevicesController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/devices/aasd,d1,d2,test,test1,xcv', '127.0.0.1', '内网IP', '[\"aasd\",\"d1\",\"d2\",\"test\",\"test1\",\"xcv\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 13:17:22', 69);
INSERT INTO `sys_oper_log` VALUES (137, '设备接入网关', 3, 'com.ruoyi.iot.controller.EdgeDeviceController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/edgeDevice/modbus_1', '127.0.0.1', '内网IP', '[\"modbus_1\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 13:19:18', 25);
INSERT INTO `sys_oper_log` VALUES (138, '设备接入网关', 1, 'com.ruoyi.iot.controller.EdgeDeviceController.add()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDevice', '127.0.0.1', '内网IP', '{\"configuration\":\"{\\\"ip_address\\\":\\\"127.0.0.1\\\",\\\"port\\\":502,\\\"timeout\\\":1000,\\\"slave_id\\\":0,\\\"refresh_interval\\\":1000}\",\"createTime\":\"2026-06-26 13:42:26\",\"id\":\"a9dfc8cbbad34aca9ca3c1849e6f7ad3\",\"linkStatus\":\"offline\",\"name\":\"localmodbus\",\"params\":{},\"protocolId\":\"modbus\",\"status\":\"disable\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 13:42:26', 14);
INSERT INTO `sys_oper_log` VALUES (139, '设备接入网关', 1, 'com.ruoyi.iot.controller.EdgeDeviceController.add()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDevice', '127.0.0.1', '内网IP', '{\"configuration\":\"{\\\"ip_address\\\":\\\"qe\\\"}\",\"createTime\":\"2026-06-26 13:43:51\",\"description\":\"\",\"id\":\"0a7c2060041b438db8b3c1321a5b0316\",\"linkStatus\":\"offline\",\"name\":\"\",\"params\":{},\"status\":\"disable\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 13:43:51', 6);
INSERT INTO `sys_oper_log` VALUES (140, '设备接入网关', 3, 'com.ruoyi.iot.controller.EdgeDeviceController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/edgeDevice/0a7c2060041b438db8b3c1321a5b0316', '127.0.0.1', '内网IP', '[\"0a7c2060041b438db8b3c1321a5b0316\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 13:43:56', 9);
INSERT INTO `sys_oper_log` VALUES (141, '设备接入网关', 1, 'com.ruoyi.iot.controller.EdgeDeviceController.add()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDevice', '127.0.0.1', '内网IP', '{\"configuration\":\"{}\",\"createTime\":\"2026-06-26 13:47:42\",\"id\":\"modbus_mquienm0_pjuwbf\",\"linkStatus\":\"offline\",\"name\":\"qwe\",\"params\":{},\"status\":\"disable\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 13:47:42', 5);
INSERT INTO `sys_oper_log` VALUES (142, '设备接入网关', 3, 'com.ruoyi.iot.controller.EdgeDeviceController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/edgeDevice/modbus_mquienm0_pjuwbf', '127.0.0.1', '内网IP', '[\"modbus_mquienm0_pjuwbf\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 13:47:46', 10);
INSERT INTO `sys_oper_log` VALUES (143, '网关数据点位', 1, 'com.ruoyi.iot.controller.EdgeDataPointController.add()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint', '127.0.0.1', '内网IP', '{\"config\":\"{\\\"register_type\\\":\\\"coil\\\",\\\"offset\\\":3,\\\"quantity\\\":6}\",\"createTime\":\"2026-06-26 15:08:31\",\"gatewayId\":\"a9dfc8cbbad34aca9ca3c1849e6f7ad3\",\"id\":\"2070403818898149376\",\"name\":\"123\",\"operationTpye\":\"r\",\"params\":{},\"protocolId\":\"modbus\",\"type\":\"int\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 15:08:31', 78);
INSERT INTO `sys_oper_log` VALUES (144, '网关数据点位', 3, 'com.ruoyi.iot.controller.EdgeDataPointController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/edgeDataPoint/2070403818898149376', '127.0.0.1', '内网IP', '[\"2070403818898149376\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 15:13:30', 13);
INSERT INTO `sys_oper_log` VALUES (145, '设备接入网关', 3, 'com.ruoyi.iot.controller.EdgeDeviceController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/edgeDevice/a9dfc8cbbad34aca9ca3c1849e6f7ad3', '127.0.0.1', '内网IP', '[\"a9dfc8cbbad34aca9ca3c1849e6f7ad3\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 15:13:34', 7);
INSERT INTO `sys_oper_log` VALUES (146, '设备接入网关', 1, 'com.ruoyi.iot.controller.EdgeDeviceController.add()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDevice', '127.0.0.1', '内网IP', '{\"configuration\":\"{\\\"ip_address\\\":\\\"127.0.0.1\\\",\\\"port\\\":502,\\\"timeout\\\":1000,\\\"refresh_interval\\\":1000,\\\"slave_id\\\":0}\",\"createTime\":\"2026-06-26 16:13:26\",\"id\":\"modbus_local\",\"linkStatus\":\"offline\",\"name\":\"modbus_local\",\"params\":{},\"protocolId\":\"modbus\",\"status\":\"disable\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 16:13:26', 24);
INSERT INTO `sys_oper_log` VALUES (147, '网关数据点位', 1, 'com.ruoyi.iot.controller.EdgeDataPointController.add()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint', '127.0.0.1', '内网IP', '{\"config\":\"{\\\"register_type\\\":\\\"coil\\\",\\\"offset\\\":1,\\\"quantity\\\":1}\",\"createTime\":\"2026-06-26 16:14:05\",\"gatewayId\":\"modbus_local\",\"id\":\"2070420318954541056\",\"name\":\"modbus1\",\"operationTpye\":\"rw\",\"params\":{},\"protocolId\":\"modbus\",\"type\":\"int\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 16:14:05', 4);
INSERT INTO `sys_oper_log` VALUES (148, '设备', 1, 'com.ruoyi.iot.controller.DevicesController.add()', 'POST', 1, 'admin', '研发部门', '/iot/devices', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-06-26 16:17:34\",\"deviceType\":\"gatewayS\",\"gatewayId\":\"modbus_local\",\"id\":\"test\",\"name\":\"test\",\"params\":{},\"productId\":\"dimmer\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 16:17:34', 15);
INSERT INTO `sys_oper_log` VALUES (149, '设备属性模板', 1, 'com.ruoyi.iot.controller.DeviceBindingController.add()', 'POST', 1, 'admin', '研发部门', '/iot/binding', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-06-26 16:17:56\",\"dataType\":\"int\",\"deviceId\":\"test\",\"edgePointId\":\"2070420318954541056\",\"edgePointName\":\"modbus1\",\"gatewayId\":\"modbus_local\",\"gatewayName\":\"modbus_local\",\"id\":\"ac31d1d53f944fb78492d5dcc3133749\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"unitSymbol\":\"%\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 16:17:56', 38);
INSERT INTO `sys_oper_log` VALUES (150, '设备接入网关', 2, 'com.ruoyi.iot.controller.EdgeDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDevice', '127.0.0.1', '内网IP', '{\"configuration\":\"{\\\"ip_address\\\":\\\"127.0.0.1\\\",\\\"port\\\":502,\\\"timeout\\\":1000,\\\"refresh_interval\\\":1000,\\\"slave_id\\\":0}\",\"createBy\":\"\",\"createTime\":\"2026-06-26 16:13:26\",\"id\":\"modbus_local\",\"linkStatus\":\"offline\",\"name\":\"modbusaaaaaa\",\"params\":{},\"protocolId\":\"modbus\",\"status\":\"disable\",\"updateTime\":\"2026-06-26 16:20:12\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 16:20:12', 7);
INSERT INTO `sys_oper_log` VALUES (151, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/devices', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2026-06-26 16:17:34\",\"deviceType\":\"gatewayS\",\"gatewayId\":\"modbus_local\",\"id\":\"test\",\"name\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"updateTime\":\"2026-06-26 16:20:21\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 16:20:21', 7);
INSERT INTO `sys_oper_log` VALUES (152, '设备接入网关', 2, 'com.ruoyi.iot.controller.EdgeDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDevice', '127.0.0.1', '内网IP', '{\"configuration\":\"{\\\"ip_address\\\":\\\"127.0.0.1\\\",\\\"port\\\":502,\\\"timeout\\\":1000,\\\"refresh_interval\\\":1000,\\\"slave_id\\\":0}\",\"createBy\":\"\",\"createTime\":\"2026-06-26 16:13:26\",\"id\":\"modbus_local\",\"linkStatus\":\"offline\",\"name\":\"modbusLocal\",\"params\":{},\"protocolId\":\"modbus\",\"status\":\"disable\",\"updateTime\":\"2026-06-26 16:23:40\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 16:23:40', 10);
INSERT INTO `sys_oper_log` VALUES (153, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint', '127.0.0.1', '内网IP', '{\"config\":\"{\\\"register_type\\\":\\\"input\\\",\\\"offset\\\":1,\\\"quantity\\\":1}\",\"createBy\":\"\",\"createTime\":\"2026-06-26 16:14:05\",\"gatewayId\":\"modbus_local\",\"id\":\"2070420318954541056\",\"name\":\"modbus1\",\"operationTpye\":\"rw\",\"params\":{},\"protocolId\":\"modbus\",\"type\":\"int\",\"updateBy\":\"\",\"updateTime\":\"2026-06-26 16:59:44\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 16:59:44', 10);
INSERT INTO `sys_oper_log` VALUES (154, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"modbus_local\",\"id\":\"2070420318954541056\",\"params\":{},\"value\":\"1231\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置失败\",\"result\":false}}', 0, NULL, '2026-06-26 16:59:49', 10);
INSERT INTO `sys_oper_log` VALUES (155, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint', '127.0.0.1', '内网IP', '{\"config\":\"{\\\"register_type\\\":\\\"holding\\\",\\\"offset\\\":0,\\\"quantity\\\":1}\",\"createBy\":\"\",\"createTime\":\"2026-06-26 16:14:05\",\"gatewayId\":\"modbus_local\",\"id\":\"2070420318954541056\",\"name\":\"modbus1\",\"operationTpye\":\"rw\",\"params\":{},\"protocolId\":\"modbus\",\"type\":\"int\",\"updateBy\":\"\",\"updateTime\":\"2026-06-26 17:00:03\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 17:00:03', 9);
INSERT INTO `sys_oper_log` VALUES (156, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"modbus_local\",\"id\":\"2070420318954541056\",\"params\":{},\"value\":\"88\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-26 17:00:17', 3);
INSERT INTO `sys_oper_log` VALUES (157, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"modbus_local\",\"id\":\"2070420318954541056\",\"params\":{},\"value\":\"78\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-26 17:00:23', 1);
INSERT INTO `sys_oper_log` VALUES (158, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"modbus_local\",\"id\":\"2070420318954541056\",\"params\":{},\"value\":\"32\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-26 17:01:52', 0);
INSERT INTO `sys_oper_log` VALUES (159, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint', '127.0.0.1', '内网IP', '{\"config\":\"{\\\"register_type\\\":\\\"holding\\\",\\\"offset\\\":0,\\\"quantity\\\":2}\",\"createBy\":\"\",\"createTime\":\"2026-06-26 16:14:05\",\"gatewayId\":\"modbus_local\",\"id\":\"2070420318954541056\",\"name\":\"modbus1\",\"operationTpye\":\"rw\",\"params\":{},\"protocolId\":\"modbus\",\"type\":\"int\",\"updateBy\":\"\",\"updateTime\":\"2026-06-26 17:03:26\",\"value\":\"null\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 17:03:26', 9);
INSERT INTO `sys_oper_log` VALUES (160, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint', '127.0.0.1', '内网IP', '{\"config\":\"{\\\"register_type\\\":\\\"holding\\\",\\\"offset\\\":0,\\\"quantity\\\":1}\",\"createBy\":\"\",\"createTime\":\"2026-06-26 16:14:05\",\"gatewayId\":\"modbus_local\",\"id\":\"2070420318954541056\",\"name\":\"modbus1\",\"operationTpye\":\"rw\",\"params\":{},\"protocolId\":\"modbus\",\"type\":\"float\",\"updateBy\":\"\",\"updateTime\":\"2026-06-26 17:03:35\",\"value\":\"null\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 17:03:35', 8);
INSERT INTO `sys_oper_log` VALUES (161, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint', '127.0.0.1', '内网IP', '{\"config\":\"{\\\"register_type\\\":\\\"holding\\\",\\\"offset\\\":1,\\\"quantity\\\":1}\",\"createBy\":\"\",\"createTime\":\"2026-06-26 16:14:05\",\"gatewayId\":\"modbus_local\",\"id\":\"2070420318954541056\",\"name\":\"modbus1\",\"operationTpye\":\"rw\",\"params\":{},\"protocolId\":\"modbus\",\"type\":\"float\",\"updateBy\":\"\",\"updateTime\":\"2026-06-26 17:03:38\",\"value\":\"null\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 17:03:38', 11);
INSERT INTO `sys_oper_log` VALUES (162, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"modbus_local\",\"id\":\"2070420318954541056\",\"params\":{},\"value\":\"null\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置失败\",\"result\":false}}', 0, NULL, '2026-06-26 17:03:39', 2);
INSERT INTO `sys_oper_log` VALUES (163, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"modbus_local\",\"id\":\"2070420318954541056\",\"params\":{},\"value\":\"55\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-26 17:03:42', 1);
INSERT INTO `sys_oper_log` VALUES (164, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"modbus_local\",\"id\":\"2070420318954541056\",\"params\":{},\"value\":\"77\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-26 17:04:03', 0);
INSERT INTO `sys_oper_log` VALUES (165, '设备接入网关', 2, 'com.ruoyi.iot.controller.EdgeDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDevice', '127.0.0.1', '内网IP', '{\"configuration\":\"{\\\"ip_address\\\":\\\"127.0.0.1\\\",\\\"port\\\":502,\\\"timeout\\\":1000,\\\"refresh_interval\\\":1000,\\\"slave_id\\\":1}\",\"createBy\":\"\",\"createTime\":\"2026-06-26 16:13:26\",\"id\":\"modbus_local\",\"linkStatus\":\"online\",\"name\":\"modbusLocal\",\"params\":{},\"protocolId\":\"modbus\",\"status\":\"enable\",\"statusTime\":\"2026-06-26 17:09:47\",\"updateTime\":\"2026-06-26 17:10:03\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 17:10:03', 25);
INSERT INTO `sys_oper_log` VALUES (166, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint', '127.0.0.1', '内网IP', '{\"config\":\"{\\\"register_type\\\":\\\"holding\\\",\\\"offset\\\":0,\\\"quantity\\\":1}\",\"createBy\":\"\",\"createTime\":\"2026-06-26 16:14:05\",\"gatewayId\":\"modbus_local\",\"id\":\"2070420318954541056\",\"name\":\"modbus1\",\"operationTpye\":\"rw\",\"params\":{},\"protocolId\":\"modbus\",\"type\":\"float\",\"updateBy\":\"\",\"updateTime\":\"2026-06-26 17:10:16\",\"value\":\"null\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 17:10:16', 59);
INSERT INTO `sys_oper_log` VALUES (167, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"modbus_local\",\"id\":\"2070420318954541056\",\"params\":{},\"value\":\"78\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置失败\",\"result\":false}}', 0, NULL, '2026-06-26 17:10:20', 8);
INSERT INTO `sys_oper_log` VALUES (168, '设备接入网关', 2, 'com.ruoyi.iot.controller.EdgeDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDevice', '127.0.0.1', '内网IP', '{\"configuration\":\"{\\\"ip_address\\\":\\\"127.0.0.1\\\",\\\"port\\\":502,\\\"timeout\\\":1000,\\\"refresh_interval\\\":1000,\\\"slave_id\\\":1}\",\"createBy\":\"\",\"createTime\":\"2026-06-26 16:13:26\",\"id\":\"modbus_local\",\"linkStatus\":\"offline\",\"name\":\"modbusLocal\",\"params\":{},\"protocolId\":\"modbus\",\"status\":\"disable\",\"statusTime\":\"2026-06-26 17:10:39\",\"updateTime\":\"2026-06-26 17:10:50\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 17:10:50', 10);
INSERT INTO `sys_oper_log` VALUES (169, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint', '127.0.0.1', '内网IP', '{\"config\":\"{\\\"register_type\\\":\\\"holding\\\",\\\"offset\\\":0,\\\"quantity\\\":1}\",\"createBy\":\"\",\"createTime\":\"2026-06-26 16:14:05\",\"gatewayId\":\"modbus_local\",\"id\":\"2070420318954541056\",\"name\":\"modbus1\",\"operationTpye\":\"rw\",\"params\":{},\"protocolId\":\"modbus\",\"type\":\"int\",\"updateBy\":\"\",\"updateTime\":\"2026-06-26 17:11:05\",\"value\":\"null\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 17:11:05', 9);
INSERT INTO `sys_oper_log` VALUES (170, '网关数据点位', 5, 'com.ruoyi.iot.controller.EdgeDataPointController.export()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 1, 'Cannot invoke \"com.ruoyi.iot.domain.EdgeDevice.getProtocolId()\" because \"edgeDevice\" is null', '2026-06-26 17:12:52', 12);
INSERT INTO `sys_oper_log` VALUES (171, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint', '127.0.0.1', '内网IP', '{\"config\":\"{\\\"register_type\\\":\\\"holding\\\",\\\"offset\\\":0,\\\"quantity\\\":1}\",\"createBy\":\"\",\"createTime\":\"2026-06-26 16:14:05\",\"gatewayId\":\"modbus_local\",\"id\":\"2070420318954541056\",\"name\":\"modbus1\",\"operationTpye\":\"rw\",\"params\":{},\"protocolId\":\"modbus\",\"type\":\"int\",\"updateBy\":\"\",\"updateTime\":\"2026-06-26 17:13:00\",\"value\":\"null\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 17:13:00', 12);
INSERT INTO `sys_oper_log` VALUES (172, '网关数据点位', 5, 'com.ruoyi.iot.controller.EdgeDataPointController.export()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 1, 'Cannot invoke \"com.ruoyi.iot.domain.EdgeDevice.getProtocolId()\" because \"edgeDevice\" is null', '2026-06-26 17:13:03', 4);
INSERT INTO `sys_oper_log` VALUES (173, '网关数据点位', 5, 'com.ruoyi.iot.controller.EdgeDataPointController.export()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 1, 'Cannot invoke \"com.ruoyi.iot.domain.EdgeDevice.getProtocolId()\" because \"edgeDevice\" is null', '2026-06-26 17:13:42', 13981);
INSERT INTO `sys_oper_log` VALUES (174, '网关数据点位', 5, 'com.ruoyi.iot.controller.EdgeDataPointController.export()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 1, 'Cannot invoke \"com.ruoyi.iot.domain.EdgeDevice.getProtocolId()\" because \"edgeDevice\" is null', '2026-06-26 17:14:21', 28318);
INSERT INTO `sys_oper_log` VALUES (175, '网关数据点位', 5, 'com.ruoyi.iot.controller.EdgeDataPointController.export()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 1, 'Cannot invoke \"com.ruoyi.iot.domain.EdgeDevice.getProtocolId()\" because \"edgeDevice\" is null', '2026-06-26 17:14:21', 2751);
INSERT INTO `sys_oper_log` VALUES (176, '网关数据点位', 5, 'com.ruoyi.iot.controller.EdgeDataPointController.export()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 1, 'Cannot invoke \"com.ruoyi.iot.domain.EdgeDevice.getProtocolId()\" because \"edgeDevice\" is null', '2026-06-26 17:14:37', 6);
INSERT INTO `sys_oper_log` VALUES (177, '网关数据点位', 5, 'com.ruoyi.iot.controller.EdgeDataPointController.export()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 1, 'Cannot invoke \"com.ruoyi.iot.domain.EdgeDevice.getProtocolId()\" because \"edgeDevice\" is null', '2026-06-26 17:14:39', 6);
INSERT INTO `sys_oper_log` VALUES (178, '设备接入网关', 5, 'com.ruoyi.iot.controller.EdgeDeviceController.export()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDevice/export', '127.0.0.1', '内网IP', '{\"protocolId\":\"modbus\",\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2026-06-26 17:23:38', 941);
INSERT INTO `sys_oper_log` VALUES (179, '网关数据点位', 5, 'com.ruoyi.iot.controller.EdgeDataPointController.export()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\",\"gatewayId\":\"modbus_local\"}', NULL, 0, NULL, '2026-06-26 17:24:22', 834);
INSERT INTO `sys_oper_log` VALUES (180, '网关数据点位', 5, 'com.ruoyi.iot.controller.EdgeDataPointController.export()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\",\"gatewayId\":\"modbus_local\"}', NULL, 0, NULL, '2026-06-26 17:25:17', 699);
INSERT INTO `sys_oper_log` VALUES (181, '网关数据点位', 5, 'com.ruoyi.iot.controller.EdgeDataPointController.export()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\",\"gatewayId\":\"modbus_local\"}', NULL, 0, NULL, '2026-06-26 17:25:38', 55);
INSERT INTO `sys_oper_log` VALUES (182, '设备', 5, 'com.ruoyi.iot.controller.DevicesController.export()', 'POST', 1, 'admin', '研发部门', '/iot/devices/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2026-06-26 17:27:08', 67);
INSERT INTO `sys_oper_log` VALUES (183, '网关数据点位', 5, 'com.ruoyi.iot.controller.EdgeDataPointController.export()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 1, 'Cannot invoke \"com.ruoyi.iot.domain.EdgeDevice.getProtocolId()\" because \"edgeDevice\" is null', '2026-06-26 17:29:53', 22);
INSERT INTO `sys_oper_log` VALUES (184, '网关数据点位', 5, 'com.ruoyi.iot.controller.EdgeDataPointController.export()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\",\"gatewayId\":\"modbus_local\"}', NULL, 0, NULL, '2026-06-26 17:29:58', 918);
INSERT INTO `sys_oper_log` VALUES (185, '网关数据点位', 1, 'com.ruoyi.iot.controller.EdgeDataPointController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\",\"gatewayId\":\"modbus_local\"}', NULL, 1, '很抱歉，导入失败！共 1 条数据格式不正确，错误如下：<br/>0、网关：modbus_local，点位:modbus1 已存在', '2026-06-26 17:31:28', 1089);
INSERT INTO `sys_oper_log` VALUES (186, '网关数据点位', 5, 'com.ruoyi.iot.controller.EdgeDataPointController.export()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"50\",\"pageNum\":\"1\",\"gatewayId\":\"modbus_local\"}', NULL, 0, NULL, '2026-06-26 17:33:33', 1097);
INSERT INTO `sys_oper_log` VALUES (187, '设备属性模板', 1, 'com.ruoyi.iot.controller.DeviceBindingController.add()', 'POST', 1, 'admin', '研发部门', '/iot/binding', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-06-26 17:35:35\",\"dataType\":\"int\",\"deviceId\":\"test\",\"edgePointId\":\"2070439791132020736\",\"edgePointName\":\"modbus2\",\"gatewayId\":\"modbus_local\",\"gatewayName\":\"modbusLocal\",\"id\":\"372c42e6419c46279fe3ed4357a891ea\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.colorTemperature\",\"telemetryKey\":\"colorTemperature\",\"unitSymbol\":\"K\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 17:35:35', 31);
INSERT INTO `sys_oper_log` VALUES (188, '设备属性模板', 1, 'com.ruoyi.iot.controller.DeviceBindingController.add()', 'POST', 1, 'admin', '研发部门', '/iot/binding', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-06-26 17:35:39\",\"dataType\":\"boolean\",\"deviceId\":\"test\",\"edgePointId\":\"2070439791354318848\",\"edgePointName\":\"modbus8\",\"gatewayId\":\"modbus_local\",\"gatewayName\":\"modbusLocal\",\"id\":\"02fc7540291d44f9aeaef8a685f4f80b\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.power\",\"telemetryKey\":\"power\",\"unitSymbol\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 17:35:39', 13);
INSERT INTO `sys_oper_log` VALUES (189, '设备属性模板', 1, 'com.ruoyi.iot.controller.DeviceBindingController.add()', 'POST', 1, 'admin', '研发部门', '/iot/binding', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-06-26 17:35:43\",\"dataType\":\"enum\",\"deviceId\":\"test\",\"edgePointId\":\"2070420318954541056\",\"edgePointName\":\"modbus1\",\"gatewayId\":\"modbus_local\",\"gatewayName\":\"modbusLocal\",\"id\":\"6bfc2fcfc59e43b9a4550ee6500b8de0\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.status\",\"telemetryKey\":\"status\",\"unitSymbol\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-26 17:35:43', 10);
INSERT INTO `sys_oper_log` VALUES (190, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.status\",\"telemetryKey\":\"status\",\"value\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-26 17:35:56', 14);
INSERT INTO `sys_oper_log` VALUES (191, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.status\",\"telemetryKey\":\"status\",\"value\":\"\"} ', '{\"msg\":\"点位下置失败\",\"code\":500}', 0, NULL, '2026-06-26 17:36:00', 6);
INSERT INTO `sys_oper_log` VALUES (192, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.status\",\"telemetryKey\":\"status\",\"value\":\"15\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-26 17:36:05', 11);
INSERT INTO `sys_oper_log` VALUES (193, '设备', 5, 'com.ruoyi.iot.controller.DevicesController.export()', 'POST', 1, 'admin', '研发部门', '/iot/devices/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2026-06-27 14:40:22', 758);
INSERT INTO `sys_oper_log` VALUES (194, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/devices', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2026-06-26 16:17:34\",\"deviceType\":\"gatewayS\",\"gatewayId\":\"modbus_local\",\"groupId\":103,\"id\":\"test\",\"linkStatus\":\"online\",\"name\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"updateTime\":\"2026-06-27 14:42:24\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-27 14:42:24', 15);
INSERT INTO `sys_oper_log` VALUES (195, '产品信息', 5, 'com.ruoyi.iot.controller.ProductsController.export()', 'POST', 1, 'admin', '研发部门', '/iot/products/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2026-06-27 14:44:45', 51);
INSERT INTO `sys_oper_log` VALUES (196, '设备属性模板', 2, 'com.ruoyi.iot.controller.DeviceBindingController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/binding', '127.0.0.1', '内网IP', '{\"dataType\":\"int\",\"deviceId\":\"test\",\"edgePointId\":\"2070439791329153024\",\"edgePointName\":\"modbus7\",\"gatewayId\":\"modbus_local\",\"gatewayName\":\"modbusLocal\",\"id\":\"ac31d1d53f944fb78492d5dcc3133749\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"unitSymbol\":\"%\",\"updateTime\":\"2026-06-27 14:57:04\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-27 14:57:04', 22);
INSERT INTO `sys_oper_log` VALUES (197, '设备属性模板', 2, 'com.ruoyi.iot.controller.DeviceBindingController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/binding', '127.0.0.1', '内网IP', '{\"dataType\":\"int\",\"deviceId\":\"test\",\"edgePointId\":\"2070420318954541056\",\"edgePointName\":\"modbus1\",\"gatewayId\":\"modbus_local\",\"gatewayName\":\"modbusLocal\",\"id\":\"ac31d1d53f944fb78492d5dcc3133749\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"unitSymbol\":\"%\",\"updateTime\":\"2026-06-27 14:57:12\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-27 14:57:12', 11);
INSERT INTO `sys_oper_log` VALUES (198, '保存菜单排序', 2, 'com.ruoyi.web.controller.system.SysMenuController.updateSort()', 'PUT', 1, 'admin', '研发部门', '/system/menu/updateSort', '127.0.0.1', '内网IP', '{\"menuIds\":\"2152,2158\",\"orderNums\":\"2,3\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-27 14:58:13', 18);
INSERT INTO `sys_oper_log` VALUES (199, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-27 15:13:32', 63);
INSERT INTO `sys_oper_log` VALUES (200, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.status\",\"telemetryKey\":\"status\",\"value\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-27 15:14:08', 12);
INSERT INTO `sys_oper_log` VALUES (201, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.status\",\"telemetryKey\":\"status\",\"value\":\"2\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-27 15:14:11', 17);
INSERT INTO `sys_oper_log` VALUES (202, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.status\",\"telemetryKey\":\"status\",\"value\":\"3\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-27 15:14:24', 2);
INSERT INTO `sys_oper_log` VALUES (203, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"3\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-27 15:14:32', 15);
INSERT INTO `sys_oper_log` VALUES (204, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"88\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-27 15:14:36', 13);
INSERT INTO `sys_oper_log` VALUES (205, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-27 15:14:40', 7);
INSERT INTO `sys_oper_log` VALUES (206, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"2\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-27 15:14:44', 10);
INSERT INTO `sys_oper_log` VALUES (207, '产品物模型', 2, 'com.ruoyi.iot.controller.ProductTemplatesController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/productTemplates', '127.0.0.1', '内网IP', '{\"classify\":\"property\",\"createBy\":\"\",\"createTime\":\"2025-02-25 18:30:05\",\"define\":\"{\\\"id\\\":\\\"brightness\\\",\\\"name\\\":\\\"亮度值\\\",\\\"valueType\\\":{\\\"type\\\":\\\"int\\\",\\\"max\\\":102,\\\"min\\\":0,\\\"unit\\\":\\\"%\\\"}}\",\"description\":\"亮度值，范围从0%到100%\",\"id\":\"dimmer.brightness\",\"name\":\"亮度值\",\"operationTpye\":\"rw\",\"params\":{},\"productId\":\"dimmer\",\"telemetryKey\":\"brightness\",\"type\":\"int\",\"updateBy\":\"\",\"updateTime\":\"2026-06-27 15:16:45\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-27 15:16:45', 24);
INSERT INTO `sys_oper_log` VALUES (208, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.status\",\"telemetryKey\":\"status\",\"value\":\"3\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-27 15:23:17', 15);
INSERT INTO `sys_oper_log` VALUES (209, '产品物模型', 2, 'com.ruoyi.iot.controller.ProductTemplatesController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/productTemplates', '127.0.0.1', '内网IP', '{\"classify\":\"property\",\"createBy\":\"\",\"createTime\":\"2025-02-25 18:33:56\",\"define\":\"{\\\"id\\\":\\\"status\\\",\\\"name\\\":\\\"工作状态\\\",\\\"valueType\\\":{\\\"elements\\\":[{\\\"description\\\":\\\"正在运行\\\",\\\"text\\\":\\\"正在运行\\\",\\\"value\\\":\\\"1\\\"},{\\\"description\\\":\\\"无法运行\\\",\\\"text\\\":\\\"无法运行\\\",\\\"value\\\":\\\"2\\\"},{\\\"description\\\":\\\"未知\\\",\\\"text\\\":\\\"未知\\\",\\\"value\\\":\\\"3\\\"},{\\\"description\\\":\\\"超载\\\",\\\"text\\\":\\\"超载\\\",\\\"value\\\":\\\"4\\\"}],\\\"type\\\":\\\"enum\\\"}}\",\"description\":\"设备的工作状态（如：开，关，故障等）\",\"id\":\"dimmer.status\",\"name\":\"工作状态\",\"operationTpye\":\"r\",\"params\":{},\"productId\":\"dimmer\",\"telemetryKey\":\"status\",\"type\":\"enum\",\"updateBy\":\"\",\"updateTime\":\"2026-06-27 15:27:21\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-27 15:27:21', 7);
INSERT INTO `sys_oper_log` VALUES (210, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-27 15:27:33', 4);
INSERT INTO `sys_oper_log` VALUES (211, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"2\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-27 15:27:38', 11);
INSERT INTO `sys_oper_log` VALUES (212, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"disable\"}', '{\"msg\":\"停用成功\",\"code\":200}', 0, NULL, '2026-06-27 15:53:19', 9);
INSERT INTO `sys_oper_log` VALUES (213, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"enable\"}', '{\"msg\":\"启用成功\",\"code\":200}', 0, NULL, '2026-06-27 15:53:21', 9);
INSERT INTO `sys_oper_log` VALUES (214, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"disable\"}', '{\"msg\":\"停用成功\",\"code\":200}', 0, NULL, '2026-06-27 15:58:24', 10);
INSERT INTO `sys_oper_log` VALUES (215, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/products', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2025-03-04 21:48:20\",\"dataExpiration\":36500000,\"description\":\"dsc\",\"deviceType\":\"gatewayS\",\"id\":\"dimmer\",\"name\":\"照明控制\",\"params\":{},\"productCategoryId\":100,\"protocolId\":\"modbus\",\"status\":\"disable\",\"storageInterval\":1000,\"updateBy\":\"\",\"updateTime\":\"2026-06-27 15:58:31\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-27 15:58:31', 16);
INSERT INTO `sys_oper_log` VALUES (216, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"enable\"}', '{\"msg\":\"启用成功\",\"code\":200}', 0, NULL, '2026-06-27 15:58:32', 8);
INSERT INTO `sys_oper_log` VALUES (217, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"disable\"}', '{\"msg\":\"停用成功\",\"code\":200}', 0, NULL, '2026-06-27 15:58:52', 7);
INSERT INTO `sys_oper_log` VALUES (218, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"enable\"}', '{\"msg\":\"启用成功\",\"code\":200}', 0, NULL, '2026-06-27 15:59:06', 9);
INSERT INTO `sys_oper_log` VALUES (219, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"disable\"}', '{\"msg\":\"停用成功\",\"code\":200}', 0, NULL, '2026-06-27 15:59:08', 7);
INSERT INTO `sys_oper_log` VALUES (220, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"enable\"}', '{\"msg\":\"启用成功\",\"code\":200}', 0, NULL, '2026-06-27 15:59:26', 12);
INSERT INTO `sys_oper_log` VALUES (221, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"disable\"}', '{\"msg\":\"停用成功\",\"code\":200}', 0, NULL, '2026-06-27 16:00:36', 11);
INSERT INTO `sys_oper_log` VALUES (222, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"enable\"}', '{\"msg\":\"启用成功\",\"code\":200}', 0, NULL, '2026-06-27 16:00:57', 13);
INSERT INTO `sys_oper_log` VALUES (223, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"disable\"}', '{\"msg\":\"停用成功\",\"code\":200}', 0, NULL, '2026-06-27 16:02:00', 6944);
INSERT INTO `sys_oper_log` VALUES (224, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"enable\"}', '{\"msg\":\"启用成功\",\"code\":200}', 0, NULL, '2026-06-27 16:04:07', 19);
INSERT INTO `sys_oper_log` VALUES (225, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"disable\"}', '{\"msg\":\"停用成功\",\"code\":200}', 0, NULL, '2026-06-27 16:08:06', 16);
INSERT INTO `sys_oper_log` VALUES (226, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"enable\"}', '{\"msg\":\"启用成功\",\"code\":200}', 0, NULL, '2026-06-27 16:21:12', 104);
INSERT INTO `sys_oper_log` VALUES (227, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"disable\"}', '{\"msg\":\"停用成功\",\"code\":200}', 0, NULL, '2026-06-27 16:21:13', 20);
INSERT INTO `sys_oper_log` VALUES (228, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"enable\"}', '{\"msg\":\"启用成功\",\"code\":200}', 0, NULL, '2026-06-27 16:21:15', 16);
INSERT INTO `sys_oper_log` VALUES (229, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"102\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-27 18:51:32', 134);
INSERT INTO `sys_oper_log` VALUES (230, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.power\",\"telemetryKey\":\"colorTemperature\",\"value\":\"true\"} ', '{\"msg\":\"点位下置失败\",\"code\":500}', 0, NULL, '2026-06-27 19:28:23', 7);
INSERT INTO `sys_oper_log` VALUES (231, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"77\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-27 19:28:26', 27);
INSERT INTO `sys_oper_log` VALUES (232, '设备属性模板', 2, 'com.ruoyi.iot.controller.DeviceBindingController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/binding', '127.0.0.1', '内网IP', '{\"dataType\":\"int\",\"deviceId\":\"test\",\"edgePointId\":\"2070439791186546688\",\"edgePointName\":\"modbus3\",\"gatewayId\":\"modbus_local\",\"gatewayName\":\"modbusLocal\",\"id\":\"372c42e6419c46279fe3ed4357a891ea\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.colorTemperature\",\"telemetryKey\":\"colorTemperature\",\"unitSymbol\":\"K\",\"updateTime\":\"2026-06-27 19:28:34\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-27 19:28:34', 29);
INSERT INTO `sys_oper_log` VALUES (233, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"102\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-27 19:28:36', 3);
INSERT INTO `sys_oper_log` VALUES (234, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"80\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-27 19:28:39', 15);
INSERT INTO `sys_oper_log` VALUES (235, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.power\",\"telemetryKey\":\"power\",\"value\":\"false\"} ', '{\"msg\":\"点位下置失败\",\"code\":500}', 0, NULL, '2026-06-27 19:28:44', 2);
INSERT INTO `sys_oper_log` VALUES (236, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.power\",\"telemetryKey\":\"power\",\"value\":\"true\"} ', '{\"msg\":\"点位下置失败\",\"code\":500}', 0, NULL, '2026-06-27 19:28:47', 2);
INSERT INTO `sys_oper_log` VALUES (237, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"84\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-27 19:28:53', 12);
INSERT INTO `sys_oper_log` VALUES (238, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"94\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-27 19:29:25', 10);
INSERT INTO `sys_oper_log` VALUES (239, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"94\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-27 19:29:40', 16);
INSERT INTO `sys_oper_log` VALUES (240, '产品物模型', 2, 'com.ruoyi.iot.controller.ProductTemplatesController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/productTemplates', '127.0.0.1', '内网IP', '{\"classify\":\"property\",\"createBy\":\"\",\"createTime\":\"2025-02-25 18:33:08\",\"define\":\"{\\\"valueType\\\":{\\\"type\\\":\\\"int\\\",\\\"unit\\\":\\\"K\\\",\\\"min\\\":null,\\\"max\\\":null}}\",\"description\":\"\\\"色温值，单位为开尔文，范围为2000K到6500K\\\"\",\"id\":\"dimmer.colorTemperature\",\"name\":\"色温值\",\"operationTpye\":\"rw\",\"params\":{},\"productId\":\"dimmer\",\"telemetryKey\":\"colorTemperature\",\"type\":\"int\",\"updateBy\":\"\",\"updateTime\":\"2026-06-27 19:32:08\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-27 19:32:08', 36);
INSERT INTO `sys_oper_log` VALUES (241, '产品物模型', 2, 'com.ruoyi.iot.controller.ProductTemplatesController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/productTemplates', '127.0.0.1', '内网IP', '{\"classify\":\"property\",\"createBy\":\"\",\"createTime\":\"2025-02-25 18:32:21\",\"define\":\"{\\\"id\\\":\\\"power\\\",\\\"name\\\":\\\"亮度值\\\",\\\"valueType\\\":{\\\"type\\\":\\\"boolean\\\",\\\"trueText\\\":\\\"开启\\\",\\\"falseText\\\":\\\"关闭\\\",\\\"trueValue\\\":\\\"1\\\",\\\"falseValue\\\":\\\"0\\\"}}\",\"description\":\"设备的开关状态\",\"id\":\"dimmer.power\",\"name\":\"开关\",\"operationTpye\":\"rw\",\"params\":{},\"productId\":\"dimmer\",\"telemetryKey\":\"power\",\"type\":\"boolean\",\"updateBy\":\"\",\"updateTime\":\"2026-06-27 19:32:22\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-06-27 19:32:22', 5);
INSERT INTO `sys_oper_log` VALUES (242, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"disable\"}', '{\"msg\":\"停用成功\",\"code\":200}', 0, NULL, '2026-06-27 19:32:27', 14);
INSERT INTO `sys_oper_log` VALUES (243, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"enable\"}', '{\"msg\":\"启用成功\",\"code\":200}', 0, NULL, '2026-06-27 19:32:28', 9);
INSERT INTO `sys_oper_log` VALUES (244, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.colorTemperature\",\"telemetryKey\":\"colorTemperature\",\"value\":\"3712\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-27 19:32:45', 8);
INSERT INTO `sys_oper_log` VALUES (245, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"102\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-27 19:32:46', 1);
INSERT INTO `sys_oper_log` VALUES (246, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.colorTemperature\",\"telemetryKey\":\"colorTemperature\",\"value\":\"3712\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-27 19:32:47', 16);
INSERT INTO `sys_oper_log` VALUES (247, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.colorTemperature\",\"telemetryKey\":\"colorTemperature\",\"value\":\"88\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-27 19:33:03', 7);
INSERT INTO `sys_oper_log` VALUES (248, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"77\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-27 19:33:07', 183);
INSERT INTO `sys_oper_log` VALUES (249, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.power\",\"telemetryKey\":\"power\",\"value\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-27 19:33:09', 12);
INSERT INTO `sys_oper_log` VALUES (250, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.power\",\"telemetryKey\":\"power\",\"value\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-06-27 19:33:13', 17);
INSERT INTO `sys_oper_log` VALUES (251, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"disable\"}', '{\"msg\":\"停用成功\",\"code\":200}', 0, NULL, '2026-06-28 11:26:02', 53);
INSERT INTO `sys_oper_log` VALUES (252, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"electrical\",\"status\":\"disable\"}', '{\"msg\":\"停用成功\",\"code\":200}', 0, NULL, '2026-06-28 11:26:04', 9);
INSERT INTO `sys_oper_log` VALUES (253, '设备', 5, 'com.ruoyi.iot.controller.DevicesController.export()', 'POST', 1, 'admin', '研发部门', '/iot/devices/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2026-07-11 10:52:12', 1052);
INSERT INTO `sys_oper_log` VALUES (254, '设备', 3, 'com.ruoyi.iot.controller.DevicesController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/devices/test', '127.0.0.1', '内网IP', '[\"test\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-11 11:04:05', 35);
INSERT INTO `sys_oper_log` VALUES (255, '设备', 6, 'com.ruoyi.iot.controller.DevicesController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/devices/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', '{\"msg\":\"恭喜您，数据已全部导入成功！共 49 条，数据如下：<br/>1、设备 test1 导入成功<br/>2、设备 test2 导入成功<br/>3、设备 test3 导入成功<br/>4、设备 test4 导入成功<br/>5、设备 test5 导入成功<br/>6、设备 test6 导入成功<br/>7、设备 test7 导入成功<br/>8、设备 test8 导入成功<br/>9、设备 test9 导入成功<br/>10、设备 test10 导入成功<br/>11、设备 test11 导入成功<br/>12、设备 test12 导入成功<br/>13、设备 test13 导入成功<br/>14、设备 test14 导入成功<br/>15、设备 test15 导入成功<br/>16、设备 test16 导入成功<br/>17、设备 test17 导入成功<br/>18、设备 test18 导入成功<br/>19、设备 test19 导入成功<br/>20、设备 test20 导入成功<br/>21、设备 test21 导入成功<br/>22、设备 test22 导入成功<br/>23、设备 test23 导入成功<br/>24、设备 test24 导入成功<br/>25、设备 test25 导入成功<br/>26、设备 test26 导入成功<br/>27、设备 test27 导入成功<br/>28、设备 test28 导入成功<br/>29、设备 test29 导入成功<br/>30、设备 test30 导入成功<br/>31、设备 test31 导入成功<br/>32、设备 test32 导入成功<br/>33、设备 test33 导入成功<br/>34、设备 test34 导入成功<br/>35、设备 test35 导入成功<br/>36、设备 test36 导入成功<br/>37、设备 test37 导入成功<br/>38、设备 test38 导入成功<br/>39、设备 test39 导入成功<br/>40、设备 test40 导入成功<br/>41、设备 test41 导入成功<br/>42、设备 test42 导入成功<br/>43、设备 test43 导入成功<br/>44、设备 test44 导入成功<br/>45、设备 test45 导入成功<br/>46、设备 test46 导入成功<br/>47、设备 test47 导入成功<br/>48、设备 test48 导入成功<br/>49、设备 test49 导入成功\",\"code\":200}', 0, NULL, '2026-07-11 11:04:47', 419);
INSERT INTO `sys_oper_log` VALUES (256, '设备', 3, 'com.ruoyi.iot.controller.DevicesController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/devices/test1,test10,test11,test12,test13,test14,test15,test16,test17,test18,test19,test2,test20,test21,test22,test23,test24,test25,test26,test27,test28,test29,test3,test30,test31,test32,test33,test34,test35,test36,test37,test38,test39,test4,test40,t', '127.0.0.1', '内网IP', '[\"test1\",\"test10\",\"test11\",\"test12\",\"test13\",\"test14\",\"test15\",\"test16\",\"test17\",\"test18\",\"test19\",\"test2\",\"test20\",\"test21\",\"test22\",\"test23\",\"test24\",\"test25\",\"test26\",\"test27\",\"test28\",\"test29\",\"test3\",\"test30\",\"test31\",\"test32\",\"test33\",\"test34\",\"test35\",\"test36\",\"test37\",\"test38\",\"test39\",\"test4\",\"test40\",\"test41\",\"test42\",\"test43\",\"test44\",\"test45\",\"test46\",\"test47\",\"test48\",\"test49\",\"test5\",\"test6\",\"test7\",\"test8\",\"test9\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-11 11:09:23', 308);
INSERT INTO `sys_oper_log` VALUES (257, '设备', 6, 'com.ruoyi.iot.controller.DevicesController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/devices/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', '{\"msg\":\"恭喜您，数据已全部导入成功！共 49 条，数据如下：<br/>1、设备 test1 导入成功<br/>2、设备 test2 导入成功<br/>3、设备 test3 导入成功<br/>4、设备 test4 导入成功<br/>5、设备 test5 导入成功<br/>6、设备 test6 导入成功<br/>7、设备 test7 导入成功<br/>8、设备 test8 导入成功<br/>9、设备 test9 导入成功<br/>10、设备 test10 导入成功<br/>11、设备 test11 导入成功<br/>12、设备 test12 导入成功<br/>13、设备 test13 导入成功<br/>14、设备 test14 导入成功<br/>15、设备 test15 导入成功<br/>16、设备 test16 导入成功<br/>17、设备 test17 导入成功<br/>18、设备 test18 导入成功<br/>19、设备 test19 导入成功<br/>20、设备 test20 导入成功<br/>21、设备 test21 导入成功<br/>22、设备 test22 导入成功<br/>23、设备 test23 导入成功<br/>24、设备 test24 导入成功<br/>25、设备 test25 导入成功<br/>26、设备 test26 导入成功<br/>27、设备 test27 导入成功<br/>28、设备 test28 导入成功<br/>29、设备 test29 导入成功<br/>30、设备 test30 导入成功<br/>31、设备 test31 导入成功<br/>32、设备 test32 导入成功<br/>33、设备 test33 导入成功<br/>34、设备 test34 导入成功<br/>35、设备 test35 导入成功<br/>36、设备 test36 导入成功<br/>37、设备 test37 导入成功<br/>38、设备 test38 导入成功<br/>39、设备 test39 导入成功<br/>40、设备 test40 导入成功<br/>41、设备 test41 导入成功<br/>42、设备 test42 导入成功<br/>43、设备 test43 导入成功<br/>44、设备 test44 导入成功<br/>45、设备 test45 导入成功<br/>46、设备 test46 导入成功<br/>47、设备 test47 导入成功<br/>48、设备 test48 导入成功<br/>49、设备 test49 导入成功\",\"code\":200}', 0, NULL, '2026-07-11 11:09:28', 961);
INSERT INTO `sys_oper_log` VALUES (258, '设备', 3, 'com.ruoyi.iot.controller.DevicesController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/devices/test1,test10,test11,test12,test13,test14,test15,test16,test17,test18,test19,test2,test20,test21,test22,test23,test24,test25,test26,test27,test28,test29,test3,test30,test31,test32,test33,test34,test35,test36,test37,test38,test39,test4,test40,t', '127.0.0.1', '内网IP', '[\"test1\",\"test10\",\"test11\",\"test12\",\"test13\",\"test14\",\"test15\",\"test16\",\"test17\",\"test18\",\"test19\",\"test2\",\"test20\",\"test21\",\"test22\",\"test23\",\"test24\",\"test25\",\"test26\",\"test27\",\"test28\",\"test29\",\"test3\",\"test30\",\"test31\",\"test32\",\"test33\",\"test34\",\"test35\",\"test36\",\"test37\",\"test38\",\"test39\",\"test4\",\"test40\",\"test41\",\"test42\",\"test43\",\"test44\",\"test45\",\"test46\",\"test47\",\"test48\",\"test49\",\"test5\",\"test6\",\"test7\",\"test8\",\"test9\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-11 11:09:49', 195);
INSERT INTO `sys_oper_log` VALUES (259, '设备', 6, 'com.ruoyi.iot.controller.DevicesController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/devices/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', '{\"msg\":\"恭喜您，数据已全部导入成功！共 49 条，数据如下：<br/>1、设备 test1 导入成功<br/>2、设备 test2 导入成功<br/>3、设备 test3 导入成功<br/>4、设备 test4 导入成功<br/>5、设备 test5 导入成功<br/>6、设备 test6 导入成功<br/>7、设备 test7 导入成功<br/>8、设备 test8 导入成功<br/>9、设备 test9 导入成功<br/>10、设备 test10 导入成功<br/>11、设备 test11 导入成功<br/>12、设备 test12 导入成功<br/>13、设备 test13 导入成功<br/>14、设备 test14 导入成功<br/>15、设备 test15 导入成功<br/>16、设备 test16 导入成功<br/>17、设备 test17 导入成功<br/>18、设备 test18 导入成功<br/>19、设备 test19 导入成功<br/>20、设备 test20 导入成功<br/>21、设备 test21 导入成功<br/>22、设备 test22 导入成功<br/>23、设备 test23 导入成功<br/>24、设备 test24 导入成功<br/>25、设备 test25 导入成功<br/>26、设备 test26 导入成功<br/>27、设备 test27 导入成功<br/>28、设备 test28 导入成功<br/>29、设备 test29 导入成功<br/>30、设备 test30 导入成功<br/>31、设备 test31 导入成功<br/>32、设备 test32 导入成功<br/>33、设备 test33 导入成功<br/>34、设备 test34 导入成功<br/>35、设备 test35 导入成功<br/>36、设备 test36 导入成功<br/>37、设备 test37 导入成功<br/>38、设备 test38 导入成功<br/>39、设备 test39 导入成功<br/>40、设备 test40 导入成功<br/>41、设备 test41 导入成功<br/>42、设备 test42 导入成功<br/>43、设备 test43 导入成功<br/>44、设备 test44 导入成功<br/>45、设备 test45 导入成功<br/>46、设备 test46 导入成功<br/>47、设备 test47 导入成功<br/>48、设备 test48 导入成功<br/>49、设备 test49 导入成功\",\"code\":200}', 0, NULL, '2026-07-11 11:10:17', 24499);
INSERT INTO `sys_oper_log` VALUES (260, '设备', 3, 'com.ruoyi.iot.controller.DevicesController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/devices/test1,test10,test11,test12,test13,test14,test15,test16,test17,test18,test19,test2,test20,test21,test22,test23,test24,test25,test26,test27,test28,test29,test3,test30,test31,test32,test33,test34,test35,test36,test37,test38,test39,test4,test40,t', '127.0.0.1', '内网IP', '[\"test1\",\"test10\",\"test11\",\"test12\",\"test13\",\"test14\",\"test15\",\"test16\",\"test17\",\"test18\",\"test19\",\"test2\",\"test20\",\"test21\",\"test22\",\"test23\",\"test24\",\"test25\",\"test26\",\"test27\",\"test28\",\"test29\",\"test3\",\"test30\",\"test31\",\"test32\",\"test33\",\"test34\",\"test35\",\"test36\",\"test37\",\"test38\",\"test39\",\"test4\",\"test40\",\"test41\",\"test42\",\"test43\",\"test44\",\"test45\",\"test46\",\"test47\",\"test48\",\"test49\",\"test5\",\"test6\",\"test7\",\"test8\",\"test9\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-11 11:17:06', 210);
INSERT INTO `sys_oper_log` VALUES (261, '设备', 6, 'com.ruoyi.iot.controller.DevicesController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/devices/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', '{\"msg\":\"恭喜您，数据已全部导入成功！共 49 条，数据如下：<br/>1、设备 test1 导入成功<br/>2、设备 test2 导入成功<br/>3、设备 test3 导入成功<br/>4、设备 test4 导入成功<br/>5、设备 test5 导入成功<br/>6、设备 test6 导入成功<br/>7、设备 test7 导入成功<br/>8、设备 test8 导入成功<br/>9、设备 test9 导入成功<br/>10、设备 test10 导入成功<br/>11、设备 test11 导入成功<br/>12、设备 test12 导入成功<br/>13、设备 test13 导入成功<br/>14、设备 test14 导入成功<br/>15、设备 test15 导入成功<br/>16、设备 test16 导入成功<br/>17、设备 test17 导入成功<br/>18、设备 test18 导入成功<br/>19、设备 test19 导入成功<br/>20、设备 test20 导入成功<br/>21、设备 test21 导入成功<br/>22、设备 test22 导入成功<br/>23、设备 test23 导入成功<br/>24、设备 test24 导入成功<br/>25、设备 test25 导入成功<br/>26、设备 test26 导入成功<br/>27、设备 test27 导入成功<br/>28、设备 test28 导入成功<br/>29、设备 test29 导入成功<br/>30、设备 test30 导入成功<br/>31、设备 test31 导入成功<br/>32、设备 test32 导入成功<br/>33、设备 test33 导入成功<br/>34、设备 test34 导入成功<br/>35、设备 test35 导入成功<br/>36、设备 test36 导入成功<br/>37、设备 test37 导入成功<br/>38、设备 test38 导入成功<br/>39、设备 test39 导入成功<br/>40、设备 test40 导入成功<br/>41、设备 test41 导入成功<br/>42、设备 test42 导入成功<br/>43、设备 test43 导入成功<br/>44、设备 test44 导入成功<br/>45、设备 test45 导入成功<br/>46、设备 test46 导入成功<br/>47、设备 test47 导入成功<br/>48、设备 test48 导入成功<br/>49、设备 test49 导入成功\",\"code\":200}', 0, NULL, '2026-07-11 11:17:12', 1005);
INSERT INTO `sys_oper_log` VALUES (262, '设备', 3, 'com.ruoyi.iot.controller.DevicesController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/devices/test1,test10,test11,test12,test13,test14,test15,test16,test17,test18,test19,test2,test20,test21,test22,test23,test24,test25,test26,test27,test28,test29,test3,test30,test31,test32,test33,test34,test35,test36,test37,test38,test39,test4,test40,t', '127.0.0.1', '内网IP', '[\"test1\",\"test10\",\"test11\",\"test12\",\"test13\",\"test14\",\"test15\",\"test16\",\"test17\",\"test18\",\"test19\",\"test2\",\"test20\",\"test21\",\"test22\",\"test23\",\"test24\",\"test25\",\"test26\",\"test27\",\"test28\",\"test29\",\"test3\",\"test30\",\"test31\",\"test32\",\"test33\",\"test34\",\"test35\",\"test36\",\"test37\",\"test38\",\"test39\",\"test4\",\"test40\",\"test41\",\"test42\",\"test43\",\"test44\",\"test45\",\"test46\",\"test47\",\"test48\",\"test49\",\"test5\",\"test6\",\"test7\",\"test8\",\"test9\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-11 11:18:28', 310);
INSERT INTO `sys_oper_log` VALUES (263, '设备', 6, 'com.ruoyi.iot.controller.DevicesController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/devices/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', '{\"msg\":\"恭喜您，数据已全部导入成功！共 49 条，数据如下：<br/>1、设备 test1 导入成功<br/>2、设备 test2 导入成功<br/>3、设备 test3 导入成功<br/>4、设备 test4 导入成功<br/>5、设备 test5 导入成功<br/>6、设备 test6 导入成功<br/>7、设备 test7 导入成功<br/>8、设备 test8 导入成功<br/>9、设备 test9 导入成功<br/>10、设备 test10 导入成功<br/>11、设备 test11 导入成功<br/>12、设备 test12 导入成功<br/>13、设备 test13 导入成功<br/>14、设备 test14 导入成功<br/>15、设备 test15 导入成功<br/>16、设备 test16 导入成功<br/>17、设备 test17 导入成功<br/>18、设备 test18 导入成功<br/>19、设备 test19 导入成功<br/>20、设备 test20 导入成功<br/>21、设备 test21 导入成功<br/>22、设备 test22 导入成功<br/>23、设备 test23 导入成功<br/>24、设备 test24 导入成功<br/>25、设备 test25 导入成功<br/>26、设备 test26 导入成功<br/>27、设备 test27 导入成功<br/>28、设备 test28 导入成功<br/>29、设备 test29 导入成功<br/>30、设备 test30 导入成功<br/>31、设备 test31 导入成功<br/>32、设备 test32 导入成功<br/>33、设备 test33 导入成功<br/>34、设备 test34 导入成功<br/>35、设备 test35 导入成功<br/>36、设备 test36 导入成功<br/>37、设备 test37 导入成功<br/>38、设备 test38 导入成功<br/>39、设备 test39 导入成功<br/>40、设备 test40 导入成功<br/>41、设备 test41 导入成功<br/>42、设备 test42 导入成功<br/>43、设备 test43 导入成功<br/>44、设备 test44 导入成功<br/>45、设备 test45 导入成功<br/>46、设备 test46 导入成功<br/>47、设备 test47 导入成功<br/>48、设备 test48 导入成功<br/>49、设备 test49 导入成功\",\"code\":200}', 0, NULL, '2026-07-11 11:19:36', 62821);
INSERT INTO `sys_oper_log` VALUES (264, '设备', 6, 'com.ruoyi.iot.controller.DevicesController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/devices/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', '{\"msg\":\"恭喜您，数据已全部导入成功！共 49 条，数据如下：<br/>1、设备 test1 导入成功<br/>2、设备 test2 导入成功<br/>3、设备 test3 导入成功<br/>4、设备 test4 导入成功<br/>5、设备 test5 导入成功<br/>6、设备 test6 导入成功<br/>7、设备 test7 导入成功<br/>8、设备 test8 导入成功<br/>9、设备 test9 导入成功<br/>10、设备 test10 导入成功<br/>11、设备 test11 导入成功<br/>12、设备 test12 导入成功<br/>13、设备 test13 导入成功<br/>14、设备 test14 导入成功<br/>15、设备 test15 导入成功<br/>16、设备 test16 导入成功<br/>17、设备 test17 导入成功<br/>18、设备 test18 导入成功<br/>19、设备 test19 导入成功<br/>20、设备 test20 导入成功<br/>21、设备 test21 导入成功<br/>22、设备 test22 导入成功<br/>23、设备 test23 导入成功<br/>24、设备 test24 导入成功<br/>25、设备 test25 导入成功<br/>26、设备 test26 导入成功<br/>27、设备 test27 导入成功<br/>28、设备 test28 导入成功<br/>29、设备 test29 导入成功<br/>30、设备 test30 导入成功<br/>31、设备 test31 导入成功<br/>32、设备 test32 导入成功<br/>33、设备 test33 导入成功<br/>34、设备 test34 导入成功<br/>35、设备 test35 导入成功<br/>36、设备 test36 导入成功<br/>37、设备 test37 导入成功<br/>38、设备 test38 导入成功<br/>39、设备 test39 导入成功<br/>40、设备 test40 导入成功<br/>41、设备 test41 导入成功<br/>42、设备 test42 导入成功<br/>43、设备 test43 导入成功<br/>44、设备 test44 导入成功<br/>45、设备 test45 导入成功<br/>46、设备 test46 导入成功<br/>47、设备 test47 导入成功<br/>48、设备 test48 导入成功<br/>49、设备 test49 导入成功\",\"code\":200}', 0, NULL, '2026-07-11 11:45:15', 343);
INSERT INTO `sys_oper_log` VALUES (265, '设备', 3, 'com.ruoyi.iot.controller.DevicesController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/devices/test1,test10,test11,test12,test13,test14,test15,test16,test17,test18', '127.0.0.1', '内网IP', '[\"test1\",\"test10\",\"test11\",\"test12\",\"test13\",\"test14\",\"test15\",\"test16\",\"test17\",\"test18\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-11 13:56:13', 53);
INSERT INTO `sys_oper_log` VALUES (266, '设备', 3, 'com.ruoyi.iot.controller.DevicesController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/devices/test19,test2', '127.0.0.1', '内网IP', '[\"test19\",\"test2\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-11 13:56:15', 12);
INSERT INTO `sys_oper_log` VALUES (267, '设备', 1, 'com.ruoyi.iot.controller.DevicesController.add()', 'POST', 1, 'admin', '研发部门', '/iot/devices', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-07-11 13:56:25\",\"deviceType\":\"gatewayS\",\"gatewayId\":\"modbus_local\",\"id\":\"test1\",\"name\":\"test1\",\"params\":{},\"productId\":\"dimmer\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-11 13:56:25', 25);
INSERT INTO `sys_oper_log` VALUES (268, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/devices', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2026-07-11 13:56:26\",\"deviceType\":\"gatewayS\",\"gatewayId\":\"modbus_local\",\"id\":\"test1\",\"name\":\"aaaaa\",\"params\":{},\"productId\":\"dimmer\",\"updateTime\":\"2026-07-11 13:56:31\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-11 13:56:31', 8);
INSERT INTO `sys_oper_log` VALUES (269, '设备', 6, 'com.ruoyi.iot.controller.DevicesController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/devices/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', NULL, 1, '很抱歉，导入失败！共 1 条数据格式不正确，错误如下：<br/>1、设备 test1 已存在', '2026-07-11 13:56:38', 304);
INSERT INTO `sys_oper_log` VALUES (270, '设备', 3, 'com.ruoyi.iot.controller.DevicesController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/devices/test1', '127.0.0.1', '内网IP', '[\"test1\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-11 13:56:42', 8);
INSERT INTO `sys_oper_log` VALUES (271, '设备', 6, 'com.ruoyi.iot.controller.DevicesController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/devices/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', '{\"msg\":\"恭喜您，数据已全部导入成功！共 49 条，数据如下：<br/>1、设备 test1 导入成功<br/>2、设备 test2 导入成功<br/>3、设备 test3 导入成功<br/>4、设备 test4 导入成功<br/>5、设备 test5 导入成功<br/>6、设备 test6 导入成功<br/>7、设备 test7 导入成功<br/>8、设备 test8 导入成功<br/>9、设备 test9 导入成功<br/>10、设备 test10 导入成功<br/>11、设备 test11 导入成功<br/>12、设备 test12 导入成功<br/>13、设备 test13 导入成功<br/>14、设备 test14 导入成功<br/>15、设备 test15 导入成功<br/>16、设备 test16 导入成功<br/>17、设备 test17 导入成功<br/>18、设备 test18 导入成功<br/>19、设备 test19 导入成功<br/>20、设备 test20 导入成功<br/>21、设备 test21 导入成功<br/>22、设备 test22 导入成功<br/>23、设备 test23 导入成功<br/>24、设备 test24 导入成功<br/>25、设备 test25 导入成功<br/>26、设备 test26 导入成功<br/>27、设备 test27 导入成功<br/>28、设备 test28 导入成功<br/>29、设备 test29 导入成功<br/>30、设备 test30 导入成功<br/>31、设备 test31 导入成功<br/>32、设备 test32 导入成功<br/>33、设备 test33 导入成功<br/>34、设备 test34 导入成功<br/>35、设备 test35 导入成功<br/>36、设备 test36 导入成功<br/>37、设备 test37 导入成功<br/>38、设备 test38 导入成功<br/>39、设备 test39 导入成功<br/>40、设备 test40 导入成功<br/>41、设备 test41 导入成功<br/>42、设备 test42 导入成功<br/>43、设备 test43 导入成功<br/>44、设备 test44 导入成功<br/>45、设备 test45 导入成功<br/>46、设备 test46 导入成功<br/>47、设备 test47 导入成功<br/>48、设备 test48 导入成功<br/>49、设备 test49 导入成功\",\"code\":200}', 0, NULL, '2026-07-11 13:56:47', 220);
INSERT INTO `sys_oper_log` VALUES (272, '网关数据点位', 1, 'com.ruoyi.iot.controller.EdgeDataPointController.add()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint', '127.0.0.1', '内网IP', '{\"config\":\"{\\\"register_type\\\":\\\"coil\\\",\\\"offset\\\":1,\\\"quantity\\\":1}\",\"createTime\":\"2026-07-11 13:59:01\",\"gatewayId\":\"modbus_local\",\"id\":\"2075822148043284480\",\"name\":\"modbus01\",\"params\":{},\"protocolId\":\"modbus\",\"type\":\"int\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-11 13:59:01', 57);
INSERT INTO `sys_oper_log` VALUES (273, '网关数据点位', 3, 'com.ruoyi.iot.controller.EdgeDataPointController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/edgeDataPoint/2075822148043284480', '127.0.0.1', '内网IP', '[\"2075822148043284480\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-11 13:59:24', 5);
INSERT INTO `sys_oper_log` VALUES (274, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"energy_meter_reading_raw,energy_usage_bucket_task,sub_energy_items,energy_work_order,energy_usage_fact,energy_types,energy_topology_version,energy_meter_data_min,energy_meter_data_monthly,energy_meter_data_yearly,energy_reading_revision,energy_recalculation_job,energy_site,energy_factor_version,energy_item_data_daily,energy_item_data_hourly,energy_item_data_min,energy_item_data_monthly,energy_item_data_yearly,energy_line_data_daily,energy_line_data_hourly,energy_line_data_min,energy_line_data_monthly,energy_line_data_yearly,energy_meter_config_version,energy_meter_data_daily,energy_meter_data_hourly,energy_area_data_daily,energy_area_data_hourly,energy_area_data_min,energy_area_data_monthly,energy_area_data_yearly,energy_benchmark_results,energy_data_yearly,energy_data_monthly,energy_data_hourly,energy_data_daily,energy_billing_statement,energy_benchmarks,energy_allocation_result\",\"tplWebType\":\"element-plus\"}', NULL, 1, '导入失败：\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'function_name\' at row 1\r\n### The error may exist in file [D:\\workspace\\lightning\\lightning-generator\\target\\classes\\mapper\\generator\\GenTableMapper.xml]\r\n### The error may involve com.ruoyi.generator.mapper.GenTableMapper.insertGenTable-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into gen_table (     table_name,      table_comment,      class_name,           tpl_web_type,      package_name,      module_name,      business_name,      function_name,      function_author,                           create_by,     create_time          )values(     ?,      ?,      ?,           ?,      ?,      ?,      ?,      ?,      ?,                           ?,     sysdate()          )\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'function_name\' at row 1\n; Data truncation: Data too long for column \'function_name\' at row 1', '2026-07-14 10:13:17', 508);
INSERT INTO `sys_oper_log` VALUES (275, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"energy_meter_reading_raw,energy_usage_bucket_task,sub_energy_items,energy_work_order,energy_usage_fact,energy_types,energy_topology_version,energy_meter_data_min,energy_meter_data_monthly,energy_meter_data_yearly,energy_reading_revision,energy_recalculation_job,energy_site,energy_factor_version,energy_item_data_daily,energy_item_data_hourly,energy_item_data_min,energy_item_data_monthly,energy_item_data_yearly,energy_line_data_daily,energy_line_data_hourly,energy_line_data_min,energy_line_data_monthly,energy_line_data_yearly,energy_meter_config_version,energy_meter_data_daily,energy_meter_data_hourly,energy_area_data_daily,energy_area_data_hourly,energy_area_data_min,energy_area_data_monthly,energy_area_data_yearly,energy_benchmark_results,energy_data_yearly,energy_data_monthly,energy_data_hourly,energy_data_daily,energy_billing_statement,energy_benchmarks,energy_allocation_result\",\"tplWebType\":\"element-plus\"}', NULL, 1, '导入失败：\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'function_name\' at row 1\r\n### The error may exist in file [D:\\workspace\\lightning\\lightning-generator\\target\\classes\\mapper\\generator\\GenTableMapper.xml]\r\n### The error may involve com.ruoyi.generator.mapper.GenTableMapper.insertGenTable-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into gen_table (     table_name,      table_comment,      class_name,           tpl_web_type,      package_name,      module_name,      business_name,      function_name,      function_author,                           create_by,     create_time          )values(     ?,      ?,      ?,           ?,      ?,      ?,      ?,      ?,      ?,                           ?,     sysdate()          )\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'function_name\' at row 1\n; Data truncation: Data too long for column \'function_name\' at row 1', '2026-07-14 10:14:15', 119);
INSERT INTO `sys_oper_log` VALUES (276, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"energy_usage_fact\",\"tplWebType\":\"element-plus\"}', NULL, 1, '导入失败：\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'function_name\' at row 1\r\n### The error may exist in file [D:\\workspace\\lightning\\lightning-generator\\target\\classes\\mapper\\generator\\GenTableMapper.xml]\r\n### The error may involve com.ruoyi.generator.mapper.GenTableMapper.insertGenTable-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into gen_table (     table_name,      table_comment,      class_name,           tpl_web_type,      package_name,      module_name,      business_name,      function_name,      function_author,                           create_by,     create_time          )values(     ?,      ?,      ?,           ?,      ?,      ?,      ?,      ?,      ?,                           ?,     sysdate()          )\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'function_name\' at row 1\n; Data truncation: Data too long for column \'function_name\' at row 1', '2026-07-14 10:14:22', 4);
INSERT INTO `sys_oper_log` VALUES (277, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"energy_types\",\"tplWebType\":\"element-plus\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-14 10:14:29', 33);
INSERT INTO `sys_oper_log` VALUES (278, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"energy_usage_bucket_task,energy_usage_fact,energy_work_order,energy_meter_reading_raw,sub_energy_items,energy_topology_version,energy_meter_data_hourly,energy_meter_data_min,energy_meter_data_monthly,energy_meter_data_yearly,energy_reading_revision,energy_recalculation_job,energy_site,energy_factor_version,energy_item_data_daily,energy_item_data_hourly,energy_item_data_min,energy_item_data_monthly,energy_item_data_yearly,energy_line_data_daily,energy_line_data_hourly,energy_line_data_min,energy_line_data_monthly,energy_line_data_yearly,energy_meter_config_version,energy_meter_data_daily,energy_area_data_daily,energy_area_data_hourly,energy_area_data_min,energy_area_data_monthly,energy_area_data_yearly,energy_benchmark_results,energy_benchmarks,energy_data_yearly,energy_data_monthly,energy_data_hourly,energy_data_daily,energy_billing_statement,energy_allocation_result\",\"tplWebType\":\"element-plus\"}', NULL, 1, '导入失败：\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'function_name\' at row 1\r\n### The error may exist in file [D:\\workspace\\lightning\\lightning-generator\\target\\classes\\mapper\\generator\\GenTableMapper.xml]\r\n### The error may involve com.ruoyi.generator.mapper.GenTableMapper.insertGenTable-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into gen_table (     table_name,      table_comment,      class_name,           tpl_web_type,      package_name,      module_name,      business_name,      function_name,      function_author,                           create_by,     create_time          )values(     ?,      ?,      ?,           ?,      ?,      ?,      ?,      ?,      ?,                           ?,     sysdate()          )\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'function_name\' at row 1\n; Data truncation: Data too long for column \'function_name\' at row 1', '2026-07-14 10:16:53', 615);
INSERT INTO `sys_oper_log` VALUES (279, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/17', '127.0.0.1', '内网IP', '[17] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-14 10:19:54', 14);
INSERT INTO `sys_oper_log` VALUES (280, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"energy_reading_revision,energy_meter_config_version,energy_benchmark_results,energy_usage_bucket_task,energy_usage_fact,energy_work_order,energy_meter_reading_raw,sub_energy_items,energy_types,energy_topology_version,energy_meter_data_yearly,energy_recalculation_job,energy_site,energy_factor_version,energy_item_data_daily,energy_item_data_hourly,energy_item_data_min,energy_item_data_monthly,energy_item_data_yearly,energy_line_data_daily,energy_line_data_hourly,energy_line_data_min,energy_line_data_monthly,energy_line_data_yearly,energy_meter_data_daily,energy_meter_data_hourly,energy_meter_data_min,energy_meter_data_monthly,energy_area_data_daily,energy_area_data_hourly,energy_area_data_min,energy_data_hourly,energy_data_yearly,energy_data_monthly,energy_data_daily,energy_billing_statement,energy_benchmarks,energy_area_data_yearly,energy_area_data_monthly,energy_allocation_result\",\"tplWebType\":\"element-plus\"}', NULL, 1, '导入失败：\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'function_name\' at row 1\r\n### The error may exist in file [D:\\workspace\\lightning\\lightning-generator\\target\\classes\\mapper\\generator\\GenTableMapper.xml]\r\n### The error may involve com.ruoyi.generator.mapper.GenTableMapper.insertGenTable-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into gen_table (     table_name,      table_comment,      class_name,           tpl_web_type,      package_name,      module_name,      business_name,      function_name,      function_author,                           create_by,     create_time          )values(     ?,      ?,      ?,           ?,      ?,      ?,      ?,      ?,      ?,                           ?,     sysdate()          )\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'function_name\' at row 1\n; Data truncation: Data too long for column \'function_name\' at row 1', '2026-07-14 10:20:00', 107);
INSERT INTO `sys_oper_log` VALUES (281, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"energy_benchmarks\",\"tplWebType\":\"element-plus\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-14 10:21:21', 23);
INSERT INTO `sys_oper_log` VALUES (282, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/34', '127.0.0.1', '内网IP', '[34] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-14 10:21:23', 9);
INSERT INTO `sys_oper_log` VALUES (283, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"energy_reading_revision,energy_meter_config_version,energy_benchmark_results,energy_usage_bucket_task,energy_usage_fact,energy_work_order,energy_meter_reading_raw,sub_energy_items,energy_types,energy_topology_version,energy_meter_data_yearly,energy_recalculation_job,energy_site,energy_factor_version,energy_item_data_daily,energy_item_data_hourly,energy_item_data_min,energy_item_data_monthly,energy_item_data_yearly,energy_line_data_daily,energy_line_data_hourly,energy_line_data_min,energy_line_data_monthly,energy_line_data_yearly,energy_meter_data_daily,energy_meter_data_hourly,energy_meter_data_min,energy_meter_data_monthly,energy_area_data_daily,energy_area_data_hourly,energy_area_data_min,energy_data_hourly,energy_data_yearly,energy_data_monthly,energy_data_daily,energy_billing_statement,energy_benchmarks,energy_area_data_yearly,energy_area_data_monthly,energy_allocation_result\",\"tplWebType\":\"element-plus\"}', NULL, 1, '导入失败：\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'function_name\' at row 1\r\n### The error may exist in file [D:\\workspace\\lightning\\lightning-generator\\target\\classes\\mapper\\generator\\GenTableMapper.xml]\r\n### The error may involve com.ruoyi.generator.mapper.GenTableMapper.insertGenTable-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into gen_table (     table_name,      table_comment,      class_name,           tpl_web_type,      package_name,      module_name,      business_name,      function_name,      function_author,                           create_by,     create_time          )values(     ?,      ?,      ?,           ?,      ?,      ?,      ?,      ?,      ?,                           ?,     sysdate()          )\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'function_name\' at row 1\n; Data truncation: Data too long for column \'function_name\' at row 1', '2026-07-14 10:21:29', 115);
INSERT INTO `sys_oper_log` VALUES (284, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"energy_reading_revision,energy_meter_config_version,energy_benchmark_results,energy_usage_bucket_task,energy_usage_fact,energy_work_order,energy_meter_reading_raw,sub_energy_items,energy_types,energy_topology_version,energy_meter_data_yearly,energy_recalculation_job,energy_site,energy_factor_version,energy_item_data_daily,energy_item_data_hourly,energy_item_data_min,energy_item_data_monthly,energy_item_data_yearly,energy_line_data_daily,energy_line_data_hourly,energy_line_data_min,energy_line_data_monthly,energy_line_data_yearly,energy_meter_data_daily,energy_meter_data_hourly,energy_meter_data_min,energy_meter_data_monthly,energy_area_data_daily,energy_area_data_hourly,energy_area_data_min,energy_data_hourly,energy_data_yearly,energy_data_monthly,energy_data_daily,energy_billing_statement,energy_benchmarks,energy_area_data_yearly,energy_area_data_monthly,energy_allocation_result\",\"tplWebType\":\"element-plus\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-14 10:22:42', 449);
INSERT INTO `sys_oper_log` VALUES (285, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"meterDaily\",\"className\":\"EnergyMeterDataDaily\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键ID\",\"columnId\":946,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-14 10:22:42\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":68,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"MeterId\",\"columnComment\":\"计量设备ID\",\"columnId\":947,\"columnName\":\"meter_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-14 10:22:42\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"meterId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":68,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"DataDate\",\"columnComment\":\"日期\",\"columnId\":948,\"columnName\":\"data_date\",\"columnType\":\"date\",\"createBy\":\"admin\",\"createTime\":\"2026-07-14 10:22:42\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"dataDate\",\"javaType\":\"Date\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":68,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Consumption\",\"columnComment\":\"日用量\",\"columnId\":949,\"columnName\":\"consumption\",\"columnType\":\"decimal(15,6)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-14 10:22:42\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-14 10:40:29', 37);
INSERT INTO `sys_oper_log` VALUES (286, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"meterDaily\",\"className\":\"EnergyMeterDataDaily\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键ID\",\"columnId\":946,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-14 10:22:42\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":68,\"updateBy\":\"\",\"updateTime\":\"2026-07-14 10:40:29\",\"usableColumn\":false},{\"capJavaField\":\"MeterId\",\"columnComment\":\"计量设备ID\",\"columnId\":947,\"columnName\":\"meter_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-14 10:22:42\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"meterId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":68,\"updateBy\":\"\",\"updateTime\":\"2026-07-14 10:40:29\",\"usableColumn\":false},{\"capJavaField\":\"DataDate\",\"columnComment\":\"日期\",\"columnId\":948,\"columnName\":\"data_date\",\"columnType\":\"date\",\"createBy\":\"admin\",\"createTime\":\"2026-07-14 10:22:42\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"dataDate\",\"javaType\":\"Date\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":68,\"updateBy\":\"\",\"updateTime\":\"2026-07-14 10:40:29\",\"usableColumn\":false},{\"capJavaField\":\"Consumption\",\"columnComment\":\"日用量\",\"columnId\":949,\"columnName\":\"consumption\",\"columnType\":\"decimal(15,6)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-14 10:22:42\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-14 10:40:50', 19);
INSERT INTO `sys_oper_log` VALUES (287, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"sub_energy_items,energy_line_data_monthly,energy_line_data_yearly,energy_meter_config_version,energy_meter_data_daily,energy_meter_data_hourly,energy_meter_data_min,energy_meter_data_monthly,energy_meter_data_yearly,energy_meter_reading_raw,energy_reading_revision,energy_recalculation_job,energy_site,energy_topology_version,energy_types,energy_usage_bucket_task,energy_usage_fact,energy_work_order,energy_item_data_yearly,energy_line_data_daily,energy_allocation_result,energy_line_data_min,energy_area_data_daily,energy_area_data_hourly,energy_area_data_min,energy_area_data_monthly,energy_area_data_yearly,energy_benchmark_results,energy_benchmarks,energy_billing_statement,energy_data_daily,energy_data_hourly,energy_data_monthly,energy_data_yearly,energy_factor_version,energy_item_data_daily,energy_item_data_hourly,energy_item_data_min,energy_item_data_monthly,energy_line_data_hourly\"}', NULL, 0, NULL, '2026-07-14 10:42:11', 2189);
INSERT INTO `sys_oper_log` VALUES (288, '设备属性模板', 1, 'com.ruoyi.iot.controller.DeviceBindingController.add()', 'POST', 1, 'admin', '研发部门', '/iot/binding', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-07-14 20:53:07\",\"dataType\":\"int\",\"deviceId\":\"test1\",\"edgePointId\":\"2070420318954541056\",\"edgePointName\":\"modbus1\",\"gatewayId\":\"modbus_local\",\"gatewayName\":\"modbusLocal\",\"id\":\"c8704053a98b4eea9dd382f325221319\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"unitSymbol\":\"%\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-14 20:53:07', 23);
INSERT INTO `sys_oper_log` VALUES (289, '设备属性模板', 1, 'com.ruoyi.iot.controller.DeviceBindingController.add()', 'POST', 1, 'admin', '研发部门', '/iot/binding', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-07-14 20:53:09\",\"dataType\":\"int\",\"deviceId\":\"test1\",\"edgePointId\":\"2070439791132020736\",\"edgePointName\":\"modbus2\",\"gatewayId\":\"modbus_local\",\"gatewayName\":\"modbusLocal\",\"id\":\"08b81007af324d4d91a863a6269494c9\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.colorTemperature\",\"telemetryKey\":\"colorTemperature\",\"unitSymbol\":\"K\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-14 20:53:09', 9);
INSERT INTO `sys_oper_log` VALUES (290, '设备属性模板', 1, 'com.ruoyi.iot.controller.DeviceBindingController.add()', 'POST', 1, 'admin', '研发部门', '/iot/binding', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-07-14 20:53:12\",\"dataType\":\"boolean\",\"deviceId\":\"test1\",\"edgePointId\":\"2070439791186546688\",\"edgePointName\":\"modbus3\",\"gatewayId\":\"modbus_local\",\"gatewayName\":\"modbusLocal\",\"id\":\"4b48f4c1123148e0b553056b1f636b31\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.power\",\"telemetryKey\":\"power\",\"unitSymbol\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-14 20:53:12', 9);
INSERT INTO `sys_oper_log` VALUES (291, '设备属性模板', 1, 'com.ruoyi.iot.controller.DeviceBindingController.add()', 'POST', 1, 'admin', '研发部门', '/iot/binding', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-07-14 20:53:14\",\"dataType\":\"enum\",\"deviceId\":\"test1\",\"edgePointId\":\"2070439791224295424\",\"edgePointName\":\"modbus4\",\"gatewayId\":\"modbus_local\",\"gatewayName\":\"modbusLocal\",\"id\":\"e16efb52ed6e4c2999533cea0095955e\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.status\",\"telemetryKey\":\"status\",\"unitSymbol\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-14 20:53:14', 10);
INSERT INTO `sys_oper_log` VALUES (292, '设备', 5, 'com.ruoyi.iot.controller.DevicesController.export()', 'POST', 1, 'admin', '研发部门', '/iot/devices/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"50\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2026-07-14 21:01:42', 507);
INSERT INTO `sys_oper_log` VALUES (293, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"enable\"}', '{\"msg\":\"启用成功\",\"code\":200}', 0, NULL, '2026-07-14 21:18:24', 30);
INSERT INTO `sys_oper_log` VALUES (294, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"disable\"}', '{\"msg\":\"停用成功\",\"code\":200}', 0, NULL, '2026-07-14 21:18:26', 9);
INSERT INTO `sys_oper_log` VALUES (295, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"telemetryKey\":\"brightness\",\"value\":\"11\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-14 21:29:15', 20);
INSERT INTO `sys_oper_log` VALUES (296, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"telemetryKey\":\"brightness\",\"value\":\"14\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-14 21:29:23', 8);
INSERT INTO `sys_oper_log` VALUES (297, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"telemetryKey\":\"brightness\",\"value\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-14 21:29:25', 11);
INSERT INTO `sys_oper_log` VALUES (298, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"telemetryKey\":\"brightness\",\"value\":\"15\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-14 21:30:11', 7);
INSERT INTO `sys_oper_log` VALUES (299, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"telemetryKey\":\"brightness\",\"value\":\"16\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-14 21:30:13', 10);
INSERT INTO `sys_oper_log` VALUES (300, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"telemetryKey\":\"brightness\",\"value\":\"6\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-14 21:30:15', 63);
INSERT INTO `sys_oper_log` VALUES (301, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"telemetryKey\":\"brightness\",\"value\":\"25\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-14 21:31:05', 9);
INSERT INTO `sys_oper_log` VALUES (302, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"telemetryKey\":\"brightness\",\"value\":\"2720\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-14 21:31:08', 12);
INSERT INTO `sys_oper_log` VALUES (303, '设备属性模板', 5, 'com.ruoyi.iot.controller.DeviceBindingController.export()', 'POST', 1, 'admin', '研发部门', '/iot/binding/export', '127.0.0.1', '内网IP', '{\"params\":{}} ', NULL, 0, NULL, '2026-07-14 21:31:24', 459);
INSERT INTO `sys_oper_log` VALUES (304, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"telemetryKey\":\"brightness\",\"value\":\"25\"} ', '{\"msg\":\"边缘网关未连接\",\"code\":500}', 0, NULL, '2026-07-15 11:01:25', 5);
INSERT INTO `sys_oper_log` VALUES (305, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/products', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2025-03-04 21:48:20\",\"dataExpiration\":36500000,\"description\":\"dsc\",\"deviceType\":\"gatewayS\",\"id\":\"dimmer\",\"name\":\"照明控制\",\"params\":{},\"productCategoryId\":100,\"protocolId\":\"modbus\",\"status\":\"disable\",\"storageInterval\":1000,\"updateBy\":\"\",\"updateTime\":\"2026-07-15 12:30:59\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-15 12:30:59', 22);
INSERT INTO `sys_oper_log` VALUES (306, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"enable\"}', '{\"msg\":\"启用成功\",\"code\":200}', 0, NULL, '2026-07-15 12:31:00', 12);
INSERT INTO `sys_oper_log` VALUES (307, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"electrical\",\"status\":\"enable\"}', '{\"msg\":\"启用成功\",\"code\":200}', 0, NULL, '2026-07-15 12:31:01', 10);
INSERT INTO `sys_oper_log` VALUES (308, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/sub_energy_items', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:21:40', 43);
INSERT INTO `sys_oper_log` VALUES (309, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_line_data_monthly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:21:43', 36);
INSERT INTO `sys_oper_log` VALUES (310, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_line_data_yearly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:21:46', 23);
INSERT INTO `sys_oper_log` VALUES (311, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_config_version', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:21:49', 41);
INSERT INTO `sys_oper_log` VALUES (312, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_data_daily', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:21:50', 32);
INSERT INTO `sys_oper_log` VALUES (313, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_data_hourly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:21:52', 22);
INSERT INTO `sys_oper_log` VALUES (314, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_data_min', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:21:54', 24);
INSERT INTO `sys_oper_log` VALUES (315, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_data_hourly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:21:58', 21);
INSERT INTO `sys_oper_log` VALUES (316, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_data_min', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:22:00', 23);
INSERT INTO `sys_oper_log` VALUES (317, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_data_monthly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:22:02', 33);
INSERT INTO `sys_oper_log` VALUES (318, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_data_yearly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:22:03', 21);
INSERT INTO `sys_oper_log` VALUES (319, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_reading_raw', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:22:05', 30);
INSERT INTO `sys_oper_log` VALUES (320, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_reading_revision', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:22:08', 30);
INSERT INTO `sys_oper_log` VALUES (321, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_recalculation_job', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:22:10', 27);
INSERT INTO `sys_oper_log` VALUES (322, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_site', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:22:11', 22);
INSERT INTO `sys_oper_log` VALUES (323, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_types', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:22:13', 20);
INSERT INTO `sys_oper_log` VALUES (324, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_line_data_hourly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:22:16', 20);
INSERT INTO `sys_oper_log` VALUES (325, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_item_data_min', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:22:19', 18);
INSERT INTO `sys_oper_log` VALUES (326, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_item_data_monthly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:22:21', 28);
INSERT INTO `sys_oper_log` VALUES (327, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_item_data_daily', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:22:25', 23);
INSERT INTO `sys_oper_log` VALUES (328, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_data_yearly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:22:27', 19);
INSERT INTO `sys_oper_log` VALUES (329, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_data_monthly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:22:30', 27);
INSERT INTO `sys_oper_log` VALUES (330, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_data_hourly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:22:31', 18);
INSERT INTO `sys_oper_log` VALUES (331, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_data_daily', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:22:34', 25);
INSERT INTO `sys_oper_log` VALUES (332, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_site', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:22:43', 18);
INSERT INTO `sys_oper_log` VALUES (333, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_site', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:22:44', 17);
INSERT INTO `sys_oper_log` VALUES (334, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"sub_energy_items,energy_line_data_monthly,energy_line_data_yearly,energy_meter_config_version,energy_meter_data_daily,energy_meter_data_hourly,energy_meter_data_min,energy_meter_data_monthly,energy_meter_data_yearly,energy_meter_reading_raw,energy_reading_revision,energy_recalculation_job,energy_site,energy_topology_version,energy_types,energy_usage_bucket_task,energy_usage_fact,energy_work_order,energy_item_data_yearly,energy_line_data_daily,energy_allocation_result,energy_line_data_min,energy_area_data_daily,energy_area_data_hourly,energy_area_data_min,energy_area_data_monthly,energy_area_data_yearly,energy_benchmark_results,energy_benchmarks,energy_billing_statement,energy_data_daily,energy_data_hourly,energy_data_monthly,energy_data_yearly,energy_factor_version,energy_item_data_daily,energy_item_data_hourly,energy_item_data_min,energy_item_data_monthly,energy_line_data_hourly\"}', NULL, 0, NULL, '2026-07-16 10:22:51', 824);
INSERT INTO `sys_oper_log` VALUES (335, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_line_data_yearly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:02', 25);
INSERT INTO `sys_oper_log` VALUES (336, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_data_min', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:03', 18);
INSERT INTO `sys_oper_log` VALUES (337, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_data_daily', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:06', 21);
INSERT INTO `sys_oper_log` VALUES (338, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_reading_revision', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:07', 21);
INSERT INTO `sys_oper_log` VALUES (339, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_data_monthly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:07', 22);
INSERT INTO `sys_oper_log` VALUES (340, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_data_hourly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:08', 18);
INSERT INTO `sys_oper_log` VALUES (341, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/sub_energy_items', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:08', 15);
INSERT INTO `sys_oper_log` VALUES (342, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_reading_raw', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:09', 24);
INSERT INTO `sys_oper_log` VALUES (343, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_config_version', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:10', 27);
INSERT INTO `sys_oper_log` VALUES (344, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_data_yearly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:10', 17);
INSERT INTO `sys_oper_log` VALUES (345, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_data_min', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:11', 15);
INSERT INTO `sys_oper_log` VALUES (346, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_line_data_yearly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:11', 16);
INSERT INTO `sys_oper_log` VALUES (347, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_reading_revision', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:15', 22);
INSERT INTO `sys_oper_log` VALUES (348, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_recalculation_job', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:15', 20);
INSERT INTO `sys_oper_log` VALUES (349, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_site', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:16', 16);
INSERT INTO `sys_oper_log` VALUES (350, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_topology_version', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:16', 20);
INSERT INTO `sys_oper_log` VALUES (351, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_types', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:17', 19);
INSERT INTO `sys_oper_log` VALUES (352, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_usage_bucket_task', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:18', 17);
INSERT INTO `sys_oper_log` VALUES (353, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_usage_fact', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:18', 25);
INSERT INTO `sys_oper_log` VALUES (354, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_work_order', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:19', 19);
INSERT INTO `sys_oper_log` VALUES (355, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_item_data_yearly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:19', 15);
INSERT INTO `sys_oper_log` VALUES (356, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_line_data_daily', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:20', 21);
INSERT INTO `sys_oper_log` VALUES (357, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_allocation_result', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:22', 22);
INSERT INTO `sys_oper_log` VALUES (358, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_line_data_min', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:23', 19);
INSERT INTO `sys_oper_log` VALUES (359, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_area_data_daily', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:24', 24);
INSERT INTO `sys_oper_log` VALUES (360, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_area_data_hourly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:24', 18);
INSERT INTO `sys_oper_log` VALUES (361, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_area_data_min', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:25', 16);
INSERT INTO `sys_oper_log` VALUES (362, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_area_data_monthly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:25', 22);
INSERT INTO `sys_oper_log` VALUES (363, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_area_data_yearly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:26', 15);
INSERT INTO `sys_oper_log` VALUES (364, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_benchmark_results', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:26', 19);
INSERT INTO `sys_oper_log` VALUES (365, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_benchmark_results', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:27', 20);
INSERT INTO `sys_oper_log` VALUES (366, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_benchmarks', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:28', 22);
INSERT INTO `sys_oper_log` VALUES (367, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_billing_statement', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:29', 25);
INSERT INTO `sys_oper_log` VALUES (368, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_data_daily', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:32', 19);
INSERT INTO `sys_oper_log` VALUES (369, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_data_hourly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:32', 17);
INSERT INTO `sys_oper_log` VALUES (370, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_data_monthly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:33', 26);
INSERT INTO `sys_oper_log` VALUES (371, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_data_yearly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:34', 19);
INSERT INTO `sys_oper_log` VALUES (372, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_factor_version', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:35', 17);
INSERT INTO `sys_oper_log` VALUES (373, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_item_data_daily', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:36', 20);
INSERT INTO `sys_oper_log` VALUES (374, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_item_data_hourly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:37', 18);
INSERT INTO `sys_oper_log` VALUES (375, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_item_data_min', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:38', 17);
INSERT INTO `sys_oper_log` VALUES (376, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_item_data_monthly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:39', 23);
INSERT INTO `sys_oper_log` VALUES (377, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_line_data_hourly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:23:40', 18);
INSERT INTO `sys_oper_log` VALUES (378, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/73', '127.0.0.1', '内网IP', '[73] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:38:52', 15);
INSERT INTO `sys_oper_log` VALUES (379, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2177', '127.0.0.1', '内网IP', '2177 ', '{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}', 0, NULL, '2026-07-16 10:41:10', 2);
INSERT INTO `sys_oper_log` VALUES (380, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"sub_energy_items,energy_line_data_monthly,energy_line_data_yearly,energy_meter_config_version,energy_meter_data_daily,energy_meter_data_hourly,energy_meter_data_min,energy_meter_data_monthly,energy_meter_data_yearly,energy_reading_revision,energy_recalculation_job,energy_site,energy_topology_version,energy_types,energy_usage_bucket_task,energy_usage_fact,energy_work_order,energy_item_data_monthly,energy_item_data_yearly,energy_allocation_result,energy_line_data_hourly,energy_line_data_min,energy_area_data_daily,energy_area_data_hourly,energy_area_data_min,energy_area_data_monthly,energy_area_data_yearly,energy_benchmark_results,energy_benchmarks,energy_billing_statement,energy_data_daily,energy_data_hourly,energy_data_monthly,energy_data_yearly,energy_factor_version,energy_item_data_daily,energy_item_data_hourly,energy_item_data_min,energy_line_data_daily\"}', NULL, 0, NULL, '2026-07-16 10:47:16', 619);
INSERT INTO `sys_oper_log` VALUES (381, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"subEnergyItem\",\"className\":\"SubEnergyItems\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键\",\"columnId\":1141,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-14 10:22:42\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":82,\"updateBy\":\"\",\"updateTime\":\"2026-07-16 10:23:08\",\"usableColumn\":false},{\"capJavaField\":\"ParentId\",\"columnComment\":\"父类ID\",\"columnId\":1142,\"columnName\":\"parent_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-14 10:22:42\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"parentId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":true,\"tableId\":82,\"updateBy\":\"\",\"updateTime\":\"2026-07-16 10:23:08\",\"usableColumn\":true},{\"capJavaField\":\"Ancestors\",\"columnComment\":\"祖级列表\",\"columnId\":1143,\"columnName\":\"ancestors\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-14 10:22:42\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"ancestors\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":true,\"tableId\":82,\"updateBy\":\"\",\"updateTime\":\"2026-07-16 10:23:08\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"分项名称\",\"columnId\":1144,\"columnName\":\"name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-14 10:22:42\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":tru', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 10:47:32', 22);
INSERT INTO `sys_oper_log` VALUES (382, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"sub_energy_items,energy_line_data_monthly,energy_line_data_yearly,energy_meter_config_version,energy_meter_data_daily,energy_meter_data_hourly,energy_meter_data_min,energy_meter_data_monthly,energy_meter_data_yearly,energy_reading_revision,energy_recalculation_job,energy_site,energy_topology_version,energy_types,energy_usage_bucket_task,energy_usage_fact,energy_work_order,energy_item_data_monthly,energy_item_data_yearly,energy_allocation_result,energy_line_data_hourly,energy_line_data_min,energy_area_data_daily,energy_area_data_hourly,energy_area_data_min,energy_area_data_monthly,energy_area_data_yearly,energy_benchmark_results,energy_benchmarks,energy_billing_statement,energy_data_daily,energy_data_hourly,energy_data_monthly,energy_data_yearly,energy_factor_version,energy_item_data_daily,energy_item_data_hourly,energy_item_data_min,energy_line_data_daily\"}', NULL, 0, NULL, '2026-07-16 11:28:07', 690);
INSERT INTO `sys_oper_log` VALUES (383, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"disable\"}', '{\"msg\":\"停用成功\",\"code\":200}', 0, NULL, '2026-07-16 11:31:23', 17);
INSERT INTO `sys_oper_log` VALUES (384, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"electrical\",\"status\":\"disable\"}', '{\"msg\":\"停用成功\",\"code\":200}', 0, NULL, '2026-07-16 11:31:24', 10);
INSERT INTO `sys_oper_log` VALUES (385, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/4', '127.0.0.1', '内网IP', '4 ', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2026-07-16 11:38:15', 10);
INSERT INTO `sys_oper_log` VALUES (386, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-06-26 10:30:29\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 11:38:24', 29);
INSERT INTO `sys_oper_log` VALUES (387, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/4', '127.0.0.1', '内网IP', '4 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 11:38:29', 10);
INSERT INTO `sys_oper_log` VALUES (388, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2184', '127.0.0.1', '内网IP', '2184 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 11:41:34', 12);
INSERT INTO `sys_oper_log` VALUES (389, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2185', '127.0.0.1', '内网IP', '2185 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 11:41:35', 10);
INSERT INTO `sys_oper_log` VALUES (390, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2186', '127.0.0.1', '内网IP', '2186 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 11:41:36', 10);
INSERT INTO `sys_oper_log` VALUES (391, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2187', '127.0.0.1', '内网IP', '2187 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 11:41:37', 11);
INSERT INTO `sys_oper_log` VALUES (392, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2188', '127.0.0.1', '内网IP', '2188 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 11:41:38', 9);
INSERT INTO `sys_oper_log` VALUES (393, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2190', '127.0.0.1', '内网IP', '2190 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 11:41:39', 9);
INSERT INTO `sys_oper_log` VALUES (394, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2191', '127.0.0.1', '内网IP', '2191 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 11:41:40', 10);
INSERT INTO `sys_oper_log` VALUES (395, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2192', '127.0.0.1', '内网IP', '2192 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 11:41:41', 10);
INSERT INTO `sys_oper_log` VALUES (396, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2193', '127.0.0.1', '内网IP', '2193 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 11:41:41', 10);
INSERT INTO `sys_oper_log` VALUES (397, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2194', '127.0.0.1', '内网IP', '2194 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 11:41:43', 11);
INSERT INTO `sys_oper_log` VALUES (398, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2183', '127.0.0.1', '内网IP', '2183 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 11:41:44', 10);
INSERT INTO `sys_oper_log` VALUES (399, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2189', '127.0.0.1', '内网IP', '2189 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 11:41:47', 10);
INSERT INTO `sys_oper_log` VALUES (400, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"energy_anomalies,energy_anomaly_rules\",\"tplWebType\":\"element-plus\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 11:42:46', 64);
INSERT INTO `sys_oper_log` VALUES (401, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"energy_anomalies,energy_anomaly_rules\"}', NULL, 0, NULL, '2026-07-16 11:44:22', 146);
INSERT INTO `sys_oper_log` VALUES (402, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"energy_anomaly_rules,energy_anomalies,energy_line_data_monthly,energy_line_data_yearly,energy_meter_config_version,energy_meter_data_daily,energy_meter_data_hourly,energy_meter_data_min,energy_meter_data_monthly,energy_meter_data_yearly,energy_reading_revision,energy_recalculation_job,energy_site,energy_topology_version,energy_types,energy_usage_bucket_task,energy_usage_fact,energy_work_order,sub_energy_items,energy_line_data_daily,energy_allocation_result,energy_line_data_min,energy_area_data_daily,energy_area_data_hourly,energy_area_data_min,energy_area_data_monthly,energy_area_data_yearly,energy_benchmark_results,energy_benchmarks,energy_billing_statement,energy_data_daily,energy_data_hourly,energy_data_monthly,energy_data_yearly,energy_factor_version,energy_item_data_daily,energy_item_data_hourly,energy_item_data_min,energy_item_data_monthly,energy_item_data_yearly,energy_line_data_hourly\"}', NULL, 0, NULL, '2026-07-16 11:51:44', 879);
INSERT INTO `sys_oper_log` VALUES (403, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"iot/buildings/index\",\"createTime\":\"2025-08-26 21:42:29\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2195,\"menuName\":\"建筑基础信息\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2312,\"path\":\"buildings\",\"perms\":\"iot:buildings:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-16 19:34:22', 24);
INSERT INTO `sys_oper_log` VALUES (404, '设备属性模板', 5, 'com.ruoyi.iot.controller.DeviceBindingController.export()', 'POST', 1, 'admin', '研发部门', '/iot/binding/export', '127.0.0.1', '内网IP', '{\"params\":{}} ', NULL, 0, NULL, '2026-07-18 13:47:58', 486);
INSERT INTO `sys_oper_log` VALUES (405, '网关数据点位', 5, 'com.ruoyi.iot.controller.EdgeDataPointController.export()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 1, 'Cannot invoke \"com.ruoyi.iot.domain.EdgeDevice.getProtocolId()\" because \"edgeDevice\" is null', '2026-07-18 13:49:36', 8);
INSERT INTO `sys_oper_log` VALUES (406, '网关数据点位', 5, 'com.ruoyi.iot.controller.EdgeDataPointController.export()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\",\"gatewayId\":\"modbus_local\"}', NULL, 0, NULL, '2026-07-18 13:49:38', 87);
INSERT INTO `sys_oper_log` VALUES (407, '设备属性模板', 6, 'com.ruoyi.iot.controller.DeviceBindingController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/binding/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"1\"}', NULL, 1, 'Index 1 out of bounds for length 1', '2026-07-18 13:51:28', 120);
INSERT INTO `sys_oper_log` VALUES (408, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"enable\"}', '{\"msg\":\"启用成功\",\"code\":200}', 0, NULL, '2026-07-18 17:57:43', 23);
INSERT INTO `sys_oper_log` VALUES (409, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"disable\"}', '{\"msg\":\"停用成功\",\"code\":200}', 0, NULL, '2026-07-18 17:57:45', 10);
INSERT INTO `sys_oper_log` VALUES (410, '设备分组', 3, 'com.ruoyi.iot.controller.DeviceGroupController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/deviceGroup/102', '127.0.0.1', '内网IP', '[102] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-18 17:57:56', 14);
INSERT INTO `sys_oper_log` VALUES (411, '设备分组', 3, 'com.ruoyi.iot.controller.DeviceGroupController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/deviceGroup/103', '127.0.0.1', '内网IP', '[103] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-18 17:57:57', 9);
INSERT INTO `sys_oper_log` VALUES (412, '设备分组', 3, 'com.ruoyi.iot.controller.DeviceGroupController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/deviceGroup/101', '127.0.0.1', '内网IP', '[101] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-18 17:57:57', 10);
INSERT INTO `sys_oper_log` VALUES (413, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/84,83,65,66,67,68,69,70,71,72,74,75,76,77,78,79,80,81,82,62,43,64,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,63', '127.0.0.1', '内网IP', '[84,83,65,66,67,68,69,70,71,72,74,75,76,77,78,79,80,81,82,62,43,64,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,63] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-18 17:58:20', 21);
INSERT INTO `sys_oper_log` VALUES (414, '设备属性模板', 6, 'com.ruoyi.iot.controller.DeviceBindingController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/binding/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', NULL, 1, 'Index 1 out of bounds for length 1', '2026-07-18 18:01:34', 25);
INSERT INTO `sys_oper_log` VALUES (415, '设备属性模板', 6, 'com.ruoyi.iot.controller.DeviceBindingController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/binding/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', NULL, 1, 'Index 1 out of bounds for length 1', '2026-07-18 18:03:00', 372);
INSERT INTO `sys_oper_log` VALUES (416, '设备属性模板', 6, 'com.ruoyi.iot.controller.DeviceBindingController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/binding/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', NULL, 1, 'Index 1 out of bounds for length 1', '2026-07-18 18:03:26', 23);
INSERT INTO `sys_oper_log` VALUES (417, '设备属性模板', 6, 'com.ruoyi.iot.controller.DeviceBindingController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/binding/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', NULL, 1, 'Index 1 out of bounds for length 1', '2026-07-18 18:04:29', 32770);
INSERT INTO `sys_oper_log` VALUES (418, '设备属性模板', 6, 'com.ruoyi.iot.controller.DeviceBindingController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/binding/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', NULL, 1, 'Index 1 out of bounds for length 1', '2026-07-18 18:05:31', 385);
INSERT INTO `sys_oper_log` VALUES (419, '设备属性模板', 5, 'com.ruoyi.iot.controller.DeviceBindingController.export()', 'POST', 1, 'admin', '研发部门', '/iot/binding/export', '127.0.0.1', '内网IP', '{\"params\":{}} ', NULL, 0, NULL, '2026-07-18 18:05:40', 222);
INSERT INTO `sys_oper_log` VALUES (420, '设备属性模板', 6, 'com.ruoyi.iot.controller.DeviceBindingController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/binding/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', NULL, 1, 'Index 1 out of bounds for length 1', '2026-07-18 18:08:04', 24);
INSERT INTO `sys_oper_log` VALUES (421, '设备', 6, 'com.ruoyi.iot.controller.DevicesController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/devices/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', NULL, 1, 'Cannot invoke \"com.ruoyi.iot.domain.Device.getName()\" because \"device\" is null', '2026-07-18 18:08:23', 384);
INSERT INTO `sys_oper_log` VALUES (422, '设备属性模板', 6, 'com.ruoyi.iot.controller.DeviceBindingController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/binding/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', '{\"msg\":\"恭喜您，数据已全部导入成功！共 196 条，数据如下：<br/>1、设备属性模板  导入成功<br/>2、设备属性模板  导入成功<br/>3、设备属性模板  导入成功<br/>4、设备属性模板  导入成功<br/>5、设备属性模板  导入成功<br/>6、设备属性模板  导入成功<br/>7、设备属性模板  导入成功<br/>8、设备属性模板  导入成功<br/>9、设备属性模板  导入成功<br/>10、设备属性模板  导入成功<br/>11、设备属性模板  导入成功<br/>12、设备属性模板  导入成功<br/>13、设备属性模板  导入成功<br/>14、设备属性模板  导入成功<br/>15、设备属性模板  导入成功<br/>16、设备属性模板  导入成功<br/>17、设备属性模板  导入成功<br/>18、设备属性模板  导入成功<br/>19、设备属性模板  导入成功<br/>20、设备属性模板  导入成功<br/>21、设备属性模板  导入成功<br/>22、设备属性模板  导入成功<br/>23、设备属性模板  导入成功<br/>24、设备属性模板  导入成功<br/>25、设备属性模板  导入成功<br/>26、设备属性模板  导入成功<br/>27、设备属性模板  导入成功<br/>28、设备属性模板  导入成功<br/>29、设备属性模板  导入成功<br/>30、设备属性模板  导入成功<br/>31、设备属性模板  导入成功<br/>32、设备属性模板  导入成功<br/>33、设备属性模板  导入成功<br/>34、设备属性模板  导入成功<br/>35、设备属性模板  导入成功<br/>36、设备属性模板  导入成功<br/>37、设备属性模板  导入成功<br/>38、设备属性模板  导入成功<br/>39、设备属性模板  导入成功<br/>40、设备属性模板  导入成功<br/>41、设备属性模板  导入成功<br/>42、设备属性模板  导入成功<br/>43、设备属性模板  导入成功<br/>44、设备属性模板  导入成功<br/>45、设备属性模板  导入成功<br/>46、设备属性模板  导入成功<br/>47、设备属性模板  导入成功<br/>48、设备属性模板  导入成功<br/>49、设备属性模板  导入成功<br/>50、设备属性模板  导入成功<br/>51、设备属性模板  导入成功<br/>52、设备属性模板  导入成功<br/>53、设备属性模板  导入成功<br/>54、设备属性模板  导入成功<br/>55、设备属性模板  导入成功<br/>56、设备属性模板  导入成功<br/>57、设备属性模板  导入成功<br/>58、设备属性模板  导入成功<br/>59、设备属性模板  导入成功<br/>60、设备属性模板  导入成功<br/>61、设备属性模板  导入成功<br/>62、设备属性模板  导入成功<br/>63、设备属性模板  导入成功<br/>64、设备属性模板  导入成功<br/>65、设备属性模板  导入成功<br/>66、设备属性模板  导入成功<br/>67、设备属性模板  导入成功<br/>68、设备属性模板  导入成功<br/>69、设备属性模板  导入成功<br/>70、设备属性模板  导入成功<br/>71、设备属性模板  导入成功<br/>72、设备属性模板  导入成功<br/>73、设备属性模板  导入成功<br/>74、设备属性模板  导入成功<br/>75、设备属性模板  导入成功<br/>76、设备属性模板  导入成功<br/>77、设备属性模板  导入成功<br/>78、设备属性模板  导入成功<br/>79、设备属性模板  导入成功<br/>80、设备属性模板  导入成功<br/>81、设备属性模板  导入成功<br/>82、设备属性模板  导入成功<br/>83、设备属性模板  导入成功<br/>84、设备属性模板  导入成功<br/>85、设备属性模板  导入成功<br/>86、设备属性模板  导入成功<br/>87、设备属性模板  导入成功<br/>88、设备属性模板  导入成功<br/>89、设备属性模板  导入成功<br/>90、设备属性模板  导入成功<br/>91、设备属性模板  导入成功<br/>92、设备属性模板  导入成功<br/>93、设备属性模板  导入成功<br/>94、设备属性模板  导入成功<br/>95、设备属性模板  导入成功<br/>96、设备属性模板  导入成功<br/>97、设备属性模板  导入成功<br/>98、设备属性模板  导入成功<br/>99、设备属性模板', 0, NULL, '2026-07-18 18:11:42', 768);
INSERT INTO `sys_oper_log` VALUES (423, '设备属性模板', 5, 'com.ruoyi.iot.controller.DeviceBindingController.export()', 'POST', 1, 'admin', '研发部门', '/iot/binding/export', '127.0.0.1', '内网IP', '{\"params\":{}} ', NULL, 0, NULL, '2026-07-18 18:13:12', 200);
INSERT INTO `sys_oper_log` VALUES (424, '设备属性模板', 6, 'com.ruoyi.iot.controller.DeviceBindingController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/binding/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', NULL, 1, '很抱歉，导入失败！共 4 条数据格式不正确，错误如下：<br/>1、设备属性模板 brightness 已存在<br/>2、设备属性模板 colorTemperature 已存在<br/>3、设备属性模板 power 已存在<br/>4、设备属性模板 status 已存在', '2026-07-18 18:13:48', 630);
INSERT INTO `sys_oper_log` VALUES (425, '设备属性模板', 6, 'com.ruoyi.iot.controller.DeviceBindingController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/binding/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"1\"}', '{\"msg\":\"恭喜您，数据已全部导入成功！共 245 条，数据如下：<br/>1、设备属性模板 brightness 更新成功<br/>2、设备属性模板 colorTemperature 更新成功<br/>3、设备属性模板 power 更新成功<br/>4、设备属性模板 status 更新成功<br/>5、设备属性模板 brightness 导入成功<br/>6、设备属性模板 colorTemperature 导入成功<br/>7、设备属性模板 power 导入成功<br/>8、设备属性模板 status 导入成功<br/>9、设备属性模板 brightness 导入成功<br/>10、设备属性模板 colorTemperature 导入成功<br/>11、设备属性模板 power 导入成功<br/>12、设备属性模板 status 导入成功<br/>13、设备属性模板 brightness 导入成功<br/>14、设备属性模板 colorTemperature 导入成功<br/>15、设备属性模板 power 导入成功<br/>16、设备属性模板 status 导入成功<br/>17、设备属性模板 brightness 导入成功<br/>18、设备属性模板 colorTemperature 导入成功<br/>19、设备属性模板 power 导入成功<br/>20、设备属性模板 status 导入成功<br/>21、设备属性模板 brightness 导入成功<br/>22、设备属性模板 colorTemperature 导入成功<br/>23、设备属性模板 power 导入成功<br/>24、设备属性模板 status 导入成功<br/>25、设备属性模板 brightness 导入成功<br/>26、设备属性模板 colorTemperature 导入成功<br/>27、设备属性模板 power 导入成功<br/>28、设备属性模板 status 导入成功<br/>29、设备属性模板 brightness 导入成功<br/>30、设备属性模板 colorTemperature 导入成功<br/>31、设备属性模板 power 导入成功<br/>32、设备属性模板 status 导入成功<br/>33、设备属性模板 brightness 导入成功<br/>34、设备属性模板 colorTemperature 导入成功<br/>35、设备属性模板 power 导入成功<br/>36、设备属性模板 status 导入成功<br/>37、设备属性模板 brightness 导入成功<br/>38、设备属性模板 colorTemperature 导入成功<br/>39、设备属性模板 power 导入成功<br/>40、设备属性模板 status 导入成功<br/>41、设备属性模板 brightness 导入成功<br/>42、设备属性模板 colorTemperature 导入成功<br/>43、设备属性模板 power 导入成功<br/>44、设备属性模板 status 导入成功<br/>45、设备属性模板 brightness 导入成功<br/>46、设备属性模板 colorTemperature 导入成功<br/>47、设备属性模板 power 导入成功<br/>48、设备属性模板 status 导入成功<br/>49、设备属性模板 brightness 导入成功<br/>50、设备属性模板 colorTemperature 导入成功<br/>51、设备属性模板 power 导入成功<br/>52、设备属性模板 status 导入成功<br/>53、设备属性模板 brightness 导入成功<br/>54、设备属性模板 colorTemperature 导入成功<br/>55、设备属性模板 power 导入成功<br/>56、设备属性模板 status 导入成功<br/>57、设备属性模板 brightness 导入成功<br/>58、设备属性模板 colorTemperature 导入成功<br/>59、设备属性模板 power 导入成功<br/>60、设备属性模板 status 导入成功<br/>61、设备属性模板 brightness 导入成功<br/>62、设备属性模板 colorTemperature 导入成功<br/>63、设备属性模板 power 导入成功<br/>64、设备属性模板 status 导入成功<br/>65、设备属性模板 brightness 导入成功<br/>66、设备属性模板 colorTemperature 导入成功<br/>67、设备属性模板 power 导入成功<br/>68、设备属', 0, NULL, '2026-07-18 18:13:58', 592);
INSERT INTO `sys_oper_log` VALUES (426, '设备属性模板', 5, 'com.ruoyi.iot.controller.DeviceBindingController.export()', 'POST', 1, 'admin', '研发部门', '/iot/binding/export', '127.0.0.1', '内网IP', '{\"params\":{}} ', NULL, 0, NULL, '2026-07-18 18:17:33', 132);
INSERT INTO `sys_oper_log` VALUES (427, '产品信息', 5, 'com.ruoyi.iot.controller.ProductsController.export()', 'POST', 1, 'admin', '研发部门', '/iot/products/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2026-07-18 18:39:43', 77);
INSERT INTO `sys_oper_log` VALUES (428, '产品物模型', 5, 'com.ruoyi.iot.controller.ProductTemplatesController.export()', 'POST', 1, 'admin', '研发部门', '/iot/productTemplates/export', '127.0.0.1', '内网IP', '{\"productId\":\"dimmer\"}', NULL, 0, NULL, '2026-07-18 18:39:54', 36);
INSERT INTO `sys_oper_log` VALUES (429, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"energy_allocation_result,energy_reconciliation_result_detail,energy_reconciliation_result,energy_benchmark_result,energy_carbon_conversion_fact,energy_billing_statement,energy_line_data_yearly,energy_meter_data_yearly,energy_meter_data_monthly,energy_line_data_monthly,energy_line_data_min,energy_line_data_hourly,energy_meter_data_min,energy_line_data_daily,energy_meter_data_hourly,energy_meter_data_daily,energy_item_data_daily,energy_area_data_hourly,energy_area_data_min,energy_area_data_monthly,energy_area_data_yearly,energy_area_data_daily,energy_item_data_hourly,energy_item_data_min,energy_item_data_monthly,energy_item_data_yearly,energy_config_validation_issue,energy_branch_line,energy_meter,energy_meter_branch_binding,energy_meter_channel,energy_branch_dimension_binding,energy_meter_formula,energy_meter_formula_dependency,energy_meter_usage_calc_task,energy_meter_usage_recalc_job,energy_stat_data_revision,energy_carbon_factor,energy_stat_data_history_lineage,energy_stat_data_lineage,energy_billing_statement_line,energy_meter_usage_recalc_job_task,energy_type,energy_area,energy_sub_item,energy_anomaly_rule,energy_anomaly_event,energy_allocation_rule,energy_allocation_rule_target,energy_tariff_detail\",\"tplWebType\":\"element-plus\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-18 21:12:04', 986);
INSERT INTO `sys_oper_log` VALUES (430, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"energy_tariff_policie,energy_benchmark\",\"tplWebType\":\"element-plus\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-18 21:12:09', 44);
INSERT INTO `sys_oper_log` VALUES (431, '规则场景', 1, 'com.ruoyi.iot.controller.RuleSceneController.add()', 'POST', 1, 'admin', '研发部门', '/iot/ruleScene', '127.0.0.1', '内网IP', '{\"actions\":\"[{\\\"actionType\\\":\\\"DEVICE_PROPERTY\\\",\\\"targetDeviceId\\\":\\\"\\\",\\\"setProperty\\\":\\\"\\\",\\\"setValue\\\":\\\"\\\",\\\"delaySeconds\\\":1,\\\"message\\\":\\\"\\\",\\\"productId\\\":\\\"dimmer\\\",\\\"deviceId\\\":\\\"test1\\\",\\\"property\\\":\\\"colorTemperature\\\",\\\"value\\\":\\\"88\\\"}]\",\"conditionLogic\":\"AND\",\"conditions\":\"[]\",\"createTime\":\"2026-07-18 22:54:19\",\"description\":\"\",\"id\":\"scene_mrqhlbsp_ydxt5\",\"name\":\"test\",\"params\":{},\"state\":\"enable\",\"triggers\":\"[{\\\"triggerType\\\":\\\"DEVICE\\\",\\\"deviceId\\\":\\\"test1\\\",\\\"property\\\":\\\"brightness\\\",\\\"value\\\":\\\"120\\\",\\\"cronExpression\\\":\\\"\\\",\\\"alarm\\\":\\\"enable\\\",\\\"productId\\\":\\\"dimmer\\\",\\\"operator\\\":\\\"==\\\"}]\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-18 22:54:19', 30);
INSERT INTO `sys_oper_log` VALUES (432, '规则场景', 2, 'com.ruoyi.iot.controller.RuleSceneController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/ruleScene', '127.0.0.1', '内网IP', '{\"actions\":\"[{\\\"actionType\\\":\\\"DEVICE_PROPERTY\\\",\\\"targetDeviceId\\\":\\\"\\\",\\\"setProperty\\\":\\\"\\\",\\\"setValue\\\":\\\"\\\",\\\"delaySeconds\\\":1,\\\"message\\\":\\\"\\\",\\\"productId\\\":\\\"dimmer\\\",\\\"deviceId\\\":\\\"test1\\\",\\\"property\\\":\\\"colorTemperature\\\",\\\"value\\\":\\\"88\\\"}]\",\"conditionLogic\":\"AND\",\"conditions\":\"[]\",\"description\":\"\",\"id\":\"scene_mrqhlbsp_ydxt5\",\"name\":\"test\",\"params\":{},\"state\":\"disable\",\"triggers\":\"[{\\\"triggerType\\\":\\\"DEVICE\\\",\\\"deviceId\\\":\\\"test1\\\",\\\"property\\\":\\\"brightness\\\",\\\"value\\\":\\\"120\\\",\\\"cronExpression\\\":\\\"\\\",\\\"alarm\\\":\\\"enable\\\",\\\"productId\\\":\\\"dimmer\\\",\\\"operator\\\":\\\"==\\\"}]\",\"updateTime\":\"2026-07-18 22:55:10\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-18 22:55:10', 9);
INSERT INTO `sys_oper_log` VALUES (433, '规则场景', 2, 'com.ruoyi.iot.controller.RuleSceneController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/ruleScene', '127.0.0.1', '内网IP', '{\"actions\":\"[{\\\"actionType\\\":\\\"DEVICE_PROPERTY\\\",\\\"targetDeviceId\\\":\\\"\\\",\\\"setProperty\\\":\\\"\\\",\\\"setValue\\\":\\\"\\\",\\\"delaySeconds\\\":1,\\\"message\\\":\\\"\\\",\\\"productId\\\":\\\"dimmer\\\",\\\"deviceId\\\":\\\"test1\\\",\\\"property\\\":\\\"colorTemperature\\\",\\\"value\\\":\\\"88\\\"}]\",\"conditionLogic\":\"AND\",\"conditions\":\"[]\",\"description\":\"\",\"id\":\"scene_mrqhlbsp_ydxt5\",\"name\":\"test\",\"params\":{},\"state\":\"enable\",\"triggers\":\"[{\\\"triggerType\\\":\\\"DEVICE\\\",\\\"deviceId\\\":\\\"test1\\\",\\\"property\\\":\\\"brightness\\\",\\\"value\\\":\\\"120\\\",\\\"cronExpression\\\":\\\"\\\",\\\"alarm\\\":\\\"enable\\\",\\\"productId\\\":\\\"dimmer\\\",\\\"operator\\\":\\\"==\\\"}]\",\"updateTime\":\"2026-07-18 22:55:14\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-18 22:55:14', 10);
INSERT INTO `sys_oper_log` VALUES (434, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"102\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-18 22:55:45', 22);
INSERT INTO `sys_oper_log` VALUES (435, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"102\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-18 22:55:50', 9);
INSERT INTO `sys_oper_log` VALUES (436, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"102\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-18 22:55:56', 10);
INSERT INTO `sys_oper_log` VALUES (437, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"102\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-18 22:56:03', 12);
INSERT INTO `sys_oper_log` VALUES (438, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"102\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-18 22:56:06', 3);
INSERT INTO `sys_oper_log` VALUES (439, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.colorTemperature\",\"telemetryKey\":\"colorTemperature\",\"value\":\"123\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-18 22:56:12', 16);
INSERT INTO `sys_oper_log` VALUES (440, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"11\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-18 22:56:20', 13);
INSERT INTO `sys_oper_log` VALUES (441, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"102\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-18 22:56:25', 3);
INSERT INTO `sys_oper_log` VALUES (442, '设备属性模板', 2, 'com.ruoyi.iot.controller.DeviceBindingController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/binding', '127.0.0.1', '内网IP', '{\"dataType\":\"int\",\"deviceId\":\"test1\",\"edgePointId\":\"2070420318954541056\",\"edgePointName\":\"modbus1\",\"gatewayId\":\"modbus_local\",\"gatewayName\":\"modbusLocal\",\"id\":\"c8704053a98b4eea9dd382f325221319\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"unitSymbol\":\"%\",\"updateTime\":\"2026-07-18 22:57:22\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-18 22:57:22', 14);
INSERT INTO `sys_oper_log` VALUES (443, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"102\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-18 22:57:26', 15);
INSERT INTO `sys_oper_log` VALUES (444, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"102\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-18 22:57:27', 15);
INSERT INTO `sys_oper_log` VALUES (445, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"102\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-18 22:57:29', 10);
INSERT INTO `sys_oper_log` VALUES (446, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"102\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-18 22:57:32', 6);
INSERT INTO `sys_oper_log` VALUES (447, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.colorTemperature\",\"telemetryKey\":\"colorTemperature\",\"value\":\"88\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-18 22:57:33', 10);
INSERT INTO `sys_oper_log` VALUES (448, '规则场景', 2, 'com.ruoyi.iot.controller.RuleSceneController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/ruleScene', '127.0.0.1', '内网IP', '{\"actions\":\"[{\\\"actionType\\\":\\\"DEVICE_PROPERTY\\\",\\\"targetDeviceId\\\":\\\"\\\",\\\"setProperty\\\":\\\"\\\",\\\"setValue\\\":\\\"\\\",\\\"delaySeconds\\\":1,\\\"message\\\":\\\"\\\",\\\"productId\\\":\\\"dimmer\\\",\\\"deviceId\\\":\\\"test1\\\",\\\"property\\\":\\\"colorTemperature\\\",\\\"value\\\":\\\"88\\\"}]\",\"conditionLogic\":\"AND\",\"conditions\":\"[]\",\"description\":\"\",\"id\":\"scene_mrqhlbsp_ydxt5\",\"name\":\"test\",\"params\":{},\"state\":\"disable\",\"triggers\":\"[{\\\"triggerType\\\":\\\"DEVICE\\\",\\\"deviceId\\\":\\\"test1\\\",\\\"property\\\":\\\"brightness\\\",\\\"value\\\":\\\"120\\\",\\\"cronExpression\\\":\\\"\\\",\\\"alarm\\\":\\\"enable\\\",\\\"productId\\\":\\\"dimmer\\\",\\\"operator\\\":\\\"==\\\"}]\",\"updateTime\":\"2026-07-18 23:03:17\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-18 23:03:17', 17);
INSERT INTO `sys_oper_log` VALUES (449, '规则场景', 2, 'com.ruoyi.iot.controller.RuleSceneController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/ruleScene', '127.0.0.1', '内网IP', '{\"actions\":\"[{\\\"actionType\\\":\\\"DEVICE_PROPERTY\\\",\\\"targetDeviceId\\\":\\\"\\\",\\\"setProperty\\\":\\\"\\\",\\\"setValue\\\":\\\"\\\",\\\"delaySeconds\\\":1,\\\"message\\\":\\\"\\\",\\\"productId\\\":\\\"dimmer\\\",\\\"deviceId\\\":\\\"test1\\\",\\\"property\\\":\\\"colorTemperature\\\",\\\"value\\\":\\\"88\\\"}]\",\"conditionLogic\":\"AND\",\"conditions\":\"[]\",\"description\":\"\",\"id\":\"scene_mrqhlbsp_ydxt5\",\"name\":\"test\",\"params\":{},\"startTime\":1784387000612,\"state\":\"enable\",\"triggers\":\"[{\\\"triggerType\\\":\\\"DEVICE\\\",\\\"deviceId\\\":\\\"test1\\\",\\\"property\\\":\\\"brightness\\\",\\\"value\\\":\\\"120\\\",\\\"cronExpression\\\":\\\"\\\",\\\"alarm\\\":\\\"enable\\\",\\\"productId\\\":\\\"dimmer\\\",\\\"operator\\\":\\\"==\\\"}]\",\"updateTime\":\"2026-07-18 23:03:20\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-18 23:03:20', 10);
INSERT INTO `sys_oper_log` VALUES (450, '规则场景', 2, 'com.ruoyi.iot.controller.RuleSceneController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/ruleScene', '127.0.0.1', '内网IP', '{\"actions\":\"[{\\\"actionType\\\":\\\"DEVICE_PROPERTY\\\",\\\"targetDeviceId\\\":\\\"\\\",\\\"setProperty\\\":\\\"\\\",\\\"setValue\\\":\\\"\\\",\\\"delaySeconds\\\":1,\\\"message\\\":\\\"\\\",\\\"productId\\\":\\\"dimmer\\\",\\\"deviceId\\\":\\\"test1\\\",\\\"property\\\":\\\"colorTemperature\\\",\\\"value\\\":\\\"88\\\"}]\",\"conditionLogic\":\"AND\",\"conditions\":\"[]\",\"description\":\"\",\"id\":\"scene_mrqhlbsp_ydxt5\",\"name\":\"test\",\"params\":{},\"state\":\"disable\",\"triggers\":\"[{\\\"triggerType\\\":\\\"DEVICE\\\",\\\"deviceId\\\":\\\"test1\\\",\\\"property\\\":\\\"brightness\\\",\\\"value\\\":\\\"120\\\",\\\"cronExpression\\\":\\\"\\\",\\\"alarm\\\":\\\"enable\\\",\\\"productId\\\":\\\"dimmer\\\",\\\"operator\\\":\\\"==\\\"}]\",\"updateTime\":\"2026-07-18 23:05:05\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-18 23:05:05', 19);
INSERT INTO `sys_oper_log` VALUES (451, '规则场景', 2, 'com.ruoyi.iot.controller.RuleSceneController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/ruleScene', '127.0.0.1', '内网IP', '{\"actions\":\"[{\\\"actionType\\\":\\\"DEVICE_PROPERTY\\\",\\\"targetDeviceId\\\":\\\"\\\",\\\"setProperty\\\":\\\"\\\",\\\"setValue\\\":\\\"\\\",\\\"delaySeconds\\\":1,\\\"message\\\":\\\"\\\",\\\"productId\\\":\\\"dimmer\\\",\\\"deviceId\\\":\\\"test1\\\",\\\"property\\\":\\\"colorTemperature\\\",\\\"value\\\":\\\"88\\\"}]\",\"conditionLogic\":\"AND\",\"conditions\":\"[]\",\"description\":\"\",\"id\":\"scene_mrqhlbsp_ydxt5\",\"name\":\"test\",\"params\":{},\"startTime\":\"2026-07-18 23:05:07\",\"state\":\"enable\",\"triggers\":\"[{\\\"triggerType\\\":\\\"DEVICE\\\",\\\"deviceId\\\":\\\"test1\\\",\\\"property\\\":\\\"brightness\\\",\\\"value\\\":\\\"120\\\",\\\"cronExpression\\\":\\\"\\\",\\\"alarm\\\":\\\"enable\\\",\\\"productId\\\":\\\"dimmer\\\",\\\"operator\\\":\\\"==\\\"}]\",\"updateTime\":\"2026-07-18 23:05:07\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-18 23:05:07', 10);
INSERT INTO `sys_oper_log` VALUES (452, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"telemetryKey\":\"brightness\",\"value\":\"12\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-19 11:17:55', 8);
INSERT INTO `sys_oper_log` VALUES (453, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"telemetryKey\":\"brightness\",\"value\":\"10\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-19 11:18:01', 7);
INSERT INTO `sys_oper_log` VALUES (454, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"组态管理\",\"menuType\":\"M\",\"orderNum\":6,\"params\":{},\"parentId\":0,\"path\":\"graphic\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-19 12:26:41', 18);
INSERT INTO `sys_oper_log` VALUES (455, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-07-19 12:26:41\",\"icon\":\"example\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2313,\"menuName\":\"组态管理\",\"menuType\":\"M\",\"orderNum\":6,\"params\":{},\"parentId\":0,\"path\":\"graphic\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-19 12:27:09', 13);
INSERT INTO `sys_oper_log` VALUES (456, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"clipboard\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuName\":\"我的项目\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2313,\"path\":\"http://localhost:3000/#/project/items\",\"routeName\":\"project\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-19 12:28:24', 11);
INSERT INTO `sys_oper_log` VALUES (457, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-07-19 12:28:24\",\"icon\":\"clipboard\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":2314,\"menuName\":\"我的项目\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2313,\"path\":\"http://localhost:3000/#/project/items\",\"perms\":\"\",\"routeName\":\"project\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-19 12:48:49', 12);
INSERT INTO `sys_oper_log` VALUES (458, '设备', 5, 'com.ruoyi.iot.controller.DevicesController.export()', 'POST', 1, 'admin', '研发部门', '/iot/devices/export', '127.0.0.1', '内网IP', '{\"name\":\"test1\",\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2026-07-19 23:48:39', 493);
INSERT INTO `sys_oper_log` VALUES (459, '设备属性模板', 5, 'com.ruoyi.iot.controller.DeviceBindingController.export()', 'POST', 1, 'admin', '研发部门', '/iot/binding/export', '127.0.0.1', '内网IP', '{\"params\":{}} ', NULL, 0, NULL, '2026-07-19 23:48:41', 69);
INSERT INTO `sys_oper_log` VALUES (460, '设备', 5, 'com.ruoyi.iot.controller.DevicesController.export()', 'POST', 1, 'admin', '研发部门', '/iot/devices/export', '127.0.0.1', '内网IP', '{\"name\":\"test1\",\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2026-07-19 23:49:03', 25);
INSERT INTO `sys_oper_log` VALUES (461, '设备属性模板', 5, 'com.ruoyi.iot.controller.DeviceBindingController.export()', 'POST', 1, 'admin', '研发部门', '/iot/binding/export', '127.0.0.1', '内网IP', '{\"params\":{}} ', NULL, 0, NULL, '2026-07-19 23:49:10', 51);
INSERT INTO `sys_oper_log` VALUES (462, '设备', 5, 'com.ruoyi.iot.controller.DevicesController.export()', 'POST', 1, 'admin', '研发部门', '/iot/devices/export', '127.0.0.1', '内网IP', '{\"productId\":\"dimmer\",\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2026-07-19 23:52:18', 29);
INSERT INTO `sys_oper_log` VALUES (463, '设备属性模板', 5, 'com.ruoyi.iot.controller.DeviceBindingController.export()', 'POST', 1, 'admin', '研发部门', '/iot/binding/export', '127.0.0.1', '内网IP', '{\"productId\":\"dimmer\"}', NULL, 0, NULL, '2026-07-19 23:52:21', 50);
INSERT INTO `sys_oper_log` VALUES (464, '设备属性模板', 5, 'com.ruoyi.iot.controller.DeviceBindingController.export()', 'POST', 1, 'admin', '研发部门', '/iot/binding/export', '127.0.0.1', '内网IP', '{\"productId\":\"electrical\"}', NULL, 0, NULL, '2026-07-19 23:52:28', 24);
INSERT INTO `sys_oper_log` VALUES (465, '设备属性模板', 5, 'com.ruoyi.iot.controller.DeviceBindingController.export()', 'POST', 1, 'admin', '研发部门', '/iot/binding/export', '127.0.0.1', '内网IP', '{\"productId\":\"electrical\",\"name\":\"test1\"}', NULL, 0, NULL, '2026-07-19 23:52:36', 32);
INSERT INTO `sys_oper_log` VALUES (466, '设备属性模板', 5, 'com.ruoyi.iot.controller.DeviceBindingController.export()', 'POST', 1, 'admin', '研发部门', '/iot/binding/export', '127.0.0.1', '内网IP', '{\"name\":\"test1\"}', NULL, 0, NULL, '2026-07-19 23:52:42', 34);
INSERT INTO `sys_oper_log` VALUES (467, '产品信息', 5, 'com.ruoyi.iot.controller.ProductsController.export()', 'POST', 1, 'admin', '研发部门', '/iot/products/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2026-07-20 09:59:14', 501);
INSERT INTO `sys_oper_log` VALUES (468, '产品物模型', 5, 'com.ruoyi.iot.controller.ProductTemplatesController.export()', 'POST', 1, 'admin', '研发部门', '/iot/productTemplates/export', '127.0.0.1', '内网IP', '{\"params\":{}} ', NULL, 0, NULL, '2026-07-20 09:59:38', 34);
INSERT INTO `sys_oper_log` VALUES (469, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/135,136,91,133,134,130,90,97,92,93,94,95,96,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,125,126,127,128,129,124,131,132,86,87,88', '127.0.0.1', '内网IP', '[135,136,91,133,134,130,90,97,92,93,94,95,96,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,125,126,127,128,129,124,131,132,86,87,88] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-21 23:44:18', 35);
INSERT INTO `sys_oper_log` VALUES (470, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/85,89', '127.0.0.1', '内网IP', '[85,89] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-21 23:44:20', 9);
INSERT INTO `sys_oper_log` VALUES (471, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"energy_allocation_result,energy_reconciliation_result_detail,energy_reconciliation_result,energy_benchmark_result,energy_carbon_conversion_fact,energy_billing_statement,energy_line_data_yearly,energy_meter_data_yearly,energy_meter_data_monthly,energy_line_data_monthly\",\"tplWebType\":\"element-plus\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-22 01:40:54', 253);
INSERT INTO `sys_oper_log` VALUES (472, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"energy_meter_data_daily,energy_line_data_min,energy_line_data_hourly,energy_line_data_daily,energy_meter_data_hourly,energy_meter_data_min,energy_area_data_daily,energy_item_data_daily,energy_area_data_hourly,energy_area_data_min,energy_area_data_monthly,energy_area_data_yearly,energy_item_data_hourly,energy_item_data_min,energy_item_data_monthly,energy_item_data_yearly,energy_meter_channel,energy_meter_branch_binding,energy_meter,energy_branch_dimension_binding,energy_branch_line,energy_config_validation_issue,energy_meter_formula,energy_meter_formula_dependency,energy_meter_usage_calc_task,energy_meter_usage_recalc_job,energy_stat_data_revision,energy_carbon_factor,energy_stat_data_history_lineage,energy_stat_data_lineage,energy_billing_statement_line,energy_meter_usage_recalc_job_task,energy_type,energy_area,energy_sub_item,energy_anomaly_rule,energy_anomaly_event,energy_allocation_rule_target,energy_allocation_rule,energy_tariff_detail,energy_tariff_policie,energy_benchmark\",\"tplWebType\":\"element-plus\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-22 01:41:03', 607);
INSERT INTO `sys_oper_log` VALUES (473, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"lineage\",\"className\":\"EnergyStatDataLineage\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键ID\",\"columnId\":3156,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":183,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"TargetDataTable\",\"columnComment\":\"派生目标统计表名\",\"columnId\":3157,\"columnName\":\"target_data_table\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"targetDataTable\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":183,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"TargetDataId\",\"columnComment\":\"派生目标统计记录ID\",\"columnId\":3158,\"columnName\":\"target_data_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"targetDataId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":183,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"SourceDataTable\",\"columnComment\":\"来源统计表名\",\"columnId\":3159,\"columnName\":\"source_data_table\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-22 01:57:45', 47);
INSERT INTO `sys_oper_log` VALUES (474, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"item\",\"className\":\"EnergySubItem\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键ID\",\"columnId\":3182,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":185,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"EnergyTypeId\",\"columnComment\":\"能源类型ID；同一分项树内父子节点能源类型必须一致\",\"columnId\":3183,\"columnName\":\"energy_type_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"energyTypeId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":185,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ParentId\",\"columnComment\":\"父级分项ID；为空表示能源类型下的根分项\",\"columnId\":3184,\"columnName\":\"parent_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"parentId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":true,\"tableId\":185,\"updateBy\":\"\",\"usableColumn\":true},{\"capJavaField\":\"Name\",\"columnComment\":\"分项名称\",\"columnId\":3185,\"columnName\":\"name\",\"columnType\":\"varchar(128)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-22 01:58:39', 26);
INSERT INTO `sys_oper_log` VALUES (475, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"energyType\",\"className\":\"EnergyType\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键ID\",\"columnId\":3227,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":188,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"TypeCode\",\"columnComment\":\"能源类型编码，例如ELECTRICITY、WATER、NATURAL_GAS\",\"columnId\":3228,\"columnName\":\"type_code\",\"columnType\":\"varchar(32)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"typeCode\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":188,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"TypeName\",\"columnComment\":\"能源类型名称\",\"columnId\":3229,\"columnName\":\"type_name\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"typeName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":188,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"BaseUnit\",\"columnComment\":\"能源用量标准单位，例如kWh、m³、Nm³、t、GJ\",\"columnId\":3230,\"columnName\":\"base_unit\",\"columnType\":\"varchar(32)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-22 01:59:15', 25);
INSERT INTO `sys_oper_log` VALUES (476, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"energy_type\"}', NULL, 0, NULL, '2026-07-22 01:59:23', 151);
INSERT INTO `sys_oper_log` VALUES (477, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"energyType\",\"className\":\"EnergyType\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键ID\",\"columnId\":3227,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":188,\"updateBy\":\"\",\"updateTime\":\"2026-07-22 01:59:15\",\"usableColumn\":false},{\"capJavaField\":\"TypeCode\",\"columnComment\":\"能源类型编码，例如ELECTRICITY、WATER、NATURAL_GAS\",\"columnId\":3228,\"columnName\":\"type_code\",\"columnType\":\"varchar(32)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"typeCode\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":188,\"updateBy\":\"\",\"updateTime\":\"2026-07-22 01:59:15\",\"usableColumn\":false},{\"capJavaField\":\"TypeName\",\"columnComment\":\"能源类型名称\",\"columnId\":3229,\"columnName\":\"type_name\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"typeName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":188,\"updateBy\":\"\",\"updateTime\":\"2026-07-22 01:59:15\",\"usableColumn\":false},{\"capJavaField\":\"BaseUnit\",\"columnComment\":\"能源用量标准单位，例如kWh、m³、Nm³、t、GJ\",\"columnId\":3230,\"columnName\":\"base_unit\",\"columnType\":\"varchar(32)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"di', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-22 02:06:28', 59);
INSERT INTO `sys_oper_log` VALUES (478, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"energyType\",\"className\":\"EnergyType\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键ID\",\"columnId\":3227,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":188,\"updateBy\":\"\",\"updateTime\":\"2026-07-22 02:06:27\",\"usableColumn\":false},{\"capJavaField\":\"TypeCode\",\"columnComment\":\"能源类型编码，例如ELECTRICITY、WATER、NATURAL_GAS\",\"columnId\":3228,\"columnName\":\"type_code\",\"columnType\":\"varchar(32)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"typeCode\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":188,\"updateBy\":\"\",\"updateTime\":\"2026-07-22 02:06:27\",\"usableColumn\":false},{\"capJavaField\":\"TypeName\",\"columnComment\":\"能源类型名称\",\"columnId\":3229,\"columnName\":\"type_name\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"typeName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":188,\"updateBy\":\"\",\"updateTime\":\"2026-07-22 02:06:27\",\"usableColumn\":false},{\"capJavaField\":\"BaseUnit\",\"columnComment\":\"能源用量标准单位，例如kWh、m³、Nm³、t、GJ\",\"columnId\":3230,\"columnName\":\"base_unit\",\"columnType\":\"varchar(32)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"di', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-22 02:07:17', 29);
INSERT INTO `sys_oper_log` VALUES (479, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"energyType\",\"className\":\"EnergyType\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键ID\",\"columnId\":3227,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":188,\"updateBy\":\"\",\"updateTime\":\"2026-07-22 02:07:17\",\"usableColumn\":false},{\"capJavaField\":\"TypeCode\",\"columnComment\":\"能源类型编码，例如ELECTRICITY、WATER、NATURAL_GAS\",\"columnId\":3228,\"columnName\":\"type_code\",\"columnType\":\"varchar(32)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"typeCode\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":188,\"updateBy\":\"\",\"updateTime\":\"2026-07-22 02:07:17\",\"usableColumn\":false},{\"capJavaField\":\"TypeName\",\"columnComment\":\"能源类型名称\",\"columnId\":3229,\"columnName\":\"type_name\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"typeName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":188,\"updateBy\":\"\",\"updateTime\":\"2026-07-22 02:07:17\",\"usableColumn\":false},{\"capJavaField\":\"BaseUnit\",\"columnComment\":\"能源用量标准单位，例如kWh、m³、Nm³、t、GJ\",\"columnId\":3230,\"columnName\":\"base_unit\",\"columnType\":\"varchar(32)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"di', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-22 02:07:52', 25);
INSERT INTO `sys_oper_log` VALUES (480, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"dimmer\",\"status\":\"enable\"}', '{\"msg\":\"启用成功\",\"code\":200}', 0, NULL, '2026-07-22 11:50:36', 29);
INSERT INTO `sys_oper_log` VALUES (481, '设备属性模板', 5, 'com.ruoyi.iot.controller.DeviceBindingController.export()', 'POST', 1, 'admin', '研发部门', '/iot/binding/export', '127.0.0.1', '内网IP', '{\"params\":{}} ', NULL, 0, NULL, '2026-07-22 14:26:59', 460);
INSERT INTO `sys_oper_log` VALUES (482, '设备', 3, 'com.ruoyi.iot.controller.DevicesController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/devices/test2,test3,test4,test5,test6,test7,test8,test9,test10,test11,test12,test13,test14,test15,test16,test17,test18,test19,test20,test21,test22,test23,test24,test25,test26,test27,test28,test29,test30,test31,test32,test33,test34,test35,test36,test3', '127.0.0.1', '内网IP', '[\"test2\",\"test3\",\"test4\",\"test5\",\"test6\",\"test7\",\"test8\",\"test9\",\"test10\",\"test11\",\"test12\",\"test13\",\"test14\",\"test15\",\"test16\",\"test17\",\"test18\",\"test19\",\"test20\",\"test21\",\"test22\",\"test23\",\"test24\",\"test25\",\"test26\",\"test27\",\"test28\",\"test29\",\"test30\",\"test31\",\"test32\",\"test33\",\"test34\",\"test35\",\"test36\",\"test37\",\"test38\",\"test39\",\"test40\",\"test41\",\"test42\",\"test43\",\"test44\",\"test45\",\"test46\",\"test47\",\"test48\",\"test49\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-22 14:28:56', 454);
INSERT INTO `sys_oper_log` VALUES (483, '设备属性模板', 2, 'com.ruoyi.iot.controller.DeviceBindingController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/binding', '127.0.0.1', '内网IP', '{\"dataType\":\"int\",\"deviceId\":\"test1\",\"edgePointId\":\"2070420318954541056\",\"edgePointName\":\"modbus1\",\"gatewayId\":\"modbus_local\",\"gatewayName\":\"modbusLocal\",\"id\":\"c8704053a98b4eea9dd382f325221319\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"unitSymbol\":\"%\",\"updateTime\":\"2026-07-22 14:29:09\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-22 14:29:09', 10);
INSERT INTO `sys_oper_log` VALUES (484, '设备属性模板', 2, 'com.ruoyi.iot.controller.DeviceBindingController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/binding', '127.0.0.1', '内网IP', '{\"dataType\":\"int\",\"deviceId\":\"test1\",\"edgePointId\":\"2070439791132020736\",\"edgePointName\":\"modbus2\",\"gatewayId\":\"modbus_local\",\"gatewayName\":\"modbusLocal\",\"id\":\"08b81007af324d4d91a863a6269494c9\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.colorTemperature\",\"telemetryKey\":\"colorTemperature\",\"unitSymbol\":\"K\",\"updateTime\":\"2026-07-22 14:29:11\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-22 14:29:11', 11);
INSERT INTO `sys_oper_log` VALUES (485, '设备属性模板', 2, 'com.ruoyi.iot.controller.DeviceBindingController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/binding', '127.0.0.1', '内网IP', '{\"dataType\":\"boolean\",\"deviceId\":\"test1\",\"edgePointId\":\"2070439791186546688\",\"edgePointName\":\"modbus3\",\"gatewayId\":\"modbus_local\",\"gatewayName\":\"modbusLocal\",\"id\":\"4b48f4c1123148e0b553056b1f636b31\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.power\",\"telemetryKey\":\"power\",\"unitSymbol\":\"\",\"updateTime\":\"2026-07-22 14:29:12\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-22 14:29:12', 10);
INSERT INTO `sys_oper_log` VALUES (486, '设备属性模板', 2, 'com.ruoyi.iot.controller.DeviceBindingController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/binding', '127.0.0.1', '内网IP', '{\"dataType\":\"enum\",\"deviceId\":\"test1\",\"edgePointId\":\"2070439791224295424\",\"edgePointName\":\"modbus4\",\"gatewayId\":\"modbus_local\",\"gatewayName\":\"modbusLocal\",\"id\":\"e16efb52ed6e4c2999533cea0095955e\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.status\",\"telemetryKey\":\"status\",\"unitSymbol\":\"\",\"updateTime\":\"2026-07-22 14:29:13\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-22 14:29:13', 10);
INSERT INTO `sys_oper_log` VALUES (487, '设备', 5, 'com.ruoyi.iot.controller.DevicesController.export()', 'POST', 1, 'admin', '研发部门', '/iot/devices/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"50\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2026-07-22 14:29:17', 29);
INSERT INTO `sys_oper_log` VALUES (488, '设备', 6, 'com.ruoyi.iot.controller.DevicesController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/devices/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"1\"}', '{\"msg\":\"恭喜您，数据已全部导入成功！共 19 条，数据如下：<br/>1、设备 test1 更新成功<br/>2、设备 test2 导入成功<br/>3、设备 test3 导入成功<br/>4、设备 test4 导入成功<br/>5、设备 test5 导入成功<br/>6、设备 test6 导入成功<br/>7、设备 test7 导入成功<br/>8、设备 test8 导入成功<br/>9、设备 test9 导入成功<br/>10、设备 test10 导入成功<br/>11、设备 test11 导入成功<br/>12、设备 test12 导入成功<br/>13、设备 test13 导入成功<br/>14、设备 test14 导入成功<br/>15、设备 test15 导入成功<br/>16、设备 test16 导入成功<br/>17、设备 test17 导入成功<br/>18、设备 test18 导入成功<br/>19、设备 test19 导入成功\",\"code\":200}', 0, NULL, '2026-07-22 14:29:45', 145);
INSERT INTO `sys_oper_log` VALUES (489, '设备', 5, 'com.ruoyi.iot.controller.DevicesController.export()', 'POST', 1, 'admin', '研发部门', '/iot/devices/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"50\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2026-07-22 14:29:51', 32);
INSERT INTO `sys_oper_log` VALUES (490, '设备属性模板', 5, 'com.ruoyi.iot.controller.DeviceBindingController.export()', 'POST', 1, 'admin', '研发部门', '/iot/binding/export', '127.0.0.1', '内网IP', '{\"params\":{}} ', NULL, 0, NULL, '2026-07-22 14:30:00', 42);
INSERT INTO `sys_oper_log` VALUES (491, '设备属性模板', 5, 'com.ruoyi.iot.controller.DeviceBindingController.export()', 'POST', 1, 'admin', '研发部门', '/iot/binding/export', '127.0.0.1', '内网IP', '{\"params\":{}} ', NULL, 0, NULL, '2026-07-22 14:35:04', 30);
INSERT INTO `sys_oper_log` VALUES (492, '网关数据点位', 5, 'com.ruoyi.iot.controller.EdgeDataPointController.export()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\",\"gatewayId\":\"modbus_local\"}', NULL, 0, NULL, '2026-07-22 14:46:07', 99);
INSERT INTO `sys_oper_log` VALUES (493, '设备属性模板', 6, 'com.ruoyi.iot.controller.DeviceBindingController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/binding/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"1\"}', '{\"msg\":\"恭喜您，数据已全部导入成功！共 77 条，数据如下：<br/>1、设备属性模板 brightness 导入成功<br/>2、设备属性模板 colorTemperature 导入成功<br/>3、设备属性模板 power 导入成功<br/>4、设备属性模板 status 导入成功<br/>5、设备属性模板 brightness 导入成功<br/>6、设备属性模板 colorTemperature 导入成功<br/>7、设备属性模板 power 导入成功<br/>8、设备属性模板 status 导入成功<br/>9、设备属性模板 brightness 导入成功<br/>10、设备属性模板 colorTemperature 导入成功<br/>11、设备属性模板 power 导入成功<br/>12、设备属性模板 status 导入成功<br/>13、设备属性模板 brightness 导入成功<br/>14、设备属性模板 colorTemperature 导入成功<br/>15、设备属性模板 power 导入成功<br/>16、设备属性模板 status 导入成功<br/>17、设备属性模板 brightness 导入成功<br/>18、设备属性模板 colorTemperature 导入成功<br/>19、设备属性模板 power 导入成功<br/>20、设备属性模板 status 导入成功<br/>21、设备属性模板 brightness 导入成功<br/>22、设备属性模板 colorTemperature 导入成功<br/>23、设备属性模板 power 导入成功<br/>24、设备属性模板 status 导入成功<br/>25、设备属性模板 brightness 导入成功<br/>26、设备属性模板 colorTemperature 导入成功<br/>27、设备属性模板 power 导入成功<br/>28、设备属性模板 status 导入成功<br/>29、设备属性模板 brightness 导入成功<br/>30、设备属性模板 colorTemperature 导入成功<br/>31、设备属性模板 power 导入成功<br/>32、设备属性模板 status 导入成功<br/>33、设备属性模板 brightness 导入成功<br/>34、设备属性模板 colorTemperature 导入成功<br/>35、设备属性模板 power 导入成功<br/>36、设备属性模板 status 导入成功<br/>37、设备属性模板 brightness 导入成功<br/>38、设备属性模板 colorTemperature 导入成功<br/>39、设备属性模板 power 导入成功<br/>40、设备属性模板 status 导入成功<br/>41、设备属性模板 brightness 导入成功<br/>42、设备属性模板 colorTemperature 导入成功<br/>43、设备属性模板 power 导入成功<br/>44、设备属性模板 status 导入成功<br/>45、设备属性模板 brightness 导入成功<br/>46、设备属性模板 colorTemperature 导入成功<br/>47、设备属性模板 power 导入成功<br/>48、设备属性模板 status 导入成功<br/>49、设备属性模板 brightness 导入成功<br/>50、设备属性模板 colorTemperature 导入成功<br/>51、设备属性模板 power 导入成功<br/>52、设备属性模板 status 导入成功<br/>53、设备属性模板 brightness 导入成功<br/>54、设备属性模板 colorTemperature 导入成功<br/>55、设备属性模板 power 导入成功<br/>56、设备属性模板 status 导入成功<br/>57、设备属性模板 brightness 导入成功<br/>58、设备属性模板 colorTemperature 导入成功<br/>59、设备属性模板 power 导入成功<br/>60、设备属性模板 status 导入成功<br/>61、设备属性模板 brightness 导入成功<br/>62、设备属性模板 colorTemperature 导入成功<br/>63、设备属性模板 power 导入成功<br/>64、设备属性模板 status 导入成功<br/>65、设备属性模板 brightness 导入成功<br/>66、设备属性模板 colorTemperature 导入成功<br/>67、设备属性模板 power 导入成功<br/>68、设备属性', 0, NULL, '2026-07-22 14:46:48', 218);
INSERT INTO `sys_oper_log` VALUES (494, '设备属性模板', 6, 'com.ruoyi.iot.controller.DeviceBindingController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/binding/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', NULL, 1, '很抱歉，导入失败！共 77 条数据格式不正确，错误如下：<br/>1、设备属性模板 brightness 已存在<br/>2、设备属性模板 colorTemperature 已存在<br/>3、设备属性模板 power 已存在<br/>4、设备属性模板 status 已存在<br/>5、设备属性模板 brightness 已存在<br/>6、设备属性模板 colorTemperature 已存在<br/>7、设备属性模板 power 已存在<br/>8、设备属性模板 status 已存在<br/>9、设备属性模板 brightness 已存在<br/>10、设备属性模板 colorTemperature 已存在<br/>11、设备属性模板 power 已存在<br/>12、设备属性模板 status 已存在<br/>13、设备属性模板 brightness 已存在<br/>14、设备属性模板 colorTemperature 已存在<br/>15、设备属性模板 power 已存在<br/>16、设备属性模板 status 已存在<br/>17、设备属性模板 brightness 已存在<br/>18、设备属性模板 colorTemperature 已存在<br/>19、设备属性模板 power 已存在<br/>20、设备属性模板 status 已存在<br/>21、设备属性模板 brightness 已存在<br/>22、设备属性模板 colorTemperature 已存在<br/>23、设备属性模板 power 已存在<br/>24、设备属性模板 status 已存在<br/>25、设备属性模板 brightness 已存在<br/>26、设备属性模板 colorTemperature 已存在<br/>27、设备属性模板 power 已存在<br/>28、设备属性模板 status 已存在<br/>29、设备属性模板 brightness 已存在<br/>30、设备属性模板 colorTemperature 已存在<br/>31、设备属性模板 power 已存在<br/>32、设备属性模板 status 已存在<br/>33、设备属性模板 brightness 已存在<br/>34、设备属性模板 colorTemperature 已存在<br/>35、设备属性模板 power 已存在<br/>36、设备属性模板 status 已存在<br/>37、设备属性模板 brightness 已存在<br/>38、设备属性模板 colorTemperature 已存在<br/>39、设备属性模板 power 已存在<br/>40、设备属性模板 status 已存在<br/>41、设备属性模板 brightness 已存在<br/>42、设备属性模板 colorTemperature 已存在<br/>43、设备属性模板 power 已存在<br/>44、设备属性模板 status 已存在<br/>45、设备属性模板 brightness 已存在<br/>46、设备属性模板 colorTemperature 已存在<br/>47、设备属性模板 power 已存在<br/>48、设备属性模板 status 已存在<br/>49、设备属性模板 brightness 已存在<br/>50、设备属性模板 colorTemperature 已存在<br/>51、设备属性模板 power 已存在<br/>52、设备属性模板 status 已存在<br/>53、设备属性模板 brightness 已存在<br/>54、设备属性模板 colorTemperature 已存在<br/>55、设备属性模板 power 已存在<br/>56、设备属性模板 status 已存在<br/>57、设备属性模板 brightness 已存在<br/>58、设备属性模板 colorTemperature 已存在<br/>59、设备属性模板 power 已存在<br/>60、设备属性模板 status 已存在<br/>61、设备属性模板 brightness 已存在<br/>62、设备属性模板 colorTemperature 已存在<br/>63、设备属性模板 power 已存在<br/>64、设备属性模板 status 已存在<br/>65、设备属性模板 brightness 已存在<br/>66、设备属性模板 colorTemperature 已存在<br/>67、设备属性模板 power 已存在<br/>68、设备属性模板 status 已存在<br/>69、设备属性模板 brightness 已存在<br/>70、设备属性模板 colorTemperature', '2026-07-22 14:47:29', 413);
INSERT INTO `sys_oper_log` VALUES (495, '设备属性模板', 5, 'com.ruoyi.iot.controller.DeviceBindingController.export()', 'POST', 1, 'admin', '研发部门', '/iot/binding/export', '127.0.0.1', '内网IP', '{\"params\":{}} ', NULL, 0, NULL, '2026-07-22 15:04:08', 45);
INSERT INTO `sys_oper_log` VALUES (496, '设备属性模板', 6, 'com.ruoyi.iot.controller.DeviceBindingController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/binding/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', '{\"msg\":\"恭喜您，数据已全部导入成功！共 76 条，数据如下：<br/>1、设备属性模板 brightness 导入成功<br/>2、设备属性模板 colorTemperature 导入成功<br/>3、设备属性模板 power 导入成功<br/>4、设备属性模板 status 导入成功<br/>5、设备属性模板 brightness 导入成功<br/>6、设备属性模板 colorTemperature 导入成功<br/>7、设备属性模板 power 导入成功<br/>8、设备属性模板 status 导入成功<br/>9、设备属性模板 brightness 导入成功<br/>10、设备属性模板 colorTemperature 导入成功<br/>11、设备属性模板 power 导入成功<br/>12、设备属性模板 status 导入成功<br/>13、设备属性模板 brightness 导入成功<br/>14、设备属性模板 colorTemperature 导入成功<br/>15、设备属性模板 power 导入成功<br/>16、设备属性模板 status 导入成功<br/>17、设备属性模板 brightness 导入成功<br/>18、设备属性模板 colorTemperature 导入成功<br/>19、设备属性模板 power 导入成功<br/>20、设备属性模板 status 导入成功<br/>21、设备属性模板 brightness 导入成功<br/>22、设备属性模板 colorTemperature 导入成功<br/>23、设备属性模板 power 导入成功<br/>24、设备属性模板 status 导入成功<br/>25、设备属性模板 brightness 导入成功<br/>26、设备属性模板 colorTemperature 导入成功<br/>27、设备属性模板 power 导入成功<br/>28、设备属性模板 status 导入成功<br/>29、设备属性模板 brightness 导入成功<br/>30、设备属性模板 colorTemperature 导入成功<br/>31、设备属性模板 power 导入成功<br/>32、设备属性模板 status 导入成功<br/>33、设备属性模板 brightness 导入成功<br/>34、设备属性模板 colorTemperature 导入成功<br/>35、设备属性模板 power 导入成功<br/>36、设备属性模板 status 导入成功<br/>37、设备属性模板 brightness 导入成功<br/>38、设备属性模板 colorTemperature 导入成功<br/>39、设备属性模板 power 导入成功<br/>40、设备属性模板 status 导入成功<br/>41、设备属性模板 brightness 导入成功<br/>42、设备属性模板 colorTemperature 导入成功<br/>43、设备属性模板 power 导入成功<br/>44、设备属性模板 status 导入成功<br/>45、设备属性模板 brightness 导入成功<br/>46、设备属性模板 colorTemperature 导入成功<br/>47、设备属性模板 power 导入成功<br/>48、设备属性模板 status 导入成功<br/>49、设备属性模板 brightness 导入成功<br/>50、设备属性模板 colorTemperature 导入成功<br/>51、设备属性模板 power 导入成功<br/>52、设备属性模板 status 导入成功<br/>53、设备属性模板 brightness 导入成功<br/>54、设备属性模板 colorTemperature 导入成功<br/>55、设备属性模板 power 导入成功<br/>56、设备属性模板 status 导入成功<br/>57、设备属性模板 brightness 导入成功<br/>58、设备属性模板 colorTemperature 导入成功<br/>59、设备属性模板 power 导入成功<br/>60、设备属性模板 status 导入成功<br/>61、设备属性模板 brightness 导入成功<br/>62、设备属性模板 colorTemperature 导入成功<br/>63、设备属性模板 power 导入成功<br/>64、设备属性模板 status 导入成功<br/>65、设备属性模板 brightness 导入成功<br/>66、设备属性模板 colorTemperature 导入成功<br/>67、设备属性模板 power 导入成功<br/>68、设备属性', 0, NULL, '2026-07-22 15:05:13', 194);
INSERT INTO `sys_oper_log` VALUES (497, '设备属性模板', 6, 'com.ruoyi.iot.controller.DeviceBindingController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/binding/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', NULL, 1, '很抱歉，导入失败！共 76 条数据格式不正确，错误如下：<br/>1、设备属性模板 brightness 已存在<br/>2、设备属性模板 colorTemperature 已存在<br/>3、设备属性模板 power 已存在<br/>4、设备属性模板 status 已存在<br/>5、设备属性模板 brightness 已存在<br/>6、设备属性模板 colorTemperature 已存在<br/>7、设备属性模板 power 已存在<br/>8、设备属性模板 status 已存在<br/>9、设备属性模板 brightness 已存在<br/>10、设备属性模板 colorTemperature 已存在<br/>11、设备属性模板 power 已存在<br/>12、设备属性模板 status 已存在<br/>13、设备属性模板 brightness 已存在<br/>14、设备属性模板 colorTemperature 已存在<br/>15、设备属性模板 power 已存在<br/>16、设备属性模板 status 已存在<br/>17、设备属性模板 brightness 已存在<br/>18、设备属性模板 colorTemperature 已存在<br/>19、设备属性模板 power 已存在<br/>20、设备属性模板 status 已存在<br/>21、设备属性模板 brightness 已存在<br/>22、设备属性模板 colorTemperature 已存在<br/>23、设备属性模板 power 已存在<br/>24、设备属性模板 status 已存在<br/>25、设备属性模板 brightness 已存在<br/>26、设备属性模板 colorTemperature 已存在<br/>27、设备属性模板 power 已存在<br/>28、设备属性模板 status 已存在<br/>29、设备属性模板 brightness 已存在<br/>30、设备属性模板 colorTemperature 已存在<br/>31、设备属性模板 power 已存在<br/>32、设备属性模板 status 已存在<br/>33、设备属性模板 brightness 已存在<br/>34、设备属性模板 colorTemperature 已存在<br/>35、设备属性模板 power 已存在<br/>36、设备属性模板 status 已存在<br/>37、设备属性模板 brightness 已存在<br/>38、设备属性模板 colorTemperature 已存在<br/>39、设备属性模板 power 已存在<br/>40、设备属性模板 status 已存在<br/>41、设备属性模板 brightness 已存在<br/>42、设备属性模板 colorTemperature 已存在<br/>43、设备属性模板 power 已存在<br/>44、设备属性模板 status 已存在<br/>45、设备属性模板 brightness 已存在<br/>46、设备属性模板 colorTemperature 已存在<br/>47、设备属性模板 power 已存在<br/>48、设备属性模板 status 已存在<br/>49、设备属性模板 brightness 已存在<br/>50、设备属性模板 colorTemperature 已存在<br/>51、设备属性模板 power 已存在<br/>52、设备属性模板 status 已存在<br/>53、设备属性模板 brightness 已存在<br/>54、设备属性模板 colorTemperature 已存在<br/>55、设备属性模板 power 已存在<br/>56、设备属性模板 status 已存在<br/>57、设备属性模板 brightness 已存在<br/>58、设备属性模板 colorTemperature 已存在<br/>59、设备属性模板 power 已存在<br/>60、设备属性模板 status 已存在<br/>61、设备属性模板 brightness 已存在<br/>62、设备属性模板 colorTemperature 已存在<br/>63、设备属性模板 power 已存在<br/>64、设备属性模板 status 已存在<br/>65、设备属性模板 brightness 已存在<br/>66、设备属性模板 colorTemperature 已存在<br/>67、设备属性模板 power 已存在<br/>68、设备属性模板 status 已存在<br/>69、设备属性模板 brightness 已存在<br/>70、设备属性模板 colorTemperature', '2026-07-22 15:05:24', 119);
INSERT INTO `sys_oper_log` VALUES (498, '设备属性模板', 6, 'com.ruoyi.iot.controller.DeviceBindingController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/binding/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"1\"}', '{\"msg\":\"恭喜您，数据已全部导入成功！共 76 条，数据如下：<br/>1、设备属性模板 brightness 更新成功<br/>2、设备属性模板 colorTemperature 更新成功<br/>3、设备属性模板 power 更新成功<br/>4、设备属性模板 status 更新成功<br/>5、设备属性模板 brightness 更新成功<br/>6、设备属性模板 colorTemperature 更新成功<br/>7、设备属性模板 power 更新成功<br/>8、设备属性模板 status 更新成功<br/>9、设备属性模板 brightness 更新成功<br/>10、设备属性模板 colorTemperature 更新成功<br/>11、设备属性模板 power 更新成功<br/>12、设备属性模板 status 更新成功<br/>13、设备属性模板 brightness 更新成功<br/>14、设备属性模板 colorTemperature 更新成功<br/>15、设备属性模板 power 更新成功<br/>16、设备属性模板 status 更新成功<br/>17、设备属性模板 brightness 更新成功<br/>18、设备属性模板 colorTemperature 更新成功<br/>19、设备属性模板 power 更新成功<br/>20、设备属性模板 status 更新成功<br/>21、设备属性模板 brightness 更新成功<br/>22、设备属性模板 colorTemperature 更新成功<br/>23、设备属性模板 power 更新成功<br/>24、设备属性模板 status 更新成功<br/>25、设备属性模板 brightness 更新成功<br/>26、设备属性模板 colorTemperature 更新成功<br/>27、设备属性模板 power 更新成功<br/>28、设备属性模板 status 更新成功<br/>29、设备属性模板 brightness 更新成功<br/>30、设备属性模板 colorTemperature 更新成功<br/>31、设备属性模板 power 更新成功<br/>32、设备属性模板 status 更新成功<br/>33、设备属性模板 brightness 更新成功<br/>34、设备属性模板 colorTemperature 更新成功<br/>35、设备属性模板 power 更新成功<br/>36、设备属性模板 status 更新成功<br/>37、设备属性模板 brightness 更新成功<br/>38、设备属性模板 colorTemperature 更新成功<br/>39、设备属性模板 power 更新成功<br/>40、设备属性模板 status 更新成功<br/>41、设备属性模板 brightness 更新成功<br/>42、设备属性模板 colorTemperature 更新成功<br/>43、设备属性模板 power 更新成功<br/>44、设备属性模板 status 更新成功<br/>45、设备属性模板 brightness 更新成功<br/>46、设备属性模板 colorTemperature 更新成功<br/>47、设备属性模板 power 更新成功<br/>48、设备属性模板 status 更新成功<br/>49、设备属性模板 brightness 更新成功<br/>50、设备属性模板 colorTemperature 更新成功<br/>51、设备属性模板 power 更新成功<br/>52、设备属性模板 status 更新成功<br/>53、设备属性模板 brightness 更新成功<br/>54、设备属性模板 colorTemperature 更新成功<br/>55、设备属性模板 power 更新成功<br/>56、设备属性模板 status 更新成功<br/>57、设备属性模板 brightness 更新成功<br/>58、设备属性模板 colorTemperature 更新成功<br/>59、设备属性模板 power 更新成功<br/>60、设备属性模板 status 更新成功<br/>61、设备属性模板 brightness 更新成功<br/>62、设备属性模板 colorTemperature 更新成功<br/>63、设备属性模板 power 更新成功<br/>64、设备属性模板 status 更新成功<br/>65、设备属性模板 brightness 更新成功<br/>66、设备属性模板 colorTemperature 更新成功<br/>67、设备属性模板 power 更新成功<br/>68、设备属性', 0, NULL, '2026-07-22 15:05:31', 196);
INSERT INTO `sys_oper_log` VALUES (499, '设备接入网关', 1, 'com.ruoyi.iot.controller.EdgeDeviceController.add()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDevice', '127.0.0.1', '内网IP', '{\"configuration\":\"{\\\"ip_address\\\":\\\"127.0.0.1\\\",\\\"port\\\":1,\\\"refresh_interval\\\":1,\\\"timeout\\\":1,\\\"slave_id\\\":1}\",\"createTime\":\"2026-07-22 16:21:59\",\"id\":\"modbus_mrvtd52c_j1c70\",\"linkStatus\":\"offline\",\"name\":\"rtewr\",\"params\":{},\"protocolId\":\"modbus\",\"status\":\"disable\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-22 16:21:59', 17);
INSERT INTO `sys_oper_log` VALUES (500, '设备接入网关', 3, 'com.ruoyi.iot.controller.EdgeDeviceController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/edgeDevice/modbus_mrvtd52c_j1c70', '127.0.0.1', '内网IP', '[\"modbus_mrvtd52c_j1c70\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-22 16:22:03', 9);
INSERT INTO `sys_oper_log` VALUES (501, '通知公告', 3, 'com.ruoyi.web.controller.system.SysNoticeController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/notice/3,2,1', '127.0.0.1', '内网IP', '[3,2,1] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 00:21:01', 21);
INSERT INTO `sys_oper_log` VALUES (502, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_stat_data_lineage', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 16:21:54', 41);
INSERT INTO `sys_oper_log` VALUES (503, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_sub_item', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 16:21:56', 29);
INSERT INTO `sys_oper_log` VALUES (504, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_branch_line', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 16:32:19', 49);
INSERT INTO `sys_oper_log` VALUES (505, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_branch_binding', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 16:32:25', 30);
INSERT INTO `sys_oper_log` VALUES (506, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_stat_data_lineage', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:11:58', 33);
INSERT INTO `sys_oper_log` VALUES (507, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_sub_item', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:11:59', 29);
INSERT INTO `sys_oper_log` VALUES (508, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_tariff_detail', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:11:59', 29);
INSERT INTO `sys_oper_log` VALUES (509, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_stat_data_history_lineage', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:01', 20);
INSERT INTO `sys_oper_log` VALUES (510, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_formula', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:01', 25);
INSERT INTO `sys_oper_log` VALUES (511, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_type', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:02', 29);
INSERT INTO `sys_oper_log` VALUES (512, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_usage_calc_task', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:02', 44);
INSERT INTO `sys_oper_log` VALUES (513, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_formula_dependency', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:03', 20);
INSERT INTO `sys_oper_log` VALUES (514, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_usage_recalc_job_task', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:04', 17);
INSERT INTO `sys_oper_log` VALUES (515, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_usage_recalc_job', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:04', 38);
INSERT INTO `sys_oper_log` VALUES (516, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_tariff_detail', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:06', 26);
INSERT INTO `sys_oper_log` VALUES (517, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_tariff_policie', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:07', 26);
INSERT INTO `sys_oper_log` VALUES (518, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_allocation_rule_target', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:07', 22);
INSERT INTO `sys_oper_log` VALUES (519, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_anomaly_rule', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:08', 35);
INSERT INTO `sys_oper_log` VALUES (520, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_area', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:09', 23);
INSERT INTO `sys_oper_log` VALUES (521, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_area_data_daily', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:09', 30);
INSERT INTO `sys_oper_log` VALUES (522, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_area_data_hourly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:10', 31);
INSERT INTO `sys_oper_log` VALUES (523, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_area_data_min', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:10', 28);
INSERT INTO `sys_oper_log` VALUES (524, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_area_data_monthly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:11', 33);
INSERT INTO `sys_oper_log` VALUES (525, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_area_data_yearly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:12', 27);
INSERT INTO `sys_oper_log` VALUES (526, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_benchmark', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:14', 28);
INSERT INTO `sys_oper_log` VALUES (527, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_billing_statement_line', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:15', 21);
INSERT INTO `sys_oper_log` VALUES (528, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_branch_dimension_binding', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:16', 31);
INSERT INTO `sys_oper_log` VALUES (529, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_branch_line', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:17', 22);
INSERT INTO `sys_oper_log` VALUES (530, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_carbon_factor', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:17', 23);
INSERT INTO `sys_oper_log` VALUES (531, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_config_validation_issue', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:18', 20);
INSERT INTO `sys_oper_log` VALUES (532, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_item_data_daily', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:18', 32);
INSERT INTO `sys_oper_log` VALUES (533, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_item_data_hourly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:19', 26);
INSERT INTO `sys_oper_log` VALUES (534, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_item_data_min', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:19', 24);
INSERT INTO `sys_oper_log` VALUES (535, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_item_data_monthly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:20', 29);
INSERT INTO `sys_oper_log` VALUES (536, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_item_data_yearly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:23', 36);
INSERT INTO `sys_oper_log` VALUES (537, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_line_data_daily', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:24', 36);
INSERT INTO `sys_oper_log` VALUES (538, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_line_data_hourly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:24', 25);
INSERT INTO `sys_oper_log` VALUES (539, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_line_data_min', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:25', 24);
INSERT INTO `sys_oper_log` VALUES (540, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:25', 19);
INSERT INTO `sys_oper_log` VALUES (541, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_branch_binding', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:27', 18);
INSERT INTO `sys_oper_log` VALUES (542, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:30', 22);
INSERT INTO `sys_oper_log` VALUES (543, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_channel', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:30', 48);
INSERT INTO `sys_oper_log` VALUES (544, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_data_daily', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:31', 33);
INSERT INTO `sys_oper_log` VALUES (545, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_data_hourly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:32', 28);
INSERT INTO `sys_oper_log` VALUES (546, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_anomaly_event', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:33', 37);
INSERT INTO `sys_oper_log` VALUES (547, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_allocation_rule', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:35', 20);
INSERT INTO `sys_oper_log` VALUES (548, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_data_min', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:36', 23);
INSERT INTO `sys_oper_log` VALUES (549, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_data_yearly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:36', 29);
INSERT INTO `sys_oper_log` VALUES (550, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_line_data_yearly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:37', 22);
INSERT INTO `sys_oper_log` VALUES (551, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_line_data_monthly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:38', 30);
INSERT INTO `sys_oper_log` VALUES (552, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_allocation_result', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:38', 32);
INSERT INTO `sys_oper_log` VALUES (553, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_carbon_conversion_fact', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:39', 32);
INSERT INTO `sys_oper_log` VALUES (554, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_benchmark_result', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:40', 30);
INSERT INTO `sys_oper_log` VALUES (555, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_billing_statement', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:41', 33);
INSERT INTO `sys_oper_log` VALUES (556, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_data_monthly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:42', 29);
INSERT INTO `sys_oper_log` VALUES (557, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_reconciliation_result_detail', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:43', 19);
INSERT INTO `sys_oper_log` VALUES (558, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_reconciliation_result', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:12:44', 32);
INSERT INTO `sys_oper_log` VALUES (559, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_sub_item', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:19:22', 20);
INSERT INTO `sys_oper_log` VALUES (560, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/182', '127.0.0.1', '内网IP', '[182] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:19:35', 15);
INSERT INTO `sys_oper_log` VALUES (561, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/140', '127.0.0.1', '内网IP', '[140] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 17:19:49', 11);
INSERT INTO `sys_oper_log` VALUES (562, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/183', '127.0.0.1', '内网IP', '[183] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 18:24:57', 11);
INSERT INTO `sys_oper_log` VALUES (563, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/184', '127.0.0.1', '内网IP', '[184] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 18:25:06', 10);
INSERT INTO `sys_oper_log` VALUES (564, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/187,186,181,180,178,177,147,150,148,149,154,153,152,155,156,157,158,161,162,163,164,165,166,167,168,169,170,146,145,137,142,141,139,138', '127.0.0.1', '内网IP', '[187,186,181,180,178,177,147,150,148,149,154,153,152,155,156,157,158,161,162,163,164,165,166,167,168,169,170,146,145,137,142,141,139,138] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 18:26:20', 14);
INSERT INTO `sys_oper_log` VALUES (565, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/179', '127.0.0.1', '内网IP', '[179] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 18:26:25', 8);
INSERT INTO `sys_oper_log` VALUES (566, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_sub_item', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 18:26:47', 24);
INSERT INTO `sys_oper_log` VALUES (567, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_type', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 18:26:48', 20);
INSERT INTO `sys_oper_log` VALUES (568, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_area', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 18:26:49', 26);
INSERT INTO `sys_oper_log` VALUES (569, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_branch_dimension_binding', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 18:26:49', 21);
INSERT INTO `sys_oper_log` VALUES (570, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_branch_line', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 18:26:50', 21);
INSERT INTO `sys_oper_log` VALUES (571, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 18:26:51', 22);
INSERT INTO `sys_oper_log` VALUES (572, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_branch_binding', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 18:26:51', 16);
INSERT INTO `sys_oper_log` VALUES (573, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_channel', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 18:26:52', 33);
INSERT INTO `sys_oper_log` VALUES (574, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_data_daily', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 18:26:53', 32);
INSERT INTO `sys_oper_log` VALUES (575, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_data_hourly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 18:26:53', 27);
INSERT INTO `sys_oper_log` VALUES (576, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_data_min', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 18:26:55', 24);
INSERT INTO `sys_oper_log` VALUES (577, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_data_monthly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 18:26:56', 30);
INSERT INTO `sys_oper_log` VALUES (578, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/energy_meter_data_yearly', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 18:26:57', 26);
INSERT INTO `sys_oper_log` VALUES (579, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"energyArea\",\"className\":\"EnergyArea\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键ID\",\"columnId\":2537,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:02\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":151,\"updateBy\":\"\",\"updateTime\":\"2026-07-24 18:26:49\",\"usableColumn\":false},{\"capJavaField\":\"ParentAreaId\",\"columnComment\":\"父区域ID；为空表示建筑下的根区域\",\"columnId\":2538,\"columnName\":\"parent_area_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:02\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"parentAreaId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":151,\"updateBy\":\"\",\"updateTime\":\"2026-07-24 18:26:49\",\"usableColumn\":false},{\"capJavaField\":\"BuildingId\",\"columnComment\":\"所属建筑ID\",\"columnId\":2539,\"columnName\":\"building_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:02\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"buildingId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":151,\"updateBy\":\"\",\"updateTime\":\"2026-07-24 18:26:49\",\"usableColumn\":false},{\"capJavaField\":\"AreaCode\",\"columnComment\":\"区域编码；同一建筑下唯一\",\"columnId\":2540,\"columnName\":\"area_code\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:02\",\"dictType\":\"\",\"edit\":true,\"htmlTy', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 18:27:49', 39);
INSERT INTO `sys_oper_log` VALUES (580, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"energyBranchLine\",\"className\":\"EnergyBranchLine\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键ID\",\"columnId\":2716,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:02\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":160,\"updateBy\":\"\",\"updateTime\":\"2026-07-24 18:26:50\",\"usableColumn\":false},{\"capJavaField\":\"ParentId\",\"columnComment\":\"父支路ID\",\"columnId\":2717,\"columnName\":\"parent_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:02\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"parentId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":true,\"tableId\":160,\"updateBy\":\"\",\"updateTime\":\"2026-07-24 18:26:50\",\"usableColumn\":true},{\"capJavaField\":\"BuildingId\",\"columnComment\":\"建筑ID\",\"columnId\":2718,\"columnName\":\"building_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:02\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"buildingId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":160,\"updateBy\":\"\",\"updateTime\":\"2026-07-24 18:26:50\",\"usableColumn\":false},{\"capJavaField\":\"EnergyTypeId\",\"columnComment\":\"能源类型ID\",\"columnId\":2719,\"columnName\":\"energy_type_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:02\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increm', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 18:28:13', 16);
INSERT INTO `sys_oper_log` VALUES (581, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"energy_sub_item,energy_type,energy_area,energy_branch_dimension_binding,energy_branch_line,energy_meter,energy_meter_branch_binding,energy_meter_channel,energy_meter_data_daily,energy_meter_data_hourly,energy_meter_data_min,energy_meter_data_monthly,energy_meter_data_yearly\"}', NULL, 0, NULL, '2026-07-24 18:28:55', 1011);
INSERT INTO `sys_oper_log` VALUES (582, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/devices', '127.0.0.1', '内网IP', '{\"alias\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-07-11 13:56:47\",\"description\":\"\",\"deviceType\":\"gatewayS\",\"ext\":\"\",\"gatewayId\":\"modbus_local\",\"groupId\":100,\"id\":\"test1\",\"linkStatus\":\"online\",\"name\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"token\":\"\",\"updateTime\":\"2026-07-24 19:37:28\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 19:37:28', 32);
INSERT INTO `sys_oper_log` VALUES (583, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/devices', '127.0.0.1', '内网IP', '{\"alias\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 14:29:45\",\"description\":\"\",\"deviceType\":\"gatewayS\",\"ext\":\"\",\"gatewayId\":\"modbus_local\",\"groupId\":103,\"id\":\"test2\",\"linkStatus\":\"online\",\"name\":\"test2\",\"params\":{},\"productId\":\"dimmer\",\"token\":\"\",\"updateTime\":\"2026-07-24 19:37:40\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 19:37:40', 9);
INSERT INTO `sys_oper_log` VALUES (584, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/devices', '127.0.0.1', '内网IP', '{\"alias\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 14:29:45\",\"description\":\"\",\"deviceType\":\"gatewayS\",\"ext\":\"\",\"gatewayId\":\"modbus_local\",\"groupId\":100,\"id\":\"test2\",\"linkStatus\":\"online\",\"name\":\"test2\",\"params\":{},\"productId\":\"dimmer\",\"token\":\"\",\"updateTime\":\"2026-07-24 19:37:46\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 19:37:46', 9);
INSERT INTO `sys_oper_log` VALUES (585, '设备分组', 1, 'com.ruoyi.iot.controller.DeviceGroupController.add()', 'POST', 1, 'admin', '研发部门', '/iot/deviceGroup', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-07-24 19:38:47\",\"groupId\":104,\"groupName\":\"asdw\",\"orderNum\":0,\"params\":{},\"parentId\":100,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 19:38:47', 17);
INSERT INTO `sys_oper_log` VALUES (586, '设备分组', 3, 'com.ruoyi.iot.controller.DeviceGroupController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/deviceGroup/104', '127.0.0.1', '内网IP', '[104] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 19:38:50', 11);
INSERT INTO `sys_oper_log` VALUES (587, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"device_groups\",\"tplWebType\":\"element-plus\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 19:40:31', 42);
INSERT INTO `sys_oper_log` VALUES (588, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"deviceGroups\",\"className\":\"DeviceGroups\",\"columns\":[{\"capJavaField\":\"GroupId\",\"columnComment\":\"设备分组id\",\"columnId\":3243,\"columnName\":\"group_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-24 19:40:31\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"groupId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":189,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ParentId\",\"columnComment\":\"父类id\",\"columnId\":3244,\"columnName\":\"parent_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-24 19:40:31\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"parentId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":true,\"tableId\":189,\"updateBy\":\"\",\"usableColumn\":true},{\"capJavaField\":\"Ancestors\",\"columnComment\":\"祖级列表\",\"columnId\":3245,\"columnName\":\"ancestors\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-24 19:40:31\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"ancestors\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":true,\"tableId\":189,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"GroupName\",\"columnComment\":\"设备分组名称\",\"columnId\":3246,\"columnName\":\"group_name\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-24 19:40:31\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 19:41:18', 50);
INSERT INTO `sys_oper_log` VALUES (589, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"deviceGroups\",\"className\":\"DeviceGroups\",\"columns\":[{\"capJavaField\":\"GroupId\",\"columnComment\":\"设备分组id\",\"columnId\":3243,\"columnName\":\"group_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-24 19:40:31\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"groupId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":189,\"updateBy\":\"\",\"updateTime\":\"2026-07-24 19:41:18\",\"usableColumn\":false},{\"capJavaField\":\"ParentId\",\"columnComment\":\"父类id\",\"columnId\":3244,\"columnName\":\"parent_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-24 19:40:31\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"parentId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":true,\"tableId\":189,\"updateBy\":\"\",\"updateTime\":\"2026-07-24 19:41:18\",\"usableColumn\":true},{\"capJavaField\":\"Ancestors\",\"columnComment\":\"祖级列表\",\"columnId\":3245,\"columnName\":\"ancestors\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-24 19:40:31\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"ancestors\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":true,\"tableId\":189,\"updateBy\":\"\",\"updateTime\":\"2026-07-24 19:41:18\",\"usableColumn\":false},{\"capJavaField\":\"GroupName\",\"columnComment\":\"设备分组名称\",\"columnId\":3246,\"columnName\":\"group_name\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-24 19:40:31\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 19:41:24', 22);
INSERT INTO `sys_oper_log` VALUES (590, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"device_groups\"}', NULL, 0, NULL, '2026-07-24 19:41:37', 58);
INSERT INTO `sys_oper_log` VALUES (591, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/189', '127.0.0.1', '内网IP', '[189] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 19:48:36', 25);
INSERT INTO `sys_oper_log` VALUES (592, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"device_group\",\"tplWebType\":\"element-plus\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 19:48:43', 44);
INSERT INTO `sys_oper_log` VALUES (593, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"deviceGroup\",\"className\":\"DeviceGroup\",\"columns\":[{\"capJavaField\":\"GroupId\",\"columnComment\":\"设备分组id\",\"columnId\":3255,\"columnName\":\"group_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-24 19:48:43\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"groupId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":190,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ParentId\",\"columnComment\":\"父类id\",\"columnId\":3256,\"columnName\":\"parent_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-24 19:48:43\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"parentId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":true,\"tableId\":190,\"updateBy\":\"\",\"usableColumn\":true},{\"capJavaField\":\"Ancestors\",\"columnComment\":\"祖级列表\",\"columnId\":3257,\"columnName\":\"ancestors\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-24 19:48:43\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"ancestors\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":true,\"tableId\":190,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"GroupName\",\"columnComment\":\"设备分组名称\",\"columnId\":3258,\"columnName\":\"group_name\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-24 19:48:43\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"is', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 19:49:10', 36);
INSERT INTO `sys_oper_log` VALUES (594, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"deviceGroup\",\"className\":\"DeviceGroup\",\"columns\":[{\"capJavaField\":\"GroupId\",\"columnComment\":\"设备分组id\",\"columnId\":3255,\"columnName\":\"group_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-24 19:48:43\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"groupId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":190,\"updateBy\":\"\",\"updateTime\":\"2026-07-24 19:49:10\",\"usableColumn\":false},{\"capJavaField\":\"ParentId\",\"columnComment\":\"父类id\",\"columnId\":3256,\"columnName\":\"parent_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-24 19:48:43\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"parentId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":true,\"tableId\":190,\"updateBy\":\"\",\"updateTime\":\"2026-07-24 19:49:10\",\"usableColumn\":true},{\"capJavaField\":\"Ancestors\",\"columnComment\":\"祖级列表\",\"columnId\":3257,\"columnName\":\"ancestors\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-24 19:48:43\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"ancestors\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":true,\"tableId\":190,\"updateBy\":\"\",\"updateTime\":\"2026-07-24 19:49:10\",\"usableColumn\":false},{\"capJavaField\":\"GroupName\",\"columnComment\":\"设备分组名称\",\"columnId\":3258,\"columnName\":\"group_name\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-24 19:48:43\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 19:49:33', 25);
INSERT INTO `sys_oper_log` VALUES (595, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"device_group\"}', NULL, 0, NULL, '2026-07-24 19:49:37', 147);
INSERT INTO `sys_oper_log` VALUES (596, '设备分组', 1, 'com.ruoyi.iot.controller.DeviceGroupController.add()', 'POST', 1, 'admin', '研发部门', '/iot/deviceGroup', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-07-24 19:55:20\",\"groupId\":105,\"groupName\":\"testA\",\"orderNum\":1,\"params\":{},\"parentId\":0} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 19:55:20', 105);
INSERT INTO `sys_oper_log` VALUES (597, '设备分组', 1, 'com.ruoyi.iot.controller.DeviceGroupController.add()', 'POST', 1, 'admin', '研发部门', '/iot/deviceGroup', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-07-24 19:55:32\",\"groupId\":106,\"groupName\":\"testa\",\"orderNum\":1,\"params\":{},\"parentId\":105} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 19:55:32', 11);
INSERT INTO `sys_oper_log` VALUES (598, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/devices', '127.0.0.1', '内网IP', '{\"alias\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-07-11 13:56:47\",\"description\":\"\",\"deviceType\":\"gatewayS\",\"ext\":\"\",\"gatewayId\":\"modbus_local\",\"groupId\":105,\"id\":\"test1\",\"linkStatus\":\"online\",\"name\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"token\":\"\",\"updateTime\":\"2026-07-24 19:56:46\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-24 19:56:46', 16);
INSERT INTO `sys_oper_log` VALUES (599, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/device_group', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-25 09:31:58', 48);
INSERT INTO `sys_oper_log` VALUES (600, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"device_group\"}', NULL, 0, NULL, '2026-07-25 09:32:06', 130);
INSERT INTO `sys_oper_log` VALUES (601, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"device_group\"}', NULL, 0, NULL, '2026-07-25 09:32:15', 54);
INSERT INTO `sys_oper_log` VALUES (602, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.batchWrite()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write/batch', '127.0.0.1', '内网IP', '{\"groupId\":105,\"productId\":\"dimmer\",\"telemetryKey\":\"colorTemperature\",\"value\":\"88\"} ', '{\"msg\":\"批量下置失败\",\"code\":500,\"data\":{\"failureCount\":19,\"failures\":[{\"deviceId\":\"test1\",\"deviceName\":\"test1\",\"message\":\"边缘网关不存在或着离线！\"},{\"deviceId\":\"test2\",\"deviceName\":\"test2\",\"message\":\"边缘网关不存在或着离线！\"},{\"deviceId\":\"test3\",\"deviceName\":\"test3\",\"message\":\"边缘网关不存在或着离线！\"},{\"deviceId\":\"test4\",\"deviceName\":\"test4\",\"message\":\"边缘网关不存在或着离线！\"},{\"deviceId\":\"test5\",\"deviceName\":\"test5\",\"message\":\"边缘网关不存在或着离线！\"},{\"deviceId\":\"test6\",\"deviceName\":\"test6\",\"message\":\"边缘网关不存在或着离线！\"},{\"deviceId\":\"test7\",\"deviceName\":\"test7\",\"message\":\"边缘网关不存在或着离线！\"},{\"deviceId\":\"test8\",\"deviceName\":\"test8\",\"message\":\"边缘网关不存在或着离线！\"},{\"deviceId\":\"test9\",\"deviceName\":\"test9\",\"message\":\"边缘网关不存在或着离线！\"},{\"deviceId\":\"test10\",\"deviceName\":\"test10\",\"message\":\"边缘网关不存在或着离线！\"},{\"deviceId\":\"test11\",\"deviceName\":\"test11\",\"message\":\"边缘网关不存在或着离线！\"},{\"deviceId\":\"test12\",\"deviceName\":\"test12\",\"message\":\"边缘网关不存在或着离线！\"},{\"deviceId\":\"test13\",\"deviceName\":\"test13\",\"message\":\"边缘网关不存在或着离线！\"},{\"deviceId\":\"test14\",\"deviceName\":\"test14\",\"message\":\"边缘网关不存在或着离线！\"},{\"deviceId\":\"test15\",\"deviceName\":\"test15\",\"message\":\"边缘网关不存在或着离线！\"},{\"deviceId\":\"test16\",\"deviceName\":\"test16\",\"message\":\"边缘网关不存在或着离线！\"},{\"deviceId\":\"test17\",\"deviceName\":\"test17\",\"message\":\"边缘网关不存在或着离线！\"},{\"deviceId\":\"test18\",\"deviceName\":\"test18\",\"message\":\"边缘网关不存在或着离线！\"},{\"deviceId\":\"test19\",\"deviceName\":\"test19\",\"message\":\"边缘网关不存在或着离线！\"}],\"groupId\":105,\"matchedGroupIds\":[105,106],\"productId\":\"dimmer\",\"successCount\":0,\"telemetryKey\":\"colorTemperature\",\"totalCount\":19}}', 0, NULL, '2026-07-25 20:15:33', 24);
INSERT INTO `sys_oper_log` VALUES (603, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.batchWrite()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write/batch', '127.0.0.1', '内网IP', '{\"groupId\":105,\"productId\":\"dimmer\",\"telemetryKey\":\"brightness\",\"value\":\"77\"} ', '{\"msg\":\"批量下置成功\",\"code\":200,\"data\":{\"failureCount\":0,\"failures\":[],\"groupId\":105,\"matchedGroupIds\":[105,106],\"productId\":\"dimmer\",\"successCount\":19,\"telemetryKey\":\"brightness\",\"totalCount\":19}}', 0, NULL, '2026-07-25 20:17:44', 295);
INSERT INTO `sys_oper_log` VALUES (604, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.batchWrite()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write/batch', '127.0.0.1', '内网IP', '{\"groupId\":105,\"productId\":\"dimmer\",\"telemetryKey\":\"brightness\",\"value\":\"1\"} ', '{\"msg\":\"批量下置成功\",\"code\":200,\"data\":{\"failureCount\":0,\"failures\":[],\"groupId\":105,\"matchedGroupIds\":[105,106],\"productId\":\"dimmer\",\"successCount\":19,\"telemetryKey\":\"brightness\",\"totalCount\":19}}', 0, NULL, '2026-07-25 20:18:03', 301);
INSERT INTO `sys_oper_log` VALUES (605, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.batchWrite()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write/batch', '127.0.0.1', '内网IP', '{\"groupId\":105,\"productId\":\"dimmer\",\"telemetryKey\":\"brightness\",\"value\":\"11\"} ', '{\"msg\":\"批量下置成功\",\"code\":200,\"data\":{\"failureCount\":0,\"failures\":[],\"groupId\":105,\"matchedGroupIds\":[105,106],\"productId\":\"dimmer\",\"successCount\":19,\"telemetryKey\":\"brightness\",\"totalCount\":19}}', 0, NULL, '2026-07-25 20:19:16', 309);
INSERT INTO `sys_oper_log` VALUES (606, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"energy/energyMeterChannel/index\",\"createTime\":\"2026-07-24 18:31:41\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2327,\"menuName\":\"通道配置管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2176,\"path\":\"energyMeterChannel\",\"perms\":\"energy:energyMeterChannel:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-25 21:41:37', 72);
INSERT INTO `sys_oper_log` VALUES (607, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"energy/energyBranchDimBinding/index\",\"createTime\":\"2026-07-24 18:32:34\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2333,\"menuName\":\"支路归属管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2176,\"path\":\"energyBranchDimBinding\",\"perms\":\"energy:energyBranchDimBinding:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-25 21:41:51', 12);
INSERT INTO `sys_oper_log` VALUES (608, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"energy/energyMeterBranchBinding/index\",\"createTime\":\"2026-07-24 18:32:45\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2339,\"menuName\":\"逻辑绑定管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2176,\"path\":\"energyMeterBranchBinding\",\"perms\":\"energy:energyMeterBranchBinding:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-25 21:41:56', 59);
INSERT INTO `sys_oper_log` VALUES (609, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"energy/energyMeterDataDaily/index\",\"createTime\":\"2026-07-24 18:33:06\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2345,\"menuName\":\"日级统计管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2176,\"path\":\"energyMeterDataDaily\",\"perms\":\"energy:energyMeterDataDaily:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-25 21:42:07', 13);
INSERT INTO `sys_oper_log` VALUES (610, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"energy/energyMeterDataMin/index\",\"createTime\":\"2026-07-24 18:33:20\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2357,\"menuName\":\"分钟统计管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2176,\"path\":\"energyMeterDataMin\",\"perms\":\"energy:energyMeterDataMin:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-25 21:42:11', 10);
INSERT INTO `sys_oper_log` VALUES (611, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"energy/energyMeterDataHourly/index\",\"createTime\":\"2026-07-24 18:33:17\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2351,\"menuName\":\"小时统计管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2176,\"path\":\"energyMeterDataHourly\",\"perms\":\"energy:energyMeterDataHourly:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-25 21:42:15', 18);
INSERT INTO `sys_oper_log` VALUES (612, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"energy/energyMeterDataMin/index\",\"createTime\":\"2026-07-24 18:33:20\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2357,\"menuName\":\"分钟统计管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2176,\"path\":\"energyMeterDataMin\",\"perms\":\"energy:energyMeterDataMin:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-25 21:42:18', 121);
INSERT INTO `sys_oper_log` VALUES (613, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"energy/energyMeterDataDaily/index\",\"createTime\":\"2026-07-24 18:33:06\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2345,\"menuName\":\"日级统计管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2176,\"path\":\"energyMeterDataDaily\",\"perms\":\"energy:energyMeterDataDaily:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-25 21:42:21', 98);
INSERT INTO `sys_oper_log` VALUES (614, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"energy/energyMeterDataMonthly/index\",\"createTime\":\"2026-07-24 18:33:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2363,\"menuName\":\"月级统计管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2176,\"path\":\"energyMeterDataMonthly\",\"perms\":\"energy:energyMeterDataMonthly:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-25 21:42:25', 194);
INSERT INTO `sys_oper_log` VALUES (615, '传输协议', 3, 'com.ruoyi.iot.controller.TransportProtocolController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/protocol/mqtt', '127.0.0.1', '内网IP', '[\"mqtt\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-26 10:48:03', 12);
INSERT INTO `sys_oper_log` VALUES (616, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2345', '127.0.0.1', '内网IP', '2345 ', '{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}', 0, NULL, '2026-07-27 00:18:16', 7);
INSERT INTO `sys_oper_log` VALUES (617, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2346', '127.0.0.1', '内网IP', '2346 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 00:18:19', 16);
INSERT INTO `sys_oper_log` VALUES (618, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2347', '127.0.0.1', '内网IP', '2347 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 00:18:20', 10);
INSERT INTO `sys_oper_log` VALUES (619, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2348', '127.0.0.1', '内网IP', '2348 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 00:18:20', 10);
INSERT INTO `sys_oper_log` VALUES (620, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2349', '127.0.0.1', '内网IP', '2349 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 00:18:22', 10);
INSERT INTO `sys_oper_log` VALUES (621, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2350', '127.0.0.1', '内网IP', '2350 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 00:18:23', 8);
INSERT INTO `sys_oper_log` VALUES (622, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2345', '127.0.0.1', '内网IP', '2345 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 00:18:24', 10);
INSERT INTO `sys_oper_log` VALUES (623, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"energy/energyBranchLine/index\",\"createTime\":\"2026-07-25 18:08:18\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2387,\"menuName\":\"能源支路管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2176,\"path\":\"energyBranchLine\",\"perms\":\"energy:energyBranchLine:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 00:24:01', 18);
INSERT INTO `sys_oper_log` VALUES (624, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"energy/energySubItem/index\",\"createTime\":\"2026-07-24 18:33:31\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2381,\"menuName\":\"能耗分项管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2176,\"path\":\"energySubItem\",\"perms\":\"energy:energySubItem:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 00:24:15', 12);
INSERT INTO `sys_oper_log` VALUES (625, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"energy/energyMeter/index\",\"createTime\":\"2026-07-24 18:33:28\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2375,\"menuName\":\"能耗表具管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2176,\"path\":\"energyMeter\",\"perms\":\"energy:energyMeter:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 00:24:35', 13);
INSERT INTO `sys_oper_log` VALUES (626, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"energy/energyArea/index\",\"createTime\":\"2026-07-24 18:31:35\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2321,\"menuName\":\"区域管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2176,\"path\":\"energyArea\",\"perms\":\"energy:energyArea:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 00:25:00', 12);
INSERT INTO `sys_oper_log` VALUES (627, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"energy/energyBranchLine/index\",\"createTime\":\"2026-07-25 18:08:18\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2387,\"menuName\":\"支路管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2176,\"path\":\"energyBranchLine\",\"perms\":\"energy:energyBranchLine:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 00:25:06', 13);
INSERT INTO `sys_oper_log` VALUES (628, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"energy/energySubItem/index\",\"createTime\":\"2026-07-24 18:33:31\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2381,\"menuName\":\"分项管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2176,\"path\":\"energySubItem\",\"perms\":\"energy:energySubItem:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 00:25:09', 12);
INSERT INTO `sys_oper_log` VALUES (629, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"energy/energyMeter/index\",\"createTime\":\"2026-07-24 18:33:28\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2375,\"menuName\":\"表具管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2176,\"path\":\"energyMeter\",\"perms\":\"energy:energyMeter:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 00:25:12', 11);
INSERT INTO `sys_oper_log` VALUES (630, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"energy/energyMeterBranchBinding/index\",\"createTime\":\"2026-07-24 18:32:45\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2339,\"menuName\":\"逻辑绑定管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2176,\"path\":\"energyMeterBranchBinding\",\"perms\":\"energy:energyMeterBranchBinding:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 00:25:55', 12);
INSERT INTO `sys_oper_log` VALUES (631, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"energyReport\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\" 报表管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2176,\"path\":\"/energyReport\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 00:31:11', 10);
INSERT INTO `sys_oper_log` VALUES (632, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"energyReport\",\"createTime\":\"2026-07-27 00:31:11\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2393,\"menuName\":\" 报表管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2176,\"path\":\"/energyReport\",\"perms\":\"energy:energyReport:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 00:31:28', 12);
INSERT INTO `sys_oper_log` VALUES (633, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"energyReport\",\"createTime\":\"2026-07-27 00:31:11\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2393,\"menuName\":\" 报表管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2176,\"path\":\"energy/energyReport/index\",\"perms\":\"energy:energyReport:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 00:31:42', 10);
INSERT INTO `sys_oper_log` VALUES (634, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"energy/energyReport/index\",\"createTime\":\"2026-07-27 00:31:11\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2393,\"menuName\":\" 报表管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2176,\"path\":\"ems/energyReport\",\"perms\":\"energy:energyReport:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 00:33:17', 11);
INSERT INTO `sys_oper_log` VALUES (635, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"energy/energyReport/index\",\"createTime\":\"2026-07-27 00:31:11\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2393,\"menuName\":\" 报表管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2176,\"path\":\"energyReport\",\"perms\":\"energy:energyReport:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 00:33:28', 10);
INSERT INTO `sys_oper_log` VALUES (636, '能源逻辑计主数据；不直接保存设备属性通道和业务归属', 1, 'com.ruoyi.energy.controller.EnergyMeterController.add()', 'POST', 1, 'admin', '研发部门', '/energy/energyMeter', '127.0.0.1', '内网IP', '{\"commissionedAt\":\"2026-07-01\",\"createTime\":\"2026-07-27 00:51:06\",\"energyTypeId\":1,\"id\":1,\"isVirtual\":1,\"meterCode\":\"test\",\"meterName\":\"test\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 00:51:06', 18);
INSERT INTO `sys_oper_log` VALUES (637, '逻辑计与能源支路的版本化有效期绑定', 1, 'com.ruoyi.energy.controller.EnergyMeterBranchBindingController.add()', 'POST', 1, 'admin', '研发部门', '/energy/energyMeterBranchBinding', '127.0.0.1', '内网IP', '{\"branchId\":5,\"id\":1,\"meterId\":1,\"meterRole\":\"PRIMARY\",\"params\":{},\"status\":\"0\",\"validFrom\":\"2026-07-27\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 19:50:46', 20);
INSERT INTO `sys_oper_log` VALUES (638, '逻辑计与能源支路的版本化有效期绑定', 1, 'com.ruoyi.energy.controller.EnergyMeterBranchBindingController.add()', 'POST', 1, 'admin', '研发部门', '/energy/energyMeterBranchBinding', '127.0.0.1', '内网IP', '{\"branchId\":5,\"id\":2,\"meterId\":1,\"meterRole\":\"PRIMARY\",\"params\":{},\"status\":\"0\",\"validFrom\":\"2026-07-27\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 19:55:41', 110);
INSERT INTO `sys_oper_log` VALUES (639, '逻辑计与能源支路的版本化有效期绑定', 1, 'com.ruoyi.energy.controller.EnergyMeterBranchBindingController.add()', 'POST', 1, 'admin', '研发部门', '/energy/energyMeterBranchBinding', '127.0.0.1', '内网IP', '{\"branchId\":5,\"meterId\":1,\"meterRole\":\"PRIMARY\",\"params\":{},\"status\":\"ACTIVE\",\"validFrom\":\"2026-07-27\"} ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'1\' for key \'energy_meter_branch_binding.uk_meter_branch_version\'\r\n### The error may exist in file [D:\\workspace\\lightning\\lightning-energy\\target\\classes\\mapper\\energy\\EnergyMeterBranchBindingMapper.xml]\r\n### The error may involve com.ruoyi.energy.mapper.EnergyMeterBranchBindingMapper.insertEnergyMeterBranchBinding-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into energy_meter_branch_binding          ( branch_id,             meter_id,             meter_role,             valid_from,                          status )           values ( ?,             ?,             ?,             ?,                          ? )\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'1\' for key \'energy_meter_branch_binding.uk_meter_branch_version\'\n; Duplicate entry \'1\' for key \'energy_meter_branch_binding.uk_meter_branch_version\'', '2026-07-27 20:00:32', 443);
INSERT INTO `sys_oper_log` VALUES (640, '逻辑计与能源支路的版本化有效期绑定', 1, 'com.ruoyi.energy.controller.EnergyMeterBranchBindingController.add()', 'POST', 1, 'admin', '研发部门', '/energy/energyMeterBranchBinding', '127.0.0.1', '内网IP', '{\"branchId\":5,\"id\":4,\"meterId\":1,\"meterRole\":\"PRIMARY\",\"params\":{},\"status\":\"ACTIVE\",\"validFrom\":\"2026-07-27\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 20:00:42', 11);
INSERT INTO `sys_oper_log` VALUES (641, '逻辑计与能源支路的版本化有效期绑定', 3, 'com.ruoyi.energy.controller.EnergyMeterBranchBindingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/energy/energyMeterBranchBinding/4', '127.0.0.1', '内网IP', '[4] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 20:01:21', 11);
INSERT INTO `sys_oper_log` VALUES (642, '逻辑计与能源支路的版本化有效期绑定', 1, 'com.ruoyi.energy.controller.EnergyMeterBranchBindingController.add()', 'POST', 1, 'admin', '研发部门', '/energy/energyMeterBranchBinding', '127.0.0.1', '内网IP', '{\"branchId\":5,\"id\":5,\"meterId\":1,\"meterRole\":\"PRIMARY\",\"params\":{},\"status\":\"ACTIVE\",\"validFrom\":\"2026-07-27\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 20:01:33', 9);
INSERT INTO `sys_oper_log` VALUES (643, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/products', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2025-10-28 21:41:09\",\"dataExpiration\":0,\"deviceType\":\"gatewayS\",\"id\":\"electrical\",\"name\":\"电气测量\",\"params\":{},\"productCategoryId\":102,\"protocolId\":\"modbus\",\"status\":\"disable\",\"storageInterval\":1000,\"updateBy\":\"\",\"updateTime\":\"2026-07-27 20:15:40\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 20:15:40', 26);
INSERT INTO `sys_oper_log` VALUES (644, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/products', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2025-10-28 21:41:09\",\"dataExpiration\":0,\"deviceType\":\"gatewayS\",\"id\":\"electrical\",\"name\":\"电气测量\",\"params\":{},\"productCategoryId\":102,\"protocolId\":\"modbus\",\"status\":\"disable\",\"storageInterval\":60000,\"updateBy\":\"\",\"updateTime\":\"2026-07-27 20:15:53\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 20:15:54', 10);
INSERT INTO `sys_oper_log` VALUES (645, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"electrical\",\"status\":\"enable\"}', '{\"msg\":\"启用成功\",\"code\":200}', 0, NULL, '2026-07-27 20:15:57', 19);
INSERT INTO `sys_oper_log` VALUES (646, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"101\"} ', '{\"msg\":\"边缘网关未连接\",\"code\":500}', 0, NULL, '2026-07-27 20:32:57', 11);
INSERT INTO `sys_oper_log` VALUES (647, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"101\"} ', '{\"msg\":\"边缘网关未连接\",\"code\":500}', 0, NULL, '2026-07-27 20:33:00', 0);
INSERT INTO `sys_oper_log` VALUES (648, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.colorTemperature\",\"telemetryKey\":\"colorTemperature\",\"value\":\"20275\"} ', '{\"msg\":\"边缘网关未连接\",\"code\":500}', 0, NULL, '2026-07-27 20:33:02', 0);
INSERT INTO `sys_oper_log` VALUES (649, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"102\"} ', '{\"msg\":\"边缘网关未连接\",\"code\":500}', 0, NULL, '2026-07-27 20:33:16', 1);
INSERT INTO `sys_oper_log` VALUES (650, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test4\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"5\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-27 20:33:37', 163);
INSERT INTO `sys_oper_log` VALUES (651, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test4\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"3\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-27 20:33:38', 12);
INSERT INTO `sys_oper_log` VALUES (652, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test4\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"4\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-27 20:33:40', 8);
INSERT INTO `sys_oper_log` VALUES (653, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test4\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"5\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-27 20:33:42', 9);
INSERT INTO `sys_oper_log` VALUES (654, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test4\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"5\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-27 20:33:45', 14);
INSERT INTO `sys_oper_log` VALUES (655, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test4\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"7\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-27 20:33:46', 6);
INSERT INTO `sys_oper_log` VALUES (656, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test4\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.power\",\"telemetryKey\":\"power\",\"value\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-27 20:33:53', 2);
INSERT INTO `sys_oper_log` VALUES (657, '设备属性模板', 3, 'com.ruoyi.iot.controller.DeviceBindingController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/binding/fea54b7d51284991ad2b654aec26f772', '127.0.0.1', '内网IP', '[\"fea54b7d51284991ad2b654aec26f772\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 20:34:07', 9);
INSERT INTO `sys_oper_log` VALUES (658, '设备属性模板', 1, 'com.ruoyi.iot.controller.DeviceBindingController.add()', 'POST', 1, 'admin', '研发部门', '/iot/binding', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-07-27 20:34:10\",\"dataType\":\"enum\",\"deviceId\":\"test4\",\"edgePointId\":\"2070439791224295424\",\"edgePointName\":\"modbus4\",\"gatewayId\":\"modbus_local\",\"gatewayName\":\"modbusLocal\",\"id\":\"abb2eaa1b2f54ebfbbd287da24df15b8\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.status\",\"telemetryKey\":\"status\",\"unitSymbol\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 20:34:10', 11);
INSERT INTO `sys_oper_log` VALUES (659, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"75\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-27 20:36:33', 3);
INSERT INTO `sys_oper_log` VALUES (660, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"74\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-27 20:36:35', 11);
INSERT INTO `sys_oper_log` VALUES (661, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.power\",\"telemetryKey\":\"power\",\"value\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-27 20:36:49', 21);
INSERT INTO `sys_oper_log` VALUES (662, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.power\",\"telemetryKey\":\"power\",\"value\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-27 20:36:56', 3);
INSERT INTO `sys_oper_log` VALUES (663, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.colorTemperature\",\"telemetryKey\":\"colorTemperature\",\"value\":\"85\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-27 20:37:02', 102);
INSERT INTO `sys_oper_log` VALUES (664, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.colorTemperature\",\"telemetryKey\":\"colorTemperature\",\"value\":\"87\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-27 20:37:04', 7);
INSERT INTO `sys_oper_log` VALUES (665, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/products', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2025-03-04 21:48:20\",\"dataExpiration\":36500000,\"description\":\"dsc\",\"deviceType\":\"gatewayS\",\"id\":\"dimmer\",\"name\":\"照明控制\",\"params\":{},\"productCategoryId\":100,\"protocolId\":\"modbus\",\"status\":\"enable\",\"storageInterval\":1002,\"updateBy\":\"\",\"updateTime\":\"2026-07-27 20:47:20\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 20:47:20', 8);
INSERT INTO `sys_oper_log` VALUES (666, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"94\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-27 20:56:10', 15);
INSERT INTO `sys_oper_log` VALUES (667, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"102\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-27 20:56:12', 13);
INSERT INTO `sys_oper_log` VALUES (668, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"value\":\"94\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-27 21:00:28', 12);
INSERT INTO `sys_oper_log` VALUES (669, '网关数据点位', 5, 'com.ruoyi.iot.controller.EdgeDataPointController.export()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"6\"}', NULL, 1, 'Cannot invoke \"com.ruoyi.iot.domain.EdgeDevice.getProtocolId()\" because \"edgeDevice\" is null', '2026-07-27 21:56:19', 4);
INSERT INTO `sys_oper_log` VALUES (670, '网关数据点位', 5, 'com.ruoyi.iot.controller.EdgeDataPointController.export()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\",\"gatewayId\":\"modbus_local\"}', NULL, 0, NULL, '2026-07-27 21:56:23', 681);
INSERT INTO `sys_oper_log` VALUES (671, '网关数据点位', 1, 'com.ruoyi.iot.controller.EdgeDataPointController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"true\",\"gatewayId\":\"modbus_local\"}', '{\"msg\":\"恭喜您，数据已全部导入成功！共 1014 条，数据如下：<br/>1、网关：modbus_local，点位:modbus1 更新成功<br/>2、网关：modbus_local，点位:modbus2 更新成功<br/>3、网关：modbus_local，点位:modbus3 更新成功<br/>4、网关：modbus_local，点位:modbus4 更新成功<br/>5、网关：modbus_local，点位:modbus5 更新成功<br/>6、网关：modbus_local，点位:modbus6 更新成功<br/>7、网关：modbus_local，点位:modbus7 更新成功<br/>8、网关：modbus_local，点位:modbus8 更新成功<br/>9、网关：modbus_local，点位:modbus9 更新成功<br/>10、网关：modbus_local，点位:modbus10 更新成功<br/>11、网关：modbus_local，点位:modbus11 更新成功<br/>12、网关：modbus_local，点位:modbus12 更新成功<br/>13、网关：modbus_local，点位:modbus13 更新成功<br/>14、网关：modbus_local，点位:modbus14 更新成功<br/>15、网关：modbus_local，点位:modbus15 更新成功<br/>16、网关：modbus_local，点位:modbus16 更新成功<br/>17、网关：modbus_local，点位:modbus17 更新成功<br/>18、网关：modbus_local，点位:modbus18 更新成功<br/>19、网关：modbus_local，点位:modbus19 更新成功<br/>20、网关：modbus_local，点位:modbus20 更新成功<br/>21、网关：modbus_local，点位:modbus21 更新成功<br/>22、网关：modbus_local，点位:modbus22 更新成功<br/>23、网关：modbus_local，点位:modbus23 更新成功<br/>24、网关：modbus_local，点位:modbus24 更新成功<br/>25、网关：modbus_local，点位:modbus25 更新成功<br/>26、网关：modbus_local，点位:modbus26 更新成功<br/>27、网关：modbus_local，点位:modbus27 更新成功<br/>28、网关：modbus_local，点位:modbus28 更新成功<br/>29、网关：modbus_local，点位:modbus29 更新成功<br/>30、网关：modbus_local，点位:modbus30 更新成功<br/>31、网关：modbus_local，点位:modbus31 更新成功<br/>32、网关：modbus_local，点位:modbus32 更新成功<br/>33、网关：modbus_local，点位:modbus33 更新成功<br/>34、网关：modbus_local，点位:modbus34 更新成功<br/>35、网关：modbus_local，点位:modbus35 更新成功<br/>36、网关：modbus_local，点位:modbus36 更新成功<br/>37、网关：modbus_local，点位:modbus37 更新成功<br/>38、网关：modbus_local，点位:modbus38 更新成功<br/>39、网关：modbus_local，点位:modbus39 更新成功<br/>40、网关：modbus_local，点位:modbus40 更新成功<br/>41、网关：modbus_local，点位:modbus41 更新成功<br/>42、网关：modbus_local，点位:modbus42 更新成功<br/>43、网关：modbus_local，点位:modbus43 更新成功<br/>44、网关：modbus_local，点位:modbus44 更新成功<br/>45、网关：modbus_local，点位:modbus45 更新成功<br/>46、网关：modbus_local，点位:modbus46 更新成功<br/>47、网关：modbus_local，点位:modbus47 更新成功<br/>48、网关：modbus_local，点位:modbus48 更新成功<br/>49、网关：modbus_local，点位:modbus49 更新成功<br/>50、网关：modbus_loca', 0, NULL, '2026-07-27 22:00:39', 7439);
INSERT INTO `sys_oper_log` VALUES (672, '设备', 1, 'com.ruoyi.iot.controller.DevicesController.add()', 'POST', 1, 'admin', '研发部门', '/iot/devices', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-07-27 22:03:50\",\"deviceType\":\"gatewayS\",\"gatewayId\":\"modbus_local\",\"groupId\":106,\"id\":\"el1\",\"name\":\"el1\",\"params\":{},\"productId\":\"electrical\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 22:03:50', 17);
INSERT INTO `sys_oper_log` VALUES (673, '设备', 5, 'com.ruoyi.iot.controller.DevicesController.export()', 'POST', 1, 'admin', '研发部门', '/iot/devices/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"2\"}', NULL, 0, NULL, '2026-07-27 22:03:55', 50);
INSERT INTO `sys_oper_log` VALUES (674, '设备', 6, 'com.ruoyi.iot.controller.DevicesController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/devices/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', NULL, 1, '很抱歉，导入失败！共 1 条数据格式不正确，错误如下：<br/>1、设备 el1 已存在', '2026-07-27 22:04:39', 198);
INSERT INTO `sys_oper_log` VALUES (675, '设备', 6, 'com.ruoyi.iot.controller.DevicesController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/devices/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"1\"}', '{\"msg\":\"恭喜您，数据已全部导入成功！共 47 条，数据如下：<br/>1、设备 el1 更新成功<br/>2、设备 el2 导入成功<br/>3、设备 el3 导入成功<br/>4、设备 el4 导入成功<br/>5、设备 el5 导入成功<br/>6、设备 el6 导入成功<br/>7、设备 el7 导入成功<br/>8、设备 el8 导入成功<br/>9、设备 el9 导入成功<br/>10、设备 el10 导入成功<br/>11、设备 el11 导入成功<br/>12、设备 el12 导入成功<br/>13、设备 el13 导入成功<br/>14、设备 el14 导入成功<br/>15、设备 el15 导入成功<br/>16、设备 el16 导入成功<br/>17、设备 el17 导入成功<br/>18、设备 el18 导入成功<br/>19、设备 el19 导入成功<br/>20、设备 el20 导入成功<br/>21、设备 el21 导入成功<br/>22、设备 el22 导入成功<br/>23、设备 el23 导入成功<br/>24、设备 el24 导入成功<br/>25、设备 el25 导入成功<br/>26、设备 el26 导入成功<br/>27、设备 el27 导入成功<br/>28、设备 el28 导入成功<br/>29、设备 el29 导入成功<br/>30、设备 el30 导入成功<br/>31、设备 el31 导入成功<br/>32、设备 el32 导入成功<br/>33、设备 el33 导入成功<br/>34、设备 el34 导入成功<br/>35、设备 el35 导入成功<br/>36、设备 el36 导入成功<br/>37、设备 el37 导入成功<br/>38、设备 el38 导入成功<br/>39、设备 el39 导入成功<br/>40、设备 el40 导入成功<br/>41、设备 el41 导入成功<br/>42、设备 el42 导入成功<br/>43、设备 el43 导入成功<br/>44、设备 el44 导入成功<br/>45、设备 el45 导入成功<br/>46、设备 el46 导入成功<br/>47、设备 el47 导入成功\",\"code\":200}', 0, NULL, '2026-07-27 22:04:50', 147);
INSERT INTO `sys_oper_log` VALUES (676, '设备属性模板', 5, 'com.ruoyi.iot.controller.DeviceBindingController.export()', 'POST', 1, 'admin', '研发部门', '/iot/binding/export', '127.0.0.1', '内网IP', '{\"productId\":\"electrical\"}', NULL, 0, NULL, '2026-07-27 22:05:00', 62);
INSERT INTO `sys_oper_log` VALUES (677, '设备属性模板', 5, 'com.ruoyi.iot.controller.DeviceBindingController.export()', 'POST', 1, 'admin', '研发部门', '/iot/binding/export', '127.0.0.1', '内网IP', '{\"productId\":\"electrical\"}', NULL, 0, NULL, '2026-07-27 22:07:15', 523);
INSERT INTO `sys_oper_log` VALUES (678, '设备属性模板', 5, 'com.ruoyi.iot.controller.DeviceBindingController.export()', 'POST', 1, 'admin', '研发部门', '/iot/binding/export', '127.0.0.1', '内网IP', '{\"productId\":\"electrical\"}', NULL, 0, NULL, '2026-07-27 22:08:25', 496);
INSERT INTO `sys_oper_log` VALUES (679, '网关数据点位', 5, 'com.ruoyi.iot.controller.EdgeDataPointController.export()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\",\"gatewayId\":\"modbus_local\"}', NULL, 0, NULL, '2026-07-27 22:14:58', 159);
INSERT INTO `sys_oper_log` VALUES (680, '设备属性模板', 6, 'com.ruoyi.iot.controller.DeviceBindingController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/binding/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\"}', '{\"msg\":\"恭喜您，数据已全部导入成功！共 141 条，数据如下：<br/>1、设备属性模板 Current 导入成功<br/>2、设备属性模板 ForwardActiveEnergy 导入成功<br/>3、设备属性模板 Voltage 导入成功<br/>4、设备属性模板 Current 导入成功<br/>5、设备属性模板 ForwardActiveEnergy 导入成功<br/>6、设备属性模板 Voltage 导入成功<br/>7、设备属性模板 Current 导入成功<br/>8、设备属性模板 ForwardActiveEnergy 导入成功<br/>9、设备属性模板 Voltage 导入成功<br/>10、设备属性模板 Current 导入成功<br/>11、设备属性模板 ForwardActiveEnergy 导入成功<br/>12、设备属性模板 Voltage 导入成功<br/>13、设备属性模板 Current 导入成功<br/>14、设备属性模板 ForwardActiveEnergy 导入成功<br/>15、设备属性模板 Voltage 导入成功<br/>16、设备属性模板 Current 导入成功<br/>17、设备属性模板 ForwardActiveEnergy 导入成功<br/>18、设备属性模板 Voltage 导入成功<br/>19、设备属性模板 Current 导入成功<br/>20、设备属性模板 ForwardActiveEnergy 导入成功<br/>21、设备属性模板 Voltage 导入成功<br/>22、设备属性模板 Current 导入成功<br/>23、设备属性模板 ForwardActiveEnergy 导入成功<br/>24、设备属性模板 Voltage 导入成功<br/>25、设备属性模板 Current 导入成功<br/>26、设备属性模板 ForwardActiveEnergy 导入成功<br/>27、设备属性模板 Voltage 导入成功<br/>28、设备属性模板 Current 导入成功<br/>29、设备属性模板 ForwardActiveEnergy 导入成功<br/>30、设备属性模板 Voltage 导入成功<br/>31、设备属性模板 Current 导入成功<br/>32、设备属性模板 ForwardActiveEnergy 导入成功<br/>33、设备属性模板 Voltage 导入成功<br/>34、设备属性模板 Current 导入成功<br/>35、设备属性模板 ForwardActiveEnergy 导入成功<br/>36、设备属性模板 Voltage 导入成功<br/>37、设备属性模板 Current 导入成功<br/>38、设备属性模板 ForwardActiveEnergy 导入成功<br/>39、设备属性模板 Voltage 导入成功<br/>40、设备属性模板 Current 导入成功<br/>41、设备属性模板 ForwardActiveEnergy 导入成功<br/>42、设备属性模板 Voltage 导入成功<br/>43、设备属性模板 Current 导入成功<br/>44、设备属性模板 ForwardActiveEnergy 导入成功<br/>45、设备属性模板 Voltage 导入成功<br/>46、设备属性模板 Current 导入成功<br/>47、设备属性模板 ForwardActiveEnergy 导入成功<br/>48、设备属性模板 Voltage 导入成功<br/>49、设备属性模板 Current 导入成功<br/>50、设备属性模板 ForwardActiveEnergy 导入成功<br/>51、设备属性模板 Voltage 导入成功<br/>52、设备属性模板 Current 导入成功<br/>53、设备属性模板 ForwardActiveEnergy 导入成功<br/>54、设备属性模板 Voltage 导入成功<br/>55、设备属性模板 Current 导入成功<br/>56、设备属性模板 ForwardActiveEnergy 导入成功<br/>57、设备属性模板 Voltage 导入成功<br/>58、设备属性模板 Current 导入成功<br/>59、设备属性模板 ForwardActiveEnergy 导入成功<br/>60、设备属性模板 Voltage 导入成功<br/>61、设备属性模板 Current 导入成功<br/>62、设备属性模板 ForwardActiveEnergy 导入成功<br/>63、设备属性模板 Voltage 导入成功<br/>64、设备属性模板 Curren', 0, NULL, '2026-07-27 22:19:51', 677);
INSERT INTO `sys_oper_log` VALUES (681, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"electrical\",\"status\":\"disable\"}', '{\"msg\":\"停用成功\",\"code\":200}', 0, NULL, '2026-07-27 22:20:09', 14);
INSERT INTO `sys_oper_log` VALUES (682, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.updateProductStatus()', 'PUT', 1, 'admin', '研发部门', '/iot/products/change/status', '127.0.0.1', '内网IP', '{\"id\":\"electrical\",\"status\":\"enable\"}', '{\"msg\":\"启用成功\",\"code\":200}', 0, NULL, '2026-07-27 22:20:12', 12);
INSERT INTO `sys_oper_log` VALUES (683, '通过产品属性快捷新增表具及通道', 1, 'com.ruoyi.energy.controller.EnergyMeterController.quickCreate()', 'POST', 1, 'admin', '研发部门', '/energy/energyMeter/quick-create', '127.0.0.1', '内网IP', '{\"energyTypeId\":1,\"productId\":\"electrical\",\"properties\":[{\"direction\":\"IMPORT\",\"metricCode\":\"Current\",\"metricRole\":\"CURRENT\",\"multiplier\":1,\"productPropertyId\":\"electrical.Current\"},{\"direction\":\"IMPORT\",\"isPrimaryUsage\":1,\"metricCode\":\"ForwardActiveEnergy\",\"metricRole\":\"ENERGY_READING\",\"multiplier\":1,\"productPropertyId\":\"electrical.ForwardActiveEnergy\"},{\"direction\":\"IMPORT\",\"metricCode\":\"Voltage\",\"metricRole\":\"VOLTAGE\",\"multiplier\":1,\"productPropertyId\":\"electrical.Voltage\"}],\"remark\":\"由产品批量创建\",\"status\":\"ACTIVE\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"deviceCount\":47,\"meters\":[{\"channels\":[{\"createdAt\":\"2026-07-27\",\"deviceId\":\"el1\",\"direction\":\"IMPORT\",\"id\":1,\"isPrimaryUsage\":0,\"measurementType\":\"CUMULATIVE_READING\",\"meterId\":2,\"metricCode\":\"Current\",\"metricRole\":\"CURRENT\",\"multiplier\":1,\"params\":{},\"productId\":\"electrical\",\"readingMode\":\"INSTANT\",\"resetPolicy\":\"ZERO_AS_RESET\",\"samplePeriodSec\":60,\"sourceUnit\":\"A\",\"status\":\"ACTIVE\",\"telemetryKey\":\"Current\",\"updatedAt\":\"2026-07-27\",\"validFrom\":\"2026-07-27\",\"versionNo\":1},{\"createdAt\":\"2026-07-27\",\"deviceId\":\"el1\",\"direction\":\"IMPORT\",\"id\":2,\"isPrimaryUsage\":1,\"measurementType\":\"CUMULATIVE_READING\",\"meterId\":2,\"metricCode\":\"ForwardActiveEnergy\",\"metricRole\":\"ENERGY_READING\",\"multiplier\":1,\"params\":{},\"productId\":\"electrical\",\"readingMode\":\"CUMULATIVE\",\"resetPolicy\":\"ZERO_AS_RESET\",\"samplePeriodSec\":60,\"sourceUnit\":\"kW·h\",\"status\":\"ACTIVE\",\"telemetryKey\":\"ForwardActiveEnergy\",\"updatedAt\":\"2026-07-27\",\"validFrom\":\"2026-07-27\",\"versionNo\":1},{\"createdAt\":\"2026-07-27\",\"deviceId\":\"el1\",\"direction\":\"IMPORT\",\"id\":3,\"isPrimaryUsage\":0,\"measurementType\":\"CUMULATIVE_READING\",\"meterId\":2,\"metricCode\":\"Voltage\",\"metricRole\":\"VOLTAGE\",\"multiplier\":1,\"params\":{},\"productId\":\"electrical\",\"readingMode\":\"INSTANT\",\"resetPolicy\":\"ZERO_AS_RESET\",\"samplePeriodSec\":60,\"sourceUnit\":\"V\",\"status\":\"ACTIVE\",\"telemetryKey\":\"Voltage\",\"updatedAt\":\"2026-07-27\",\"validFrom\":\"2026-07-27\",\"versionNo\":1}],\"meter\":{\"commissionedAt\":\"2026-07-27\",\"createBy\":\"admin\",\"createTime\":\"2026-07-27 22:20:53\",\"energyTypeId\":1,\"id\":2,\"isVirtual\":0,\"meterCode\":\"el1\",\"meterName\":\"el1\",\"params\":{},\"remark\":\"由产品批量创建\",\"status\":\"ACTIVE\"}},{\"channels\":[{\"createdAt\":\"2026-07-27\",\"deviceId\":\"el2\",\"direction\":\"IMPORT\",\"id\":4,\"isPrimaryUsage\":0,\"measurementType\":\"CUMULATIVE_READING\",\"meterId\":3,\"metricCode\":\"Current\",\"metricRole\":\"CURRENT\",\"multiplier\":1,\"params\":{},\"productId\":\"electrical\",\"readingMode\":\"INSTANT\",\"resetPolicy\":\"ZERO_AS_RESET\",\"samplePeriodSec\":60,\"sourceUnit\":\"A\",\"status\":\"', 0, NULL, '2026-07-27 22:20:53', 246);
INSERT INTO `sys_oper_log` VALUES (684, '能源逻辑计主数据；不直接保存设备属性通道和业务归属', 3, 'com.ruoyi.energy.controller.EnergyMeterController.remove()', 'DELETE', 1, 'admin', '研发部门', '/energy/energyMeter/1', '127.0.0.1', '内网IP', '[1] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 22:20:59', 10);
INSERT INTO `sys_oper_log` VALUES (685, '逻辑计与能源支路的版本化有效期绑定', 1, 'com.ruoyi.energy.controller.EnergyMeterBranchBindingController.add()', 'POST', 1, 'admin', '研发部门', '/energy/energyMeterBranchBinding', '127.0.0.1', '内网IP', '{\"branchId\":5,\"id\":6,\"meterId\":2,\"meterRole\":\"PRIMARY\",\"params\":{},\"status\":\"ACTIVE\",\"validFrom\":\"2026-07-27\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 22:57:39', 25);
INSERT INTO `sys_oper_log` VALUES (686, '逻辑计与能源支路的版本化有效期绑定', 1, 'com.ruoyi.energy.controller.EnergyMeterBranchBindingController.add()', 'POST', 1, 'admin', '研发部门', '/energy/energyMeterBranchBinding', '127.0.0.1', '内网IP', '{\"branchId\":6,\"id\":7,\"meterId\":3,\"meterRole\":\"PRIMARY\",\"params\":{},\"status\":\"ACTIVE\",\"validFrom\":\"2026-07-27\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 22:57:53', 11);
INSERT INTO `sys_oper_log` VALUES (687, '逻辑计与能源支路的版本化有效期绑定', 1, 'com.ruoyi.energy.controller.EnergyMeterBranchBindingController.add()', 'POST', 1, 'admin', '研发部门', '/energy/energyMeterBranchBinding', '127.0.0.1', '内网IP', '{\"branchId\":7,\"id\":8,\"meterId\":4,\"meterRole\":\"PRIMARY\",\"params\":{},\"status\":\"ACTIVE\",\"validFrom\":\"2026-07-27\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-27 22:58:05', 13);
INSERT INTO `sys_oper_log` VALUES (688, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"energy/energyType/index\",\"createTime\":\"2026-07-22 01:59:57\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2315,\"menuName\":\"能源类型\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2176,\"path\":\"energyType\",\"perms\":\"energy:energyType:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-28 22:28:49', 19);
INSERT INTO `sys_oper_log` VALUES (689, '保存菜单排序', 2, 'com.ruoyi.web.controller.system.SysMenuController.updateSort()', 'PUT', 1, 'admin', '研发部门', '/system/menu/updateSort', '127.0.0.1', '内网IP', '{\"menuIds\":\"2315,2321,2381,2387,2393\",\"orderNums\":\"6,5,4,3,2\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-28 22:30:02', 21);
INSERT INTO `sys_oper_log` VALUES (690, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"energySubItem\",\"className\":\"EnergySubItem\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键ID\",\"columnId\":3182,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":185,\"updateBy\":\"\",\"updateTime\":\"2026-07-24 18:26:47\",\"usableColumn\":false},{\"capJavaField\":\"EnergyTypeId\",\"columnComment\":\"能源类型ID；同一分项树内父子节点能源类型必须一致\",\"columnId\":3183,\"columnName\":\"energy_type_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"energyTypeId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":185,\"updateBy\":\"\",\"updateTime\":\"2026-07-24 18:26:47\",\"usableColumn\":false},{\"capJavaField\":\"ParentId\",\"columnComment\":\"父级分项ID；为空表示能源类型下的根分项\",\"columnId\":3184,\"columnName\":\"parent_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"parentId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":true,\"tableId\":185,\"updateBy\":\"\",\"updateTime\":\"2026-07-24 18:26:47\",\"usableColumn\":true},{\"capJavaField\":\"Name\",\"columnComment\":\"分项名称\",\"columnId\":3185,\"columnName\":\"name\",\"columnType\":\"varchar(128)\",\"createBy\":\"admin\",\"createTime\":\"2026-07-22 01:41:03\",\"dictType\":\"\",\"edit\":true,\"htm', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-28 22:36:40', 37);
INSERT INTO `sys_oper_log` VALUES (691, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"energy_sub_item\"}', NULL, 0, NULL, '2026-07-28 22:36:50', 73);
INSERT INTO `sys_oper_log` VALUES (692, '能源空间区域树；用于区域统计及面积、人数分摊', 1, 'com.ruoyi.energy.controller.EnergyAreaController.add()', 'POST', 1, 'admin', '研发部门', '/energy/energyArea', '127.0.0.1', '内网IP', '{\"areaCode\":\"aaa\",\"buildingId\":1,\"children\":[],\"createTime\":\"2026-07-28 23:39:41\",\"id\":8,\"params\":{},\"parentAreaId\":0} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-28 23:39:41', 40);
INSERT INTO `sys_oper_log` VALUES (693, '能源空间区域树；用于区域统计及面积、人数分摊', 2, 'com.ruoyi.energy.controller.EnergyAreaController.edit()', 'PUT', 1, 'admin', '研发部门', '/energy/energyArea', '127.0.0.1', '内网IP', '{\"areaCode\":\"aaa\",\"areaName\":\"aa\",\"areaType\":\"OTHER\",\"buildingId\":1,\"children\":[],\"createBy\":\"\",\"createTime\":\"2026-07-28 23:39:41\",\"defaultPersonnelCount\":0,\"id\":8,\"params\":{},\"parentAreaId\":0,\"sortOrder\":0,\"status\":\"ACTIVE\",\"updateBy\":\"\",\"updateTime\":\"2026-07-28 23:39:54\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-28 23:39:54', 8);
INSERT INTO `sys_oper_log` VALUES (694, '能源空间区域树；用于区域统计及面积、人数分摊', 3, 'com.ruoyi.energy.controller.EnergyAreaController.remove()', 'DELETE', 1, 'admin', '研发部门', '/energy/energyArea/8', '127.0.0.1', '内网IP', '[8] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-28 23:40:33', 11);
INSERT INTO `sys_oper_log` VALUES (695, '规则场景', 2, 'com.ruoyi.iot.controller.RuleSceneController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/ruleScene', '127.0.0.1', '内网IP', '{\"actions\":\"[{\\\"actionType\\\":\\\"DEVICE_PROPERTY\\\",\\\"targetDeviceId\\\":\\\"\\\",\\\"setProperty\\\":\\\"\\\",\\\"setValue\\\":\\\"\\\",\\\"delaySeconds\\\":1,\\\"message\\\":\\\"\\\",\\\"productId\\\":\\\"dimmer\\\",\\\"deviceId\\\":\\\"test1\\\",\\\"property\\\":\\\"colorTemperature\\\",\\\"value\\\":\\\"88\\\"}]\",\"conditionLogic\":\"AND\",\"conditions\":\"[]\",\"description\":\"\",\"id\":\"scene_mrqhlbsp_ydxt5\",\"name\":\"test\",\"params\":{},\"state\":\"disable\",\"triggers\":\"[{\\\"triggerType\\\":\\\"DEVICE\\\",\\\"deviceId\\\":\\\"test1\\\",\\\"property\\\":\\\"brightness\\\",\\\"value\\\":\\\"10\\\",\\\"cronExpression\\\":\\\"\\\",\\\"alarm\\\":\\\"enable\\\",\\\"productId\\\":\\\"dimmer\\\",\\\"operator\\\":\\\"==\\\"}]\",\"updateTime\":\"2026-07-29 19:45:25\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-29 19:45:25', 15);
INSERT INTO `sys_oper_log` VALUES (696, '规则场景', 2, 'com.ruoyi.iot.controller.RuleSceneController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/ruleScene', '127.0.0.1', '内网IP', '{\"actions\":\"[{\\\"actionType\\\":\\\"DEVICE_PROPERTY\\\",\\\"targetDeviceId\\\":\\\"\\\",\\\"setProperty\\\":\\\"\\\",\\\"setValue\\\":\\\"\\\",\\\"delaySeconds\\\":1,\\\"message\\\":\\\"\\\",\\\"productId\\\":\\\"dimmer\\\",\\\"deviceId\\\":\\\"test1\\\",\\\"property\\\":\\\"colorTemperature\\\",\\\"value\\\":\\\"88\\\"}]\",\"conditionLogic\":\"AND\",\"conditions\":\"[]\",\"description\":\"\",\"id\":\"scene_mrqhlbsp_ydxt5\",\"name\":\"test\",\"params\":{},\"startTime\":\"2026-07-29 20:03:16\",\"state\":\"enable\",\"triggers\":\"[{\\\"triggerType\\\":\\\"DEVICE\\\",\\\"deviceId\\\":\\\"test1\\\",\\\"property\\\":\\\"brightness\\\",\\\"value\\\":\\\"10\\\",\\\"cronExpression\\\":\\\"\\\",\\\"alarm\\\":\\\"enable\\\",\\\"productId\\\":\\\"dimmer\\\",\\\"operator\\\":\\\"==\\\"}]\",\"updateTime\":\"2026-07-29 20:03:16\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-29 20:03:16', 9);
INSERT INTO `sys_oper_log` VALUES (697, '场景联动历史记录', 3, 'com.ruoyi.iot.controller.RuleSceneLogController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/ruleSceneLog/1,2,3,4,5,6,7,8,9', '127.0.0.1', '内网IP', '[1,2,3,4,5,6,7,8,9] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-29 20:07:16', 15);
INSERT INTO `sys_oper_log` VALUES (698, '告警记录', 3, 'com.ruoyi.iot.controller.AlarmLogController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/alarmLog/1', '127.0.0.1', '内网IP', '[1] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-29 22:53:42', 17);
INSERT INTO `sys_oper_log` VALUES (699, '告警记录', 2, 'com.ruoyi.iot.controller.AlarmLogController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/alarmLog', '127.0.0.1', '内网IP', '{\"handleMessage\":\"啊啊啊啊\",\"handleTime\":\"2026-07-29\",\"handleType\":\"4\",\"id\":2,\"params\":{},\"state\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-29 23:27:56', 27);
INSERT INTO `sys_oper_log` VALUES (700, '告警记录', 2, 'com.ruoyi.iot.controller.AlarmLogController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/alarmLog', '127.0.0.1', '内网IP', '{\"handleMessage\":\"啊啊啊啊\",\"handleTime\":\"2026-07-29\",\"handleType\":\"3\",\"id\":2,\"params\":{},\"state\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-29 23:28:05', 9);
INSERT INTO `sys_oper_log` VALUES (701, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.power\",\"telemetryKey\":\"power\",\"value\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-07-29 23:32:23', 9);
INSERT INTO `sys_oper_log` VALUES (702, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"#/project/items\",\"createTime\":\"2026-07-19 12:28:24\",\"icon\":\"clipboard\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2314,\"menuName\":\"我的项目\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2313,\"path\":\"#/project/items\",\"perms\":\"\",\"routeName\":\"project\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-31 17:09:25', 20);
INSERT INTO `sys_oper_log` VALUES (703, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"#/project/items\",\"createTime\":\"2026-07-19 12:28:24\",\"icon\":\"clipboard\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":2314,\"menuName\":\"我的项目\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2313,\"path\":\"http://localhost/view/#/project/device-components\",\"perms\":\"\",\"routeName\":\"project\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-31 17:11:05', 13);
INSERT INTO `sys_oper_log` VALUES (704, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"/view/#/project/items\",\"createTime\":\"2026-07-19 12:28:24\",\"icon\":\"clipboard\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":2314,\"menuName\":\"我的项目\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2313,\"path\":\"http://localhost/view/#/project/device-components\",\"perms\":\"\",\"routeName\":\"project\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-31 17:20:30', 12);
INSERT INTO `sys_oper_log` VALUES (705, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"/view/#/project/items\",\"createTime\":\"2026-07-19 12:28:24\",\"icon\":\"clipboard\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2314,\"menuName\":\"我的项目\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2313,\"path\":\"/view/#/project/device-components\",\"perms\":\"\",\"routeName\":\"project\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-31 17:22:12', 10);
INSERT INTO `sys_oper_log` VALUES (706, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"/view/#/project/items\",\"createTime\":\"2026-07-19 12:28:24\",\"icon\":\"clipboard\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2314,\"menuName\":\"我的项目\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2313,\"path\":\"project\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-31 17:22:40', 11);
INSERT INTO `sys_oper_log` VALUES (707, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"view/#/project/items\",\"createTime\":\"2026-07-19 12:28:24\",\"icon\":\"clipboard\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2314,\"menuName\":\"我的项目\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2313,\"path\":\"project\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-31 17:23:01', 12);
INSERT INTO `sys_oper_log` VALUES (708, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"view/#/project\",\"createTime\":\"2026-07-19 12:28:24\",\"icon\":\"clipboard\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2314,\"menuName\":\"我的项目\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2313,\"path\":\"project\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-31 17:26:38', 13);
INSERT INTO `sys_oper_log` VALUES (709, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"http://localhost/view/#/project/items\",\"createTime\":\"2026-07-19 12:28:24\",\"icon\":\"clipboard\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2314,\"menuName\":\"我的项目\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2313,\"path\":\"project\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-31 17:27:25', 12);
INSERT INTO `sys_oper_log` VALUES (710, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"/view/#/project/items\",\"createTime\":\"2026-07-19 12:28:24\",\"icon\":\"clipboard\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2314,\"menuName\":\"我的项目\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2313,\"path\":\"project\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-31 17:27:52', 20);
INSERT INTO `sys_oper_log` VALUES (711, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"/view/#/project/items\",\"createTime\":\"2026-07-19 12:28:24\",\"icon\":\"clipboard\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2314,\"menuName\":\"我的项目\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2313,\"path\":\"/view/#/project/items\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-31 17:30:23', 14);
INSERT INTO `sys_oper_log` VALUES (712, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"#/project/items\",\"createTime\":\"2026-07-19 12:28:24\",\"icon\":\"clipboard\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2314,\"menuName\":\"我的项目\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2313,\"path\":\"#/project/items\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-31 18:00:33', 10);
INSERT INTO `sys_oper_log` VALUES (713, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-07-19 12:26:41\",\"icon\":\"example\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2313,\"menuName\":\"组态管理\",\"menuType\":\"M\",\"orderNum\":6,\"params\":{},\"parentId\":0,\"path\":\"view\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-31 18:00:40', 12);
INSERT INTO `sys_oper_log` VALUES (714, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-07-19 12:26:41\",\"icon\":\"example\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2313,\"menuName\":\"组态管理\",\"menuType\":\"M\",\"orderNum\":6,\"params\":{},\"parentId\":0,\"path\":\"view\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-31 18:01:11', 12);
INSERT INTO `sys_oper_log` VALUES (715, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"project\",\"createTime\":\"2026-07-19 12:28:24\",\"icon\":\"clipboard\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":2314,\"menuName\":\"我的项目\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2313,\"path\":\"http://localhost/view/#/project/items\",\"perms\":\"\",\"routeName\":\"project\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-31 18:04:07', 11);
INSERT INTO `sys_oper_log` VALUES (716, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"project\",\"createTime\":\"2026-07-19 12:28:24\",\"icon\":\"clipboard\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":2314,\"menuName\":\"我的项目\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2313,\"path\":\"http://localhost:3000\",\"perms\":\"\",\"routeName\":\"project\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-31 19:07:02', 11);
INSERT INTO `sys_oper_log` VALUES (717, '能源支路到区域及能源分项的唯一权威归属配置', 1, 'com.ruoyi.energy.controller.EnergyBranchDimensionBindingController.add()', 'POST', 1, 'admin', '研发部门', '/energy/energyBranchDimBinding', '127.0.0.1', '内网IP', '{\"areaCoverageScope\":\"NODE_SELF\",\"areaId\":5,\"bindingSource\":\"MANUAL\",\"branchId\":2,\"createdAt\":\"2026-07-31\",\"description\":\"\",\"id\":1,\"params\":{},\"status\":\"ACTIVE\",\"subItemCoverageScope\":\"NODE_SELF\",\"subItemId\":3,\"updatedAt\":\"2026-07-31\",\"validFrom\":\"2026-07-31\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-31 19:10:25', 14);
INSERT INTO `sys_oper_log` VALUES (718, '能源支路到区域及能源分项的唯一权威归属配置', 1, 'com.ruoyi.energy.controller.EnergyBranchDimensionBindingController.add()', 'POST', 1, 'admin', '研发部门', '/energy/energyBranchDimBinding', '127.0.0.1', '内网IP', '{\"areaCoverageScope\":\"NODE_SELF\",\"areaId\":6,\"bindingSource\":\"MANUAL\",\"branchId\":1,\"createdAt\":\"2026-07-31\",\"description\":\"\",\"id\":2,\"params\":{},\"status\":\"ACTIVE\",\"subItemCoverageScope\":\"NODE_SELF\",\"subItemId\":3,\"updatedAt\":\"2026-07-31\",\"validFrom\":\"2026-07-31\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-31 19:10:35', 8);
INSERT INTO `sys_oper_log` VALUES (719, '能源支路到区域及能源分项的唯一权威归属配置', 1, 'com.ruoyi.energy.controller.EnergyBranchDimensionBindingController.add()', 'POST', 1, 'admin', '研发部门', '/energy/energyBranchDimBinding', '127.0.0.1', '内网IP', '{\"areaCoverageScope\":\"NODE_SELF\",\"areaId\":6,\"bindingSource\":\"MANUAL\",\"branchId\":5,\"createdAt\":\"2026-07-31\",\"description\":\"\",\"id\":3,\"params\":{},\"status\":\"ACTIVE\",\"subItemCoverageScope\":\"NODE_SELF\",\"subItemId\":5,\"updatedAt\":\"2026-07-31\",\"validFrom\":\"2026-07-31\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-31 19:10:42', 9);
INSERT INTO `sys_oper_log` VALUES (720, '能源支路到区域及能源分项的唯一权威归属配置', 1, 'com.ruoyi.energy.controller.EnergyBranchDimensionBindingController.add()', 'POST', 1, 'admin', '研发部门', '/energy/energyBranchDimBinding', '127.0.0.1', '内网IP', '{\"areaCoverageScope\":\"NODE_SELF\",\"areaId\":7,\"bindingSource\":\"MANUAL\",\"branchId\":6,\"createdAt\":\"2026-07-31\",\"description\":\"\",\"id\":4,\"params\":{},\"status\":\"ACTIVE\",\"subItemCoverageScope\":\"NODE_SELF\",\"subItemId\":3,\"updatedAt\":\"2026-07-31\",\"validFrom\":\"2026-07-31\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-31 19:11:02', 8);
INSERT INTO `sys_oper_log` VALUES (721, '指定时间范围能耗统计计算', 0, 'com.ruoyi.energy.controller.EnergyStatisticsCalculationController.calculate()', 'POST', 1, 'admin', '研发部门', '/energy/statistics/calculate', '127.0.0.1', '内网IP', '{\"periodEnd\":\"2025-12-31 00:00:00\",\"periodStart\":\"2024-12-31 00:00:00\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"periods\":[{\"affectedCount\":0,\"granularity\":\"FIFTEEN_MINUTES\",\"periodCount\":35040,\"periodEnd\":\"2025-12-31 00:00:00\",\"periodStart\":\"2024-12-31 00:00:00\"},{\"affectedCount\":0,\"granularity\":\"HOURLY\",\"periodCount\":8760,\"periodEnd\":\"2025-12-31 00:00:00\",\"periodStart\":\"2024-12-31 00:00:00\"},{\"affectedCount\":0,\"granularity\":\"DAILY\",\"periodCount\":365,\"periodEnd\":\"2025-12-31 00:00:00\",\"periodStart\":\"2024-12-31 00:00:00\"},{\"affectedCount\":0,\"granularity\":\"MONTHLY\",\"periodCount\":13,\"periodEnd\":\"2026-01-01 00:00:00\",\"periodStart\":\"2024-12-01 00:00:00\"},{\"affectedCount\":0,\"granularity\":\"YEARLY\",\"periodCount\":2,\"periodEnd\":\"2026-01-01 00:00:00\",\"periodStart\":\"2024-01-01 00:00:00\"}],\"requestedEnd\":\"2025-12-31 00:00:00\",\"requestedStart\":\"2024-12-31 00:00:00\",\"totalAffectedCount\":0,\"totalPeriodCount\":44180}}', 0, NULL, '2026-08-02 18:55:15', 59805);
INSERT INTO `sys_oper_log` VALUES (722, '指定时间范围能耗统计计算', 0, 'com.ruoyi.energy.controller.EnergyStatisticsCalculationController.calculate()', 'POST', 1, 'admin', '研发部门', '/energy/statistics/calculate', '127.0.0.1', '内网IP', '{\"periodEnd\":\"2025-08-03 00:00:00\",\"periodStart\":\"2025-08-01 00:00:00\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"periods\":[{\"affectedCount\":0,\"granularity\":\"FIFTEEN_MINUTES\",\"periodCount\":192,\"periodEnd\":\"2025-08-03 00:00:00\",\"periodStart\":\"2025-08-01 00:00:00\"},{\"affectedCount\":0,\"granularity\":\"HOURLY\",\"periodCount\":48,\"periodEnd\":\"2025-08-03 00:00:00\",\"periodStart\":\"2025-08-01 00:00:00\"},{\"affectedCount\":0,\"granularity\":\"DAILY\",\"periodCount\":2,\"periodEnd\":\"2025-08-03 00:00:00\",\"periodStart\":\"2025-08-01 00:00:00\"},{\"affectedCount\":0,\"granularity\":\"MONTHLY\",\"periodCount\":1,\"periodEnd\":\"2025-09-01 00:00:00\",\"periodStart\":\"2025-08-01 00:00:00\"},{\"affectedCount\":0,\"granularity\":\"YEARLY\",\"periodCount\":1,\"periodEnd\":\"2026-01-01 00:00:00\",\"periodStart\":\"2025-01-01 00:00:00\"}],\"requestedEnd\":\"2025-08-03 00:00:00\",\"requestedStart\":\"2025-08-01 00:00:00\",\"totalAffectedCount\":0,\"totalPeriodCount\":244}}', 0, NULL, '2026-08-02 20:02:31', 358);
INSERT INTO `sys_oper_log` VALUES (723, '指定时间范围能耗统计计算', 0, 'com.ruoyi.energy.controller.EnergyStatisticsCalculationController.calculate()', 'POST', 1, 'admin', '研发部门', '/energy/statistics/calculate', '127.0.0.1', '内网IP', '{\"periodEnd\":\"2025-12-31 00:00:00\",\"periodStart\":\"2024-12-31 00:00:00\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"periods\":[{\"affectedCount\":35040,\"granularity\":\"FIFTEEN_MINUTES\",\"periodCount\":35040,\"periodEnd\":\"2025-12-31 00:00:00\",\"periodStart\":\"2024-12-31 00:00:00\"},{\"affectedCount\":8760,\"granularity\":\"HOURLY\",\"periodCount\":8760,\"periodEnd\":\"2025-12-31 00:00:00\",\"periodStart\":\"2024-12-31 00:00:00\"},{\"affectedCount\":365,\"granularity\":\"DAILY\",\"periodCount\":365,\"periodEnd\":\"2025-12-31 00:00:00\",\"periodStart\":\"2024-12-31 00:00:00\"},{\"affectedCount\":13,\"granularity\":\"MONTHLY\",\"periodCount\":13,\"periodEnd\":\"2026-01-01 00:00:00\",\"periodStart\":\"2024-12-01 00:00:00\"},{\"affectedCount\":2,\"granularity\":\"YEARLY\",\"periodCount\":2,\"periodEnd\":\"2026-01-01 00:00:00\",\"periodStart\":\"2024-01-01 00:00:00\"}],\"requestedEnd\":\"2025-12-31 00:00:00\",\"requestedStart\":\"2024-12-31 00:00:00\",\"totalAffectedCount\":44180,\"totalPeriodCount\":44180}}', 0, NULL, '2026-08-02 20:35:26', 1182366);
INSERT INTO `sys_oper_log` VALUES (724, '指定时间范围能耗统计计算', 0, 'com.ruoyi.energy.controller.EnergyStatisticsCalculationController.calculate()', 'POST', 1, 'admin', '研发部门', '/energy/statistics/calculate', '127.0.0.1', '内网IP', '{\"periodEnd\":\"2025-01-31 00:00:00\",\"periodStart\":\"2025-01-01 00:00:00\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"periods\":[{\"affectedCount\":135360,\"granularity\":\"FIFTEEN_MINUTES\",\"periodCount\":2880,\"periodEnd\":\"2025-01-31 00:00:00\",\"periodStart\":\"2025-01-01 00:00:00\"},{\"affectedCount\":33840,\"granularity\":\"HOURLY\",\"periodCount\":720,\"periodEnd\":\"2025-01-31 00:00:00\",\"periodStart\":\"2025-01-01 00:00:00\"},{\"affectedCount\":1410,\"granularity\":\"DAILY\",\"periodCount\":30,\"periodEnd\":\"2025-01-31 00:00:00\",\"periodStart\":\"2025-01-01 00:00:00\"},{\"affectedCount\":47,\"granularity\":\"MONTHLY\",\"periodCount\":1,\"periodEnd\":\"2025-02-01 00:00:00\",\"periodStart\":\"2025-01-01 00:00:00\"},{\"affectedCount\":47,\"granularity\":\"YEARLY\",\"periodCount\":1,\"periodEnd\":\"2026-01-01 00:00:00\",\"periodStart\":\"2025-01-01 00:00:00\"}],\"requestedEnd\":\"2025-01-31 00:00:00\",\"requestedStart\":\"2025-01-01 00:00:00\",\"totalAffectedCount\":170704,\"totalPeriodCount\":3632}}', 0, NULL, '2026-08-02 22:38:19', 255047);
INSERT INTO `sys_oper_log` VALUES (725, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2314', '127.0.0.1', '内网IP', '2314 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-11 13:25:14', 20);
INSERT INTO `sys_oper_log` VALUES (726, '设备接入网关', 1, 'com.ruoyi.iot.controller.EdgeDeviceController.add()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDevice', '127.0.0.1', '内网IP', '{\"configuration\":\"{\\\"port\\\":502,\\\"host\\\":\\\"127.0.0.1\\\",\\\"default_unit_identifier\\\":1,\\\"ping_address\\\":\\\"127.0.0.1\\\",\\\"default_payload_byte_order\\\":\\\"1000\\\",\\\"max_coils_per_request\\\":100,\\\"max_registers_per_request\\\":125,\\\"connection_string\\\":\\\"1452452\\\",\\\"request_timeout\\\":1000,\\\"refresh_interval\\\":1000,\\\"connect_interval\\\":1000,\\\"prefer_subscription\\\":\\\"true\\\",\\\"fallback_to_polling\\\":\\\"true\\\"}\",\"createTime\":\"2026-08-12 13:48:15\",\"id\":\"plc4x-modbus-tcp_mspo3219_9p9as\",\"linkStatus\":\"offline\",\"name\":\"etst\",\"params\":{},\"protocolId\":\"plc4x-modbus-tcp\",\"status\":\"enable\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-12 13:48:15', 15);
INSERT INTO `sys_oper_log` VALUES (727, '网关数据点位', 1, 'com.ruoyi.iot.controller.EdgeDataPointController.add()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint', '127.0.0.1', '内网IP', '{\"config\":\"{}\",\"createTime\":\"2026-08-12 14:11:57\",\"gatewayId\":\"plc4x-modbus-tcp_mspo3219_9p9as\",\"id\":\"2087421813801005056\",\"name\":\"test\",\"operationTpye\":\"r\",\"params\":{},\"protocolId\":\"plc4x-modbus-tcp\",\"type\":\"long\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-12 14:11:57', 38);
INSERT INTO `sys_oper_log` VALUES (728, '网关数据点位', 3, 'com.ruoyi.iot.controller.EdgeDataPointController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/edgeDataPoint/2087421813801005056', '127.0.0.1', '内网IP', '[\"2087421813801005056\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-12 14:12:00', 12);
INSERT INTO `sys_oper_log` VALUES (729, '设备接入网关', 3, 'com.ruoyi.iot.controller.EdgeDeviceController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/edgeDevice/plc4x-modbus-tcp_mspo3219_9p9as', '127.0.0.1', '内网IP', '[\"plc4x-modbus-tcp_mspo3219_9p9as\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-12 14:13:12', 16);
INSERT INTO `sys_oper_log` VALUES (730, '设备接入网关', 1, 'com.ruoyi.iot.controller.EdgeDeviceController.add()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDevice', '127.0.0.1', '内网IP', '{\"configuration\":\"{}\",\"createTime\":\"2026-08-12 14:13:18\",\"id\":\"plc4x-modbus-tcp_mspp0pln_6wuie\",\"linkStatus\":\"offline\",\"name\":\"test\",\"params\":{},\"protocolId\":\"plc4x-modbus-tcp\",\"status\":\"enable\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-12 14:13:18', 16);
INSERT INTO `sys_oper_log` VALUES (731, '设备接入网关', 3, 'com.ruoyi.iot.controller.EdgeDeviceController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/edgeDevice/plc4x-modbus-tcp_mspp0pln_6wuie', '127.0.0.1', '内网IP', '[\"plc4x-modbus-tcp_mspp0pln_6wuie\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-12 14:13:21', 10);
INSERT INTO `sys_oper_log` VALUES (732, '设备接入网关', 1, 'com.ruoyi.iot.controller.EdgeDeviceController.add()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDevice', '127.0.0.1', '内网IP', '{\"configuration\":\"{\\\"host\\\":\\\"127a\\\",\\\"port\\\":502,\\\"default_unit_identifier\\\":1,\\\"default_payload_byte_order\\\":\\\"111\\\",\\\"ping_address\\\":\\\"111\\\",\\\"max_coils_per_request\\\":11,\\\"max_registers_per_request\\\":11,\\\"tcp_keep_alive\\\":\\\"true\\\",\\\"tcp_no_delay\\\":\\\"false\\\",\\\"tcp_default_timeout\\\":1000,\\\"connection_string\\\":\\\"10101\\\",\\\"request_timeout\\\":10,\\\"refresh_interval\\\":101,\\\"connect_interval\\\":101,\\\"prefer_subscription\\\":\\\"true\\\",\\\"fallback_to_polling\\\":\\\"true\\\"}\",\"createTime\":\"2026-08-12 14:21:24\",\"id\":\"plc4x-modbus-tcp_msppaq4c_lieu0\",\"linkStatus\":\"offline\",\"name\":\"aaa\",\"params\":{},\"protocolId\":\"plc4x-modbus-tcp\",\"status\":\"enable\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-12 14:21:24', 107);
INSERT INTO `sys_oper_log` VALUES (733, '设备接入网关', 3, 'com.ruoyi.iot.controller.EdgeDeviceController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/edgeDevice/plc4x-modbus-tcp_msppaq4c_lieu0', '127.0.0.1', '内网IP', '[\"plc4x-modbus-tcp_msppaq4c_lieu0\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-14 14:24:47', 16);
INSERT INTO `sys_oper_log` VALUES (734, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'admin', '研发部门', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/08/16/162664394e8844cb9f273c5766407c65.jpg\",\"code\":200}', 0, NULL, '2026-08-16 19:08:46', 21);
INSERT INTO `sys_oper_log` VALUES (735, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'admin', '研发部门', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/08/16/91fab74be08c4ce796a41645fa914e71.jpg\",\"code\":200}', 0, NULL, '2026-08-16 19:08:55', 16);
INSERT INTO `sys_oper_log` VALUES (736, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'admin', '研发部门', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/08/16/8042de13bfae481684342652f6697d60.png\",\"code\":200}', 0, NULL, '2026-08-16 22:30:27', 112);
INSERT INTO `sys_oper_log` VALUES (737, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"404\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"test\",\"menuType\":\"V\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"projectId\":\"2089010415043563520\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"所选大屏项目不存在\",\"code\":500}', 0, NULL, '2026-08-17 16:35:43', 10);
INSERT INTO `sys_oper_log` VALUES (738, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"404\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"test\",\"menuType\":\"V\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"projectId\":\"2089010415043563520\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"所选大屏项目不存在\",\"code\":500}', 0, NULL, '2026-08-17 16:35:46', 2);
INSERT INTO `sys_oper_log` VALUES (739, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"404\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"test\",\"menuType\":\"V\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"projectId\":\"2089010415043563520\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"所选大屏项目不存在\",\"code\":500}', 0, NULL, '2026-08-17 16:36:16', 2);
INSERT INTO `sys_oper_log` VALUES (740, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"404\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"test\",\"menuType\":\"V\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"projectId\":\"2089010415043563520\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"所选大屏项目尚未发布\",\"code\":500}', 0, NULL, '2026-08-17 16:37:56', 11);
INSERT INTO `sys_oper_log` VALUES (741, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"view/chart/preview\",\"createBy\":\"admin\",\"icon\":\"404\",\"isCache\":\"1\",\"isFrame\":\"1\",\"menuName\":\"test\",\"menuType\":\"V\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"screen/2089010415043563520\",\"perms\":\"\",\"projectId\":\"2089010415043563520\",\"query\":\"\",\"routeName\":\"Screen2089010415043563520\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-17 16:38:14', 116);
INSERT INTO `sys_oper_log` VALUES (742, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'admin', '研发部门', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/08/17/654f184387484bbb9617235c54be2655.jpg\",\"code\":200}', 0, NULL, '2026-08-17 16:38:38', 110);
INSERT INTO `sys_oper_log` VALUES (743, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2403', '127.0.0.1', '内网IP', '2403 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-17 16:38:55', 14);
INSERT INTO `sys_oper_log` VALUES (744, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"telemetryKey\":\"brightness\",\"value\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-08-20 16:54:14', 21);
INSERT INTO `sys_oper_log` VALUES (745, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.power\",\"telemetryKey\":\"power\",\"value\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-08-20 16:55:45', 5);
INSERT INTO `sys_oper_log` VALUES (746, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"test1\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.power\",\"telemetryKey\":\"power\",\"value\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-08-20 16:56:26', 2);
INSERT INTO `sys_oper_log` VALUES (747, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'admin', '研发部门', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/08/24/027ecec33c114af5a63bd7f137797112.jpg\",\"code\":200}', 0, NULL, '2026-08-24 10:31:01', 72);
INSERT INTO `sys_oper_log` VALUES (748, '系统备份', 5, 'com.ruoyi.web.backup.controller.SystemBackupController.backup()', 'POST', 1, 'admin', '研发部门', '/api/system/backup', '127.0.0.1', '内网IP', '', NULL, 1, 'mysqldump 可执行文件不存在: D:\\workspace\\lightning\\mysql\\bin\\mysqldump.exe', '2026-08-24 10:47:43', 3);
INSERT INTO `sys_oper_log` VALUES (749, '系统备份', 5, 'com.ruoyi.web.backup.controller.SystemBackupController.backup()', 'POST', 1, 'admin', '研发部门', '/api/system/backup', '127.0.0.1', '内网IP', '', NULL, 1, 'mysqldump 可执行文件不存在: D:\\workspace\\lightning\\mysql\\bin\\mysqldump.exe', '2026-08-24 10:47:51', 2);
INSERT INTO `sys_oper_log` VALUES (750, '系统备份', 5, 'com.ruoyi.web.backup.controller.SystemBackupController.backup()', 'POST', 1, 'admin', '研发部门', '/api/system/backup', '127.0.0.1', '内网IP', '', NULL, 1, 'mysqldump 可执行文件不存在: D:\\workspace\\lightning\\mysql\\bin\\mysqldump.exe', '2026-08-24 10:47:57', 2);
INSERT INTO `sys_oper_log` VALUES (751, '系统备份', 5, 'com.ruoyi.web.backup.controller.SystemBackupController.backup()', 'POST', 1, 'admin', '研发部门', '/api/system/backup', '127.0.0.1', '内网IP', '', NULL, 1, 'mysqldump 可执行文件不存在: D:\\workspace\\lightning\\mysql\\bin\\mysqldump.exe', '2026-08-24 10:47:58', 2);
INSERT INTO `sys_oper_log` VALUES (752, '系统备份', 5, 'com.ruoyi.web.backup.controller.SystemBackupController.backup()', 'POST', 1, 'admin', '研发部门', '/api/system/backup', '127.0.0.1', '内网IP', '', NULL, 1, 'mysqldump 可执行文件不存在: D:\\workspace\\lightning\\mysql\\bin\\mysqldump.exe', '2026-08-24 10:47:58', 2);
INSERT INTO `sys_oper_log` VALUES (753, '系统备份', 5, 'com.ruoyi.web.backup.controller.SystemBackupController.backup()', 'POST', 1, 'admin', '研发部门', '/api/system/backup', '127.0.0.1', '内网IP', '', NULL, 1, 'mysqldump 可执行文件不存在: D:\\workspace\\lightning\\mysql\\bin\\mysqldump.exe', '2026-08-24 10:47:58', 1);
INSERT INTO `sys_oper_log` VALUES (754, '系统备份', 5, 'com.ruoyi.web.backup.controller.SystemBackupController.backup()', 'POST', 1, 'admin', '研发部门', '/api/system/backup', '127.0.0.1', '内网IP', '', NULL, 1, 'mysqldump 可执行文件不存在: D:\\workspace\\lightning\\mysql\\bin\\mysqldump.exe', '2026-08-24 10:47:58', 2);
INSERT INTO `sys_oper_log` VALUES (755, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"example\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"平台备份\",\"menuType\":\"C\",\"orderNum\":10,\"params\":{},\"parentId\":1,\"path\":\"/system/backup/index\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-24 10:49:16', 17);
INSERT INTO `sys_oper_log` VALUES (756, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"/system/backup/index\",\"createTime\":\"2026-08-24 10:49:16\",\"icon\":\"example\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2404,\"menuName\":\"平台备份\",\"menuType\":\"C\",\"orderNum\":10,\"params\":{},\"parentId\":1,\"path\":\"backup\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-24 10:49:48', 13);
INSERT INTO `sys_oper_log` VALUES (757, '保存菜单排序', 2, 'com.ruoyi.web.controller.system.SysMenuController.updateSort()', 'PUT', 1, 'admin', '研发部门', '/system/menu/updateSort', '127.0.0.1', '内网IP', '{\"menuIds\":\"2404\",\"orderNums\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-24 10:50:08', 14);
INSERT INTO `sys_oper_log` VALUES (758, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/backup/index\",\"createTime\":\"2026-08-24 10:49:16\",\"icon\":\"example\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2404,\"menuName\":\"平台备份\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":1,\"path\":\"backup\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-24 10:50:44', 11);
INSERT INTO `sys_oper_log` VALUES (759, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2404', '127.0.0.1', '内网IP', '2404 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-24 10:55:11', 12);
INSERT INTO `sys_oper_log` VALUES (760, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'admin', '研发部门', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"ry@163.com\",\"nickName\":\"管理员\",\"params\":{},\"phonenumber\":\"15888888888\",\"sex\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-24 10:56:10', 9);
INSERT INTO `sys_oper_log` VALUES (761, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'admin', '研发部门', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"aaaaa@163.com\",\"nickName\":\"管理\",\"params\":{},\"phonenumber\":\"15888888888\",\"sex\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-24 10:56:23', 8);
INSERT INTO `sys_oper_log` VALUES (762, '系统备份', 5, 'com.ruoyi.web.backup.controller.SystemBackupController.backup()', 'POST', 1, 'admin', '研发部门', '/api/system/backup', '127.0.0.1', '内网IP', '', NULL, 1, 'mysqldump 可执行文件不存在: D:\\workspace\\lightning\\mysql\\bin\\mysqldump.exe', '2026-08-24 10:56:42', 1);
INSERT INTO `sys_oper_log` VALUES (763, '系统备份', 5, 'com.ruoyi.web.backup.controller.SystemBackupController.backup()', 'POST', 1, 'admin', '研发部门', '/api/system/backup', '127.0.0.1', '内网IP', '', NULL, 1, 'mysqldump 可执行文件不存在: D:\\workspace\\lightning\\mysql\\bin\\mysqldump.exe', '2026-08-24 10:56:44', 1);
INSERT INTO `sys_oper_log` VALUES (764, '系统备份', 5, 'com.ruoyi.web.backup.controller.SystemBackupController.backup()', 'POST', 1, 'admin', '研发部门', '/api/system/backup', '127.0.0.1', '内网IP', '', NULL, 1, 'mysqldump 可执行文件不存在: D:\\workspace\\lightning\\mysql\\bin\\mysqldump.exe', '2026-08-24 10:56:44', 2);
INSERT INTO `sys_oper_log` VALUES (765, '系统备份', 5, 'com.ruoyi.web.backup.controller.SystemBackupController.backup()', 'POST', 1, 'admin', '研发部门', '/api/system/backup', '127.0.0.1', '内网IP', '', NULL, 1, 'mysqldump 可执行文件不存在: D:\\workspace\\lightning\\mysql\\bin\\mysqldump.exe', '2026-08-24 10:56:44', 1);
INSERT INTO `sys_oper_log` VALUES (766, '系统备份', 5, 'com.ruoyi.web.backup.controller.SystemBackupController.backup()', 'POST', 1, 'admin', '研发部门', '/api/system/backup', '127.0.0.1', '内网IP', '', NULL, 1, 'mysqldump 可执行文件不存在: D:\\workspace\\lightning\\mysql\\bin\\mysqldump.exe', '2026-08-24 10:56:44', 2);
INSERT INTO `sys_oper_log` VALUES (767, '系统备份', 5, 'com.ruoyi.web.backup.controller.SystemBackupController.backup()', 'POST', 1, 'admin', '研发部门', '/api/system/backup', '127.0.0.1', '内网IP', '', NULL, 1, 'mysqldump 可执行文件不存在: D:\\workspace\\lightning\\mysql\\bin\\mysqldump.exe', '2026-08-24 10:56:44', 1);
INSERT INTO `sys_oper_log` VALUES (768, '系统备份', 5, 'com.ruoyi.web.backup.controller.SystemBackupController.backup()', 'POST', 1, 'admin', '研发部门', '/api/system/backup', '127.0.0.1', '内网IP', '', NULL, 1, 'mysqldump 可执行文件不存在: D:\\workspace\\lightning\\mysql\\bin\\mysqldump.exe', '2026-08-27 16:35:44', 5);
INSERT INTO `sys_oper_log` VALUES (769, '系统备份', 5, 'com.ruoyi.web.backup.controller.SystemBackupController.backup()', 'POST', 1, 'admin', '研发部门', '/api/system/backup', '127.0.0.1', '内网IP', '', NULL, 1, 'mysqldump 可执行文件不存在: D:\\workspace\\lightning\\mysql\\bin\\mysqldump.exe', '2026-08-27 16:35:48', 2);
INSERT INTO `sys_oper_log` VALUES (770, '系统备份', 5, 'com.ruoyi.web.backup.controller.SystemBackupController.backup()', 'POST', 1, 'admin', '研发部门', '/api/system/backup', '127.0.0.1', '内网IP', '', NULL, 1, 'mysqldump 可执行文件不存在: D:\\workspace\\lightning\\mysql\\bin\\mysqldump.exe', '2026-08-27 16:35:48', 1);
INSERT INTO `sys_oper_log` VALUES (771, '系统备份', 5, 'com.ruoyi.web.backup.controller.SystemBackupController.backup()', 'POST', 1, 'admin', '研发部门', '/api/system/backup', '127.0.0.1', '内网IP', '', NULL, 1, 'mysqldump 可执行文件不存在: D:\\workspace\\lightning\\mysql\\bin\\mysqldump.exe', '2026-08-27 16:35:48', 2);
INSERT INTO `sys_oper_log` VALUES (772, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'admin', '研发部门', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/08/27/dae00250166045b88f20fb4a021f351e.png\",\"code\":200}', 0, NULL, '2026-08-27 16:36:03', 113);
INSERT INTO `sys_oper_log` VALUES (773, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'admin', '研发部门', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/08/27/8e9c3903645d4ee5bd15f4169e149f54.png\",\"code\":200}', 0, NULL, '2026-08-27 16:39:32', 86);
INSERT INTO `sys_oper_log` VALUES (774, '系统备份', 5, 'com.ruoyi.web.backup.controller.SystemBackupController.backup()', 'POST', 1, 'admin', '研发部门', '/api/system/backup', '127.0.0.1', '内网IP', '', NULL, 1, 'mysqldump 可执行文件不存在: D:\\workspace\\lightning\\mysql\\bin\\mysqldump.exe', '2026-08-27 16:41:25', 4);
INSERT INTO `sys_oper_log` VALUES (775, '系统备份', 5, 'com.ruoyi.web.backup.controller.SystemBackupController.backup()', 'POST', 1, 'admin', '研发部门', '/api/system/backup', '127.0.0.1', '内网IP', '', '{\"body\":{\"URI\":\"file:/D:/workspace/lightning/backup/system-backup-20260827-164224.zip\",\"URL\":\"file:/D:/workspace/lightning/backup/system-backup-20260827-164224.zip\",\"contentAsByteArray\":[80,75,3,4,20,0,8,8,8,0,76,-123,27,93,0,0,0,0,0,0,0,0,0,0,0,0,13,0,0,0,109,97,110,105,102,101,115,116,46,106,115,111,110,-85,-26,-27,82,80,80,42,75,45,42,-50,-52,-49,83,82,-80,82,80,50,-44,51,80,-46,1,-117,38,37,38,103,-105,22,-124,100,-26,-90,-126,37,-116,12,-116,-52,116,13,44,116,-115,-52,67,12,-51,-84,76,-116,-84,-116,76,-12,12,76,76,-52,-51,44,-95,-22,83,18,75,18,-109,18,-117,33,-86,115,50,-45,51,74,-14,50,-13,-46,-95,-110,-71,-107,-59,-123,57,32,-103,-110,-94,-46,84,-120,80,105,65,78,126,98,10,76,-116,-105,-85,22,0,80,75,7,8,16,66,-11,81,110,0,0,0,-115,0,0,0,80,75,3,4,20,0,8,8,8,0,76,-123,27,93,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,109,121,115,113,108,47,3,0,80,75,7,8,0,0,0,0,2,0,0,0,0,0,0,0,80,75,3,4,20,0,8,8,8,0,76,-123,27,93,0,0,0,0,0,0,0,0,0,0,0,0,18,0,0,0,109,121,115,113,108,47,100,97,116,97,98,97,115,101,46,115,113,108,-20,-67,-5,-109,29,-57,113,-17,-7,-13,50,-126,-1,-61,-71,-2,5,-96,23,-96,-85,50,-77,94,-72,-63,13,65,-28,72,-58,-118,4,100,0,-76,-81,110,56,98,-40,-113,106,104,-82,-128,25,122,48,-96,-116,-35,-40,8,82,54,-97,18,69,-55,122,75,-108,76,-38,-92,72,-5,-118,15,-39,-70,18,5,-126,82,-60,-2,43,-117,-103,1,127,-30,-65,-80,89,125,-50,-52,-87,62,-89,1,12,-47,-39,24,-34,-72,102,-112,-100,-41,-23,-45,89,-89,-85,-14,-101,89,-107,-11,-87,-29,-57,39,-113,93,61,-9,23,-113,78,-22,43,-105,-98,-100,104,-11,-96,-58,-55,-28,-111,-75,-53,91,-101,107,-27,-60,63,-88,30,36,123,108,-46,108,108,78,-2,106,109,-35,-46,-28,-24,-33,122,-69,106,-23,-127,-5,-17,59,126,60,-3,55,-7,-13,-115,-53,91,39,38,26,28,-65,-108,47,-98,-16,63,-113,20,91,69,89,92,-114,39,38,23,-41,46,124,117,107,125,109,-3,66,-5,-46,-29,119,-11,79,123,-23,-71,-72,-7,84,-36,-100,-16,127,-105,-41,54,-42,-1,-73,-42,46,-72,-1,-66,-5,-17,-5,-77,63,-3,79,-92,-76,-46,-109,115,43,-25,39,-97,59,-13,-24,35,-85,15,-1,-7,-55,-77,39,31,62,-6', 0, NULL, '2026-08-27 16:42:24', 576);
INSERT INTO `sys_oper_log` VALUES (776, '系统恢复', 6, 'com.ruoyi.web.backup.controller.SystemBackupController.restore()', 'POST', 1, 'admin', '研发部门', '/api/system/restore', '127.0.0.1', '内网IP', '', '{\"msg\":\"系统恢复成功\",\"code\":200}', 0, NULL, '2026-08-27 16:46:03', 28909);
INSERT INTO `sys_oper_log` VALUES (777, '系统备份', 5, 'com.ruoyi.web.backup.controller.SystemBackupController.backup()', 'POST', 1, 'admin', '研发部门', '/api/system/backup', '127.0.0.1', '内网IP', '', NULL, 1, 'mysqldump 可执行文件不存在: D:\\workspace\\lightning\\app\\mysql\\bin\\mysqldump.exe', '2026-08-27 16:57:21', 8);
INSERT INTO `sys_oper_log` VALUES (778, '系统备份', 5, 'com.ruoyi.web.backup.controller.SystemBackupController.backup()', 'POST', 1, 'admin', '研发部门', '/api/system/backup', '127.0.0.1', '内网IP', '', NULL, 1, 'mysqldump 可执行文件不存在: D:\\workspace\\lightning\\app\\mysql\\bin\\mysqldump.exe', '2026-08-27 17:24:01', 3);
INSERT INTO `sys_oper_log` VALUES (779, '系统恢复', 6, 'com.ruoyi.web.backup.controller.SystemBackupController.restore()', 'POST', 1, 'admin', '研发部门', '/api/system/restore', '127.0.0.1', '内网IP', '', '{\"msg\":\"系统恢复成功\",\"code\":200}', 0, NULL, '2026-08-27 17:33:26', 11075);
INSERT INTO `sys_oper_log` VALUES (780, '设备接入网关', 1, 'com.ruoyi.iot.controller.EdgeDeviceController.add()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDevice', '127.0.0.1', '内网IP', '{\"configuration\":\"{\\\"endpoint\\\":\\\"opc.tcp://DESKTOP-2JHO6FD.mshome.net:4840/OPCUA/SimulationServer\\\"}\",\"createTime\":\"2026-08-30 22:35:53\",\"id\":\"opcua_mtfwam6e_dfuyu\",\"linkStatus\":\"offline\",\"name\":\"testopc\",\"params\":{},\"protocolId\":\"opcua\",\"status\":\"enable\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-30 22:35:53', 105);
INSERT INTO `sys_oper_log` VALUES (781, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"opcua_mtfwam6e_dfuyu\",\"id\":\"2094071922395582464\",\"params\":{},\"value\":\"88\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-08-30 22:49:04', 10);
INSERT INTO `sys_oper_log` VALUES (782, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"opcua_mtfwam6e_dfuyu\",\"id\":\"2094071926334033920\",\"params\":{},\"value\":\"356.365\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-08-30 22:50:22', 1);
INSERT INTO `sys_oper_log` VALUES (783, '设备接入网关', 3, 'com.ruoyi.iot.controller.EdgeDeviceController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/edgeDevice/opcua_mtfwam6e_dfuyu', '127.0.0.1', '内网IP', '[\"opcua_mtfwam6e_dfuyu\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-30 23:19:19', 24);
INSERT INTO `sys_oper_log` VALUES (784, '设备接入网关', 1, 'com.ruoyi.iot.controller.EdgeDeviceController.add()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDevice', '127.0.0.1', '内网IP', '{\"configuration\":\"{\\\"endpoint\\\":\\\"opc.tcp://DESKTOP-2JHO6FD.mshome.net:4840/OPCUA/SimulationServer\\\"}\",\"createTime\":\"2026-08-30 23:19:38\",\"id\":\"opcua_mtfygdtq_o8l33\",\"linkStatus\":\"offline\",\"name\":\"opctest\",\"params\":{},\"protocolId\":\"opcua\",\"status\":\"enable\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-30 23:19:38', 14);
INSERT INTO `sys_oper_log` VALUES (785, '网关数据点位', 3, 'com.ruoyi.iot.controller.EdgeDataPointController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/edgeDataPoint/2094082701819777024,2094082701853331456,2094082701874302976,2094082701907857408,2094082701933023232,2094082701966577664,2094082701991743488,2094082702029492224,2094082702058852352,2094082702084018176,2094082702113378304,2094082702142738', '127.0.0.1', '内网IP', '[\"2094082701819777024\",\"2094082701853331456\",\"2094082701874302976\",\"2094082701907857408\",\"2094082701933023232\",\"2094082701966577664\",\"2094082701991743488\",\"2094082702029492224\",\"2094082702058852352\",\"2094082702084018176\",\"2094082702113378304\",\"2094082702142738432\",\"2094082702176292864\",\"2094082702205652992\",\"2094082702235013120\",\"2094082702260178944\",\"2094082702289539072\",\"2094082702318899200\",\"2094082702348259328\",\"2094082702373425152\",\"2094082702398590976\",\"2094082702427951104\",\"2094082702457311232\",\"2094082702486671360\",\"2094082702511837184\",\"2094082702541197312\",\"2094082702570557440\",\"2094082702599917568\",\"2094082702629277696\",\"2094082702658637824\",\"2094082702687997952\",\"2094082702721552384\",\"2094082702750912512\",\"2094082702780272640\",\"2094082702809632768\",\"2094082702838992896\",\"2094082702864158720\",\"2094082702889324544\",\"2094082702918684672\",\"2094082702939656192\",\"2094082702969016320\",\"2094082702989987840\",\"2094082703019347968\",\"2094082703048708096\",\"2094082703078068224\",\"2094082703103234048\",\"2094082703128399872\",\"2094082703157760000\",\"2094082703182925824\",\"2094082703212285952\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-30 23:24:56', 11);
INSERT INTO `sys_oper_log` VALUES (786, '网关数据点位', 3, 'com.ruoyi.iot.controller.EdgeDataPointController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/edgeDataPoint/2094082703237451776,2094082703266811904,2094082703296172032,2094082703321337856,2094082703350697984,2094082703380058112,2094082703409418240,2094082703442972672,2094082703476527104,2094082703505887232,2094082703539441664,2094082703568801', '127.0.0.1', '内网IP', '[\"2094082703237451776\",\"2094082703266811904\",\"2094082703296172032\",\"2094082703321337856\",\"2094082703350697984\",\"2094082703380058112\",\"2094082703409418240\",\"2094082703442972672\",\"2094082703476527104\",\"2094082703505887232\",\"2094082703539441664\",\"2094082703568801792\",\"2094082703598161920\",\"2094082703627522048\",\"2094082703656882176\",\"2094082703682048000\",\"2094082703715602432\",\"2094082703740768256\",\"2094082703774322688\",\"2094082703799488512\",\"2094082703828848640\",\"2094082703862403072\",\"2094082703891763200\",\"2094082703925317632\",\"2094082703958872064\",\"2094082703984037888\",\"2094082704009203712\",\"2094082704038563840\",\"2094082704072118272\",\"2094082704101478400\",\"2094082704126644224\",\"2094082704156004352\",\"2094082704185364480\",\"2094082704210530304\",\"2094082704239890432\",\"2094082704269250560\",\"2094082704298610688\",\"2094082704327970816\",\"2094082704353136640\",\"2094082704382496768\",\"2094082704411856896\",\"2094082704441217024\",\"2094082704491548672\",\"2094082704554463232\",\"2094082704608989184\",\"2094082704667709440\",\"2094082704726429696\",\"2094082704785149952\",\"2094082704843870208\",\"2094082704890007552\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-30 23:24:58', 13);
INSERT INTO `sys_oper_log` VALUES (787, '网关数据点位', 3, 'com.ruoyi.iot.controller.EdgeDataPointController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/edgeDataPoint/2094082704952922112,2094082705007448064,2094082705049391104,2094082705087139840,2094082705112305664,2094082705137471488,2094082705162637312,2094082705187803136,2094082705221357568,2094082705250717696,2094082705284272128,2094082705309437', '127.0.0.1', '内网IP', '[\"2094082704952922112\",\"2094082705007448064\",\"2094082705049391104\",\"2094082705087139840\",\"2094082705112305664\",\"2094082705137471488\",\"2094082705162637312\",\"2094082705187803136\",\"2094082705221357568\",\"2094082705250717696\",\"2094082705284272128\",\"2094082705309437952\",\"2094082705338798080\",\"2094082705363963904\",\"2094082705401712640\",\"2094082705418489856\",\"2094082705447849984\",\"2094082705477210112\",\"2094082705506570240\",\"2094082705535930368\",\"2094082705565290496\",\"2094082705594650624\",\"2094082705624010752\",\"2094082705653370880\",\"2094082705682731008\",\"2094082705716285440\",\"2094082705749839872\",\"2094082705779200000\",\"2094082705800171520\",\"2094082705833725952\",\"2094082705858891776\",\"2094082705884057600\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-30 23:25:00', 10);
INSERT INTO `sys_oper_log` VALUES (788, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-02-27 14:09:28\",\"default\":false,\"dictCode\":106,\"dictLabel\":\"网关协议\",\"dictSort\":0,\"dictType\":\"protocol_type\",\"dictValue\":\"edge\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-31 13:28:12', 15);
INSERT INTO `sys_oper_log` VALUES (789, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-02-27 14:09:47\",\"default\":false,\"dictCode\":107,\"dictLabel\":\"包含设备信息的协议\",\"dictSort\":0,\"dictType\":\"protocol_type\",\"dictValue\":\"DeviceAware\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-31 13:28:16', 11);
INSERT INTO `sys_oper_log` VALUES (790, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-02-27 14:09:28\",\"default\":false,\"dictCode\":106,\"dictLabel\":\"网关协议\",\"dictSort\":0,\"dictType\":\"protocol_type\",\"dictValue\":\"edge\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-31 13:29:02', 11);
INSERT INTO `sys_oper_log` VALUES (791, '字典数据', 2, 'com.ruoyi.web.controller.system.SysDictDataController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2025-02-27 14:09:28\",\"default\":false,\"dictCode\":106,\"dictLabel\":\"网关协议\",\"dictSort\":0,\"dictType\":\"protocol_type\",\"dictValue\":\"edge\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-31 13:29:18', 8);
INSERT INTO `sys_oper_log` VALUES (792, '字典类型', 9, 'com.ruoyi.web.controller.system.SysDictTypeController.refreshCache()', 'DELETE', 1, 'admin', '研发部门', '/system/dict/type/refreshCache', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-31 13:29:22', 12);
INSERT INTO `sys_oper_log` VALUES (793, '字典类型', 9, 'com.ruoyi.web.controller.system.SysDictTypeController.refreshCache()', 'DELETE', 1, 'admin', '研发部门', '/system/dict/type/refreshCache', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-31 13:29:23', 11);
INSERT INTO `sys_oper_log` VALUES (794, '字典类型', 9, 'com.ruoyi.web.controller.system.SysDictTypeController.refreshCache()', 'DELETE', 1, 'admin', '研发部门', '/system/dict/type/refreshCache', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-31 13:29:23', 5);
INSERT INTO `sys_oper_log` VALUES (795, '字典类型', 9, 'com.ruoyi.web.controller.system.SysDictTypeController.refreshCache()', 'DELETE', 1, 'admin', '研发部门', '/system/dict/type/refreshCache', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-31 13:29:23', 11);
INSERT INTO `sys_oper_log` VALUES (796, '设备接入网关', 1, 'com.ruoyi.iot.controller.EdgeDeviceController.add()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDevice', '127.0.0.1', '内网IP', '{\"configuration\":\"{\\\"ip_address\\\":\\\"127.0.0.1\\\",\\\"port\\\":205}\",\"createTime\":\"2026-08-31 13:41:19\",\"id\":\"modbus_mtgt8nzq_zazec\",\"linkStatus\":\"offline\",\"name\":\"mod2\",\"params\":{},\"protocolId\":\"modbus\",\"status\":\"enable\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-31 13:41:19', 33);
INSERT INTO `sys_oper_log` VALUES (797, '设备', 3, 'com.ruoyi.iot.controller.DevicesController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/devices/test1,test2,test3,test4,test5,test6,test7,test8,test9,test10', '127.0.0.1', '内网IP', '[\"test1\",\"test2\",\"test3\",\"test4\",\"test5\",\"test6\",\"test7\",\"test8\",\"test9\",\"test10\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-31 14:57:49', 34);
INSERT INTO `sys_oper_log` VALUES (798, '设备', 3, 'com.ruoyi.iot.controller.DevicesController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/devices/test11,test12,test13,test14,test15,test16,test17,test18,test19,el1,el2,el3,el4,el5,el6,el7,el8,el9,el10,el11,el12,el13,el14,el15,el16,el17,el18,el19,el20,el21,el22,el23,el24,el25,el26,el27,el28,el29,el30,el31,el32,el33,el34,el35,el36,el37,el3', '127.0.0.1', '内网IP', '[\"test11\",\"test12\",\"test13\",\"test14\",\"test15\",\"test16\",\"test17\",\"test18\",\"test19\",\"el1\",\"el2\",\"el3\",\"el4\",\"el5\",\"el6\",\"el7\",\"el8\",\"el9\",\"el10\",\"el11\",\"el12\",\"el13\",\"el14\",\"el15\",\"el16\",\"el17\",\"el18\",\"el19\",\"el20\",\"el21\",\"el22\",\"el23\",\"el24\",\"el25\",\"el26\",\"el27\",\"el28\",\"el29\",\"el30\",\"el31\",\"el32\",\"el33\",\"el34\",\"el35\",\"el36\",\"el37\",\"el38\",\"el39\",\"el40\",\"el41\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-31 14:57:52', 98);
INSERT INTO `sys_oper_log` VALUES (799, '设备', 3, 'com.ruoyi.iot.controller.DevicesController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/devices/el42,el43,el44,el45,el46,el47', '127.0.0.1', '内网IP', '[\"el42\",\"el43\",\"el44\",\"el45\",\"el46\",\"el47\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-31 14:57:55', 19);
INSERT INTO `sys_oper_log` VALUES (800, '能源逻辑计主数据；不直接保存设备属性通道和业务归属', 3, 'com.ruoyi.energy.controller.EnergyMeterController.remove()', 'DELETE', 1, 'admin', '研发部门', '/energy/energyMeter/2,3,4,5,6,7,8,9,10,11', '127.0.0.1', '内网IP', '[2,3,4,5,6,7,8,9,10,11] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-31 14:58:06', 9);
INSERT INTO `sys_oper_log` VALUES (801, '能源逻辑计主数据；不直接保存设备属性通道和业务归属', 3, 'com.ruoyi.energy.controller.EnergyMeterController.remove()', 'DELETE', 1, 'admin', '研发部门', '/energy/energyMeter/12,13,14,15,16,17,18,19,20,21', '127.0.0.1', '内网IP', '[12,13,14,15,16,17,18,19,20,21] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-31 14:58:08', 9);
INSERT INTO `sys_oper_log` VALUES (802, '能源逻辑计主数据；不直接保存设备属性通道和业务归属', 3, 'com.ruoyi.energy.controller.EnergyMeterController.remove()', 'DELETE', 1, 'admin', '研发部门', '/energy/energyMeter/22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48', '127.0.0.1', '内网IP', '[22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-31 14:58:14', 10);
INSERT INTO `sys_oper_log` VALUES (803, '设备接入网关', 1, 'com.ruoyi.iot.controller.EdgeDeviceController.add()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDevice', '127.0.0.1', '内网IP', '{\"configuration\":\"{\\\"ip_address\\\":\\\"127.0.0.1\\\",\\\"port\\\":502}\",\"createTime\":\"2026-08-31 15:05:34\",\"id\":\"modbus_mtgw8yl9_fzq7q\",\"linkStatus\":\"offline\",\"name\":\"modlocal\",\"params\":{},\"protocolId\":\"modbus\",\"status\":\"enable\"} ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'seq\' doesn\'t have a default value\r\n### The error may exist in file [D:\\workspace\\lightning\\lightning-iot\\target\\classes\\mapper\\iot\\EdgeDeviceMapper.xml]\r\n### The error may involve com.ruoyi.iot.mapper.EdgeDeviceMapper.insertEdgeDevice-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into edge_device          ( id,             name,             status,             link_status,             protocol_id,             configuration,                                                    create_time )           values ( ?,             ?,             ?,             ?,             ?,             ?,                                                    ? )\r\n### Cause: java.sql.SQLException: Field \'seq\' doesn\'t have a default value\n; Field \'seq\' doesn\'t have a default value', '2026-08-31 15:05:35', 315);
INSERT INTO `sys_oper_log` VALUES (804, '设备接入网关', 1, 'com.ruoyi.iot.controller.EdgeDeviceController.add()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDevice', '127.0.0.1', '内网IP', '{\"configuration\":\"{\\\"ip_address\\\":\\\"127.0.0.1\\\",\\\"port\\\":502}\",\"createTime\":\"2026-08-31 15:06:12\",\"id\":\"modbus_mtgw8yl9_fzq7q\",\"linkStatus\":\"offline\",\"name\":\"modlocal\",\"params\":{},\"protocolId\":\"modbus\",\"status\":\"enable\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-31 15:06:12', 9);
INSERT INTO `sys_oper_log` VALUES (805, '设备接入网关', 3, 'com.ruoyi.iot.controller.EdgeDeviceController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/edgeDevice/modbus_mtgw8yl9_fzq7q', '127.0.0.1', '内网IP', '[\"modbus_mtgw8yl9_fzq7q\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-31 15:07:47', 10);
INSERT INTO `sys_oper_log` VALUES (806, '设备接入网关', 1, 'com.ruoyi.iot.controller.EdgeDeviceController.add()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDevice', '127.0.0.1', '内网IP', '{\"configuration\":\"{\\\"ip_address\\\":\\\"127.0.0.1\\\",\\\"port\\\":502}\",\"createTime\":\"2026-08-31 15:07:59\",\"id\":\"modbus_mtgwc3bg_5g4kh\",\"linkStatus\":\"offline\",\"name\":\"modbusaaa\",\"params\":{},\"protocolId\":\"modbus\",\"status\":\"enable\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-31 15:07:59', 9);
INSERT INTO `sys_oper_log` VALUES (807, '设备接入网关', 3, 'com.ruoyi.iot.controller.EdgeDeviceController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/edgeDevice/modbus_mtgwc3bg_5g4kh', '127.0.0.1', '内网IP', '[\"modbus_mtgwc3bg_5g4kh\"] ', NULL, 1, '网关已启动，请先停用网关后再删除点位', '2026-08-31 15:13:00', 11);
INSERT INTO `sys_oper_log` VALUES (808, '设备接入网关', 3, 'com.ruoyi.iot.controller.EdgeDeviceController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/edgeDevice/modbus_mtgwc3bg_5g4kh', '127.0.0.1', '内网IP', '[\"modbus_mtgwc3bg_5g4kh\"] ', NULL, 1, '网关已启动，请先停用网关后再删除点位', '2026-08-31 15:13:06', 2);
INSERT INTO `sys_oper_log` VALUES (809, '设备接入网关', 3, 'com.ruoyi.iot.controller.EdgeDeviceController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/edgeDevice/modbus_mtgwc3bg_5g4kh', '127.0.0.1', '内网IP', '[\"modbus_mtgwc3bg_5g4kh\"] ', NULL, 1, '网关已启动，请先停用网关后再删除点位', '2026-08-31 15:13:11', 2);
INSERT INTO `sys_oper_log` VALUES (810, '设备接入网关', 1, 'com.ruoyi.iot.controller.EdgeDeviceController.add()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDevice', '127.0.0.1', '内网IP', '{\"configuration\":\"{\\\"ipAddress\\\":\\\"127.0.0.1\\\",\\\"port\\\":3671}\",\"createTime\":\"2026-08-31 22:57:24\",\"id\":\"knx_mthd3dt0_i42bg\",\"linkStatus\":\"offline\",\"name\":\"kncx_test\",\"params\":{},\"protocolId\":\"knx\",\"status\":\"disable\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-31 22:57:24', 20);
INSERT INTO `sys_oper_log` VALUES (811, '网关数据点位', 1, 'com.ruoyi.iot.controller.EdgeDataPointController.add()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint', '127.0.0.1', '内网IP', '{\"config\":\"{\\\"groupAddress\\\":\\\"0/0/1\\\",\\\"dpt\\\":\\\"1.001\\\"}\",\"createTime\":\"2026-08-31 22:59:24\",\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"name\":\"d11\",\"operationTpye\":\"rw\",\"params\":{},\"protocolId\":\"knx\",\"type\":\"boolean\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-31 22:59:24', 10);
INSERT INTO `sys_oper_log` VALUES (812, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"false\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-08-31 23:05:06', 57);
INSERT INTO `sys_oper_log` VALUES (813, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"true\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-08-31 23:05:11', 53);
INSERT INTO `sys_oper_log` VALUES (814, '网关数据点位', 1, 'com.ruoyi.iot.controller.EdgeDataPointController.add()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint', '127.0.0.1', '内网IP', '{\"config\":\"{\\\"dpt\\\":\\\"5.001\\\",\\\"groupAddress\\\":\\\"0/1/1\\\"}\",\"createTime\":\"2026-08-31 23:08:56\",\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094442318873698304\",\"name\":\"d12\",\"operationTpye\":\"rw\",\"params\":{},\"protocolId\":\"knx\",\"type\":\"int\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-31 23:08:56', 7);
INSERT INTO `sys_oper_log` VALUES (815, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094442318873698304\",\"params\":{},\"value\":\"100\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"边缘网关未连接\",\"result\":false}}', 0, NULL, '2026-08-31 23:11:28', 1);
INSERT INTO `sys_oper_log` VALUES (816, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094442318873698304\",\"params\":{},\"value\":\"2\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"边缘网关未连接\",\"result\":false}}', 0, NULL, '2026-08-31 23:12:51', 0);
INSERT INTO `sys_oper_log` VALUES (817, '网关数据点位', 3, 'com.ruoyi.iot.controller.EdgeDataPointController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/edgeDataPoint/2094442318873698304', '127.0.0.1', '内网IP', '[\"2094442318873698304\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-31 23:13:14', 11);
INSERT INTO `sys_oper_log` VALUES (818, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"false\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"边缘网关未连接\",\"result\":false}}', 0, NULL, '2026-08-31 23:15:47', 8);
INSERT INTO `sys_oper_log` VALUES (819, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"false\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-08-31 23:16:07', 28);
INSERT INTO `sys_oper_log` VALUES (820, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"true\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-08-31 23:16:11', 29);
INSERT INTO `sys_oper_log` VALUES (821, '网关数据点位', 1, 'com.ruoyi.iot.controller.EdgeDataPointController.add()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint', '127.0.0.1', '内网IP', '{\"config\":\"{\\\"groupAddress\\\":\\\"0/1/1\\\",\\\"dpt\\\":\\\"5.001\\\"}\",\"createTime\":\"2026-08-31 23:17:42\",\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094444525979324416\",\"name\":\"d12\",\"operationTpye\":\"rw\",\"params\":{},\"protocolId\":\"knx\",\"type\":\"float\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-08-31 23:17:42', 16);
INSERT INTO `sys_oper_log` VALUES (822, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"false\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-08-31 23:17:50', 53);
INSERT INTO `sys_oper_log` VALUES (823, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094444525979324416\",\"params\":{},\"value\":\"18\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"下置点位缓存中不存在，请重启边缘网关设备\",\"result\":false}}', 0, NULL, '2026-08-31 23:17:57', 1);
INSERT INTO `sys_oper_log` VALUES (824, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094444525979324416\",\"params\":{},\"value\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"下置点位缓存中不存在，请重启边缘网关设备\",\"result\":false}}', 0, NULL, '2026-08-31 23:18:12', 0);
INSERT INTO `sys_oper_log` VALUES (825, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094444525979324416\",\"params\":{},\"value\":\"4\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"下置点位缓存中不存在，请重启边缘网关设备\",\"result\":false}}', 0, NULL, '2026-08-31 23:18:14', 1);
INSERT INTO `sys_oper_log` VALUES (826, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094444525979324416\",\"params\":{},\"value\":\"78\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"边缘网关未连接\",\"result\":false}}', 0, NULL, '2026-08-31 23:18:37', 0);
INSERT INTO `sys_oper_log` VALUES (827, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094444525979324416\",\"params\":{},\"value\":\"78\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-08-31 23:20:24', 56019);
INSERT INTO `sys_oper_log` VALUES (828, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094444525979324416\",\"params\":{},\"value\":\"78\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置失败：maximum send attempts, no service acknowledgment received\",\"result\":false}}', 0, NULL, '2026-08-31 23:27:28', 12005);
INSERT INTO `sys_oper_log` VALUES (829, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094444525979324416\",\"params\":{},\"value\":\"56\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"边缘网关未连接\",\"result\":false}}', 0, NULL, '2026-08-31 23:27:31', 0);
INSERT INTO `sys_oper_log` VALUES (830, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094444525979324416\",\"params\":{},\"value\":\"58.0356\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"边缘网关未连接\",\"result\":false}}', 0, NULL, '2026-08-31 23:27:49', 0);
INSERT INTO `sys_oper_log` VALUES (831, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"false\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"边缘网关未连接\",\"result\":false}}', 0, NULL, '2026-08-31 23:28:31', 5538);
INSERT INTO `sys_oper_log` VALUES (832, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"false\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置失败：maximum send attempts, no service acknowledgment received\",\"result\":false}}', 0, NULL, '2026-08-31 23:28:54', 14165);
INSERT INTO `sys_oper_log` VALUES (833, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"false\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置失败：maximum send attempts, no service acknowledgment received\",\"result\":false}}', 0, NULL, '2026-08-31 23:32:19', 12015);
INSERT INTO `sys_oper_log` VALUES (834, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"false\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"边缘网关未连接\",\"result\":false}}', 0, NULL, '2026-08-31 23:32:41', 1);
INSERT INTO `sys_oper_log` VALUES (835, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"true\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"边缘网关未连接\",\"result\":false}}', 0, NULL, '2026-08-31 23:32:46', 0);
INSERT INTO `sys_oper_log` VALUES (836, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"true\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"边缘网关未连接\",\"result\":false}}', 0, NULL, '2026-08-31 23:33:46', 5760);
INSERT INTO `sys_oper_log` VALUES (837, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"false\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"边缘网关未连接\",\"result\":false}}', 0, NULL, '2026-08-31 23:34:32', 0);
INSERT INTO `sys_oper_log` VALUES (838, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"true\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"边缘网关未连接\",\"result\":false}}', 0, NULL, '2026-08-31 23:34:36', 0);
INSERT INTO `sys_oper_log` VALUES (839, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"false\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-08-31 23:38:34', 53);
INSERT INTO `sys_oper_log` VALUES (840, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"true\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-08-31 23:38:38', 42);
INSERT INTO `sys_oper_log` VALUES (841, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"false\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-08-31 23:41:14', 35858);
INSERT INTO `sys_oper_log` VALUES (842, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094444525979324416\",\"params\":{},\"value\":\"78\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-08-31 23:43:32', 57009);
INSERT INTO `sys_oper_log` VALUES (843, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"true\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-08-31 23:43:42', 36);
INSERT INTO `sys_oper_log` VALUES (844, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094444525979324416\",\"params\":{},\"value\":\"45\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-08-31 23:43:50', 41);
INSERT INTO `sys_oper_log` VALUES (845, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094444525979324416\",\"params\":{},\"value\":\"56\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-08-31 23:43:55', 61);
INSERT INTO `sys_oper_log` VALUES (846, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094444525979324416\",\"params\":{},\"value\":\"56\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-08-31 23:45:53', 8);
INSERT INTO `sys_oper_log` VALUES (847, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094444525979324416\",\"params\":{},\"value\":\"10\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-08-31 23:45:59', 17);
INSERT INTO `sys_oper_log` VALUES (848, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094444525979324416\",\"params\":{},\"value\":\"15\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-08-31 23:46:04', 47);
INSERT INTO `sys_oper_log` VALUES (849, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094444525979324416\",\"params\":{},\"value\":\"100\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-08-31 23:46:38', 47);
INSERT INTO `sys_oper_log` VALUES (850, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094444525979324416\",\"params\":{},\"value\":\"15\"} ', NULL, 1, '边缘网关不存在或着离线！', '2026-09-01 09:09:39', 8);
INSERT INTO `sys_oper_log` VALUES (851, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094444525979324416\",\"params\":{},\"value\":\"88\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-09-01 09:21:48', 19);
INSERT INTO `sys_oper_log` VALUES (852, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint', '127.0.0.1', '内网IP', '{\"config\":\"{\\\"groupAddress\\\":\\\"0/1/1\\\",\\\"dpt\\\":\\\"5.001\\\"}\",\"createBy\":\"\",\"createTime\":\"2026-08-31 23:17:43\",\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094444525979324416\",\"lastTime\":\"2026-09-01 09:21:48\",\"name\":\"d12\",\"operationTpye\":\"rw\",\"params\":{},\"protocolId\":\"knx\",\"type\":\"int\",\"updateBy\":\"\",\"updateTime\":\"2026-09-01 09:23:40\",\"value\":\"87.84314\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-01 09:23:40', 17);
INSERT INTO `sys_oper_log` VALUES (853, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094444525979324416\",\"params\":{},\"value\":\"45\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"边缘网关未连接\",\"result\":false}}', 0, NULL, '2026-09-01 09:24:02', 1);
INSERT INTO `sys_oper_log` VALUES (854, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094444525979324416\",\"params\":{},\"value\":\"87.84314\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"边缘网关未连接\",\"result\":false}}', 0, NULL, '2026-09-01 09:24:17', 0);
INSERT INTO `sys_oper_log` VALUES (855, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094444525979324416\",\"params\":{},\"value\":\"87.84314\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-09-01 09:25:05', 27857);
INSERT INTO `sys_oper_log` VALUES (856, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094444525979324416\",\"params\":{},\"value\":\"18\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-09-01 09:25:15', 62);
INSERT INTO `sys_oper_log` VALUES (857, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094444525979324416\",\"params\":{},\"value\":\"56\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-09-01 09:25:21', 39);
INSERT INTO `sys_oper_log` VALUES (858, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"true\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-09-01 09:25:28', 25);
INSERT INTO `sys_oper_log` VALUES (859, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094444525979324416\",\"params\":{},\"value\":\"46\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置失败：maximum send attempts, no service acknowledgment received\",\"result\":false}}', 0, NULL, '2026-09-01 09:28:19', 12038);
INSERT INTO `sys_oper_log` VALUES (860, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"false\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置失败：maximum send attempts, no service acknowledgment received\",\"result\":false}}', 0, NULL, '2026-09-01 09:30:11', 12006);
INSERT INTO `sys_oper_log` VALUES (861, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"false\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"边缘网关未连接\",\"result\":false}}', 0, NULL, '2026-09-01 10:02:47', 0);
INSERT INTO `sys_oper_log` VALUES (862, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"true\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"边缘网关未连接\",\"result\":false}}', 0, NULL, '2026-09-01 10:02:54', 0);
INSERT INTO `sys_oper_log` VALUES (863, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"false\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"边缘网关未连接\",\"result\":false}}', 0, NULL, '2026-09-01 10:03:08', 1);
INSERT INTO `sys_oper_log` VALUES (864, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"true\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"边缘网关未连接\",\"result\":false}}', 0, NULL, '2026-09-01 10:04:26', 8);
INSERT INTO `sys_oper_log` VALUES (865, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"true\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"边缘网关未连接\",\"result\":false}}', 0, NULL, '2026-09-01 10:05:38', 64552);
INSERT INTO `sys_oper_log` VALUES (866, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"true\"} ', NULL, 1, '边缘网关已经离线！', '2026-09-01 10:09:34', 9);
INSERT INTO `sys_oper_log` VALUES (867, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"true\"} ', NULL, 1, '边缘网关已经离线！', '2026-09-01 10:09:38', 0);
INSERT INTO `sys_oper_log` VALUES (868, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"knx_mthd3dt0_i42bg\",\"id\":\"2094439920222543872\",\"params\":{},\"value\":\"true\"} ', NULL, 1, '边缘网关已经离线！', '2026-09-01 10:09:42', 0);
INSERT INTO `sys_oper_log` VALUES (869, '设备接入网关', 1, 'com.ruoyi.iot.controller.EdgeDeviceController.add()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDevice', '127.0.0.1', '内网IP', '{\"configuration\":\"{\\\"localDeviceInstance\\\":1,\\\"localIp\\\":\\\"198.18.0.1:47808\\\"}\",\"createTime\":\"2026-09-01 11:28:21\",\"id\":\"bacnet_mti3x5j1_q2o7f\",\"linkStatus\":\"offline\",\"name\":\"bacnet_test\",\"params\":{},\"protocolId\":\"bacnet\",\"status\":\"disable\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-01 11:28:21', 16);
INSERT INTO `sys_oper_log` VALUES (870, '设备接入网关', 2, 'com.ruoyi.iot.controller.EdgeDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDevice', '127.0.0.1', '内网IP', '{\"configuration\":\"{\\\"localDeviceInstance\\\":1,\\\"localIp\\\":\\\"198.18.0.1\\\"}\",\"createBy\":\"\",\"createTime\":\"2026-09-01 11:28:22\",\"id\":\"bacnet_mti3x5j1_q2o7f\",\"linkStatus\":\"offline\",\"name\":\"bacnet_test\",\"params\":{},\"protocolId\":\"bacnet\",\"status\":\"disable\",\"updateTime\":\"2026-09-01 11:28:30\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-01 11:28:30', 13);
INSERT INTO `sys_oper_log` VALUES (871, '设备接入网关', 2, 'com.ruoyi.iot.controller.EdgeDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDevice', '127.0.0.1', '内网IP', '{\"configuration\":\"{\\\"localDeviceInstance\\\":10,\\\"localIp\\\":\\\"198.18.0.1\\\",\\\"pollingInterval\\\":1000}\",\"createBy\":\"\",\"createTime\":\"2026-09-01 11:28:22\",\"id\":\"bacnet_mti3x5j1_q2o7f\",\"linkStatus\":\"offline\",\"name\":\"bacnet_test\",\"params\":{},\"protocolId\":\"bacnet\",\"status\":\"enable\",\"updateTime\":\"2026-09-01 11:28:47\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-01 11:28:47', 13);
INSERT INTO `sys_oper_log` VALUES (872, '设备接入网关', 3, 'com.ruoyi.iot.controller.EdgeDeviceController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/edgeDevice/bacnet_mti3x5j1_q2o7f', '127.0.0.1', '内网IP', '[\"bacnet_mti3x5j1_q2o7f\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-01 20:16:30', 17);
INSERT INTO `sys_oper_log` VALUES (873, '设备接入网关', 3, 'com.ruoyi.iot.controller.EdgeDeviceController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/edgeDevice/modbus_mtgwc3bg_5g4kh', '127.0.0.1', '内网IP', '[\"modbus_mtgwc3bg_5g4kh\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-01 20:18:06', 16);
INSERT INTO `sys_oper_log` VALUES (874, '设备接入网关', 1, 'com.ruoyi.iot.controller.EdgeDeviceController.add()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDevice', '127.0.0.1', '内网IP', '{\"configuration\":\"{\\\"ip_address\\\":\\\"127.0.0.1\\\",\\\"port\\\":502}\",\"createTime\":\"2026-09-01 20:18:22\",\"id\":\"modbus_mtimv06b_jun45\",\"linkStatus\":\"offline\",\"name\":\"modbusTest\",\"params\":{},\"protocolId\":\"modbus\",\"status\":\"disable\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-01 20:18:22', 15);
INSERT INTO `sys_oper_log` VALUES (875, '网关数据点位', 1, 'com.ruoyi.iot.controller.EdgeDataPointController.add()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint', '127.0.0.1', '内网IP', '{\"config\":\"{\\\"register_type\\\":\\\"holding\\\",\\\"offset\\\":0,\\\"quantity\\\":1}\",\"createTime\":\"2026-09-01 20:18:41\",\"gatewayId\":\"modbus_mtimv06b_jun45\",\"id\":\"2094761861501755392\",\"name\":\"int1\",\"operationTpye\":\"rw\",\"params\":{},\"protocolId\":\"modbus\",\"type\":\"int\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-01 20:18:41', 17);
INSERT INTO `sys_oper_log` VALUES (876, '网关数据点位', 5, 'com.ruoyi.iot.controller.EdgeDataPointController.export()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint/export', '127.0.0.1', '内网IP', '{\"protocolId\":\"modbus\",\"pageSize\":\"10\",\"pageNum\":\"1\",\"gatewayId\":\"modbus_mtimv06b_jun45\"}', NULL, 0, NULL, '2026-09-01 20:18:53', 521);
INSERT INTO `sys_oper_log` VALUES (877, '网关数据点位', 2, 'com.ruoyi.iot.controller.EdgeDataPointController.writeDataPoint()', 'PUT', 1, 'admin', '研发部门', '/iot/edgeDataPoint/write', '127.0.0.1', '内网IP', '{\"gatewayId\":\"modbus_mtimv06b_jun45\",\"id\":\"2094761861501755392\",\"params\":{},\"value\":\"10\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-09-01 20:19:27', 13);
INSERT INTO `sys_oper_log` VALUES (878, '网关数据点位', 1, 'com.ruoyi.iot.controller.EdgeDataPointController.importData()', 'POST', 1, 'admin', '研发部门', '/iot/edgeDataPoint/importData', '127.0.0.1', '内网IP', '{\"updateSupport\":\"0\",\"gatewayId\":\"modbus_mtimv06b_jun45\"}', NULL, 1, '很抱歉，导入失败！共 1 条数据格式不正确，错误如下：<br/>0、网关：modbus_mtimv06b_jun45，点位:int1 已存在', '2026-09-01 20:20:28', 381);
INSERT INTO `sys_oper_log` VALUES (879, '产品信息', 1, 'com.ruoyi.iot.controller.ProductsController.add()', 'POST', 1, 'admin', '研发部门', '/iot/products', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-09-01 20:21:51\",\"deviceType\":\"gatewayS\",\"id\":\"shuifa\",\"name\":\"水阀\",\"params\":{},\"productCategoryId\":102,\"protocolId\":\"modbus\",\"status\":\"enable\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-01 20:21:51', 12);
INSERT INTO `sys_oper_log` VALUES (880, '产品信息', 2, 'com.ruoyi.iot.controller.ProductsController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/products', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2026-09-01 20:21:52\",\"dataExpiration\":3650000,\"deviceType\":\"gatewayS\",\"id\":\"shuifa\",\"name\":\"水阀\",\"params\":{},\"productCategoryId\":102,\"protocolId\":\"modbus\",\"status\":\"enable\",\"storageInterval\":3000,\"updateBy\":\"\",\"updateTime\":\"2026-09-01 20:22:16\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-01 20:22:16', 18);
INSERT INTO `sys_oper_log` VALUES (881, '产品物模型', 1, 'com.ruoyi.iot.controller.ProductTemplatesController.add()', 'POST', 1, 'admin', '研发部门', '/iot/productTemplates', '127.0.0.1', '内网IP', '{\"classify\":\"property\",\"createTime\":\"2026-09-01 20:22:49\",\"define\":\"{\\\"valueType\\\":{\\\"type\\\":\\\"boolean\\\",\\\"trueValue\\\":\\\"true\\\",\\\"trueText\\\":\\\"真\\\",\\\"falseValue\\\":\\\"false\\\",\\\"falseText\\\":\\\"假\\\"}}\",\"id\":\"shuifa.kaiguan\",\"name\":\"开关\",\"operationTpye\":\"rw\",\"params\":{},\"productId\":\"shuifa\",\"telemetryKey\":\"kaiguan\",\"type\":\"boolean\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-01 20:22:49', 9);
INSERT INTO `sys_oper_log` VALUES (882, '产品物模型', 1, 'com.ruoyi.iot.controller.ProductTemplatesController.add()', 'POST', 1, 'admin', '研发部门', '/iot/productTemplates', '127.0.0.1', '内网IP', '{\"classify\":\"property\",\"createTime\":\"2026-09-01 20:23:25\",\"define\":\"{\\\"valueType\\\":{\\\"type\\\":\\\"float\\\",\\\"unit\\\":\\\"m³/s\\\",\\\"min\\\":0,\\\"max\\\":150,\\\"scale\\\":2}}\",\"id\":\"shuifa.speed\",\"name\":\"流量\",\"operationTpye\":\"R\",\"params\":{},\"productId\":\"shuifa\",\"telemetryKey\":\"speed\",\"type\":\"float\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-01 20:23:25', 9);
INSERT INTO `sys_oper_log` VALUES (883, '设备', 1, 'com.ruoyi.iot.controller.DevicesController.add()', 'POST', 1, 'admin', '研发部门', '/iot/devices', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-09-01 20:24:04\",\"deviceType\":\"gatewayS\",\"gatewayId\":\"modbus_mtimv06b_jun45\",\"groupId\":106,\"id\":\"shuifa01\",\"name\":\"水阀01\",\"params\":{},\"productId\":\"shuifa\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-01 20:24:04', 14);
INSERT INTO `sys_oper_log` VALUES (884, '设备属性模板', 1, 'com.ruoyi.iot.controller.DeviceBindingController.add()', 'POST', 1, 'admin', '研发部门', '/iot/binding', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-09-01 20:24:13\",\"dataType\":\"boolean\",\"deviceId\":\"shuifa01\",\"edgePointId\":\"2094761861501755392\",\"edgePointName\":\"int1\",\"gatewayId\":\"modbus_mtimv06b_jun45\",\"gatewayName\":\"modbusTest\",\"id\":\"c7bef995931547f2b30b18d75781fb00\",\"params\":{},\"productId\":\"shuifa\",\"productTemplateId\":\"shuifa.kaiguan\",\"telemetryKey\":\"kaiguan\",\"unitSymbol\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-01 20:24:13', 13);
INSERT INTO `sys_oper_log` VALUES (885, '设备属性模板', 1, 'com.ruoyi.iot.controller.DeviceBindingController.add()', 'POST', 1, 'admin', '研发部门', '/iot/binding', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-09-01 20:24:16\",\"dataType\":\"float\",\"deviceId\":\"shuifa01\",\"edgePointId\":\"2094762311897190400\",\"edgePointName\":\"int2\",\"gatewayId\":\"modbus_mtimv06b_jun45\",\"gatewayName\":\"modbusTest\",\"id\":\"46b4773cf4424ce7a12a5e8cdfdfc896\",\"params\":{},\"productId\":\"shuifa\",\"productTemplateId\":\"shuifa.speed\",\"telemetryKey\":\"speed\",\"unitSymbol\":\"m³/s\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-01 20:24:16', 13);
INSERT INTO `sys_oper_log` VALUES (886, '规则场景', 1, 'com.ruoyi.iot.controller.RuleSceneController.add()', 'POST', 1, 'admin', '研发部门', '/iot/ruleScene', '127.0.0.1', '内网IP', '{\"actions\":\"[{\\\"actionType\\\":\\\"DEVICE_PROPERTY\\\",\\\"targetDeviceId\\\":\\\"\\\",\\\"setProperty\\\":\\\"\\\",\\\"setValue\\\":\\\"\\\",\\\"delaySeconds\\\":1,\\\"message\\\":\\\"\\\",\\\"productId\\\":\\\"shuifa\\\",\\\"deviceId\\\":\\\"shuifa01\\\",\\\"property\\\":\\\"kaiguan\\\",\\\"value\\\":\\\"1\\\"}]\",\"conditionLogic\":\"AND\",\"conditions\":\"[]\",\"createTime\":\"2026-09-01 20:25:54\",\"description\":\"\",\"id\":\"scene_mtin4hky_wc8np\",\"name\":\"aaa\",\"params\":{},\"state\":\"enable\",\"triggers\":\"[{\\\"triggerType\\\":\\\"DEVICE\\\",\\\"deviceId\\\":\\\"shuifa01\\\",\\\"property\\\":\\\"kaiguan\\\",\\\"value\\\":\\\"1\\\",\\\"cronExpression\\\":\\\"\\\",\\\"alarm\\\":\\\"disable\\\",\\\"productId\\\":\\\"shuifa\\\",\\\"operator\\\":\\\"==\\\"}]\"} ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'seq\' doesn\'t have a default value\r\n### The error may exist in file [D:\\workspace\\lightning\\lightning-iot\\target\\classes\\mapper\\iot\\RuleSceneMapper.xml]\r\n### The error may involve com.ruoyi.iot.mapper.RuleSceneMapper.insertRuleScene-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into rule_scene          ( id,             name,             condition_logic,             triggers,             conditions,                          actions,                          state,                                       description,                          create_time )           values ( ?,             ?,             ?,             ?,             ?,                          ?,                          ?,                                       ?,                          ? )\r\n### Cause: java.sql.SQLException: Field \'seq\' doesn\'t have a default value\n; Field \'seq\' doesn\'t have a default value', '2026-09-01 20:25:54', 324);
INSERT INTO `sys_oper_log` VALUES (887, '能源逻辑计主数据；不直接保存设备属性通道和业务归属', 1, 'com.ruoyi.energy.controller.EnergyMeterController.add()', 'POST', 1, 'admin', '研发部门', '/energy/energyMeter', '127.0.0.1', '内网IP', '{\"commissionedAt\":\"2026-09-02\",\"createTime\":\"2026-09-01 20:36:11\",\"energyTypeId\":1,\"id\":49,\"isVirtual\":0,\"meterCode\":\"EM-001-001\",\"meterName\":\"aaa\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-01 20:36:11', 14);
INSERT INTO `sys_oper_log` VALUES (888, '逻辑计的设备历史采集通道及有效期配置', 1, 'com.ruoyi.energy.controller.EnergyMeterChannelController.add()', 'POST', 1, 'admin', '研发部门', '/energy/energyMeterChannel', '127.0.0.1', '内网IP', '{\"deviceId\":\"shuifa01\",\"direction\":\"IMPORT\",\"isPrimaryUsage\":0,\"meterId\":49,\"metricCode\":\"avcity_acrt\",\"metricRole\":\"ENERGY_READING\",\"multiplier\":1,\"params\":{},\"productId\":\"shuifa\",\"sourceUnit\":\"kiuw\",\"status\":\"0\",\"telemetryKey\":\"kaiguan\",\"validFrom\":\"2026-09-23\",\"versionNo\":1} ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'measurement_type\' doesn\'t have a default value\r\n### The error may exist in file [D:\\workspace\\lightning\\lightning-energy\\target\\classes\\mapper\\energy\\EnergyMeterChannelMapper.xml]\r\n### The error may involve com.ruoyi.energy.mapper.EnergyMeterChannelMapper.insertEnergyMeterChannel-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into energy_meter_channel          ( meter_id,             metric_code,             version_no,             metric_role,             is_primary_usage,             product_id,             device_id,             telemetry_key,                                       source_unit,             multiplier,             direction,                                                    valid_from,                          status )           values ( ?,             ?,             ?,             ?,             ?,             ?,             ?,             ?,                                       ?,             ?,             ?,                                                    ?,                          ? )\r\n### Cause: java.sql.SQLException: Field \'measurement_type\' doesn\'t have a default value\n; Field \'measurement_type\' doesn\'t have a default value', '2026-09-01 20:36:40', 7);
INSERT INTO `sys_oper_log` VALUES (889, '产品信息', 3, 'com.ruoyi.iot.controller.ProductsController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/products/shuifa', '127.0.0.1', '内网IP', '[\"shuifa\"] ', NULL, 1, '产品下有设备，请先删除设备', '2026-09-01 21:07:15', 5);
INSERT INTO `sys_oper_log` VALUES (890, '设备', 3, 'com.ruoyi.iot.controller.DevicesController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/devices/shuifa01', '127.0.0.1', '内网IP', '[\"shuifa01\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-01 21:07:25', 18);
INSERT INTO `sys_oper_log` VALUES (891, '设备', 1, 'com.ruoyi.iot.controller.DevicesController.add()', 'POST', 1, 'admin', '研发部门', '/iot/devices', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-09-01 21:07:44\",\"deviceType\":\"gatewayS\",\"id\":\"dimmer1\",\"name\":\"照明控制one\",\"params\":{},\"productId\":\"dimmer\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-01 21:07:44', 9);
INSERT INTO `sys_oper_log` VALUES (892, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/devices', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2026-09-01 21:07:44\",\"deviceType\":\"gatewayS\",\"gatewayId\":\"modbus_mtimv06b_jun45\",\"id\":\"dimmer1\",\"name\":\"照明控制one\",\"params\":{},\"productId\":\"dimmer\",\"updateTime\":\"2026-09-01 21:08:08\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-01 21:08:08', 9);
INSERT INTO `sys_oper_log` VALUES (893, '设备属性模板', 1, 'com.ruoyi.iot.controller.DeviceBindingController.add()', 'POST', 1, 'admin', '研发部门', '/iot/binding', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-09-01 21:08:12\",\"dataType\":\"int\",\"deviceId\":\"dimmer1\",\"edgePointId\":\"2094761861501755392\",\"edgePointName\":\"int1\",\"gatewayId\":\"modbus_mtimv06b_jun45\",\"gatewayName\":\"modbusTest\",\"id\":\"45ffeff46fe347f7bc8c913f5c065df5\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.brightness\",\"telemetryKey\":\"brightness\",\"unitSymbol\":\"%\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-01 21:08:12', 11);
INSERT INTO `sys_oper_log` VALUES (894, '设备属性模板', 1, 'com.ruoyi.iot.controller.DeviceBindingController.add()', 'POST', 1, 'admin', '研发部门', '/iot/binding', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-09-01 21:08:15\",\"dataType\":\"int\",\"deviceId\":\"dimmer1\",\"edgePointId\":\"2094762311897190400\",\"edgePointName\":\"int2\",\"gatewayId\":\"modbus_mtimv06b_jun45\",\"gatewayName\":\"modbusTest\",\"id\":\"dd8f8784c0514b53b76eebbfdad42c95\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.colorTemperature\",\"telemetryKey\":\"colorTemperature\",\"unitSymbol\":\"K\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-01 21:08:15', 11);
INSERT INTO `sys_oper_log` VALUES (895, '设备属性模板', 1, 'com.ruoyi.iot.controller.DeviceBindingController.add()', 'POST', 1, 'admin', '研发部门', '/iot/binding', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-09-01 21:08:17\",\"dataType\":\"boolean\",\"deviceId\":\"dimmer1\",\"edgePointId\":\"2094762311947522048\",\"edgePointName\":\"int3\",\"gatewayId\":\"modbus_mtimv06b_jun45\",\"gatewayName\":\"modbusTest\",\"id\":\"586f3459276f4654b3762c5473aa97f3\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.power\",\"telemetryKey\":\"power\",\"unitSymbol\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-01 21:08:17', 10);
INSERT INTO `sys_oper_log` VALUES (896, '设备属性模板', 1, 'com.ruoyi.iot.controller.DeviceBindingController.add()', 'POST', 1, 'admin', '研发部门', '/iot/binding', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-09-01 21:08:20\",\"dataType\":\"enum\",\"deviceId\":\"dimmer1\",\"edgePointId\":\"2094762311985270784\",\"edgePointName\":\"int4\",\"gatewayId\":\"modbus_mtimv06b_jun45\",\"gatewayName\":\"modbusTest\",\"id\":\"594b8c20f26e41d98c1844b7a3e5a6ff\",\"params\":{},\"productId\":\"dimmer\",\"productTemplateId\":\"dimmer.status\",\"telemetryKey\":\"status\",\"unitSymbol\":\"\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-01 21:08:20', 10);
INSERT INTO `sys_oper_log` VALUES (897, '设备分组', 2, 'com.ruoyi.iot.controller.DeviceGroupController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/deviceGroup', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"\",\"createTime\":\"2026-07-24 19:55:20\",\"delFlag\":\"0\",\"groupId\":105,\"groupName\":\"testA\",\"orderNum\":1,\"params\":{},\"productId\":\"dimmer\",\"updateBy\":\"\",\"updateTime\":\"2026-09-02 11:23:43\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-02 11:23:43', 27);
INSERT INTO `sys_oper_log` VALUES (898, '设备分组', 3, 'com.ruoyi.iot.controller.DeviceGroupController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/deviceGroup/105', '127.0.0.1', '内网IP', '[105] ', NULL, 1, '设备分组下存在子分组，不能删除：testa', '2026-09-02 11:23:47', 4);
INSERT INTO `sys_oper_log` VALUES (899, '设备分组', 3, 'com.ruoyi.iot.controller.DeviceGroupController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/deviceGroup/106', '127.0.0.1', '内网IP', '[106] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-02 11:23:48', 15);
INSERT INTO `sys_oper_log` VALUES (900, '设备分组', 3, 'com.ruoyi.iot.controller.DeviceGroupController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/deviceGroup/105', '127.0.0.1', '内网IP', '[105] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-02 11:23:49', 10);
INSERT INTO `sys_oper_log` VALUES (901, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"iot/deviceHistory/index\",\"createTime\":\"2025-03-11 18:56:28\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2164,\"menuName\":\"设备历史记录\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":2060,\"path\":\"deviceHistory\",\"perms\":\"iot:deviceHistory:list\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-02 11:24:08', 15);
INSERT INTO `sys_oper_log` VALUES (902, '告警记录', 2, 'com.ruoyi.iot.controller.AlarmLogController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/alarmLog', '127.0.0.1', '内网IP', '{\"handleMessage\":\"啊啊啊啊\",\"handleTime\":\"2026-09-30\",\"handleType\":\"3\",\"id\":2,\"params\":{},\"state\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-02 11:24:42', 11);
INSERT INTO `sys_oper_log` VALUES (903, '告警记录', 2, 'com.ruoyi.iot.controller.AlarmLogController.edit()', 'PUT', 1, 'admin', '研发部门', '/iot/alarmLog', '127.0.0.1', '内网IP', '{\"handleMessage\":\"asd\",\"handleTime\":\"2026-09-02\",\"handleType\":\"2\",\"id\":3,\"params\":{},\"state\":\"2\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-02 11:24:55', 9);
INSERT INTO `sys_oper_log` VALUES (904, '规则场景', 1, 'com.ruoyi.iot.controller.RuleSceneController.add()', 'POST', 1, 'admin', '研发部门', '/iot/ruleScene', '127.0.0.1', '内网IP', '{\"actionParallel\":\"true\",\"actions\":\"[{\\\"actionType\\\":\\\"DEVICE_PROPERTY\\\",\\\"targetType\\\":\\\"DEVICE\\\",\\\"productId\\\":\\\"dimmer\\\",\\\"deviceId\\\":\\\"dimmer1\\\",\\\"groupId\\\":null,\\\"property\\\":\\\"brightness\\\",\\\"value\\\":\\\"123\\\",\\\"delaySeconds\\\":1,\\\"retryCount\\\":0,\\\"retryInterval\\\":0,\\\"message\\\":\\\"\\\"}]\",\"conditionLogic\":\"AND\",\"conditions\":\"[]\",\"createTime\":\"2026-09-02 11:26:16\",\"description\":\"\",\"id\":\"scene_mtjjahry_z9tm3\",\"name\":\"123\",\"params\":{},\"state\":\"disable\",\"triggers\":\"[{\\\"triggerType\\\":\\\"DEVICE\\\",\\\"targetType\\\":\\\"DEVICE\\\",\\\"productId\\\":\\\"dimmer\\\",\\\"deviceId\\\":\\\"dimmer1\\\",\\\"groupId\\\":null,\\\"property\\\":\\\"brightness\\\",\\\"operator\\\":\\\"==\\\",\\\"value\\\":\\\"1\\\",\\\"alarm\\\":\\\"disable\\\",\\\"debounceDelay\\\":0,\\\"requiredConsecutiveMatches\\\":1,\\\"cronExpression\\\":\\\"\\\"}]\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-02 11:26:16', 21);
INSERT INTO `sys_oper_log` VALUES (905, '逻辑计的设备历史采集通道及有效期配置', 1, 'com.ruoyi.energy.controller.EnergyMeterChannelController.add()', 'POST', 1, 'admin', '研发部门', '/energy/energyMeterChannel', '127.0.0.1', '内网IP', '{\"deviceId\":\"dimmer1\",\"direction\":\"IMPORT\",\"isPrimaryUsage\":0,\"meterId\":49,\"metricCode\":\"q\'we\",\"metricRole\":\"ENERGY_READING\",\"multiplier\":1,\"params\":{},\"productId\":\"dimmer\",\"sourceUnit\":\"KWh\",\"status\":\"0\",\"telemetryKey\":\"colorTemperature\",\"validFrom\":\"2026-09-02\",\"versionNo\":1} ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'measurement_type\' doesn\'t have a default value\r\n### The error may exist in file [D:\\workspace\\lightning\\lightning-energy\\target\\classes\\mapper\\energy\\EnergyMeterChannelMapper.xml]\r\n### The error may involve com.ruoyi.energy.mapper.EnergyMeterChannelMapper.insertEnergyMeterChannel-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into energy_meter_channel          ( meter_id,             metric_code,             version_no,             metric_role,             is_primary_usage,             product_id,             device_id,             telemetry_key,                                       source_unit,             multiplier,             direction,                                                    valid_from,                          status )           values ( ?,             ?,             ?,             ?,             ?,             ?,             ?,             ?,                                       ?,             ?,             ?,                                                    ?,                          ? )\r\n### Cause: java.sql.SQLException: Field \'measurement_type\' doesn\'t have a default value\n; Field \'measurement_type\' doesn\'t have a default value', '2026-09-02 11:27:01', 329);
INSERT INTO `sys_oper_log` VALUES (906, '逻辑计的设备历史采集通道及有效期配置', 1, 'com.ruoyi.energy.controller.EnergyMeterChannelController.add()', 'POST', 1, 'admin', '研发部门', '/energy/energyMeterChannel', '127.0.0.1', '内网IP', '{\"deviceId\":\"dimmer1\",\"direction\":\"IMPORT\",\"isPrimaryUsage\":0,\"meterId\":49,\"metricCode\":\"q\'we\",\"metricRole\":\"ENERGY_READING\",\"multiplier\":1,\"params\":{},\"productId\":\"dimmer\",\"sourceUnit\":\"KWh\",\"status\":\"0\",\"telemetryKey\":\"colorTemperature\",\"validFrom\":\"2026-09-02\",\"versionNo\":1} ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'reading_mode\' doesn\'t have a default value\r\n### The error may exist in file [D:\\workspace\\lightning\\lightning-energy\\target\\classes\\mapper\\energy\\EnergyMeterChannelMapper.xml]\r\n### The error may involve com.ruoyi.energy.mapper.EnergyMeterChannelMapper.insertEnergyMeterChannel-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into energy_meter_channel          ( meter_id,             metric_code,             version_no,             metric_role,             is_primary_usage,             product_id,             device_id,             telemetry_key,                                       source_unit,             multiplier,             direction,                                                    valid_from,                          status )           values ( ?,             ?,             ?,             ?,             ?,             ?,             ?,             ?,                                       ?,             ?,             ?,                                                    ?,                          ? )\r\n### Cause: java.sql.SQLException: Field \'reading_mode\' doesn\'t have a default value\n; Field \'reading_mode\' doesn\'t have a default value', '2026-09-02 11:28:37', 3);
INSERT INTO `sys_oper_log` VALUES (907, '逻辑计的设备历史采集通道及有效期配置', 1, 'com.ruoyi.energy.controller.EnergyMeterChannelController.add()', 'POST', 1, 'admin', '研发部门', '/energy/energyMeterChannel', '127.0.0.1', '内网IP', '{\"deviceId\":\"dimmer1\",\"direction\":\"IMPORT\",\"id\":142,\"isPrimaryUsage\":0,\"meterId\":49,\"metricCode\":\"q\'we\",\"metricRole\":\"ENERGY_READING\",\"multiplier\":1,\"params\":{},\"productId\":\"dimmer\",\"sourceUnit\":\"KWh\",\"status\":\"0\",\"telemetryKey\":\"colorTemperature\",\"validFrom\":\"2026-09-02\",\"versionNo\":1} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-02 11:28:54', 10);
INSERT INTO `sys_oper_log` VALUES (908, '逻辑计的设备历史采集通道及有效期配置', 1, 'com.ruoyi.energy.controller.EnergyMeterChannelController.add()', 'POST', 1, 'admin', '研发部门', '/energy/energyMeterChannel', '127.0.0.1', '内网IP', '{\"deviceId\":\"dimmer1\",\"direction\":\"IMPORT\",\"id\":143,\"isPrimaryUsage\":0,\"measurementType\":\"CUMULATIVE_READING\",\"meterId\":49,\"metricCode\":\"qwe\",\"metricRole\":\"ENERGY_READING\",\"multiplier\":1,\"params\":{},\"productId\":\"dimmer\",\"readingMode\":\"CUMULATIVE\",\"sourceUnit\":\"kw\",\"status\":\"0\",\"telemetryKey\":\"brightness\",\"validFrom\":\"2026-09-02\",\"versionNo\":1} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-02 11:42:46', 103);
INSERT INTO `sys_oper_log` VALUES (909, '逻辑计的设备历史采集通道及有效期配置', 3, 'com.ruoyi.energy.controller.EnergyMeterChannelController.remove()', 'DELETE', 1, 'admin', '研发部门', '/energy/energyMeterChannel/143', '127.0.0.1', '内网IP', '[143] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-02 11:42:49', 10);
INSERT INTO `sys_oper_log` VALUES (910, '设备接入网关', 3, 'com.ruoyi.iot.controller.EdgeDeviceController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/edgeDevice/knx_mthd3dt0_i42bg', '127.0.0.1', '内网IP', '[\"knx_mthd3dt0_i42bg\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-04 09:29:05', 39);
INSERT INTO `sys_oper_log` VALUES (911, '设备接入网关', 3, 'com.ruoyi.iot.controller.EdgeDeviceController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/edgeDevice/modbus_mtimv06b_jun45', '127.0.0.1', '内网IP', '[\"modbus_mtimv06b_jun45\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-04 09:29:07', 18);
INSERT INTO `sys_oper_log` VALUES (912, '产品类型', 3, 'com.ruoyi.iot.controller.ProductCategoriesController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/productCategories/101', '127.0.0.1', '内网IP', '[101] ', '{\"msg\":\"存在下级产品类型,不允许删除\",\"code\":601}', 0, NULL, '2026-09-04 09:31:37', 3);
INSERT INTO `sys_oper_log` VALUES (913, '设备', 3, 'com.ruoyi.iot.controller.DevicesController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/devices/dimmer1', '127.0.0.1', '内网IP', '[\"dimmer1\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-04 09:31:43', 59);
INSERT INTO `sys_oper_log` VALUES (914, '产品信息', 3, 'com.ruoyi.iot.controller.ProductsController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/products/shuifa', '127.0.0.1', '内网IP', '[\"shuifa\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-04 09:31:48', 24);
INSERT INTO `sys_oper_log` VALUES (915, '产品信息', 3, 'com.ruoyi.iot.controller.ProductsController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/products/electrical', '127.0.0.1', '内网IP', '[\"electrical\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-04 09:31:49', 20);
INSERT INTO `sys_oper_log` VALUES (916, '产品信息', 3, 'com.ruoyi.iot.controller.ProductsController.remove()', 'DELETE', 1, 'admin', '研发部门', '/iot/products/dimmer', '127.0.0.1', '内网IP', '[\"dimmer\"] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-04 09:32:00', 18);
INSERT INTO `sys_oper_log` VALUES (917, '能源逻辑计主数据；不直接保存设备属性通道和业务归属', 3, 'com.ruoyi.energy.controller.EnergyMeterController.remove()', 'DELETE', 1, 'admin', '研发部门', '/energy/energyMeter/49', '127.0.0.1', '内网IP', '[49] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-09-04 09:32:15', 39);
INSERT INTO `sys_oper_log` VALUES (918, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"device-bms-fcu-01\",\"params\":{},\"productId\":\"bms-fcu\",\"productTemplateId\":\"pt-bms-fcu-fan-speed\",\"telemetryKey\":\"fan_speed\",\"value\":\"15\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-09-04 21:43:31', 8);
INSERT INTO `sys_oper_log` VALUES (919, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"device-bms-fcu-01\",\"params\":{},\"productId\":\"bms-fcu\",\"productTemplateId\":\"pt-bms-fcu-setpoint-temp\",\"telemetryKey\":\"setpoint_temp\",\"value\":\"23.6\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-09-04 21:43:42', 13);
INSERT INTO `sys_oper_log` VALUES (920, '设备', 2, 'com.ruoyi.iot.controller.DevicesController.write()', 'POST', 1, 'admin', '研发部门', '/iot/devices/write', '127.0.0.1', '内网IP', '{\"deviceId\":\"device-bms-fcu-01\",\"params\":{},\"productId\":\"bms-fcu\",\"productTemplateId\":\"pt-bms-fcu-setpoint-temp\",\"telemetryKey\":\"setpoint_temp\",\"value\":\"18\"} ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"message\":\"点位下置成功\",\"result\":true}}', 0, NULL, '2026-09-04 21:43:51', 4);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '岗位信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2026-06-26 10:30:29', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '0', 'admin', '2026-06-26 10:30:29', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2026-06-26 10:30:29', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2026-06-26 10:30:29', 'admin', '2026-07-16 11:38:24', '普通角色');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和部门关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime NULL DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '管理', '00', 'aaaaa@163.com', '15888888888', '0', '/profile/avatar/2026/08/27/8e9c3903645d4ee5bd15f4169e149f54.png', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-09-04 21:42:58', '2026-06-26 10:30:29', 'admin', '2026-06-26 10:30:29', '', '2026-08-27 16:39:31', '管理员');
INSERT INTO `sys_user` VALUES (2, 105, 'ry', '若依', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-06-26 10:30:29', '2026-06-26 10:30:29', 'admin', '2026-06-26 10:30:29', '', NULL, '测试员');

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (2, 2);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户和角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);

-- ----------------------------
-- Table structure for t_goview_project
-- ----------------------------
DROP TABLE IF EXISTS `t_goview_project`;
CREATE TABLE `t_goview_project`  (
  `id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键ID',
  `project_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '项目名称',
  `project_type` tinyint NULL DEFAULT NULL COMMENT '0大屏 1普通项目 2模板 3组件库',
  `state` tinyint NULL DEFAULT NULL COMMENT '项目状态（0草稿 1发布等）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `create_user_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建用户ID',
  `is_delete` tinyint NULL DEFAULT NULL COMMENT '是否删除（0否 1是）',
  `index_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '项目封面图',
  `remarks` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注信息',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'GoView项目基本信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_goview_project
-- ----------------------------

-- ----------------------------
-- Table structure for t_goview_project_data
-- ----------------------------
DROP TABLE IF EXISTS `t_goview_project_data`;
CREATE TABLE `t_goview_project_data`  (
  `id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键ID',
  `project_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联的项目ID',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `create_user_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建用户ID',
  `content` longblob NULL COMMENT '项目内容数据（JSON/结构化数据）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'GoView项目内容数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_goview_project_data
-- ----------------------------

-- ----------------------------
-- Table structure for t_sys_file
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_file`;
CREATE TABLE `t_sys_file`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键ID',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件名称',
  `file_size` int NULL DEFAULT NULL COMMENT '文件大小（字节）',
  `file_suffix` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件后缀名',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `md5` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件MD5值',
  `virtual_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '虚拟存储key（如OSS、COS路径）',
  `relative_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '相对路径',
  `absolute_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '绝对路径',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统文件存储表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_sys_file
-- ----------------------------
INSERT INTO `t_sys_file` VALUES ('1992566810839924737', '1992566810839924736/profile/upload/2025/11/23/能耗_20251123201202A001.pdf', 9313236, '.pdf', '2025-11-23 20:12:50', NULL, 'oss', '2025-11-23', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('1992567382326427649', '1992567382326427648/profile/upload/2025/11/23/zerox_20251123201339A002.txt', 93, '.txt', '2025-11-23 20:14:19', NULL, 'oss', '2025-11-23', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('1998388077799227393', '19983880777992273921998011340615614464_index_preview.png', 33049, '.png', '2025-12-09 21:43:41', NULL, 'oss', '2025-12-09', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('1998388289582219265', '19983882895822192641998011340615614464_index_preview.png', 33063, '.png', '2025-12-09 21:44:31', NULL, 'oss', '2025-12-09', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('1998388618130440193', '19983886181304401921998011340615614464_index_preview.png', 20896, '.png', '2025-12-09 21:45:49', NULL, 'oss', '2025-12-09', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('1998389534233542657', '19983895342335426561998011340615614464_index_preview.png', 20896, '.png', '2025-12-09 21:49:28', NULL, 'oss', '2025-12-09', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('1998399851156029441', '19983998511560294401998011340615614464_index_preview.png', 69546, '.png', '2025-12-09 22:30:28', NULL, 'oss', '2025-12-09', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('1998429495058055169', '19984294950580551681998011340615614464_index_preview.png', 31655, '.png', '2025-12-10 00:28:15', NULL, 'oss', '2025-12-10', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('1998429679817146369', '19984296798171463681998011340615614464_index_background.png', 4030770, '.png', '2025-12-10 00:28:59', NULL, 'oss', '2025-12-10', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('1998429811186941953', '19984298111869419521998011340615614464_index_background.png', 2122551, '.png', '2025-12-10 00:29:31', NULL, 'oss', '2025-12-10', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('1998430080947798017', '19984300809477980161998011340615614464_index_preview.png', 20481, '.png', '2025-12-10 00:30:35', NULL, 'oss', '2025-12-10', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('1998431804454375425', '19984318044543754241998431730781425664_index_preview.png', 24543, '.png', '2025-12-10 00:37:26', NULL, 'oss', '2025-12-10', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('1998431837576794113', '19984318375767941121998431730781425664_index_preview.png', 24543, '.png', '2025-12-10 00:37:34', NULL, 'oss', '2025-12-10', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('1998431850033876993', '19984318500338769921998431730781425664_index_preview.png', 24543, '.png', '2025-12-10 00:37:37', NULL, 'oss', '2025-12-10', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('1998432042942500865', '19984320429425008641998431730781425664_index_preview.png', 29257, '.png', '2025-12-10 00:38:23', NULL, 'oss', '2025-12-10', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('1998725374088400896', '19987253740842065921998431730781425664_index_preview.png', 229945, '.png', '2025-12-10 20:03:58', NULL, 'oss', '2025-12-10', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('1998725484897718273', '19987254848977182721998431730781425664_index_preview.png', 24543, '.png', '2025-12-10 20:04:25', NULL, 'oss', '2025-12-10', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('1998728965511532545', '19987289655115325441998431730781425664_index_preview.png', 93548, '.png', '2025-12-10 20:18:15', NULL, 'oss', '2025-12-10', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('1998731016836567041', '19987310168365670401998431730781425664_index_preview.png', 126770, '.png', '2025-12-10 20:26:24', NULL, 'oss', '2025-12-10', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('1998731307313090561', '19987313073130905601998431730781425664_index_preview.png', 126525, '.png', '2025-12-10 20:27:33', NULL, 'oss', '2025-12-10', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('1998731429849681921', '19987314298496819201998431730781425664_index_preview.png', 126857, '.png', '2025-12-10 20:28:02', NULL, 'oss', '2025-12-10', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('1998731687711297537', '19987316877112975361998431730781425664_index_preview.png', 127086, '.png', '2025-12-10 20:29:04', NULL, 'oss', '2025-12-10', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2001980191204208641', '2001980191204208640500_index_preview.png', 126724, '.png', '2025-12-19 19:37:27', NULL, 'oss', '2025-12-19', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2001980518603190273', '2001980518603190272500_index_preview.png', 126357, '.png', '2025-12-19 19:38:45', NULL, 'oss', '2025-12-19', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2001981590692458497', '20019815906924584962001981576423436288_index_preview.png', 24543, '.png', '2025-12-19 19:43:01', NULL, 'oss', '2025-12-19', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002005795815321601', '20020057958153216002001981576423436288_index_preview.png', 84960, '.png', '2025-12-19 21:19:12', NULL, 'oss', '2025-12-19', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002008351492829185', '20020083514928291842001981576423436288_index_preview.png', 95677, '.png', '2025-12-19 21:29:21', NULL, 'oss', '2025-12-19', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002008590417162241', '20020085904171622402001981576423436288_index_preview.png', 253584, '.png', '2025-12-19 21:30:18', NULL, 'oss', '2025-12-19', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002008657702187009', '20020086577021870082001981576423436288_index_preview.png', 254198, '.png', '2025-12-19 21:30:34', NULL, 'oss', '2025-12-19', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002008659333771265', '20020086593337712642001981576423436288_index_preview.png', 254103, '.png', '2025-12-19 21:30:35', NULL, 'oss', '2025-12-19', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002008664475987969', '20020086644759879682001981576423436288_index_preview.png', 254225, '.png', '2025-12-19 21:30:36', NULL, 'oss', '2025-12-19', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002008676912099329', '20020086769120993282001981576423436288_index_preview.png', 254383, '.png', '2025-12-19 21:30:39', NULL, 'oss', '2025-12-19', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002008687544659969', '20020086875446599682001981576423436288_index_preview.png', 252132, '.png', '2025-12-19 21:30:41', NULL, 'oss', '2025-12-19', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002008745153425409', '2002008745153425408500_index_preview.png', 254509, '.png', '2025-12-19 21:30:55', NULL, 'oss', '2025-12-19', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002009680353193985', '20020096803531939842001981576423436288_index_preview.png', 255526, '.png', '2025-12-19 21:34:38', NULL, 'oss', '2025-12-19', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002009753162117121', '20020097531621171202001981576423436288_index_preview.png', 261033, '.png', '2025-12-19 21:34:55', NULL, 'oss', '2025-12-19', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002009759449378817', '20020097594493788162001981576423436288_index_preview.png', 252595, '.png', '2025-12-19 21:34:57', NULL, 'oss', '2025-12-19', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002009765589839873', '20020097655898398722001981576423436288_index_preview.png', 252755, '.png', '2025-12-19 21:34:58', NULL, 'oss', '2025-12-19', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002009821877399553', '20020098218773995522001981576423436288_index_preview.png', 250505, '.png', '2025-12-19 21:35:12', NULL, 'oss', '2025-12-19', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002273897446711296', '20022738974425169922001981576423436288_index_preview.png', 254227, '.png', '2025-12-20 15:04:32', NULL, 'oss', '2025-12-20', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002273912260993025', '20022739122609930242001981576423436288_index_preview.png', 254185, '.png', '2025-12-20 15:04:36', NULL, 'oss', '2025-12-20', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002279242059554817', '20022792420595548162001981576423436288_index_preview.png', 266815, '.png', '2025-12-20 15:25:47', NULL, 'oss', '2025-12-20', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002337472974495745', '20023374729744957442001981576423436288_index_preview.png', 92733, '.png', '2025-12-20 19:17:10', NULL, 'oss', '2025-12-20', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002337993965772801', '20023379939657728002001981576423436288_index_preview.png', 92587, '.png', '2025-12-20 19:19:14', NULL, 'oss', '2025-12-20', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002338033115406337', '20023380331154063362001981576423436288_index_preview.png', 91514, '.png', '2025-12-20 19:19:23', NULL, 'oss', '2025-12-20', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002398911617638401', '20023989116176384002001981576423436288_index_preview.png', 91244, '.png', '2025-12-20 23:21:18', NULL, 'oss', '2025-12-20', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002400083460038657', '20024000834600386562002399507196223488_index_preview.png', 28705, '.png', '2025-12-20 23:25:57', NULL, 'oss', '2025-12-20', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002400437027282945', '20024004370272829442002399507196223488_index_preview.png', 29224, '.png', '2025-12-20 23:27:22', NULL, 'oss', '2025-12-20', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002400782461771777', '20024007824617717762002399507196223488_index_preview.png', 29224, '.png', '2025-12-20 23:28:44', NULL, 'oss', '2025-12-20', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002400876447735809', '20024008764477358082002399507196223488_index_preview.png', 29224, '.png', '2025-12-20 23:29:06', NULL, 'oss', '2025-12-20', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002401249275224065', '20024012492752240642002399507196223488_index_preview.png', 29241, '.png', '2025-12-20 23:30:35', NULL, 'oss', '2025-12-20', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002401278815707137', '20024012788157071362002399507196223488_index_preview.png', 26201, '.png', '2025-12-20 23:30:42', NULL, 'oss', '2025-12-20', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002401408214179841', '20024014082141798402002401345874239488_index_preview.png', 43451, '.png', '2025-12-20 23:31:13', NULL, 'oss', '2025-12-20', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002401665085939713', '20024016650859397122002401345874239488_index_preview.png', 43284, '.png', '2025-12-20 23:32:14', NULL, 'oss', '2025-12-20', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002402290645409793', '20024022906454097922002402219900084224_index_preview.png', 29225, '.png', '2025-12-20 23:34:44', NULL, 'oss', '2025-12-20', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002402343158095873', '20024023431580958722002402219900084224_index_preview.png', 29225, '.png', '2025-12-20 23:34:56', NULL, 'oss', '2025-12-20', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002662301229506561', '20026623012295065602002402219900084224_index_preview.png', 29220, '.png', '2025-12-21 16:47:55', NULL, 'oss', '2025-12-21', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002662367944105985', '20026623679441059842002402219900084224_index_preview.png', 26200, '.png', '2025-12-21 16:48:11', NULL, 'oss', '2025-12-21', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002662517533958145', '20026625175339581442002402219900084224_index_preview.png', 28679, '.png', '2025-12-21 16:48:47', NULL, 'oss', '2025-12-21', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002662537675005953', '20026625376750059522002402219900084224_index_preview.png', 26260, '.png', '2025-12-21 16:48:51', NULL, 'oss', '2025-12-21', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002667378845540353', '20026673788455403522002402219900084224_index_preview.png', 41802, '.png', '2025-12-21 17:08:06', NULL, 'oss', '2025-12-21', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002765823514107905', '20027658235141079042002402219900084224_index_preview.png', 28698, '.png', '2025-12-21 23:39:17', NULL, 'oss', '2025-12-21', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002767207856726017', '20027672078567260162002402219900084224_index_preview.png', 43999, '.png', '2025-12-21 23:44:47', NULL, 'oss', '2025-12-21', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002768876493463553', '20027688764934635522002402219900084224_index_preview.png', 43999, '.png', '2025-12-21 23:51:24', NULL, 'oss', '2025-12-21', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002769394573893633', '20027693945738936322002402219900084224_index_preview.png', 28695, '.png', '2025-12-21 23:53:28', NULL, 'oss', '2025-12-21', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2002769400588525569', '20027694005885255682002402219900084224_index_preview.png', 28696, '.png', '2025-12-21 23:53:29', NULL, 'oss', '2025-12-21', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071056423500476417', '2071056423500476416device_component_icon_1782613304049.png', 6327, '.png', '2026-06-28 10:21:44', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071056505851441153', '2071056505851441152device_component_icon_1782613323925.png', 1520953, '.png', '2026-06-28 10:22:04', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071058742057201664', '20710587420530073602071056097309454336_index_preview.png', 20375, '.png', '2026-06-28 10:30:57', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071058914166272001', '20710589141662720002071056097309454336_index_preview.png', 19018, '.png', '2026-06-28 10:31:38', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071058991391797249', '20710589913917972482071058772985999360_index_preview.png', 17691, '.png', '2026-06-28 10:31:57', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071059039320109057', '20710590393201090562071058772985999360_index_preview.png', 18926, '.png', '2026-06-28 10:32:08', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071068637489885185', '20710686374898851842071068587175014400_index_preview.png', 17691, '.png', '2026-06-28 11:10:16', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071069099366641665', '2071069099366641664device_component_icon_1782616326532.png', 6790, '.png', '2026-06-28 11:12:07', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071069115837673473', '2071069115837673472device_component_icon_1782616330459.png', 6673, '.png', '2026-06-28 11:12:10', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071069127158099969', '2071069127158099968device_component_icon_1782616333158.png', 6772, '.png', '2026-06-28 11:12:13', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071069197861482497', '2071069197861482496device_component_icon_1782616350016.png', 6772, '.png', '2026-06-28 11:12:30', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071069239880019969', '2071069239880019968device_component_icon_1782616360033.png', 6772, '.png', '2026-06-28 11:12:40', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071069292082327553', '2071069292082327552device_component_icon_1782616372477.png', 6673, '.png', '2026-06-28 11:12:52', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071069305961279489', '2071069305961279488device_component_icon_1782616375788.png', 6790, '.png', '2026-06-28 11:12:56', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071069638129184769', '20710696381291847682071068587175014400_index_preview.png', 41738, '.png', '2026-06-28 11:14:15', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071069748527460352', '20710697485232660482071069727958593536_index_preview.png', 17691, '.png', '2026-06-28 11:14:41', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071070202325987328', '20710702023175987202071068587175014400_index_preview.png', 74939, '.png', '2026-06-28 11:16:30', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071070493326798849', '20710704933267988482071069727958593536_index_preview.png', 38762, '.png', '2026-06-28 11:17:39', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071070560913813504', '20710705609096192002071069727958593536_index_preview.png', 28653, '.png', '2026-06-28 11:17:55', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071129493330292737', '20711294933302927362071129413881786368_index_preview.png', 17691, '.png', '2026-06-28 15:12:06', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071129504172568577', '20711295041725685762071129413881786368_index_preview.png', 17691, '.png', '2026-06-28 15:12:08', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071129572460032001', '2071129572460032000device_component_icon_1782630744432.png', 6772, '.png', '2026-06-28 15:12:24', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071129593347665920', '20711295933434716162071129413881786368_index_preview.png', 19026, '.png', '2026-06-28 15:12:29', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071131018735742976', '20711310187315486722071069727958593536_index_preview.png', 27969, '.png', '2026-06-28 15:18:09', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071131179398557697', '20711311793985576962071129413881786368_index_preview.png', 22601, '.png', '2026-06-28 15:18:48', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071131271631302657', '20711312716313026562071129413881786368_index_preview.png', 26390, '.png', '2026-06-28 15:19:10', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071131382469980160', '20711313824657858562071069727958593536_index_preview.png', 27133, '.png', '2026-06-28 15:19:36', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071131436492615681', '20711314364926156802071069727958593536_index_preview.png', 48720, '.png', '2026-06-28 15:19:49', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071131639715033088', '20711316397108387842071068587175014400_index_preview.png', 59941, '.png', '2026-06-28 15:20:37', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071131820279820289', '20711318202798202882071068587175014400_index_preview.png', 71963, '.png', '2026-06-28 15:21:20', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2071140869423591425', '20711408694235914242071069727958593536_index_preview.png', 75178, '.png', '2026-06-28 15:57:18', NULL, 'oss', '2026-06-28', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2077013079429898241', '2077013079429898240device_component_icon_1784033481748.png', 22328, '.png', '2026-07-14 20:51:22', NULL, 'oss', '2026-07-14', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2077013140402495489', '2077013140402495488device_component_icon_1784033496358.jpg', 13303, '.jpg', '2026-07-14 20:51:36', NULL, 'oss', '2026-07-14', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2077013218924060673', '2077013218924060672device_component_icon_1784033515079.png', 22328, '.png', '2026-07-14 20:51:55', NULL, 'oss', '2026-07-14', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2077013352881741824', '20770133528775475202071068587175014400_index_preview.png', 72411, '.png', '2026-07-14 20:52:27', NULL, 'oss', '2026-07-14', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2077013433848586241', '20770134338485862402071069727958593536_index_preview.png', 29237, '.png', '2026-07-14 20:52:46', NULL, 'oss', '2026-07-14', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2077013633837195265', '20770136338371952642071069727958593536_index_preview.png', 30556, '.png', '2026-07-14 20:53:34', NULL, 'oss', '2026-07-14', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2077022474441666561', '20770224744416665602071068587175014400_index_preview.png', 85102, '.png', '2026-07-14 21:28:42', NULL, 'oss', '2026-07-14', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2077022555412705281', '20770225554127052802071068587175014400_index_preview.png', 85102, '.png', '2026-07-14 21:29:01', NULL, 'oss', '2026-07-14', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2077227503228338177', '20772275032283381762071068587175014400_index_preview.png', 73044, '.png', '2026-07-15 11:03:24', NULL, 'oss', '2026-07-15', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2077227624632467457', '20772276246324674562071069727958593536_index_preview.png', 70371, '.png', '2026-07-15 11:03:53', NULL, 'oss', '2026-07-15', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2078680948958011393', '20786809489580113922071069727958593536_index_preview.png', 78204, '.png', '2026-07-19 11:18:53', NULL, 'oss', '2026-07-19', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2083113783861055489', '20831137838610554882071069727958593536_index_preview.png', 99099, '.png', '2026-07-31 16:53:23', NULL, 'oss', '2026-07-31', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2083113981404385281', '20831139814043852802071069727958593536_index_preview.png', 99099, '.png', '2026-07-31 16:54:10', NULL, 'oss', '2026-07-31', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2083132401395044353', '20831324013950443522071068587175014400_index_preview.png', 63455, '.png', '2026-07-31 18:07:22', NULL, 'oss', '2026-07-31', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2083132477441970177', '20831324774419701762071068587175014400_index_preview.png', 367364, '.png', '2026-07-31 18:07:40', NULL, 'oss', '2026-07-31', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2083132527731675137', '20831325277316751362071068587175014400_index_preview.png', 63455, '.png', '2026-07-31 18:07:52', NULL, 'oss', '2026-07-31', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2083132650842886144', '20831326508386918402071069727958593536_index_preview.png', 99099, '.png', '2026-07-31 18:08:21', NULL, 'oss', '2026-07-31', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2083133151173021697', '20831331511730216962071069727958593536_index_preview.png', 99099, '.png', '2026-07-31 18:10:21', NULL, 'oss', '2026-07-31', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2087054962097123329', '20870549620971233282087054914659545088_index_preview.png', 72771, '.png', '2026-08-11 13:54:13', NULL, 'oss', '2026-08-11', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2087054970825469953', '20870549708254699522087054914659545088_index_preview.png', 72771, '.png', '2026-08-11 13:54:15', NULL, 'oss', '2026-08-11', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2088149988982087681', '2088149988982087680pexels-andreea-ch-371539-1166643.jpg', 602824, '.jpg', '2026-08-14 14:25:28', NULL, 'oss', '2026-08-14', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2088150026462388225', '20881500264623882242087054914659545088_index_preview.png', 174066, '.png', '2026-08-14 14:25:37', NULL, 'oss', '2026-08-14', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2088166083856048128', '2088166083851853824device_component_icon_1786692565230.png', 22328, '.png', '2026-08-14 15:29:25', NULL, 'oss', '2026-08-14', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2088166102457786369', '20881661024577863682088165985151492096_index_preview.png', 35731, '.png', '2026-08-14 15:29:30', NULL, 'oss', '2026-08-14', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2088166536526307329', '20881665365263073282087054914659545088_index_background.jpg', 13303, '.jpg', '2026-08-14 15:31:13', NULL, 'oss', '2026-08-14', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2088166616234860545', '20881666162348605442087054914659545088_index_background.png', 22328, '.png', '2026-08-14 15:31:32', NULL, 'oss', '2026-08-14', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2088167236945715201', '20881672369457152002087054914659545088_index_background.jpg', 13303, '.jpg', '2026-08-14 15:34:00', NULL, 'oss', '2026-08-14', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2088167411781083137', '20881674117810831362087054914659545088_index_preview.png', 771662, '.png', '2026-08-14 15:34:42', NULL, 'oss', '2026-08-14', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2088169024721657857', '20881690247216578562087054914659545088_index_preview.png', 588350, '.png', '2026-08-14 15:41:06', NULL, 'oss', '2026-08-14', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2088169058066374656', '20881690580621803522087054914659545088_index_preview.png', 771662, '.png', '2026-08-14 15:41:14', NULL, 'oss', '2026-08-14', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2088470697249185793', '20884706972491857922088470670862819328_index_preview.png', 24543, '.png', '2026-08-15 11:39:51', NULL, 'oss', '2026-08-15', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2088470724780597249', '20884707247805972482088470714982703104_index_preview.png', 24543, '.png', '2026-08-15 11:39:57', NULL, 'oss', '2026-08-15', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2088470755201884161', '20884707552018841602088470741348098048_index_preview.png', 24543, '.png', '2026-08-15 11:40:05', NULL, 'oss', '2026-08-15', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2088484926190624769', '2088484926190624768F4提升改造平面图6.2-1.png', 22328, '.png', '2026-08-15 12:36:23', NULL, 'oss', '2026-08-15', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2088484953151610881', '20884849531516108802088470670862819328_index_preview.png', 230787, '.png', '2026-08-15 12:36:30', NULL, 'oss', '2026-08-15', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2088486099261956097', '20884860992619560962088485930600603648_index_preview.png', 107574, '.png', '2026-08-15 12:41:03', NULL, 'oss', '2026-08-15', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2088487572725145601', '20884875727251456002088485930600603648_index_preview.png', 226070, '.png', '2026-08-15 12:46:54', NULL, 'oss', '2026-08-15', 'D:/upload/');
INSERT INTO `t_sys_file` VALUES ('2088488310318669825', '20884883103186698242088485930600603648_index_preview.png', 226224, '.png', '2026-08-15 12:49:50', NULL, 'oss', '2026-08-15', 'D:/upload/');

-- ----------------------------
-- Table structure for tag_detail
-- ----------------------------
DROP TABLE IF EXISTS `tag_detail`;
CREATE TABLE `tag_detail`  (
  `tag_id` bigint NOT NULL AUTO_INCREMENT COMMENT '标签id',
  `tag_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标签名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标签描述',
  `tag_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`tag_id`) USING BTREE,
  UNIQUE KEY `uk_tag_detail_name` (`tag_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '标签详情' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tag_detail
-- ----------------------------

-- ----------------------------
-- Table structure for thing_property_unit
-- ----------------------------
DROP TABLE IF EXISTS `thing_property_unit`;
CREATE TABLE `thing_property_unit`  (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '单位标识（英文名）',
  `chinese_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '单位中文名称',
  `symbol` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '单位符号',
  `type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '单位分类；例如：电力单位、速度单位',
  `description` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '单位描述',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '设备属性单位表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of thing_property_unit
-- ----------------------------

-- ----------------------------
-- Table structure for transparent_codec
-- ----------------------------
DROP TABLE IF EXISTS `transparent_codec`;
CREATE TABLE `transparent_codec`  (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '解析包名称',
  `provider` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '解析包提供商',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '解析包描述',
  `protocol_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '通信协议名称',
  `file_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '通信包文件地址',
  `configuration` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '协议包编解码配置',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '透传消息解析器' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of transparent_codec
-- ----------------------------

-- ----------------------------
-- Table structure for transport_protocol
-- ----------------------------
DROP TABLE IF EXISTS `transport_protocol`;
CREATE TABLE `transport_protocol`  (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '传输协议名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '协议描述',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '启停状态：enable，disable',
  `configuration` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '传输协议配置',
  `protocol_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '传输协议类型',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '传输协议表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of transport_protocol
-- ----------------------------
INSERT INTO `transport_protocol` VALUES ('bacnet', 'BACnet/IP', '基于 BACnet4J 6.1.1 的 BACnet/IP 边缘采集协议', 'enable', '{\r\n      \"id\": \"bacnet\",\r\n      \"name\": \"BACnet/IP\",\r\n      \"description\": \"基于 BACnet4J 6.1.1 的 BACnet/IP 边缘采集协议\",\r\n      \"connectionProperties\": [\r\n        {\"id\":\"localDeviceInstance\",\"name\":\"本地设备实例\",\"description\":\"本网关的BACnet设备实例，0-4194302且网络内唯一\",\"required\":true,\"valueType\":{\"type\":\"int\"}},\r\n        {\"id\":\"localIp\",\"name\":\"本机IPv4地址\",\"description\":\"可选；多网卡主机建议指定，广播地址和网络前缀自动读取\",\"required\":false,\"valueType\":{\"type\":\"string\"}},\r\n        {\"id\":\"deviceInstances\",\"name\":\"设备实例白名单\",\"description\":\"逗号分隔的远端设备实例；留空发现全部\",\"required\":false,\"valueType\":{\"type\":\"string\"}},\r\n        {\"id\":\"pollingInterval\",\"name\":\"轮询周期(ms)\",\"description\":\"默认5000ms\",\"required\":false,\"valueType\":{\"type\":\"int\"}}\r\n      ],\r\n      \"dataPointProperties\": [\r\n        {\"id\":\"deviceInstance\",\"name\":\"远端设备实例\",\"description\":\"BACnet Device实例，0-4194302\",\"required\":true,\"valueType\":{\"type\":\"int\"}},\r\n        {\"id\":\"objectType\",\"name\":\"对象类型\",\"description\":\"当前驱动支持的BACnet标准对象类型\",\"required\":true,\"valueType\":{\"type\":\"enum\",\"valueType\":{\"type\":\"string\"},\"elements\":[{\"value\":\"analogInput\",\"text\":\"模拟量输入\"},{\"value\":\"analogOutput\",\"text\":\"模拟量输出\"},{\"value\":\"analogValue\",\"text\":\"模拟量值\"},{\"value\":\"binaryInput\",\"text\":\"二进制输入\"},{\"value\":\"binaryOutput\",\"text\":\"二进制输出\"},{\"value\":\"binaryValue\",\"text\":\"二进制值\"},{\"value\":\"multiStateInput\",\"text\":\"多状态输入\"},{\"value\":\"multiStateOutput\",\"text\":\"多状态输出\"},{\"value\":\"multiStateValue\",\"text\":\"多状态值\"},{\"value\":\"accumulator\",\"text\":\"累加器\"},{\"value\":\"pulseConverter\",\"text\":\"脉冲转换器\"},{\"value\":\"integerValue\",\"text\":\"整数值\"},{\"value\":\"positiveIntegerValue\",\"text\":\"正整数值\"},{\"value\":\"largeAnalogValue\",\"text\":\"大模拟量值\"},{\"value\":\"characterstringValue\",\"text\":\"字符串值\"}]}},\r\n        {\"id\":\"objectInstance\",\"name\":\"对象实例\",\"description\":\"BACnet对象实例，0-4194302\",\"required\":true,\"valueType\":{\"type\":\"int\"}},\r\n        {\"id\":\"writePriority\",\"name\":\"写优先级\",\"description\":\"可选，范围1-16，仅写点位使用\",\"required\":false,\"valueType\":{\"type\":\"int\"}}\r\n      ]\r\n    }', 'edge', 'admin', '2026-08-30 22:18:37', 'admin', NULL, 'edge-bacnet PF4J协议插件，协议ID为bacnet');
INSERT INTO `transport_protocol` VALUES ('knx', 'KNXnet/IP', '基于 Calimero 的 KNXnet/IP 边缘采集协议', 'enable', '{\r\n      \"id\": \"knx\",\r\n      \"name\": \"KNXnet/IP\",\r\n      \"description\": \"基于 Calimero 的 KNXnet/IP 边缘采集协议\",\r\n      \"connectionProperties\": [\r\n        {\r\n          \"id\": \"ipAddress\",\r\n          \"name\": \"IP地址\",\r\n          \"description\": \"KNXnet/IP 接口或路由器的 IPv4 地址，例如 192.168.1.20\",\r\n          \"required\": true,\r\n          \"valueType\": {\"type\": \"string\"}\r\n        },\r\n        {\r\n          \"id\": \"port\",\r\n          \"name\": \"连接端口\",\r\n          \"description\": \"KNXnet/IP Tunneling UDP 端口，通常为 3671\",\r\n          \"required\": true,\r\n          \"valueType\": {\"type\": \"int\"}\r\n        }\r\n      ],\r\n      \"dataPointProperties\": [\r\n        {\r\n          \"id\": \"groupAddress\",\r\n          \"name\": \"KNX 组地址\",\r\n          \"description\": \"例如 1/2/3\",\r\n          \"required\": true,\r\n          \"valueType\": {\"type\": \"string\"}\r\n        },\r\n        {\r\n          \"id\": \"dpt\",\r\n          \"name\": \"KNX DPT\",\r\n          \"description\": \"标准 DPT，例如开关 1.001、温度 9.001\",\r\n          \"required\": true,\r\n          \"valueType\": {\"type\": \"string\"}\r\n        }\r\n      ]\r\n    }', 'edge', 'admin', '2026-08-19 17:36:17', 'admin', NULL, 'edge-knx PF4J协议插件，协议ID为knx');
INSERT INTO `transport_protocol` VALUES ('modbus', 'modbus协议', 'modbus', 'enable', '{\r\n  \"id\": \"modbus\",\r\n  \"name\": \"modbus通讯协议\",\r\n  \"connectionProperties\": [\r\n    {\r\n      \"id\": \"ip_address\",\r\n      \"name\": \"ip地址\",\r\n      \"valueType\": {\r\n        \"type\": \"string\"\r\n      }\r\n    },\r\n    {\r\n      \"id\": \"port\",\r\n      \"name\": \"端口\",\r\n      \"valueType\": {\r\n        \"type\": \"int\"\r\n      }\r\n    },\r\n    {\r\n      \"id\": \"timeout\",\r\n      \"name\": \"连接超时时间\",\r\n      \"valueType\": {\r\n        \"type\": \"int\",\r\n        \"unit\": \"ms\"\r\n      }\r\n    },\r\n    {\r\n      \"id\": \"refresh_interval\",\r\n      \"name\": \"数据刷新周期\",\r\n      \"valueType\": {\r\n        \"type\": \"int\",\r\n        \"unit\": \"ms\"\r\n      }\r\n    },\r\n    {\r\n      \"id\": \"slave_id\",\r\n      \"name\": \"从站id\",\r\n      \"valueType\": {\r\n        \"type\": \"int\",\r\n        \"max\": 255,\r\n        \"min\": 0\r\n      }\r\n    }\r\n  ],\r\n  \"dataPointProperties\": [\r\n    {\r\n      \"id\": \"register_type\",\r\n      \"name\": \"寄存器类型\",\r\n      \"valueType\": {\r\n        \"elements\": [\r\n          {\r\n            \"description\": \"控制离散输出设备的开关状态（0或1）\",\r\n            \"text\": \"离散输出寄存器\",\r\n            \"value\": \"coil\"\r\n          },\r\n          {\r\n            \"description\": \"读取输入信号的状态（0或1）\",\r\n            \"text\": \"离散输入寄存器\",\r\n            \"value\": \"discrete\"\r\n          },\r\n          {\r\n            \"description\": \"读取设备的输入数据（如传感器数据）\",\r\n            \"text\": \"输入寄存器\",\r\n            \"value\": \"input\"\r\n          },\r\n          {\r\n            \"description\": \"存储配置信息、控制命令、数据等\",\r\n            \"text\": \"保持寄存器\",\r\n            \"value\": \"holding\"\r\n          }\r\n        ],\r\n        \"type\": \"enum\"\r\n      }\r\n    },\r\n    {\r\n      \"id\": \"offset\",\r\n      \"name\": \"寄存器地址\",\r\n      \"valueType\": {\r\n        \"type\": \"int\"\r\n      }\r\n    },\r\n    {\r\n      \"id\": \"quantity\",\r\n      \"name\": \"寄存器数量\",\r\n      \"valueType\": {\r\n        \"type\": \"int\",\r\n        \"max\": 125,\r\n        \"min\": 1\r\n      }\r\n    }\r\n  ]\r\n}', 'edge', 'admin', '2025-02-12 15:28:07', 'admin', '2025-03-18 18:39:19', 'modbus');
INSERT INTO `transport_protocol` VALUES ('opcua', 'OPC UA', '基于 Eclipse Milo 的 OPC UA 边缘采集协议', 'enable', '{\n  \"id\": \"opcua\",\n  \"name\": \"OPC UA\",\n  \"description\": \"基于 Eclipse Milo 的 OPC UA 边缘采集协议\",\n  \"connectionProperties\": [\n    {\n      \"id\": \"endpoint\",\n      \"name\": \"服务地址\",\n      \"description\": \"OPC UA 服务地址，例如 192.168.1.10:4840\",\n      \"required\": true,\n      \"valueType\": {\n        \"type\": \"string\"\n      }\n    },\n    {\n      \"id\": \"username\",\n      \"name\": \"用户名\",\n      \"description\": \"匿名连接时留空\",\n      \"required\": false,\n      \"valueType\": {\n        \"type\": \"string\"\n      }\n    },\n    {\n      \"id\": \"password\",\n      \"name\": \"密码\",\n      \"description\": \"匿名连接时留空\",\n      \"required\": false,\n      \"valueType\": {\n        \"type\": \"password\"\n      }\n    },\n    {\n      \"id\": \"autoCreatePoints\",\n      \"name\": \"自动创建点位\",\n      \"description\": \"连接后浏览OPC UA变量节点并自动创建点位，默认开启\",\n      \"required\": false,\n      \"valueType\": {\n        \"type\": \"boolean\"\n      }\n    },\n    {\n      \"id\": \"samplingInterval\",\n      \"name\": \"采样周期(ms)\",\n      \"description\": \"监控项采样周期，默认1000ms\",\n      \"required\": false,\n      \"valueType\": {\n        \"type\": \"int\"\n      }\n    },\n    {\n      \"id\": \"publishingInterval\",\n      \"name\": \"发布周期(ms)\",\n      \"description\": \"订阅发布周期，默认1000ms\",\n      \"required\": false,\n      \"valueType\": {\n        \"type\": \"int\"\n      }\n    },\n    {\n      \"id\": \"connectInterval\",\n      \"name\": \"重连检测周期(ms)\",\n      \"description\": \"连接状态检测及重连周期，默认30000ms\",\n      \"required\": false,\n      \"valueType\": {\n        \"type\": \"int\"\n      }\n    },\n    {\n      \"id\": \"requestTimeout\",\n      \"name\": \"请求超时(ms)\",\n      \"description\": \"OPC UA请求超时时间，默认5000ms\",\n      \"required\": false,\n      \"valueType\": {\n        \"type\": \"int\"\n      }\n    }\n  ],\n  \"dataPointProperties\": [\n    {\n      \"id\": \"nodeId\",\n      \"name\": \"NodeId\",\n      \"description\": \"标准 OPC UA NodeId，例如 ns=2;s=Machine/Temperature\",\n      \"required\": true,\n      \"valueType\": {\n        \"type\": \"string\"\n      }\n    },\n    {\n      \"id\": \"browseName\",\n      \"name\": \"浏览名称\",\n      \"description\": \"OPC UA 节点的 BrowseName，例如 Temperature\",\n      \"required\": false,\n      \"valueType\": {\n        \"type\": \"string\"\n      }\n    },\n    {\n      \"id\": \"displayName\",\n      \"name\": \"显示名称\",\n      \"description\": \"OPC UA 节点的本地化显示名称，例如 温度\",\n      \"required\": false,\n      \"valueType\": {\n        \"type\": \"string\"\n      }\n    },\n    {\n      \"id\": \"dataType\",\n      \"name\": \"数据类型\",\n      \"description\": \"OPC UA 数据类型名称，例如 Double\",\n      \"required\": false,\n      \"valueType\": {\n        \"type\": \"string\"\n      }\n    },\n    {\n      \"id\": \"dataTypeNodeId\",\n      \"name\": \"数据类型 NodeId\",\n      \"description\": \"OPC UA 数据类型节点标识，例如 ns=0;i=11\",\n      \"required\": false,\n      \"valueType\": {\n        \"type\": \"string\"\n      }\n    },\n    {\n      \"id\": \"accessLevel\",\n      \"name\": \"访问级别\",\n      \"description\": \"当前用户的 OPC UA 节点访问权限，例如 Read/Write\",\n      \"required\": false,\n      \"valueType\": {\n        \"type\": \"string\"\n      }\n    },\n    {\n      \"id\": \"writable\",\n      \"name\": \"可写\",\n      \"description\": \"当前用户是否具有节点写入权限\",\n      \"required\": false,\n      \"valueType\": {\n        \"type\": \"boolean\"\n      }\n    }\n  ]\n}', 'edge', 'admin', '2026-08-18 22:00:45', 'admin', NULL, 'edge-opcua PF4J协议插件，协议ID为opcua');
INSERT INTO `transport_protocol` VALUES ('plc4x', 'PLC4X通讯协议', 'Apache PLC4X 通讯协议', 'enable', '{\r\n  \"id\": \"plc4x\",\r\n  \"name\": \"Apache PLC4X 通讯协议\",\r\n  \"connectionProperties\": [\r\n    {\r\n      \"id\": \"connection_string\",\r\n      \"name\": \"连接地址\",\r\n      \"description\": \"PLC4X 原生连接字符串，例如 s7://192.168.1.10、modbus-tcp://192.168.1.10:502\",\r\n      \"valueType\": {\r\n        \"type\": \"string\"\r\n      }\r\n    },\r\n    {\r\n      \"id\": \"request_timeout\",\r\n      \"name\": \"超时时间\",\r\n      \"valueType\": {\r\n        \"type\": \"int\",\r\n        \"unit\": \"ms\",\r\n        \"min\": 1\r\n      }\r\n    },\r\n    {\r\n      \"id\": \"refresh_interval\",\r\n      \"name\": \"周期\",\r\n      \"description\": \"订阅类型为 cyclic 时作为默认订阅周期；不支持订阅时作为轮询刷新周期\",\r\n      \"valueType\": {\r\n        \"type\": \"int\",\r\n        \"unit\": \"ms\",\r\n        \"min\": 1\r\n      }\r\n    },\r\n    {\r\n      \"id\": \"connect_interval\",\r\n      \"name\": \"重连检测\",\r\n      \"valueType\": {\r\n        \"type\": \"int\",\r\n        \"unit\": \"ms\",\r\n        \"min\": 1\r\n      }\r\n    },\r\n    {\r\n      \"id\": \"prefer_subscription\",\r\n      \"name\": \"优先订阅\",\r\n      \"description\": \"连接支持订阅时优先使用 PLC4X 订阅模式\",\r\n      \"valueType\": {\r\n        \"type\": \"boolean\"\r\n      }\r\n    },\r\n    {\r\n      \"id\": \"fallback_to_polling\",\r\n      \"name\": \"订阅失败回退轮询\",\r\n      \"description\": \"驱动不支持订阅或订阅建立失败时，自动回退到读取刷新\",\r\n      \"valueType\": {\r\n        \"type\": \"boolean\"\r\n      }\r\n    }\r\n  ],\r\n  \"dataPointProperties\": [\r\n    {\r\n      \"id\": \"tag_address\",\r\n      \"name\": \"标签地址\",\r\n      \"description\": \"PLC4X 原生 Tag Address，按具体 driver 的地址语法填写\",\r\n      \"valueType\": {\r\n        \"type\": \"string\"\r\n      }\r\n    },\r\n    {\r\n      \"id\": \"subscription_type\",\r\n      \"name\": \"订阅类型\",\r\n      \"description\": \"仅在连接支持订阅且 prefer_subscription=true 时生效\",\r\n      \"valueType\": {\r\n        \"elements\": [\r\n          {\r\n            \"description\": \"按固定周期接收点位值，适合大多数 PLC4X 驱动\",\r\n            \"text\": \"周期订阅\",\r\n            \"value\": \"cyclic\"\r\n          },\r\n          {\r\n            \"description\": \"点位状态变化时接收事件，需具体 PLC4X driver 支持\",\r\n            \"text\": \"变化订阅\",\r\n            \"value\": \"change\"\r\n          },\r\n          {\r\n            \"description\": \"接收设备事件，需具体 PLC4X driver 支持\",\r\n            \"text\": \"事件订阅\",\r\n            \"value\": \"event\"\r\n          }\r\n        ],\r\n        \"type\": \"enum\"\r\n      }\r\n    },\r\n    {\r\n      \"id\": \"subscription_interval\",\r\n      \"name\": \"订阅周期\",\r\n      \"description\": \"subscription_type=cyclic 时生效；为空时使用网关 refresh_interval\",\r\n      \"valueType\": {\r\n        \"type\": \"int\",\r\n        \"unit\": \"ms\",\r\n        \"min\": 1\r\n      }\r\n    }\r\n  ]\r\n}\r\n', 'edge', 'admin', '2026-07-09 22:13:52', 'admin', '2026-07-09 22:13:57', 'Apache PLC4X');

-- ----------------------------
-- Table structure for unit
-- ----------------------------
DROP TABLE IF EXISTS `unit`;
CREATE TABLE `unit`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '单位名称，如 千克',
  `symbol` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '单位符号，如 kg',
  `category_id` bigint NOT NULL COMMENT '所属单位分类',
  `conversion_factor` decimal(32, 16) NOT NULL DEFAULT 1.0000000000000000 COMMENT '相对于主单位的换算因子',
  `is_base_unit` tinyint(1) NULL DEFAULT 0 COMMENT '是否为主单位',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '说明，如 kg是质量主单位',
  `created_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `symbol`(`symbol` ASC, `category_id` ASC) USING BTREE,
  INDEX `fk_unit_category`(`category_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 74 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '单位信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of unit
-- ----------------------------
INSERT INTO `unit` VALUES (1, '百分比', '%', 1, 1.0000000000000000, 1, '百分比(%)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (2, '次', 'count', 1, 1.0000000000000000, 0, '次', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (3, '转每分钟', 'r/min', 1, 1.0000000000000000, 0, '转每分钟', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (4, '纳米', 'nm', 2, 0.0000000010000000, 0, '长度单位:纳米(nm)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (5, '微米', 'μm', 2, 0.0000010000000000, 0, '长度单位:微米(μm)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (6, '毫米', 'mm', 2, 0.0010000000000000, 0, '长度单位:毫米(mm)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (7, '厘米', 'cm', 2, 0.0100000000000000, 0, '长度单位:厘米(cm)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (8, '米', 'm', 2, 1.0000000000000000, 1, '长度单位:米(m)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (9, '千米', 'km', 2, 1000.0000000000000000, 0, '长度单位:千米(km)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (10, '平方毫米', 'mm²', 3, 0.0000010000000000, 0, '面积单位:平方毫米(mm²)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (11, '平方厘米', 'cm²', 3, 0.0001000000000000, 0, '面积单位:平方厘米(cm²)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (12, '平方米', 'm²', 3, 1.0000000000000000, 1, '面积单位:平方米(m²)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (13, '平方千米', 'km²', 3, 1000000.0000000000000000, 0, '面积单位:平方千米(km²)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (14, '公顷', 'hm²', 3, 10000.0000000000000000, 0, '面积单位:公顷(hm²)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (15, '天', 'd', 4, 86400.0000000000000000, 0, '时间单位:天(d)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (16, '小时', 'h', 4, 3600.0000000000000000, 0, '时间单位:小时(h)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (17, '分钟', 'min', 4, 60.0000000000000000, 0, '时间单位:分钟(min)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (18, '秒', 's', 4, 1.0000000000000000, 1, '时间单位:秒(s)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (19, '毫秒', 'ms', 4, 0.0010000000000000, 0, '时间单位:毫秒(ms)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (20, '微秒', 'μs', 4, 0.0000010000000000, 0, '时间单位:微秒(μs)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (21, '纳秒', 'ns', 4, 0.0000000010000000, 0, '时间单位:纳秒(ns)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (22, '立方毫米', 'mm³', 5, 0.0000000010000000, 0, '体积单位:立方毫米(mm³)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (23, '立方厘米', 'cm³', 5, 0.0000010000000000, 0, '体积单位:立方厘米(cm³)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (24, '立方米', 'm³', 5, 1.0000000000000000, 1, '体积单位:立方米(m³)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (25, '立方千米', 'km³', 5, 1000000000000.0000000000000000, 0, '体积单位:立方千米(km³)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (26, '立方米每秒', 'm³/s', 6, 1.0000000000000000, 1, '流量单位:立方米每秒(m³/s)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (27, '立方千米每秒', 'km³/s', 6, 1000000000000.0000000000000000, 0, '流量单位:立方千米每秒(km³/s)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (28, '立方厘米每秒', 'cm³/s', 6, 0.0000010000000000, 0, '流量单位:立方厘米每秒(cm³/s)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (29, '升每秒', 'l/s', 6, 0.0010000000000000, 0, '流量单位:升每秒(l/s)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (30, '立方米每小时', 'm³/h', 6, 0.0002777778000000, 0, '流量单位:立方米每小时(m³/h)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (31, '立方千米每小时', 'km³/h', 6, 277777777.8000000000000000, 0, '流量单位:立方千米每小时(km³/h)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (32, '立方厘米每小时', 'cm³/h', 6, 0.0000000002777800, 0, '流量单位:立方厘米每小时(cm³/h)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (33, '升每小时', 'l/h', 6, 0.0000002777800000, 0, '流量单位:升每小时(l/h)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (34, '毫升', 'mL', 7, 0.0010000000000000, 0, '容积单位:毫升(mL)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (35, '升', 'L', 7, 1.0000000000000000, 1, '容积单位:升(L)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (36, '毫克', 'mg', 8, 0.0000010000000000, 0, '质量单位:毫克(mg)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (37, '克', 'g', 8, 0.0010000000000000, 0, '质量单位:克(g)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (38, '千克', 'kg', 8, 1.0000000000000000, 1, '质量单位:千克(kg)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (39, '吨', 't', 8, 1000.0000000000000000, 0, '质量单位:吨(t)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (40, '帕斯卡', 'Pa', 9, 1.0000000000000000, 1, '压力单位:帕斯卡(Pa)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (41, '千帕斯卡', 'kPa', 9, 1000.0000000000000000, 0, '压力单位:千帕斯卡(kPa)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (42, '牛顿', 'N', 10, 1.0000000000000000, 1, '力单位:牛顿(N)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (43, '牛·米', 'N.m', 10, 1.0000000000000000, 0, '力单位:牛·米(N.m)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (44, '开尔文', 'K', 11, 1.0000000000000000, 1, '温度单位:开尔文(K)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (45, '摄氏度', '℃', 11, 1.0000000000000000, 0, '温度单位:摄氏度(℃)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (46, '华氏度', '℉', 11, 1.8000000000000000, 0, '温度单位:华氏度(℉)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (47, '焦耳', 'J', 12, 1.0000000000000000, 1, '能量单位:焦耳(J)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (48, '卡', 'cal', 12, 4.1840000000000000, 0, '能量单位:卡(cal)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (49, '瓦特', 'W', 13, 1.0000000000000000, 1, '功率单位:瓦特(W)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (50, '千瓦特', 'kW', 13, 1000.0000000000000000, 0, '功率单位:千瓦特(kW)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (51, '弧度', 'rad', 14, 1.0000000000000000, 1, '角度单位:弧度(rad)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (52, '度', '°', 14, 0.0174533000000000, 0, '角度单位:度(°)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (53, '[角]分', '′', 14, 0.0002908880000000, 0, '角度单位:分(′)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (54, '[角]秒', '″', 14, 0.0000048480000000, 0, '角度单位:秒(″)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (55, '赫兹', 'Hz', 15, 1.0000000000000000, 1, '频率单位:赫兹(Hz)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (56, '兆赫兹', 'MHz', 15, 1000000.0000000000000000, 0, '频率单位:兆赫兹(MHz)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (57, 'G赫兹', 'GHz', 15, 1000000000.0000000000000000, 0, '频率单位:G赫兹(GHz)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (58, '米每秒', 'm/s', 16, 1.0000000000000000, 1, '速度单位:米每秒(m/s)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (59, '千米每小时', 'km/h', 16, 0.2777780000000000, 0, '速度单位:千米每小时(km/h)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (60, '节', 'kn', 16, 0.5144440000000000, 0, '速度单位:节(kn)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (61, '伏特', 'V', 17, 1.0000000000000000, 1, '电压:伏特(V)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (62, '千伏', 'kV', 17, 1000.0000000000000000, 0, '电压:千伏(kV)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (63, '毫伏', 'mV', 17, 0.0010000000000000, 0, '电压:毫伏(mV)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (64, '微伏', 'μV', 17, 0.0000010000000000, 0, '电压:微伏(μV)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (65, '安培', 'A', 17, 1.0000000000000000, 1, '电流:安培(A)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (66, '毫安', 'mA', 17, 0.0010000000000000, 0, '电流:毫安(mA)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (67, '微安', 'μA', 17, 0.0000010000000000, 0, '电流:微安(μA)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (68, '纳安', 'nA', 17, 0.0000000010000000, 0, '电流:纳安(nA)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (69, '欧姆', 'Ω', 17, 1.0000000000000000, 1, '电阻:欧姆(Ω)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (70, '千欧', 'KΩ', 17, 1000.0000000000000000, 0, '电阻:千欧(KΩ)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (71, '兆欧', 'MΩ', 17, 1000000.0000000000000000, 0, '电阻:兆欧(MΩ)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (72, '电子伏', 'eV', 17, 0.0000000000000000, 0, '能量:电子伏(eV)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');
INSERT INTO `unit` VALUES (73, '千瓦·时', 'kW·h', 17, 3600000.0000000000000000, 0, '能量:千瓦·时(kW·h)', '2025-07-31 19:57:50', '2025-07-31 19:57:50');

-- ----------------------------
-- Table structure for unit_category
-- ----------------------------
DROP TABLE IF EXISTS `unit_category`;
CREATE TABLE `unit_category`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类编码，如 mass, energy',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类名称，如 质量, 能源',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `created_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '单位类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of unit_category
-- ----------------------------
INSERT INTO `unit_category` VALUES (1, 'common', '常用单位', '百分比、计数、转速等常用单位', '2025-07-31 19:51:22', '2025-07-31 19:51:22');
INSERT INTO `unit_category` VALUES (2, 'length', '长度单位', '用于表示长度的计量单位，如米、千米', '2025-07-31 19:51:22', '2025-07-31 19:51:22');
INSERT INTO `unit_category` VALUES (3, 'area', '面积单位', '用于表示面积的计量单位，如平方米、公顷', '2025-07-31 19:51:22', '2025-07-31 19:51:22');
INSERT INTO `unit_category` VALUES (4, 'time', '时间单位', '用于表示时间的计量单位，如秒、分钟、小时', '2025-07-31 19:51:22', '2025-07-31 19:51:22');
INSERT INTO `unit_category` VALUES (5, 'volume', '体积单位', '用于表示体积的计量单位，如立方米、立方厘米', '2025-07-31 19:51:22', '2025-07-31 19:51:22');
INSERT INTO `unit_category` VALUES (6, 'flow', '流量单位', '用于表示流量的计量单位，如立方米每秒、升每小时', '2025-07-31 19:51:22', '2025-07-31 19:51:22');
INSERT INTO `unit_category` VALUES (7, 'capacity', '容积单位', '用于表示容积的计量单位，如升、毫升', '2025-07-31 19:51:22', '2025-07-31 19:51:22');
INSERT INTO `unit_category` VALUES (8, 'mass', '质量单位', '用于表示质量的计量单位，如千克、吨', '2025-07-31 19:51:22', '2025-07-31 19:51:22');
INSERT INTO `unit_category` VALUES (9, 'pressure', '压力单位', '用于表示压力的计量单位，如帕斯卡、千帕斯卡', '2025-07-31 19:51:22', '2025-07-31 19:51:22');
INSERT INTO `unit_category` VALUES (10, 'force', '力单位', '用于表示力的计量单位，如牛顿、牛·米', '2025-07-31 19:51:22', '2025-07-31 19:51:22');
INSERT INTO `unit_category` VALUES (11, 'temperature', '温度单位', '用于表示温度的计量单位，如摄氏度、开尔文', '2025-07-31 19:51:22', '2025-07-31 19:51:22');
INSERT INTO `unit_category` VALUES (12, 'energy', '能量单位', '用于表示能量的计量单位，如焦耳、卡', '2025-07-31 19:51:22', '2025-07-31 19:51:22');
INSERT INTO `unit_category` VALUES (13, 'power', '功率单位', '用于表示功率的计量单位，如瓦特、千瓦', '2025-07-31 19:51:22', '2025-07-31 19:51:22');
INSERT INTO `unit_category` VALUES (14, 'angle', '角度单位', '用于表示角度的计量单位，如弧度、度', '2025-07-31 19:51:22', '2025-07-31 19:51:22');
INSERT INTO `unit_category` VALUES (15, 'frequency', '频率单位', '用于表示频率的计量单位，如赫兹、兆赫兹', '2025-07-31 19:51:22', '2025-07-31 19:51:22');
INSERT INTO `unit_category` VALUES (16, 'speed', '速度单位', '用于表示速度的计量单位，如米每秒、千米每小时', '2025-07-31 19:51:22', '2025-07-31 19:51:22');
INSERT INTO `unit_category` VALUES (17, 'electricity', '电力单位', '用于表示电学相关的单位，如伏特、安培、欧姆', '2025-07-31 19:51:22', '2025-07-31 19:51:22');

SET FOREIGN_KEY_CHECKS = 1;
