# 演習 2 模範解答: incremental ロジック変更

## 典型的な結果

| フェーズ | net_price (order_id=1, line_number=1) | 変化した？ |
|---------|--------------------------------------|-----------|
| A (変更前) | 例: 23,014.57 | - |
| C (refresh なし) | 例: 23,014.57 (同じ) | **No** |
| D (refresh あり) | 例: 21,168.23 (変化) | **Yes** |

## 解説

### Phase C で値が変わらない理由

incremental モデルの2回目以降の実行では `is_incremental() = TRUE` となり、WHERE 句が有効になる：

```sql
WHERE li.ship_date > (SELECT MAX(ship_date) FROM {{ this }})
```

既に全データがテーブルに入っているため、MAX(ship_date) 以降の新しいデータがない = **0行が処理される**。

つまり、既存の行は一切更新されず、古い計算ロジックで作られたデータがそのまま残る。

### Phase D で値が変わる理由

`--full-refresh` を指定すると：
1. 既存テーブルを **DROP**
2. `is_incremental() = FALSE` として実行 → WHERE 句なしで全データを SELECT
3. **新しい計算ロジック**で CREATE TABLE AS SELECT

これにより全行が新しいロジック（tax 除外）で再計算される。

### --full-refresh を忘れるとどうなるか

- テーブル内に **新旧2つのロジックで計算された値が混在** する
- 新しく追加された行は新ロジック、既存行は旧ロジック
- 集計結果が不正確になるが、エラーは出ないため **気づきにくい**
- これが incremental モデルで最も危険なバグの一つ

### ルール

> **incremental モデルの SELECT 句（カラム定義・計算ロジック）を変更したら、必ず `--full-refresh` を実行する。**
