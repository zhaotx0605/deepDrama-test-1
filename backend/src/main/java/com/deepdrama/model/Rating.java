package com.deepdrama.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 评分实体类
 * 
 * @author DeepDrama Team
 * @since 1.0.0
 */
@Data
public class Rating {
    
    /**
     * 主键ID
     */
    private Long id;
    
    /**
     * 剧本编号
     */
    private String scriptId;
    
    /**
     * 用户ID
     */
    private String userId;
    
    /**
     * 内容维度分数 (0-100)
     */
    private BigDecimal contentScore;
    
    /**
     * 市场维度分数 (0-100)
     */
    private BigDecimal marketScore;
    
    /**
     * 商业维度分数 (0-100)
     */
    private BigDecimal commercialScore;
    
    /**
     * 合规维度分数 (0-100)
     */
    private BigDecimal complianceScore;
    
    /**
     * 加权总分
     */
    private BigDecimal totalScore;
    
    /**
     * 评级 (S/A/B/C/D)
     */
    private String grade;
    
    /**
     * 评语
     */
    private String comments;
    
    /**
     * 创建时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date createdAt;
    
    // ========== 扩展字段 (非数据库字段) ==========
    
    /**
     * 评分人姓名
     */
    private String userName;
    
    /**
     * 评分人角色
     */
    private String userRole;
}
