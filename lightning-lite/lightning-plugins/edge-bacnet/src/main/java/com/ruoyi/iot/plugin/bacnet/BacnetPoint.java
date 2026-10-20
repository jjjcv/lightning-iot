package com.ruoyi.iot.plugin.bacnet;

import com.serotonin.bacnet4j.type.enumerated.ObjectType;
import com.serotonin.bacnet4j.type.enumerated.PropertyIdentifier;
import com.serotonin.bacnet4j.type.primitive.ObjectIdentifier;

/** 单个 BACnet Present Value 点位的精简配置。 */
public class BacnetPoint {

    private String id;
    private int deviceInstance = -1;
    private String objectType;
    private int objectInstance = -1;
    private Integer writePriority;

    private transient ObjectIdentifier parsedObjectIdentifier;

    public void validateAndPrepare() {
        validateInstance(deviceInstance, "deviceInstance");
        if (objectType == null || objectType.isBlank()) {
            throw new IllegalArgumentException("objectType 不能为空");
        }
        validateInstance(objectInstance, "objectInstance");
        parsedObjectIdentifier = new ObjectIdentifier(parseObjectType(objectType.trim()), objectInstance);

        if (writePriority != null && (writePriority < 1 || writePriority > 16)) {
            throw new IllegalArgumentException("writePriority 必须在 1 到 16 之间");
        }
    }

    private static ObjectType parseObjectType(String value) {
        return switch (value) {
            case "analogInput" -> ObjectType.analogInput;
            case "analogOutput" -> ObjectType.analogOutput;
            case "analogValue" -> ObjectType.analogValue;
            case "binaryInput" -> ObjectType.binaryInput;
            case "binaryOutput" -> ObjectType.binaryOutput;
            case "binaryValue" -> ObjectType.binaryValue;
            case "multiStateInput" -> ObjectType.multiStateInput;
            case "multiStateOutput" -> ObjectType.multiStateOutput;
            case "multiStateValue" -> ObjectType.multiStateValue;
            case "accumulator" -> ObjectType.accumulator;
            case "pulseConverter" -> ObjectType.pulseConverter;
            case "integerValue" -> ObjectType.integerValue;
            case "positiveIntegerValue" -> ObjectType.positiveIntegerValue;
            case "largeAnalogValue" -> ObjectType.largeAnalogValue;
            case "characterstringValue" -> ObjectType.characterstringValue;
            default -> throw new IllegalArgumentException("objectType 不受支持：" + value);
        };
    }

    private static void validateInstance(int value, String name) {
        if (value < 0 || value >= ObjectIdentifier.UNINITIALIZED) {
            throw new IllegalArgumentException(name + " 必须在 0 到 4194302 之间");
        }
    }

    public String stableKey() {
        return deviceInstance + "/" + objectType.trim() + "/"
                + objectInstance + "/presentValue";
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public int getDeviceInstance() { return deviceInstance; }
    public void setDeviceInstance(int deviceInstance) { this.deviceInstance = deviceInstance; }
    public String getObjectType() { return objectType; }
    public void setObjectType(String objectType) { this.objectType = objectType; }
    public int getObjectInstance() { return objectInstance; }
    public void setObjectInstance(int objectInstance) { this.objectInstance = objectInstance; }
    public Integer getWritePriority() { return writePriority; }
    public void setWritePriority(Integer writePriority) { this.writePriority = writePriority; }
    public ObjectIdentifier getParsedObjectIdentifier() { return parsedObjectIdentifier; }
    public PropertyIdentifier getParsedPropertyIdentifier() { return PropertyIdentifier.presentValue; }
}
