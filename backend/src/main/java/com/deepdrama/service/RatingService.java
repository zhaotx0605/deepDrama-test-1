package com.deepdrama.service;

import com.deepdrama.dto.RatingSubmitDTO;
import com.deepdrama.mapper.RatingMapper;
import com.deepdrama.model.Rating;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 评分业务逻辑类
 * SOP加权算法实现
 * 
 * @author DeepDrama Team
 * @since 1.0.0
 */
@Service
public class RatingService {
    
    @Autowired
    private RatingMapper ratingMapper;
    
    /**
     * 提交评分
     * 
     * SOP加权算法:
     * 总分 = (内容维度 × 40%) + (市场维度 × 30%) + (商业维度 × 30%)
     * 
     * 熔断机制:
     * 合规分 < 60 → 强制D级，总分归零
     */
    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> submitRating(String scriptId, RatingSubmitDTO dto) {
        Rating rating = new Rating();
        BeanUtils.copyProperties(dto, rating);
        rating.setScriptId(scriptId);
        
        // 设置默认用户ID (如果未提供)
        if (rating.getUserId() == null || rating.getUserId().isEmpty()) {
            rating.setUserId("U001");
        }
        
        // 计算加权总分
        BigDecimal totalScore = calculateTotalScore(
            dto.getContentScore(),
            dto.getMarketScore(),
            dto.getCommercialScore(),
            dto.getComplianceScore()
        );
        rating.setTotalScore(totalScore);
        
        // 判定评级
        String grade = determineGrade(totalScore, dto.getComplianceScore());
        rating.setGrade(grade);
        
        // 保存评分
        ratingMapper.insert(rating);
        
        // 返回结果
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("totalScore", totalScore);
        result.put("grade", grade);
        return result;
    }
    
    /**
     * 计算加权总分
     * 
     * @param contentScore 内容维度分数
     * @param marketScore 市场维度分数
     * @param commercialScore 商业维度分数
     * @param complianceScore 合规维度分数
     * @return 加权总分
     */
    private BigDecimal calculateTotalScore(
            BigDecimal contentScore,
            BigDecimal marketScore,
            BigDecimal commercialScore,
            BigDecimal complianceScore) {
        
        // 合规熔断机制
        if (complianceScore.compareTo(new BigDecimal("60")) < 0) {
            return BigDecimal.ZERO;
        }
        
        // SOP加权算法: 4:3:3
        BigDecimal total = contentScore.multiply(new BigDecimal("0.4"))
                .add(marketScore.multiply(new BigDecimal("0.3")))
                .add(commercialScore.multiply(new BigDecimal("0.3")));
        
        // 保留1位小数
        return total.setScale(1, RoundingMode.HALF_UP);
    }
    
    /**
     * 判定评级
     * 
     * @param totalScore 加权总分
     * @param complianceScore 合规分数
     * @return 评级 (S/A/B/C/D)
     */
    private String determineGrade(BigDecimal totalScore, BigDecimal complianceScore) {
        // 合规不达标，强制D级
        if (complianceScore.compareTo(new BigDecimal("60")) < 0) {
            return "D";
        }
        
        // 根据总分判定评级
        if (totalScore.compareTo(new BigDecimal("90")) >= 0) {
            return "S";
        } else if (totalScore.compareTo(new BigDecimal("80")) >= 0) {
            return "A";
        } else if (totalScore.compareTo(new BigDecimal("70")) >= 0) {
            return "B";
        } else if (totalScore.compareTo(new BigDecimal("60")) >= 0) {
            return "C";
        } else {
            return "D";
        }
    }
    
    /**
     * 查询评分历史
     */
    public List<Rating> getRatingHistory(String scriptId) {
        return ratingMapper.selectList(scriptId);
    }
    
    /**
     * 查询评级分布
     */
    public List<Map<String, Object>> getGradeDistribution() {
        return ratingMapper.selectGradeDistribution();
    }
}
