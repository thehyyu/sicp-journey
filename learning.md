# SICP 學習地圖

## 全景：這本書在做一件事

**如何控制複雜性。**

| 階段 | 章節 | 核心問題 | 狀態 |
|---|---|---|---|
| 程序抽象 | Ch.1 | 計算的基本單位是什麼？ | 未開始 |
| 數據抽象 | Ch.2 | 如何隱藏實作，讓模組獨立？ | 未開始 |
| 狀態與時間 | Ch.3 | 引入「改變」之後，複雜性從哪裡來？ | 未開始 |
| 元語言抽象 | Ch.4 | 如何造一個語言來解決問題？ | 未開始 |
| 寄存器機器 | Ch.5 | 語言如何變成機器能執行的東西？ | 未開始 |

Ch.4 是整本書的高峰，也是讀懂 TAPL 的入口。

---

## 方法論：Zoom In / Zoom Out

每章固定循環：**Zoom Out → Zoom In → 測試**

- Zoom Out：只看標題。問「這模組對外承諾了什麼？」
- Zoom In：習題 + 小專案，跑起來才算數。
- 測試：能說清楚「它在什麼情況下會壞掉」，代表真的理解了。

---

## 階段一｜程序抽象（Ch.1）

### Zoom Out 問題

Ch.1 在說「函數是第一公民」。什麼叫第一公民？它對後面四章承諾了什麼？

### 專案任務

- [ ] 用純遞迴寫一個計算器，不使用任何 loop
- [ ] 實作 `fixed-point`，接受函數作為參數
- [ ] 實作 `newton-method`，接受函數作為參數

```racket
; 目標：這個函數的行為由傳入的 f 決定，不是硬編碼的
(define (fixed-point f first-guess)
  (define tolerance 0.00001)
  (define (close-enough? a b)
    (< (abs (- a b)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

; 驗收：能用同一個 fixed-point 求黃金比例和 sqrt(2)
(fixed-point (lambda (x) (+ 1 (/ 1 x))) 1.0)   ; → 黃金比例 ≈ 1.618
(fixed-point (lambda (x) (/ 2.0 x)) 1.0)         ; → sqrt(2) ≈ 1.414（需要 average-damp）
```

### 完成標準

能定義一個通用的「過程模式」，它的行為由傳入的函數決定，而不是硬編碼在裡面。

### 洞見記錄

> 每節讀完後在這裡記一件讓你意外的事，連結到你已知的世界。

---

## 階段二｜數據抽象（Ch.2）

### Zoom Out 問題

Ch.2 在說「數據也可以有介面」。什麼叫數據的介面？抽象屏障擋住了什麼？

### 專案任務

- [ ] 用 `cons/car/cdr` 從零實作 list
- [ ] 用 `cons/car/cdr` 從零實作 tree
- [ ] 用 `cons/car/cdr` 從零實作 queue
- [ ] 建立通用算術系統：`add-rat` 不知道底層是整數、分數還是複數

```racket
; 抽象屏障：上層只看介面
(define (make-rat n d) (cons n d))
(define (numer r) (car r))
(define (denom r) (cdr r))

; add-rat 不知道分數「長什麼樣」
(define (add-rat x y)
  (make-rat
    (+ (* (numer x) (denom y))
       (* (numer y) (denom x)))
    (* (denom x) (denom y))))
```

### 完成標準

能在不改動 `add-rat` 的情況下，換掉底層的分數表示方式。

### 洞見記錄

---

## 階段三｜狀態與時間（Ch.3）

### Zoom Out 問題

Ch.3 在說「賦值讓世界複雜了」。為什麼一個簡單的 `x = x + 1` 會破壞函數式的純粹性？

### 專案任務

- [ ] 實作有狀態的銀行帳戶系統，觀察 closure 如何封裝狀態
- [ ] 用 `delay/force` 實作無限流（Stream）
- [ ] 對比：Stream 的「惰性求值」vs 帳戶系統的「可變狀態」，兩者都在應對複雜性，但代價不同

```racket
; 賦值的代價：同樣輸入，不同輸出
(define (make-account balance)
  (define (withdraw amount)
    (if (<= amount balance)
        (begin (set! balance (- balance amount)) balance)
        "餘額不足"))
  withdraw)

(define acc (make-account 100))
(acc 30) ; → 70
(acc 30) ; → 40  ← 同樣輸入，不同輸出：你失去了「替換模型」
```

### 完成標準

能清楚說出「引入賦值之後，你失去了什麼，得到了什麼」。

### 洞見記錄

---

## 階段四｜元循環解釋器（Ch.4）⭐

### Zoom Out 問題

Ch.4 在說「eval 和 apply 是計算的心臟」。用程式碼寫一個能跑程式碼的程式，這在做什麼？

### 專案任務

- [ ] 實作完整的元循環解釋器（metacircular evaluator）
- [ ] 讓它能跑 Ch.1 的 `fixed-point` 和 `newton-method`
- [ ] 讓它能跑 Ch.2 的 `add-rat` 系統
- [ ] 讓它能跑 Ch.3 的 `make-account`

```racket
; eval 和 apply 互相呼叫，這是計算的本質結構
(define (scheme-eval expr env)
  (cond ((self-evaluating? expr) expr)
        ((symbol? expr) (env-lookup expr env))
        ((special-form? expr) (eval-special-form expr env))
        (else
         (let ((proc (scheme-eval (operator expr) env))
               (args (map (lambda (arg) (scheme-eval arg env))
                          (operands expr))))
           (scheme-apply proc args)))))

(define (scheme-apply proc args)
  (if (primitive? proc)
      (apply-primitive proc args)
      (scheme-eval (proc-body proc)
                   (extend-env (proc-params proc) args (proc-env proc)))))
```

這個解釋器用 Racket 寫，它解釋的也是 Racket/Scheme。語言在解釋它自己。

### 完成標準

你的解釋器能跑你在 Ch.1–Ch.3 寫過的全部程式。
到這一步，你自然會知道 TAPL 在討論什麼。

### 洞見記錄

---

## 階段五｜寄存器機器（Ch.5）

### Zoom Out 問題

Ch.5 在說「所有的高階抽象，最後都要跑在暫存器上」。eval/apply 要怎麼變成機器指令？

### 專案任務

- [ ] 實作簡單的寄存器機器模擬器
- [ ] 讓 Ch.4 的解釋器能在模擬器上跑
- [ ] 追蹤 fibonacci 在寄存器層面的執行過程

### 完成標準

能追蹤一個遞迴函數（如 fibonacci）在寄存器層面的執行過程，看到堆疊如何增長與收縮。

### 洞見記錄

---

## 下一步

打開 SICP Ch.1，先不讀內文，只看章節標題和小節標題。

回答這個問題再開始讀：

> **Ch.1 對外承諾了什麼？讀完它，你應該能做到什麼是現在做不到的？**

答案想清楚了，再 Zoom In 讀第一節。
