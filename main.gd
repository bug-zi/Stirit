extends Control

const TOTAL_ORDERS := 5
const ROUND_SECONDS := 100.0
const INGREDIENT_MIN := 2
const INGREDIENT_MAX := 3
const SEASONING_MIN := 1
const SEASONING_MAX := 2
const AI_TIMEOUT_SECONDS := 20.0
const INITIAL_FUNDS := 666
const BASE_SERVICE_COST := 50
const SERVICE_COST_STEP := 12
const AI_CONFIG_PATH := "res://ai_config.local.json"
const USER_AI_CONFIG_PATH := "user://ai_config.json"
const SUPABASE_CONFIG_PATH := "res://supabase_config.local.json"
const USER_SESSION_PATH := "user://supabase_session.json"
const HOME_POSTER_PATH := "res://assets/poster_home.png"
const SUPABASE_PROFILE_TABLE := "profiles"
const SUPABASE_AVATAR_BUCKET := "avatars"
const AI_ENDPOINT_ENV := "AI_EVALUATION_URL"
const AI_TOKEN_ENV := "AI_EVALUATION_TOKEN"

const AI_PROVIDER_PRESETS := {
	"deepseek": {
		"label": "DeepSeek",
		"endpoint": "https://api.deepseek.com/chat/completions",
		"model": "deepseek-v4-flash"
	},
	"glm": {
		"label": "GLM",
		"endpoint": "https://open.bigmodel.cn/api/paas/v4/chat/completions",
		"model": "glm-4.7-flash"
	},
	"custom": {
		"label": "自定义",
		"endpoint": "",
		"model": ""
	}
}

const LEVEL_TITLES := [
	{"level": 1, "exp": 0, "title": "街边新厨"},
	{"level": 2, "exp": 40, "title": "稳锅学徒"},
	{"level": 3, "exp": 90, "title": "风味厨师"},
	{"level": 4, "exp": 160, "title": "人气主厨"},
	{"level": 5, "exp": 250, "title": "AI 食神候补"}
]

const BUFF_POOL := [
	{"id": "tip_bonus", "name": "好评小费", "description": "A/S 评价额外获得 20 金币。"},
	{"id": "cost_control", "name": "成本控制", "description": "后续出锅成本降低 10%。"},
	{"id": "signature_price", "name": "招牌溢价", "description": "S 级菜品报酬提高 30%。"},
	{"id": "mistake_insurance", "name": "失误补救", "description": "第一次 D/F 评价按 C 级报酬结算。"},
	{"id": "streak_heat", "name": "连击热锅", "description": "A/S 连击报酬倍率额外提高 5%。"}
]
const COLOR_BG := Color("#1a1a2e")
const COLOR_PRIMARY := Color("#ff6b6b")
const COLOR_SECONDARY := Color("#ffd93d")
const COLOR_FOOD := Color("#f59e4b")
const COLOR_ACCENT := Color("#00d2ff")
const COLOR_TEXT := Color("#ffffff")
const COLOR_TEXT_MUTED := Color("#8888aa")

const CHARACTER_SHEET_COLS := 4
const CHARACTER_SHEET_ROWS := 4
const CHARACTER_IDLE_SHEETS := [
	"res://assets/characters/pixel_character_1/Idle/Blue_Head_Idle-Sheet.png",
	"res://assets/characters/pixel_character_1/Idle/Orange_Head_Idle-Sheet.png",
	"res://assets/characters/pixel_character_1/Idle/Pink_Head_Idle-Sheet.png"
]
const CHARACTER_WALK_SHEETS := [
	"res://assets/characters/pixel_character_1/Walking/Blue_Head_Walking-Sheet.png",
	"res://assets/characters/pixel_character_1/Walking/Orange_Head_Walking-Sheet.png",
	"res://assets/characters/pixel_character_1/Walking/Pink_Head_Walking-Sheet.png"
]
const CHARACTER_ROW_BACK := 0
const CHARACTER_ROW_RIGHT := 1
const CHARACTER_ROW_FRONT := 2
const CHARACTER_ROW_LEFT := 3
const ITEM_ICON_DIR := "res://assets/ingredients"
const APPROACH_CUTSCENE_SCENE := "res://scenes/approach_cutscene.tscn"
const CUSTOMER_PANEL_LEFT_SCENE := "res://scenes/customer_panel_left.tscn"

const INGREDIENTS := [
	{"id": "ingredient_noodle", "name": "泡面", "tags": ["便宜", "学生", "深夜", "续命", "敷衍"], "description": "深夜救命粮，便宜但很有故事。"},
	{"id": "ingredient_rice", "name": "米饭", "tags": ["饱腹", "家常", "稳定", "温暖", "安全"], "description": "所有怪菜的缓冲垫，让离谱也能落地。"},
	{"id": "ingredient_egg", "name": "鸡蛋", "tags": ["早餐", "温暖", "稳定", "治愈", "百搭"], "description": "朴素但可靠，像食堂阿姨最后多给的一勺。"},
	{"id": "ingredient_milk_tea_jelly", "name": "奶茶冻", "tags": ["甜", "学生", "快乐", "安慰", "幼稚"], "description": "甜得很直接，像群聊里的表情包。"},
	{"id": "ingredient_dumpling", "name": "速冻饺子", "tags": ["饱腹", "家常", "深夜", "安全", "安慰"], "description": "宿舍冰箱里的最后底气。"},
	{"id": "ingredient_coffee_jelly", "name": "咖啡冻", "tags": ["续命", "提神", "苦", "焦虑", "清醒"], "description": "把咖啡做成能咀嚼的 deadline。"},
	{"id": "ingredient_tofu", "name": "豆腐", "tags": ["清淡", "温和", "养生", "安全", "软糯"], "description": "负责让整锅东西看起来还可以被原谅。"},
	{"id": "ingredient_fried_chicken", "name": "炸鸡块", "tags": ["罪恶", "快乐", "夜市", "油炸", "热烈"], "description": "快乐很短，但酥脆是真的。"},
	{"id": "ingredient_potato_mash", "name": "土豆泥", "tags": ["饱腹", "安慰", "温暖", "软糯", "治愈"], "description": "把情绪压平一点，再撒点盐。"},
	{"id": "ingredient_oatmeal", "name": "燕麦粥", "tags": ["养生", "早餐", "清淡", "自律", "克制"], "description": "像一句暂时还算可信的健康宣言。"},
	{"id": "ingredient_hotdog", "name": "热狗肠", "tags": ["便宜", "夜市", "学生", "重口", "饱腹"], "description": "路边摊气质很足，精致程度很少。"},
	{"id": "ingredient_tomato", "name": "小番茄", "tags": ["酸甜", "清爽", "轻盈", "体面", "养生"], "description": "在怪菜里努力保持清白。"},
	{"id": "ingredient_rice_cake", "name": "年糕", "tags": ["弹牙", "夜市", "甜", "饱腹", "软糯"], "description": "Q弹到底，嚼着嚼着就忘了烦恼。"},
	{"id": "ingredient_cheese_slice", "name": "芝士片", "tags": ["浓郁", "解压", "体面", "拉丝", "快乐"], "description": "拉丝越长，烦恼越短。"},
	{"id": "ingredient_luncheon_meat", "name": "午餐肉", "tags": ["肉食", "便宜", "学生", "怀旧", "饱腹"], "description": "学生时代的硬通货，切片就能撑起一顿。"},
	{"id": "ingredient_corn", "name": "玉米粒", "tags": ["甜", "轻盈", "百搭", "快乐", "清爽"], "description": "一颗颗小炸弹，在你嘴里爆出轻松。"},
	{"id": "ingredient_bacon", "name": "培根碎", "tags": ["肉食", "罪恶", "早餐", "香脆", "热烈"], "description": "烟熏味的快乐，犯规但从不道歉。"},
	{"id": "ingredient_seaweed", "name": "海苔碎", "tags": ["海味", "轻盈", "提神", "清爽", "安全"], "description": "大海的碎片，咸鲜又安静。"},
	{"id": "ingredient_sweet_potato", "name": "红薯泥", "tags": ["温暖", "甜", "饱腹", "治愈", "软糯"], "description": "秋天的味道，把冷天和坏心情一起焐热。"},
	{"id": "ingredient_century_egg", "name": "皮蛋", "tags": ["冒险", "奇怪", "争议", "上头", "深夜"], "description": "爱它的人觉得是仙丹，怕它的人觉得是挑战。"},
	{"id": "ingredient_mustard_pickle", "name": "榨菜丝", "tags": ["便宜", "学生", "酸爽", "解压", "怀旧"], "description": "嘎嘣脆的穷学生记忆，一筷子回到食堂。"},
	{"id": "ingredient_crouton", "name": "面包丁", "tags": ["香脆", "简单", "百搭", "安全", "轻盈"], "description": "不抢戏的配角，但少了它锅底少点心安。"},
	{"id": "ingredient_crab_stick", "name": "蟹味棒", "tags": ["海味", "便宜", "快乐", "夜市", "学生"], "description": "假装是螃蟹，但其实快乐不需要太贵。"},
	{"id": "ingredient_enoki", "name": "金针菇", "tags": ["弹牙", "清淡", "养生", "轻盈", "安全"], "description": "细长柔韧，在锅里绕来绕去像小心思。"},
	{"id": "ingredient_peanut", "name": "花生碎", "tags": ["香脆", "浓郁", "解压", "怀旧", "饱腹"], "description": "每次咀嚼都是一声脆响，把焦虑嚼碎咽下去。"},
	{"id": "ingredient_sour_cabbage", "name": "酸菜丝", "tags": ["酸爽", "家常", "温暖", "怀旧", "安全"], "description": "北方冬天的记忆，酸得踏实，暖得到位。"},
	{"id": "ingredient_crayfish", "name": "小龙虾尾", "tags": ["夜市", "罪恶", "上头", "热烈", "肉食"], "description": "夜市的灵魂被浓缩成小小一颗，但香味炸裂。"},
	{"id": "ingredient_pork_floss", "name": "肉松", "tags": ["甜", "怀旧", "温暖", "童年", "轻盈"], "description": "轻盈如絮，落在任何东西上都像被温柔对待。"},
	{"id": "ingredient_mochi", "name": "麻薯", "tags": ["软糯", "甜", "弹牙", "快乐", "夜市"], "description": "会拉丝的甜糯小炸弹，嚼着嚼着就笑了。"},
	{"id": "ingredient_braised_egg", "name": "卤蛋", "tags": ["浓郁", "家常", "安全", "百搭", "温暖"], "description": "慢炖出深色，像时间给的最朴素的奖赏。"}
]



const SEASONINGS := [
	{"id": "seasoning_chili", "name": "辣椒", "tags": ["刺激", "热烈", "重口", "上头", "冒险", "风险"], "description": "提升冲击力，适合夜市和崩溃单。"},
	{"id": "seasoning_sugar", "name": "白糖", "tags": ["甜", "快乐", "幼稚", "安慰", "童年"], "description": "做开心方向的万能补丁。"},
	{"id": "seasoning_mint", "name": "薄荷", "tags": ["清凉", "清爽", "提神", "奇怪", "克制"], "description": "给大脑开一扇窗，但别和重口乱叠。"},
	{"id": "seasoning_cilantro", "name": "香菜", "tags": ["争议", "冒险", "清爽", "分歧", "奇怪"], "description": "隐藏菜单挑战选手。"},
	{"id": "seasoning_dark_chocolate", "name": "黑巧", "tags": ["苦", "高级", "克制", "清醒", "文艺"], "description": "成年人的甜味需要绕一圈。"},
	{"id": "seasoning_honey", "name": "蜂蜜", "tags": ["甜", "温暖", "治愈", "体面", "香气"], "description": "温柔收尾，修复过猛的冲击。"},
	{"id": "seasoning_hotpot_base", "name": "火锅底料", "tags": ["重口", "热烈", "夜市", "罪恶", "上头", "冒险"], "description": "一勺下去，世界开始喧哗。"},
	{"id": "seasoning_lemon", "name": "柠檬汁", "tags": ["酸甜", "清爽", "提神", "体面", "轻盈"], "description": "清爽拉回油腻，过量会变尖锐。"},
	{"id": "seasoning_garlic", "name": "蒜蓉酱", "tags": ["香气", "家常", "百搭", "稳定", "温暖"], "description": "万能底香，不管炒什么，先来一勺准没错。"},
	{"id": "seasoning_sesame_paste", "name": "芝麻酱", "tags": ["浓郁", "温暖", "解压", "治愈", "怀旧"], "description": "厚重绵密，把一团乱麻的情绪慢慢理顺。"},
	{"id": "seasoning_curry", "name": "咖喱块", "tags": ["异域", "冒险", "热烈", "浓郁", "上头"], "description": "异国风味的催化剂，让一切变得陌生又有趣。"},
	{"id": "seasoning_sichuan_pepper", "name": "花椒油", "tags": ["麻", "刺激", "夜市", "上头", "冒险"], "description": "舌尖过电，麻得让你重新认识自己的嘴。"},
	{"id": "seasoning_wasabi", "name": "芥末酱", "tags": ["冒险", "提神", "刺激", "风险", "奇怪"], "description": "鼻尖一冲，眼眶一热，但清醒只需一秒。"},
	{"id": "seasoning_cumin", "name": "孜然粉", "tags": ["夜市", "热烈", "香气", "冒险", "肉食"], "description": "烧烤摊的灵魂，闻到它就想找个路边坐下。"},
	{"id": "seasoning_cheese_powder", "name": "芝士粉", "tags": ["浓郁", "解压", "体面", "快乐", "罪恶"], "description": "洒哪儿哪儿变身，犯规级别的美味加成。"},
	{"id": "seasoning_plum_powder", "name": "梅子粉", "tags": ["酸甜", "清凉", "童年", "怀旧", "清爽"], "description": "酸酸甜甜的童年记忆，撒一点就像小时候。"},
	{"id": "seasoning_matcha", "name": "抹茶粉", "tags": ["文艺", "苦", "克制", "高级", "体面"], "description": "微苦回甘，把成熟压成细细的绿色粉末。"},
	{"id": "seasoning_shrimp_paste", "name": "虾酱", "tags": ["海味", "冒险", "重口", "争议", "奇怪"], "description": "发酵的海洋味道，爱的人闻到就饿，怕的人拔腿就跑。"},
	{"id": "seasoning_osmanthus_honey", "name": "桂花蜜", "tags": ["香气", "甜", "诗意", "体面", "高级"], "description": "秋天和诗意一起溶进甜里，温柔的顶级版本。"},
	{"id": "seasoning_soy_sauce", "name": "酱油", "tags": ["家常", "稳定", "百搭", "安全", "香气"], "description": "厨房的底色，没有它一切热闹都少点根基。"}
]



const COOKING_METHODS := [
	{"id": "method_stir_fry", "name": "爆炒", "tags": ["刺激", "热烈", "混乱", "上头"], "description": "把所有情绪都炒到冒烟。"},
	{"id": "method_iced", "name": "冰镇", "tags": ["清凉", "清爽", "克制", "冷静"], "description": "把世界先放进冰箱冷静一下。"},
	{"id": "method_slow_stew", "name": "慢炖", "tags": ["温暖", "治愈", "家常", "安慰"], "description": "让疲惫慢慢变得能入口。"},
	{"id": "method_deep_fry", "name": "油炸", "tags": ["罪恶", "快乐", "油炸", "夜市"], "description": "把理智炸到酥脆。"}
]

const ORDERS := [
	{"id": "order_001", "customer_name": "阿困", "role": "熬夜赶项目的学生", "avatar_key": "student_sleepy", "request": "我想吃一个像期末周一样崩溃但还能续命的东西。", "difficulty": 2, "desired_tags": ["续命", "熬夜", "焦虑", "刺激"], "avoid_tags": ["太平淡", "过度健康"], "boss": false},
	{"id": "order_002", "customer_name": "小周", "role": "周五下午提前下班失败的人", "avatar_key": "office_friday", "request": "给我来点像周五下午一样自由，但周一早上也能解释得过去的。", "difficulty": 2, "desired_tags": ["快乐", "轻松", "克制", "可靠"], "avoid_tags": ["太混乱", "风险"], "boss": false},
	{"id": "order_003", "customer_name": "答辩侠", "role": "刚答辩完的研究生", "avatar_key": "defense_done", "request": "我刚答辩完，想吃点能让我重新做人。", "difficulty": 2, "desired_tags": ["修复", "安慰", "稳定", "回血"], "avoid_tags": ["冲击", "焦虑"], "boss": false},
	{"id": "order_004", "customer_name": "雨夜社恐", "role": "被迫参加团建的社恐", "avatar_key": "social_tired", "request": "我需要一道能让我礼貌消失，但又不显得太扫兴的菜。", "difficulty": 3, "desired_tags": ["克制", "柔和", "社恐", "清爽"], "avoid_tags": ["热闹", "社交"], "boss": false},
	{"id": "order_005", "customer_name": "阿卷", "role": "早八连堂的本科生", "avatar_key": "morning_class", "request": "我要一份能把灵魂从被窝里拽出来的早餐感。", "difficulty": 2, "desired_tags": ["提神", "可靠", "续命", "基础"], "avoid_tags": ["太油腻", "幻觉"], "boss": false},
	{"id": "order_006", "customer_name": "半夜甲方", "role": "临时改需求的人", "avatar_key": "client_midnight", "request": "做个听起来很合理，实际有点离谱的东西，我明天要拿去说服别人。", "difficulty": 3, "desired_tags": ["神秘", "克制", "冲击", "成熟"], "avoid_tags": ["太家常", "太幼稚"], "boss": false},
	{"id": "order_007", "customer_name": "训练狂", "role": "刚跑完五公里的人", "avatar_key": "runner", "request": "我想奖励自己，但最好还能假装健康。", "difficulty": 2, "desired_tags": ["运动", "快乐", "健康", "克制"], "avoid_tags": ["重口", "负担"], "boss": false},
	{"id": "order_008", "customer_name": "奶茶忏悔者", "role": "刚喝完第二杯奶茶的人", "avatar_key": "milk_tea_guilt", "request": "给我一个甜甜的安慰，但别让我显得完全没有自控力。", "difficulty": 2, "desired_tags": ["甜", "安慰", "克制", "温柔"], "avoid_tags": ["罪恶", "负担"], "boss": false},
	{"id": "order_009", "customer_name": "论文幽灵", "role": "查重前夜的学生", "avatar_key": "paper_ghost", "request": "我要吃一口就能看见参考文献自动排好的奇迹。", "difficulty": 3, "desired_tags": ["熬夜", "神秘", "续命", "焦虑"], "avoid_tags": ["稳定", "朴素"], "boss": false},
	{"id": "order_010", "customer_name": "校门口诗人", "role": "夜市摊边写歌词的人", "avatar_key": "night_poet", "request": "来点便宜、热闹、带一点后悔，但很像青春的。", "difficulty": 2, "desired_tags": ["夜市", "便宜", "热闹", "罪恶"], "avoid_tags": ["健康", "克制"], "boss": false},
	{"id": "order_011", "customer_name": "冷静姐", "role": "刚和队友开完会的人", "avatar_key": "meeting_calm", "request": "我现在不想赢，我只想把火降下来，然后正常说话。", "difficulty": 2, "desired_tags": ["清凉", "冷静", "克制", "清火"], "avoid_tags": ["刺激", "上头"], "boss": false},
	{"id": "order_012", "customer_name": "孤独冰箱", "role": "一个人吃晚饭的人", "avatar_key": "solo_dinner", "request": "做点像冰箱最后存货一样孤独，但吃完还能睡个好觉的。", "difficulty": 3, "desired_tags": ["孤独", "家常", "安慰", "温暖"], "avoid_tags": ["冲击", "热闹"], "boss": false},
	{"id": "order_013", "customer_name": "热闹恐惧症", "role": "刚逃离聚餐的人", "avatar_key": "party_escape", "request": "我需要一点热闹的余味，但不要再有人问我近况。", "difficulty": 3, "desired_tags": ["热闹", "克制", "柔和", "夜市"], "avoid_tags": ["社交", "强烈"], "boss": false},
	{"id": "order_014", "customer_name": "健身房鸽王", "role": "办卡后没去过的人", "avatar_key": "gym_skipper", "request": "给我一份看起来在自律，吃起来在摆烂的东西。", "difficulty": 3, "desired_tags": ["健康", "快乐", "敷衍", "负罪感"], "avoid_tags": ["过度成熟", "太稳定"], "boss": false},
	{"id": "order_015", "customer_name": "咖啡续命员", "role": "三杯咖啡还困的人", "avatar_key": "coffee_worker", "request": "我不需要清醒，我需要被合法地电一下。", "difficulty": 2, "desired_tags": ["提神", "刺激", "上头", "续命"], "avoid_tags": ["温和", "柔和"], "boss": false},
	{"id": "order_016", "customer_name": "春招人", "role": "刚投完简历的人", "avatar_key": "job_hunter", "request": "做个让我觉得人生还有机会，但不要太鸡汤的。", "difficulty": 3, "desired_tags": ["修复", "稳定", "克制", "可靠"], "avoid_tags": ["幼稚", "幻觉"], "boss": false},
	{"id": "order_017", "customer_name": "失眠鼠标手", "role": "通宵剪视频的人", "avatar_key": "editor_night", "request": "我想吃点深夜的，最好能安慰我电脑还没崩。", "difficulty": 2, "desired_tags": ["深夜", "安慰", "续命", "可靠"], "avoid_tags": ["太热闹", "冲击"], "boss": false},
	{"id": "order_018", "customer_name": "短视频中毒者", "role": "刷到凌晨的人", "avatar_key": "scrolling", "request": "我要一道上头但不至于让我明天更后悔的。", "difficulty": 3, "desired_tags": ["上头", "快乐", "克制", "风险"], "avoid_tags": ["负担", "幻觉"], "boss": false},
	{"id": "order_019", "customer_name": "宿舍长", "role": "刚调解完矛盾的人", "avatar_key": "dorm_leader", "request": "来点能让大家重新坐下来讲话的，不要太刺激。", "difficulty": 2, "desired_tags": ["家常", "温和", "稳定", "社交"], "avoid_tags": ["强烈", "争议"], "boss": false},
	{"id": "order_020", "customer_name": "考试玄学家", "role": "考前拜遍所有图标的人", "avatar_key": "exam_luck", "request": "给我一点神秘力量，最好别真的把我送走。", "difficulty": 3, "desired_tags": ["神秘", "续命", "风险", "克制"], "avoid_tags": ["太朴素", "过度危险"], "boss": false},
	{"id": "order_021", "customer_name": "早八哲学家", "role": "刚迟到十五分钟的人", "avatar_key": "late_class", "request": "我想吃得像个成年人，但内心还是想回宿舍。", "difficulty": 3, "desired_tags": ["成熟", "稳定", "苦", "安慰"], "avoid_tags": ["幼稚", "热闹"], "boss": false},
	{"id": "order_022", "customer_name": "外卖破产者", "role": "月底只剩饭卡的人", "avatar_key": "broke_student", "request": "便宜点，顶饱点，最好还能让我觉得自己没有输。", "difficulty": 2, "desired_tags": ["便宜", "饱腹", "稳定", "学生"], "avoid_tags": ["负担", "过度精致"], "boss": false},
	{"id": "order_023", "customer_name": "创赛队长", "role": "正在写商业计划书的人", "avatar_key": "startup_pitch", "request": "做一道很能讲故事的菜，味道可以先别太诚实。", "difficulty": 3, "desired_tags": ["校园", "神秘", "冲击", "快乐"], "avoid_tags": ["朴素", "太家常"], "boss": false},
	{"id": "order_024", "customer_name": "空调争夺者", "role": "刚从闷热教室逃出来的人", "avatar_key": "summer_heat", "request": "我现在只想降温，顺便重新相信人类文明。", "difficulty": 2, "desired_tags": ["清凉", "清爽", "安慰", "冷静"], "avoid_tags": ["油腻", "热烈"], "boss": false},
	{"id": "order_025", "customer_name": "复盘大师", "role": "输完比赛还在分析的人", "avatar_key": "post_match", "request": "我要一道承认失败但还能准备下一局的东西。", "difficulty": 3, "desired_tags": ["成熟", "修复", "稳定", "苦"], "avoid_tags": ["幼稚", "过度快乐"], "boss": false},
	{"id": "boss_001", "customer_name": "小炒 AI-7", "role": "亲自下场的点单评价系统", "avatar_key": "ai_boss", "request": "请证明你理解人类的崩溃、续命、快乐和后悔。我要一锅逻辑自洽的怪菜。", "difficulty": 5, "desired_tags": ["续命", "快乐", "风险", "克制", "神秘"], "avoid_tags": ["太平淡", "太安全"], "boss": true},
	{"id": "boss_002", "customer_name": "黑客松评委", "role": "连续看了十个项目的人", "avatar_key": "judge", "request": "三分钟内打动我：要有校园感、技术感、笑点，还要能入口。", "difficulty": 5, "desired_tags": ["校园", "提神", "快乐", "可靠", "冲击"], "avoid_tags": ["太普通", "太危险"], "boss": true},
	{"id": "boss_003", "customer_name": "凌晨四点的服务器", "role": "刚报警的线上服务", "avatar_key": "server_alert", "request": "我需要降火、续命、稳定运行，但最好保留一点事故现场的灵魂。", "difficulty": 5, "desired_tags": ["冷静", "续命", "稳定", "风险", "克制"], "avoid_tags": ["混乱", "过度热烈"], "boss": true},
	{"id": "boss_004", "customer_name": "未来校长", "role": "巡视夜市的神秘人物", "avatar_key": "principal", "request": "做一道能代表未来校园夜市精神的菜：便宜、热闹、荒诞，但不丢人。", "difficulty": 5, "desired_tags": ["便宜", "热闹", "夜市", "神秘", "克制"], "avoid_tags": ["太幼稚", "过度负担"], "boss": true},
	{"id": "boss_005", "customer_name": "另一个你", "role": "通宵后出现的精神分身", "avatar_key": "other_self", "request": "我想吃一份能让我继续干活，又能提醒我这不太正常的东西。", "difficulty": 5, "desired_tags": ["续命", "熬夜", "焦虑", "成熟", "风险"], "avoid_tags": ["太安稳", "太快乐"], "boss": true}
]

var rng := RandomNumberGenerator.new()
var screen_state := "start"
var order_index := 0
var current_order := {}
var current_customer_variant_index := 0
var normal_order_pool := []
var presented_ingredients: Array = []
var presented_seasonings: Array = []
var selected_ingredient_ids := []
var selected_seasoning_ids := []
var selected_method_id := ""
var time_left := ROUND_SECONDS
var message_text := ""
var total_score := 0
var total_coins := 0
var current_funds := INITIAL_FUNDS
var total_exp := 0
var player_level := 1
var player_title := "街边新厨"
var completed_orders := 0
var current_service_cost := 0
var day_index := 1
var combo_count := 0
var round_results := []
var active_buffs := []
var pending_buff_choices := []
var mistake_insurance_used := false
var pending_payload := {}
var pending_http_request: HTTPRequest
var timer_label: Label
var supabase_config := {}
var auth_session := {}
var current_user := {}
var user_profile := {}
var ai_config := {}
var home_tab := "overview"
var auth_mode := "login"
var auth_notice := ""
var profile_notice := ""
var ai_config_notice := ""
var current_avatar_texture: Texture2D
var last_countdown_sfx_second := -1
var auth_email_input: LineEdit
var auth_password_input: LineEdit
var profile_username_input: LineEdit
var ai_provider_option: OptionButton
var ai_endpoint_input: LineEdit
var ai_key_input: LineEdit
var ai_model_input: LineEdit

func _ready() -> void:
	rng.randomize()
	ai_config = _load_user_ai_config()
	_ensure_item_icons_on_disk()
	_show_start_screen()
var icon_cache: Dictionary = {}
var file_texture_cache: Dictionary = {}
var playing_root: Control
var coins_label: Label
var order_label: Label
var customer_avatar_rect: TextureRect
var customer_body_rect: TextureRect
var customer_request_label: Label
var customer_signature_label: Label
var ingredient_buttons: Dictionary = {}
var seasoning_buttons: Dictionary = {}
var method_buttons: Dictionary = {}
var selected_chips_box: Container
var status_label: Label
var economy_label: Label
var cook_button: Button
var _bg_overlay: TextureRect
var _bg_offset := Vector2.ZERO
var _timer_pulsing := false
var _timer_tween: Tween
var _cook_breathing := false
var _cook_breath_tween: Tween
var _vignette: ColorRect
var pot_view: PotView
var funds_label: Label
var title_label: Label
var exp_label: Label
var exp_progress_bar: ProgressBar
var making_progress_bar: ProgressBar

class SteamParticles:
	extends Control
	var parts := []
	var rng := RandomNumberGenerator.new()

	func _ready() -> void:
		rng.randomize()
		set_process(true)
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _process(delta: float) -> void:
		if rng.randf() < 0.3:
			_spawn()
		for i in range(parts.size() - 1, -1, -1):
			parts[i]["y"] -= parts[i]["speed"] * 60.0 * delta
			parts[i]["life"] -= 0.9 * delta
			if parts[i]["life"] <= 0.0:
				parts.remove_at(i)
		queue_redraw()

	func _spawn() -> void:
		parts.append({
			"x": rng.randf_range(0.2, 0.8) * size.x,
			"y": size.y - 4.0,
			"speed": rng.randf_range(0.4, 1.2),
			"life": 1.0,
			"size": rng.randf_range(2.0, 6.0)
		})
		if parts.size() > 30:
			parts.remove_at(0)

	func _draw() -> void:
		for p in parts:
			var alpha := float(p["life"]) * 0.25
			var s := float(p["size"]) * float(p["life"])
			draw_circle(Vector2(float(p["x"]), float(p["y"])), s, Color(1, 1, 1, alpha))

class PotView:
	extends Control
	var ingredient_ids: Array = []
	var seasoning_ids: Array = []
	var method_id := ""
	var phase := 0.0
	var icon_provider: Callable
	var item_meta: Dictionary = {}
	var add_events: Array = []

	func _ready() -> void:
		set_process(true)
		texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

	func set_state(new_ingredient_ids: Array, new_seasoning_ids: Array, new_method_id: String) -> void:
		for old_id in ingredient_ids:
			var s_old := str(old_id)
			if not new_ingredient_ids.has(s_old):
				item_meta.erase("ingredient|" + s_old)
		for old_id in seasoning_ids:
			var s_old := str(old_id)
			if not new_seasoning_ids.has(s_old):
				item_meta.erase("seasoning|" + s_old)

		for new_id in new_ingredient_ids:
			var s_new := str(new_id)
			if not ingredient_ids.has(s_new):
				_record_add_event("ingredient", s_new)
		for new_id in new_seasoning_ids:
			var s_new := str(new_id)
			if not seasoning_ids.has(s_new):
				_record_add_event("seasoning", s_new)

		ingredient_ids = new_ingredient_ids.duplicate()
		seasoning_ids = new_seasoning_ids.duplicate()
		method_id = new_method_id
		queue_redraw()

	func _process(delta: float) -> void:
		phase += delta
		_prune_add_events()
		queue_redraw()

	func _record_add_event(kind: String, id: String) -> void:
		var key := "%s|%s" % [kind, id]
		if not item_meta.has(key):
			var meta_seed: int = _hash_u32(id.hash() ^ kind.hash())
			item_meta[key] = {"t0": phase, "seed": meta_seed}
		add_events.append({"kind": kind, "id": id, "t0": phase})
		if add_events.size() > 18:
			add_events.remove_at(0)

	func _prune_add_events() -> void:
		var keep: Array = []
		for e in add_events:
			var age: float = phase - float(e.get("t0", 0.0))
			if age <= 1.2:
				keep.append(e)
		add_events = keep

	func _hash_u32(v: int) -> int:
		var x: int = v
		x = int((x ^ 61) ^ (x >> 16))
		x = x + (x << 3)
		x = x ^ (x >> 4)
		x = int((x * 0x27d4eb2d) & 0x7fffffff)
		x = x ^ (x >> 15)
		return x

	func _hash01(v: int) -> float:
		var u: int = _hash_u32(v)
		return float(u & 0x7fffffff) / 2147483647.0

	func _ease_out_cubic(t: float) -> float:
		var tt: float = clampf(t, 0.0, 1.0)
		var inv: float = 1.0 - tt
		return 1.0 - inv * inv * inv

	func _p(origin: Vector2, tile: int, x: float, y: float) -> Vector2:
		return origin + Vector2(x * float(tile), y * float(tile))

	func _boil_power() -> float:
		if method_id == "method_stir_fry":
			return 1.0
		if method_id == "method_deep_fry":
			return 0.85
		if method_id == "method_slow_stew":
			return 0.55
		if method_id == "method_iced":
			return 0.25
		return 0.65

	func _liquid_base_color() -> Color:
		if method_id == "method_deep_fry":
			return Color(0.55, 0.36, 0.16)
		if method_id == "method_slow_stew":
			return Color(0.5, 0.32, 0.18)
		if method_id == "method_iced":
			return Color(0.2, 0.55, 0.7)
		if method_id == "method_stir_fry":
			return Color(0.62, 0.38, 0.18)
		return Color(0.6, 0.38, 0.2)

	func _liquid_highlight_color() -> Color:
		if method_id == "method_iced":
			return Color(0.55, 0.9, 1.0, 0.65)
		return Color(0.95, 0.88, 0.7, 0.35)

	func _draw_pixel(origin: Vector2, tile: int, x: int, y: int, color: Color) -> void:
		draw_rect(Rect2(origin + Vector2(x * tile, y * tile), Vector2(tile, tile)), color)

	func _draw_blob(origin: Vector2, tile: int, x: int, y: int, w: int, h: int, color: Color) -> void:
		draw_rect(Rect2(origin + Vector2(x * tile, y * tile), Vector2(w * tile, h * tile)), color)

	func _draw_swirl_piece(origin: Vector2, tile: int, cx: float, cy: float, rx: float, ry: float, hash_seed: int, piece: int, speed: float) -> Vector2:
		var a: float = _hash01(hash_seed + piece * 31) * TAU
		a += phase * speed
		var rr: float = lerpf(0.25, 1.0, _hash01(hash_seed + piece * 73))
		var x: float = cx + cos(a) * rx * rr
		var y: float = cy + sin(a) * ry * rr
		y += sin(phase * 2.3 + float(piece)) * 0.55
		return _p(origin, tile, x, y)

	func _draw_add_splash(origin: Vector2, tile: int, food_left: int, food_right: int, food_top: int, food_bottom: int, kind: String, id: String, t: float) -> void:
		var boil: float = _boil_power()
		var base_seed: int = _hash_u32(id.hash() ^ kind.hash())
		var up: float = lerpf(0.0, 10.0, _ease_out_cubic(t))
		var splash_color := _liquid_highlight_color()
		if kind == "seasoning":
			if id == "seasoning_chili" or id == "seasoning_hotpot_base":
				splash_color = Color(1.0, 0.25, 0.2, 0.8)
			elif id == "seasoning_mint" or id == "seasoning_lemon":
				splash_color = Color(0.5, 1.0, 0.75, 0.7)
			elif id == "seasoning_sugar" or id == "seasoning_honey":
				splash_color = Color(1.0, 0.95, 0.8, 0.75)

		var cx: float = float(food_left + food_right) / 2.0 + sin(phase * 1.7) * 1.2
		var cy: float = float(food_top + food_bottom) / 2.0
		for i in range(10):
			var fx: float = lerpf(float(food_left + 2), float(food_right - 3), _hash01(base_seed + i * 19))
			var vy: float = lerpf(2.5, 6.5, _hash01(base_seed + i * 29)) * (0.6 + 0.6 * boil)
			var px: int = int(round(fx))
			var py: int = int(round(float(food_top + 1) - up + vy * (1.0 - t) + sin(float(i) + phase * 7.0) * 0.35))
			_draw_pixel(origin, tile, px, py, splash_color)

		var ripple_color := Color(splash_color.r, splash_color.g, splash_color.b, 0.35)
		var ring: float = lerpf(0.0, 12.0, t)
		for i in range(24):
			var a: float = float(i) / 24.0 * TAU
			var rx: float = ring * (1.0 + 0.2 * sin(phase * 5.0 + float(i)))
			var ry: float = ring * 0.55
			var x: int = int(round(cx + cos(a) * rx))
			var y: int = int(round(cy + sin(a) * ry))
			if x >= food_left + 1 and x <= food_right - 2 and y >= food_top + 1 and y <= food_bottom - 2:
				_draw_pixel(origin, tile, x, y, ripple_color)

	func _draw() -> void:
		var grid_w := 96
		var grid_h := 54
		var tile: int = int(floor(minf(size.x / float(grid_w), size.y / float(grid_h))))
		tile = maxi(3, tile)
		var canvas := Vector2(grid_w * tile, grid_h * tile)
		var origin := (size - canvas) / 2.0
		origin = Vector2(floor(origin.x), floor(origin.y))

		var bg := Color(0.07, 0.06, 0.14)
		draw_rect(Rect2(origin, canvas), bg)

		var stove_rect := Rect2(origin + Vector2(18 * tile, 38 * tile), Vector2(60 * tile, 12 * tile))
		draw_rect(stove_rect.grow_individual(0, 0, 0, 2 * tile), Color(0.0, 0.0, 0.0, 0.25))
		draw_rect(stove_rect, Color(0.14, 0.16, 0.26))
		draw_rect(Rect2(origin + Vector2(18 * tile, 38 * tile), Vector2(60 * tile, 1 * tile)), Color(0.22, 0.24, 0.34, 0.8))
		draw_rect(Rect2(origin + Vector2(18 * tile, 49 * tile), Vector2(60 * tile, 1 * tile)), Color(0.05, 0.06, 0.1, 0.8))
		draw_rect(Rect2(origin + Vector2(22 * tile, 36 * tile), Vector2(52 * tile, 3 * tile)), Color(0.1, 0.12, 0.2))

		var flame_power: float = 0.0
		if method_id == "method_stir_fry":
			flame_power = 1.0
		elif method_id == "method_deep_fry":
			flame_power = 0.85
		elif method_id == "method_slow_stew":
			flame_power = 0.45
		elif method_id == "method_iced":
			flame_power = 0.0

		if flame_power > 0.0:
			var t: float = 0.5 + 0.5 * sin(phase * 6.0)
			var c1 := Color(1.0, 0.45, 0.2).lerp(Color(1.0, 0.85, 0.25), t)
			var c2 := Color(1.0, 0.25, 0.18).lerp(Color(1.0, 0.6, 0.22), t)
			for i in range(7):
				var x := 34 + i * 4
				var h: int = int(round(6.0 + (sin(phase * 7.0 + float(i)) * 2.0 + 2.0) * flame_power))
				draw_rect(Rect2(origin + Vector2(x * tile, (36 - h) * tile), Vector2(3 * tile, h * tile)), c2)
				var hh: int = maxi(0, h - 2)
				draw_rect(Rect2(origin + Vector2((x + 1) * tile, (36 - h + 1) * tile), Vector2(1 * tile, hh * tile)), c1)

		var wok_dark := Color(0.05, 0.05, 0.08)
		var wok_mid := Color(0.12, 0.13, 0.18)
		var wok_rim := Color(0.22, 0.25, 0.38)
		var wok_hi := Color(0.35, 0.38, 0.52, 0.55)
		var wok_shadow := Color(0.0, 0.0, 0.0, 0.22)
		for y in range(12, 38):
			var dy: int = absi(y - 26)
			var half := int(round(34 - dy * 1.65))
			if half <= 0:
				continue
			var left := 48 - half
			var right := 48 + half
			if y >= 18 and y <= 36:
				draw_rect(Rect2(origin + Vector2((left + 1) * tile, (y + 1) * tile), Vector2((right - left - 2) * tile, 1 * tile)), wok_shadow)
			draw_rect(Rect2(origin + Vector2(left * tile, y * tile), Vector2((right - left) * tile, 1 * tile)), wok_mid)
			if y == 12 or y == 37:
				draw_rect(Rect2(origin + Vector2(left * tile, y * tile), Vector2((right - left) * tile, 1 * tile)), wok_dark)
			else:
				draw_rect(Rect2(origin + Vector2(left * tile, y * tile), Vector2(1 * tile, 1 * tile)), wok_dark)
				draw_rect(Rect2(origin + Vector2((right - 1) * tile, y * tile), Vector2(1 * tile, 1 * tile)), wok_dark)
			if y == 13 or y == 14:
				draw_rect(Rect2(origin + Vector2((left + 2) * tile, y * tile), Vector2(maxi(0, (right - left) - 4) * tile, 1 * tile)), Color(wok_rim.r, wok_rim.g, wok_rim.b, 0.55))
			if y == 15 or y == 16:
				draw_rect(Rect2(origin + Vector2((left + 4) * tile, y * tile), Vector2(maxi(0, (right - left) - 8) * tile, 1 * tile)), wok_hi)
			if y >= 28 and (y % 3) == 0:
				draw_rect(Rect2(origin + Vector2((left + 6) * tile, y * tile), Vector2(maxi(0, (right - left) - 12) * tile, 1 * tile)), Color(0.0, 0.0, 0.0, 0.16))

		draw_rect(Rect2(origin + Vector2(18 * tile, 24 * tile), Vector2(6 * tile, 7 * tile)), Color(0.08, 0.09, 0.14))
		draw_rect(Rect2(origin + Vector2(18 * tile, 24 * tile), Vector2(6 * tile, 1 * tile)), Color(0.26, 0.28, 0.38, 0.6))
		draw_rect(Rect2(origin + Vector2(72 * tile, 24 * tile), Vector2(6 * tile, 7 * tile)), Color(0.08, 0.09, 0.14))
		draw_rect(Rect2(origin + Vector2(72 * tile, 24 * tile), Vector2(6 * tile, 1 * tile)), Color(0.26, 0.28, 0.38, 0.6))

		var food_left := 32
		var food_right := 64
		var food_top := 18
		var food_bottom := 32
		var food_bg := _liquid_base_color()
		draw_rect(Rect2(origin + Vector2(food_left * tile, food_top * tile), Vector2((food_right - food_left) * tile, (food_bottom - food_top) * tile)), food_bg)

		var boil: float = _boil_power()
		var surface_y: int = food_top + 2
		var surface_col := _liquid_highlight_color()
		for x in range(food_left + 1, food_right - 1):
			var wobble: float = sin(phase * 4.0 + float(x) * 0.55) * boil * 0.8
			var yy: int = int(round(float(surface_y) + wobble))
			_draw_pixel(origin, tile, x, yy, surface_col)
			if (x % 3) == 0:
				_draw_pixel(origin, tile, x, yy + 1, Color(surface_col.r, surface_col.g, surface_col.b, 0.18))

		var bubble_count: int = int(round(10.0 + 20.0 * boil))
		for i in range(bubble_count):
			var base: int = i * 97 + int(round(phase * 10.0))
			var speed: float = lerpf(0.65, 1.8, _hash01(base + 11)) * (0.6 + boil)
			var t: float = fposmod(phase * speed + _hash01(base + 21) * 6.0, 1.0)
			var fx: float = lerpf(float(food_left + 2), float(food_right - 3), _hash01(base + 31))
			var fy: float = lerpf(float(food_bottom - 2), float(food_top + 2), _ease_out_cubic(t))
			var px: int = int(round(fx))
			var py: int = int(round(fy))
			if py <= food_top + 2:
				continue
			var alpha: float = lerpf(0.12, 0.35, clampf(boil, 0.0, 1.0)) * lerpf(1.0, 0.2, t)
			var bc := Color(1.0, 1.0, 1.0, alpha)
			_draw_pixel(origin, tile, px, py, bc)
			if (i % 3) == 0 and py + 1 <= food_bottom - 2:
				_draw_pixel(origin, tile, px, py + 1, Color(1.0, 1.0, 1.0, alpha * 0.4))

		for e in add_events:
			var t0: float = float(e.get("t0", 0.0))
			var dt: float = phase - t0
			if dt < 0.0 or dt > 0.8:
				continue
			var tt: float = dt / 0.8
			_draw_add_splash(origin, tile, food_left, food_right, food_top, food_bottom, str(e.get("kind", "")), str(e.get("id", "")), tt)

		var cx: float = float(food_left + food_right) / 2.0
		var cy: float = float(food_top + food_bottom) / 2.0 + 1.0
		var rx: float = float(food_right - food_left) * 0.42
		var ry: float = float(food_bottom - food_top) * 0.28
		var swirl_speed: float = lerpf(0.6, 1.45, boil)

		for ingredient in ingredient_ids:
			var id := str(ingredient)
			var key := "ingredient|" + id
			var hash_seed: int = int(item_meta.get(key, {"seed": _hash_u32(id.hash())}).get("seed", _hash_u32(id.hash())))
			match id:
				"ingredient_noodle":
					var c := Color(0.96, 0.84, 0.26)
					for p in range(10):
						var pos := _draw_swirl_piece(origin, tile, cx, cy, rx, ry, hash_seed, p, swirl_speed * 0.9)
						var gx: int = int(round((pos.x - origin.x) / float(tile)))
						var gy: int = int(round((pos.y - origin.y) / float(tile)))
						for k in range(4):
							_draw_pixel(origin, tile, gx + k - 2, gy + ((k + p) % 2), Color(c.r, c.g, c.b, 0.9))
				"ingredient_rice":
					var c := Color(0.96, 0.96, 0.92)
					for p in range(12):
						var pos := _draw_swirl_piece(origin, tile, cx, cy, rx, ry, hash_seed, p, swirl_speed * 0.75)
						var gx: int = int(round((pos.x - origin.x) / float(tile)))
						var gy: int = int(round((pos.y - origin.y) / float(tile)))
						_draw_pixel(origin, tile, gx, gy, Color(c.r, c.g, c.b, 0.8))
						if (p % 3) == 0:
							_draw_pixel(origin, tile, gx + 1, gy, Color(0.82, 0.82, 0.8, 0.55))
				"ingredient_egg":
					var white := Color(0.96, 0.95, 0.92, 0.92)
					var yolk := Color(1.0, 0.78, 0.18, 0.92)
					var pulse: float = 0.9 + 0.08 * sin(phase * 3.2 + _hash01(hash_seed + 7) * 6.0)
					var w: int = int(round(10.0 * pulse))
					var h: int = int(round(7.0 * pulse))
					var ox: int = int(round(cx - float(w) / 2.0 + sin(phase * 0.7) * 1.2))
					var oy: int = int(round(cy - float(h) / 2.0 + cos(phase * 0.6) * 0.8))
					_draw_blob(origin, tile, ox, oy, w, h, white)
					_draw_blob(origin, tile, ox + int(round(float(w) * 0.35)), oy + int(round(float(h) * 0.35)), maxi(2, int(round(float(w) * 0.3))), maxi(2, int(round(float(h) * 0.3))), yolk)
				"ingredient_tomato":
					var red := Color(0.92, 0.22, 0.28, 0.9)
					for p in range(4):
						var pos := _draw_swirl_piece(origin, tile, cx, cy, rx, ry, hash_seed, p, swirl_speed * 0.82)
						var gx: int = int(round((pos.x - origin.x) / float(tile)))
						var gy: int = int(round((pos.y - origin.y) / float(tile)))
						_draw_blob(origin, tile, gx - 1, gy - 1, 3, 3, red)
						_draw_pixel(origin, tile, gx, gy, Color(1.0, 0.82, 0.82, 0.55))
				"ingredient_tofu":
					var c := Color(0.9, 0.92, 0.94, 0.92)
					var shade := Color(0.8, 0.84, 0.88, 0.7)
					for p in range(6):
						var pos := _draw_swirl_piece(origin, tile, cx, cy, rx, ry, hash_seed, p, swirl_speed * 0.7)
						var gx: int = int(round((pos.x - origin.x) / float(tile)))
						var gy: int = int(round((pos.y - origin.y) / float(tile)))
						_draw_blob(origin, tile, gx - 1, gy - 1, 3, 3, c)
						_draw_pixel(origin, tile, gx + 1, gy + 1, shade)
				"ingredient_fried_chicken":
					var c := Color(0.78, 0.46, 0.18, 0.95)
					var crumb := Color(0.95, 0.86, 0.62, 0.65)
					for p in range(5):
						var pos := _draw_swirl_piece(origin, tile, cx, cy, rx, ry, hash_seed, p, swirl_speed * 1.05)
						var gx: int = int(round((pos.x - origin.x) / float(tile)))
						var gy: int = int(round((pos.y - origin.y) / float(tile)))
						_draw_blob(origin, tile, gx - 1, gy - 1, 3, 2, c)
						_draw_pixel(origin, tile, gx + (p % 2), gy, crumb)
				"ingredient_dumpling":
					var c := Color(0.92, 0.86, 0.72, 0.92)
					var hi := Color(0.96, 0.92, 0.82, 0.75)
					for p in range(3):
						var pos := _draw_swirl_piece(origin, tile, cx, cy, rx, ry, hash_seed, p, swirl_speed * 0.72)
						var gx: int = int(round((pos.x - origin.x) / float(tile)))
						var gy: int = int(round((pos.y - origin.y) / float(tile)))
						_draw_blob(origin, tile, gx - 2, gy - 1, 5, 3, c)
						_draw_blob(origin, tile, gx - 1, gy - 2, 3, 1, hi)
				"ingredient_hotdog":
					var c := Color(0.72, 0.26, 0.22, 0.92)
					for p in range(2):
						var pos := _draw_swirl_piece(origin, tile, cx, cy, rx, ry, hash_seed, p, swirl_speed * 0.88)
						var gx: int = int(round((pos.x - origin.x) / float(tile)))
						var gy: int = int(round((pos.y - origin.y) / float(tile)))
						for k in range(8):
							var yy: int = gy + int(round(sin(phase * 4.0 + float(k) * 0.55 + float(p)) * 0.6))
							_draw_pixel(origin, tile, gx + k - 4, yy, c)
				"ingredient_potato_mash", "ingredient_oatmeal":
					var c := Color(0.86, 0.74, 0.46, 0.85) if id == "ingredient_potato_mash" else Color(0.82, 0.68, 0.38, 0.85)
					for p in range(10):
						var pos := _draw_swirl_piece(origin, tile, cx, cy, rx, ry, hash_seed, p, swirl_speed * 0.62)
						var gx: int = int(round((pos.x - origin.x) / float(tile)))
						var gy: int = int(round((pos.y - origin.y) / float(tile)))
						_draw_pixel(origin, tile, gx, gy, c)
				"ingredient_milk_tea_jelly", "ingredient_coffee_jelly":
					var c := Color(0.62, 0.38, 0.24, 0.65) if id == "ingredient_milk_tea_jelly" else Color(0.2, 0.16, 0.18, 0.65)
					var hi := Color(0.92, 0.95, 1.0, 0.3)
					for p in range(6):
						var pos := _draw_swirl_piece(origin, tile, cx, cy, rx, ry, hash_seed, p, swirl_speed * 0.78)
						var gx: int = int(round((pos.x - origin.x) / float(tile)))
						var gy: int = int(round((pos.y - origin.y) / float(tile)))
						_draw_blob(origin, tile, gx - 1, gy - 1, 3, 3, c)
						_draw_pixel(origin, tile, gx - 1, gy - 1, hi)
				_:
					if not icon_provider.is_null():
						var tex = icon_provider.call("ingredient", id, 32)
						if tex is Texture2D:
							var pos := _draw_swirl_piece(origin, tile, cx, cy, rx, ry, hash_seed, 0, swirl_speed * 0.7)
							var pulse: float = 0.92 + 0.10 * sin(phase * 3.2 + _hash01(hash_seed + 41) * TAU)
							var s: float = float(tile) * 8.6 * pulse
							var a: float = 0.72 + 0.20 * (0.5 + 0.5 * sin(phase * 4.2 + _hash01(hash_seed + 59) * TAU))
							draw_texture_rect(tex as Texture2D, Rect2(pos - Vector2(s / 2.0, s / 2.0), Vector2(s, s)), false, Color(1.0, 1.0, 1.0, a))
							var hi_s: float = s * 0.92
							draw_texture_rect(tex as Texture2D, Rect2(pos - Vector2(hi_s / 2.0, hi_s / 2.0) + Vector2(-0.6 * float(tile), -0.6 * float(tile)), Vector2(hi_s, hi_s)), false, Color(1.0, 1.0, 1.0, a * 0.25))

		for seasoning in seasoning_ids:
			var id := str(seasoning)
			var key := "seasoning|" + id
			var hash_seed: int = int(item_meta.get(key, {"seed": _hash_u32(id.hash())}).get("seed", _hash_u32(id.hash())))
			match id:
				"seasoning_chili":
					var c := Color(1.0, 0.25, 0.2, 0.85)
					for p in range(12):
						var pos := _draw_swirl_piece(origin, tile, cx, cy, rx, ry, hash_seed, p, swirl_speed * 1.25)
						var gx: int = int(round((pos.x - origin.x) / float(tile)))
						var gy: int = int(round((pos.y - origin.y) / float(tile)))
						if (p % 2) == 0:
							_draw_pixel(origin, tile, gx, gy, c)
				"seasoning_mint":
					var c := Color(0.28, 0.86, 0.54, 0.75)
					for p in range(6):
						var pos := _draw_swirl_piece(origin, tile, cx, cy, rx, ry, hash_seed, p, swirl_speed * 0.88)
						var gx: int = int(round((pos.x - origin.x) / float(tile)))
						var gy: int = int(round((pos.y - origin.y) / float(tile)))
						_draw_blob(origin, tile, gx - 1, gy - 1, 3, 2, c)
						_draw_pixel(origin, tile, gx, gy - 1, Color(0.14, 0.62, 0.4, 0.65))
				"seasoning_sugar":
					var c := Color(1.0, 1.0, 1.0, 0.55)
					for p in range(10):
						var pos := _draw_swirl_piece(origin, tile, cx, cy, rx, ry, hash_seed, p, swirl_speed * 0.55)
						var gx: int = int(round((pos.x - origin.x) / float(tile)))
						var gy: int = int(round((pos.y - origin.y) / float(tile)))
						_draw_pixel(origin, tile, gx, gy, c)
				"seasoning_hotpot_base":
					var c := Color(0.3, 0.12, 0.14, 0.6)
					for p in range(14):
						var pos := _draw_swirl_piece(origin, tile, cx, cy, rx, ry, hash_seed, p, swirl_speed * 1.35)
						var gx: int = int(round((pos.x - origin.x) / float(tile)))
						var gy: int = int(round((pos.y - origin.y) / float(tile)))
						_draw_pixel(origin, tile, gx, gy, c)
				"seasoning_lemon":
					var c := Color(1.0, 0.88, 0.25, 0.65)
					for p in range(8):
						var pos := _draw_swirl_piece(origin, tile, cx, cy, rx, ry, hash_seed, p, swirl_speed * 0.95)
						var gx: int = int(round((pos.x - origin.x) / float(tile)))
						var gy: int = int(round((pos.y - origin.y) / float(tile)))
						_draw_pixel(origin, tile, gx, gy, c)
						if (p % 4) == 0:
							_draw_pixel(origin, tile, gx + 1, gy, Color(1.0, 1.0, 0.85, 0.45))
				"seasoning_cilantro":
					var c := Color(0.2, 0.7, 0.34, 0.7)
					for p in range(8):
						var pos := _draw_swirl_piece(origin, tile, cx, cy, rx, ry, hash_seed, p, swirl_speed * 0.76)
						var gx: int = int(round((pos.x - origin.x) / float(tile)))
						var gy: int = int(round((pos.y - origin.y) / float(tile)))
						_draw_pixel(origin, tile, gx, gy, c)
						_draw_pixel(origin, tile, gx + 1, gy, Color(0.12, 0.56, 0.28, 0.65))
				"seasoning_dark_chocolate":
					var c := Color(0.18, 0.12, 0.14, 0.6)
					for p in range(8):
						var pos := _draw_swirl_piece(origin, tile, cx, cy, rx, ry, hash_seed, p, swirl_speed * 0.72)
						var gx: int = int(round((pos.x - origin.x) / float(tile)))
						var gy: int = int(round((pos.y - origin.y) / float(tile)))
						_draw_pixel(origin, tile, gx, gy, c)
				"seasoning_honey":
					var c := Color(0.95, 0.74, 0.18, 0.55)
					for p in range(10):
						var pos := _draw_swirl_piece(origin, tile, cx, cy, rx, ry, hash_seed, p, swirl_speed * 0.62)
						var gx: int = int(round((pos.x - origin.x) / float(tile)))
						var gy: int = int(round((pos.y - origin.y) / float(tile)))
						_draw_pixel(origin, tile, gx, gy, c)
				_:
					if not icon_provider.is_null():
						var tex = icon_provider.call("seasoning", id, 32)
						if tex is Texture2D:
							var pos := _draw_swirl_piece(origin, tile, cx, cy, rx, ry, hash_seed, 0, swirl_speed * 0.7)
							var pulse: float = 0.92 + 0.10 * sin(phase * 3.0 + _hash01(hash_seed + 17) * TAU)
							var s: float = float(tile) * 7.6 * pulse
							var a: float = 0.62 + 0.22 * (0.5 + 0.5 * sin(phase * 4.0 + _hash01(hash_seed + 23) * TAU))
							draw_texture_rect(tex as Texture2D, Rect2(pos - Vector2(s / 2.0, s / 2.0), Vector2(s, s)), false, Color(1.0, 1.0, 1.0, a))
							var hi_s: float = s * 0.92
							draw_texture_rect(tex as Texture2D, Rect2(pos - Vector2(hi_s / 2.0, hi_s / 2.0) + Vector2(-0.5 * float(tile), -0.5 * float(tile)), Vector2(hi_s, hi_s)), false, Color(1.0, 1.0, 1.0, a * 0.22))

		var steam_power := 0.0
		if method_id == "method_slow_stew":
			steam_power = 1.0
		elif method_id == "method_stir_fry":
			steam_power = 0.65
		elif method_id == "method_deep_fry":
			steam_power = 0.45

		if steam_power > 0.0:
			var steam := Color(0.92, 0.95, 1.0, 0.25 + 0.1 * sin(phase * 2.0))
			for i in range(6):
				var sx := 34 + i * 6 + int(round(sin(phase * 2.0 + float(i)) * 2.0))
				var sy := 8 + int(round(fposmod(phase * 18.0 + float(i) * 7.0, 18.0)))
				draw_rect(Rect2(origin + Vector2(sx * tile, sy * tile), Vector2(4 * tile, 10 * tile)), steam)

		if method_id == "method_iced":
			var ice := Color(0.55, 0.92, 1.0, 0.55)
			for i in range(20):
				var ix := 26 + (i * 7) % 44
				var iy := 14 + int(round(fposmod(phase * 8.0 + float(i) * 4.0, 18.0)))
				draw_rect(Rect2(origin + Vector2(ix * tile, iy * tile), Vector2(2 * tile, 2 * tile)), ice)

class StallApproachView:
	extends Control
	signal finished
	var phase := 0.0
	var walk_t := 0.0
	var duration := 2.2
	var walk_sheet: Texture2D
	var portrait: Texture2D
	var customer_name := ""
	var customer_role := ""
	var request_text := ""
	var boss := false
	var emitted := false

	func setup(sheet: Texture2D, portrait_texture: Texture2D, name_text: String, role_text: String, request_preview: String, is_boss: bool) -> void:
		walk_sheet = sheet
		portrait = portrait_texture
		customer_name = name_text
		customer_role = role_text
		request_text = request_preview
		boss = is_boss

	func _ready() -> void:
		set_process(true)
		texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

	func _process(delta: float) -> void:
		phase += delta
		walk_t += delta / duration
		if walk_t >= 1.0 and not emitted:
			emitted = true
			emit_signal("finished")
		queue_redraw()

	func _draw() -> void:
		var grid_w := 160
		var grid_h := 90
		var tile: int = int(floor(minf(size.x / float(grid_w), size.y / float(grid_h))))
		tile = maxi(3, tile)
		var canvas := Vector2(grid_w * tile, grid_h * tile)
		var origin := (size - canvas) / 2.0
		origin = Vector2(floor(origin.x), floor(origin.y))

		draw_rect(Rect2(origin, canvas), Color(0.05, 0.05, 0.11))
		_draw_floor(origin, tile)

		_draw_stall(origin, tile)

		var title_alpha: float = clampf(walk_t * 1.15, 0.0, 1.0) * (0.88 + 0.08 * sin(phase * 2.0))
		var title_bg := Color(0.06, 0.06, 0.11, 0.92)
		draw_rect(Rect2(origin + Vector2(40 * tile, 6 * tile), Vector2(80 * tile, 14 * tile)), title_bg)
		draw_string(get_theme_default_font(), origin + Vector2(42 * tile, 18 * tile), "你来说我来炒", HORIZONTAL_ALIGNMENT_LEFT, 76 * tile, 28, Color(1.0, 0.9, 0.72, title_alpha))
		draw_string(get_theme_default_font(), origin + Vector2(42 * tile, 28 * tile), "深夜怪菜摊 · 正在接待", HORIZONTAL_ALIGNMENT_LEFT, 76 * tile, 16, Color(0.82, 0.9, 1.0, 0.55 * title_alpha))

		if portrait is Texture2D:
			var p_size := Vector2(18 * tile, 18 * tile)
			var p_pos := origin + Vector2(6 * tile, 6 * tile)
			draw_rect(Rect2(p_pos - Vector2(1 * tile, 1 * tile), p_size + Vector2(2 * tile, 2 * tile)), Color(0.06, 0.06, 0.11, 0.92))
			draw_texture_rect(portrait, Rect2(p_pos, p_size), false, Color(1, 1, 1, 1))

		_draw_stall_pot(origin, tile)

		var t: float = clampf(walk_t, 0.0, 1.0)
		if t < 0.15:
			t = ease(t / 0.15, 2.0) * 0.15
		elif t > 0.75:
			var decel := (t - 0.75) / 0.25
			t = 0.75 + (1.0 - pow(1.0 - decel, 3.0)) * 0.25

		var x: float = lerpf(-18.0, 52.0, t)
		var bob: float = absf(sin(t * PI * 4.0)) * 1.2
		var y: float = 58.0 - bob

		if walk_sheet is Texture2D:
			var fw: int = int(round(float(walk_sheet.get_width()) / float(CHARACTER_SHEET_COLS)))
			var fh: int = int(round(float(walk_sheet.get_height()) / float(CHARACTER_SHEET_ROWS)))
			var walk_frame := int(floor(phase * 10.0)) % 4
			var col := walk_frame % CHARACTER_SHEET_COLS
			var row := CHARACTER_ROW_RIGHT
			var src := Rect2(col * fw, row * fh, fw, fh)
			var dest := Rect2(origin + Vector2(x * tile, (y - float(fh)) * tile), Vector2(fw * tile, fh * tile))
			draw_texture_rect_region(walk_sheet, dest, src, Color(1, 1, 1, 1))
			var shadow_alpha := 0.25 + 0.1 * bob
			draw_rect(Rect2(origin + Vector2((x + 4) * tile, 60 * tile), Vector2(12 * tile, 3 * tile)), Color(0, 0, 0, shadow_alpha))

		if walk_t >= 1.0:
			var st: float = minf((walk_t - 1.0) / 0.4, 1.0)
			var sb: float = 1.0 + (1.0 - st) * 0.06 * sin(st * PI)
			var idle_sheet := walk_sheet
			if idle_sheet is Texture2D:
				var fw: int = int(round(float(idle_sheet.get_width()) / float(CHARACTER_SHEET_COLS)))
				var fh: int = int(round(float(idle_sheet.get_height()) / float(CHARACTER_SHEET_ROWS)))
				var src := Rect2(0, CHARACTER_ROW_FRONT * fh, fw, fh)
				var dest_size := Vector2(fw * tile, fh * tile) * sb
				var dest_origin := origin + Vector2((52 + (fw - fw * sb) / 2.0) * tile, (52 - fh * sb) * tile)
				draw_texture_rect_region(idle_sheet, Rect2(dest_origin, dest_size), src, Color(1, 1, 1, 1))

		if boss:
			var flicker := 0.7 + 0.3 * sin(phase * 6.0)
			draw_rect(Rect2(origin + Vector2(18 * tile, 14 * tile), Vector2(54 * tile, 10 * tile)), Color(0.08, 0.09, 0.16, 0.9))
			draw_string(get_theme_default_font(), origin + Vector2(20 * tile, 22 * tile), "BOSS · " + customer_name, HORIZONTAL_ALIGNMENT_LEFT, 52 * tile, 22, Color(1.0, 0.3, 0.3, flicker))
			draw_string(get_theme_default_font(), origin + Vector2(20 * tile, 34 * tile), customer_role, HORIZONTAL_ALIGNMENT_LEFT, 52 * tile, 14, Color(0.78, 0.88, 1.0, 0.7))
		else:
			var label_col := Color(1.0, 0.94, 0.65, 0.95)
			draw_rect(Rect2(origin + Vector2(18 * tile, 14 * tile), Vector2(54 * tile, 10 * tile)), Color(0.06, 0.06, 0.12, 0.95))
			draw_string(get_theme_default_font(), origin + Vector2(20 * tile, 22 * tile), customer_name, HORIZONTAL_ALIGNMENT_LEFT, 52 * tile, 22, label_col)
			draw_string(get_theme_default_font(), origin + Vector2(20 * tile, 34 * tile), customer_role, HORIZONTAL_ALIGNMENT_LEFT, 52 * tile, 14, Color(0.78, 0.88, 1.0, 0.7))

		_draw_fairy_lights(origin, tile)
		_draw_thought_fragment(origin, tile)
		if boss:
			_draw_boss_glow(origin, tile)

	func _draw_stall(origin: Vector2, tile: int) -> void:
		var stall_x := 78; var stall_w := 70; var stall_y := 20; var stall_h := 56
		draw_rect(Rect2(origin + Vector2(stall_x * tile, stall_y * tile), Vector2(stall_w * tile, stall_h * tile)), Color(0.12, 0.14, 0.22))
		for i in range(8):
			var stripe_x := stall_x + i * 9
			var stripe_color := Color(0.85, 0.25, 0.25) if i % 2 == 0 else Color(1.0, 1.0, 1.0)
			draw_rect(Rect2(origin + Vector2(stripe_x * tile, (stall_y - 8) * tile), Vector2(9 * tile, 8 * tile)), stripe_color)
		var glow := 0.6 + 0.4 * sin(phase * 3.0)
		draw_rect(Rect2(origin + Vector2((stall_x + 10) * tile, (stall_y - 18) * tile), Vector2(50 * tile, 10 * tile)), Color(0.05, 0.05, 0.12, 0.95))
		draw_string(get_theme_default_font(), origin + Vector2((stall_x + 14) * tile, (stall_y - 17) * tile), "怪 菜 快 炒", HORIZONTAL_ALIGNMENT_LEFT, 46 * tile, 24, Color(1.0, 0.3, 0.5, glow))
		var menu_y := stall_y + 8
		draw_rect(Rect2(origin + Vector2((stall_x + 8) * tile, menu_y * tile), Vector2(54 * tile, 22 * tile)), Color(0.06, 0.07, 0.14))
		for i in range(5):
			var line_y := menu_y + 2 + i * 4
			var line_w := 30 + int(sin(float(i) * 1.7) * 10)
			draw_rect(Rect2(origin + Vector2((stall_x + 12) * tile, line_y * tile), Vector2(line_w * tile, 2 * tile)), Color(0.15, 0.18, 0.26))
		var counter_y := stall_y + stall_h - 10
		draw_rect(Rect2(origin + Vector2(stall_x * tile, counter_y * tile), Vector2(stall_w * tile, 10 * tile)), Color(0.18, 0.12, 0.08))
		for i in range(4):
			draw_rect(Rect2(origin + Vector2((stall_x + 2) * tile, (counter_y + 2 + i * 2) * tile), Vector2((stall_w - 4) * tile, 1 * tile)), Color(0.14, 0.10, 0.06))

	func _draw_stall_pot(origin: Vector2, tile: int) -> void:
		var px := 110; var py := 42; var pw := 22; var ph := 16
		draw_rect(Rect2(origin + Vector2(px * tile, py * tile), Vector2(pw * tile, ph * tile)), Color(0.1, 0.11, 0.16))
		draw_rect(Rect2(origin + Vector2((px + 2) * tile, (py + 2) * tile), Vector2((pw - 4) * tile, (ph - 4) * tile)), Color(0.5, 0.33, 0.18))
		for i in range(6):
			var bx := px + 4 + i * 3 + int(sin(phase * 4.0 + i) * 1.5)
			var by := py + 4 + int(fposmod(phase * 8.0 + i * 3.0, 8.0))
			draw_rect(Rect2(origin + Vector2(bx * tile, by * tile), Vector2(tile, tile)), Color(1.0, 1.0, 1.0, 0.3))
		for i in range(4):
			var sx := px + 4 + i * 5
			var sy := py - 2 - int(fposmod(phase * 12.0 + i * 4.0, 10.0))
			draw_rect(Rect2(origin + Vector2(sx * tile, sy * tile), Vector2(3 * tile, 6 * tile)), Color(0.9, 0.95, 1.0, 0.2))

	func _draw_floor(origin: Vector2, tile: int) -> void:
		var floor_y := 58
		draw_rect(Rect2(origin + Vector2(0, floor_y * tile), Vector2(160 * tile, 32 * tile)), Color(0.06, 0.07, 0.14))
		for i in range(8):
			draw_rect(Rect2(origin + Vector2(i * 20 * tile, floor_y * tile), Vector2(tile, 32 * tile)), Color(0.09, 0.10, 0.18))
		for j in range(4):
			draw_rect(Rect2(origin + Vector2(0, (floor_y + j * 8) * tile), Vector2(160 * tile, tile)), Color(0.09, 0.10, 0.18))
		draw_rect(Rect2(origin + Vector2(78 * tile, floor_y * tile), Vector2(70 * tile, 22 * tile)), Color(1.0, 0.8, 0.4, 0.04))

	func _draw_fairy_lights(origin: Vector2, tile: int) -> void:
		var light_y := 8
		var colors: Array[Color] = [COLOR_PRIMARY, COLOR_SECONDARY, COLOR_ACCENT, COLOR_FOOD]
		for i in range(13):
			var lx := i * 12 + 6
			var flicker := 0.5 + 0.5 * sin(phase * (4.0 + i * 0.7) + i * 1.3)
			var c: Color = colors[i % colors.size()]
			draw_circle(origin + Vector2(lx * tile, light_y * tile), 2 * tile, Color(c.r, c.g, c.b, 0.4 + flicker * 0.5))
			draw_circle(origin + Vector2(lx * tile, light_y * tile), 5 * tile, Color(c.r, c.g, c.b, 0.06 + flicker * 0.05))
			draw_line(origin + Vector2(lx * tile, (light_y + 2) * tile), origin + Vector2(lx * tile, (light_y + 12) * tile), Color(c.r, c.g, c.b, 0.10), 1)

	func _draw_thought_fragment(origin: Vector2, tile: int) -> void:
		if walk_t < 0.5:
			return
		var ft := (walk_t - 0.5) / 0.5
		var fa := clampf(ft * ft, 0.0, 0.7)
		var bx := 50; var by := 34 - ft * 8
		draw_rect(Rect2(origin + Vector2(bx * tile, by * tile), Vector2(40 * tile, 14 * tile)), Color(0.08, 0.09, 0.16, fa))
		var preview_text := str(request_text).substr(0, 10) + "…"
		draw_string(get_theme_default_font(), origin + Vector2((bx + 2) * tile, (by + 2) * tile), preview_text, HORIZONTAL_ALIGNMENT_LEFT, 36 * tile, 14, Color(0.9, 0.95, 1.0, fa))

	func _draw_boss_glow(origin: Vector2, tile: int) -> void:
		var glow := 0.06 + 0.04 * sin(phase * 2.5)
		var gc := Color(1.0, 0.15, 0.15, glow)
		for i in range(4):
			var m := i * 2
			draw_rect(Rect2(origin + Vector2(m * tile, m * tile), Vector2((160 - m * 2) * tile, tile)), gc)
			draw_rect(Rect2(origin + Vector2(m * tile, (90 - m) * tile), Vector2((160 - m * 2) * tile, tile)), gc)
			draw_rect(Rect2(origin + Vector2(m * tile, m * tile), Vector2(tile, (90 - m * 2) * tile)), gc)
			draw_rect(Rect2(origin + Vector2((160 - m) * tile, m * tile), Vector2(tile, (90 - m * 2) * tile)), gc)

func _ensure_item_icons_on_disk() -> void:
	var dir_abs := ProjectSettings.globalize_path(ITEM_ICON_DIR)
	DirAccess.make_dir_recursive_absolute(dir_abs)

	var work: Array = []
	for item in INGREDIENTS:
		var id := str(item.get("id", ""))
		if id != "":
			work.append(id)
	for item in SEASONINGS:
		var id := str(item.get("id", ""))
		if id != "":
			work.append(id)

	for id in work:
		var item_id := str(id).strip_edges()
		if item_id == "":
			continue
		var out_abs := dir_abs.path_join("%s.png" % item_id)
		if FileAccess.file_exists(out_abs):
			var keep := false
			var probe := Image.new()
			if probe.load(out_abs) == OK:
				if probe.get_width() == 64 and probe.get_height() == 64:
					keep = true
			if keep:
				continue

		var kind := ""
		if item_id.begins_with("ingredient_"):
			kind = "ingredient"
		elif item_id.begins_with("seasoning_"):
			kind = "seasoning"
		else:
			continue

		var a := COLOR_FOOD
		var b := COLOR_SECONDARY
		if kind == "seasoning":
			a = COLOR_PRIMARY
			b = COLOR_SECONDARY

		var icon_key := item_id
		var image := Image.create(64, 64, false, Image.FORMAT_RGBA8)
		image.fill(Color(0, 0, 0, 0))
		_draw_named_icon(image, icon_key, a, b)
		image.save_png(out_abs)
		file_texture_cache.erase("%s/%s.png" % [ITEM_ICON_DIR, item_id])

func _images_match(a: Image, b: Image) -> bool:
	if a == null or b == null:
		return false
	if a.get_width() != b.get_width() or a.get_height() != b.get_height():
		return false
	var w := a.get_width()
	var h := a.get_height()
	for y in range(0, h, 8):
		for x in range(0, w, 8):
			var ca := a.get_pixel(x, y)
			var cb := b.get_pixel(x, y)
			if absf(ca.r - cb.r) > 0.01 or absf(ca.g - cb.g) > 0.01 or absf(ca.b - cb.b) > 0.01 or absf(ca.a - cb.a) > 0.01:
				return false
	return true

func _process(delta: float) -> void:
	if screen_state != "playing":
		return
	time_left -= delta
	if time_left <= 0.0:
		time_left = 0.0
		_auto_complete_for_timeout()
		_submit_dish(true)
		return
	_update_timer_label()
	_update_vignette()
	_process_bg_movement(delta)

func _show_start_screen() -> void:
	screen_state = "start"
	_clear_screen()
	var page := _make_page()
	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 12)
	page.add_child(box)

	box.add_child(_build_home_nav())

	var body := HBoxContainer.new()
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 14)
	box.add_child(body)

	body.add_child(_build_home_poster())
	body.add_child(_build_home_info_panel())

func _build_home_nav() -> Control:
	var panel := _make_panel(Color(0.035, 0.048, 0.062), Color(0.16, 0.48, 0.55), 10)
	panel.custom_minimum_size = Vector2(0, 68)
	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 12)
	panel.add_child(row)

	var logo := _make_label("你来说我来炒", 30, Color(0.98, 0.72, 0.9), HORIZONTAL_ALIGNMENT_CENTER)
	logo.custom_minimum_size = Vector2(260, 0)
	row.add_child(logo)

	var overview := _make_action_button("游戏概况", 18, _home_tab_color("overview"), Color(0.28, 0.64, 0.68))
	overview.custom_minimum_size = Vector2(130, 44)
	overview.pressed.connect(_set_home_tab.bind("overview"))
	row.add_child(overview)

	var rules := _make_action_button("玩法说明", 18, _home_tab_color("rules"), Color(0.28, 0.64, 0.68))
	rules.custom_minimum_size = Vector2(130, 44)
	rules.pressed.connect(_set_home_tab.bind("rules"))
	row.add_child(rules)

	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(spacer)

	var ai_status_button := _make_action_button("API 已配置" if _has_playable_ai_config() else "未配置 API", 18, Color(0.11, 0.18, 0.22), Color(0.42, 0.7, 0.72))
	ai_status_button.custom_minimum_size = Vector2(190, 44)
	ai_status_button.disabled = true
	row.add_child(ai_status_button)
	return panel

func _build_home_poster() -> Control:
	var panel := _make_panel(Color(0.035, 0.042, 0.055), Color(0.16, 0.34, 0.46), 14)
	panel.custom_minimum_size = Vector2(720, 0)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 12)
	panel.add_child(stack)

	var poster := TextureRect.new()
	poster.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	poster.size_flags_vertical = Control.SIZE_EXPAND_FILL
	poster.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	poster.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	poster.texture = load(HOME_POSTER_PATH)
	stack.add_child(poster)

	var caption := _make_label("未来校园夜市营业中：读懂顾客，选择食材，把情绪炒成一锅能被 AI 点评的怪菜。", 17, Color(0.78, 0.86, 0.9), HORIZONTAL_ALIGNMENT_CENTER)
	caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	stack.add_child(caption)
	return panel

func _build_home_info_panel() -> Control:
	var panel := _make_panel(Color(0.055, 0.062, 0.076), Color(0.28, 0.36, 0.48), 14)
	panel.custom_minimum_size = Vector2(460, 0)
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	panel.add_child(box)

	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_child(scroll)

	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 12)
	scroll.add_child(content)

	if home_tab == "rules":
		content.add_child(_make_label("玩法说明", 32, Color(1.0, 0.82, 0.38), HORIZONTAL_ALIGNMENT_CENTER))
		content.add_child(_make_home_paragraph("1. API 配置是可选项；不配置也能玩，出锅时使用本地评分。\n2. 每单顾客会提出抽象需求。\n3. 选择 2-3 个食材、1-2 个调料和 1 种烹饪方式。\n4. 配置 API 后，AI 会根据顾客需求和菜品语义评分。\n5. 一局 5 单，第 5 单必出 Boss。"))
	else:
		content.add_child(_make_label("游戏概况", 32, Color(1.0, 0.82, 0.38), HORIZONTAL_ALIGNMENT_CENTER))
		content.add_child(_make_home_paragraph("你经营一家未来校园夜市里的怪菜摊。顾客说不清自己想吃什么，只能给出情绪、场景和一点离谱暗示。你的任务是把这些需求翻译成食材组合，让小炒 AI-7 判断这锅东西到底有没有读懂人。"))
		content.add_child(_make_home_paragraph("AI 是游戏的一部分：配置 API 后，它会在出锅后用自然语言评价菜名、贴题度、美味度、情绪命中和风险值；未配置时游戏会使用本地评分。"))

	var ai_status := "AI：未配置，出锅时使用本地评分"
	if _has_playable_ai_config():
		ai_status = "AI：已配置，可以开始"
	content.add_child(_make_label(ai_status, 18, Color(0.72, 0.88, 0.9), HORIZONTAL_ALIGNMENT_CENTER))
	content.add_child(_make_separator())
	content.add_child(_build_ai_config_panel())

	var start_button := _make_action_button("开始一局", 26, Color(0.38, 0.13, 0.16), Color(0.95, 0.43, 0.48))
	start_button.custom_minimum_size = Vector2(0, 60)
	start_button.pressed.connect(_start_game)
	box.add_child(start_button)
	return panel

func _make_home_paragraph(text: String) -> Label:
	var label := _make_label(text, 19, Color(0.88, 0.92, 0.96))
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label

func _set_home_tab(tab: String) -> void:
	home_tab = tab
	_show_start_screen()

func _home_tab_color(tab: String) -> Color:
	if home_tab == tab:
		return Color(0.12, 0.28, 0.32)
	return Color(0.09, 0.12, 0.14)

func _show_auth_screen(mode: String = "login") -> void:
	screen_state = "auth"
	auth_mode = mode
	_clear_screen()
	var page := _make_page()
	var center := CenterContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	page.add_child(center)

	var panel := _make_panel(Color(0.045, 0.055, 0.07), Color(0.28, 0.5, 0.58), 14)
	panel.custom_minimum_size = Vector2(560, 500)
	center.add_child(panel)
	var box := VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 14)
	panel.add_child(box)

	box.add_child(_make_label("账号入口", 36, Color(1.0, 0.82, 0.38), HORIZONTAL_ALIGNMENT_CENTER))
	box.add_child(_make_label("Supabase Auth 邮箱密码登录。演示环境建议关闭邮箱确认。", 16, Color(0.72, 0.82, 0.88), HORIZONTAL_ALIGNMENT_CENTER))

	var tabs := HBoxContainer.new()
	tabs.alignment = BoxContainer.ALIGNMENT_CENTER
	tabs.add_theme_constant_override("separation", 10)
	box.add_child(tabs)
	var login_tab := _make_action_button("登录", 18, Color(0.12, 0.28, 0.32) if auth_mode == "login" else Color(0.09, 0.12, 0.14), Color(0.28, 0.64, 0.68))
	login_tab.custom_minimum_size = Vector2(120, 42)
	login_tab.pressed.connect(_show_auth_screen.bind("login"))
	tabs.add_child(login_tab)
	var signup_tab := _make_action_button("注册", 18, Color(0.12, 0.28, 0.32) if auth_mode == "signup" else Color(0.09, 0.12, 0.14), Color(0.28, 0.64, 0.68))
	signup_tab.custom_minimum_size = Vector2(120, 42)
	signup_tab.pressed.connect(_show_auth_screen.bind("signup"))
	tabs.add_child(signup_tab)

	auth_email_input = _make_line_edit("邮箱")
	auth_email_input.custom_minimum_size = Vector2(420, 44)
	box.add_child(auth_email_input)
	auth_password_input = _make_line_edit("密码")
	auth_password_input.secret = true
	auth_password_input.custom_minimum_size = Vector2(420, 44)
	box.add_child(auth_password_input)

	if auth_notice != "":
		var notice := _make_label(auth_notice, 16, Color(1.0, 0.7, 0.58), HORIZONTAL_ALIGNMENT_CENTER)
		notice.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		box.add_child(notice)

	var submit := _make_action_button("注册并登录" if auth_mode == "signup" else "登录", 22, Color(0.38, 0.13, 0.16), Color(0.95, 0.43, 0.48))
	submit.custom_minimum_size = Vector2(420, 54)
	submit.pressed.connect(_submit_auth_form)
	box.add_child(submit)

	var back := _make_action_button("返回首页", 18, Color(0.11, 0.14, 0.16), Color(0.32, 0.4, 0.46))
	back.custom_minimum_size = Vector2(420, 44)
	back.pressed.connect(_show_start_screen)
	box.add_child(back)

func _show_profile_screen() -> void:
	if not _is_logged_in():
		auth_notice = "请先登录，再进入用户中心。"
		_show_auth_screen("login")
		return
	screen_state = "profile"
	_clear_screen()
	var page := _make_page()
	var body := HBoxContainer.new()
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 14)
	page.add_child(body)

	body.add_child(_build_profile_panel())
	body.add_child(_build_ai_config_panel())

func _build_profile_panel() -> Control:
	var panel := _make_panel(Color(0.05, 0.06, 0.074), Color(0.26, 0.4, 0.48), 14)
	panel.custom_minimum_size = Vector2(430, 0)
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 14)
	panel.add_child(box)

	box.add_child(_make_label("用户中心", 34, Color(1.0, 0.82, 0.38), HORIZONTAL_ALIGNMENT_CENTER))
	var avatar_preview := TextureRect.new()
	avatar_preview.custom_minimum_size = Vector2(180, 180)
	avatar_preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	avatar_preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	avatar_preview.texture = _get_avatar_texture()
	var avatar_center := CenterContainer.new()
	avatar_center.add_child(avatar_preview)
	box.add_child(avatar_center)

	profile_username_input = _make_line_edit("用户名")
	profile_username_input.text = _user_display_name()
	profile_username_input.custom_minimum_size = Vector2(0, 44)
	box.add_child(profile_username_input)

	var save_name := _make_action_button("保存用户名", 19, Color(0.12, 0.28, 0.32), Color(0.28, 0.64, 0.68))
	save_name.custom_minimum_size = Vector2(0, 48)
	save_name.pressed.connect(_save_profile_name)
	box.add_child(save_name)

	var upload_avatar := _make_action_button("上传本地头像", 19, Color(0.12, 0.18, 0.22), Color(0.42, 0.7, 0.72))
	upload_avatar.custom_minimum_size = Vector2(0, 48)
	upload_avatar.pressed.connect(_open_avatar_file_dialog)
	box.add_child(upload_avatar)

	if profile_notice != "":
		var notice := _make_label(profile_notice, 16, Color(1.0, 0.7, 0.58), HORIZONTAL_ALIGNMENT_CENTER)
		notice.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		box.add_child(notice)

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_child(spacer)

	var logout := _make_action_button("退出登录", 18, Color(0.2, 0.09, 0.1), Color(0.7, 0.22, 0.26))
	logout.custom_minimum_size = Vector2(0, 46)
	logout.pressed.connect(_logout)
	box.add_child(logout)

	var back := _make_action_button("返回首页", 18, Color(0.11, 0.14, 0.16), Color(0.32, 0.4, 0.46))
	back.custom_minimum_size = Vector2(0, 46)
	back.pressed.connect(_show_start_screen)
	box.add_child(back)
	return panel

func _build_ai_config_panel() -> Control:
	var panel := _make_panel(Color(0.045, 0.053, 0.065), Color(0.28, 0.36, 0.48), 10)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	panel.add_child(box)

	box.add_child(_make_label("API 配置", 26, Color(1.0, 0.82, 0.38), HORIZONTAL_ALIGNMENT_CENTER))
	box.add_child(_make_home_paragraph("配置只保存在本机；不配置也能开始游戏，只是出锅评价会使用本地评分。"))

	ai_provider_option = OptionButton.new()
	ai_provider_option.add_theme_font_size_override("font_size", 18)
	ai_provider_option.add_item("DeepSeek", 0)
	ai_provider_option.set_item_metadata(0, "deepseek")
	ai_provider_option.add_item("GLM", 1)
	ai_provider_option.set_item_metadata(1, "glm")
	ai_provider_option.add_item("自定义", 2)
	ai_provider_option.set_item_metadata(2, "custom")
	ai_provider_option.custom_minimum_size = Vector2(0, 42)
	ai_provider_option.item_selected.connect(_on_ai_provider_selected)
	box.add_child(ai_provider_option)

	ai_endpoint_input = _make_line_edit("Endpoint")
	ai_endpoint_input.custom_minimum_size = Vector2(0, 42)
	box.add_child(ai_endpoint_input)
	ai_key_input = _make_line_edit("API Key")
	ai_key_input.secret = true
	ai_key_input.custom_minimum_size = Vector2(0, 42)
	box.add_child(ai_key_input)
	ai_model_input = _make_line_edit("Model")
	ai_model_input.custom_minimum_size = Vector2(0, 42)
	box.add_child(ai_model_input)
	_fill_ai_config_form()

	if _selected_ai_provider() != "custom":
		ai_endpoint_input.editable = false
		ai_endpoint_input.mouse_filter = Control.MOUSE_FILTER_IGNORE
		ai_endpoint_input.visible = false
		ai_model_input.editable = false
		ai_model_input.mouse_filter = Control.MOUSE_FILTER_IGNORE
		ai_model_input.visible = false

	var save_ai := _make_action_button("保存 AI 配置", 20, Color(0.38, 0.13, 0.16), Color(0.95, 0.43, 0.48))
	save_ai.custom_minimum_size = Vector2(0, 48)
	save_ai.pressed.connect(_save_ai_config_from_form)
	box.add_child(save_ai)

	if ai_config_notice != "":
		var notice := _make_label(ai_config_notice, 15, Color(1.0, 0.7, 0.58), HORIZONTAL_ALIGNMENT_CENTER)
		notice.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		box.add_child(notice)

	var hint := _make_label("DeepSeek / GLM 使用官方默认配置，只需填写 API Key；选择自定义后可填写 Endpoint 和 Model。", 14, Color(0.72, 0.8, 0.86))
	hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(hint)
	return panel

func _start_game() -> void:
	order_index = 0
	total_score = 0
	total_coins = 0
	current_funds = INITIAL_FUNDS
	total_exp = 0
	player_level = 1
	player_title = _title_for_level(player_level)
	completed_orders = 0
	current_service_cost = 0
	day_index = 1
	combo_count = 0
	round_results.clear()
	active_buffs.clear()
	pending_buff_choices.clear()
	mistake_insurance_used = false
	normal_order_pool = _get_orders(false)
	_pick_next_order()
	_show_approach_screen()

func _pick_next_order() -> void:
	selected_ingredient_ids.clear()
	selected_seasoning_ids.clear()
	selected_method_id = ""
	message_text = ""
	time_left = ROUND_SECONDS
	current_customer_variant_index = rng.randi_range(0, CHARACTER_IDLE_SHEETS.size() - 1)
	day_index = int(floor(float(completed_orders) / float(TOTAL_ORDERS))) + 1
	if order_index == TOTAL_ORDERS - 1:
		var boss_orders := _get_orders(true)
		current_order = boss_orders[rng.randi_range(0, boss_orders.size() - 1)]
	else:
		if normal_order_pool.is_empty():
			normal_order_pool = _get_orders(false)
		var pool_index := rng.randi_range(0, normal_order_pool.size() - 1)
		current_order = normal_order_pool[pool_index]
		normal_order_pool.remove_at(pool_index)
	current_service_cost = 0
	if current_funds < _peek_next_service_cost():
		day_index = int(floor(float(completed_orders) / float(TOTAL_ORDERS))) + 1
		_show_bankruptcy_screen()
		return
	var desired_tags: Array = current_order.get("desired_tags", [])
	presented_ingredients = _roll_presented_items(INGREDIENTS, desired_tags, 12, 6)
	presented_seasonings = _roll_presented_items(SEASONINGS, desired_tags, 10, 4)
	screen_state = "approach"

func _roll_presented_items(source: Array, desired_tags: Array, total: int, min_relevant: int) -> Array:
	var relevant: Array = []
	var irrelevant: Array = []
	for item in source:
		var tags: Array = item.get("tags", [])
		if _has_overlap(tags, desired_tags):
			relevant.append(item)
		else:
			irrelevant.append(item)

	var picked: Array = []
	var want_total := clampi(total, 1, source.size())
	var desired_unique: Array = []
	for t in desired_tags:
		var s := str(t).strip_edges()
		if s != "" and not desired_unique.has(s):
			desired_unique.append(s)
	var uncovered := desired_unique.duplicate()

	while picked.size() < want_total and not uncovered.is_empty() and not relevant.is_empty():
		var best_gain := 0
		var best_indices: Array[int] = []
		for i in range(relevant.size()):
			var tags: Array = relevant[i].get("tags", [])
			var gain := 0
			for ut in uncovered:
				if tags.has(ut):
					gain += 1
			if gain > best_gain:
				best_gain = gain
				best_indices.clear()
				best_indices.append(i)
			elif gain == best_gain and gain > 0:
				best_indices.append(i)
		if best_gain <= 0 or best_indices.is_empty():
			break
		var pick_idx := best_indices[rng.randi_range(0, best_indices.size() - 1)]
		var picked_item = relevant[pick_idx]
		picked.append(picked_item)
		var picked_tags: Array = picked_item.get("tags", [])
		for j in range(uncovered.size() - 1, -1, -1):
			if picked_tags.has(uncovered[j]):
				uncovered.remove_at(j)
		relevant.remove_at(pick_idx)

	var available_relevant_total := picked.size() + relevant.size()
	var want_relevant := clampi(min_relevant, 0, want_total)
	want_relevant = mini(want_relevant, available_relevant_total)
	while picked.size() < want_total and picked.size() < want_relevant and not relevant.is_empty():
		var idx := rng.randi_range(0, relevant.size() - 1)
		picked.append(relevant[idx])
		relevant.remove_at(idx)

	while picked.size() < want_total and not relevant.is_empty():
		var idx := rng.randi_range(0, relevant.size() - 1)
		picked.append(relevant[idx])
		relevant.remove_at(idx)

	while picked.size() < want_total and not irrelevant.is_empty():
		var idx := rng.randi_range(0, irrelevant.size() - 1)
		picked.append(irrelevant[idx])
		irrelevant.remove_at(idx)

	return picked

func _has_overlap(a: Array, b: Array) -> bool:
	if a.is_empty() or b.is_empty():
		return false
	for t in b:
		if a.has(t):
			return true
	return false

func _show_approach_screen() -> void:
	screen_state = "approach"
	_clear_screen()
	var page := _make_page()
	var walk_sheet := _get_customer_walk_sheet_index(current_customer_variant_index)
	var portrait := _get_customer_portrait_index(current_customer_variant_index)
	if ResourceLoader.exists(APPROACH_CUTSCENE_SCENE):
		var scene := load(APPROACH_CUTSCENE_SCENE)
		if scene is PackedScene:
			var instance := (scene as PackedScene).instantiate()
			if instance is Control:
				var cutscene := instance as Control
				cutscene.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				cutscene.size_flags_vertical = Control.SIZE_EXPAND_FILL
				if cutscene.has_method("setup"):
					cutscene.call("setup", walk_sheet, portrait, str(current_order.get("customer_name", "")), str(current_order.get("role", "")), bool(current_order.get("boss", false)))
				if cutscene.has_signal("finished"):
					cutscene.connect("finished", Callable(self, "_on_approach_finished"))
				page.add_child(cutscene)
				return
	var view := StallApproachView.new()
	view.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	view.size_flags_vertical = Control.SIZE_EXPAND_FILL
	view.setup(walk_sheet, portrait, str(current_order.get("customer_name", "")), str(current_order.get("role", "")), str(current_order.get("request", "")), bool(current_order.get("boss", false)))
	view.finished.connect(_on_approach_finished)
	page.add_child(view)

func _on_approach_finished() -> void:
	var hold := create_tween()
	hold.tween_interval(0.3)
	hold.tween_callback(func(): _show_game_screen(true))

func _show_game_screen(animate_in: bool = false) -> void:
	screen_state = "playing"
	_clear_screen()
	var page := _make_page()

	var root := VBoxContainer.new()
	playing_root = root
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_theme_constant_override("separation", 10)
	page.add_child(root)

	root.add_child(_build_top_bar())

	var body := HBoxContainer.new()
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 12)
	root.add_child(body)

	body.add_child(_build_customer_panel_left())
	body.add_child(_build_pot_panel_center())
	body.add_child(_build_library_panel_right())

	root.add_child(_build_bottom_bar())
	_refresh_playing_ui()
	if animate_in:
		root.modulate = Color(1.0, 1.0, 1.0, 0.0)
		var tween := create_tween()
		tween.tween_property(root, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.28)

func _build_header() -> Control:
	var header := HBoxContainer.new()
	header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_theme_constant_override("separation", 10)
	header.add_child(_build_logo_panel())
	header.add_child(_build_session_bar())
	return header

func _build_logo_panel() -> Control:
	var panel := _make_panel(Color(0.04, 0.065, 0.085), Color(0.16, 0.56, 0.62), 12)
	panel.custom_minimum_size = Vector2(300, 56)
	var label := _make_label("你来说我来炒", 28, Color(0.98, 0.72, 0.9), HORIZONTAL_ALIGNMENT_CENTER)
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	panel.add_child(label)
	return panel

func _build_session_bar() -> Control:
	var panel := _make_panel()
	panel.custom_minimum_size = Vector2(0, 52)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 28)
	panel.add_child(row)

	row.add_child(_make_label("第 %d 天  %d / %d 单%s" % [day_index, order_index + 1, TOTAL_ORDERS, "  BOSS" if current_order.get("boss", false) else ""], 20, Color(1.0, 0.84, 0.58)))
	row.add_child(_make_label("资金  %d" % current_funds, 20, Color(0.96, 0.78, 0.42)))
	row.add_child(_make_label("成本  %d" % current_service_cost, 19, Color(1.0, 0.58, 0.48)))
	row.add_child(_make_label("%s Lv.%d" % [player_title, player_level], 18, Color(0.82, 1.0, 0.82)))
	row.add_child(_make_label("经验  %d" % total_exp, 18, Color(0.72, 0.88, 1.0)))
	return panel

func _build_selection_panel() -> Control:
	var panel := _make_panel(Color(0.055, 0.072, 0.078), Color(0.22, 0.55, 0.58), 12)
	panel.custom_minimum_size = Vector2(300, 0)
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_child(scroll)
	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 10)
	scroll.add_child(box)

	box.add_child(_make_label("食材 & 调料", 23, Color(0.96, 0.86, 0.7), HORIZONTAL_ALIGNMENT_CENTER))
	var ingredient_list := VBoxContainer.new()
	ingredient_list.add_theme_constant_override("separation", 8)
	box.add_child(ingredient_list)
	for item in INGREDIENTS:
		var button := _make_option_button(item["name"], 19)
		button.custom_minimum_size = Vector2(0, 56)
		button.tooltip_text = item["description"]
		button.disabled = selected_ingredient_ids.has(item["id"])
		button.pressed.connect(_on_add_ingredient.bind(item["id"]))
		ingredient_list.add_child(button)

	box.add_child(_make_separator())
	var seasoning_list := VBoxContainer.new()
	seasoning_list.add_theme_constant_override("separation", 8)
	box.add_child(seasoning_list)
	for item in SEASONINGS:
		var button := _make_option_button(item["name"], 19)
		button.custom_minimum_size = Vector2(0, 56)
		button.tooltip_text = item["description"]
		button.disabled = selected_seasoning_ids.has(item["id"])
		button.pressed.connect(_on_add_seasoning.bind(item["id"]))
		seasoning_list.add_child(button)

	return panel

func _build_pot_panel() -> Control:
	var panel := _make_panel(Color(0.055, 0.062, 0.066), Color(0.19, 0.32, 0.36), 14)
	panel.custom_minimum_size = Vector2(0, 0)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	panel.add_child(box)

	var title := _make_label("深夜快炒台", 25, Color(0.96, 0.82, 0.58), HORIZONTAL_ALIGNMENT_CENTER)
	box.add_child(title)

	var wok := CenterContainer.new()
	wok.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	wok.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var wok_label := _make_label("◜       ◝\n\n     这锅正在等一个理由\n\n◟       ◞", 30, Color(0.94, 0.78, 0.52), HORIZONTAL_ALIGNMENT_CENTER)
	wok_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	wok.add_child(wok_label)
	box.add_child(wok)

	box.add_child(_make_label("已选食材", 16, Color(0.95, 0.9, 0.78)))
	var selected_ingredients := GridContainer.new()
	selected_ingredients.columns = 3
	selected_ingredients.add_theme_constant_override("h_separation", 8)
	selected_ingredients.add_theme_constant_override("v_separation", 8)
	box.add_child(selected_ingredients)
	_add_selected_buttons(selected_ingredients, selected_ingredient_ids, INGREDIENTS, _on_remove_ingredient)

	box.add_child(_make_label("已选调料", 16, Color(0.95, 0.9, 0.78)))
	var selected_seasonings := GridContainer.new()
	selected_seasonings.columns = 2
	selected_seasonings.add_theme_constant_override("h_separation", 8)
	selected_seasonings.add_theme_constant_override("v_separation", 8)
	box.add_child(selected_seasonings)
	_add_selected_buttons(selected_seasonings, selected_seasoning_ids, SEASONINGS, _on_remove_seasoning)

	box.add_child(_make_label("点击左侧加入，点击锅内项目移除。", 14, Color(0.62, 0.7, 0.78), HORIZONTAL_ALIGNMENT_CENTER))
	return panel

func _build_cooking_bar() -> Control:
	var panel := _make_panel(Color(0.035, 0.048, 0.062), Color(0.16, 0.25, 0.31), 10)
	panel.custom_minimum_size = Vector2(0, 82)
	return panel

func _build_top_bar() -> Control:
	var panel := _make_panel(Color(0.16, 0.165, 0.26), Color(0.36, 0.4, 0.56), 12)
	panel.custom_minimum_size = Vector2(0, 48)
	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 16)
	panel.add_child(row)

	var left := HBoxContainer.new()
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.alignment = BoxContainer.ALIGNMENT_BEGIN
	left.add_theme_constant_override("separation", 8)
	row.add_child(left)

	var timer_icon := TextureRect.new()
	timer_icon.texture = _get_icon("ui_timer", 24, COLOR_PRIMARY, COLOR_SECONDARY)
	timer_icon.custom_minimum_size = Vector2(24, 24)
	timer_icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	timer_icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	left.add_child(timer_icon)
	timer_label = _make_label("%02d" % int(ROUND_SECONDS), 28, COLOR_TEXT, HORIZONTAL_ALIGNMENT_LEFT)
	left.add_child(timer_label)

	order_label = _make_label("", 20, COLOR_TEXT, HORIZONTAL_ALIGNMENT_CENTER)
	order_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(order_label)

	var center := HBoxContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_theme_constant_override("separation", 18)
	row.add_child(center)

	funds_label = _make_label("", 20, COLOR_SECONDARY, HORIZONTAL_ALIGNMENT_CENTER)
	center.add_child(funds_label)

	title_label = _make_label("", 18, Color(0.82, 1.0, 0.82), HORIZONTAL_ALIGNMENT_CENTER)
	center.add_child(title_label)

	var right := HBoxContainer.new()
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right.alignment = BoxContainer.ALIGNMENT_END
	right.add_theme_constant_override("separation", 8)
	row.add_child(right)

	exp_label = _make_label("", 16, Color(0.72, 0.88, 1.0), HORIZONTAL_ALIGNMENT_RIGHT)
	right.add_child(exp_label)
	exp_progress_bar = ProgressBar.new()
	exp_progress_bar.min_value = 0
	exp_progress_bar.max_value = 100
	exp_progress_bar.show_percentage = false
	exp_progress_bar.custom_minimum_size = Vector2(180, 18)
	right.add_child(exp_progress_bar)
	return panel

func _build_customer_panel_left() -> Control:
	if ResourceLoader.exists(CUSTOMER_PANEL_LEFT_SCENE):
		var scene := load(CUSTOMER_PANEL_LEFT_SCENE)
		if scene is PackedScene:
			var instance := (scene as PackedScene).instantiate()
			if instance is PanelContainer:
				var panel := instance as PanelContainer
				_apply_panel_style(panel, Color(0.14, 0.145, 0.23), Color(0.34, 0.38, 0.54), 12)

				var avatar_frame := panel.find_child("AvatarFrame", true, false)
				if avatar_frame is PanelContainer:
					_apply_panel_style(avatar_frame as PanelContainer, Color(0.12, 0.125, 0.2), Color(0.34, 0.38, 0.54), 12)

				var request_panel := panel.find_child("RequestPanel", true, false)
				if request_panel is PanelContainer:
					_apply_panel_style(request_panel as PanelContainer, Color(0.155, 0.16, 0.255), Color(0.32, 0.36, 0.52), 12)

				var avatar := panel.find_child("Avatar", true, false)
				if avatar is TextureRect:
					customer_avatar_rect = avatar as TextureRect
					customer_avatar_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

				var body := panel.find_child("Body", true, false)
				if body is TextureRect:
					customer_body_rect = body as TextureRect
					customer_body_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

				var signature := panel.find_child("Signature", true, false)
				if signature is Label:
					customer_signature_label = signature as Label
					customer_signature_label.add_theme_font_size_override("font_size", 22)
					customer_signature_label.add_theme_color_override("font_color", Color(1.0, 0.92, 0.3, 1.0))

				var header_title := panel.find_child("Title", true, false)
				if header_title is Label:
					(header_title as Label).add_theme_font_size_override("font_size", 16)
					(header_title as Label).add_theme_color_override("font_color", Color(0.78, 0.84, 0.92, 0.75))

				var request := panel.find_child("Request", true, false)
				if request is Label:
					customer_request_label = request as Label
					customer_request_label.add_theme_color_override("font_color", COLOR_TEXT)

				var wants := panel.find_child("WantsLabel", true, false)
				if wants is Label:
					(wants as Label).add_theme_color_override("font_color", Color(0.78, 0.88, 1.0))

				return panel

	var fallback := _make_panel(Color(0.14, 0.145, 0.23), Color(0.34, 0.38, 0.54), 12)
	fallback.custom_minimum_size = Vector2(340, 0)
	fallback.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 12)
	fallback.add_child(box)

	var header := HBoxContainer.new()
	header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_theme_constant_override("separation", 12)
	box.add_child(header)

	customer_avatar_rect = TextureRect.new()
	customer_avatar_rect.custom_minimum_size = Vector2(72, 72)
	customer_avatar_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	customer_avatar_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	customer_avatar_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	header.add_child(customer_avatar_rect)

	var right := VBoxContainer.new()
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right.add_theme_constant_override("separation", 6)
	header.add_child(right)

	right.add_child(_make_label("订单", 18, COLOR_SECONDARY))
	customer_signature_label = _make_label("", 22, Color(1.0, 0.92, 0.3, 1.0))
	customer_signature_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	right.add_child(customer_signature_label)

	var body_center := CenterContainer.new()
	body_center.custom_minimum_size = Vector2(0, 240)
	body_center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_child(body_center)
	customer_body_rect = TextureRect.new()
	customer_body_rect.custom_minimum_size = Vector2(240, 240)
	customer_body_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	customer_body_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	customer_body_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	body_center.add_child(customer_body_rect)

	var request_panel2 := _make_panel(Color(0.155, 0.16, 0.255), Color(0.32, 0.36, 0.52), 12)
	request_panel2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	request_panel2.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_child(request_panel2)
	var request_box := VBoxContainer.new()
	request_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	request_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	request_box.add_theme_constant_override("separation", 8)
	request_panel2.add_child(request_box)

	customer_request_label = _make_label("", 22, COLOR_TEXT)
	customer_request_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	customer_request_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	request_box.add_child(customer_request_label)

	var wants2 := _make_label("", 16, Color(0.78, 0.88, 1.0))
	wants2.name = "WantsLabel"
	wants2.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	request_box.add_child(wants2)

	return fallback

func _build_pot_panel_center() -> Control:
	var panel := _make_panel(Color(0.14, 0.145, 0.23), Color(0.34, 0.38, 0.54), 12)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 10)
	panel.add_child(box)

	var chips_scroll := ScrollContainer.new()
	chips_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	chips_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	chips_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	chips_scroll.custom_minimum_size = Vector2(0, 56)
	chips_scroll.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	box.add_child(chips_scroll)

	var chips_row := HBoxContainer.new()
	chips_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	chips_row.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	chips_row.add_theme_constant_override("separation", 10)
	chips_scroll.add_child(chips_row)
	selected_chips_box = chips_row

	pot_view = PotView.new()
	pot_view.custom_minimum_size = Vector2(0, 340)
	pot_view.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	pot_view.size_flags_vertical = Control.SIZE_EXPAND_FILL
	pot_view.icon_provider = Callable(self, "_get_item_icon")
	var pot_layer := Control.new()
	pot_layer.custom_minimum_size = pot_view.custom_minimum_size
	pot_layer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	pot_layer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_child(pot_layer)

	pot_view.set_anchors_preset(Control.PRESET_FULL_RECT)
	pot_layer.add_child(pot_view)

	var steam_particles := SteamParticles.new()
	steam_particles.set_anchors_preset(Control.PRESET_FULL_RECT)
	pot_layer.add_child(steam_particles)

	status_label = _make_label("", 16, COLOR_TEXT_MUTED, HORIZONTAL_ALIGNMENT_CENTER)
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(status_label)

	economy_label = _make_label("成本：%d  当前资金：%d" % [current_service_cost, current_funds], 16, Color(1.0, 0.74, 0.58), HORIZONTAL_ALIGNMENT_CENTER)
	economy_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(economy_label)

	var tags := _make_label("想要：" + "、".join(current_order["desired_tags"]), 14, Color(0.72, 0.83, 0.96))
	tags.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(tags)
	return panel

func _build_library_panel_right() -> Control:
	var panel := _make_panel(Color(0.14, 0.145, 0.23), Color(0.34, 0.38, 0.54), 12)
	panel.custom_minimum_size = Vector2(360, 0)
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 10)
	panel.add_child(box)

	box.add_child(_make_label("食材 & 调料", 18, COLOR_SECONDARY))

	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	box.add_child(scroll)

	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 10)
	scroll.add_child(content)

	content.add_child(_make_label("主菜品", 16, Color(0.92, 0.95, 1.0)))
	var ing_list := VBoxContainer.new()
	ing_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ing_list.add_theme_constant_override("separation", 8)
	content.add_child(ing_list)

	var ingredients := presented_ingredients if not presented_ingredients.is_empty() else INGREDIENTS
	for item in ingredients:
		var b := _make_library_item_button(item, "ingredient")
		ingredient_buttons[str(item["id"])] = b
		ing_list.add_child(b)

	content.add_child(_make_label("调料", 16, Color(0.92, 0.95, 1.0)))
	var sea_list := VBoxContainer.new()
	sea_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sea_list.add_theme_constant_override("separation", 8)
	content.add_child(sea_list)
	var seasonings := presented_seasonings if not presented_seasonings.is_empty() else SEASONINGS
	for item in seasonings:
		var b := _make_library_item_button(item, "seasoning")
		seasoning_buttons[str(item["id"])] = b
		sea_list.add_child(b)

	return panel

func _build_bottom_bar() -> Control:
	var panel := _make_panel()
	panel.custom_minimum_size = Vector2(0, 110)
	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 12)
	panel.add_child(row)

	var method_row := HBoxContainer.new()
	method_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	method_row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	method_row.add_theme_constant_override("separation", 10)
	row.add_child(method_row)

	var group := ButtonGroup.new()
	for method in COOKING_METHODS:
		var b := _make_method_button(method, group)
		method_buttons[str(method["id"])] = b
		method_row.add_child(b)

	cook_button = _make_button("🍳 出锅", 26)
	cook_button.custom_minimum_size = Vector2(220, 80)
	cook_button.pressed.connect(_submit_dish.bind(false))
	row.add_child(cook_button)

	return panel

func _make_library_item_button(item: Dictionary, kind: String) -> Button:
	var button := _make_button("", 18)
	button.toggle_mode = true
	button.custom_minimum_size = Vector2(0, 56)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 10)
	button.add_child(row)

	var icon := TextureRect.new()
	icon.texture = _get_item_icon(kind, str(item["id"]), 36)
	icon.custom_minimum_size = Vector2(36, 36)
	icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	row.add_child(icon)

	var name_label := _make_label(str(item["name"]), 18, COLOR_TEXT)
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(name_label)

	if kind == "ingredient" or kind == "seasoning":
		var price := _price_for_item(item, kind)
		var price_label := _make_label("￥%d" % price, 16, Color(1.0, 0.82, 0.38), HORIZONTAL_ALIGNMENT_RIGHT)
		price_label.custom_minimum_size = Vector2(66, 0)
		row.add_child(price_label)
		var tags_text := "、".join(item.get("tags", []))
		button.tooltip_text = "%s\n￥%d\n%s" % [str(item.get("description", "")), price, tags_text]
	else:
		button.tooltip_text = str(item.get("description", ""))

	if kind == "ingredient":
		button.toggled.connect(_on_toggle_ingredient.bind(str(item["id"])))
	else:
		button.toggled.connect(_on_toggle_seasoning.bind(str(item["id"])))
	button.mouse_entered.connect(func():
		if not button.has_meta("hover_base_y"):
			button.set_meta("hover_base_y", button.position.y)
		var base_y: float = float(button.get_meta("hover_base_y"))
		var t := button.create_tween()
		t.tween_property(button, "position:y", base_y - 2.0, 0.1)
	)
	button.mouse_exited.connect(func():
		if not button.has_meta("hover_base_y"):
			button.set_meta("hover_base_y", button.position.y)
		var base_y: float = float(button.get_meta("hover_base_y"))
		var t := button.create_tween()
		t.tween_property(button, "position:y", base_y, 0.1)
	)
	return button

func _price_for_item(item: Dictionary, kind: String) -> int:
	var id := str(item.get("id", ""))
	var tags: Array = item.get("tags", [])
	var h: int = id.hash()
	if h < 0:
		h = -h
	var tag_bonus := clampi(int(floor(float(tags.size()) / 2.0)), 0, 4)
	if kind == "seasoning":
		return 2 + int(h % 6) + tag_bonus
	return 8 + int(h % 10) + tag_bonus

func _make_method_button(method: Dictionary, group: ButtonGroup) -> Button:
	var button := _make_button("", 20)
	button.toggle_mode = true
	button.button_group = group
	button.custom_minimum_size = Vector2(0, 80)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 10)
	button.add_child(row)

	var icon := TextureRect.new()
	icon.texture = _get_item_icon("method", str(method["id"]), 44)
	icon.custom_minimum_size = Vector2(44, 44)
	icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	row.add_child(icon)
	row.add_child(_make_label(str(method["name"]), 22, COLOR_TEXT))

	button.toggled.connect(_on_toggle_method.bind(str(method["id"])))
	button.mouse_entered.connect(func():
		if not button.has_meta("hover_base_y"):
			button.set_meta("hover_base_y", button.position.y)
		var base_y: float = float(button.get_meta("hover_base_y"))
		var t := button.create_tween()
		t.tween_property(button, "position:y", base_y - 2.0, 0.1)
	)
	button.mouse_exited.connect(func():
		if not button.has_meta("hover_base_y"):
			button.set_meta("hover_base_y", button.position.y)
		var base_y: float = float(button.get_meta("hover_base_y"))
		var t := button.create_tween()
		t.tween_property(button, "position:y", base_y, 0.1)
	)
	return button

func _refresh_playing_ui() -> void:
	if not is_instance_valid(playing_root):
		return
	current_service_cost = _calculate_selection_cost()

	if is_instance_valid(order_label):
		order_label.text = "第 %d/%d 单%s" % [order_index + 1, TOTAL_ORDERS, " · BOSS" if current_order.get("boss", false) else ""]
	if is_instance_valid(funds_label):
		funds_label.text = "资金 %d" % current_funds
	if is_instance_valid(title_label):
		title_label.text = "%s Lv.%d" % [player_title, player_level]
	if is_instance_valid(exp_label):
		exp_label.text = _exp_progress_text()
	if is_instance_valid(exp_progress_bar):
		exp_progress_bar.value = _exp_progress_value()

	if is_instance_valid(customer_avatar_rect):
		customer_avatar_rect.texture = _get_customer_portrait_index(current_customer_variant_index)
	if is_instance_valid(customer_body_rect):
		customer_body_rect.texture = _get_customer_body_index(current_customer_variant_index)
	if is_instance_valid(customer_request_label):
		customer_request_label.text = "“%s”" % str(current_order.get("request", ""))
	if is_instance_valid(customer_signature_label):
		var name_text := str(current_order.get("customer_name", "")).strip_edges()
		var role_text := str(current_order.get("role", "")).strip_edges()
		var boss := bool(current_order.get("boss", false))
		customer_signature_label.add_theme_font_size_override("font_size", 22)
		if boss:
			customer_signature_label.add_theme_color_override("font_color", Color(1.0, 0.3, 0.3, 1.0))
			customer_signature_label.text = "BOSS · %s\n%s" % [name_text, role_text]
		else:
			customer_signature_label.add_theme_color_override("font_color", Color(1.0, 0.92, 0.3, 1.0))
			customer_signature_label.text = "%s\n%s" % [name_text, role_text]
	var wants_label := playing_root.find_child("WantsLabel", true, false)
	if wants_label is Label:
		(wants_label as Label).text = "想要：" + "、".join(current_order.get("desired_tags", []))

	for id in ingredient_buttons.keys():
		var b = ingredient_buttons[id]
		if b is Button:
			var pressed: bool = selected_ingredient_ids.has(str(id))
			(b as Button).set_pressed_no_signal(pressed)
			if pressed:
				_apply_button_selected(b as Button)
			else:
				_apply_button_default(b as Button)

	for id in seasoning_buttons.keys():
		var b = seasoning_buttons[id]
		if b is Button:
			var pressed: bool = selected_seasoning_ids.has(str(id))
			(b as Button).set_pressed_no_signal(pressed)
			if pressed:
				_apply_button_selected(b as Button)
			else:
				_apply_button_default(b as Button)

	for id in method_buttons.keys():
		var b = method_buttons[id]
		if b is Button:
			var pressed: bool = selected_method_id == str(id)
			(b as Button).set_pressed_no_signal(pressed)
			if pressed:
				_apply_button_selected(b as Button)
			else:
				_apply_button_default(b as Button)

	_rebuild_selected_chips()

	if is_instance_valid(pot_view):
		pot_view.set_state(selected_ingredient_ids, selected_seasoning_ids, selected_method_id)

	var status_text := message_text if message_text != "" else _get_validity_text()
	var status_color := COLOR_TEXT_MUTED if _is_selection_valid() else COLOR_PRIMARY
	if is_instance_valid(status_label):
		status_label.text = status_text
		status_label.add_theme_color_override("font_color", status_color)
	if is_instance_valid(economy_label):
		economy_label.text = "成本：%d  当前资金：%d" % [current_service_cost, current_funds]

	if is_instance_valid(cook_button):
		_apply_button_accent(cook_button, COLOR_SECONDARY if _is_selection_valid() else COLOR_PRIMARY)

	_update_timer_label()
	if _is_selection_valid() and not _cook_breathing:
		_start_cook_breath()
	elif not _is_selection_valid() and _cook_breathing:
		_stop_cook_breath()
	if is_instance_valid(customer_avatar_rect):
		_start_avatar_idle()

func _rebuild_selected_chips() -> void:
	if not is_instance_valid(selected_chips_box):
		return
	for child in selected_chips_box.get_children():
		selected_chips_box.remove_child(child)
		child.queue_free()

	_add_selected_chips(selected_chips_box, selected_ingredient_ids, INGREDIENTS, "ingredient", _on_remove_ingredient)
	_add_selected_chips(selected_chips_box, selected_seasoning_ids, SEASONINGS, "seasoning", _on_remove_seasoning)
	if selected_method_id != "":
		var method := _find_by_id(selected_method_id, COOKING_METHODS)
		if not method.is_empty():
			selected_chips_box.add_child(_make_chip(method, "method"))

func _make_chip(item: Dictionary, kind: String) -> Control:
	var chip := _make_panel()
	chip.custom_minimum_size = Vector2(220, 44)
	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 6)
	chip.add_child(row)
	var icon := TextureRect.new()
	icon.texture = _get_item_icon(kind, item["id"], 28)
	icon.custom_minimum_size = Vector2(28, 28)
	icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	row.add_child(icon)
	var name_text := str(item["name"])
	if kind == "ingredient" or kind == "seasoning":
		name_text = "%s ￥%d" % [name_text, _price_for_item(item, kind)]
	var name_label := _make_label(name_text, 16, COLOR_TEXT)
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_label.custom_minimum_size = Vector2(150, 0)
	name_label.clip_text = true
	name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	row.add_child(name_label)
	return chip

func _add_selected_chips(container: Container, ids: Array, source: Array, kind: String, callback: Callable) -> void:
	for id in ids:
		var item := _find_by_id(id, source)
		if item.is_empty():
			continue
		var button := _make_button("", 16)
		button.custom_minimum_size = Vector2(220, 44)
		button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		var row := HBoxContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_theme_constant_override("separation", 6)
		button.add_child(row)
		var icon := TextureRect.new()
		icon.texture = _get_item_icon(kind, item["id"], 28)
		icon.custom_minimum_size = Vector2(28, 28)
		icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		row.add_child(icon)
		var name_text := str(item["name"])
		if kind == "ingredient" or kind == "seasoning":
			name_text = "%s ￥%d" % [name_text, _price_for_item(item, kind)]
		var name_label := _make_label(name_text, 16, COLOR_TEXT)
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_label.custom_minimum_size = Vector2(150, 0)
		name_label.clip_text = true
		name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		row.add_child(name_label)
		_apply_button_default(button)
		button.pressed.connect(callback.bind(id))
		container.add_child(button)

func _on_toggle_ingredient(pressed: bool, item_id: String) -> void:
	if pressed:
		if selected_ingredient_ids.has(item_id):
			return
		if selected_ingredient_ids.size() >= INGREDIENT_MAX:
			message_text = "最多选 %d 个主菜品哦。" % INGREDIENT_MAX
			if ingredient_buttons.has(item_id):
				var b = ingredient_buttons[item_id]
				if b is Button:
					(b as Button).set_pressed_no_signal(false)
			_refresh_playing_ui()
			return
		selected_ingredient_ids.append(item_id)
		if ingredient_buttons.has(item_id):
			var btn = ingredient_buttons[item_id]
			if btn is Control:
				_punch_scale(btn as Control, Vector2(0.92, 0.92), 0.16)
		_play_sfx("select")
		message_text = ""
	else:
		selected_ingredient_ids.erase(item_id)
		message_text = ""
	_refresh_playing_ui()

func _on_toggle_seasoning(pressed: bool, item_id: String) -> void:
	if pressed:
		if selected_seasoning_ids.has(item_id):
			return
		if selected_seasoning_ids.size() >= SEASONING_MAX:
			message_text = "最多选 %d 个调料哦。" % SEASONING_MAX
			if seasoning_buttons.has(item_id):
				var b = seasoning_buttons[item_id]
				if b is Button:
					(b as Button).set_pressed_no_signal(false)
			_refresh_playing_ui()
			return
		selected_seasoning_ids.append(item_id)
		if seasoning_buttons.has(item_id):
			var btn = seasoning_buttons[item_id]
			if btn is Control:
				_punch_scale(btn as Control, Vector2(0.92, 0.92), 0.16)
		_play_sfx("select")
		message_text = ""
	else:
		selected_seasoning_ids.erase(item_id)
		message_text = ""
	_refresh_playing_ui()

func _on_toggle_method(pressed: bool, method_id: String) -> void:
	if pressed:
		selected_method_id = method_id
	else:
		if selected_method_id == method_id:
			selected_method_id = ""
	message_text = ""
	_refresh_playing_ui()

func _show_evaluating_screen() -> void:
	screen_state = "evaluating"
	_clear_screen()
	var page := _make_page()
	var center := CenterContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	page.add_child(center)

	var panel := _make_panel(Color(0.14, 0.145, 0.23), Color(0.34, 0.38, 0.54), 14)
	panel.custom_minimum_size = Vector2(760, 360)
	center.add_child(panel)
	var box := VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 18)
	panel.add_child(box)
	var title_row := HBoxContainer.new()
	title_row.alignment = BoxContainer.ALIGNMENT_CENTER
	title_row.add_theme_constant_override("separation", 10)
	box.add_child(title_row)
	title_row.add_child(_make_label("AI 品尝中", 38, COLOR_SECONDARY, HORIZONTAL_ALIGNMENT_CENTER))
	var dots := _make_label(".", 38, COLOR_SECONDARY, HORIZONTAL_ALIGNMENT_CENTER)
	title_row.add_child(dots)
	_start_dots_animation(dots)
	box.add_child(_make_label("小炒 AI-7 正在尝试理解你的语义料理。", 20, Color(0.92, 0.95, 1.0), HORIZONTAL_ALIGNMENT_CENTER))
	box.add_child(_make_label("若 AI 接口不可用，将自动启用本地评分。", 17, COLOR_TEXT_MUTED, HORIZONTAL_ALIGNMENT_CENTER))

func _show_result_screen(result: Dictionary) -> void:
	screen_state = "result"
	_clear_screen()
	var page := _make_page()
	var root := VBoxContainer.new()
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_theme_constant_override("separation", 12)
	page.add_child(root)

	var header := _make_label("第 %d 单评价" % [order_index + 1], 26, Color(1.0, 0.82, 0.38), HORIZONTAL_ALIGNMENT_CENTER)
	header.modulate = Color(1, 1, 1, 0)
	root.add_child(header)

	var body := HBoxContainer.new()
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 14)
	root.add_child(body)

	var left := _make_panel(Color(0.14, 0.145, 0.23), Color(0.34, 0.38, 0.54), 14)
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_child(left)
	var left_box := VBoxContainer.new()
	left_box.add_theme_constant_override("separation", 12)
	left.add_child(left_box)

	var dish_label := _make_label(str(result["dish_name"]), 36, Color(1.0, 0.86, 0.46), HORIZONTAL_ALIGNMENT_CENTER)
	dish_label.modulate = Color(1, 1, 1, 0)
	left_box.add_child(dish_label)

	var grade_total := _make_label("评级 %s   总分 %d" % [str(result["grade"]), int(result["total_score"])], 28, Color(0.83, 1.0, 0.78), HORIZONTAL_ALIGNMENT_CENTER)
	grade_total.modulate = Color(1, 1, 1, 0)
	left_box.add_child(grade_total)
	var economy_1 := _make_label("成本 -%d   净收益 %+d" % [int(result["service_cost"]), int(result["net_profit"])], 21, Color(0.96, 0.88, 0.64), HORIZONTAL_ALIGNMENT_CENTER)
	economy_1.modulate = Color(1, 1, 1, 0)
	left_box.add_child(economy_1)
	var economy_2 := _make_label("资金 %d   经验 +%d" % [int(current_funds), int(result["exp_gain"])], 21, Color(0.96, 0.88, 0.64), HORIZONTAL_ALIGNMENT_CENTER)
	economy_2.modulate = Color(1, 1, 1, 0)
	left_box.add_child(economy_2)

	var coins_gain := _make_label("报酬 +0", 28, Color(0.94, 0.96, 1.0), HORIZONTAL_ALIGNMENT_CENTER)
	coins_gain.modulate = Color(1, 1, 1, 0)
	left_box.add_child(coins_gain)
	coins_label = coins_gain

	var source_notice := _make_label(str(result["source_notice"]), 17, Color(0.7, 0.78, 0.88), HORIZONTAL_ALIGNMENT_CENTER)
	source_notice.modulate = Color(1, 1, 1, 0)
	left_box.add_child(source_notice)

	var scores: Dictionary = result["scores"]
	var score_rows: Array[Control] = []
	var score_bars: Array[ProgressBar] = []
	for entry in [
		{"name": "贴题度", "value": int(scores["relevance"])},
		{"name": "美味度", "value": int(scores["taste"])},
		{"name": "情绪命中", "value": int(scores["emotion"])},
		{"name": "风险值", "value": int(scores["risk"])}
	]:
		var row: Control = _make_score_bar(str(entry["name"]), int(entry["value"]))
		row.modulate = Color(1, 1, 1, 0)
		left_box.add_child(row)
		score_rows.append(row)
		var bar_node := row.find_child("ScoreBar", true, false)
		if bar_node is ProgressBar:
			score_bars.append(bar_node as ProgressBar)

	var right := _make_panel(Color(0.18, 0.17, 0.30), Color(0.44, 0.46, 0.64), 14)
	right.custom_minimum_size = Vector2(420, 0)
	right.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_child(right)
	var right_box := VBoxContainer.new()
	right_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right_box.add_theme_constant_override("separation", 16)
	right.add_child(right_box)
	var stamp := _make_grade_stamp(str(result["grade"]))
	stamp.modulate = Color(1, 1, 1, 0)
	stamp.scale = Vector2(0.3, 0.3)
	right_box.add_child(stamp)
	var comment := _make_label("AI 点评：\n%s" % str(result["comment"]), 20, Color(0.93, 0.96, 1.0))
	comment.modulate = Color(1, 1, 1, 0)
	comment.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	right_box.add_child(comment)
	var reaction := _make_label("顾客反应：\n%s" % str(result["customer_reaction"]), 20, Color(0.82, 0.9, 0.98))
	reaction.modulate = Color(1, 1, 1, 0)
	reaction.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	right_box.add_child(reaction)

	var flash := ColorRect.new()
	flash.color = Color(1.0, 0.88, 0.3, 0.0)
	flash.set_anchors_preset(Control.PRESET_FULL_RECT)
	flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	page.add_child(flash)

	var next_button_text := "下一单"
	if order_index >= TOTAL_ORDERS - 1:
		next_button_text = "查看日结"
	if current_funds < _peek_next_service_cost():
		next_button_text = "查看破产结算"
	var next_button := _make_button(next_button_text, 24)
	next_button.custom_minimum_size = Vector2(240, 56)
	next_button.pressed.connect(_advance_after_result)
	next_button.modulate = Color(1, 1, 1, 0)
	next_button.disabled = true
	root.add_child(next_button)

	var grade_text: String = str(result.get("grade", "F"))
	var target_coins: int = int(result.get("coins", 0))
	var tween := create_tween()
	tween.tween_property(header, "modulate:a", 1.0, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(dish_label, "modulate:a", 1.0, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(grade_total, "modulate:a", 1.0, 0.2)
	tween.tween_property(economy_1, "modulate:a", 1.0, 0.18)
	tween.tween_property(economy_2, "modulate:a", 1.0, 0.18)
	tween.tween_property(source_notice, "modulate:a", 1.0, 0.18)
	for idx in range(score_rows.size()):
		var row: Control = score_rows[idx]
		tween.tween_property(row, "modulate:a", 1.0, 0.12)
		if idx < score_bars.size():
			var bar: ProgressBar = score_bars[idx]
			var target: float = float(int(bar.get_meta("target_value", 0)))
			tween.tween_callback(Callable(self, "_play_sfx").bind("score"))
			tween.tween_property(bar, "value", target, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_interval(0.18)

	tween.tween_callback(Callable(self, "_play_sfx").bind("stamp"))
	tween.tween_property(stamp, "modulate:a", 1.0, 0.02)
	tween.parallel().tween_property(stamp, "scale", Vector2(1.3, 1.3), 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(stamp, "scale", Vector2.ONE, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	if grade_text == "S":
		tween.tween_property(flash, "color:a", 0.38, 0.06).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(flash, "color:a", 0.0, 0.22).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.tween_property(comment, "modulate:a", 1.0, 0.32)
	tween.tween_property(reaction, "modulate:a", 1.0, 0.32)

	tween.tween_property(coins_gain, "modulate:a", 1.0, 0.12)
	tween.tween_callback(Callable(self, "_play_sfx").bind("coin"))
	tween.tween_method(Callable(self, "_set_number_label").bind(coins_gain, "报酬 +%d"), 0.0, float(target_coins), 0.55).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(Callable(self, "_coin_bounce"))

	tween.tween_property(next_button, "modulate:a", 1.0, 0.25)
	tween.tween_callback(Callable(next_button, "set_disabled").bind(false))

func _show_summary_screen() -> void:
	screen_state = "summary"
	_clear_screen()
	var page := _make_page()
	var center := CenterContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	page.add_child(center)

	var panel := _make_panel(Color(0.14, 0.145, 0.23), Color(0.34, 0.38, 0.54), 14)
	panel.custom_minimum_size = Vector2(820, 560)
	center.add_child(panel)
	panel.modulate = Color(1, 1, 1, 0)
	panel.scale = Vector2(0.9, 0.9)
	var tween := create_tween()
	tween.tween_property(panel, "modulate:a", 1.0, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(panel, "scale", Vector2.ONE, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	var box := VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 14)
	panel.add_child(box)

	var average := 0
	if round_results.size() > 0:
		average = int(round(float(total_score) / float(round_results.size())))
	var best := _get_best_result()
	box.add_child(_make_label("第 %d 天日结" % day_index, 42, Color(1.0, 0.82, 0.38), HORIZONTAL_ALIGNMENT_CENTER))
	box.add_child(_typewriter_label(_get_final_title(average), 30, Color(0.82, 1.0, 0.82), HORIZONTAL_ALIGNMENT_CENTER))
	box.add_child(_make_label("总分 %d   平均分 %d   资金 %d   经验 %d" % [total_score, average, current_funds, total_exp], 24, Color(0.92, 0.95, 1.0), HORIZONTAL_ALIGNMENT_CENTER))
	box.add_child(_make_label("头衔：%s Lv.%d   累计报酬 %d" % [player_title, player_level, total_coins], 22, Color(0.82, 1.0, 0.82), HORIZONTAL_ALIGNMENT_CENTER))
	box.add_child(_make_label("最高单：%s / %d 分" % [best.get("dish_name", "暂无"), best.get("total_score", 0)], 22, Color(0.93, 0.88, 0.72), HORIZONTAL_ALIGNMENT_CENTER))

	var list := VBoxContainer.new()
	list.add_theme_constant_override("separation", 6)
	box.add_child(list)
	for index in range(round_results.size()):
		var result: Dictionary = round_results[index]
		var line := "%d. %s  %s  %d 分  净收益 %+d" % [index + 1, result["dish_name"], result["grade"], result["total_score"], result["net_profit"]]
		list.add_child(_make_label(line, 18, Color(0.78, 0.84, 0.92), HORIZONTAL_ALIGNMENT_CENTER))

	var continue_button := _make_button("继续营业", 24)
	continue_button.custom_minimum_size = Vector2(240, 56)
	continue_button.pressed.connect(_start_next_day)
	box.add_child(continue_button)

func _show_level_up_screen() -> void:
	screen_state = "level_up"
	_clear_screen()
	var page := _make_page()
	var center := CenterContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	page.add_child(center)

	var panel := _make_panel(Color(0.045, 0.058, 0.072), Color(0.32, 0.62, 0.58), 14)
	panel.custom_minimum_size = Vector2(860, 520)
	center.add_child(panel)
	var box := VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 16)
	panel.add_child(box)

	box.add_child(_make_label("头衔晋升", 42, Color(1.0, 0.82, 0.38), HORIZONTAL_ALIGNMENT_CENTER))
	box.add_child(_make_label("你升到了 Lv.%d：%s" % [player_level, player_title], 28, Color(0.82, 1.0, 0.82), HORIZONTAL_ALIGNMENT_CENTER))
	box.add_child(_make_label("选择一个增益 Buff，决定接下来怎么继续营业。", 20, Color(0.82, 0.9, 0.96), HORIZONTAL_ALIGNMENT_CENTER))

	var choices := HBoxContainer.new()
	choices.alignment = BoxContainer.ALIGNMENT_CENTER
	choices.add_theme_constant_override("separation", 14)
	box.add_child(choices)
	for buff in pending_buff_choices:
		var button := _make_action_button("%s\n%s" % [buff["name"], buff["description"]], 18, Color(0.12, 0.19, 0.22), Color(0.42, 0.7, 0.72))
		button.custom_minimum_size = Vector2(250, 150)
		button.pressed.connect(_choose_buff.bind(buff["id"]))
		choices.add_child(button)

func _show_bankruptcy_screen() -> void:
	screen_state = "bankrupt"
	_clear_screen()
	var page := _make_page()
	var center := CenterContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	page.add_child(center)

	var panel := _make_panel(Color(0.055, 0.045, 0.048), Color(0.68, 0.22, 0.28), 14)
	panel.custom_minimum_size = Vector2(850, 560)
	center.add_child(panel)
	var box := VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 14)
	panel.add_child(box)

	var average := 0
	if round_results.size() > 0:
		average = int(round(float(total_score) / float(round_results.size())))
	var best := _get_best_result()
	box.add_child(_make_label("破产结算", 44, Color(1.0, 0.68, 0.58), HORIZONTAL_ALIGNMENT_CENTER))
	box.add_child(_make_label("资金不足以完成下一单（最低成本 %d），怪菜摊暂时打烊。" % _peek_next_service_cost(), 22, Color(0.96, 0.88, 0.82), HORIZONTAL_ALIGNMENT_CENTER))
	box.add_child(_make_label("接待 %d 单   撑到第 %d 天   最终资金 %d" % [completed_orders, day_index, current_funds], 23, Color(0.92, 0.95, 1.0), HORIZONTAL_ALIGNMENT_CENTER))
	box.add_child(_make_label("最高头衔：%s Lv.%d   平均分 %d" % [player_title, player_level, average], 22, Color(0.82, 1.0, 0.82), HORIZONTAL_ALIGNMENT_CENTER))
	box.add_child(_make_label("最佳菜品：%s / %d 分" % [best.get("dish_name", "暂无"), best.get("total_score", 0)], 20, Color(0.93, 0.88, 0.72), HORIZONTAL_ALIGNMENT_CENTER))
	box.add_child(_make_label(_get_final_title(average), 30, Color(1.0, 0.82, 0.38), HORIZONTAL_ALIGNMENT_CENTER))

	var restart := _make_button("重新开张", 24)
	restart.custom_minimum_size = Vector2(240, 56)
	restart.pressed.connect(_start_game)
	box.add_child(restart)

func _on_add_ingredient(item_id: String) -> void:
	if selected_ingredient_ids.has(item_id):
		message_text = "这份食材已经在锅里了。"
	elif selected_ingredient_ids.size() >= INGREDIENT_MAX:
		message_text = "食材已经够多了，再加就像需求文档一样失控。"
	else:
		selected_ingredient_ids.append(item_id)
		message_text = ""
	_refresh_playing_ui()

func _on_add_seasoning(item_id: String) -> void:
	if selected_seasoning_ids.has(item_id):
		message_text = "这份调料已经在锅里了。"
	elif selected_seasoning_ids.size() >= SEASONING_MAX:
		message_text = "调料已经到上限，再加小炒 AI-7 会皱眉。"
	else:
		selected_seasoning_ids.append(item_id)
		message_text = ""
	_refresh_playing_ui()

func _on_remove_ingredient(item_id: String) -> void:
	selected_ingredient_ids.erase(item_id)
	message_text = ""
	_refresh_playing_ui()

func _on_remove_seasoning(item_id: String) -> void:
	selected_seasoning_ids.erase(item_id)
	message_text = ""
	_refresh_playing_ui()

func _on_select_method(method_id: String) -> void:
	selected_method_id = method_id
	message_text = ""
	_refresh_playing_ui()

func _submit_auth_form() -> void:
	var email := auth_email_input.text.strip_edges()
	var password := auth_password_input.text.strip_edges()
	if email == "" or password == "":
		auth_notice = "请填写邮箱和密码。"
		_show_auth_screen(auth_mode)
		return
	if _supabase_base_url() == "" or _supabase_anon_key() == "":
		auth_notice = "缺少 Supabase 配置，请创建 supabase_config.local.json。"
		_show_auth_screen(auth_mode)
		return
	if auth_mode == "signup":
		_request_auth_signup(email, password)
	else:
		_request_auth_login(email, password)

func _request_auth_signup(email: String, password: String) -> void:
	auth_notice = "正在注册..."
	var payload := {
		"email": email,
		"password": password
	}
	_send_supabase_request(
		"POST",
		"/auth/v1/signup",
		payload,
		_on_auth_response,
		false
	)

func _request_auth_login(email: String, password: String) -> void:
	auth_notice = "正在登录..."
	var payload := {
		"email": email,
		"password": password
	}
	_send_supabase_request(
		"POST",
		"/auth/v1/token?grant_type=password",
		payload,
		_on_auth_response,
		false
	)

func _on_auth_response(ok: bool, response_code: int, data: Variant) -> void:
	if not ok or typeof(data) != TYPE_DICTIONARY:
		auth_notice = "账号请求失败（%d）。" % response_code
		_show_auth_screen(auth_mode)
		return
	var result: Dictionary = data
	if result.has("access_token"):
		_set_auth_session(result)
		auth_notice = ""
		profile_notice = "登录成功。"
		_request_profile(true)
		return
	if auth_mode == "signup":
		auth_notice = "注册成功，请登录。"
		_show_auth_screen("login")
		return
	auth_notice = "登录失败，请检查邮箱、密码或邮箱验证状态。"
	_show_auth_screen(auth_mode)

func _restore_auth_session() -> void:
	if not FileAccess.file_exists(USER_SESSION_PATH):
		return
	var file := FileAccess.open(USER_SESSION_PATH, FileAccess.READ)
	if file == null:
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	auth_session = parsed
	current_user = auth_session.get("user", {})
	if _is_logged_in() and auth_session.has("refresh_token"):
		_refresh_auth_session()

func _refresh_auth_session() -> void:
	if _supabase_base_url() == "" or _supabase_anon_key() == "":
		return
	var payload := {
		"refresh_token": str(auth_session.get("refresh_token", ""))
	}
	_send_supabase_request(
		"POST",
		"/auth/v1/token?grant_type=refresh_token",
		payload,
		_on_refresh_response,
		false
	)

func _on_refresh_response(ok: bool, _response_code: int, data: Variant) -> void:
	if ok and typeof(data) == TYPE_DICTIONARY and data.has("access_token"):
		_set_auth_session(data)

func _set_auth_session(session: Dictionary) -> void:
	auth_session = session.duplicate(true)
	current_user = auth_session.get("user", {})
	_save_json(USER_SESSION_PATH, auth_session)

func _logout() -> void:
	if _is_logged_in():
		_send_supabase_request(
			"POST",
			"/auth/v1/logout",
			{},
			_on_logout_response,
			true
		)
	_clear_auth_state()
	_show_start_screen()

func _on_logout_response(_ok: bool, _response_code: int, _data: Variant) -> void:
	pass

func _clear_auth_state() -> void:
	auth_session = {}
	current_user = {}
	user_profile = {}
	current_avatar_texture = null
	profile_notice = ""
	if FileAccess.file_exists(USER_SESSION_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(USER_SESSION_PATH))

func _request_profile(open_after_load: bool) -> void:
	if not _is_logged_in():
		return
	var user_id := _current_user_id()
	if user_id == "":
		return
	var path := "/rest/v1/%s?id=eq.%s&select=id,username,avatar_path,updated_at" % [SUPABASE_PROFILE_TABLE, user_id.uri_encode()]
	_send_supabase_request(
		"GET",
		path,
		{},
		func(ok: bool, response_code: int, data: Variant) -> void:
			_on_profile_loaded(ok, response_code, data, open_after_load),
		true
	)

func _on_profile_loaded(ok: bool, _response_code: int, data: Variant, open_after_load: bool) -> void:
	if ok and typeof(data) == TYPE_ARRAY and data.size() > 0 and typeof(data[0]) == TYPE_DICTIONARY:
		user_profile = data[0]
	else:
		user_profile = {
			"id": _current_user_id(),
			"username": "新厨师",
			"avatar_path": ""
		}
		_upsert_profile(user_profile, Callable())
	_load_avatar_texture()
	if open_after_load:
		_show_profile_screen()

func _save_profile_name() -> void:
	if profile_username_input == null:
		return
	var username := profile_username_input.text.strip_edges()
	if username == "":
		profile_notice = "用户名不能为空。"
		_show_profile_screen()
		return
	user_profile["id"] = _current_user_id()
	user_profile["username"] = username
	profile_notice = "正在保存用户名..."
	_upsert_profile(user_profile, _on_profile_saved)

func _on_profile_saved(ok: bool, response_code: int, _data: Variant) -> void:
	profile_notice = "资料已保存。" if ok else "资料保存失败（%d）。" % response_code
	_show_profile_screen()

func _upsert_profile(profile: Dictionary, callback: Callable) -> void:
	var payload := {
		"id": profile.get("id", _current_user_id()),
		"username": profile.get("username", "新厨师"),
		"avatar_path": profile.get("avatar_path", "")
	}
	_send_supabase_request(
		"POST",
		"/rest/v1/%s" % SUPABASE_PROFILE_TABLE,
		payload,
		callback,
		true,
		["Prefer: resolution=merge-duplicates,return=representation"]
	)

func _open_avatar_file_dialog() -> void:
	var dialog := FileDialog.new()
	dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dialog.access = FileDialog.ACCESS_FILESYSTEM
	dialog.title = "选择头像图片"
	dialog.filters = PackedStringArray(["*.png ; PNG 图片", "*.jpg, *.jpeg ; JPEG 图片", "*.webp ; WebP 图片"])
	dialog.file_selected.connect(_upload_avatar_file)
	add_child(dialog)
	dialog.popup_centered(Vector2i(760, 520))

func _upload_avatar_file(path: String) -> void:
	if not _is_logged_in():
		profile_notice = "请先登录。"
		_show_profile_screen()
		return
	var bytes := FileAccess.get_file_as_bytes(path)
	if bytes.is_empty():
		profile_notice = "头像文件读取失败。"
		_show_profile_screen()
		return
	var ext := path.get_extension().to_lower()
	if ext == "jpeg":
		ext = "jpg"
	if not ["png", "jpg", "webp"].has(ext):
		profile_notice = "只支持 png、jpg、webp。"
		_show_profile_screen()
		return
	var object_path := "%s/avatar.%s" % [_current_user_id(), ext]
	var content_type := "image/png"
	if ext == "jpg":
		content_type = "image/jpeg"
	elif ext == "webp":
		content_type = "image/webp"
	profile_notice = "正在上传头像..."
	_send_supabase_binary_request(
		"POST",
		"/storage/v1/object/%s/%s" % [SUPABASE_AVATAR_BUCKET, _encode_storage_path(object_path)],
		bytes,
		content_type,
		func(ok: bool, response_code: int, data: Variant) -> void:
			_on_avatar_uploaded(ok, response_code, data, object_path)
	)

func _on_avatar_uploaded(ok: bool, response_code: int, _data: Variant, object_path: String) -> void:
	if not ok:
		profile_notice = "头像上传失败（%d）。" % response_code
		_show_profile_screen()
		return
	user_profile["id"] = _current_user_id()
	user_profile["username"] = user_profile.get("username", _user_display_name())
	user_profile["avatar_path"] = object_path
	_upsert_profile(user_profile, func(saved: bool, save_code: int, _save_data: Variant) -> void:
		profile_notice = "头像已更新。" if saved else "头像已上传，但资料保存失败（%d）。" % save_code
		current_avatar_texture = null
		_load_avatar_texture()
		_show_profile_screen()
	)

func _fill_ai_config_form() -> void:
	if ai_provider_option == null:
		return
	var provider := str(ai_config.get("provider", "deepseek"))
	if not AI_PROVIDER_PRESETS.has(provider):
		provider = "deepseek"
	var preset: Dictionary = AI_PROVIDER_PRESETS[provider]
	var selected := 0
	for index in range(ai_provider_option.get_item_count()):
		if str(ai_provider_option.get_item_metadata(index)) == provider:
			selected = index
			break
	ai_provider_option.select(selected)
	ai_endpoint_input.text = str(preset.get("endpoint", "")) if provider != "custom" else str(ai_config.get("endpoint", ""))
	ai_key_input.text = str(ai_config.get("api_key", ai_config.get("token", "")))
	ai_model_input.text = str(preset.get("model", "")) if provider != "custom" else str(ai_config.get("model", ""))

func _on_ai_provider_selected(index: int) -> void:
	var provider := str(ai_provider_option.get_item_metadata(index))
	if not AI_PROVIDER_PRESETS.has(provider):
		return
	var preset: Dictionary = AI_PROVIDER_PRESETS[provider]
	ai_endpoint_input.editable = provider == "custom"
	ai_endpoint_input.mouse_filter = Control.MOUSE_FILTER_STOP if provider == "custom" else Control.MOUSE_FILTER_IGNORE
	ai_endpoint_input.visible = provider == "custom"
	ai_model_input.editable = provider == "custom"
	ai_model_input.mouse_filter = Control.MOUSE_FILTER_STOP if provider == "custom" else Control.MOUSE_FILTER_IGNORE
	ai_model_input.visible = provider == "custom"
	ai_endpoint_input.text = str(preset.get("endpoint", ""))
	ai_model_input.text = str(preset.get("model", ""))

func _selected_ai_provider() -> String:
	if ai_provider_option == null:
		return "deepseek"
	return str(ai_provider_option.get_item_metadata(ai_provider_option.selected))

func _save_ai_config_from_form() -> void:
	if ai_provider_option == null:
		return
	var provider := _selected_ai_provider()
	var preset: Dictionary = AI_PROVIDER_PRESETS.get(provider, AI_PROVIDER_PRESETS["deepseek"])
	var endpoint := str(ai_endpoint_input.text).strip_edges()
	var model := str(ai_model_input.text).strip_edges()
	if provider != "custom":
		endpoint = str(preset.get("endpoint", ""))
		model = str(preset.get("model", ""))
	ai_config = {
		"provider": provider,
		"endpoint": endpoint,
		"api_key": ai_key_input.text.strip_edges(),
		"model": model
	}
	var has_any_value := str(ai_config.get("endpoint", "")) != "" or str(ai_config.get("api_key", "")) != "" or str(ai_config.get("model", "")) != ""
	var has_all_values := str(ai_config.get("endpoint", "")) != "" and str(ai_config.get("api_key", "")) != "" and str(ai_config.get("model", "")) != ""
	if has_any_value and not has_all_values:
		ai_config_notice = "请填写 API Key。" if provider != "custom" else "API 配置不完整；可补全三项，或全部清空后使用本地评分。"
		_show_start_screen()
		return
	_save_json(USER_AI_CONFIG_PATH, ai_config)
	ai_config_notice = "AI 配置已保存。" if has_all_values else "已清空 API 配置，游戏将使用本地评分。"
	_show_start_screen()

func _has_playable_ai_config() -> bool:
	var config := _load_user_ai_config()
	return str(config.get("endpoint", "")).strip_edges() != "" and str(config.get("api_key", "")).strip_edges() != "" and str(config.get("model", "")).strip_edges() != ""

func _submit_dish(from_timeout: bool) -> void:
	if screen_state != "playing":
		return
	if not from_timeout and is_instance_valid(cook_button):
		_punch_scale(cook_button, Vector2(0.85, 1.2), 0.22)
		_play_sfx("cook")
	if not _is_selection_valid():
		if from_timeout:
			_auto_complete_for_timeout()
		else:
			message_text = _get_validity_text()
			_refresh_playing_ui()
			return
	if not _is_selection_valid():
		message_text = "还没法出锅：请至少选 2 个食材、1 个调料和 1 种烹饪方式。"
		_refresh_playing_ui()
		return

	var cost := _calculate_selection_cost()
	current_service_cost = cost
	if not from_timeout and current_funds < cost:
		message_text = "资金不足：本次成本 %d，当前资金 %d。" % [cost, current_funds]
		_refresh_playing_ui()
		return

	pending_payload = _build_evaluation_payload()
	_show_evaluating_screen()
	_request_ai_evaluation(pending_payload)

func _request_ai_evaluation(payload: Dictionary) -> void:
	var active_ai_config := _load_ai_config()
	var endpoint := str(active_ai_config.get("endpoint", "")).strip_edges()
	if endpoint == "":
		_finish_evaluation(_make_local_evaluation(payload), "点单系统短路，启用本地评分。")
		return

	pending_http_request = HTTPRequest.new()
	pending_http_request.timeout = AI_TIMEOUT_SECONDS
	add_child(pending_http_request)
	pending_http_request.request_completed.connect(_on_ai_request_completed)

	var headers := ["Content-Type: application/json"]
	var token := str(active_ai_config.get("api_key", active_ai_config.get("token", ""))).strip_edges()
	if token != "":
		headers.append("Authorization: Bearer %s" % token)

	var body := payload
	if active_ai_config.get("mode", "legacy") == "chat":
		body = _build_chat_completion_body(active_ai_config, payload)
	var body_json := JSON.stringify(body)
	print("[AI_DEBUG] sending request, body_len=", body_json.length())
	var error := pending_http_request.request(endpoint, headers, HTTPClient.METHOD_POST, body_json)
	print("[AI_DEBUG] request() returned error=", error)
	if error != OK:
		print("[AI_DEBUG] request() FAILED")
		_finish_evaluation(_make_local_evaluation(payload), "点单系统短路，启用本地评分。")

func _load_ai_config() -> Dictionary:
	var config := {
		"endpoint": OS.get_environment(AI_ENDPOINT_ENV).strip_edges(),
		"token": OS.get_environment(AI_TOKEN_ENV).strip_edges(),
		"mode": "legacy"
	}
	var user_config := _load_user_ai_config()
	if FileAccess.file_exists(USER_AI_CONFIG_PATH) and str(user_config.get("endpoint", "")).strip_edges() != "":
		user_config["mode"] = "chat"
		return user_config
	if not FileAccess.file_exists(AI_CONFIG_PATH):
		return config
	var file := FileAccess.open(AI_CONFIG_PATH, FileAccess.READ)
	if file == null:
		return config
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return config
	if parsed.has("endpoint"):
		config["endpoint"] = str(parsed["endpoint"]).strip_edges()
	if parsed.has("token"):
		config["token"] = str(parsed["token"]).strip_edges()
	if parsed.has("api_key"):
		config["api_key"] = str(parsed["api_key"]).strip_edges()
	if parsed.has("model"):
		config["model"] = str(parsed["model"]).strip_edges()
	if parsed.has("mode"):
		config["mode"] = str(parsed["mode"]).strip_edges()
	return config

func _load_user_ai_config() -> Dictionary:
	var default_config := {
		"provider": "deepseek",
		"endpoint": "",
		"api_key": "",
		"model": ""
	}
	if not FileAccess.file_exists(USER_AI_CONFIG_PATH):
		return default_config
	var file := FileAccess.open(USER_AI_CONFIG_PATH, FileAccess.READ)
	if file == null:
		return default_config
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return default_config
	for key in ["provider", "endpoint", "api_key", "model"]:
		if parsed.has(key):
			default_config[key] = str(parsed[key]).strip_edges()
	return default_config

func _build_chat_completion_body(config: Dictionary, payload: Dictionary) -> Dictionary:
	return {
		"model": str(config.get("model", "")).strip_edges(),
		"messages": [
			{
				"role": "system",
				"content": str(payload["prompt"])
			},
			{
				"role": "user",
				"content": JSON.stringify({
					"customer": payload["customer"],
					"dish": payload["dish"],
					"system_score": payload["system_score"],
					"return_json_only": true
				})
			}
		],
		"temperature": 0.7
	}

func _extract_json_text(text: String) -> String:
	var clean := text.strip_edges()
	if clean.begins_with("```"):
		var first_newline := clean.find("\n")
		var last_fence := clean.rfind("```")
		if first_newline != -1 and last_fence > first_newline:
			clean = clean.substr(first_newline + 1, last_fence - first_newline - 1).strip_edges()
	var start := clean.find("{")
	var end := clean.rfind("}")
	if start != -1 and end > start:
		return clean.substr(start, end - start + 1)
	return clean
func _on_ai_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	print("[AI_DEBUG] result=", result, " code=", response_code, " body=", body.get_string_from_utf8().substr(0, 200))
	if is_instance_valid(pending_http_request):
		pending_http_request.queue_free()
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		print("[AI_DEBUG] HTTP_FAILED")
		_finish_evaluation(_make_local_evaluation(pending_payload), "点单系统短路，启用本地评分。")
		return

	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		_finish_evaluation(_make_local_evaluation(pending_payload), "点单系统短路，启用本地评分。")
		return

	if parsed.has("choices") and typeof(parsed["choices"]) == TYPE_ARRAY and parsed["choices"].size() > 0:
		var first_choice = parsed["choices"][0]
		if typeof(first_choice) == TYPE_DICTIONARY and first_choice.has("message"):
			var message = first_choice["message"]
			if typeof(message) == TYPE_DICTIONARY:
				var content := str(message.get("content", "")).strip_edges()
				var parsed_content = JSON.parse_string(_extract_json_text(content))
				if typeof(parsed_content) == TYPE_DICTIONARY:
					parsed = parsed_content

	var evaluation := _sanitize_ai_evaluation(parsed)
	if evaluation.is_empty():
		_finish_evaluation(_make_local_evaluation(pending_payload), "点单系统短路，启用本地评分。")
		return
	_finish_evaluation(evaluation, "小炒 AI-7 已完成评价。")

func _finish_evaluation(evaluation: Dictionary, source_notice: String) -> void:
	var total := _calculate_total_score(evaluation["scores"])
	var grade := _grade_for_score(total)
	evaluation["grade"] = grade
	evaluation["total_score"] = total
	evaluation["source_notice"] = source_notice

	if grade == "S" or grade == "A":
		combo_count += 1
	else:
		combo_count = 0

	var base_coins := _base_payout_for_grade(grade)
	var multiplier := 1.0
	if combo_count >= 4:
		multiplier = 1.3
	elif combo_count == 3:
		multiplier = 1.2
	elif combo_count == 2:
		multiplier = 1.1
	if active_buffs.has("streak_heat") and combo_count >= 2:
		multiplier += 0.05
	if active_buffs.has("signature_price") and grade == "S":
		multiplier += 0.3
	var payout_grade := grade
	if active_buffs.has("mistake_insurance") and not mistake_insurance_used and (grade == "D" or grade == "F"):
		payout_grade = "C"
		mistake_insurance_used = true
		base_coins = _base_payout_for_grade(payout_grade)
	var coins := int(round(float(base_coins) * multiplier))
	if active_buffs.has("tip_bonus") and (grade == "S" or grade == "A"):
		coins += 20
	var service_cost := current_service_cost
	var exp_gain := _exp_for_grade(grade)
	var net_profit := coins - service_cost
	evaluation["coins"] = coins
	evaluation["service_cost"] = service_cost
	evaluation["net_profit"] = net_profit
	evaluation["exp_gain"] = exp_gain
	evaluation["payout_grade"] = payout_grade

	total_score += total
	total_coins += coins
	current_funds += net_profit
	total_exp += exp_gain
	completed_orders += 1
	round_results.append(evaluation.duplicate(true))
	_show_result_screen(evaluation)

func _advance_after_result() -> void:
	var old_level := player_level
	_update_player_level()
	if player_level > old_level:
		pending_buff_choices = _roll_buff_choices()
		if not pending_buff_choices.is_empty():
			_show_level_up_screen()
			return
	if current_funds < _peek_next_service_cost():
		_show_bankruptcy_screen()
		return
	if order_index >= TOTAL_ORDERS - 1:
		_show_summary_screen()
		return
	order_index += 1
	_pick_next_order()
	_show_game_screen()

func _start_next_day() -> void:
	order_index = 0
	normal_order_pool = _get_orders(false)
	_pick_next_order()
	_show_approach_screen()

func _choose_buff(buff_id: String) -> void:
	if buff_id != "" and not active_buffs.has(buff_id):
		active_buffs.append(buff_id)
	pending_buff_choices.clear()
	if current_funds < _peek_next_service_cost():
		_show_bankruptcy_screen()
		return
	if order_index >= TOTAL_ORDERS - 1:
		_show_summary_screen()
		return
	order_index += 1
	_pick_next_order()
	_show_approach_screen()

func _build_evaluation_payload() -> Dictionary:
	var ingredient_names := _names_for_ids(selected_ingredient_ids, INGREDIENTS)
	var seasoning_names := _names_for_ids(selected_seasoning_ids, SEASONINGS)
	var method := _find_by_id(selected_method_id, COOKING_METHODS)
	var semantic_tags := _selected_semantic_tags()
	var system_score := _calculate_system_scores(semantic_tags, current_order)
	return {
		"prompt": "你是小炒 AI-7，一套怪菜点单评价系统。请只返回 JSON，不要输出额外解释。字段必须包含 dish_name、scores.relevance、scores.taste、scores.emotion、scores.risk、grade、comment、customer_reaction。语气毒舌但友好，评价要同时回应顾客需求和玩家选择。",
		"customer": {
			"name": current_order["customer_name"],
			"role": current_order["role"],
			"request": current_order["request"],
			"desired_tags": current_order["desired_tags"],
			"avoid_tags": current_order["avoid_tags"]
		},
		"dish": {
			"ingredients": ingredient_names,
			"seasonings": seasoning_names,
			"cooking_method": method["name"],
			"semantic_tags": semantic_tags
		},
		"system_score": system_score
	}

func _make_local_evaluation(payload: Dictionary) -> Dictionary:
	var scores: Dictionary = payload["system_score"].duplicate()
	var dish: Dictionary = payload["dish"]
	var customer: Dictionary = payload["customer"]
	var core_name = dish["ingredients"][0] if dish["ingredients"].size() > 0 else "空气"
	var need_tag = customer["desired_tags"][0] if customer["desired_tags"].size() > 0 else "情绪"
	var dish_name = "%s%s%s" % [need_tag, dish["cooking_method"], core_name]
	var total := _calculate_total_score(scores)
	var grade := _grade_for_score(total)
	var comment := _local_comment_for_grade(grade, customer["request"], dish["semantic_tags"])
	var reaction := _local_reaction_for_grade(grade)
	return {
		"dish_name": dish_name,
		"scores": scores,
		"grade": grade,
		"comment": comment,
		"customer_reaction": reaction
	}

func _sanitize_ai_evaluation(raw: Dictionary) -> Dictionary:
	if not raw.has("dish_name") or not raw.has("scores") or not raw.has("comment") or not raw.has("customer_reaction"):
		return {}
	if typeof(raw["scores"]) != TYPE_DICTIONARY:
		return {}
	var scores: Dictionary = raw["scores"]
	for key in ["relevance", "taste", "emotion", "risk"]:
		if not scores.has(key):
			return {}
	var dish_name := str(raw["dish_name"]).strip_edges()
	var comment := str(raw["comment"]).strip_edges()
	var reaction := str(raw["customer_reaction"]).strip_edges()
	if dish_name == "" or comment == "" or reaction == "":
		return {}
	return {
		"dish_name": dish_name,
		"scores": {
			"relevance": clampi(int(scores["relevance"]), 0, 100),
			"taste": clampi(int(scores["taste"]), 0, 100),
			"emotion": clampi(int(scores["emotion"]), 0, 100),
			"risk": clampi(int(scores["risk"]), 0, 100)
		},
		"grade": str(raw.get("grade", "")),
		"comment": comment,
		"customer_reaction": reaction
	}

func _calculate_system_scores(tags: Array, order: Dictionary) -> Dictionary:
	var desired_hits := _count_tag_hits(tags, order["desired_tags"])
	var avoid_hits := _count_tag_hits(tags, order["avoid_tags"])
	var desired_ratio := float(desired_hits) / float(maxi(1, order["desired_tags"].size()))

	var relevance := clampi(int(round(38.0 + desired_ratio * 58.0 - float(avoid_hits) * 9.0)), 0, 100)
	var emotion := clampi(int(round(34.0 + desired_ratio * 48.0 + float(_request_keyword_hits(tags, order["request"])) * 5.0 - float(avoid_hits) * 5.0)), 0, 100)
	var taste := _calculate_taste_score(tags)
	var risk := _calculate_risk_score(tags, int(order["difficulty"]))
	return {
		"relevance": relevance,
		"taste": taste,
		"emotion": emotion,
		"risk": risk
	}

func _calculate_taste_score(tags: Array) -> int:
	var taste := 54
	for stable_tag in ["饱腹", "稳定", "基础", "可靠", "家常", "温和", "甜", "安慰"]:
		if tags.has(stable_tag):
			taste += 5
	for harsh_tag in ["冲击", "争议", "幻觉", "重口", "痛感", "苦"]:
		if tags.has(harsh_tag):
			taste -= 4
	var flavor_count := 0
	for flavor in ["甜", "辣", "苦", "清凉", "油腻", "重口"]:
		if tags.has(flavor) or (flavor == "辣" and tags.has("刺激")):
			flavor_count += 1
	if flavor_count >= 4:
		taste -= 12
	return clampi(taste, 0, 100)

func _calculate_risk_score(tags: Array, difficulty: int) -> int:
	var risk := 26 + difficulty * 5
	for risk_tag in ["刺激", "风险", "痛感", "上头", "争议", "冲击", "冒险", "罪恶", "幻觉", "负担", "混乱"]:
		if tags.has(risk_tag):
			risk += 7
	for calm_tag in ["稳定", "温和", "柔和", "克制", "清爽", "可靠"]:
		if tags.has(calm_tag):
			risk -= 3
	return clampi(risk, 0, 100)

func _calculate_total_score(scores: Dictionary) -> int:
	var risk_balance = 100 - abs(int(scores["risk"]) - 55)
	var total = float(scores["relevance"]) * 0.4 + float(scores["taste"]) * 0.2 + float(scores["emotion"]) * 0.3 + float(risk_balance) * 0.1
	return clampi(int(round(total)), 0, 100)

func _calculate_service_cost(order: Dictionary) -> int:
	var difficulty := int(order.get("difficulty", 1))
	var cost := BASE_SERVICE_COST + completed_orders * SERVICE_COST_STEP + _difficulty_cost(difficulty)
	if active_buffs.has("cost_control"):
		cost = int(round(float(cost) * 0.9))
	return max(1, cost)

func _difficulty_cost(difficulty: int) -> int:
	if difficulty >= 5:
		return 80
	if difficulty >= 4:
		return 60
	if difficulty == 3:
		return 45
	if difficulty == 2:
		return 20
	return 0

func _base_payout_for_grade(grade: String) -> int:
	match grade:
		"S":
			return int(round(float(current_service_cost) * 2.4 + 60.0))
		"A":
			return int(round(float(current_service_cost) * 1.8 + 30.0))
		"B":
			return int(round(float(current_service_cost) * 1.25))
		"C":
			return int(round(float(current_service_cost) * 0.75))
		"D":
			return int(round(float(current_service_cost) * 0.35))
		_:
			return int(round(float(current_service_cost) * 0.2))

func _exp_for_grade(grade: String) -> int:
	match grade:
		"S":
			return 30
		"A":
			return 22
		"B":
			return 15
		"C":
			return 8
		"D":
			return 3
		_:
			return 1

func _update_player_level() -> void:
	for info in LEVEL_TITLES:
		if total_exp >= int(info["exp"]):
			player_level = int(info["level"])
			player_title = str(info["title"])

func _current_level_exp_floor() -> int:
	var floor_exp := 0
	for info in LEVEL_TITLES:
		if total_exp >= int(info["exp"]):
			floor_exp = int(info["exp"])
	return floor_exp

func _next_level_exp_target() -> int:
	for info in LEVEL_TITLES:
		var required_exp := int(info["exp"])
		if required_exp > total_exp:
			return required_exp
	return _current_level_exp_floor()

func _exp_progress_value() -> float:
	var floor_exp := _current_level_exp_floor()
	var target_exp := _next_level_exp_target()
	if target_exp <= floor_exp:
		return 100.0
	return clampf((float(total_exp - floor_exp) / float(target_exp - floor_exp)) * 100.0, 0.0, 100.0)

func _exp_progress_text() -> String:
	var target_exp := _next_level_exp_target()
	if target_exp <= _current_level_exp_floor():
		return "经验 %d / MAX" % total_exp
	return "经验 %d / %d" % [total_exp, target_exp]

func _title_for_level(level: int) -> String:
	var title := "街边新厨"
	for info in LEVEL_TITLES:
		if int(info["level"]) <= level:
			title = str(info["title"])
	return title

func _roll_buff_choices() -> Array:
	var available := []
	for buff in BUFF_POOL:
		if not active_buffs.has(buff["id"]):
			available.append(buff)
	var choices := []
	while choices.size() < 3 and not available.is_empty():
		var index := rng.randi_range(0, available.size() - 1)
		choices.append(available[index])
		available.remove_at(index)
	return choices

func _peek_next_service_cost() -> int:
	var min_ingredient := 999999
	for item in INGREDIENTS:
		min_ingredient = mini(min_ingredient, _price_for_item(item, "ingredient"))
	var min_seasoning := 999999
	for item in SEASONINGS:
		min_seasoning = mini(min_seasoning, _price_for_item(item, "seasoning"))
	return max(1, min_ingredient * INGREDIENT_MIN + min_seasoning * SEASONING_MIN + _method_cost(""))

func _method_cost(method_id: String) -> int:
	match method_id:
		"method_deep_fry":
			return 6
		"method_slow_stew":
			return 4
		"method_stir_fry":
			return 4
		"method_iced":
			return 2
		_:
			return 2

func _calculate_selection_cost() -> int:
	var cost := 0
	for id in selected_ingredient_ids:
		var item := _find_by_id(str(id), INGREDIENTS)
		if not item.is_empty():
			cost += _price_for_item(item, "ingredient")
	for id in selected_seasoning_ids:
		var item := _find_by_id(str(id), SEASONINGS)
		if not item.is_empty():
			cost += _price_for_item(item, "seasoning")
	if selected_method_id != "":
		cost += _method_cost(selected_method_id)
	if active_buffs.has("cost_control"):
		cost = int(round(float(cost) * 0.9))
	return max(0, cost)

func _grade_for_score(score: int) -> String:
	if score >= 90:
		return "S"
	if score >= 80:
		return "A"
	if score >= 70:
		return "B"
	if score >= 60:
		return "C"
	if score >= 45:
		return "D"
	return "F"

func _is_selection_valid() -> bool:
	return selected_ingredient_ids.size() >= INGREDIENT_MIN and selected_ingredient_ids.size() <= INGREDIENT_MAX and selected_seasoning_ids.size() >= SEASONING_MIN and selected_seasoning_ids.size() <= SEASONING_MAX and selected_method_id != ""

func _get_validity_text() -> String:
	var missing := []
	if selected_ingredient_ids.size() < INGREDIENT_MIN:
		missing.append("至少 %d 个食材" % INGREDIENT_MIN)
	if selected_seasoning_ids.size() < SEASONING_MIN:
		missing.append("至少 %d 个调料" % SEASONING_MIN)
	if selected_method_id == "":
		missing.append("1 种烹饪方式")
	if missing.is_empty():
		return "组合合法，可以出锅。"
	return "还缺：" + "、".join(missing)

func _auto_complete_for_timeout() -> void:
	while selected_ingredient_ids.size() < INGREDIENT_MIN:
		var item := _pick_unselected(INGREDIENTS, selected_ingredient_ids)
		if item.is_empty():
			break
		selected_ingredient_ids.append(item["id"])
	while selected_seasoning_ids.size() < SEASONING_MIN:
		var item := _pick_unselected(SEASONINGS, selected_seasoning_ids)
		if item.is_empty():
			break
		selected_seasoning_ids.append(item["id"])
	if selected_method_id == "":
		var method: Dictionary = COOKING_METHODS[rng.randi_range(0, COOKING_METHODS.size() - 1)]
		selected_method_id = method["id"]

func _selected_semantic_tags() -> Array:
	var tags := []
	for id in selected_ingredient_ids:
		_add_unique_tags(tags, _find_by_id(id, INGREDIENTS)["tags"])
	for id in selected_seasoning_ids:
		_add_unique_tags(tags, _find_by_id(id, SEASONINGS)["tags"])
	if selected_method_id != "":
		_add_unique_tags(tags, _find_by_id(selected_method_id, COOKING_METHODS)["tags"])
	return tags

func _add_unique_tags(target: Array, source: Array) -> void:
	for tag in source:
		if not target.has(tag):
			target.append(tag)

func _count_tag_hits(tags: Array, expected: Array) -> int:
	var count := 0
	for tag in expected:
		if tags.has(tag):
			count += 1
	return count

func _request_keyword_hits(tags: Array, request: String) -> int:
	var count := 0
	for tag in tags:
		if request.contains(str(tag)):
			count += 1
	return count

func _names_for_ids(ids: Array, source: Array) -> Array:
	var names := []
	for id in ids:
		names.append(_find_by_id(id, source)["name"])
	return names

func _find_by_id(id: String, source: Array) -> Dictionary:
	for item in source:
		if item["id"] == id:
			return item
	return {}

func _pick_unselected(source: Array, selected_ids: Array) -> Dictionary:
	var available := []
	for item in source:
		if not selected_ids.has(item["id"]):
			available.append(item)
	if available.is_empty():
		return {}
	return available[rng.randi_range(0, available.size() - 1)]

func _get_orders(want_boss: bool) -> Array:
	var orders := []
	for order in ORDERS:
		if bool(order["boss"]) == want_boss:
			orders.append(order)
	return orders

func _get_best_result() -> Dictionary:
	var best := {}
	for result in round_results:
		if best.is_empty() or int(result["total_score"]) > int(best["total_score"]):
			best = result
	return best

func _get_final_title(average: int) -> String:
	if average >= 90:
		return "夜市语义厨神"
	if average >= 80:
		return "期末续命大师"
	if average >= 70:
		return "情绪调味师"
	if average >= 60:
		return "灵魂爆炒专家"
	return "厨房事故艺术家"

func _local_comment_for_grade(grade: String, request: String, tags: Array) -> String:
	var tag_text = "、".join(tags.slice(0, mini(4, tags.size())))
	match grade:
		"S":
			return "这锅几乎把需求翻译成了可食用格式，连“%s”这种抽象要求都被你炒明白了。关键词：%s。" % [request, tag_text]
		"A":
			return "方向很准，怪得有控制感。小炒 AI-7 承认，这不是正常菜，但确实读懂了人。关键词：%s。" % tag_text
		"B":
			return "勉强对味，像是理解了顾客前三层意思，但第四层还在锅底糊着。关键词：%s。" % tag_text
		"C":
			return "精神状态稳定，味觉前途未卜。它回答了一部分需求，但回答得像临时组队。关键词：%s。" % tag_text
		"D":
			return "顾客的需求在锅边徘徊了一下，然后选择不进来。关键词：%s。" % tag_text
		_:
			return "这已经不是怪菜，是厨房向哲学发起的无效申请。关键词：%s。" % tag_text

func _local_reaction_for_grade(grade: String) -> String:
	match grade:
		"S":
			return "顾客眼神发亮，像突然看懂了人生的隐藏菜单。"
		"A":
			return "顾客沉默三秒，然后认真地点了点头。"
		"B":
			return "顾客说不上哪里对，但确实又吃了一口。"
		"C":
			return "顾客努力微笑，像在给你的创意留面子。"
		"D":
			return "顾客把筷子放下，开始重新描述需求。"
		_:
			return "顾客和锅同时陷入了沉默。"

func _avatar_for_order(order: Dictionary) -> String:
	if order.get("boss", false):
		return "◆"
	match int(order.get("difficulty", 1)):
		1, 2:
			return "●"
		3:
			return "◐"
		_:
			return "◎"

func _avatar_for_grade(grade: String) -> String:
	match grade:
		"S":
			return "S"
		"A":
			return "A"
		"B":
			return "B"
		"C":
			return "C"
		"D":
			return "D"
		_:
			return "F"

func _make_grade_stamp(grade: String) -> Control:
	var color := Color(0.22, 0.22, 0.24)
	match grade:
		"S":
			color = Color(0.92, 0.76, 0.22)
		"A":
			color = Color(0.86, 0.28, 0.32)
		"B":
			color = Color(0.2, 0.55, 0.92)
		"C":
			color = Color(0.24, 0.78, 0.52)
		"D":
			color = Color(0.55, 0.6, 0.66)
		_:
			color = Color(0.22, 0.22, 0.24)
	var stamp := PanelContainer.new()
	stamp.custom_minimum_size = Vector2(120, 120)
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = Color(0.08, 0.08, 0.1)
	style.border_width_left = 4
	style.border_width_top = 4
	style.border_width_right = 4
	style.border_width_bottom = 4
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10
	style.shadow_color = Color(0, 0, 0, 0.45)
	style.shadow_size = 6
	style.shadow_offset = Vector2(0, 6)
	stamp.add_theme_stylebox_override("panel", style)
	var center := CenterContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stamp.add_child(center)
	var label := _make_label(_avatar_for_grade(grade), 64, Color(0.1, 0.1, 0.12), HORIZONTAL_ALIGNMENT_CENTER)
	center.add_child(label)
	return stamp

func _load_supabase_config() -> Dictionary:
	if not FileAccess.file_exists(SUPABASE_CONFIG_PATH):
		return {}
	var file := FileAccess.open(SUPABASE_CONFIG_PATH, FileAccess.READ)
	if file == null:
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return {}
	return {
		"url": str(parsed.get("url", "")).strip_edges().trim_suffix("/"),
		"anon_key": str(parsed.get("anon_key", parsed.get("publishable_key", ""))).strip_edges()
	}

func _supabase_base_url() -> String:
	return str(supabase_config.get("url", "")).strip_edges().trim_suffix("/")

func _supabase_anon_key() -> String:
	return str(supabase_config.get("anon_key", "")).strip_edges()

func _is_logged_in() -> bool:
	return str(auth_session.get("access_token", "")).strip_edges() != ""

func _current_user_id() -> String:
	if typeof(current_user) == TYPE_DICTIONARY:
		return str(current_user.get("id", "")).strip_edges()
	return ""

func _user_display_name() -> String:
	var username := str(user_profile.get("username", "")).strip_edges()
	if username != "":
		return username
	if typeof(current_user) == TYPE_DICTIONARY:
		var email := str(current_user.get("email", "")).strip_edges()
		if email != "":
			return email.split("@")[0]
	return "新厨师"

func _get_avatar_texture() -> Texture2D:
	if current_avatar_texture != null:
		return current_avatar_texture
	var image := Image.create(96, 96, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.1, 0.2, 0.24, 1.0))
	for y in range(96):
		for x in range(96):
			var dx := float(x - 48) / 48.0
			var dy := float(y - 48) / 48.0
			if dx * dx + dy * dy > 1.0:
				image.set_pixel(x, y, Color(0, 0, 0, 0))
			elif dx * dx + dy * dy < 0.62:
				image.set_pixel(x, y, Color(0.19, 0.54, 0.58, 1.0))
	current_avatar_texture = ImageTexture.create_from_image(image)
	return current_avatar_texture

func _load_avatar_texture() -> void:
	current_avatar_texture = null
	var avatar_path := str(user_profile.get("avatar_path", "")).strip_edges()
	if avatar_path == "":
		return
	var url := _avatar_public_url(avatar_path)
	if url == "":
		return
	var request := HTTPRequest.new()
	add_child(request)
	request.request_completed.connect(func(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
		request.queue_free()
		if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
			return
		var image := Image.new()
		var ext := avatar_path.get_extension().to_lower()
		var err := ERR_FILE_UNRECOGNIZED
		if ext == "png":
			err = image.load_png_from_buffer(body)
		elif ext == "jpg" or ext == "jpeg":
			err = image.load_jpg_from_buffer(body)
		elif ext == "webp":
			err = image.load_webp_from_buffer(body)
		if err == OK:
			current_avatar_texture = ImageTexture.create_from_image(image)
	)
	request.request(url, _supabase_headers(false), HTTPClient.METHOD_GET)

func _avatar_public_url(path: String) -> String:
	if _supabase_base_url() == "":
		return ""
	return "%s/storage/v1/object/public/%s/%s" % [_supabase_base_url(), SUPABASE_AVATAR_BUCKET, _encode_storage_path(path)]

func _encode_storage_path(path: String) -> String:
	var parts := []
	for part in path.split("/", false):
		parts.append(part.uri_encode())
	return "/".join(parts)

func _send_supabase_request(method: String, path: String, payload: Dictionary, callback: Callable, use_auth: bool, extra_headers: Array = []) -> void:
	var request := HTTPRequest.new()
	add_child(request)
	request.request_completed.connect(func(result: int, response_code: int, _headers: PackedStringArray, response_body: PackedByteArray) -> void:
		request.queue_free()
		var parsed: Variant = {}
		var text := response_body.get_string_from_utf8()
		if text.strip_edges() != "":
			var json = JSON.parse_string(text)
			if json != null:
				parsed = json
		var ok := result == HTTPRequest.RESULT_SUCCESS and response_code >= 200 and response_code < 300
		if callback.is_valid():
			callback.call(ok, response_code, parsed)
	)
	var headers := _supabase_headers(use_auth)
	for header in extra_headers:
		headers.append(str(header))
	var body := ""
	if method != "GET":
		body = JSON.stringify(payload)
	var error := request.request(_supabase_base_url() + path, headers, _http_method(method), body)
	if error != OK and callback.is_valid():
		callback.call(false, 0, {})

func _send_supabase_binary_request(method: String, path: String, bytes: PackedByteArray, content_type: String, callback: Callable) -> void:
	var request := HTTPRequest.new()
	add_child(request)
	request.request_completed.connect(func(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
		request.queue_free()
		var parsed: Variant = {}
		var text := body.get_string_from_utf8()
		if text.strip_edges() != "":
			var json = JSON.parse_string(text)
			if json != null:
				parsed = json
		var ok := result == HTTPRequest.RESULT_SUCCESS and response_code >= 200 and response_code < 300
		if callback.is_valid():
			callback.call(ok, response_code, parsed)
	)
	var headers := _supabase_headers(true)
	headers.append("Content-Type: %s" % content_type)
	headers.append("x-upsert: true")
	var error := request.request_raw(_supabase_base_url() + path, headers, _http_method(method), bytes)
	if error != OK and callback.is_valid():
		callback.call(false, 0, {})

func _supabase_headers(use_auth: bool) -> PackedStringArray:
	var headers := PackedStringArray([
		"apikey: %s" % _supabase_anon_key()
	])
	if use_auth and _is_logged_in():
		headers.append("Authorization: Bearer %s" % str(auth_session.get("access_token", "")))
	else:
		headers.append("Authorization: Bearer %s" % _supabase_anon_key())
	headers.append("Content-Type: application/json")
	return headers

func _http_method(method: String) -> HTTPClient.Method:
	match method:
		"GET":
			return HTTPClient.METHOD_GET
		"POST":
			return HTTPClient.METHOD_POST
		"PATCH":
			return HTTPClient.METHOD_PATCH
		"DELETE":
			return HTTPClient.METHOD_DELETE
		_:
			return HTTPClient.METHOD_GET

func _save_json(path: String, value: Dictionary) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(JSON.stringify(value, "\t"))

func _add_selected_buttons(container: GridContainer, ids: Array, source: Array, callback: Callable) -> void:
	if ids.is_empty():
		var empty := _make_label("空", 16, Color(0.55, 0.62, 0.7))
		container.add_child(empty)
		return
	for id in ids:
		var item := _find_by_id(id, source)
		var button := _make_button(item["name"], 16)
		button.custom_minimum_size = Vector2(112, 44)
		button.pressed.connect(callback.bind(id))
		container.add_child(button)

func _make_score_bar(label_text: String, value: int) -> Control:
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 4)
	var label := _make_label("%s  %d" % [label_text, value], 17, Color(0.86, 0.9, 0.96))
	box.add_child(label)
	var bar := ProgressBar.new()
	bar.name = "ScoreBar"
	bar.min_value = 0
	bar.max_value = 100
	bar.value = 0
	bar.set_meta("target_value", value)
	bar.show_percentage = false
	bar.custom_minimum_size = Vector2(0, 22)
	box.add_child(bar)
	return box

func _update_timer_label() -> void:
	if timer_label == null:
		return
	var seconds := int(ceil(time_left))
	timer_label.text = "%02d" % seconds
	var urgency := clampf(1.0 - time_left / ROUND_SECONDS, 0.0, 1.0)
	if seconds <= 10:
		timer_label.add_theme_color_override("font_color", Color.RED)
		if not _timer_pulsing:
			_start_timer_pulse()
		if last_countdown_sfx_second != seconds:
			last_countdown_sfx_second = seconds
			_play_sfx("countdown")
	else:
		timer_label.add_theme_color_override("font_color", Color.GREEN.lerp(Color.YELLOW, urgency * 1.5))
		_stop_timer_pulse()
		last_countdown_sfx_second = -1

func _start_timer_pulse() -> void:
	if _timer_pulsing:
		return
	_timer_pulsing = true
	if not is_instance_valid(timer_label):
		return
	_timer_tween = timer_label.create_tween()
	_timer_tween.set_loops()
	_timer_tween.tween_property(timer_label, "scale", Vector2(1.15, 1.15), 0.35)
	_timer_tween.tween_property(timer_label, "scale", Vector2(1.0, 1.0), 0.35)

func _stop_timer_pulse() -> void:
	_timer_pulsing = false
	if is_instance_valid(_timer_tween):
		_timer_tween.kill()
	if is_instance_valid(timer_label):
		timer_label.scale = Vector2.ONE

func _make_page() -> MarginContainer:
	var background := ColorRect.new()
	background.color = COLOR_BG
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	if not is_instance_valid(_bg_overlay):
		var bg_tex := _get_bg_texture()
		_bg_overlay = TextureRect.new()
		_bg_overlay.texture = bg_tex
		_bg_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
		_bg_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_bg_overlay.stretch_mode = TextureRect.STRETCH_TILE
		_bg_overlay.modulate = Color(1, 1, 1, 0.12)
		_bg_overlay.offset_left = -64
		_bg_overlay.offset_top = -64
		_bg_overlay.offset_right = 64
		_bg_overlay.offset_bottom = 64
	add_child(_bg_overlay)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 18)
	add_child(margin)
	return margin

var _bg_texture_cache: Texture2D

func _get_bg_texture() -> Texture2D:
	if _bg_texture_cache:
		return _bg_texture_cache
	var s := 64
	var img := Image.create(s, s, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	for _i in range(200):
		var x := rng.randi() % s
		var y := rng.randi() % s
		img.set_pixel(x, y, Color(1, 1, 1, rng.randf_range(0.02, 0.06)))
	for i in range(s >> 3):
		var y := i * 8 + 4
		for x in range(s):
			img.set_pixel(x, y, Color(1, 1, 1, rng.randf_range(0.01, 0.04)))
	_bg_texture_cache = ImageTexture.create_from_image(img)
	return _bg_texture_cache

func _process_bg_movement(delta: float) -> void:
	if not is_instance_valid(_bg_overlay):
		return
	_bg_offset.x = fposmod(_bg_offset.x + delta * 2.0, 64.0)
	_bg_offset.y = fposmod(_bg_offset.y + delta * 1.2, 64.0)
	_bg_overlay.offset_left = -64 - _bg_offset.x
	_bg_overlay.offset_top = -64 - _bg_offset.y
	_bg_overlay.offset_right = 64 - _bg_offset.x
	_bg_overlay.offset_bottom = 64 - _bg_offset.y

func _start_cook_breath() -> void:
	_cook_breathing = true
	if not is_instance_valid(cook_button):
		return
	_cook_breath_tween = cook_button.create_tween()
	_cook_breath_tween.set_loops()
	_cook_breath_tween.tween_property(cook_button, "modulate", Color(1.0, 0.88, 0.3), 0.8)
	_cook_breath_tween.tween_property(cook_button, "modulate", Color(1.0, 0.6, 0.15), 0.8)

func _stop_cook_breath() -> void:
	_cook_breathing = false
	if is_instance_valid(_cook_breath_tween):
		_cook_breath_tween.kill()
	if is_instance_valid(cook_button):
		cook_button.modulate = Color.WHITE

func _update_vignette() -> void:
	var u := clampf(1.0 - time_left / 5.0, 0.0, 1.0)
	if u > 0.0 and screen_state == "playing":
		if not is_instance_valid(_vignette):
			_vignette = ColorRect.new()
			_vignette.color = Color(0, 0, 0, 0)
			_vignette.set_anchors_preset(Control.PRESET_FULL_RECT)
			_vignette.mouse_filter = Control.MOUSE_FILTER_IGNORE
			add_child(_vignette)
		_vignette.color = Color(0, 0, 0, u * 0.4)
	elif is_instance_valid(_vignette):
		_vignette.color = Color(0, 0, 0, 0)

func _start_avatar_idle() -> void:
	if not is_instance_valid(customer_avatar_rect):
		return
	if customer_avatar_rect.has_meta("avatar_idle_started") and bool(customer_avatar_rect.get_meta("avatar_idle_started")):
		return
	customer_avatar_rect.set_meta("avatar_idle_started", true)
	var base_y := customer_avatar_rect.position.y
	var t := customer_avatar_rect.create_tween()
	t.set_loops()
	t.tween_property(customer_avatar_rect, "position:y", base_y - 4.0, 1.2).set_ease(Tween.EASE_IN_OUT)
	t.tween_property(customer_avatar_rect, "position:y", base_y + 4.0, 1.2).set_ease(Tween.EASE_IN_OUT)

func _coin_bounce() -> void:
	if not is_instance_valid(coins_label):
		return
	coins_label.add_theme_color_override("font_color", COLOR_SECONDARY)
	var t := coins_label.create_tween()
	t.tween_property(coins_label, "scale", Vector2(1.3, 1.3), 0.15)
	t.tween_property(coins_label, "scale", Vector2(1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT)
	t.tween_callback(func():
		if is_instance_valid(coins_label):
			coins_label.add_theme_color_override("font_color", COLOR_TEXT)
	)

func _typewriter_label(text: String, font_size: int, color: Color, align := HORIZONTAL_ALIGNMENT_CENTER) -> Label:
	var label := _make_label("", font_size, color, align)
	label.name = "TitleTypewriter"
	var t := label.create_tween()
	for i in range(text.length()):
		var idx := i
		t.tween_callback(func(): label.text = text.substr(0, idx + 1))
		t.tween_interval(0.06)
	return label

func _make_panel(bg_color: Color = Color(0.09, 0.09, 0.18), border_color: Color = Color(0.24, 0.27, 0.4), corner_radius: int = 12) -> PanelContainer:
	var panel := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = bg_color
	style.border_color = border_color
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.corner_radius_top_left = corner_radius
	style.corner_radius_top_right = corner_radius
	style.corner_radius_bottom_left = corner_radius
	style.corner_radius_bottom_right = corner_radius
	style.content_margin_left = 16
	style.content_margin_top = 16
	style.content_margin_right = 16
	style.content_margin_bottom = 16
	panel.add_theme_stylebox_override("panel", style)
	return panel

func _apply_panel_style(panel: PanelContainer, bg_color: Color, border_color: Color, corner_radius: int) -> void:
	if not is_instance_valid(panel):
		return
	var style := StyleBoxFlat.new()
	style.bg_color = bg_color
	style.border_color = border_color
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.corner_radius_top_left = corner_radius
	style.corner_radius_top_right = corner_radius
	style.corner_radius_bottom_left = corner_radius
	style.corner_radius_bottom_right = corner_radius
	style.content_margin_left = 16
	style.content_margin_top = 16
	style.content_margin_right = 16
	style.content_margin_bottom = 16
	panel.add_theme_stylebox_override("panel", style)

func _make_separator() -> Control:
	var sep := ColorRect.new()
	sep.color = Color(0.18, 0.2, 0.3)
	sep.custom_minimum_size = Vector2(0, 2)
	sep.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return sep

func _make_label(text: String, font_size: int, color: Color = Color.WHITE, align: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = align
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	return label

func _make_button(text: String, font_size: int) -> Button:
	var button := Button.new()
	button.text = text
	button.add_theme_font_size_override("font_size", font_size)
	button.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	_apply_button_default(button)
	return button

func _make_line_edit(placeholder: String) -> LineEdit:
	var input := LineEdit.new()
	input.placeholder_text = placeholder
	input.add_theme_font_size_override("font_size", 18)
	input.add_theme_color_override("font_color", Color(0.94, 0.96, 1.0))
	input.add_theme_color_override("font_placeholder_color", Color(0.5, 0.58, 0.64))
	input.add_theme_stylebox_override("normal", _input_style(Color(0.06, 0.075, 0.088), Color(0.24, 0.38, 0.46)))
	input.add_theme_stylebox_override("focus", _input_style(Color(0.07, 0.09, 0.105), Color(0.34, 0.72, 0.76)))
	return input

func _input_style(bg_color: Color, border_color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg_color
	style.border_color = border_color
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 12
	style.content_margin_top = 8
	style.content_margin_right = 12
	style.content_margin_bottom = 8
	return style

func _make_styled_button(text: String, font_size: int, bg_color: Color, border_color: Color, font_color: Color, corner_radius: int = 12) -> Button:
	var button := Button.new()
	button.text = text
	button.add_theme_font_size_override("font_size", font_size)
	button.add_theme_color_override("font_color", font_color)
	button.add_theme_color_override("font_hover_color", font_color)
	button.add_theme_color_override("font_pressed_color", font_color)
	button.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS

	var normal := StyleBoxFlat.new()
	normal.bg_color = bg_color
	normal.border_color = border_color
	normal.border_width_left = 2
	normal.border_width_top = 2
	normal.border_width_right = 2
	normal.border_width_bottom = 2
	normal.corner_radius_top_left = corner_radius
	normal.corner_radius_top_right = corner_radius
	normal.corner_radius_bottom_left = corner_radius
	normal.corner_radius_bottom_right = corner_radius
	normal.shadow_color = Color(0.0, 0.0, 0.0, 0.35)
	normal.shadow_size = 3
	normal.shadow_offset = Vector2(0, 3)
	normal.content_margin_left = 14
	normal.content_margin_top = 10
	normal.content_margin_right = 14
	normal.content_margin_bottom = 10

	var hover := normal.duplicate()
	(hover as StyleBoxFlat).bg_color = bg_color.lerp(Color(1, 1, 1), 0.04)
	(hover as StyleBoxFlat).border_color = border_color.lerp(COLOR_ACCENT, 0.35)

	var pressed := normal.duplicate()
	(pressed as StyleBoxFlat).shadow_size = 1
	(pressed as StyleBoxFlat).shadow_offset = Vector2(0, 1)
	(pressed as StyleBoxFlat).content_margin_top = 12
	(pressed as StyleBoxFlat).content_margin_bottom = 8

	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)
	button.add_theme_stylebox_override("focus", hover)
	return button

func _make_action_button(text: String, font_size: int, bg_color: Color, border_color: Color) -> Button:
	return _make_styled_button(text, font_size, bg_color, border_color, Color(0.94, 0.96, 1.0), 12)

func _make_option_button(text: String, font_size: int) -> Button:
	return _make_styled_button(text, font_size, Color(0.17, 0.18, 0.17), Color(0.45, 0.38, 0.28), Color(0.94, 0.84, 0.68), 10)

func _punch_scale(node: Control, pressed_scale: Vector2, duration: float = 0.16) -> void:
	if not is_instance_valid(node):
		return
	var rect_size := node.get_rect().size
	if rect_size.x > 0.0 and rect_size.y > 0.0:
		node.pivot_offset = rect_size * 0.5
	var tween := create_tween()
	tween.tween_property(node, "scale", pressed_scale, duration * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "scale", Vector2.ONE, duration * 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _set_number_label(value: float, label: Label, format_text: String) -> void:
	if not is_instance_valid(label):
		return
	label.text = format_text % int(round(value))

func _play_sfx(key: String) -> void:
	var path := ""
	match key:
		"select":
			path = "res://assets/sfx/select.wav"
		"cook":
			path = "res://assets/sfx/cook.wav"
		"score":
			path = "res://assets/sfx/score.wav"
		"stamp":
			path = "res://assets/sfx/stamp.wav"
		"coin":
			path = "res://assets/sfx/coin.wav"
		"countdown":
			path = "res://assets/sfx/countdown.wav"
		_:
			path = ""
	if path == "" or not ResourceLoader.exists(path):
		return
	var stream := load(path)
	if not (stream is AudioStream):
		return
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.bus = "Master"
	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()

func _advance_dots(label: Label) -> void:
	if not is_instance_valid(label):
		return
	var step: int = int(label.get_meta("dots_step", 0))
	step = (step + 1) % 4
	label.set_meta("dots_step", step)
	label.text = ".".repeat(step + 1)

func _start_dots_animation(label: Label) -> void:
	if not is_instance_valid(label):
		return
	label.set_meta("dots_step", -1)
	var tween := create_tween()
	tween.set_loops()
	for _i in range(4):
		tween.tween_callback(Callable(self, "_advance_dots").bind(label))
		tween.tween_interval(0.22)
func _apply_button_default(button: Button) -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color(0.18, 0.19, 0.34)
	normal.border_color = Color(0.4, 0.42, 0.62)
	normal.border_width_left = 1
	normal.border_width_top = 1
	normal.border_width_right = 1
	normal.border_width_bottom = 1
	normal.corner_radius_top_left = 12
	normal.corner_radius_top_right = 12
	normal.corner_radius_bottom_left = 12
	normal.corner_radius_bottom_right = 12
	normal.shadow_color = Color(0.0, 0.0, 0.0, 0.35)
	normal.shadow_size = 3
	normal.shadow_offset = Vector2(0, 3)
	normal.content_margin_left = 14
	normal.content_margin_top = 10
	normal.content_margin_right = 14
	normal.content_margin_bottom = 10

	var hover := normal.duplicate()
	hover.bg_color = Color(0.22, 0.24, 0.4)
	hover.border_color = Color(0.52, 0.92, 1.0)

	var pressed := normal.duplicate()
	pressed.shadow_size = 1
	pressed.shadow_offset = Vector2(0, 1)
	pressed.content_margin_top = 12
	pressed.content_margin_bottom = 8

	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)

func _apply_button_selected(button: Button) -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color(0.14, 0.14, 0.28)
	normal.border_color = COLOR_SECONDARY
	normal.border_width_left = 2
	normal.border_width_top = 2
	normal.border_width_right = 2
	normal.border_width_bottom = 2
	normal.corner_radius_top_left = 12
	normal.corner_radius_top_right = 12
	normal.corner_radius_bottom_left = 12
	normal.corner_radius_bottom_right = 12
	normal.shadow_color = Color(0.0, 0.0, 0.0, 0.35)
	normal.shadow_size = 3
	normal.shadow_offset = Vector2(0, 3)
	normal.content_margin_left = 14
	normal.content_margin_top = 10
	normal.content_margin_right = 14
	normal.content_margin_bottom = 10

	var hover := normal.duplicate()
	hover.border_color = COLOR_ACCENT

	var pressed := normal.duplicate()
	pressed.shadow_size = 1
	pressed.shadow_offset = Vector2(0, 1)
	pressed.content_margin_top = 12
	pressed.content_margin_bottom = 8

	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)

func _apply_button_accent(button: Button, accent: Color) -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color(0.12, 0.12, 0.24)
	normal.border_color = accent
	normal.border_width_left = 2
	normal.border_width_top = 2
	normal.border_width_right = 2
	normal.border_width_bottom = 2
	normal.corner_radius_top_left = 12
	normal.corner_radius_top_right = 12
	normal.corner_radius_bottom_left = 12
	normal.corner_radius_bottom_right = 12
	normal.shadow_color = Color(0.0, 0.0, 0.0, 0.35)
	normal.shadow_size = 3
	normal.shadow_offset = Vector2(0, 3)
	normal.content_margin_left = 16
	normal.content_margin_top = 12
	normal.content_margin_right = 16
	normal.content_margin_bottom = 12
	button.add_theme_stylebox_override("normal", normal)

func _get_item_icon(kind: String, key: String, icon_size: int) -> Texture2D:
	var path := "%s/%s.png" % [ITEM_ICON_DIR, key]
	var tex := _get_file_texture(path)
	if tex is Texture2D:
		return tex as Texture2D
	var a := COLOR_FOOD
	var b := COLOR_SECONDARY
	if kind == "seasoning":
		a = COLOR_PRIMARY
		b = COLOR_SECONDARY
	elif kind == "method":
		a = COLOR_ACCENT
		b = COLOR_PRIMARY
	var icon_key := key
	if not icon_key.begins_with(kind + "_"):
		icon_key = "%s_%s" % [kind, key]
	return _get_icon(icon_key, icon_size, a, b)

func _missing_item_icon_ids() -> Array:
	var missing: Array = []
	for item in INGREDIENTS:
		var id := str(item.get("id", ""))
		if id == "":
			continue
		var path := "%s/%s.png" % [ITEM_ICON_DIR, id]
		var abs_path_ing := ProjectSettings.globalize_path(path)
		if not ResourceLoader.exists(path) and not FileAccess.file_exists(abs_path_ing):
			missing.append(id)
	for item in SEASONINGS:
		var id := str(item.get("id", ""))
		if id == "":
			continue
		var path := "%s/%s.png" % [ITEM_ICON_DIR, id]
		var abs_path_sea := ProjectSettings.globalize_path(path)
		if not ResourceLoader.exists(path) and not FileAccess.file_exists(abs_path_sea):
			missing.append(id)
	return missing

func _get_file_texture(path: String) -> Texture2D:
	if file_texture_cache.has(path):
		return file_texture_cache[path] as Texture2D

	if path.begins_with(ITEM_ICON_DIR):
		var icon_abs_path := ProjectSettings.globalize_path(path)
		if FileAccess.file_exists(icon_abs_path):
			var icon_img := Image.new()
			var icon_err := icon_img.load(icon_abs_path)
			if icon_err == OK:
				var icon_tex := ImageTexture.create_from_image(icon_img)
				file_texture_cache[path] = icon_tex
				return icon_tex

	var res = null
	if ResourceLoader.exists(path):
		res = load(path)
		if res is Texture2D:
			file_texture_cache[path] = res
			return res as Texture2D

	var abs_path := ProjectSettings.globalize_path(path)
	if not FileAccess.file_exists(abs_path):
		return null
	var img := Image.new()
	var err := img.load(abs_path)
	if err != OK:
		return null
	var tex := ImageTexture.create_from_image(img)
	file_texture_cache[path] = tex
	return tex

func _character_index_for_key(key: String) -> int:
	var h: int = key.hash()
	if h < 0:
		h = -h
	return int(h % CHARACTER_IDLE_SHEETS.size())

func _get_customer_idle_sheet_index(i: int) -> Texture2D:
	var idx: int = clampi(i, 0, CHARACTER_IDLE_SHEETS.size() - 1)
	return _get_file_texture(CHARACTER_IDLE_SHEETS[idx])

func _get_customer_walk_sheet_index(i: int) -> Texture2D:
	var idx: int = clampi(i, 0, CHARACTER_WALK_SHEETS.size() - 1)
	return _get_file_texture(CHARACTER_WALK_SHEETS[idx])

func _get_customer_portrait_index(i: int) -> Texture2D:
	var sheet := _get_customer_idle_sheet_index(i)
	if not (sheet is Texture2D):
		return _get_icon("avatar_customer_%d" % i, 128, COLOR_ACCENT, COLOR_PRIMARY)
	var fw: int = int(floor(float(sheet.get_width()) / float(CHARACTER_SHEET_COLS)))
	var fh: int = int(floor(float(sheet.get_height()) / float(CHARACTER_SHEET_ROWS)))
	var atlas := AtlasTexture.new()
	atlas.atlas = sheet
	atlas.region = Rect2i(0, CHARACTER_ROW_FRONT * fh, fw, fh)
	return atlas

func _get_customer_body_index(i: int) -> Texture2D:
	var sheet := _get_customer_idle_sheet_index(i)
	if not (sheet is Texture2D):
		return _get_icon("avatar_customer_body_%d" % i, 256, COLOR_ACCENT, COLOR_PRIMARY)
	var fw: int = int(floor(float(sheet.get_width()) / float(CHARACTER_SHEET_COLS)))
	var fh: int = int(floor(float(sheet.get_height()) / float(CHARACTER_SHEET_ROWS)))
	var atlas := AtlasTexture.new()
	atlas.atlas = sheet
	atlas.region = Rect2i(0, CHARACTER_ROW_FRONT * fh, fw, fh)
	return atlas

func _get_customer_idle_sheet(key: String) -> Texture2D:
	var i: int = _character_index_for_key(key)
	return _get_file_texture(CHARACTER_IDLE_SHEETS[i])

func _get_customer_walk_sheet(key: String) -> Texture2D:
	var i: int = _character_index_for_key(key)
	return _get_file_texture(CHARACTER_WALK_SHEETS[i])

func _get_customer_portrait(key: String) -> Texture2D:
	var sheet := _get_customer_idle_sheet(key)
	if not (sheet is Texture2D):
		return _get_icon("avatar_%s" % key, 128, COLOR_ACCENT, COLOR_PRIMARY)
	var fw: int = int(floor(float(sheet.get_width()) / float(CHARACTER_SHEET_COLS)))
	var fh: int = int(floor(float(sheet.get_height()) / float(CHARACTER_SHEET_ROWS)))
	var atlas := AtlasTexture.new()
	atlas.atlas = sheet
	atlas.region = Rect2i(0, CHARACTER_ROW_FRONT * fh, fw, fh)
	return atlas

func _icon_rect(image: Image, ox: int, oy: int, x: int, y: int, w: int, h: int, pixel_scale: int, color: Color) -> void:
	image.fill_rect(Rect2i(ox + x * pixel_scale, oy + y * pixel_scale, w * pixel_scale, h * pixel_scale), color)

func _icon_px(image: Image, ox: int, oy: int, x: int, y: int, pixel_scale: int, color: Color) -> void:
	image.fill_rect(Rect2i(ox + x * pixel_scale, oy + y * pixel_scale, pixel_scale, pixel_scale), color)

func _mask_set(mask: PackedByteArray, x: int, y: int, v: int) -> void:
	if x < 0 or x >= 16 or y < 0 or y >= 16:
		return
	mask[y * 16 + x] = v

func _icon_rect_mask(image: Image, mask: PackedByteArray, ox: int, oy: int, x: int, y: int, w: int, h: int, pixel_scale: int, color: Color) -> void:
	_icon_rect(image, ox, oy, x, y, w, h, pixel_scale, color)
	if color.a <= 0.0:
		return
	for yy in range(y, y + h):
		for xx in range(x, x + w):
			_mask_set(mask, xx, yy, 1)

func _icon_px_mask(image: Image, mask: PackedByteArray, ox: int, oy: int, x: int, y: int, pixel_scale: int, color: Color) -> void:
	_icon_px(image, ox, oy, x, y, pixel_scale, color)
	if color.a <= 0.0:
		return
	_mask_set(mask, x, y, 1)

func _draw_shadow_from_mask(image: Image, mask: PackedByteArray, ox: int, oy: int, pixel_scale: int, dx: int, dy: int, color: Color) -> void:
	for y in range(16):
		for x in range(16):
			if mask[y * 16 + x] != 1:
				continue
			var sx := x + dx
			var sy := y + dy
			if sx < 0 or sx >= 16 or sy < 0 or sy >= 16:
				continue
			var px := ox + sx * pixel_scale
			var py := oy + sy * pixel_scale
			var existing := image.get_pixel(px, py)
			if existing.a > 0.02:
				continue
			_icon_px(image, ox, oy, sx, sy, pixel_scale, color)

func _draw_outline_from_mask(image: Image, mask: PackedByteArray, ox: int, oy: int, pixel_scale: int, color: Color) -> void:
	var out := PackedByteArray()
	out.resize(16 * 16)
	out.fill(0)
	for y in range(16):
		for x in range(16):
			if mask[y * 16 + x] != 1:
				continue
			for dy in range(-1, 2):
				for dx in range(-1, 2):
					if dx == 0 and dy == 0:
						continue
					var nx := x + dx
					var ny := y + dy
					if nx < 0 or nx >= 16 or ny < 0 or ny >= 16:
						continue
					if mask[ny * 16 + nx] == 1:
						continue
					out[ny * 16 + nx] = 1
	for y in range(16):
		for x in range(16):
			if out[y * 16 + x] == 1:
				_icon_px(image, ox, oy, x, y, pixel_scale, color)

func _lighten(color: Color, t: float) -> Color:
	return color.lerp(Color(1.0, 1.0, 1.0, color.a), t)

func _darken(color: Color, t: float) -> Color:
	return color.lerp(Color(0.0, 0.0, 0.0, color.a), t)

func _draw_badge(image: Image, ox: int, oy: int, pixel_scale: int, base: Color) -> void:
	var fill := Color(base.r, base.g, base.b, 0.16)
	var border := Color(0.0, 0.0, 0.0, 0.22)
	var inner := Color(1.0, 1.0, 1.0, 0.08)
	_icon_rect(image, ox, oy, 2, 2, 12, 12, pixel_scale, fill)
	_icon_rect(image, ox, oy, 2, 2, 12, 1, pixel_scale, inner)
	_icon_rect(image, ox, oy, 2, 13, 12, 1, pixel_scale, border)
	_icon_rect(image, ox, oy, 2, 2, 1, 12, pixel_scale, border)
	_icon_rect(image, ox, oy, 13, 2, 1, 12, pixel_scale, border)

func _is_legacy_generated_icon(img: Image) -> bool:
	if img.is_empty():
		return false
	if img.get_width() < 8 or img.get_height() < 8:
		return false
	var legacy_bg := Color(0.1, 0.11, 0.2, 1.0)
	var samples := [
		Vector2i(0, 0),
		Vector2i(img.get_width() - 1, 0),
		Vector2i(0, img.get_height() - 1),
		Vector2i(img.get_width() - 1, img.get_height() - 1)
	]
	for p in samples:
		var c := img.get_pixelv(p)
		if absf(c.a - 1.0) > 0.01:
			return false
		if absf(c.r - legacy_bg.r) > 0.03 or absf(c.g - legacy_bg.g) > 0.03 or absf(c.b - legacy_bg.b) > 0.03:
			return false
	return true

func _draw_bowl(image: Image, mask: PackedByteArray, ox: int, oy: int, pixel_scale: int, bowl: Color, rim: Color) -> void:
	var bowl_dark := _darken(bowl, 0.28)
	var rim_light := _lighten(rim, 0.22)
	_icon_rect_mask(image, mask, ox, oy, 3, 10, 10, 1, pixel_scale, rim)
	_icon_rect_mask(image, mask, ox, oy, 4, 11, 8, 3, pixel_scale, bowl)
	_icon_rect_mask(image, mask, ox, oy, 4, 13, 8, 1, pixel_scale, bowl_dark)
	_icon_px_mask(image, mask, ox, oy, 4, 11, pixel_scale, rim_light)
	_icon_px_mask(image, mask, ox, oy, 11, 11, pixel_scale, _darken(rim, 0.18))

func _id_hash_positive(id: String) -> int:
	var h: int = id.hash()
	if h < 0:
		h = -h
	return h

func _draw_generic_food_icon(image: Image, mask: PackedByteArray, ox: int, oy: int, pixel_scale: int, id: String, base: Color, kind: String) -> void:
	var h := _id_hash_positive(id)
	var v: int = int(h % 6)
	var c := base
	var hi := _lighten(c, 0.22)
	var sh := _darken(c, 0.25)
	if kind == "seasoning":
		v = int(h % 5)
	match v:
		0:
			_icon_rect_mask(image, mask, ox, oy, 6, 6, 4, 5, pixel_scale, c)
			_icon_rect_mask(image, mask, ox, oy, 6, 6, 4, 1, pixel_scale, hi)
			_icon_rect_mask(image, mask, ox, oy, 6, 10, 4, 1, pixel_scale, sh)
			_icon_px_mask(image, mask, ox, oy, 6, 7, pixel_scale, hi)
			_icon_px_mask(image, mask, ox, oy, 9, 9, pixel_scale, hi)
		1:
			_icon_rect_mask(image, mask, ox, oy, 5, 7, 6, 5, pixel_scale, c)
			_icon_rect_mask(image, mask, ox, oy, 5, 7, 6, 1, pixel_scale, hi)
			_icon_rect_mask(image, mask, ox, oy, 5, 11, 6, 1, pixel_scale, sh)
			_icon_px_mask(image, mask, ox, oy, 6, 9, pixel_scale, _darken(c, 0.12))
			_icon_px_mask(image, mask, ox, oy, 9, 8, pixel_scale, _darken(c, 0.12))
		2:
			_draw_bowl(image, mask, ox, oy, pixel_scale, _darken(c, 0.15), _lighten(Color(0.86, 0.88, 0.96), 0.0))
			_icon_rect_mask(image, mask, ox, oy, 5, 7, 6, 3, pixel_scale, c)
			_icon_px_mask(image, mask, ox, oy, 6, 7, pixel_scale, hi)
			_icon_px_mask(image, mask, ox, oy, 9, 8, pixel_scale, sh)
		3:
			_icon_rect_mask(image, mask, ox, oy, 5, 6, 6, 6, pixel_scale, c)
			_icon_rect_mask(image, mask, ox, oy, 5, 6, 6, 1, pixel_scale, hi)
			_icon_rect_mask(image, mask, ox, oy, 5, 11, 6, 1, pixel_scale, sh)
			for i in range(4):
				_icon_px_mask(image, mask, ox, oy, 6 + i, 8 - (i % 2), pixel_scale, _lighten(c, 0.12))
		4:
			_icon_rect_mask(image, mask, ox, oy, 7, 5, 2, 8, pixel_scale, sh)
			for i in range(4):
				_icon_rect_mask(image, mask, ox, oy, 5, 7 + i, 6, 1, pixel_scale, c.lerp(hi, float(i) / 4.0))
			_icon_px_mask(image, mask, ox, oy, 5, 7, pixel_scale, hi)
			_icon_px_mask(image, mask, ox, oy, 10, 10, pixel_scale, sh)
		5:
			_icon_rect_mask(image, mask, ox, oy, 4, 8, 3, 3, pixel_scale, c)
			_icon_rect_mask(image, mask, ox, oy, 7, 7, 3, 3, pixel_scale, c)
			_icon_rect_mask(image, mask, ox, oy, 10, 8, 2, 2, pixel_scale, c)
			_icon_px_mask(image, mask, ox, oy, 4, 8, pixel_scale, hi)
			_icon_px_mask(image, mask, ox, oy, 8, 7, pixel_scale, hi)

func _draw_named_icon(image: Image, key: String, a: Color, b: Color) -> void:
	var pixel_scale := maxi(1, int(floor(float(image.get_width()) / 16.0)))
	var canvas := 16 * pixel_scale
	var ox := int(floor(float(image.get_width() - canvas) / 2.0))
	var oy := int(floor(float(image.get_height() - canvas) / 2.0))

	var outline := Color(0.05, 0.05, 0.08, 1.0)

	var split_at := key.find("_")
	var kind := key
	var id := ""
	if split_at >= 0:
		kind = key.substr(0, split_at)
		id = key.substr(split_at + 1)

	_draw_badge(image, ox, oy, pixel_scale, b)
	var mask := PackedByteArray()
	mask.resize(16 * 16)
	mask.fill(0)

	match kind:
		"ui":
			if id == "timer":
				var face := Color(0.14, 0.14, 0.22)
				_icon_rect_mask(image, mask, ox, oy, 4, 4, 8, 7, pixel_scale, face)
				_icon_px_mask(image, mask, ox, oy, 7, 5, pixel_scale, _lighten(b, 0.35))
				_icon_px_mask(image, mask, ox, oy, 7, 6, pixel_scale, _lighten(b, 0.2))
				_icon_rect_mask(image, mask, ox, oy, 8, 7, 2, 1, pixel_scale, _lighten(a, 0.15))
				_draw_shadow_from_mask(image, mask, ox, oy, pixel_scale, 1, 1, Color(0, 0, 0, 0.22))
				_draw_outline_from_mask(image, mask, ox, oy, pixel_scale, outline)
			elif id == "coin":
				var gold := Color(0.92, 0.74, 0.18)
				var gold_hi := _lighten(gold, 0.35)
				var gold_dark := _darken(gold, 0.28)
				_icon_rect_mask(image, mask, ox, oy, 5, 5, 6, 6, pixel_scale, gold)
				_icon_rect_mask(image, mask, ox, oy, 5, 5, 6, 1, pixel_scale, gold_hi)
				_icon_rect_mask(image, mask, ox, oy, 5, 10, 6, 1, pixel_scale, gold_dark)
				_icon_px_mask(image, mask, ox, oy, 6, 7, pixel_scale, gold_hi)
				_icon_px_mask(image, mask, ox, oy, 9, 8, pixel_scale, gold_hi)
				_draw_shadow_from_mask(image, mask, ox, oy, pixel_scale, 1, 1, Color(0, 0, 0, 0.22))
				_draw_outline_from_mask(image, mask, ox, oy, pixel_scale, outline)
		"avatar":
			var skin := Color(0.92, 0.78, 0.64)
			var hair := Color(0.12, 0.12, 0.16).lerp(a, 0.25)
			_icon_rect_mask(image, mask, ox, oy, 5, 4, 6, 7, pixel_scale, skin)
			_icon_rect_mask(image, mask, ox, oy, 5, 4, 6, 2, pixel_scale, hair)
			_icon_px_mask(image, mask, ox, oy, 6, 7, pixel_scale, outline)
			_icon_px_mask(image, mask, ox, oy, 9, 7, pixel_scale, outline)
			_icon_rect_mask(image, mask, ox, oy, 7, 9, 2, 1, pixel_scale, Color(0.72, 0.32, 0.32))
			_draw_shadow_from_mask(image, mask, ox, oy, pixel_scale, 1, 1, Color(0, 0, 0, 0.18))
			_draw_outline_from_mask(image, mask, ox, oy, pixel_scale, outline)
		"ingredient":
			_draw_badge(image, ox, oy, pixel_scale, Color(0.34, 0.22, 0.16))
			match id:
				"noodle":
					_draw_bowl(image, mask, ox, oy, pixel_scale, Color(0.22, 0.24, 0.36), Color(0.86, 0.88, 0.96))
					var noodle := Color(0.96, 0.82, 0.26)
					var noodle_hi := _lighten(noodle, 0.25)
					for i in range(7):
						_icon_px_mask(image, mask, ox, oy, 4 + i, 8 - (i % 2), pixel_scale, noodle)
						_icon_px_mask(image, mask, ox, oy, 4 + i, 9 - ((i + 1) % 2), pixel_scale, noodle_hi)
					_icon_rect_mask(image, mask, ox, oy, 6, 5, 1, 3, pixel_scale, Color(0.92, 0.95, 1.0, 0.65))
					_icon_rect_mask(image, mask, ox, oy, 9, 5, 1, 3, pixel_scale, Color(0.92, 0.95, 1.0, 0.55))
				"rice":
					_draw_bowl(image, mask, ox, oy, pixel_scale, Color(0.22, 0.24, 0.36), Color(0.86, 0.88, 0.96))
					var rice := Color(0.94, 0.94, 0.92)
					var rice_sh := _darken(rice, 0.12)
					_icon_rect_mask(image, mask, ox, oy, 5, 7, 6, 3, pixel_scale, rice)
					_icon_px_mask(image, mask, ox, oy, 6, 7, pixel_scale, rice_sh)
					_icon_px_mask(image, mask, ox, oy, 8, 8, pixel_scale, rice_sh)
					_icon_px_mask(image, mask, ox, oy, 9, 7, pixel_scale, _lighten(rice, 0.2))
				"egg":
					var white := Color(0.96, 0.94, 0.9)
					var white_sh := _darken(white, 0.18)
					var yolk := Color(1.0, 0.78, 0.18)
					var yolk_hi := _lighten(yolk, 0.25)
					_icon_rect_mask(image, mask, ox, oy, 5, 5, 6, 6, pixel_scale, white)
					_icon_rect_mask(image, mask, ox, oy, 5, 10, 6, 1, pixel_scale, white_sh)
					_icon_rect_mask(image, mask, ox, oy, 7, 7, 2, 2, pixel_scale, yolk)
					_icon_px_mask(image, mask, ox, oy, 7, 7, pixel_scale, yolk_hi)
				"dumpling":
					var dough := Color(0.92, 0.86, 0.72)
					var dough_hi := _lighten(dough, 0.25)
					var dough_sh := _darken(dough, 0.22)
					_icon_rect_mask(image, mask, ox, oy, 4, 8, 4, 3, pixel_scale, dough)
					_icon_rect_mask(image, mask, ox, oy, 8, 7, 4, 3, pixel_scale, dough)
					_icon_rect_mask(image, mask, ox, oy, 4, 8, 4, 1, pixel_scale, dough_hi)
					_icon_rect_mask(image, mask, ox, oy, 8, 7, 4, 1, pixel_scale, dough_hi)
					_icon_rect_mask(image, mask, ox, oy, 4, 10, 4, 1, pixel_scale, dough_sh)
					_icon_rect_mask(image, mask, ox, oy, 8, 9, 4, 1, pixel_scale, dough_sh)
					for i in range(3):
						_icon_px_mask(image, mask, ox, oy, 5 + i, 8, pixel_scale, _darken(dough, 0.12))
				"milk_tea_jelly":
					var cup := Color(0.92, 0.95, 1.0, 0.75)
					var tea := Color(0.62, 0.38, 0.24)
					var tea_hi := _lighten(tea, 0.25)
					_icon_rect_mask(image, mask, ox, oy, 5, 5, 6, 8, pixel_scale, cup)
					_icon_rect_mask(image, mask, ox, oy, 6, 7, 4, 5, pixel_scale, tea)
					_icon_rect_mask(image, mask, ox, oy, 6, 7, 1, 5, pixel_scale, tea_hi)
					_icon_rect_mask(image, mask, ox, oy, 6, 3, 1, 3, pixel_scale, Color(0.92, 0.95, 1.0, 0.9))
					_icon_rect_mask(image, mask, ox, oy, 7, 4, 1, 1, pixel_scale, Color(0.98, 0.9, 0.55))
				"coffee_jelly":
					var jelly := Color(0.22, 0.16, 0.18)
					var jelly_hi := _lighten(jelly, 0.25)
					var jelly_sh := _darken(jelly, 0.25)
					_icon_rect_mask(image, mask, ox, oy, 5, 6, 6, 6, pixel_scale, jelly)
					_icon_rect_mask(image, mask, ox, oy, 5, 6, 6, 1, pixel_scale, jelly_hi)
					_icon_rect_mask(image, mask, ox, oy, 5, 11, 6, 1, pixel_scale, jelly_sh)
					_icon_rect_mask(image, mask, ox, oy, 6, 7, 2, 4, pixel_scale, Color(1.0, 1.0, 1.0, 0.12))
				"tofu":
					var tofu := Color(0.9, 0.92, 0.94)
					var tofu_sh := _darken(tofu, 0.2)
					_icon_rect_mask(image, mask, ox, oy, 4, 7, 8, 5, pixel_scale, tofu)
					_icon_rect_mask(image, mask, ox, oy, 4, 11, 8, 1, pixel_scale, tofu_sh)
					_icon_rect_mask(image, mask, ox, oy, 5, 8, 6, 1, pixel_scale, _lighten(tofu, 0.12))
					_icon_px_mask(image, mask, ox, oy, 6, 9, pixel_scale, tofu_sh)
					_icon_px_mask(image, mask, ox, oy, 9, 10, pixel_scale, tofu_sh)
				"fried_chicken":
					var fry := Color(0.78, 0.46, 0.18)
					var fry_hi := _lighten(fry, 0.25)
					var bone := Color(0.92, 0.86, 0.78)
					_icon_rect_mask(image, mask, ox, oy, 6, 7, 6, 4, pixel_scale, fry)
					_icon_rect_mask(image, mask, ox, oy, 4, 8, 3, 2, pixel_scale, bone)
					for p in [Vector2i(7, 8), Vector2i(9, 9), Vector2i(10, 8), Vector2i(8, 10)]:
						_icon_px_mask(image, mask, ox, oy, p.x, p.y, pixel_scale, fry_hi)
				"potato_mash":
					_draw_bowl(image, mask, ox, oy, pixel_scale, Color(0.22, 0.24, 0.36), Color(0.86, 0.88, 0.96))
					var mash := Color(0.9, 0.78, 0.48)
					_icon_rect_mask(image, mask, ox, oy, 5, 7, 6, 3, pixel_scale, mash)
					_icon_px_mask(image, mask, ox, oy, 6, 7, pixel_scale, _lighten(mash, 0.25))
					_icon_px_mask(image, mask, ox, oy, 8, 8, pixel_scale, _darken(mash, 0.18))
				"oatmeal":
					_draw_bowl(image, mask, ox, oy, pixel_scale, Color(0.22, 0.24, 0.36), Color(0.86, 0.88, 0.96))
					var oat := Color(0.82, 0.68, 0.38)
					var oat_hi := _lighten(oat, 0.22)
					_icon_rect_mask(image, mask, ox, oy, 5, 7, 6, 3, pixel_scale, oat)
					for p in [Vector2i(6, 8), Vector2i(7, 7), Vector2i(9, 8), Vector2i(10, 7)]:
						_icon_px_mask(image, mask, ox, oy, p.x, p.y, pixel_scale, oat_hi)
				"hotdog":
					var sausage := Color(0.72, 0.26, 0.22)
					var bun := Color(0.9, 0.74, 0.42)
					_icon_rect_mask(image, mask, ox, oy, 4, 8, 8, 3, pixel_scale, bun)
					_icon_rect_mask(image, mask, ox, oy, 5, 8, 6, 2, pixel_scale, sausage)
					for i in range(5):
						_icon_px_mask(image, mask, ox, oy, 5 + i, 9 - (i % 2), pixel_scale, Color(0.98, 0.9, 0.55))
				"tomato":
					var red := Color(0.92, 0.22, 0.28)
					var red_hi := _lighten(red, 0.28)
					var red_sh := _darken(red, 0.22)
					_icon_rect_mask(image, mask, ox, oy, 5, 6, 6, 6, pixel_scale, red)
					_icon_rect_mask(image, mask, ox, oy, 5, 11, 6, 1, pixel_scale, red_sh)
					_icon_px_mask(image, mask, ox, oy, 6, 7, pixel_scale, red_hi)
					_icon_px_mask(image, mask, ox, oy, 8, 8, pixel_scale, red_hi)
					_icon_rect_mask(image, mask, ox, oy, 7, 5, 2, 1, pixel_scale, Color(0.22, 0.72, 0.35))
				"corn":
					var kernel := Color(0.98, 0.82, 0.22)
					var kernel_hi := _lighten(kernel, 0.25)
					var husk := Color(0.22, 0.72, 0.35)
					_icon_rect_mask(image, mask, ox, oy, 5, 6, 6, 8, pixel_scale, husk)
					_icon_rect_mask(image, mask, ox, oy, 6, 6, 4, 8, pixel_scale, kernel)
					for p in [Vector2i(6, 7), Vector2i(8, 8), Vector2i(7, 10), Vector2i(9, 11)]:
						_icon_px_mask(image, mask, ox, oy, p.x, p.y, pixel_scale, kernel_hi)
					_icon_rect_mask(image, mask, ox, oy, 6, 13, 4, 1, pixel_scale, _darken(kernel, 0.25))
				"sweet_potato":
					var sp := Color(0.86, 0.42, 0.22)
					var sp_hi := _lighten(sp, 0.22)
					var sp_sh := _darken(sp, 0.22)
					_icon_rect_mask(image, mask, ox, oy, 5, 7, 7, 5, pixel_scale, sp)
					_icon_rect_mask(image, mask, ox, oy, 5, 11, 7, 1, pixel_scale, sp_sh)
					_icon_px_mask(image, mask, ox, oy, 6, 8, pixel_scale, sp_hi)
					_icon_px_mask(image, mask, ox, oy, 8, 9, pixel_scale, sp_hi)
				"mochi":
					var m := Color(0.96, 0.72, 0.84)
					var m_hi := _lighten(m, 0.18)
					var m_sh := _darken(m, 0.18)
					_icon_rect_mask(image, mask, ox, oy, 5, 7, 7, 6, pixel_scale, m)
					_icon_rect_mask(image, mask, ox, oy, 5, 12, 7, 1, pixel_scale, m_sh)
					_icon_px_mask(image, mask, ox, oy, 6, 8, pixel_scale, m_hi)
					_icon_px_mask(image, mask, ox, oy, 9, 9, pixel_scale, m_hi)
				"rice_cake":
					var cake := Color(0.92, 0.9, 0.86)
					var cake_sh := _darken(cake, 0.18)
					var toast := Color(0.86, 0.64, 0.32)
					_icon_rect_mask(image, mask, ox, oy, 4, 8, 4, 3, pixel_scale, cake)
					_icon_rect_mask(image, mask, ox, oy, 8, 7, 4, 3, pixel_scale, cake)
					_icon_rect_mask(image, mask, ox, oy, 4, 10, 4, 1, pixel_scale, cake_sh)
					_icon_rect_mask(image, mask, ox, oy, 8, 9, 4, 1, pixel_scale, cake_sh)
					_icon_px_mask(image, mask, ox, oy, 5, 9, pixel_scale, toast)
					_icon_px_mask(image, mask, ox, oy, 10, 8, pixel_scale, toast)
				"luncheon_meat":
					var meat := Color(0.9, 0.46, 0.54)
					var meat_hi := _lighten(meat, 0.18)
					var meat_sh := _darken(meat, 0.22)
					_icon_rect_mask(image, mask, ox, oy, 5, 7, 7, 6, pixel_scale, meat)
					_icon_rect_mask(image, mask, ox, oy, 5, 7, 7, 1, pixel_scale, meat_hi)
					_icon_rect_mask(image, mask, ox, oy, 5, 12, 7, 1, pixel_scale, meat_sh)
					_icon_px_mask(image, mask, ox, oy, 6, 9, pixel_scale, meat_hi)
					_icon_px_mask(image, mask, ox, oy, 9, 10, pixel_scale, meat_sh)
				"seaweed":
					var sw := Color(0.12, 0.28, 0.18)
					var sw_hi := _lighten(sw, 0.22)
					_icon_rect_mask(image, mask, ox, oy, 5, 6, 6, 8, pixel_scale, sw)
					for i in range(4):
						_icon_px_mask(image, mask, ox, oy, 6 + i, 7 + (i % 2), pixel_scale, sw_hi)
					_icon_rect_mask(image, mask, ox, oy, 5, 13, 6, 1, pixel_scale, _darken(sw, 0.25))
				"crab_stick":
					var white2 := Color(0.94, 0.94, 0.92)
					var red2 := Color(0.9, 0.22, 0.28)
					_icon_rect_mask(image, mask, ox, oy, 4, 8, 9, 3, pixel_scale, white2)
					_icon_rect_mask(image, mask, ox, oy, 4, 8, 9, 1, pixel_scale, red2)
					_icon_rect_mask(image, mask, ox, oy, 4, 10, 9, 1, pixel_scale, _darken(white2, 0.18))
					_icon_px_mask(image, mask, ox, oy, 6, 9, pixel_scale, _lighten(white2, 0.18))
				"enoki":
					var stem := Color(0.92, 0.9, 0.86)
					var cap := Color(0.86, 0.64, 0.32)
					for x in range(6, 10):
						_icon_rect_mask(image, mask, ox, oy, x, 7, 1, 5, pixel_scale, stem)
					for x in range(6, 10):
						_icon_px_mask(image, mask, ox, oy, x, 7, pixel_scale, cap)
					_icon_rect_mask(image, mask, ox, oy, 5, 12, 6, 1, pixel_scale, _darken(stem, 0.18))
				_:
					_draw_generic_food_icon(image, mask, ox, oy, pixel_scale, id, _lighten(a, 0.08), "ingredient")
		"seasoning":
			_draw_badge(image, ox, oy, pixel_scale, Color(0.16, 0.26, 0.34))
			match id:
				"chili":
					var chili := Color(0.9, 0.18, 0.22)
					_icon_rect_mask(image, mask, ox, oy, 6, 6, 6, 4, pixel_scale, chili)
					_icon_px_mask(image, mask, ox, oy, 5, 7, pixel_scale, Color(0.22, 0.72, 0.35))
					_icon_px_mask(image, mask, ox, oy, 6, 6, pixel_scale, _lighten(chili, 0.22))
				"sugar":
					var cube := Color(0.95, 0.95, 0.94)
					var cube_hi := _lighten(cube, 0.12)
					var cube_sh := _darken(cube, 0.2)
					_icon_rect_mask(image, mask, ox, oy, 5, 6, 6, 5, pixel_scale, cube)
					_icon_rect_mask(image, mask, ox, oy, 5, 6, 6, 1, pixel_scale, cube_hi)
					_icon_rect_mask(image, mask, ox, oy, 5, 10, 6, 1, pixel_scale, cube_sh)
					_icon_px_mask(image, mask, ox, oy, 7, 8, pixel_scale, _darken(cube, 0.12))
				"mint":
					var leaf := Color(0.22, 0.78, 0.48)
					var vein := _darken(leaf, 0.25)
					_icon_rect_mask(image, mask, ox, oy, 6, 5, 4, 7, pixel_scale, leaf)
					_icon_px_mask(image, mask, ox, oy, 7, 6, pixel_scale, vein)
					_icon_px_mask(image, mask, ox, oy, 8, 8, pixel_scale, vein)
					_icon_px_mask(image, mask, ox, oy, 7, 5, pixel_scale, _lighten(leaf, 0.25))
				"cilantro":
					var herb := Color(0.2, 0.7, 0.34)
					_icon_rect_mask(image, mask, ox, oy, 5, 7, 6, 5, pixel_scale, herb)
					_icon_px_mask(image, mask, ox, oy, 6, 8, pixel_scale, _darken(herb, 0.2))
					_icon_px_mask(image, mask, ox, oy, 9, 9, pixel_scale, _darken(herb, 0.2))
					_icon_px_mask(image, mask, ox, oy, 7, 7, pixel_scale, _lighten(herb, 0.22))
				"dark_chocolate":
					var choco := Color(0.18, 0.12, 0.14)
					var choco_hi := _lighten(choco, 0.25)
					var piece := _lighten(choco, 0.12)
					_icon_rect_mask(image, mask, ox, oy, 5, 6, 6, 7, pixel_scale, choco)
					_icon_rect_mask(image, mask, ox, oy, 5, 6, 6, 1, pixel_scale, choco_hi)
					_icon_rect_mask(image, mask, ox, oy, 6, 7, 2, 2, pixel_scale, piece)
					_icon_rect_mask(image, mask, ox, oy, 8, 7, 2, 2, pixel_scale, piece)
					_icon_rect_mask(image, mask, ox, oy, 6, 10, 2, 2, pixel_scale, piece)
					_icon_rect_mask(image, mask, ox, oy, 8, 10, 2, 2, pixel_scale, piece)
				"honey":
					var jar := Color(0.92, 0.95, 1.0, 0.65)
					var honey := Color(0.95, 0.74, 0.18)
					_icon_rect_mask(image, mask, ox, oy, 5, 6, 6, 6, pixel_scale, jar)
					_icon_rect_mask(image, mask, ox, oy, 6, 8, 4, 3, pixel_scale, honey)
					_icon_rect_mask(image, mask, ox, oy, 6, 4, 4, 2, pixel_scale, _darken(honey, 0.25))
					_icon_px_mask(image, mask, ox, oy, 6, 8, pixel_scale, _lighten(honey, 0.22))
				"hotpot_base":
					var block := Color(0.3, 0.22, 0.2)
					_icon_rect_mask(image, mask, ox, oy, 4, 8, 8, 4, pixel_scale, block)
					_icon_rect_mask(image, mask, ox, oy, 4, 8, 8, 1, pixel_scale, _lighten(block, 0.18))
					_icon_px_mask(image, mask, ox, oy, 6, 9, pixel_scale, Color(0.9, 0.18, 0.22))
					_icon_px_mask(image, mask, ox, oy, 8, 10, pixel_scale, Color(0.95, 0.74, 0.18))
				"lemon":
					var peel := Color(1.0, 0.85, 0.2)
					var pulp := Color(0.98, 0.94, 0.6)
					_icon_rect_mask(image, mask, ox, oy, 5, 6, 6, 6, pixel_scale, peel)
					_icon_rect_mask(image, mask, ox, oy, 6, 7, 4, 4, pixel_scale, pulp)
					_icon_px_mask(image, mask, ox, oy, 7, 7, pixel_scale, _lighten(peel, 0.2))
					_icon_px_mask(image, mask, ox, oy, 9, 9, pixel_scale, _darken(peel, 0.2))
				_:
					_draw_generic_food_icon(image, mask, ox, oy, pixel_scale, id, _lighten(a, 0.06), "seasoning")
		"method":
			match id:
				"stir_fry":
					_icon_rect(image, ox, oy, 7, 4, 2, 9, pixel_scale, Color(1.0, 0.45, 0.18))
					_icon_rect(image, ox, oy, 6, 6, 4, 6, pixel_scale, Color(1.0, 0.78, 0.2))
					_icon_rect(image, ox, oy, 5, 8, 6, 4, pixel_scale, Color(1.0, 0.25, 0.18))
				"iced":
					_icon_rect(image, ox, oy, 7, 3, 2, 10, pixel_scale, Color(0.3, 0.85, 1.0))
					_icon_rect(image, ox, oy, 3, 7, 10, 2, pixel_scale, Color(0.3, 0.85, 1.0))
					_icon_rect(image, ox, oy, 5, 5, 6, 6, pixel_scale, Color(0.2, 0.7, 1.0))
				"slow_stew":
					_icon_rect(image, ox, oy, 4, 8, 8, 4, pixel_scale, Color(0.22, 0.24, 0.35))
					_icon_rect(image, ox, oy, 5, 7, 6, 1, pixel_scale, Color(0.92, 0.95, 1.0))
					_icon_rect(image, ox, oy, 5, 4, 2, 3, pixel_scale, Color(0.92, 0.95, 1.0, 0.6))
					_icon_rect(image, ox, oy, 9, 4, 2, 3, pixel_scale, Color(0.92, 0.95, 1.0, 0.6))
				"deep_fry":
					_icon_rect(image, ox, oy, 4, 7, 8, 5, pixel_scale, Color(0.22, 0.24, 0.35))
					_icon_rect(image, ox, oy, 5, 8, 6, 3, pixel_scale, Color(0.96, 0.82, 0.26))
					_icon_px(image, ox, oy, 6, 9, pixel_scale, Color(1.0, 0.55, 0.2))
					_icon_px(image, ox, oy, 9, 10, pixel_scale, Color(1.0, 0.55, 0.2))
				_:
					_icon_rect(image, ox, oy, 4, 4, 8, 8, pixel_scale, a)
		_:
			_icon_rect(image, ox, oy, 4, 4, 8, 8, pixel_scale, a)

	if kind == "ingredient" or kind == "seasoning" or kind == "ui" or kind == "avatar":
		_draw_shadow_from_mask(image, mask, ox, oy, pixel_scale, 1, 1, Color(0.0, 0.0, 0.0, 0.22))
		_draw_outline_from_mask(image, mask, ox, oy, pixel_scale, outline)

func _get_icon(key: String, icon_size: int, a: Color, b: Color) -> Texture2D:
	var cache_key := "%s_%d" % [key, icon_size]
	if icon_cache.has(cache_key):
		return icon_cache[cache_key] as Texture2D

	var image := Image.create(icon_size, icon_size, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	_draw_named_icon(image, key, a, b)

	image.generate_mipmaps()
	var texture := ImageTexture.create_from_image(image)
	icon_cache[cache_key] = texture
	return texture

func _clear_screen() -> void:
	timer_label = null
	playing_root = null
	coins_label = null
	order_label = null
	funds_label = null
	title_label = null
	exp_label = null
	exp_progress_bar = null
	making_progress_bar = null
	customer_avatar_rect = null
	customer_body_rect = null
	customer_request_label = null
	customer_signature_label = null
	selected_chips_box = null
	status_label = null
	economy_label = null
	cook_button = null
	pot_view = null
	ingredient_buttons.clear()
	seasoning_buttons.clear()
	method_buttons.clear()
	if is_instance_valid(pending_http_request):
		pending_http_request.queue_free()
	for child in get_children():
		remove_child(child)
		child.queue_free()
