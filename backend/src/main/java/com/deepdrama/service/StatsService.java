package com.deepdrama.service;

import com.deepdrama.dto.StatsDTO;
import com.deepdrama.mapper.RatingMapper;
import com.deepdrama.mapper.ScriptMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;
import java.util.Map;

/**
 * 统计业务逻辑类
 * 使用Java 8 Stream API进行数据统计
 * 
 * @author DeepDrama Team
 * @since 1.0.0
 */
@Service
public class StatsService {
    
    @Autowired
    private ScriptMapper scriptMapper;
    
    @Autowired
    private RatingMapper ratingMapper;
    
    /**
     * 获取统计数据
     */
    public StatsDTO getStats() {
        StatsDTO stats = new StatsDTO();
        
        // 1. 剧本总数
        Integer totalScripts = scriptMapper.countTotal();
        stats.setTotalScripts(totalScripts != null ? totalScripts : 0);
        
        // 2. 已立项数量
        Integer projectCount = scriptMapper.countProjects();
        stats.setProjectCount(projectCount != null ? projectCount : 0);
        
        // 3. 待评分数量
        Integer pendingRatings = scriptMapper.countPendingRatings();
        stats.setPendingRatings(pendingRatings != null ? pendingRatings : 0);
        
        // 4. 转化率 (已立项 / 总剧本)
        BigDecimal conversionRate = BigDecimal.ZERO;
        if (totalScripts != null && totalScripts > 0 && projectCount != null) {
            conversionRate = new BigDecimal(projectCount)
                    .divide(new BigDecimal(totalScripts), 4, RoundingMode.HALF_UP)
                    .multiply(new BigDecimal("100"))
                    .setScale(1, RoundingMode.HALF_UP);
        }
        stats.setConversionRate(conversionRate);
        
        // 5. 平均质量分
        BigDecimal averageScore = ratingMapper.selectOverallAverageScore();
        if (averageScore != null) {
            stats.setAverageScore(averageScore.setScale(2, RoundingMode.HALF_UP));
        } else {
            stats.setAverageScore(BigDecimal.ZERO);
        }
        
        // 6. 评级分布
        List<Map<String, Object>> gradeDistribution = ratingMapper.selectGradeDistribution();
        stats.setGradeDistribution(gradeDistribution);
        
        // 7. 来源分布
        List<Map<String, Object>> sourceDistribution = scriptMapper.selectSourceDistribution();
        stats.setSourceDistribution(sourceDistribution);
        
        // 8. 状态分布
        List<Map<String, Object>> statusDistribution = scriptMapper.selectStatusDistribution();
        stats.setStatusDistribution(statusDistribution);
        
        // 9. 月度趋势 (最近7个月)
        List<Map<String, Object>> monthlyTrend = scriptMapper.selectMonthlyTrend(
            "2025-06-01", 
            "2025-12-31"
        );
        stats.setMonthlyTrend(monthlyTrend);
        
        return stats;
    }
}
