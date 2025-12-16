package com.deepdrama.controller;

import com.deepdrama.dto.StatsDTO;
import com.deepdrama.service.StatsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 统计数据Controller
 * 
 * @author DeepDrama Team
 * @since 1.0.0
 */
@RestController
@RequestMapping("/api")
public class StatsController {
    
    @Autowired
    private StatsService statsService;
    
    /**
     * 获取统计数据
     * 
     * GET /api/stats
     */
    @GetMapping("/stats")
    public StatsDTO getStats() {
        return statsService.getStats();
    }
}
