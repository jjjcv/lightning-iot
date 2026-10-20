package com.ruoyi.iot.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.iot.mapper.AlarmLogMapper;
import com.ruoyi.iot.domain.AlarmLog;
import com.ruoyi.iot.service.IAlarmLogService;

/**
 * 告警记录Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-09-10
 */
@Service
public class AlarmLogServiceImpl implements IAlarmLogService 
{
    @Autowired
    private AlarmLogMapper alarmLogMapper;

    /**
     * 查询告警记录
     * 
     * @param id 告警记录主键
     * @return 告警记录
     */
    @Override
    public AlarmLog selectAlarmLogById(Long id)
    {
        return alarmLogMapper.selectAlarmLogById(id);
    }

    /**
     * 查询告警记录列表
     * 
     * @param alarmLog 告警记录
     * @return 告警记录
     */
    @Override
    public List<AlarmLog> selectAlarmLogList(AlarmLog alarmLog)
    {
        return alarmLogMapper.selectAlarmLogList(alarmLog);
    }

    /**
     * 新增告警记录
     * 
     * @param alarmLog 告警记录
     * @return 结果
     */
    @Override
    public int insertAlarmLog(AlarmLog alarmLog)
    {
        alarmLog.setCreateTime(DateUtils.getNowDate());
        return alarmLogMapper.insertAlarmLog(alarmLog);
    }

    /**
     * 修改告警记录
     * 
     * @param alarmLog 告警记录
     * @return 结果
     */
    @Override
    public int updateAlarmLog(AlarmLog alarmLog)
    {
        return alarmLogMapper.updateAlarmLog(alarmLog);
    }

    /**
     * 批量删除告警记录
     * 
     * @param ids 需要删除的告警记录主键
     * @return 结果
     */
    @Override
    public int deleteAlarmLogByIds(Long[] ids)
    {
        return alarmLogMapper.deleteAlarmLogByIds(ids);
    }

    /**
     * 删除告警记录信息
     * 
     * @param id 告警记录主键
     * @return 结果
     */
    @Override
    public int deleteAlarmLogById(Long id)
    {
        return alarmLogMapper.deleteAlarmLogById(id);
    }
}
