<template>
  <div id="app">
    <a-layout class="layout">
      <!-- 顶部导航 -->
      <a-layout-header class="header">
        <div class="header-content">
          <div class="logo">
            <icon-star />
            <span class="logo-text">DeepDrama</span>
            <span class="subtitle">剧本管理系统</span>
          </div>
          <div class="user-info">
            <a-avatar>
              <icon-user />
            </a-avatar>
            <span class="username">管理员</span>
          </div>
        </div>
      </a-layout-header>

      <a-layout>
        <!-- 侧边栏 -->
        <a-layout-sider :width="220" class="sider">
          <a-menu :default-selected-keys="['dashboard']" @menu-item-click="handleMenuClick">
            <a-menu-item key="dashboard">
              <icon-dashboard />
              数据看板
            </a-menu-item>
            <a-menu-item key="scripts">
              <icon-book />
              剧本管理
            </a-menu-item>
            <a-menu-item key="leaderboard">
              <icon-trophy />
              剧本排行
            </a-menu-item>
          </a-menu>
        </a-layout-sider>

        <!-- 主内容区 -->
        <a-layout-content class="content">
          <!-- 数据看板 -->
          <div v-if="currentPage === 'dashboard'" class="page">
            <h2 class="page-title">
              <icon-dashboard />
              数据看板
            </h2>

            <!-- KPI卡片 -->
            <a-row :gutter="16" class="kpi-row">
              <a-col :span="6">
                <a-card class="kpi-card kpi-blue">
                  <a-statistic 
                    title="剧本总库" 
                    :value="stats.totalScripts"
                    :value-style="{ color: '#165DFF', fontSize: '32px', fontWeight: 'bold' }"
                  >
                    <template #prefix>
                      <icon-book :size="24" />
                    </template>
                  </a-statistic>
                </a-card>
              </a-col>
              <a-col :span="6">
                <a-card class="kpi-card kpi-green">
                  <a-statistic 
                    title="立项转化率" 
                    :value="stats.conversionRate"
                    suffix="%"
                    :value-style="{ color: '#00B42A', fontSize: '32px', fontWeight: 'bold' }"
                  >
                    <template #prefix>
                      <icon-check :size="24" />
                    </template>
                  </a-statistic>
                </a-card>
              </a-col>
              <a-col :span="6">
                <a-card class="kpi-card kpi-orange">
                  <a-statistic 
                    title="待办积压" 
                    :value="stats.pendingRating"
                    :value-style="{ color: '#FF7D00', fontSize: '32px', fontWeight: 'bold' }"
                  >
                    <template #prefix>
                      <span style="font-size: 24px;">⏰</span>
                    </template>
                  </a-statistic>
                </a-card>
              </a-col>
              <a-col :span="6">
                <a-card class="kpi-card kpi-purple">
                  <a-statistic 
                    title="平均质量分" 
                    :value="stats.avgScore"
                    :value-style="{ color: '#722ED1', fontSize: '32px', fontWeight: 'bold' }"
                  >
                    <template #prefix>
                      <icon-star :size="24" />
                    </template>
                  </a-statistic>
                </a-card>
              </a-col>
            </a-row>

            <!-- 图表区域 -->
            <a-row :gutter="16" style="margin-top: 16px;">
              <a-col :span="8">
                <a-card title="评级漏斗" :bordered="true">
                  <div ref="gradeChart" style="height: 300px;"></div>
                </a-card>
              </a-col>
              <a-col :span="8">
                <a-card title="来源分析" :bordered="true">
                  <div ref="sourceChart" style="height: 300px;"></div>
                </a-card>
              </a-col>
              <a-col :span="8">
                <a-card title="状态分布" :bordered="true">
                  <div ref="statusChart" style="height: 300px;"></div>
                </a-card>
              </a-col>
            </a-row>
          </div>

          <!-- 剧本管理 -->
          <div v-if="currentPage === 'scripts'" class="page">
            <h2 class="page-title">
              <icon-book />
              剧本管理
            </h2>

            <!-- 快捷筛选 -->
            <a-radio-group v-model="quickFilter" type="button" class="quick-filter">
              <a-radio value="all">全部 ({{ getTabCount('all') }})</a-radio>
              <a-radio value="pending">待评分 ({{ getTabCount('pending') }})</a-radio>
              <a-radio value="sLevel">S级潜力 ({{ getTabCount('sLevel') }})</a-radio>
              <a-radio value="project">已立项 ({{ getTabCount('project') }})</a-radio>
            </a-radio-group>

            <!-- 筛选工具栏 -->
            <a-card style="margin: 16px 0;">
              <a-space size="medium">
                <a-input-search
                  v-model="searchText"
                  placeholder="搜索剧本名称或编号"
                  style="width: 300px;"
                />
                <a-select v-model="filterStatus" placeholder="全部状态" style="width: 150px;" allow-clear>
                  <a-option value="">全部状态</a-option>
                  <a-option v-for="s in statusOptions" :key="s" :value="s">{{ s }}</a-option>
                </a-select>
                <a-select v-model="filterSource" placeholder="全部来源" style="width: 150px;" allow-clear>
                  <a-option value="">全部来源</a-option>
                  <a-option v-for="s in sourceOptions" :key="s" :value="s">{{ s }}</a-option>
                </a-select>
                <a-button @click="resetFilters">
                  <template #icon><icon-refresh /></template>
                  重置
                </a-button>
                <a-button type="primary">
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
                :pagination="{ pageSize: 10 }"
              >
                <template #scriptId="{ record }">
                  <span class="mono-font">{{ record.scriptId }}</span>
                </template>
                <template #grade="{ record }">
                  <a-tag v-if="getLatestRating(record)" 
                         :color="getGradeColor(getLatestRating(record).grade)">
                    {{ getLatestRating(record).grade }}
                  </a-tag>
                  <span v-else style="color: #999;">待评分</span>
                </template>
                <template #totalScore="{ record }">
                  <span v-if="getLatestRating(record)" class="score-text">
                    {{ getLatestRating(record).totalScore }}
                  </span>
                  <span v-else style="color: #999;">-</span>
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
                <template #isProject="{ record }">
                  <a-tag v-if="record.isProject" color="green">
                    <icon-check />已立项
                  </a-tag>
                  <span v-else style="color: #999;">-</span>
                </template>
                <template #operations="{ record }">
                  <a-space>
                    <a-button type="text" size="small">
                      <icon-eye />
                    </a-button>
                    <a-button type="text" size="small">
                      <icon-star />
                    </a-button>
                    <a-button type="text" size="small">
                      <icon-edit />
                    </a-button>
                    <a-button type="text" size="small" status="danger">
                      <icon-delete />
                    </a-button>
                  </a-space>
                </template>
              </a-table>
            </a-card>
          </div>

          <!-- 剧本排行 -->
          <div v-if="currentPage === 'leaderboard'" class="page">
            <h2 class="page-title">
              <icon-trophy />
              剧本排行
            </h2>

            <a-card>
              <a-table 
                :columns="leaderboardColumns" 
                :data="leaderboard"
                :pagination="false"
              >
                <template #rank="{ rowIndex }">
                  <span v-if="rowIndex === 0" style="font-size: 24px;">🥇</span>
                  <span v-else-if="rowIndex === 1" style="font-size: 24px;">🥈</span>
                  <span v-else-if="rowIndex === 2" style="font-size: 24px;">🥉</span>
                  <span v-else class="rank-number">{{ rowIndex + 1 }}</span>
                </template>
                <template #name="{ record }">
                  <div>
                    <div class="script-name">{{ record.name }}</div>
                    <div v-if="record.grade === 'S'" class="hot-label">
                      🔥 爆款预测
                    </div>
                  </div>
                </template>
                <template #grade="{ record }">
                  <a-tag :color="getGradeColor(record.grade)" style="font-size: 14px; padding: 4px 12px;">
                    {{ record.grade }}级
                  </a-tag>
                </template>
                <template #totalScore="{ record }">
                  <span class="score-large">{{ record.totalScore }}</span>
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
              </a-table>
            </a-card>
          </div>
        </a-layout-content>
      </a-layout>
    </a-layout>
  </div>
</template>


<style scoped>
* {
  box-sizing: border-box;
}

.layout {
  min-height: 100vh;
}

.header {
  background: #1d2129;
  padding: 0;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 24px;
  height: 100%;
}

.logo {
  display: flex;
  align-items: center;
  gap: 12px;
  color: #fff;
  font-size: 20px;
  font-weight: bold;
}

.logo-text {
  font-size: 20px;
}

.subtitle {
  font-size: 14px;
  color: #86909c;
  font-weight: normal;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #fff;
}

.username {
  font-size: 14px;
}

.sider {
  background: #fff;
  border-right: 1px solid #e5e6eb;
}

.content {
  background: #f2f3f5;
  padding: 24px;
  min-height: calc(100vh - 60px);
}

.page {
  min-height: 100%;
}

.page-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 20px;
  margin-bottom: 16px;
  color: #1d2129;
}

.kpi-row {
  margin-bottom: 16px;
}

.kpi-card {
  border-radius: 8px;
  border: 1px solid #e5e6eb;
}

.kpi-blue {
  background: linear-gradient(135deg, #e8f4ff 0%, #f0f9ff 100%);
}

.kpi-green {
  background: linear-gradient(135deg, #e8f8f0 0%, #f0fdf4 100%);
}

.kpi-orange {
  background: linear-gradient(135deg, #fff3e6 0%, #fffbf0 100%);
}

.kpi-purple {
  background: linear-gradient(135deg, #f3e8ff 0%, #faf5ff 100%);
}

.quick-filter {
  margin-bottom: 16px;
}

.mono-font {
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
  font-weight: 600;
  color: #165DFF;
}

.score-text {
  font-size: 16px;
  font-weight: bold;
  color: #165DFF;
}

.score-large {
  font-size: 20px;
  font-weight: bold;
  color: #165DFF;
}

.rank-number {
  font-size: 18px;
  font-weight: bold;
  color: #4e5969;
}

.script-name {
  font-weight: 500;
  color: #1d2129;
  margin-bottom: 4px;
}

.hot-label {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  color: #f53f3f;
  font-size: 12px;
  font-weight: 500;
}
</style>
