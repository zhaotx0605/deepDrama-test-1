package com.deepdrama.mapper;

import com.deepdrama.model.Rating;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * 评分Mapper接口
 * 
 * @author DeepDrama Team
 * @since 1.0.0
 */
@Mapper
public interface RatingMapper {
    
    /**
     * 查询评分列表
     */
    List<Rating> selectList(@Param("scriptId") String scriptId);
    
    /**
     * 根据ID查询评分
     */
    Rating selectById(@Param("id") Long id);
    
    /**
     * 插入评分
     */
    int insert(Rating rating);
    
    /**
     * 删除评分 (根据剧本ID)
     */
    int deleteByScriptId(@Param("scriptId") String scriptId);
    
    /**
     * 查询剧本的平均分
     */
    BigDecimal selectAverageScore(@Param("scriptId") String scriptId);
    
    /**
     * 查询剧本的最高分
     */
    BigDecimal selectMaxScore(@Param("scriptId") String scriptId);
    
    /**
     * 查询剧本的评分次数
     */
    Integer countByScriptId(@Param("scriptId") String scriptId);
    
    /**
     * 查询所有剧本的平均分
     */
    BigDecimal selectOverallAverageScore();
    
    /**
     * 统计评级分布
     */
    List<Map<String, Object>> selectGradeDistribution();
}
