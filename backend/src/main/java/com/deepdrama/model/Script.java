package com.deepdrama.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * 剧本实体类
 * 
 * @author DeepDrama Team
 * @since 1.0.0
 */
@Data
public class Script {
    
    /**
     * 主键ID
     */
    private Long id;
    
    /**
     * 剧本编号 (SP001格式)
     */
    private String scriptId;
    
    /**
     * 剧本名称
     */
    private String name;
    
    /**
     * 剧本简介
     */
    private String preview;
    
    /**
     * 飞书文档链接
     */
    private String fileUrl;
    
    /**
     * 标签 (JSON数组字符串)
     */
    private String tags;
    
    /**
     * 标签列表 (解析后)
     */
    private List<String> tagList;
    
    /**
     * 来源类型
     */
    private String sourceType;
    
    /**
     * 所属团队
     */
    private String team;
    
    /**
     * 剧本状态
     */
    private String status;
    
    /**
     * 是否立项 (0否 1是)
     */
    private Integer isProject;
    
    /**
     * 提交日期
     */
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date submitDate;
    
    /**
     * 提交人
     */
    private String submitUser;
    
    /**
     * 创建时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date createdAt;
    
    /**
     * 更新时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date updatedAt;
    
    // ========== 扩展字段 (非数据库字段) ==========
    
    /**
     * 加权总分
     */
    private BigDecimal totalScore;
    
    /**
     * 评级 (S/A/B/C/D)
     */
    private String grade;
    
    /**
     * 评分次数
     */
    private Integer ratingCount;
}
