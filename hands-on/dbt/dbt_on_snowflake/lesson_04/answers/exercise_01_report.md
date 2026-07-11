# 演習 1 模範解答: マテリアライゼーション比較

## 典型的な結果

| 項目 | table | view |
|------|-------|------|
| `dbt run` の時間 | 3〜10秒 | 0.5秒以下 |
| SELECT クエリの時間 | 0.5〜1秒 | 3〜8秒 |
| オブジェクト種別 | BASE TABLE | VIEW |

## 解説

### `dbt run` の時間
- **table が遅い**: SELECT 結果を実際にテーブルに書き込むため、I/O が発生する
- **view が速い**: `CREATE VIEW AS` は定義を保存するだけ（データ移動なし）

### SELECT クエリの時間
- **table が速い**: データが事前に計算済みで保存されている。GROUP BY は15万行の DIM_CUSTOMERS テーブルを読むだけ
- **view が速い**: クエリのたびに CUSTOMER × ORDERS × NATION の結合を再計算する（150万行の ORDERS を毎回 JOIN）

### 結論
`dim_customers` には **table** が適切。理由：
1. 150万行の ORDERS とのJOIN + GROUP BY は重い計算
2. BI ツールが頻繁にクエリする可能性が高い
3. 顧客データは頻繁に変わらないのでフルリフレッシュでも運用可能
