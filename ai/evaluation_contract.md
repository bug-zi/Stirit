# AI 评价输入输出与兜底约定

## Runtime Input

局内只在玩家点击出锅或 100 秒倒计时结束时调用 AI。订单不在局内生成。

玩家选择的任意合法组合都会汇总为评价 payload，再进入 AI 评价。这样即使 AI 不可用，游戏也能用本地评价生成菜名、评分和结算结果。

## FinalDish Generation

本游戏不需要提前枚举所有菜谱。最终菜品由玩家选择实时组合生成。

合法组合：

```text
2-3 个食材 + 1-2 个调料 + 1 个烹饪方式 = 1 道最终菜品
```

本地生成结构：

```json
{
  "dish_id": "dish_round_001_order_003",
  "fallback_name": "早八爆炒咖啡蛋饭",
  "ingredient_names": ["咖啡冻", "鸡蛋"],
  "seasoning_names": ["辣椒"],
  "method_name": "爆炒",
  "all_tags": ["续命", "提神", "苦", "焦虑", "清醒", "早餐", "温暖", "稳定", "治愈", "百搭", "刺激", "热烈", "重口", "上头", "冒险", "混乱"],
  "matched_desired_tags": ["早餐", "提神", "刺激"],
  "matched_avoid_tags": [],
  "display_icon_keys": ["ingredient_coffee_jelly", "ingredient_egg", "seasoning_chili", "method_stir_fry"]
}
```

`fallback_name` 生成规则建议：

```text
fallback_name = "{命中标签或需求关键词}{烹饪方式名}{主食材短名}"
```

示例：

- 咖啡冻 + 鸡蛋 + 辣椒 + 爆炒：`早八爆炒咖啡蛋饭`
- 土豆泥 + 鸡蛋 + 蜂蜜 + 慢炖：`雨天慢炖蜂蜜土豆泥`
- 炸鸡块 + 奶茶冻 + 香菜 + 辣椒 + 油炸：`冒险油炸怪味鸡`

展示规则：

- AI 成功时，最终展示 AI 返回的 `dish_name`。
- AI 失败时，最终展示本地 `fallback_name`。
- MVP 不需要为每一种组合准备独立图片；UI 可以展示锅/盘子通用底图 + 已选材料 icon + 烹饪方式特效。
- 如果后续要做唯一菜品图，再按高频组合或演示组合单独补资源。

```json
{
  "request_id": "round_001_order_003",
  "customer_order": {
    "id": "order_003",
    "customer_name": "阿哲",
    "role": "早八永远迟到的男生",
    "avatar_key": "student_late",
    "request": "我要一口像早八迟到冲进教室那样，慌但醒。",
    "difficulty": 2,
    "desired_tags": ["早餐", "提神", "速度", "刺激"],
    "avoid_tags": ["太慢", "犯困", "太油"],
    "boss": false
  },
  "player_selection": {
    "ingredients": [
      {
        "id": "ingredient_coffee_jelly",
        "name": "咖啡冻",
        "category": "ingredient",
        "tags": ["续命", "提神", "苦", "焦虑", "清醒"],
        "description": "把咖啡做成能咀嚼的 deadline。",
        "unlocked": true
      },
      {
        "id": "ingredient_egg",
        "name": "鸡蛋",
        "category": "ingredient",
        "tags": ["早餐", "温暖", "稳定", "治愈", "百搭"],
        "description": "朴素但可靠，像食堂阿姨最后多给的一勺。",
        "unlocked": true
      }
    ],
    "seasonings": [
      {
        "id": "seasoning_chili",
        "name": "辣椒",
        "category": "seasoning",
        "tags": ["刺激", "热烈", "重口", "上头", "冒险"],
        "description": "让人醒，也让人重新思考人生。",
        "unlocked": true
      }
    ],
    "method": {
      "id": "method_stir_fry",
      "name": "爆炒",
      "tags": ["刺激", "热烈", "混乱", "上头"],
      "description": "把所有情绪都炒到冒烟。",
      "effect_key": "hot"
    }
  },
  "system_summary": {
    "matched_desired_tags": ["早餐", "提神", "刺激"],
    "matched_avoid_tags": [],
    "all_tags": ["续命", "提神", "苦", "焦虑", "清醒", "早餐", "温暖", "稳定", "治愈", "百搭", "刺激", "热烈", "重口", "上头", "冒险", "混乱"],
    "base_scores": {
      "relevance": 78,
      "taste": 66,
      "emotion": 82,
      "risk": 54
    }
  }
}
```

## Required AI Output

AI 必须返回单个 JSON 对象，字段和类型固定：

```json
{
  "dish_name": "早八爆醒冻",
  "scores": {
    "relevance": 84,
    "taste": 58,
    "emotion": 88,
    "risk": 61
  },
  "grade": "A",
  "comment": "这道菜像边跑边醒的早餐，精神是有了，胃可能还在迟到。",
  "customer_reaction": "顾客端着碗冲向教室，边跑边说这次真醒了。"
}
```

## Validation Rules

- 顶层只能有 `dish_name`、`scores`、`grade`、`comment`、`customer_reaction`。
- `scores` 必须包含 `relevance`、`taste`、`emotion`、`risk` 四项。
- 所有分数必须是 0 到 100 的整数。
- 分数是小数时四舍五入；越界时 clamp 到 0 或 100。
- `grade` 必须是 `S`、`A`、`B`、`C`、`D`、`F`；当前实现会用游戏代码根据四维评分重新计算最终评级。
- 文本字段不能为空。
- `comment` 建议 12 到 60 个中文字。
- `customer_reaction` 建议 8 到 50 个中文字。
- JSON 解析失败、缺字段、字段类型错误，都视为失败。

## Timeout And Failure

- AI 请求超时时间：20 秒。
- 超时后立刻使用本地备用评分。
- 不重试，避免阻塞每单节奏。
- UI 可显示：`点单系统短路，启用本地评分`。

必须进入备用评分的情况：

- AI 请求超时。
- HTTP 或 SDK 调用失败。
- 返回空文本。
- 返回内容不是合法 JSON。
- JSON 缺少必填字段。
- 分数字段无法转换为数字。
- `grade` 不在允许枚举中。
- 内容包含不可展示文本，且无法本地替换。

## Unified Result

AI 成功和兜底都返回同一种结构。

```json
{
  "source": "ai",
  "dish_name": "早八爆醒冻",
  "scores": {
    "relevance": 84,
    "taste": 58,
    "emotion": 88,
    "risk": 61
  },
  "grade": "A",
  "comment": "这道菜像边跑边醒的早餐，精神是有了，胃可能还在迟到。",
  "customer_reaction": "顾客端着碗冲向教室，边跑边说这次真醒了。"
}
```

当前实现不单独暴露 `source` 枚举，而是在结果页显示来源提示：

- `小炒 AI-7 已完成评价。`
- `点单系统短路，启用本地评分。`

## Fallback Scoring

备用评分只依赖本地数据，保证无网络也能完整演示。

```text
desired_hit = matched_desired_tags 数量
avoid_hit = matched_avoid_tags 数量
desired_total = max(desired_tags 数量, 1)

relevance = clamp(round(38 + desired_hit / desired_total * 58 - avoid_hit * 9), 0, 100)
```

美味度 MVP 规则：

- 初始 taste 为 54。
- 每命中 `饱腹`、`稳定`、`基础`、`可靠`、`家常`、`温和`、`甜`、`安慰` 中任一标签，taste +5。
- 每命中 `冲击`、`争议`、`幻觉`、`重口`、`痛感`、`苦` 中任一标签，taste -4。
- `甜`、`辣/刺激`、`苦`、`清凉`、`油腻`、`重口` 中出现 4 类及以上，taste -12。

情绪命中：

```text
emotion = clamp(round(34 + desired_hit / desired_total * 48 + request_keyword_hit * 5 - avoid_hit * 5), 0, 100)
```

`request_keyword_hit` 为菜品标签直接出现在顾客需求文本中的次数。

风险值：

```text
risk = clamp(26 + difficulty * 5 + risk_tag_hit * 7 - calm_tag_hit * 3, 0, 100)
```

风险标签包括：

```json
["刺激", "风险", "痛感", "上头", "争议", "冲击", "冒险", "罪恶", "幻觉", "负担", "混乱"]
```

降风险标签包括：

```json
["稳定", "温和", "柔和", "克制", "清爽", "可靠"]
```

总分由游戏代码计算：

```text
risk_balance = 100 - abs(risk - 55)
overall = clamp(round(relevance * 0.4 + taste * 0.2 + emotion * 0.3 + risk_balance * 0.1), 0, 100)
```

等级：

```text
S >= 90
A >= 80
B >= 70
C >= 60
D >= 45
F < 45
```

兜底文案模板：

```text
dish_name = "{命中标签或需求关键词}{烹饪方式名}{主食材名}"
comment = "这道菜命中了{命中标签}，但{风险或味道短评}。"
customer_reaction = "顾客想了想，决定给这个脑回路一个机会。"
```
