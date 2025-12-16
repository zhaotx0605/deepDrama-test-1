package com.deepdrama.mapper;

import com.deepdrama.dto.ScriptQueryDTO;
import com.deepdrama.model.Script;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 剧本Mapper接口
 * 
 * @author DeepDrama Team
 * @since 1.0.0
 */
@Mapper
public interface ScriptMapper {
    
    /**
     * 查询剧本列表
     */
    List<Script> selectList(@Param("query") ScriptQueryDTO query);
    
    /**
     * 根据ID查询剧本
     */
    Script selectById(@Param("id") Long id);
    
    /**
     * 根据剧本编号查询
     */
    Script selectByScriptId(@Param("scriptId") String scriptId);
    
    /**
     * 插入剧本
     */
    int insert(Script script);
    
    /**
     * 更新剧本
     */
    int update(Script script);
    
    /**
     * 删除剧本
     */
    int deleteByScriptId(@Param("scriptId") String scriptId);
    
    /**
     * 统计剧本总数
     */
    Integer countTotal();
    
    /**
     * 统计已立项数量
     */
    Integer countProjects();
    
    /**
     * 统计待评分数量
     */
    Integer countPendingRatings();
    
    /**
     * 统计来源分布
     */
    List<Map<String, Object>> selectSourceDistribution();
    
    /**
     * 统计状态分布
     */
    List<Map<String, Object>> selectStatusDistribution();
    
    /**
     * 统计月度趋势
     */
    List<Map<String, Object>> selectMonthlyTrend(@Param("startDate") String startDate, 
                                                   @Param("endDate") String endDate);
    
    /**
     * 查询最新的剧本编号
     */
    String selectMaxScriptId();
    
    /**
     * 查询排行榜 (Top 100)
     */
    List<Script> selectRankings(@Param("limit") Integer limit);
}
