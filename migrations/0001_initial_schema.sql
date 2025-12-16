-- DeepDrama 剧本管理系统 - D1 数据库初始化

-- 用户表
CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT '评审专家',
  email TEXT,
  department TEXT,
  avatar TEXT,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);

-- 剧本表
CREATE TABLE IF NOT EXISTS scripts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  script_id TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  preview TEXT,
  file_url TEXT,
  tags TEXT, -- JSON array as TEXT
  source_type TEXT NOT NULL DEFAULT '内部团队',
  team TEXT,
  status TEXT NOT NULL DEFAULT '一卡初稿',
  is_project INTEGER NOT NULL DEFAULT 0,
  submit_date DATE,
  submit_user TEXT,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_scripts_status ON scripts(status);
CREATE INDEX IF NOT EXISTS idx_scripts_source_type ON scripts(source_type);
CREATE INDEX IF NOT EXISTS idx_scripts_is_project ON scripts(is_project);
CREATE INDEX IF NOT EXISTS idx_scripts_submit_date ON scripts(submit_date);

-- 评分表
CREATE TABLE IF NOT EXISTS ratings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  script_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  content_score REAL NOT NULL,
  market_score REAL NOT NULL,
  commercial_score REAL NOT NULL,
  compliance_score REAL NOT NULL,
  total_score REAL NOT NULL,
  grade TEXT NOT NULL,
  comments TEXT,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (script_id) REFERENCES scripts(script_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE INDEX IF NOT EXISTS idx_ratings_script_id ON ratings(script_id);
CREATE INDEX IF NOT EXISTS idx_ratings_user_id ON ratings(user_id);
CREATE INDEX IF NOT EXISTS idx_ratings_grade ON ratings(grade);
CREATE INDEX IF NOT EXISTS idx_ratings_created_at ON ratings(created_at);
