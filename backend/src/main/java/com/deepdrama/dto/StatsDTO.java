package com.deepdrama.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * 统计数据DTO
 * 
 * @author DeepDrama Team
 * @since 1.0.0
 */
@Data
public class StatsDTO {
    
    /**
     * 剧本总数
     */
    private Integer totalScripts;
    
    /**
     * 已立项数量
     */
    private Integer projectCount;
    
    /**
     * 待评分数量
     */
    private Integer pendingRatings;
    
    /**
     * 转化率
     */
    private BigDecimal conversionRate;
    
    /**
     * 平均质量分
     */
    private BigDecimal averageScore;
    
    /**
     * 评级分布
     */
    private List<Map<String, Object>> gradeDistribution;
    
    /**
     * 来源分布
     */
    private List<Map<String, Object>> sourceDistribution;
    
    /**
     * 状态分布
     */
    private List<Map<String, Object>> statusDistribution;
    
    /**
     * 月度趋势
     */
    private List<Map<String, Object>> monthlyTrend;
}
