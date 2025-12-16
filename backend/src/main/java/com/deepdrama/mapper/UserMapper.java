package com.deepdrama.mapper;

import com.deepdrama.model.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 用户Mapper接口
 * 
 * @author DeepDrama Team
 * @since 1.0.0
 */
@Mapper
public interface UserMapper {
    
    /**
     * 查询用户列表
     */
    List<User> selectList();
    
    /**
     * 根据ID查询用户
     */
    User selectById(@Param("id") Long id);
    
    /**
     * 根据用户ID查询
     */
    User selectByUserId(@Param("userId") String userId);
    
    /**
     * 插入用户
     */
    int insert(User user);
    
    /**
     * 更新用户
     */
    int update(User user);
    
    /**
     * 删除用户
     */
    int deleteByUserId(@Param("userId") String userId);
}
