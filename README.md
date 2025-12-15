# DeepDrama - 剧本管理系统

专业的短剧剧本评分管理系统，基于 **Vue 3 + Arco Design + Java 8 + MySQL** 构建。

## 🎯 项目概述

- **名称**: DeepDrama
- **目标**: 为短剧内容团队提供专业的剧本筛选和评估工具
- **技术栈**:
  - 前端: Vue 3 + Arco Design + ECharts + Axios
  - 后端: Java 8 + Spring Boot 2.7 + MyBatis + MySQL 5.7+

## 📂 项目结构

```
webapp/
├── frontend/          # Vue 3 + Arco Design 前端项目
│   ├── src/
│   │   ├── views/     # 页面组件
│   │   ├── components/# 通用组件
│   │   ├── api/       # API 接口
│   │   ├── router/    # 路由配置
│   │   ├── stores/    # 状态管理
│   │   └── utils/     # 工具函数
│   └── package.json
├── backend/           # Java 8 Spring Boot 后端项目
│   ├── src/
│   │   └── main/
│   │       ├── java/
│   │       │   └── com/deepdrama/
│   │       │       ├── controller/    # 控制器
│   │       │       ├── service/       # 业务逻辑
│   │       │       ├── mapper/        # MyBatis Mapper
│   │       │       ├── entity/        # 实体类
│   │       │       └── config/        # 配置类
│   │       └── resources/
│   │           ├── mapper/            # MyBatis XML
│   │           └── application.yml    # 配置文件
│   └── pom.xml
└── database/          # 数据库脚本
    ├── schema.sql     # 表结构
    └── seed.sql       # 测试数据
```

## 🚀 快速开始

### 1. 数据库初始化

```bash
# 创建数据库
mysql -u root -p < database/schema.sql

# 导入测试数据
mysql -u root -p deepdrama < database/seed.sql
```

### 2. 后端启动

```bash
cd backend
mvn spring-boot:run
```

后端默认运行在 `http://localhost:8080`

### 3. 前端启动

```bash
cd frontend
npm install
npm run dev
```

前端默认运行在 `http://localhost:5173`

## 📊 核心功能

### 1. 数据看板 (Dashboard)
- **KPI指标**: 剧本总库、立项转化率、待办积压、平均质量分
- **可视化图表**: 评级漏斗、来源分析、质量趋势

### 2. 剧本管理 (Script Management)
- **快捷筛选**: 全部 | 待评分 | S级潜力 | 已立项
- **高级筛选**: 状态、来源、标签、评分区间
- **CRUD操作**: 新增、编辑、删除、预览

### 3. 评分系统 (Rating System)
- **SOP加权算法**:
  - 内容评分 (40%)
  - 市场评分 (30%)
  - 商业评分 (30%)
  - 合规评分 (一票否决)
- **熔断机制**: 合规<60分强制D级
- **评分抽屉**: 实时预览、历史记录

### 4. 剧本排行 (Leaderboard)
- Top 100 排名
- 雷达图能力模型

## 🔌 API 接口

### 剧本接口
- `GET /api/scripts` - 获取剧本列表
- `GET /api/scripts/{id}` - 获取剧本详情
- `POST /api/scripts` - 创建剧本
- `PUT /api/scripts/{id}` - 更新剧本
- `DELETE /api/scripts/{id}` - 删除剧本

### 评分接口
- `GET /api/ratings` - 获取评分列表
- `GET /api/ratings?scriptId=xxx` - 获取指定剧本评分
- `POST /api/ratings` - 创建评分
- `PUT /api/ratings/{id}` - 更新评分
- `DELETE /api/ratings/{id}` - 删除评分

### 统计接口
- `GET /api/stats` - 获取统计数据
- `GET /api/leaderboard` - 获取排行榜

## 📝 评分算法

### SOP加权公式
```
Total = (Content × 0.4) + (Market × 0.3) + (Commercial × 0.3)
```

### 熔断机制
```java
if (complianceScore < 60) {
    grade = "D"; // 强制淘汰
} else if (totalScore >= 90) {
    grade = "S";
} else if (totalScore >= 80) {
    grade = "A";
} else if (totalScore >= 70) {
    grade = "B";
} else if (totalScore >= 60) {
    grade = "C";
} else {
    grade = "D";
}
```

### 评级标准
| 评级 | 分数范围 | 颜色 | 说明 |
|------|----------|------|------|
| S | ≥90 | 紫色 #722ED1 | 爆款潜质 |
| A | 80-89 | 青色 #0FC6C2 | 优质剧本 |
| B | 70-79 | 绿色 #00B42A | 合格剧本 |
| C | 60-69 | 橙色 #FF7D00 | 需要改进 |
| D | <60或合规不通过 | 红色 #F53F3F | 淘汰 |

## 🗄️ 数据模型

### Scripts (剧本表)
```sql
- id: BIGINT AUTO_INCREMENT
- script_id: VARCHAR(50) UNIQUE (SP001格式)
- name: VARCHAR(200) NOT NULL
- preview: TEXT
- file_url: VARCHAR(500)
- tags: JSON
- source_type: VARCHAR(50)
- team: VARCHAR(100)
- status: VARCHAR(50)
- is_project: TINYINT(1)
- submit_date: DATE
- submit_user: VARCHAR(100)
- created_at, updated_at: DATETIME
```

### Ratings (评分表)
```sql
- id: BIGINT AUTO_INCREMENT
- script_id: VARCHAR(50)
- user_id: VARCHAR(50)
- user_name: VARCHAR(100)
- user_role: VARCHAR(50)
- content_score: DECIMAL(5,2)
- market_score: DECIMAL(5,2)
- compliance_score: DECIMAL(5,2)
- commercial_score: DECIMAL(5,2)
- total_score: DECIMAL(5,2)
- grade: VARCHAR(10)
- comments: TEXT
- rating_date: DATE
- is_system_import: TINYINT(1)
- created_at, updated_at: DATETIME
```

## 🎨 前端技术

### Arco Design 组件使用
- **Layout**: 布局组件
- **Menu**: 侧边菜单
- **Table**: 数据表格
- **Form**: 表单组件
- **Modal**: 弹窗组件
- **Drawer**: 抽屉组件
- **Button**: 按钮组件
- **Tag**: 标签组件
- **Badge**: 徽标组件
- **Message**: 消息提示

### ECharts 图表
- **饼图**: 评级漏斗
- **柱状图**: 来源分析
- **折线图**: 质量趋势
- **雷达图**: 能力模型

## 🔧 配置说明

### 后端配置 (application.yml)
```yaml
server:
  port: 8080

spring:
  datasource:
    url: jdbc:mysql://localhost:3306/deepdrama?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai
    username: root
    password: your_password
    driver-class-name: com.mysql.cj.jdbc.Driver

mybatis:
  mapper-locations: classpath:mapper/*.xml
  type-aliases-package: com.deepdrama.entity
  configuration:
    map-underscore-to-camel-case: true
```

### 前端配置 (vite.config.js)
```javascript
export default defineConfig({
  server: {
    port: 5173,
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true
      }
    }
  }
})
```

## 📦 依赖版本

### 后端依赖
- Java: 8
- Spring Boot: 2.7.18
- MySQL Connector: 8.0.33
- MyBatis Spring Boot Starter: 2.3.2
- Lombok: 1.18.30

### 前端依赖
- Vue: 3.5+
- Arco Design Vue: 2.55+
- ECharts: 5.5+
- Axios: 1.7+
- Vue Router: 4.4+

## 📅 开发计划

### v1.0.0 (当前版本)
- ✅ 数据看板
- ✅ 剧本管理
- ✅ 评分系统
- ✅ 剧本排行

### v1.1.0 (计划中)
- [ ] 飞书单点登录
- [ ] 批量导入Excel
- [ ] 评分审批流程
- [ ] 数据导出功能

### v1.2.0 (计划中)
- [ ] 移动端适配
- [ ] 评分权重可配置
- [ ] 多维度数据分析
- [ ] 智能推荐系统

## 📖 开发文档

详细的开发文档请参考：
- [前端开发指南](frontend/README.md)
- [后端开发指南](backend/README.md)
- [API接口文档](docs/API.md)
- [数据库设计文档](docs/DATABASE.md)

## 🤝 贡献指南

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 📞 联系方式

项目负责人: DeepDrama Team

邮箱: team@deepdrama.com
