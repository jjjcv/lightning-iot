package com.ruoyi.iot.controller;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.iot.domain.AlarmLog;
import com.ruoyi.iot.service.IAlarmLogService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 告警记录Controller
 * 
 * @author ruoyi
 * @date 2025-09-10
 */
@RestController
@RequestMapping("/iot/alarmLog")
public class AlarmLogController extends BaseController
{
    @Autowired
    private IAlarmLogService alarmLogService;

    /**
     * 查询告警记录列表
     */
    @PreAuthorize("@ss.hasPermi('iot:alarmLog:list')")
    @GetMapping("/list")
    public TableDataInfo list(AlarmLog alarmLog)
    {
        startPage();
        List<AlarmLog> list = alarmLogService.selectAlarmLogList(alarmLog);
        return getDataTable(list);
    }

    /**
     * 导出告警记录列表
     */
    @PreAuthorize("@ss.hasPermi('iot:alarmLog:export')")
    @Log(title = "告警记录", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, AlarmLog alarmLog)
    {
        List<AlarmLog> list = alarmLogService.selectAlarmLogList(alarmLog);
        ExcelUtil<AlarmLog> util = new ExcelUtil<AlarmLog>(AlarmLog.class);
        util.exportExcel(response, list, "告警记录数据");
    }

    /**
     * 获取告警记录详细信息
     */
    @PreAuthorize("@ss.hasPermi('iot:alarmLog:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(alarmLogService.selectAlarmLogById(id));
    }

    /**
     * 新增告警记录
     */
    @PreAuthorize("@ss.hasPermi('iot:alarmLog:add')")
    @Log(title = "告警记录", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody AlarmLog alarmLog)
    {
        return toAjax(alarmLogService.insertAlarmLog(alarmLog));
    }

    /**
     * 修改告警记录
     */
    @PreAuthorize("@ss.hasPermi('iot:alarmLog:edit')")
    @Log(title = "告警记录", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody AlarmLog alarmLog)
    {
        return toAjax(alarmLogService.updateAlarmLog(alarmLog));
    }

    /**
     * 删除告警记录
     */
    @PreAuthorize("@ss.hasPermi('iot:alarmLog:remove')")
    @Log(title = "告警记录", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(alarmLogService.deleteAlarmLogByIds(ids));
    }
}
