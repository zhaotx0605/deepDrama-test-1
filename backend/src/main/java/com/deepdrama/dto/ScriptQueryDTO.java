package com.deepdrama.dto;

import lombok.Data;

import java.math.BigDecimal;

/**
 * 剧本查询DTO
 * 
 * @author DeepDrama Team
 * @since 1.0.0
 */
@Data
public class ScriptQueryDTO {
    
    /**
     * 快捷筛选 (pending/s_potential/project)
     */
    private String quickFilter;
    
    /**
     * 状态
     */
    private String status;
    
    /**
     * 来源类型
     */
    private String source;
    
    /**
     * 标签
     */
    private String tag;
    
    /**
     * 最小分数
     */
    private BigDecimal minScore;
    
    /**
     * 最大分数
     */
    private BigDecimal maxScore;
    
    /**
     * 搜索关键词
     */
    private String search;
    
    /**
     * 排序字段
     */
    private String orderBy;
    
    /**
     * 排序方式 (ASC/DESC)
     */
    private String order;
}
