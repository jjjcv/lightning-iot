package com.ruoyi.iot.metadata.types;


import com.ruoyi.iot.metadata.unit.ValueUnit;

public interface UnitSupported {
    ValueUnit getUnit();

    void setUnit(ValueUnit unit);
}
