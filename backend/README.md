# DeepDrama 后端项目

基于 Java 8 + Spring Boot 2.7 + MyBatis + MySQL 构建的后端服务。

## 📂 项目结构

```
backend/
├── src/
│   └── main/
│       ├── java/com/deepdrama/
│       │   ├── DeepDramaApplication.java          # 启动类
│       │   ├── controller/                        # 控制器层
│       │   │   ├── ScriptController.java          # 剧本接口
│       │   │   ├── RatingController.java          # 评分接口
│       │   │   ├── StatsController.java           # 统计接口
│       │   │   └── LeaderboardController.java     # 排行榜接口
│       │   ├── service/                           # 服务层
│       │   │   ├── ScriptService.java
│       │   │   ├── RatingService.java
│       │   │   └── StatsService.java
│       │   ├── mapper/                            # MyBatis Mapper
│       │   │   ├── ScriptMapper.java
│       │   │   ├── RatingMapper.java
│       │   │   └── UserMapper.java
│       │   ├── entity/                            # 实体类
│       │   │   ├── Script.java
│       │   │   ├── Rating.java
│       │   │   └── User.java
│       │   ├── dto/                               # 数据传输对象
│       │   │   ├── ScriptDTO.java
│       │   │   ├── RatingDTO.java
│       │   │   └── StatsDTO.java
│       │   ├── vo/                                # 视图对象
│       │   │   ├── ScriptVO.java
│       │   │   └── LeaderboardVO.java
│       │   ├── config/                            # 配置类
│       │   │   ├── CorsConfig.java                # 跨域配置
│       │   │   └── MyBatisConfig.java             # MyBatis配置
│       │   └── util/                              # 工具类
│       │       ├── RatingCalculator.java          # 评分计算器
│       │       └── Result.java                    # 统一返回结果
│       └── resources/
│           ├── mapper/                            # MyBatis XML
│           │   ├── ScriptMapper.xml
│           │   ├── RatingMapper.xml
│           │   └── UserMapper.xml
│           ├── application.yml                    # 主配置文件
│           └── application-dev.yml                # 开发环境配置
└── pom.xml                                        # Maven配置
```

## 🚀 快速开始

### 1. 环境要求
- JDK 8+
- Maven 3.6+
- MySQL 5.7+

### 2. 配置数据库
编辑 `src/main/resources/application.yml`:

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/deepdrama?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai
    username: root
    password: your_password
```

### 3. 启动项目
```bash
# 安装依赖
mvn clean install

# 启动项目
mvn spring-boot:run

# 或者打包后运行
mvn clean package
java -jar target/deepdrama-1.0.0.jar
```

## 📝 核心代码示例

### 1. 评分计算器 (RatingCalculator.java)

```java
package com.deepdrama.util;

public class RatingCalculator {
    
    // SOP加权系数
    private static final double CONTENT_WEIGHT = 0.4;  // 内容权重40%
    private static final double MARKET_WEIGHT = 0.3;   // 市场权重30%
    private static final double COMMERCIAL_WEIGHT = 0.3; // 商业权重30%
    
    /**
     * 计算加权总分
     * Total = (Content × 0.4) + (Market × 0.3) + (Commercial × 0.3)
     */
    public static double calculateTotalScore(double contentScore, 
                                            double marketScore, 
                                            double commercialScore) {
        double total = (contentScore * CONTENT_WEIGHT) 
                     + (marketScore * MARKET_WEIGHT) 
                     + (commercialScore * COMMERCIAL_WEIGHT);
        // 保留1位小数
        return Math.round(total * 10.0) / 10.0;
    }
    
    /**
     * 计算评级
     * 熔断机制：合规<60分强制D级
     */
    public static String calculateGrade(double totalScore, double complianceScore) {
        // 熔断机制：合规不通过直接D级
        if (complianceScore < 60) {
            return "D";
        }
        
        // 正常评级
        if (totalScore >= 90) {
            return "S";
        } else if (totalScore >= 80) {
            return "A";
        } else if (totalScore >= 70) {
            return "B";
        } else if (totalScore >= 60) {
            return "C";
        } else {
            return "D";
        }
    }
}
```

### 2. 评分服务 (RatingService.java)

```java
package com.deepdrama.service;

import com.deepdrama.entity.Rating;
import com.deepdrama.mapper.RatingMapper;
import com.deepdrama.util.RatingCalculator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class RatingService {
    
    @Autowired
    private RatingMapper ratingMapper;
    
    /**
     * 创建评分
     * 自动计算总分和评级
     */
    public Rating createRating(Rating rating) {
        // 计算加权总分
        double totalScore = RatingCalculator.calculateTotalScore(
            rating.getContentScore(),
            rating.getMarketScore(),
            rating.getCommercialScore()
        );
        rating.setTotalScore(totalScore);
        
        // 计算评级（含熔断机制）
        String grade = RatingCalculator.calculateGrade(
            totalScore,
            rating.getComplianceScore()
        );
        rating.setGrade(grade);
        
        // 设置评分日期
        if (rating.getRatingDate() == null) {
            rating.setRatingDate(LocalDate.now());
        }
        
        // 插入数据库
        ratingMapper.insert(rating);
        
        return rating;
    }
    
    /**
     * 获取剧本的所有评分
     * 按评分日期降序排列
     */
    public List<Rating> getRatingsByScriptId(String scriptId) {
        return ratingMapper.selectByScriptId(scriptId);
    }
    
    /**
     * 获取剧本的最新评分
     */
    public Rating getLatestRatingByScriptId(String scriptId) {
        return ratingMapper.selectLatestByScriptId(scriptId);
    }
}
```

### 3. 剧本控制器 (ScriptController.java)

```java
package com.deepdrama.controller;

import com.deepdrama.entity.Script;
import com.deepdrama.service.ScriptService;
import com.deepdrama.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/scripts")
public class ScriptController {
    
    @Autowired
    private ScriptService scriptService;
    
    /**
     * 获取所有剧本
     */
    @GetMapping
    public Result<List<Script>> getAllScripts() {
        List<Script> scripts = scriptService.getAllScripts();
        return Result.success(scripts);
    }
    
    /**
     * 获取单个剧本
     */
    @GetMapping("/{id}")
    public Result<Script> getScriptById(@PathVariable Long id) {
        Script script = scriptService.getScriptById(id);
        if (script == null) {
            return Result.error("剧本不存在");
        }
        return Result.success(script);
    }
    
    /**
     * 创建剧本
     * 自动生成script_id (SP001格式)
     */
    @PostMapping
    public Result<Script> createScript(@RequestBody Script script) {
        Script created = scriptService.createScript(script);
        return Result.success(created);
    }
    
    /**
     * 更新剧本
     */
    @PutMapping("/{id}")
    public Result<Void> updateScript(@PathVariable Long id, 
                                     @RequestBody Script script) {
        script.setId(id);
        scriptService.updateScript(script);
        return Result.success();
    }
    
    /**
     * 删除剧本
     * 级联删除评分记录
     */
    @DeleteMapping("/{id}")
    public Result<Void> deleteScript(@PathVariable Long id) {
        scriptService.deleteScript(id);
        return Result.success();
    }
}
```

### 4. 统计服务 (StatsService.java)

```java
package com.deepdrama.service;

import com.deepdrama.dto.StatsDTO;
import com.deepdrama.mapper.ScriptMapper;
import com.deepdrama.mapper.RatingMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class StatsService {
    
    @Autowired
    private ScriptMapper scriptMapper;
    
    @Autowired
    private RatingMapper ratingMapper;
    
    /**
     * 获取统计数据
     * 使用 Java 8 Stream API 进行内存级聚合计算
     */
    public StatsDTO getStats() {
        StatsDTO stats = new StatsDTO();
        
        // 基础统计
        int totalScripts = scriptMapper.countAll();
        int projectCount = scriptMapper.countByIsProject(true);
        int pendingRating = scriptMapper.countPendingRating();
        
        stats.setTotalScripts(totalScripts);
        stats.setProjectCount(projectCount);
        stats.setPendingRating(pendingRating);
        
        // 立项转化率
        double conversionRate = totalScripts > 0 
            ? (double) projectCount / totalScripts * 100 
            : 0;
        stats.setConversionRate(String.format("%.1f", conversionRate));
        
        // 平均质量分（获取每个剧本的最新评分，计算平均值）
        List<Rating> latestRatings = ratingMapper.selectLatestRatings();
        double avgScore = latestRatings.stream()
            .mapToDouble(Rating::getTotalScore)
            .average()
            .orElse(0.0);
        stats.setAvgScore(String.format("%.2f", avgScore));
        
        // 评级分布（使用Stream API分组统计）
        Map<String, Long> gradeDistribution = latestRatings.stream()
            .collect(Collectors.groupingBy(
                Rating::getGrade, 
                Collectors.counting()
            ));
        stats.setGradeDistribution(gradeDistribution);
        
        // 来源分布
        Map<String, Long> sourceDistribution = scriptMapper.selectAll().stream()
            .collect(Collectors.groupingBy(
                Script::getSourceType, 
                Collectors.counting()
            ));
        stats.setSourceDistribution(sourceDistribution);
        
        // 近6个月趋势（S/A级剧本）
        List<Map<String, Object>> monthlyTrend = ratingMapper.selectMonthlyTrend(6);
        stats.setMonthlyTrend(monthlyTrend);
        
        return stats;
    }
}
```

## 📋 Maven依赖 (pom.xml)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.7.18</version>
    </parent>
    
    <groupId>com.deepdrama</groupId>
    <artifactId>deepdrama-backend</artifactId>
    <version>1.0.0</version>
    
    <properties>
        <java.version>1.8</java.version>
        <maven.compiler.source>1.8</maven.compiler.source>
        <maven.compiler.target>1.8</maven.compiler.target>
    </properties>
    
    <dependencies>
        <!-- Spring Boot Web -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        
        <!-- MyBatis -->
        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
            <version>2.3.2</version>
        </dependency>
        
        <!-- MySQL -->
        <dependency>
            <groupId>com.mysql</groupId>
            <artifactId>mysql-connector-j</artifactId>
            <version>8.0.33</version>
        </dependency>
        
        <!-- Lombok -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.18.30</version>
            <scope>provided</scope>
        </dependency>
        
        <!-- Validation -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-validation</artifactId>
        </dependency>
        
        <!-- JSON -->
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>fastjson</artifactId>
            <version>2.0.43</version>
        </dependency>
    </dependencies>
    
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```

## 🔧 配置文件

### application.yml
```yaml
server:
  port: 8080
  servlet:
    context-path: /

spring:
  application:
    name: deepdrama-backend
  
  datasource:
    url: jdbc:mysql://localhost:3306/deepdrama?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai
    username: root
    password: your_password
    driver-class-name: com.mysql.cj.jdbc.Driver
    hikari:
      maximum-pool-size: 10
      minimum-idle: 5
      connection-timeout: 30000
  
  jackson:
    date-format: yyyy-MM-dd HH:mm:ss
    time-zone: GMT+8
    default-property-inclusion: non_null

mybatis:
  mapper-locations: classpath:mapper/*.xml
  type-aliases-package: com.deepdrama.entity
  configuration:
    map-underscore-to-camel-case: true
    cache-enabled: false
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl

logging:
  level:
    com.deepdrama.mapper: debug
```

## 📖 API 接口文档

详见主项目 README 中的 API 接口章节。

## 🧪 测试

```bash
# 运行单元测试
mvn test

# 运行集成测试
mvn verify
```

## 📦 打包部署

```bash
# 打包
mvn clean package -DskipTests

# 运行
java -jar target/deepdrama-backend-1.0.0.jar

# 或者使用 nohup 后台运行
nohup java -jar target/deepdrama-backend-1.0.0.jar > app.log 2>&1 &
```

## 🔒 安全建议

1. 修改默认数据库密码
2. 配置HTTPS
3. 添加JWT身份认证
4. 配置接口限流
5. 添加SQL注入防护
6. 配置CORS白名单

## 📞 技术支持

如有问题，请联系后端团队。
