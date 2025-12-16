package com.deepdrama.controller;

import com.deepdrama.dto.RatingSubmitDTO;
import com.deepdrama.model.Rating;
import com.deepdrama.service.RatingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 评分管理Controller
 * 
 * @author DeepDrama Team
 * @since 1.0.0
 */
@RestController
@RequestMapping("/api/scripts")
public class RatingController {
    
    @Autowired
    private RatingService ratingService;
    
    /**
     * 查询评分历史
     * 
     * GET /api/scripts/{scriptId}/ratings
     */
    @GetMapping("/{scriptId}/ratings")
    public List<Rating> getRatingHistory(@PathVariable String scriptId) {
        return ratingService.getRatingHistory(scriptId);
    }
    
    /**
     * 提交评分
     * 
     * POST /api/scripts/{scriptId}/ratings
     */
    @PostMapping("/{scriptId}/ratings")
    public Map<String, Object> submitRating(
            @PathVariable String scriptId,
            @Validated @RequestBody RatingSubmitDTO dto) {
        return ratingService.submitRating(scriptId, dto);
    }
}
