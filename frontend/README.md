# DeepDrama 前端项目

基于 Vue 3 + Arco Design + ECharts 构建的现代化前端应用。

## 📂 项目结构

```
frontend/
├── public/                    # 静态资源
├── src/
│   ├── views/                 # 页面组件
│   │   ├── Dashboard.vue      # 数据看板
│   │   ├── ScriptManagement.vue  # 剧本管理
│   │   └── Leaderboard.vue    # 剧本排行
│   ├── components/            # 通用组件
│   │   ├── RatingDrawer.vue   # 评分抽屉
│   │   ├── ScriptModal.vue    # 剧本编辑弹窗
│   │   └── RadarChart.vue     # 雷达图组件
│   ├── api/                   # API接口
│   │   ├── script.js          # 剧本接口
│   │   ├── rating.js          # 评分接口
│   │   └── stats.js           # 统计接口
│   ├── router/                # 路由配置
│   │   └── index.js
│   ├── stores/                # 状态管理 (Pinia)
│   │   └── app.js
│   ├── utils/                 # 工具函数
│   │   ├── request.js         # Axios封装
│   │   ├── gradeHelper.js     # 评级辅助函数
│   │   └── tagHelper.js       # 标签辅助函数
│   ├── styles/                # 样式文件
│   │   └── main.css
│   ├── App.vue                # 根组件
│   └── main.js                # 入口文件
├── index.html
├── vite.config.js            # Vite配置
└── package.json
```

## 🚀 快速开始

### 安装依赖
```bash
npm install
```

### 开发模式
```bash
npm run dev
```

访问 `http://localhost:5173`

### 生产构建
```bash
npm run build
```

### 预览生产构建
```bash
npm run preview
```

## 📦 核心依赖

### Arco Design Vue
```bash
npm install @arco-design/web-vue
```

### 使用示例
```vue
<template>
  <a-layout>
    <a-layout-sider>
      <a-menu :default-selected-keys="['dashboard']">
        <a-menu-item key="dashboard">
          <icon-dashboard />
          <span>数据看板</span>
        </a-menu-item>
      </a-menu>
    </a-layout-sider>
    <a-layout-content>
      <!-- 内容区域 -->
    </a-layout-content>
  </a-layout>
</template>
```

### ECharts
```bash
npm install echarts
```

### 使用示例
```javascript
import * as echarts from 'echarts';

const chart = echarts.init(document.getElementById('chart'));
chart.setOption({
  title: { text: '评级漏斗' },
  series: [{
    type: 'pie',
    data: [
      { name: 'S级', value: 5 },
      { name: 'A级', value: 10 }
    ]
  }]
});
```

## 🎨 Arco Design 主要组件使用

### 1. 布局组件
```vue
<a-layout class="layout">
  <a-layout-header>
    <div class="logo">DeepDrama</div>
  </a-layout-header>
  <a-layout>
    <a-layout-sider width="220">
      <!-- 侧边栏 -->
    </a-layout-sider>
    <a-layout-content>
      <!-- 主内容 -->
    </a-layout-content>
  </a-layout>
</a-layout>
```

### 2. 表格组件
```vue
<a-table 
  :columns="columns" 
  :data="dataSource"
  :pagination="pagination"
  @page-change="onPageChange"
>
  <template #status="{ record }">
    <a-tag :color="getStatusColor(record.status)">
      {{ record.status }}
    </a-tag>
  </template>
  <template #operations="{ record }">
    <a-button type="text" @click="handleEdit(record)">编辑</a-button>
    <a-button type="text" status="danger" @click="handleDelete(record)">
      删除
    </a-button>
  </template>
</a-table>
```

### 3. 表单组件
```vue
<a-form :model="form" @submit="handleSubmit">
  <a-form-item label="剧本名称" field="name" :rules="[{ required: true }]">
    <a-input v-model="form.name" placeholder="请输入剧本名称" />
  </a-form-item>
  
  <a-form-item label="来源类型" field="sourceType">
    <a-select v-model="form.sourceType">
      <a-option value="内部团队">内部团队</a-option>
      <a-option value="外部投稿">外部投稿</a-option>
    </a-select>
  </a-form-item>
  
  <a-form-item label="标签" field="tags">
    <a-checkbox-group v-model="form.tags">
      <a-checkbox value="男频">男频</a-checkbox>
      <a-checkbox value="女频">女频</a-checkbox>
      <a-checkbox value="付费">付费</a-checkbox>
    </a-checkbox-group>
  </a-form-item>
  
  <a-form-item>
    <a-button type="primary" html-type="submit">提交</a-button>
  </a-form-item>
</a-form>
```

### 4. 抽屉组件
```vue
<a-drawer
  v-model:visible="visible"
  title="剧本评分"
  width="560px"
  @ok="handleOk"
  @cancel="handleCancel"
>
  <div class="drawer-content">
    <!-- 评分表单 -->
    <a-form :model="ratingForm">
      <a-form-item label="内容评分 (40%)">
        <a-input-number 
          v-model="ratingForm.contentScore" 
          :min="0" 
          :max="100" 
        />
      </a-form-item>
      <!-- 其他评分项 -->
    </a-form>
    
    <!-- 历史评分记录 -->
    <div class="rating-history">
      <a-card v-for="rating in ratings" :key="rating.id">
        <div class="rating-header">
          <span>{{ rating.userName }}</span>
          <a-tag :color="getGradeColor(rating.grade)">
            {{ rating.grade }}
          </a-tag>
        </div>
        <div class="rating-scores">
          <span>总分: {{ rating.totalScore }}</span>
        </div>
      </a-card>
    </div>
  </div>
</a-drawer>
```

### 5. 弹窗组件
```vue
<a-modal
  v-model:visible="modalVisible"
  title="确认删除"
  @ok="handleDelete"
  @cancel="handleCancel"
>
  <p>确定要删除剧本《{{ currentScript.name }}》吗？</p>
  <p class="warning-text">此操作不可恢复</p>
</a-modal>
```

### 6. 消息提示
```javascript
import { Message } from '@arco-design/web-vue';

// 成功提示
Message.success('操作成功');

// 错误提示
Message.error('操作失败');

// 警告提示
Message.warning('请注意');

// 信息提示
Message.info('提示信息');
```

### 7. 标签组件
```vue
<a-space>
  <a-tag v-for="tag in tags" :key="tag" :color="getTagColor(tag)">
    {{ tag }}
  </a-tag>
</a-space>
```

### 8. 徽标组件
```vue
<a-badge :count="pendingCount" :dot="pendingCount > 0">
  <a-button>待评分</a-button>
</a-badge>
```

## 🎯 核心页面实现

### 1. 数据看板 (Dashboard.vue)

```vue
<template>
  <div class="dashboard">
    <!-- KPI卡片 -->
    <a-row :gutter="16" class="kpi-row">
      <a-col :span="6">
        <a-card class="kpi-card" :body-style="{ padding: '20px' }">
          <a-statistic 
            title="剧本总库" 
            :value="stats.totalScripts"
            :value-style="{ color: '#3f8600' }"
          >
            <template #prefix>
              <icon-book />
            </template>
          </a-statistic>
        </a-card>
      </a-col>
      <a-col :span="6">
        <a-card class="kpi-card">
          <a-statistic 
            title="立项转化率" 
            :value="stats.conversionRate"
            suffix="%"
          />
        </a-card>
      </a-col>
      <!-- 其他KPI卡片 -->
    </a-row>
    
    <!-- 图表区域 -->
    <a-row :gutter="16" class="chart-row">
      <a-col :span="8">
        <a-card title="评级漏斗">
          <div ref="gradeChartRef" style="height: 300px;"></div>
        </a-card>
      </a-col>
      <a-col :span="8">
        <a-card title="来源分析">
          <div ref="sourceChartRef" style="height: 300px;"></div>
        </a-card>
      </a-col>
      <a-col :span="8">
        <a-card title="质量趋势">
          <div ref="trendChartRef" style="height: 300px;"></div>
        </a-card>
      </a-col>
    </a-row>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import * as echarts from 'echarts';
import { getStats } from '@/api/stats';

const stats = ref({});
const gradeChartRef = ref(null);

onMounted(async () => {
  await loadStats();
  initCharts();
});

const loadStats = async () => {
  const res = await getStats();
  stats.value = res.data;
};

const initCharts = () => {
  const gradeChart = echarts.init(gradeChartRef.value);
  gradeChart.setOption({
    series: [{
      type: 'pie',
      radius: ['40%', '70%'],
      data: [
        { name: 'S级', value: 5, itemStyle: { color: '#722ED1' } },
        { name: 'A级', value: 10, itemStyle: { color: '#0FC6C2' } }
      ]
    }]
  });
};
</script>
```

### 2. 剧本管理 (ScriptManagement.vue)

```vue
<template>
  <div class="script-management">
    <!-- 快捷筛选 -->
    <a-radio-group v-model="quickFilter" type="button" class="quick-filter">
      <a-radio value="all">全部 ({{ getTabCount('all') }})</a-radio>
      <a-radio value="pending">待评分 ({{ getTabCount('pending') }})</a-radio>
      <a-radio value="sLevel">S级潜力 ({{ getTabCount('sLevel') }})</a-radio>
      <a-radio value="project">已立项 ({{ getTabCount('project') }})</a-radio>
    </a-radio-group>
    
    <!-- 高级筛选 -->
    <a-card class="filter-card">
      <a-form layout="inline">
        <a-form-item label="搜索">
          <a-input v-model="searchText" placeholder="剧本名称/编号" />
        </a-form-item>
        <a-form-item label="状态">
          <a-select v-model="filterStatus" placeholder="全部状态">
            <a-option value="">全部状态</a-option>
            <a-option v-for="s in statusOptions" :key="s" :value="s">
              {{ s }}
            </a-option>
          </a-select>
        </a-form-item>
        <!-- 其他筛选项 -->
      </a-form>
      <a-space class="filter-actions">
        <a-button @click="resetFilters">
          <template #icon><icon-refresh /></template>
          重置
        </a-button>
        <a-button type="primary" @click="showScriptModal('add')">
          <template #icon><icon-plus /></template>
          新增剧本
        </a-button>
      </a-space>
    </a-card>
    
    <!-- 剧本表格 -->
    <a-card>
      <a-table 
        :columns="columns" 
        :data="filteredScripts"
        :pagination="pagination"
      >
        <template #scriptId="{ record }">
          <span class="mono-font">{{ record.scriptId }}</span>
        </template>
        <template #grade="{ record }">
          <a-tag v-if="getLatestRating(record)" 
                 :color="getGradeColor(getLatestRating(record).grade)">
            {{ getLatestRating(record).grade }}
          </a-tag>
          <span v-else class="text-gray">待评分</span>
        </template>
        <template #tags="{ record }">
          <a-space>
            <a-tag v-for="tag in parseTags(record.tags)" 
                   :key="tag" 
                   :color="getTagColor(tag)">
              {{ tag }}
            </a-tag>
          </a-space>
        </template>
        <template #operations="{ record }">
          <a-space>
            <a-button type="text" @click="previewScript(record)">
              <icon-file />
            </a-button>
            <a-button type="text" @click="showRatingDrawer(record)">
              <icon-star />
            </a-button>
            <a-button type="text" @click="editScript(record)">
              <icon-edit />
            </a-button>
            <a-button type="text" status="danger" @click="deleteScript(record)">
              <icon-delete />
            </a-button>
          </a-space>
        </template>
      </a-table>
    </a-card>
    
    <!-- 评分抽屉 -->
    <RatingDrawer 
      v-model:visible="ratingDrawerVisible"
      :script="currentScript"
      @submit="onRatingSubmit"
    />
    
    <!-- 剧本编辑弹窗 -->
    <ScriptModal
      v-model:visible="scriptModalVisible"
      :mode="scriptModalMode"
      :script="currentScript"
      @submit="onScriptSubmit"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { Message } from '@arco-design/web-vue';
import { getScripts, deleteScript as deleteScriptApi } from '@/api/script';
import { getRatings } from '@/api/rating';

const scripts = ref([]);
const ratings = ref([]);
const quickFilter = ref('all');

const columns = [
  { title: '编号', dataIndex: 'scriptId', slotName: 'scriptId' },
  { title: '剧本名称', dataIndex: 'name' },
  { title: '评级', dataIndex: 'grade', slotName: 'grade' },
  { title: '总分', dataIndex: 'totalScore' },
  { title: '标签', dataIndex: 'tags', slotName: 'tags' },
  { title: '来源', dataIndex: 'sourceType' },
  { title: '团队', dataIndex: 'team' },
  { title: '状态', dataIndex: 'status' },
  { title: '操作', slotName: 'operations' }
];

const loadData = async () => {
  const [scriptsRes, ratingsRes] = await Promise.all([
    getScripts(),
    getRatings()
  ]);
  scripts.value = scriptsRes.data;
  ratings.value = ratingsRes.data;
};

onMounted(() => {
  loadData();
});
</script>
```

## 🔧 Vite配置

### vite.config.js
```javascript
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src')
    }
  },
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

## 📝 API封装

### utils/request.js
```javascript
import axios from 'axios';
import { Message } from '@arco-design/web-vue';

const request = axios.create({
  baseURL: '/api',
  timeout: 10000
});

// 请求拦截器
request.interceptors.request.use(
  config => {
    // 可以在这里添加token
    return config;
  },
  error => {
    return Promise.reject(error);
  }
);

// 响应拦截器
request.interceptors.response.use(
  response => {
    const res = response.data;
    if (res.code !== 200) {
      Message.error(res.message || '请求失败');
      return Promise.reject(new Error(res.message));
    }
    return res;
  },
  error => {
    Message.error(error.message || '网络错误');
    return Promise.reject(error);
  }
);

export default request;
```

### api/script.js
```javascript
import request from '@/utils/request';

export const getScripts = () => {
  return request.get('/scripts');
};

export const getScriptById = (id) => {
  return request.get(`/scripts/${id}`);
};

export const createScript = (data) => {
  return request.post('/scripts', data);
};

export const updateScript = (id, data) => {
  return request.put(`/scripts/${id}`, data);
};

export const deleteScript = (id) => {
  return request.delete(`/scripts/${id}`);
};
```

## 🎨 样式规范

### 评级颜色
```css
:root {
  --grade-s: #722ED1;
  --grade-a: #0FC6C2;
  --grade-b: #00B42A;
  --grade-c: #FF7D00;
  --grade-d: #F53F3F;
}

.grade-s { color: var(--grade-s); }
.grade-a { color: var(--grade-a); }
.grade-b { color: var(--grade-b); }
.grade-c { color: var(--grade-c); }
.grade-d { color: var(--grade-d); }
```

## 📱 响应式设计

```vue
<template>
  <a-row :gutter="[16, 16]">
    <a-col :xs="24" :sm="12" :md="8" :lg="6">
      <!-- 内容 -->
    </a-col>
  </a-row>
</template>
```

## 🔍 调试技巧

1. 使用 Vue DevTools
2. 查看 Network 请求
3. 使用 `console.log` 调试
4. 检查 Arco Design 组件文档

## 📞 技术支持

如有问题，请联系前端团队。
