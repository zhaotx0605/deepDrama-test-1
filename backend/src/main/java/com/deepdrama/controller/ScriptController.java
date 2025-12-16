package com.deepdrama.controller;

import com.deepdrama.dto.ScriptQueryDTO;
import com.deepdrama.model.Script;
import com.deepdrama.service.ScriptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 剧本管理Controller
 * 
 * @author DeepDrama Team
 * @since 1.0.0
 */
@RestController
@RequestMapping("/api/scripts")
public class ScriptController {
    
    @Autowired
    private ScriptService scriptService;
    
    /**
     * 查询剧本列表
     * 
     * GET /api/scripts
     * GET /api/scripts?quickFilter=pending
     * GET /api/scripts?status=完整剧本&source=内部团队
     */
    @GetMapping
    public List<Script> getScripts(ScriptQueryDTO query) {
        return scriptService.getScripts(query);
    }
    
    /**
     * 查询剧本详情
     * 
     * GET /api/scripts/{scriptId}
     */
    @GetMapping("/{scriptId}")
    public Script getScript(@PathVariable String scriptId) {
        return scriptService.getScriptByScriptId(scriptId);
    }
    
    /**
     * 新增剧本
     * 
     * POST /api/scripts
     */
    @PostMapping
    public Map<String, Object> createScript(@RequestBody Script script) {
        String scriptId = scriptService.createScript(script);
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("scriptId", scriptId);
        return result;
    }
    
    /**
     * 更新剧本
     * 
     * PUT /api/scripts/{scriptId}
     */
    @PutMapping("/{scriptId}")
    public Map<String, Object> updateScript(
            @PathVariable String scriptId,
            @RequestBody Script script) {
        scriptService.updateScript(scriptId, script);
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }
    
    /**
     * 删除剧本
     * 
     * DELETE /api/scripts/{scriptId}
     */
    @DeleteMapping("/{scriptId}")
    public Map<String, Object> deleteScript(@PathVariable String scriptId) {
        scriptService.deleteScript(scriptId);
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }
    
    /**
     * 查询剧本排行榜
     * 
     * GET /api/scripts/rankings?limit=100
     */
    @GetMapping("/rankings")
    public List<Script> getRankings(@RequestParam(required = false, defaultValue = "100") Integer limit) {
        return scriptService.getRankings(limit);
    }
}
