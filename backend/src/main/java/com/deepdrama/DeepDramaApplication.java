package com.deepdrama;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * DeepDrama 剧本评分管理系统启动类
 * 
 * @author DeepDrama Team
 * @since 1.0.0
 */
@SpringBootApplication
@MapperScan("com.deepdrama.mapper")
public class DeepDramaApplication {

    public static void main(String[] args) {
        SpringApplication.run(DeepDramaApplication.class, args);
        System.out.println("\n========================================");
        System.out.println("DeepDrama 剧本评分管理系统启动成功！");
        System.out.println("访问地址: http://localhost:8080");
        System.out.println("API文档: http://localhost:8080/api/");
        System.out.println("========================================\n");
    }
}
