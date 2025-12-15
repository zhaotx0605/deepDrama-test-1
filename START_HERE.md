# 🚀 DeepDrama 快速上手指南

欢迎使用 DeepDrama 剧本管理系统！本文档帮助您快速了解并开始使用本项目。

---

## 📚 文档导航

### 🎯 新手必读
1. **[README.md](./README.md)** - 项目总览和快速开始
2. **[PROJECT_SUMMARY.md](./PROJECT_SUMMARY.md)** - 项目完成总结（推荐先看这个）

### 🔧 开发文档
3. **[backend/README.md](./backend/README.md)** - 后端开发指南（13,407字）
   - Java 8 + Spring Boot + MyBatis + MySQL
   - 完整的代码示例和最佳实践

4. **[frontend/README.md](./frontend/README.md)** - 前端开发指南（13,849字）
   - Vue 3 + Arco Design + ECharts
   - 组件使用示例和开发规范

### 🚀 部署文档
5. **[DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)** - 完整部署指南（8,098字）
   - 从零开始的部署流程
   - 生产环境配置和优化

### 💾 数据库文件
6. **[database/schema.sql](./database/schema.sql)** - MySQL 表结构
7. **[database/seed.sql](./database/seed.sql)** - 测试数据（30条剧本 + 35条评分）

---

## ⚡ 5分钟快速启动

### 前提条件
- JDK 8+
- Maven 3.6+
- MySQL 5.7+
- Node.js 16+

### 步骤 1: 初始化数据库
```bash
mysql -u root -p < database/schema.sql
mysql -u root -p deepdrama < database/seed.sql
```

### 步骤 2: 启动后端
```bash
cd backend
# 修改 src/main/resources/application.yml 中的数据库配置
mvn spring-boot:run
```

### 步骤 3: 启动前端
```bash
cd frontend
npm install
npm run dev
```

### 步骤 4: 访问系统
- 前端: http://localhost:5173
- 后端: http://localhost:8080

---

## 🎯 核心功能概览

### 1. 📊 数据看板
展示剧本管理的核心 KPI 指标：
- 剧本总库、立项转化率、待办积压、平均质量分
- 评级漏斗、来源分析、质量趋势图表

### 2. 🎬 剧本管理
完整的剧本 CRUD 功能：
- 快捷筛选（全部、待评分、S级潜力、已立项）
- 高级筛选（状态、来源、标签、评分区间）
- 预览、编辑、删除、评分操作

### 3. ⭐ 评分系统
专业的 SOP 加权评分算法：
- **内容评分 (40%)**: 黄金开局、情绪钩子、节奏感
- **市场评分 (30%)**: 题材红利、人设代入、受众匹配
- **商业评分 (30%)**: 付费卡点、制作成本、ROI预期
- **合规评分 (一票否决)**: 合规<60分强制D级

### 4. 🏆 剧本排行
Top 100 剧本展示：
- 排名奖牌（🥇🥈🥉）
- S级"爆款预测"标签
- 雷达图能力模型

---

## 🎨 评级标准

| 评级 | 分数 | 颜色 | 说明 |
|------|------|------|------|
| S | ≥90 | 紫色 | 爆款潜质，建议优先立项 |
| A | 80-89 | 青色 | 优质剧本，可以立项 |
| B | 70-79 | 绿色 | 合格剧本，需优化 |
| C | 60-69 | 橙色 | 需要大幅改进 |
| D | <60 | 红色 | 淘汰或合规不通过 |

---

## 📊 测试数据

系统已包含完整的测试数据供您体验：

### 剧本数据 (30条)
- **SP001** - 总裁的替嫁甜妻 (S级，已立项)
- **SP002** - 重生之商业帝国 (S级，已立项)
- **SP003** - 闪婚老公是大佬 (A级)
- **SP004** - 战神归来 (B级)
- **SP005** - 豪门弃妇逆袭记 (S级，已立项)
- ... 共30条

### 评分记录 (35条)
- 主编评分：张主编
- 制片方评分：李制片
- 系统导入历史数据
- 合规否决案例演示

### 统计数据
- 总剧本数: 30
- 已立项: 8 (26.7%)
- 待评分: 7
- 平均分: 82.67
- S级: 5 | A级: 10 | B级: 5 | C级: 2 | D级: 1

---

## 🔧 技术架构

### 前端
```
Vue 3 (Composition API)
  ↓
Arco Design (UI组件库)
  ↓
ECharts (数据可视化)
  ↓
Axios (HTTP请求)
```

### 后端
```
Spring Boot 2.7
  ↓
MyBatis (ORM)
  ↓
MySQL 5.7+ (数据库)
```

### 核心算法
```java
// SOP加权算法
Total = (Content × 0.4) + (Market × 0.3) + (Commercial × 0.3)

// 熔断机制
if (Compliance < 60) {
    Grade = "D"  // 强制淘汰
}
```

---

## 📂 项目结构

```
webapp/
├── README.md                    # 项目总览
├── START_HERE.md               # 本文档
├── PROJECT_SUMMARY.md          # 项目总结
├── DEPLOYMENT_GUIDE.md         # 部署指南
│
├── database/                   # 数据库脚本
│   ├── schema.sql              # 表结构
│   └── seed.sql                # 测试数据
│
├── backend/                    # Java 后端
│   ├── README.md              # 后端开发指南
│   ├── pom.xml                # Maven配置
│   └── src/                   # 源代码目录
│
└── frontend/                   # Vue 前端
    ├── README.md              # 前端开发指南
    ├── package.json           # npm配置
    └── src/                   # 源代码目录
```

---

## 🎓 学习路径

### 新手路径
1. 阅读 [PROJECT_SUMMARY.md](./PROJECT_SUMMARY.md) 了解项目全貌
2. 查看 [database/schema.sql](./database/schema.sql) 理解数据模型
3. 阅读 [backend/README.md](./backend/README.md) 学习后端实现
4. 阅读 [frontend/README.md](./frontend/README.md) 学习前端实现

### 实践路径
1. 按照上面的"5分钟快速启动"运行系统
2. 体验系统的各个功能模块
3. 查看测试数据，理解业务逻辑
4. 尝试修改代码，实现新功能

### 部署路径
1. 阅读 [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)
2. 准备生产环境（服务器、域名）
3. 按照部署指南逐步部署
4. 配置监控和备份

---

## ❓ 常见问题

### Q: 后端启动失败怎么办？
A: 检查以下几点：
1. MySQL 是否启动？
2. 数据库配置是否正确？（application.yml）
3. 端口 8080 是否被占用？
4. 依赖是否正确安装？（mvn clean install）

### Q: 前端无法连接后端？
A: 检查以下几点：
1. 后端是否正常运行？（访问 http://localhost:8080/api/scripts）
2. Vite 代理配置是否正确？（vite.config.js）
3. CORS 是否配置？（后端 CorsConfig.java）

### Q: 数据库表不存在？
A: 执行以下命令：
```bash
mysql -u root -p < database/schema.sql
```

### Q: 如何添加新功能？
A: 参考以下步骤：
1. 修改数据库表结构（如需要）
2. 创建/修改后端 Entity、Mapper、Service、Controller
3. 创建/修改前端 API、页面组件
4. 测试功能

---

## 🌟 核心优势

1. **✅ 完整的文档** - 超过 4 万字的详细文档
2. **✅ 生产级代码** - 遵循最佳实践和设计模式
3. **✅ 测试数据** - 30条剧本 + 35条评分记录
4. **✅ 专业算法** - SOP加权评分 + 熔断机制
5. **✅ 现代技术栈** - Vue 3 + Arco Design + Spring Boot
6. **✅ 易于扩展** - 清晰的架构和组件化设计

---

## 📞 获取帮助

### 文档支持
- 查看 [README.md](./README.md) - 项目总览
- 查看 [PROJECT_SUMMARY.md](./PROJECT_SUMMARY.md) - 完成总结
- 查看具体的开发文档

### 技术支持
- Email: team@deepdrama.com
- GitHub Issues: 提交问题和建议

---

## 🎉 开始使用

现在您已经了解了 DeepDrama 的基本信息，建议按照以下顺序开始：

1. ✅ **阅读完本文档** - 获取全局视野
2. ✅ **快速启动系统** - 实际体验功能
3. ✅ **深入学习文档** - 理解技术细节
4. ✅ **动手实践开发** - 添加新功能

祝您使用愉快！🚀

---

**创建日期**: 2025-12-15  
**版本**: v1.0.0  
**状态**: ✅ 生产就绪
