-- DeepDrama 测试数据
USE deepdrama;

-- 用户数据
INSERT INTO `users` (`user_id`, `name`, `role`, `email`, `department`) VALUES 
  ('U001', '张主编', '主编', 'zhang@deepdrama.com', '内容部'),
  ('U002', '李制片', '制片方', 'li@deepdrama.com', '制作部'),
  ('U003', '王编剧', '编剧', 'wang@deepdrama.com', '创作部'),
  ('U004', '陈审核', '审核专家', 'chen@deepdrama.com', '合规部'),
  ('U005', '系统导入', '系统', 'system@deepdrama.com', '系统');

-- 剧本数据 (30条测试数据)
INSERT INTO `scripts` (`script_id`, `name`, `preview`, `file_url`, `tags`, `source_type`, `team`, `status`, `is_project`, `submit_date`, `submit_user`) VALUES 
  ('SP001', '总裁的替嫁甜妻', '霸道总裁爱上替嫁新娘，甜蜜虐恋', 'https://feishu.cn/doc/sp001', '["女频","甜宠","付费"]', '内部团队', 'A组编剧团', '完整剧本', 1, '2025-06-15', '王编剧'),
  ('SP002', '重生之商业帝国', '商界精英重生回到创业初期', 'https://feishu.cn/doc/sp002', '["男频","商战","付费"]', '内部团队', 'B组编剧团', '终稿(已立项)', 1, '2025-07-20', '张主编'),
  ('SP003', '闪婚老公是大佬', '契约婚姻遇上真爱', 'https://feishu.cn/doc/sp003', '["女频","甜宠","爆款引擎"]', '外部投稿', NULL, '改稿中', 0, '2025-08-10', '李制片'),
  ('SP004', '战神归来', '退役特种兵回归都市', 'https://feishu.cn/doc/sp004', '["男频","都市","免费"]', '合作编剧', 'C组编剧团', '一卡初稿', 0, '2025-09-05', '王编剧'),
  ('SP005', '豪门弃妇逆袭记', '被抛弃的豪门少奶奶华丽归来', 'https://feishu.cn/doc/sp005', '["女频","复仇","付费"]', '内部团队', 'A组编剧团', '完整剧本', 1, '2025-10-01', '张主编'),
  ('SP006', '穿越之农门医女', '现代医生穿越古代', 'https://feishu.cn/doc/sp006', '["女频","穿越","免费"]', '版权采购', NULL, '改稿中', 0, '2025-10-15', '李制片'),
  ('SP007', '神豪系统', '获得神豪系统后的逆袭人生', 'https://feishu.cn/doc/sp007', '["男频","系统","付费"]', '内部团队', 'B组编剧团', '一卡初稿', 0, '2025-11-01', '王编剧'),
  ('SP008', '冷面王爷的心尖宠', '穿书女主攻略冷面王爷', 'https://feishu.cn/doc/sp008', '["女频","古言","爆款引擎"]', '外部投稿', NULL, '完整剧本', 0, '2025-11-10', '张主编'),
  ('SP009', '龙王殿', '龙王归来复仇之路', 'https://feishu.cn/doc/sp009', '["男频","都市","付费"]', '合作编剧', 'A组编剧团', '终稿(已立项)', 1, '2025-11-15', '李制片'),
  ('SP010', '全能女神', '职场女强人的爱情故事', 'https://feishu.cn/doc/sp010', '["女频","职场","免费"]', '内部团队', 'C组编剧团', '改稿中', 0, '2025-11-20', '王编剧'),
  ('SP011', '赘婿当道', '上门女婿的逆袭之路', 'https://feishu.cn/doc/sp011', '["男频","都市","付费"]', '内部团队', 'A组编剧团', '完整剧本', 0, '2025-11-25', '张主编'),
  ('SP012', '千金归来', '真千金归来复仇', 'https://feishu.cn/doc/sp012', '["女频","复仇","爆款引擎"]', '外部投稿', NULL, '一卡初稿', 0, '2025-11-28', '李制片'),
  ('SP013', '透视神医', '获得透视能力的小医生', 'https://feishu.cn/doc/sp013', '["男频","都市","免费"]', '版权采购', NULL, '改稿中', 0, '2025-12-01', '王编剧'),
  ('SP014', '替嫁新娘的复仇', '被迫替嫁后的复仇计划', 'https://feishu.cn/doc/sp014', '["女频","复仇","付费"]', '内部团队', 'B组编剧团', '完整剧本', 1, '2025-12-03', '张主编'),
  ('SP015', '都市最强战神', '退伍兵王回归都市', 'https://feishu.cn/doc/sp015', '["男频","都市","付费"]', '合作编剧', 'C组编剧团', '一卡初稿', 0, '2025-12-05', '李制片'),
  ('SP016', '闪婚甜妻超大牌', '闪婚后发现老公是隐藏大佬', 'https://feishu.cn/doc/sp016', '["女频","甜宠","爆款引擎"]', '内部团队', 'A组编剧团', '终稿(已立项)', 1, '2025-12-06', '王编剧'),
  ('SP017', '重生之都市修仙', '修仙者重生现代都市', 'https://feishu.cn/doc/sp017', '["男频","修仙","付费"]', '外部投稿', NULL, '改稿中', 0, '2025-12-07', '张主编'),
  ('SP018', '宠妃无度', '穿越古代成为宠妃', 'https://feishu.cn/doc/sp018', '["女频","古言","免费"]', '版权采购', NULL, '一卡初稿', 0, '2025-12-08', '李制片'),
  ('SP019', '神级高手在都市', '隐世高手回归都市', 'https://feishu.cn/doc/sp019', '["男频","都市","付费"]', '内部团队', 'B组编剧团', '完整剧本', 0, '2025-12-09', '王编剧'),
  ('SP020', '豪门替嫁小娇妻', '替嫁入豪门的甜蜜日常', 'https://feishu.cn/doc/sp020', '["女频","甜宠","付费"]', '合作编剧', 'A组编剧团', '改稿中', 0, '2025-12-10', '张主编'),
  ('SP021', '最强狂兵', '特种兵回归复仇', 'https://feishu.cn/doc/sp021', '["男频","都市","爆款引擎"]', '内部团队', 'C组编剧团', '完整剧本', 1, '2025-12-10', '李制片'),
  ('SP022', '重生娇妻攻略', '重生后的甜蜜复仇', 'https://feishu.cn/doc/sp022', '["女频","重生","付费"]', '外部投稿', NULL, '一卡初稿', 0, '2025-12-11', '王编剧'),
  ('SP023', '无敌剑神', '剑道至尊重生归来', 'https://feishu.cn/doc/sp023', '["男频","玄幻","免费"]', '版权采购', NULL, '改稿中', 0, '2025-12-11', '张主编'),
  ('SP024', '总裁大人请放手', '契约恋爱变真爱', 'https://feishu.cn/doc/sp024', '["女频","甜宠","付费"]', '内部团队', 'A组编剧团', '完整剧本', 0, '2025-12-12', '李制片'),
  ('SP025', '医道圣手', '神医回归都市', 'https://feishu.cn/doc/sp025', '["男频","都市","付费"]', '合作编剧', 'B组编剧团', '一卡初稿', 0, '2025-12-12', '王编剧'),
  ('SP026', '霸总的隐婚妻', '隐婚后被霸总宠上天', 'https://feishu.cn/doc/sp026', '["女频","甜宠","爆款引擎"]', '内部团队', 'C组编剧团', '终稿(已立项)', 1, '2025-12-13', '张主编'),
  ('SP027', '至尊龙婿', '龙国至尊回归', 'https://feishu.cn/doc/sp027', '["男频","都市","付费"]', '外部投稿', NULL, '改稿中', 0, '2025-12-13', '李制片'),
  ('SP028', '复仇千金归来', '真千金复仇归来', 'https://feishu.cn/doc/sp028', '["女频","复仇","付费"]', '版权采购', NULL, '完整剧本', 0, '2025-12-14', '王编剧'),
  ('SP029', '绝世战神', '战神归来震惊全城', 'https://feishu.cn/doc/sp029', '["男频","都市","免费"]', '内部团队', 'A组编剧团', '一卡初稿', 0, '2025-12-14', '张主编'),
  ('SP030', '闪婚后大佬宠上瘾', '闪婚总裁甜蜜宠妻', 'https://feishu.cn/doc/sp030', '["女频","甜宠","爆款引擎"]', '合作编剧', 'B组编剧团', '完整剧本', 0, '2025-12-15', '李制片');

-- 评分数据 (多样化评分，包含历史评分)
-- SP001 - 总裁的替嫁甜妻 (S级)
INSERT INTO `ratings` (`script_id`, `user_id`, `user_name`, `user_role`, `content_score`, `market_score`, `compliance_score`, `commercial_score`, `total_score`, `grade`, `comments`, `rating_date`, `is_system_import`) VALUES 
  ('SP001', 'U001', '张主编', '主编', 92.00, 95.00, 90.00, 88.00, 91.70, 'S', '女频甜宠题材热门，剧情节奏紧凑，付费点设置合理', '2025-06-20', 0),
  ('SP001', 'U002', '李制片', '制片方', 90.00, 92.00, 95.00, 90.00, 91.40, 'S', '制作成本可控，预期ROI高，建议尽快立项', '2025-06-22', 0);

-- SP002 - 重生之商业帝国 (S级)
INSERT INTO `ratings` (`script_id`, `user_id`, `user_name`, `user_role`, `content_score`, `market_score`, `compliance_score`, `commercial_score`, `total_score`, `grade`, `comments`, `rating_date`, `is_system_import`) VALUES 
  ('SP002', 'U001', '张主编', '主编', 95.00, 90.00, 92.00, 93.00, 92.90, 'S', '商战题材优质，情节紧凑，爽点密集', '2025-07-25', 0),
  ('SP002', 'U002', '李制片', '制片方', 93.00, 88.00, 95.00, 95.00, 92.60, 'S', '商业价值高，已安排优先立项', '2025-07-28', 0);

-- SP003 - 闪婚老公是大佬 (A级)
INSERT INTO `ratings` (`script_id`, `user_id`, `user_name`, `user_role`, `content_score`, `market_score`, `compliance_score`, `commercial_score`, `total_score`, `grade`, `comments`, `rating_date`, `is_system_import`) VALUES 
  ('SP003', 'U001', '张主编', '主编', 85.00, 88.00, 90.00, 82.00, 85.40, 'A', '甜宠元素到位，需要加强情节转折', '2025-08-15', 0);

-- SP004 - 战神归来 (B级)
INSERT INTO `ratings` (`script_id`, `user_id`, `user_name`, `user_role`, `content_score`, `market_score`, `compliance_score`, `commercial_score`, `total_score`, `grade`, `comments`, `rating_date`, `is_system_import`) VALUES 
  ('SP004', 'U001', '张主编', '主编', 75.00, 78.00, 85.00, 72.00, 76.10, 'B', '题材普通，需要增加差异化元素', '2025-09-10', 0);

-- SP005 - 豪门弃妇逆袭记 (S级)
INSERT INTO `ratings` (`script_id`, `user_id`, `user_name`, `user_role`, `content_score`, `market_score`, `compliance_score`, `commercial_score`, `total_score`, `grade`, `comments`, `rating_date`, `is_system_import`) VALUES 
  ('SP005', 'U001', '张主编', '主编', 92.00, 94.00, 88.00, 90.00, 91.60, 'S', '复仇爽文套路成熟，女性受众明确', '2025-10-05', 0),
  ('SP005', 'U002', '李制片', '制片方', 90.00, 92.00, 90.00, 92.00, 90.80, 'S', '预计收益可观，建议立项', '2025-10-08', 0);

-- SP006 - 穿越之农门医女 (B级)
INSERT INTO `ratings` (`script_id`, `user_id`, `user_name`, `user_role`, `content_score`, `market_score`, `compliance_score`, `commercial_score`, `total_score`, `grade`, `comments`, `rating_date`, `is_system_import`) VALUES 
  ('SP006', 'U001', '张主编', '主编', 78.00, 72.00, 90.00, 70.00, 75.80, 'B', '穿越题材饱和，需要创新元素', '2025-10-20', 0);

-- SP008 - 冷面王爷的心尖宠 (A级)
INSERT INTO `ratings` (`script_id`, `user_id`, `user_name`, `user_role`, `content_score`, `market_score`, `compliance_score`, `commercial_score`, `total_score`, `grade`, `comments`, `rating_date`, `is_system_import`) VALUES 
  ('SP008', 'U001', '张主编', '主编', 88.00, 85.00, 92.00, 80.00, 85.70, 'A', '古言穿书题材不错，女主人设讨喜', '2025-11-12', 0);

-- SP009 - 龙王殿 (S级)
INSERT INTO `ratings` (`script_id`, `user_id`, `user_name`, `user_role`, `content_score`, `market_score`, `compliance_score`, `commercial_score`, `total_score`, `grade`, `comments`, `rating_date`, `is_system_import`) VALUES 
  ('SP009', 'U001', '张主编', '主编', 90.00, 93.00, 85.00, 92.00, 90.50, 'S', '男频复仇题材经典，节奏把控好', '2025-11-18', 0),
  ('SP009', 'U002', '李制片', '制片方', 88.00, 90.00, 88.00, 95.00, 89.90, 'A', '商业价值高，已立项制作', '2025-11-20', 0);

-- SP010 - 全能女神 (C级)
INSERT INTO `ratings` (`script_id`, `user_id`, `user_name`, `user_role`, `content_score`, `market_score`, `compliance_score`, `commercial_score`, `total_score`, `grade`, `comments`, `rating_date`, `is_system_import`) VALUES 
  ('SP010', 'U001', '张主编', '主编', 68.00, 65.00, 90.00, 60.00, 67.10, 'C', '职场剧本缺乏吸引力，需要大幅修改', '2025-11-22', 0);

-- SP011 - 赘婿当道 (A级)
INSERT INTO `ratings` (`script_id`, `user_id`, `user_name`, `user_role`, `content_score`, `market_score`, `compliance_score`, `commercial_score`, `total_score`, `grade`, `comments`, `rating_date`, `is_system_import`) VALUES 
  ('SP011', 'U001', '张主编', '主编', 85.00, 88.00, 85.00, 85.00, 85.70, 'A', '赘婿题材成熟，情节设置合理', '2025-11-26', 0);

-- SP013 - 透视神医 (C级)
INSERT INTO `ratings` (`script_id`, `user_id`, `user_name`, `user_role`, `content_score`, `market_score`, `compliance_score`, `commercial_score`, `total_score`, `grade`, `comments`, `rating_date`, `is_system_import`) VALUES 
  ('SP013', 'U001', '张主编', '主编', 65.00, 68.00, 88.00, 62.00, 66.00, 'C', '套路老旧，缺乏新意', '2025-12-02', 0);

-- SP014 - 替嫁新娘的复仇 (S级)
INSERT INTO `ratings` (`script_id`, `user_id`, `user_name`, `user_role`, `content_score`, `market_score`, `compliance_score`, `commercial_score`, `total_score`, `grade`, `comments`, `rating_date`, `is_system_import`) VALUES 
  ('SP014', 'U001', '张主编', '主编', 91.00, 92.00, 90.00, 88.00, 90.40, 'S', '替嫁复仇双元素融合，女性受众喜爱', '2025-12-04', 0),
  ('SP014', 'U002', '李制片', '制片方', 89.00, 90.00, 92.00, 90.00, 89.60, 'A', '商业价值高，建议优先制作', '2025-12-05', 0);

-- SP016 - 闪婚甜妻超大牌 (S级)
INSERT INTO `ratings` (`script_id`, `user_id`, `user_name`, `user_role`, `content_score`, `market_score`, `compliance_score`, `commercial_score`, `total_score`, `grade`, `comments`, `rating_date`, `is_system_import`) VALUES 
  ('SP016', 'U001', '张主编', '主编', 93.00, 95.00, 90.00, 92.00, 92.70, 'S', '爆款潜质明显，甜宠元素拉满', '2025-12-07', 0),
  ('SP016', 'U002', '李制片', '制片方', 92.00, 93.00, 92.00, 94.00, 92.50, 'S', '优质甜宠剧本，已安排立项', '2025-12-08', 0);

-- SP017 - 重生之都市修仙 (B级)
INSERT INTO `ratings` (`script_id`, `user_id`, `user_name`, `user_role`, `content_score`, `market_score`, `compliance_score`, `commercial_score`, `total_score`, `grade`, `comments`, `rating_date`, `is_system_import`) VALUES 
  ('SP017', 'U001', '张主编', '主编', 78.00, 75.00, 85.00, 72.00, 76.40, 'B', '修仙元素融入都市不够自然，需要调整', '2025-12-08', 0);

-- SP019 - 神级高手在都市 (A级)
INSERT INTO `ratings` (`script_id`, `user_id`, `user_name`, `user_role`, `content_score`, `market_score`, `compliance_score`, `commercial_score`, `total_score`, `grade`, `comments`, `rating_date`, `is_system_import`) VALUES 
  ('SP019', 'U001', '张主编', '主编', 82.00, 85.00, 88.00, 80.00, 82.90, 'A', '都市高手题材经典，情节紧凑', '2025-12-10', 0);

-- SP020 - 豪门替嫁小娇妻 (B级)
INSERT INTO `ratings` (`script_id`, `user_id`, `user_name`, `user_role`, `content_score`, `market_score`, `compliance_score`, `commercial_score`, `total_score`, `grade`, `comments`, `rating_date`, `is_system_import`) VALUES 
  ('SP020', 'U001', '张主编', '主编', 75.00, 78.00, 90.00, 72.00, 76.20, 'B', '题材同质化严重，需要差异化处理', '2025-12-11', 0);

-- SP021 - 最强狂兵 (S级)
INSERT INTO `ratings` (`script_id`, `user_id`, `user_name`, `user_role`, `content_score`, `market_score`, `compliance_score`, `commercial_score`, `total_score`, `grade`, `comments`, `rating_date`, `is_system_import`) VALUES 
  ('SP021', 'U001', '张主编', '主编', 90.00, 92.00, 88.00, 91.00, 90.30, 'S', '男频爆款潜质，节奏把控好', '2025-12-11', 0),
  ('SP021', 'U002', '李制片', '制片方', 88.00, 90.00, 90.00, 93.00, 89.60, 'A', '商业价值高，已安排立项', '2025-12-12', 0);

-- SP023 - 无敌剑神 (C级)
INSERT INTO `ratings` (`script_id`, `user_id`, `user_name`, `user_role`, `content_score`, `market_score`, `compliance_score`, `commercial_score`, `total_score`, `grade`, `comments`, `rating_date`, `is_system_import`) VALUES 
  ('SP023', 'U001', '张主编', '主编', 68.00, 62.00, 88.00, 58.00, 66.00, 'C', '玄幻题材制作成本高，收益预期一般', '2025-12-12', 0);

-- SP024 - 总裁大人请放手 (A级)
INSERT INTO `ratings` (`script_id`, `user_id`, `user_name`, `user_role`, `content_score`, `market_score`, `compliance_score`, `commercial_score`, `total_score`, `grade`, `comments`, `rating_date`, `is_system_import`) VALUES 
  ('SP024', 'U001', '张主编', '主编', 85.00, 82.00, 90.00, 80.00, 84.00, 'A', '甜宠剧本中规中矩，可作为储备', '2025-12-13', 0);

-- SP026 - 霸总的隐婚妻 (S级)
INSERT INTO `ratings` (`script_id`, `user_id`, `user_name`, `user_role`, `content_score`, `market_score`, `compliance_score`, `commercial_score`, `total_score`, `grade`, `comments`, `rating_date`, `is_system_import`) VALUES 
  ('SP026', 'U001', '张主编', '主编', 92.00, 94.00, 90.00, 91.00, 91.90, 'S', '隐婚甜宠双热点，爆款潜质', '2025-12-13', 0),
  ('SP026', 'U002', '李制片', '制片方', 91.00, 92.00, 92.00, 93.00, 91.60, 'S', '已立项，优先制作', '2025-12-14', 0);

-- SP027 - 至尊龙婿 (B级)
INSERT INTO `ratings` (`script_id`, `user_id`, `user_name`, `user_role`, `content_score`, `market_score`, `compliance_score`, `commercial_score`, `total_score`, `grade`, `comments`, `rating_date`, `is_system_import`) VALUES 
  ('SP027', 'U001', '张主编', '主编', 75.00, 72.00, 85.00, 70.00, 74.50, 'B', '龙婿题材泛滥，需要独特卖点', '2025-12-14', 0);

-- SP028 - 复仇千金归来 (A级)
INSERT INTO `ratings` (`script_id`, `user_id`, `user_name`, `user_role`, `content_score`, `market_score`, `compliance_score`, `commercial_score`, `total_score`, `grade`, `comments`, `rating_date`, `is_system_import`) VALUES 
  ('SP028', 'U001', '张主编', '主编', 82.00, 85.00, 90.00, 80.00, 83.00, 'A', '复仇千金题材受欢迎，情节设置合理', '2025-12-14', 0);

-- SP030 - 闪婚后大佬宠上瘾 (A级)
INSERT INTO `ratings` (`script_id`, `user_id`, `user_name`, `user_role`, `content_score`, `market_score`, `compliance_score`, `commercial_score`, `total_score`, `grade`, `comments`, `rating_date`, `is_system_import`) VALUES 
  ('SP030', 'U001', '张主编', '主编', 86.00, 88.00, 90.00, 85.00, 86.50, 'A', '闪婚甜宠经典套路，完成度高', '2025-12-15', 0);

-- 系统导入的历史评分数据
INSERT INTO `ratings` (`script_id`, `user_id`, `user_name`, `user_role`, `content_score`, `market_score`, `compliance_score`, `commercial_score`, `total_score`, `grade`, `comments`, `rating_date`, `is_system_import`) VALUES 
  ('SP001', 'U005', '系统导入', '系统', 90.00, 90.00, 88.00, 85.00, 88.70, 'A', '历史评分数据导入', '2025-06-10', 1),
  ('SP002', 'U005', '系统导入', '系统', 88.00, 85.00, 90.00, 88.00, 87.50, 'A', '历史评分数据导入', '2025-07-15', 1),
  ('SP005', 'U005', '系统导入', '系统', 85.00, 88.00, 85.00, 82.00, 85.10, 'A', '历史评分数据导入', '2025-09-20', 1);

-- 添加合规否决的案例 (D级 - 熔断机制)
INSERT INTO `ratings` (`script_id`, `user_id`, `user_name`, `user_role`, `content_score`, `market_score`, `compliance_score`, `commercial_score`, `total_score`, `grade`, `comments`, `rating_date`, `is_system_import`) VALUES 
  ('SP013', 'U004', '陈审核', '审核专家', 70.00, 72.00, 55.00, 68.00, 68.20, 'D', '合规审核不通过，存在擦边风险，建议大幅修改后重新提交', '2025-12-03', 0);
