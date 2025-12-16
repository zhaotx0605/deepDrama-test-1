package com.deepdrama.dto;

import lombok.Data;

import javax.validation.constraints.DecimalMax;
import javax.validation.constraints.DecimalMin;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;

/**
 * 评分提交DTO
 * 
 * @author DeepDrama Team
 * @since 1.0.0
 */
@Data
public class RatingSubmitDTO {
    
    /**
     * 用户ID
     */
    private String userId;
    
    /**
     * 内容维度分数 (0-100)
     */
    @NotNull(message = "内容维度分数不能为空")
    @DecimalMin(value = "0", message = "内容维度分数最小为0")
    @DecimalMax(value = "100", message = "内容维度分数最大为100")
    private BigDecimal contentScore;
    
    /**
     * 市场维度分数 (0-100)
     */
    @NotNull(message = "市场维度分数不能为空")
    @DecimalMin(value = "0", message = "市场维度分数最小为0")
    @DecimalMax(value = "100", message = "市场维度分数最大为100")
    private BigDecimal marketScore;
    
    /**
     * 商业维度分数 (0-100)
     */
    @NotNull(message = "商业维度分数不能为空")
    @DecimalMin(value = "0", message = "商业维度分数最小为0")
    @DecimalMax(value = "100", message = "商业维度分数最大为100")
    private BigDecimal commercialScore;
    
    /**
     * 合规维度分数 (0-100)
     */
    @NotNull(message = "合规维度分数不能为空")
    @DecimalMin(value = "0", message = "合规维度分数最小为0")
    @DecimalMax(value = "100", message = "合规维度分数最大为100")
    private BigDecimal complianceScore;
    
    /**
     * 评语
     */
    private String comments;
}
