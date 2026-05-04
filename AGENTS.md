# SICP Journey — AI 協作守則

## 專案願景

從「會用陣列與鏈表」進化到「理解語言、邏輯與抽象的本質」。
SICP 是抵達 TAPL（型別與程式語言理論）的前置路徑，不是終點。

---

## Tech Stack

| 工具 | 用途 |
|---|---|
| Racket | 主要語言（現代 Scheme 方言） |
| Zed + racket-langserver | 主力 IDE |
| DrRacket Stepper | 僅在 Ch.1 遞迴展開時用一次，之後回 Zed |
| Git | 每題一 commit，message 寫洞見 |
| Obsidian | 每節只記一件讓你意外的事 |

---

## 目錄結構

```
sicp-journey/
├── ch1-procedures/     # 程序抽象
├── ch2-data/           # 數據抽象
├── ch3-state/          # 狀態與時間
├── ch4-interpreter/    # 元循環解釋器
└── ch5-compiler/       # 寄存器機器
```

---

## Branch DAG

```
main
├── ch1/procedures      → merge when: fixed-point + newton-method 通過測試
├── ch2/data            → merge when: 通用算術系統可替換底層表示
├── ch3/state           → merge when: stream + account 實作完成
├── ch4/interpreter     → merge when: 解釋器能跑 ch1-ch3 的程式碼
└── ch5/compiler        → merge when: fibonacci 在寄存器層面可追蹤
```

---

## Commit Message 規範

寫洞見，不是操作記錄。

- 好：「遞迴與迭代的差異不在結果，在於呼叫堆疊的消耗方式」
- 差：「完成 exercise 1.9」

---

## AI 協作守則

### 四種使用模式

**中文講解模式（章節入口）**
> 「我要讀 1.1.7」

AI 用中文解釋該節核心概念，以使用者的 ML/RAG 背景做類比。使用者不需要讀英文原文，只需要跑習題的 Racket 程式碼。這是每節的預設起點。

**Socratic 模式（卡住時）**
> 「我認為 cons 是在做 X，對嗎？如果錯了，不要給我答案，給我一個問題讓我自己找出來。」

AI 的職責是讓你想得更深，不是替你想。不直接給出答案，除非你明確說「直接告訴我」。

**類比翻譯模式**
> 「用 RAG pipeline 的邏輯解釋 higher-order function。」

把 SICP 的抽象概念錨定到你已知的領域（ML pipeline、系統設計）。

**加難模式**
> 「我解了這題，幫我想一個更難的版本，但不要給我答案。」

完成習題後，往上推一階。

---

### AI 不應該做的事

- 在你卡住時直接給解法（先給一個問題）
- 幫你寫完整的習題解答（只協助 debug 已有的思路）
- 跳過 Zoom Out 直接進 Zoom In（每章開始前先問全景問題）
- 做完整筆記（只記讓你意外的洞見）

---

### 每章開始的標準流程

1. **Zoom Out：** 告訴 AI「我要開始 Ch.X」，AI 用中文說明這章的全景與承諾
2. **Zoom In：** 逐節推進——告訴 AI 節號，AI 中文講解，你跑程式碼做習題
3. **測試：** 對每個抽象寫測試，能說清楚「它在什麼情況下會壞掉」

卡住時 Zoom Out。感覺太抽象時說「用類比解釋」。不需要讀英文原文。

---

### 解釋器完成標準（最終驗收）

Ch.4 的元循環解釋器必須能跑 Ch.1–Ch.3 寫過的全部程式碼。
這一步完成，你自然會知道 TAPL 在討論什麼。
