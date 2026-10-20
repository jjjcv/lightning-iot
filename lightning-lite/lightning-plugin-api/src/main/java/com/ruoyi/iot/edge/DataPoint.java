package com.ruoyi.iot.edge;

import com.ruoyi.iot.metadata.DataType;
import lombok.Builder;
import lombok.Data;

import java.util.Date;

@Data
@Builder
public class DataPoint implements Cloneable {


    private String id;

    private String name;

    private DataType type;

    private String config;

    private Object value;

    private Object oldValue;

    private Date lastTime;

    /**
     * 更新点位值。
     *
     * <p>同步以保证 oldValue/value 这一对字段的写入对其它线程可见且原子，
     * 避免在响应式刷新线程写入、发布线程读取时出现可见性或撕裂问题。
     */
    public synchronized void updateValue(Object value){
        this.oldValue = this.value;
        this.value = value;
    }

    /**
     * 取一份一致的快照。
     *
     * <p>与 {@link #updateValue(Object)} 加同一把锁，确保克隆时读到的是
     * value/oldValue/lastTime 的一致组合，而非更新过程中的中间状态。
     */
    @Override
    public synchronized DataPoint clone() {
        return new DataPoint(this.id, this.name, this.type, this.config, this.value, this.oldValue, this.lastTime);
    }
}
