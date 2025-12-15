-- DeepDrama 剧本管理系统数据库初始化
-- MySQL 数据库结构

-- 创建数据库
CREATE DATABASE IF NOT EXISTS deepdrama DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE deepdrama;

-- 用户表
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` VARCHAR(50) NOT NULL COMMENT '用户ID',
  `name` VARCHAR(100) NOT NULL COMMENT '姓名',
  `role` VARCHAR(50) NOT NULL DEFAULT '评审专家' COMMENT '角色',
  `email` VARCHAR(100) COMMENT '邮箱',
  `department` VARCHAR(100) COMMENT '部门',
  `avatar` VARCHAR(255) COMMENT '头像URL',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_id` (`user_id`),
  KEY `idx_role` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 剧本表
DROP TABLE IF EXISTS `scripts`;
CREATE TABLE `scripts` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `script_id` VARCHAR(50) NOT NULL COMMENT '剧本编号(SP001格式)',
  `name` VARCHAR(200) NOT NULL COMMENT '剧本名称',
  `preview` TEXT COMMENT '剧本简介',
  `file_url` VARCHAR(500) COMMENT '飞书文档链接',
  `tags` JSON COMMENT '标签(JSON数组)',
  `source_type` VARCHAR(50) NOT NULL DEFAULT '内部团队' COMMENT '来源类型',
  `team` VARCHAR(100) COMMENT '所属团队',
  `status` VARCHAR(50) NOT NULL DEFAULT '一卡初稿' COMMENT '剧本状态',
  `is_project` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否立项(0否1是)',
  `submit_date` DATE COMMENT '提交日期',
  `submit_user` VARCHAR(100) COMMENT '提交人',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_script_id` (`script_id`),
  KEY `idx_status` (`status`),
  KEY `idx_source_type` (`source_type`),
  KEY `idx_is_project` (`is_project`),
  KEY `idx_submit_date` (`submit_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='剧本表';

-- 评分表 (核心表 - 支持SOP加权算法)
DROP TABLE IF EXISTS `ratings`;
CREATE TABLE `ratings` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `script_id` VARCHAR(50) NOT NULL COMMENT '剧本编号',
  `user_id` VARCHAR(50) COMMENT '评分人用户ID',
  `user_name` VARCHAR(100) NOT NULL COMMENT '评分人姓名',
  `user_role` VARCHAR(50) DEFAULT '评审专家' COMMENT '评分人角色',
  `content_score` DECIMAL(5,2) NOT NULL DEFAULT 0.00 COMMENT '内容评分(0-100)',
  `market_score` DECIMAL(5,2) NOT NULL DEFAULT 0.00 COMMENT '市场评分(0-100)',
  `compliance_score` DECIMAL(5,2) NOT NULL DEFAULT 0.00 COMMENT '合规评分(0-100)',
  `commercial_score` DECIMAL(5,2) NOT NULL DEFAULT 0.00 COMMENT '商业评分(0-100)',
  `total_score` DECIMAL(5,2) NOT NULL DEFAULT 0.00 COMMENT '加权总分',
  `grade` VARCHAR(10) NOT NULL DEFAULT 'D' COMMENT '评级(S/A/B/C/D)',
  `comments` TEXT COMMENT '评分意见',
  `rating_date` DATE NOT NULL COMMENT '评分日期',
  `is_system_import` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否系统导入(0否1是)',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_script_id` (`script_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_rating_date` (`rating_date`),
  KEY `idx_grade` (`grade`),
  KEY `idx_total_score` (`total_score`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='评分表';
