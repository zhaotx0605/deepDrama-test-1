package com.deepdrama.service;

import com.deepdrama.dto.ScriptQueryDTO;
import com.deepdrama.mapper.RatingMapper;
import com.deepdrama.mapper.ScriptMapper;
import com.deepdrama.model.Script;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 剧本业务逻辑类
 * 
 * @author DeepDrama Team
 * @since 1.0.0
 */
@Service
public class ScriptService {
    
    @Autowired
    private ScriptMapper scriptMapper;
    
    @Autowired
    private RatingMapper ratingMapper;
    
    private final ObjectMapper objectMapper = new ObjectMapper();
    
    /**
     * 查询剧本列表
     */
    public List<Script> getScripts(ScriptQueryDTO query) {
        List<Script> scripts = scriptMapper.selectList(query);
        
        // 解析标签JSON
        scripts.forEach(script -> {
            try {
                if (script.getTags() != null && !script.getTags().isEmpty()) {
                    List<String> tagList = objectMapper.readValue(
                        script.getTags(), 
                        new TypeReference<List<String>>() {}
                    );
                    script.setTagList(tagList);
                }
            } catch (Exception e) {
                // 忽略JSON解析错误
            }
        });
        
        return scripts;
    }
    
    /**
     * 根据剧本ID查询详情
     */
    public Script getScriptByScriptId(String scriptId) {
        Script script = scriptMapper.selectByScriptId(scriptId);
        if (script != null && script.getTags() != null) {
            try {
                List<String> tagList = objectMapper.readValue(
                    script.getTags(), 
                    new TypeReference<List<String>>() {}
                );
                script.setTagList(tagList);
            } catch (Exception e) {
                // 忽略JSON解析错误
            }
        }
        return script;
    }
    
    /**
     * 新增剧本
     */
    @Transactional(rollbackFor = Exception.class)
    public String createScript(Script script) {
        // 生成剧本编号
        String scriptId = generateScriptId();
        script.setScriptId(scriptId);
        
        // 转换标签为JSON
        if (script.getTagList() != null && !script.getTagList().isEmpty()) {
            try {
                script.setTags(objectMapper.writeValueAsString(script.getTagList()));
            } catch (Exception e) {
                script.setTags("[]");
            }
        } else {
            script.setTags("[]");
        }
        
        // 插入数据库
        scriptMapper.insert(script);
        return scriptId;
    }
    
    /**
     * 更新剧本
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateScript(String scriptId, Script script) {
        script.setScriptId(scriptId);
        
        // 转换标签为JSON
        if (script.getTagList() != null && !script.getTagList().isEmpty()) {
            try {
                script.setTags(objectMapper.writeValueAsString(script.getTagList()));
            } catch (Exception e) {
                // 保持原有标签
            }
        }
        
        scriptMapper.update(script);
    }
    
    /**
     * 删除剧本 (同时删除评分记录)
     */
    @Transactional(rollbackFor = Exception.class)
    public void deleteScript(String scriptId) {
        // 删除评分记录
        ratingMapper.deleteByScriptId(scriptId);
        
        // 删除剧本
        scriptMapper.deleteByScriptId(scriptId);
    }
    
    /**
     * 生成剧本编号 (SP001格式)
     */
    private String generateScriptId() {
        String maxScriptId = scriptMapper.selectMaxScriptId();
        
        int nextNum = 1;
        if (maxScriptId != null && maxScriptId.startsWith("SP")) {
            try {
                nextNum = Integer.parseInt(maxScriptId.substring(2)) + 1;
            } catch (NumberFormatException e) {
                nextNum = 1;
            }
        }
        
        return String.format("SP%03d", nextNum);
    }
    
    /**
     * 查询排行榜
     */
    public List<Script> getRankings(Integer limit) {
        if (limit == null || limit <= 0) {
            limit = 100;
        }
        return scriptMapper.selectRankings(limit);
    }
}
