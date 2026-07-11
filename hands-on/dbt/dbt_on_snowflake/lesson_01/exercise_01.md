# Lesson 1 — 演習: ソースデータの探索

> **難易度**: ★☆☆ 基本  
> **目的**: SQL Worksheet で TPC-H データの構造を理解する

---

## 問題

以下の問いに SQL を書いて答えよ。

### 問 1: テーブル間の関係を調べる

`ORDERS` テーブルの `O_CUSTKEY` と `CUSTOMER` テーブルの `C_CUSTKEY` は同じ顧客を指している。
以下を確認せよ：

```sql
-- ORDERS に存在するが CUSTOMER に存在しない O_CUSTKEY はあるか？
-- （あなたの SQL をここに書く）
```

### 問 2: データの概要を把握する

TPC-H の全テーブルの行数を1つのクエリで取得せよ。  
`UNION ALL` を使い、テーブル名と行数を一覧で出力すること。

対象テーブル: ORDERS, CUSTOMER, LINEITEM, NATION, REGION, PART, SUPPLIER, PARTSUPP

### 問 3: ビジネス上の問い

「注文金額（O_TOTALPRICE）が最も高い注文 TOP 5」を、顧客名と国名付きで出力せよ。  
（JOIN を使って CUSTOMER と NATION を結合する必要がある）

---

## 検証

- 問 1: 結果が0行であれば外部キー整合性が保たれている
- 問 2: 8行の結果が返る
- 問 3: 5行、各行に顧客名と国名が含まれる

---

模範解答 → [answers/exploration_queries.sql](answers/exploration_queries.sql)
