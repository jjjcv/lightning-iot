# 设备分组批量属性下置 API

> 适用模块：`lightning-iot`  
> 控制器：`com.ruoyi.iot.controller.DevicesController`  
> 基础路径：`/iot/devices`  
> 接口权限：`iot:devices:edit`

## 1. 概述

设备分组批量属性下置接口用于向指定产品、指定设备分组中的设备下置同一个属性值。

选择父分组时，接口会递归包含该分组自身及其所有层级的子分组；选择子分组时只处理该子树，不会处理其父分组、兄弟分组或其他旁系分组。

接口按设备逐台执行下置。单台设备下置失败不会中断整个批次，响应中会返回成功数量以及每台失败设备的失败原因。

## 2. 鉴权

调用接口需要用户已登录，并拥有以下权限：

```text
iot:devices:edit
```

请求按照系统现有认证方式携带访问令牌：

```http
Authorization: Bearer <access-token>
```

## 3. 接口定义

```http
POST /iot/devices/write/batch
Content-Type: application/json
```

### 3.1 请求参数

| 参数 | 类型 | 必填 | 说明 |
|---|---|:---:|---|
| `productId` | string | 是 | 产品 ID，用于限定待下置设备所属产品；不能为空字符串 |
| `groupId` | long | 是 | 设备分组 ID；接口会包含该分组及其全部后代分组 |
| `telemetryKey` | string | 是 | 物模型属性标识，与设备属性绑定中的 `telemetryKey` 一致；不能为空字符串 |
| `value` | string | 是 | 下置值。底层边缘适配器根据点位配置解析具体数据类型 |

请求示例：

```json
{
  "productId": "product-1",
  "groupId": 100,
  "telemetryKey": "switch",
  "value": "1"
}
```

cURL 示例：

```bash
curl -X POST "http://localhost:8080/iot/devices/write/batch" \
  -H "Authorization: Bearer <access-token>" \
  -H "Content-Type: application/json" \
  -d '{
    "productId": "product-1",
    "groupId": 100,
    "telemetryKey": "switch",
    "value": "1"
  }'
```

## 4. 分组与设备匹配规则

假设设备分组关系如下：

```text
100 生产车间
├── 110 一号产线
│   └── 111 一号产线包装区
└── 120 二号产线

200 仓库
```

当请求中的 `groupId=100` 时，匹配分组为：

```json
[100, 110, 120, 111]
```

当请求中的 `groupId=110` 时，仅匹配：

```json
[110, 111]
```

最终待下置设备需要同时满足：

1. 设备的 `product_id` 等于请求中的 `productId`；
2. 设备的 `group_id` 位于所选分组及其后代分组集合中。

未分组设备、其他产品的设备以及父级或旁系分组中的设备不会被处理。当前接口不额外按照设备启停状态、在线状态或分组状态过滤；不支持写入或网关离线的设备会记录在失败明细中。

## 5. 响应格式

接口统一返回 `AjaxResult`：

```json
{
  "code": 200,
  "msg": "批量下置成功",
  "data": {
    "productId": "product-1",
    "groupId": 100,
    "telemetryKey": "switch",
    "matchedGroupIds": [100, 110, 120, 111],
    "totalCount": 3,
    "successCount": 3,
    "failureCount": 0,
    "failures": []
  }
}
```

### 5.1 `AjaxResult` 字段

| 字段 | 类型 | 说明 |
|---|---|---|
| `code` | integer | 业务状态码：`200`=全部成功，`601`=警告或部分成功，`500`=业务失败 |
| `msg` | string | 批量下置结果说明 |
| `data` | object | 批量下置汇总；参数校验失败或分组不存在时可能缺省 |

### 5.2 `data` 字段

| 字段 | 类型 | 说明 |
|---|---|---|
| `productId` | string | 请求中的产品 ID |
| `groupId` | long | 请求中的根分组 ID |
| `telemetryKey` | string | 请求中的属性标识 |
| `matchedGroupIds` | long[] | 实际参与匹配的根分组及后代分组 ID；数组顺序不表示业务优先级 |
| `totalCount` | integer | 同时满足产品和分组条件的设备总数 |
| `successCount` | integer | 下置成功的设备数量 |
| `failureCount` | integer | 下置失败的设备数量 |
| `failures` | object[] | 失败设备明细；全部成功时为空数组 |

### 5.3 `failures` 字段

| 字段 | 类型 | 说明 |
|---|---|---|
| `deviceId` | string | 失败设备 ID |
| `deviceName` | string | 失败设备名称 |
| `message` | string | 边缘适配器返回的失败原因或调用异常信息 |

## 6. 响应示例

### 6.1 全部成功

```json
{
  "code": 200,
  "msg": "批量下置成功",
  "data": {
    "productId": "product-1",
    "groupId": 100,
    "telemetryKey": "switch",
    "matchedGroupIds": [100, 110, 120, 111],
    "totalCount": 3,
    "successCount": 3,
    "failureCount": 0,
    "failures": []
  }
}
```

### 6.2 部分成功

```json
{
  "code": 601,
  "msg": "批量下置部分成功",
  "data": {
    "productId": "product-1",
    "groupId": 100,
    "telemetryKey": "switch",
    "matchedGroupIds": [100, 110, 120, 111],
    "totalCount": 3,
    "successCount": 2,
    "failureCount": 1,
    "failures": [
      {
        "deviceId": "device-3",
        "deviceName": "包装机-03",
        "message": "边缘网关未连接"
      }
    ]
  }
}
```

### 6.3 全部失败

```json
{
  "code": 500,
  "msg": "批量下置失败",
  "data": {
    "productId": "product-1",
    "groupId": 100,
    "telemetryKey": "switch",
    "matchedGroupIds": [100, 110, 120, 111],
    "totalCount": 2,
    "successCount": 0,
    "failureCount": 2,
    "failures": [
      {
        "deviceId": "device-1",
        "deviceName": "包装机-01",
        "message": "未找到设备属性绑定"
      },
      {
        "deviceId": "device-2",
        "deviceName": "包装机-02",
        "message": "边缘网关未连接"
      }
    ]
  }
}
```

### 6.4 没有匹配设备

```json
{
  "code": 601,
  "msg": "所选产品和分组下没有可下置的设备",
  "data": {
    "productId": "product-1",
    "groupId": 100,
    "telemetryKey": "switch",
    "matchedGroupIds": [100, 110, 120, 111],
    "totalCount": 0,
    "successCount": 0,
    "failureCount": 0,
    "failures": []
  }
}
```

## 7. 参数与业务错误

| 场景 | `code` | `msg` 示例 |
|---|---:|---|
| `productId` 缺失或为空 | 500 | `产品ID不能为空` |
| `groupId` 缺失 | 500 | `设备分组ID不能为空` |
| `telemetryKey` 缺失或为空 | 500 | `属性标识不能为空` |
| `value` 缺失或为 `null` | 500 | `下置值不能为空` |
| 分组不存在 | 500 | `设备分组不存在：100` |
| 设备没有对应属性绑定 | 记录到失败明细 | `未找到设备属性绑定` |
| 边缘网关或点位写入失败 | 记录到失败明细 | 以边缘适配器返回信息为准 |

> `value` 是字符串类型，可以传空字符串，但不能省略或传 `null`。是否允许空字符串以及值域是否合法，由具体边缘协议和点位配置决定。

## 8. 调用注意事项

- `telemetryKey` 必须已经在每台目标设备上建立属性绑定，否则该设备下置失败。
- 批次不会执行数据库事务回滚。已经成功写入边缘设备的值不会因为其他设备失败而撤销。
- 接口会逐台汇总执行结果，调用方应同时检查 `code`、`successCount`、`failureCount` 和 `failures`，不能只判断 HTTP 请求是否成功。
- 大分组可能包含较多设备，客户端超时时间应覆盖整个批量执行过程，并避免对同一分组高频重复提交。
