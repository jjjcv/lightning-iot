package com.ruoyi.iot.controller;

import java.util.List;
import io.swagger.v3.oas.annotations.Operation;
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
import com.ruoyi.iot.domain.TagDetail;
import com.ruoyi.iot.service.ITagDetailService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 标签详情Controller
 * 
 * @author ruoyi
 * @date 2025-10-23
 */
@RestController
@RequestMapping("/iot/tagDetail")
public class TagDetailController extends BaseController
{
    @Autowired
    private ITagDetailService tagDetailService;



    @Operation(summary = "按标签统计设备连接状态", description = "统计单个标签直接关联的设备总数、在线数、离线数；连接状态使用 Redis 实时状态，无状态记录按离线处理")
    @PreAuthorize("@ss.hasAnyPermi('iot:tagDetail:list,iot:devices:list')")
    @GetMapping("/{tagId}/deviceStatistics")
    public AjaxResult deviceStatistics(@PathVariable("tagId") Long tagId) {
        return success(tagDetailService.selectDeviceStatisticsByTagId(tagId));
    }

    /**
     * 查询标签详情列表
     */
    @PreAuthorize("@ss.hasAnyPermi('iot:tagDetail:list,iot:products:list,iot:products:add,iot:products:edit,iot:devices:list,iot:devices:add,iot:devices:edit')")
    @GetMapping("/list/all")
    public AjaxResult listAll(TagDetail tagDetail)
    {
        List<TagDetail> list = tagDetailService.selectTagDetailList(tagDetail);
        return success(list);
    }

    /**
     * 查询标签详情列表
     */
    @PreAuthorize("@ss.hasPermi('iot:tagDetail:list')")
    @GetMapping("/list")
    public TableDataInfo list(TagDetail tagDetail)
    {
        startPage();
        List<TagDetail> list = tagDetailService.selectTagDetailList(tagDetail);
        return getDataTable(list);
    }

    /**
     * 导出标签详情列表
     */
    @PreAuthorize("@ss.hasPermi('iot:tagDetail:export')")
    @Log(title = "标签详情", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, TagDetail tagDetail)
    {
        List<TagDetail> list = tagDetailService.selectTagDetailList(tagDetail);
        ExcelUtil<TagDetail> util = new ExcelUtil<TagDetail>(TagDetail.class);
        util.exportExcel(response, list, "标签详情数据");
    }

    /**
     * 获取标签详情详细信息
     */
    @PreAuthorize("@ss.hasPermi('iot:tagDetail:query')")
    @GetMapping(value = "/{tagId}")
    public AjaxResult getInfo(@PathVariable("tagId") Long tagId)
    {
        return success(tagDetailService.selectTagDetailByTagId(tagId));
    }

    /**
     * 新增标签详情
     */
    @PreAuthorize("@ss.hasPermi('iot:tagDetail:add')")
    @Log(title = "标签详情", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody TagDetail tagDetail)
    {
        return toAjax(tagDetailService.insertTagDetail(tagDetail));
    }

    /**
     * 修改标签详情
     */
    @PreAuthorize("@ss.hasPermi('iot:tagDetail:edit')")
    @Log(title = "标签详情", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody TagDetail tagDetail)
    {
        return toAjax(tagDetailService.updateTagDetail(tagDetail));
    }

    /**
     * 删除标签详情
     */
    @PreAuthorize("@ss.hasPermi('iot:tagDetail:remove')")
    @Log(title = "标签详情", businessType = BusinessType.DELETE)
	@DeleteMapping("/{tagIds}")
    public AjaxResult remove(@PathVariable Long[] tagIds)
    {
        return toAjax(tagDetailService.deleteTagDetailByTagIds(tagIds));
    }
}
