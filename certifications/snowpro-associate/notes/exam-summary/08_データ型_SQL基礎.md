# データ型と SQL 基礎

> SOL-C01 対応 | Snowflake を扱う上で最低限知っておくべき知識

---

## 1. データ型一覧

> 🔗 **検証SQL**: [`verification/08_data_types/01_numeric_string_types.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/08_data_types/01_numeric_string_types.sql), [`verification/08_data_types/02_datetime_boolean.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/08_data_types/02_datetime_boolean.sql), [`verification/08_data_types/03_semi_structured_binary.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/08_data_types/03_semi_structured_binary.sql)

### 1.1 数値型

| 型名 | 別名 | 説明 | 例 |
|------|------|------|----|
| `NUMBER(p, s)` | `DECIMAL`, `NUMERIC` | 精度 p、スケール s の固定小数点数 | `NUMBER(10,2)` → `12345678.99` |
| `INT` | `INTEGER`, `BIGINT`, `SMALLINT`, `TINYINT`, `BYTEINT` | 整数（内部的には NUMBER(38,0)） | `42` |
| `FLOAT` | `FLOAT4`, `FLOAT8`, `DOUBLE`, `REAL` | 浮動小数点数（近似値） | `3.14` |

```sql
-- 使用例
CREATE TABLE products (
  id        INT,              -- 整数
  price     NUMBER(10, 2),    -- 固定小数点（最大10桁、小数2桁）
  tax_rate  FLOAT             -- 浮動小数点
);
```

> **NUMBER vs FLOAT の使い分け**
> - **NUMBER（固定小数点）**: 金額・数量など正確な値が必要な場合
> - **FLOAT（浮動小数点）**: 科学計算・統計など近似値でよい場合

---

### 1.2 文字列型

| 型名 | 別名 | 最大長 | 説明 |
|------|------|--------|------|
| `VARCHAR(n)` | `STRING`, `TEXT`, `NVARCHAR` | 16 MB | 最もよく使う可変長文字列 |
| `CHAR(n)` | `CHARACTER`, `NCHAR` | 最大16MB | 固定長（短い場合は空白でパディング） |

```sql
-- 使用例
CREATE TABLE users (
  name     VARCHAR(100),   -- 最大100文字
  country  CHAR(2),        -- 固定2文字（例: 'JP', 'US'）
  memo     TEXT            -- 長文（VARCHAR と同じ）
);
```

> **覚え方**: Snowflake では `VARCHAR` / `STRING` / `TEXT` はすべて同じ型。試験では `VARCHAR` を基準に覚えておく。

#### Snowflakeによる型の自動変換（重要）

`CREATE TABLE` を実行すると、Snowflakeが内部的に型を変換・補完することがあります。

| 指定した型 | Snowflakeが変換する型 | 理由 |
|-----------|---------------------|------|
| `TEXT(n)` | `VARCHAR(n)` | TEXT は VARCHAR の別名 |
| `NUMBER(p)` | `NUMBER(p, 0)` | スケール（小数桁数）が自動付与される |

```sql
-- ユーザーが入力したDDL
CREATE TABLE sample (
  depth_name TEXT(7),      -- TEXT を指定
  range_min  NUMBER(2)     -- スケールなしで指定
);

-- Snowflakeが実際に作成するDDL（SHOW CREATE TABLE で確認）
CREATE TABLE sample (
  depth_name VARCHAR(7),       -- TEXT → VARCHAR に変換
  range_min  NUMBER(2, 0)      -- NUMBER(2) → NUMBER(2, 0) に補完
);
```

> **実務ポイント**: テーブル定義確認時（DDLを表示したとき）に見た目が変わっていても、意図した通りに動作しているので問題ありません。

---

### 1.3 日付・時刻型

| 型名 | 説明 | 格納される情報 | 例 |
|------|------|---------------|----|
| `DATE` | 日付のみ | 年月日 | `2026-04-03` |
| `TIME` | 時刻のみ | 時分秒・ナノ秒 | `14:30:00` |
| `TIMESTAMP_NTZ` | タイムゾーンなし | 日時のみ | `2026-04-03 14:30:00` |
| `TIMESTAMP_LTZ` | ローカルタイムゾーン | 日時＋セッションのタイムゾーン | `2026-04-03 14:30:00 +09:00` |
| `TIMESTAMP_TZ` | タイムゾーン保持 | 日時＋元のタイムゾーン情報 | `2026-04-03 05:30:00 +00:00` |
| `DATETIME` | `TIMESTAMP_NTZ` の別名 | 日時のみ | `2026-04-03 14:30:00` |

```
TIMESTAMP の種類の違い（重要！）

TIMESTAMP_NTZ（No TimeZone）:
  - タイムゾーン情報を持たない
  - 最も軽量、データウェアハウスで最もよく使う
  - 例: 2026-04-03 14:30:00

TIMESTAMP_LTZ（Local TimeZone）:
  - 保存時にUTCに変換、表示時にセッションのタイムゾーンで変換
  - 例: セッションが JST なら +09:00 で表示

TIMESTAMP_TZ（with TimeZone）:
  - 元のタイムゾーン情報をそのまま保持
  - 世界各地のシステムからのデータを混在させる場合に使用
```

```sql
-- 使用例
SELECT
  CURRENT_DATE(),           -- 今日の日付
  CURRENT_TIME(),           -- 現在時刻
  CURRENT_TIMESTAMP(),      -- 現在日時（TIMESTAMP_LTZ）
  SYSDATE();                -- 現在日時（TIMESTAMP_NTZ、UTCベース）
```

---

### 1.4 ブール型

| 型名 | 真値 | 偽値 |
|------|------|------|
| `BOOLEAN` | `TRUE`, `'true'`, `'yes'`, `'1'`, `1` | `FALSE`, `'false'`, `'no'`, `'0'`, `0` |

```sql
CREATE TABLE flags (
  is_active  BOOLEAN DEFAULT TRUE,
  is_deleted BOOLEAN DEFAULT FALSE
);

SELECT * FROM flags WHERE is_active = TRUE;
```

---

### 1.5 半構造化データ型

| 型名 | 説明 | 最大サイズ | 使用場面 |
|------|------|-----------|---------|
| `VARIANT` | JSON / XML / Avro などを格納 | **16 MB** | APIレスポンス、ログ |
| `OBJECT` | キーと値のペア（JSONオブジェクト） | 16 MB | 固定構造のJSONを明示したい場合 |
| `ARRAY` | 配列データ | 16 MB | リスト形式のデータ |

> **重要**: VARIANT 型に格納できる値は **最大 16 MB** まで。これを超えるデータは格納できません（試験頻出）。

```sql
-- VARIANT: 構造が不定のデータを格納
CREATE TABLE events (
  id         INT,
  event_data VARIANT    -- JSON をそのまま格納
);

-- OBJECT: キーバリュー形式
SELECT OBJECT_CONSTRUCT('name', '田中', 'age', 30);
-- 結果: {"age": 30, "name": "田中"}

-- ARRAY: 配列形式
SELECT ARRAY_CONSTRUCT(1, 2, 3);
-- 結果: [1, 2, 3]
```

---

### 1.6 バイナリ型

| 型名 | 別名 | 説明 |
|------|------|------|
| `BINARY(n)` | `VARBINARY` | バイナリデータ（画像・ハッシュ値など）。最大 8 MB |

---

### 1.7 データ型のまとめ早見表

```
┌──────────────────────────────────────────────────────────┐
│  数値型                                                   │
│  NUMBER / INT / FLOAT                                     │
├──────────────────────────────────────────────────────────┤
│  文字列型                                                 │
│  VARCHAR (= STRING = TEXT) / CHAR                         │
├──────────────────────────────────────────────────────────┤
│  日付・時刻型                                             │
│  DATE / TIME / TIMESTAMP_NTZ / TIMESTAMP_LTZ / TIMESTAMP_TZ│
├──────────────────────────────────────────────────────────┤
│  ブール型                                                 │
│  BOOLEAN                                                  │
├──────────────────────────────────────────────────────────┤
│  半構造化型                                               │
│  VARIANT (max 16MB) / OBJECT / ARRAY                      │
├──────────────────────────────────────────────────────────┤
│  バイナリ型                                               │
│  BINARY / VARBINARY                                       │
└──────────────────────────────────────────────────────────┘
```

---

## 2. 型変換（キャスト）

> 🔗 **検証SQL**: [`verification/08_data_types/04_cast_conversion.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/08_data_types/04_cast_conversion.sql)

### 2.1 明示的な型変換

Snowflake では 2 通りの書き方があります。

```sql
-- 方法1: CAST関数
SELECT CAST('123' AS INT);           -- 文字列→整数
SELECT CAST(42 AS VARCHAR);          -- 整数→文字列
SELECT CAST('2026-04-03' AS DATE);   -- 文字列→日付

-- 方法2: :: 記法（推奨、Snowflake独自の簡略記法）
SELECT '123'::INT;
SELECT 42::VARCHAR;
SELECT '2026-04-03'::DATE;

-- VARIANT型からの取り出し（:: での型変換が必須）
SELECT event_data:user:name::STRING FROM events;
SELECT event_data:user:age::INT     FROM events;
```

### 2.2 文字列→日付・日時への変換

```sql
-- TO_DATE: 文字列を日付に変換
SELECT TO_DATE('2026/04/03', 'YYYY/MM/DD');   -- 2026-04-03

-- TO_TIMESTAMP: 文字列を日時に変換
SELECT TO_TIMESTAMP('2026-04-03 14:30:00', 'YYYY-MM-DD HH24:MI:SS');

-- TO_NUMBER: 文字列を数値に変換
SELECT TO_NUMBER('1,234.56', '9,999.99');     -- 1234.56
```

### 2.3 暗黙的型変換

Snowflake は安全な変換であれば自動的に型変換します。

```sql
-- 文字列の '2026-04-03' は DATE 型のカラムと比較時に自動変換される
SELECT * FROM sales WHERE sale_date = '2026-04-03';
-- ↑ sale_date が DATE 型でも、文字列をそのまま書ける
```

> **注意**: 暗黙的変換に頼りすぎると意図しない動作が起きることがあります。重要な変換は明示的に行うのがベストプラクティスです。

---

## 3. 文字列関数

> 🔗 **検証SQL**: [`verification/08_data_types/05_string_functions.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/08_data_types/05_string_functions.sql)

### 3.1 よく使う文字列関数

```sql
-- 大文字・小文字変換
SELECT UPPER('hello');         -- 'HELLO'
SELECT LOWER('HELLO');         -- 'hello'

-- 空白除去
SELECT TRIM('  hello  ');      -- 'hello'
SELECT LTRIM('  hello  ');     -- 'hello  '（左側のみ）
SELECT RTRIM('  hello  ');     -- '  hello'（右側のみ）

-- 文字列の長さ
SELECT LENGTH('hello');        -- 5
SELECT LEN('hello');           -- 5（LENGTHの別名）

-- 文字列の抽出
SELECT SUBSTR('hello world', 1, 5);  -- 'hello'（1から始まる5文字）
SELECT LEFT('hello world', 5);       -- 'hello'（左から5文字）
SELECT RIGHT('hello world', 5);      -- 'world'（右から5文字）

-- 文字列の結合
SELECT CONCAT('hello', ' ', 'world');  -- 'hello world'
SELECT 'hello' || ' ' || 'world';     -- 'hello world'（|| 演算子）

-- 文字列の置換
SELECT REPLACE('hello world', 'world', 'snowflake');  -- 'hello snowflake'

-- 文字列の繰り返し
SELECT REPEAT('ab', 3);  -- 'ababab'

-- 文字列のパディング
SELECT LPAD('5', 3, '0');  -- '005'（左を0で3桁に）
SELECT RPAD('5', 3, '0');  -- '500'（右を0で3桁に）

-- 文字列の位置検索
SELECT POSITION('world' IN 'hello world');  -- 7（見つかった位置）
SELECT CHARINDEX('world', 'hello world');   -- 7（同上）

-- 文字列の分割
SELECT SPLIT_PART('a,b,c', ',', 2);  -- 'b'（2番目の要素）
```

### 3.2 パターンマッチング

```sql
-- LIKE: ワイルドカード検索（% = 任意の文字列、_ = 任意の1文字）
SELECT * FROM customers WHERE name LIKE '田%';      -- 「田」で始まる
SELECT * FROM customers WHERE name LIKE '%田%';     -- 「田」を含む
SELECT * FROM customers WHERE code LIKE 'A__';     -- 'A'の後に任意の2文字

-- ILIKE: 大文字・小文字を区別しないLIKE
SELECT * FROM products WHERE name ILIKE '%apple%';

-- REGEXP_LIKE / RLIKE: 正規表現マッチング
SELECT * FROM logs WHERE REGEXP_LIKE(message, '^ERROR.*');
```

---

## 4. 日付・時刻関数

> 🔗 **検証SQL**: [`verification/08_data_types/06_datetime_functions.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/08_data_types/06_datetime_functions.sql)

### 4.1 現在日時の取得

```sql
SELECT CURRENT_DATE();      -- 今日の日付（例: 2026-04-03）
SELECT CURRENT_TIME();      -- 現在時刻（例: 14:30:00）
SELECT CURRENT_TIMESTAMP(); -- 現在日時（タイムゾーン付き）
SELECT SYSDATE();           -- 現在日時（UTC、TIMESTAMP_NTZ）
SELECT GETDATE();           -- SYSDATE の別名
```

### 4.2 日付の加減算

```sql
-- DATEADD: 日付に期間を加算
SELECT DATEADD(day, 7, '2026-04-03');     -- 2026-04-10（7日後）
SELECT DATEADD(month, -1, '2026-04-03'); -- 2026-03-03（1ヶ月前）
SELECT DATEADD(year, 1, '2026-04-03');   -- 2027-04-03（1年後）

-- 省略形
SELECT '2026-04-03'::DATE + 7;           -- 2026-04-10（日付 + 日数）

-- DATEDIFF: 2つの日付の差
SELECT DATEDIFF(day, '2026-01-01', '2026-04-03');    -- 92（日数の差）
SELECT DATEDIFF(month, '2026-01-01', '2026-04-03');  -- 3（月数の差）
```

### 4.3 日付の切り捨て・抽出

```sql
-- DATE_TRUNC: 指定した単位以下を切り捨て
SELECT DATE_TRUNC('month', '2026-04-15');  -- 2026-04-01（月初め）
SELECT DATE_TRUNC('year',  '2026-04-15');  -- 2026-01-01（年初め）
SELECT DATE_TRUNC('week',  '2026-04-15');  -- 2026-04-13（週初め・月曜）

-- EXTRACT / DATE_PART: 日付から特定の部分を抽出
SELECT EXTRACT(year  FROM '2026-04-03'::DATE);   -- 2026
SELECT EXTRACT(month FROM '2026-04-03'::DATE);   -- 4
SELECT EXTRACT(day   FROM '2026-04-03'::DATE);   -- 3

-- YEAR / MONTH / DAY 関数（省略形）
SELECT YEAR('2026-04-03'::DATE);    -- 2026
SELECT MONTH('2026-04-03'::DATE);   -- 4
SELECT DAY('2026-04-03'::DATE);     -- 3
```

---

## 5. 条件関数（NULL / 条件分岐）

> 🔗 **検証SQL**: [`verification/08_data_types/07_null_conditional.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/08_data_types/07_null_conditional.sql)

### 5.1 NULLを扱う関数

| 関数 | 説明 | 例 |
|------|------|----|
| `NVL(a, b)` | a が NULL なら b を返す | `NVL(score, 0)` |
| `COALESCE(a, b, c, ...)` | 最初の NULL でない値を返す | `COALESCE(phone, email, 'N/A')` |
| `NULLIF(a, b)` | a = b のとき NULL を返す（ゼロ除算防止等） | `NULLIF(quantity, 0)` |
| `IS NULL` | NULL かどうかの判定 | `WHERE col IS NULL` |
| `IS NOT NULL` | NULL でないかの判定 | `WHERE col IS NOT NULL` |
| `IFNULL(a, b)` | `NVL` の別名 | `IFNULL(score, 0)` |
| `ZEROIFNULL(a)` | NULL を 0 に変換 | `ZEROIFNULL(amount)` |
| `NULLIFZERO(a)` | 0 を NULL に変換 | `NULLIFZERO(qty)` |

```sql
-- NVL の使用例：点数が NULL の場合は 0 として扱う
SELECT name, NVL(score, 0) AS score FROM students;

-- COALESCE の使用例：優先順位付きのフォールバック
SELECT COALESCE(mobile_phone, home_phone, work_phone, 'なし') AS contact
FROM customers;

-- NULLIF の使用例：ゼロ除算を防ぐ
SELECT sales / NULLIF(quantity, 0) AS unit_price FROM orders;
-- quantity が 0 の場合、NULLIF が NULL を返すので 0 除算エラーにならない
```

### 5.2 条件分岐

```sql
-- IFF: 簡易的な IF 文（Snowflake 独自）
SELECT IFF(score >= 60, '合格', '不合格') AS result FROM students;
-- score >= 60 なら '合格'、そうでなければ '不合格'

-- CASE: 複雑な条件分岐
SELECT
  name,
  CASE
    WHEN score >= 90 THEN 'A'
    WHEN score >= 70 THEN 'B'
    WHEN score >= 60 THEN 'C'
    ELSE             'D'
  END AS grade
FROM students;

-- CASE（値比較形式）
SELECT
  CASE status
    WHEN 1 THEN 'アクティブ'
    WHEN 0 THEN '無効'
    ELSE        '不明'
  END AS status_label
FROM users;

-- DECODE: CASE の簡易版（Oracle互換）
SELECT DECODE(status, 1, 'アクティブ', 0, '無効', '不明') FROM users;
```

---

## 6. 集計関数とウィンドウ関数

> 🔗 **検証SQL**: [`verification/08_data_types/08_aggregate_window.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/08_data_types/08_aggregate_window.sql)

### 6.1 集計関数

```sql
-- 基本的な集計関数
SELECT
  COUNT(*)           AS 行数,           -- NULL を含む全行数
  COUNT(score)       AS 非NULL行数,     -- NULL を除いた行数
  COUNT(DISTINCT id) AS ユニーク数,
  SUM(amount)        AS 合計,
  AVG(score)         AS 平均,
  MAX(score)         AS 最大,
  MIN(score)         AS 最小,
  MEDIAN(score)      AS 中央値,
  STDDEV(score)      AS 標準偏差
FROM sales;

-- GROUP BY との組み合わせ
SELECT
  region,
  COUNT(*) AS cnt,
  SUM(amount) AS total
FROM sales
GROUP BY region
HAVING SUM(amount) > 10000;  -- 集計後の条件は HAVING を使う
```

### 6.2 ウィンドウ関数（分析関数）

ウィンドウ関数は、**グループ全体を集約せずに**各行に対して計算を行う関数です。

```sql
-- OVER() 句でウィンドウを定義する
SELECT
  name,
  region,
  amount,
  SUM(amount) OVER (PARTITION BY region) AS region_total,  -- 地域別合計
  AVG(amount) OVER (PARTITION BY region) AS region_avg,    -- 地域別平均
  RANK()       OVER (ORDER BY amount DESC) AS rank,        -- 金額ランキング
  ROW_NUMBER() OVER (ORDER BY amount DESC) AS row_num      -- 連番（同値でも異なる）
FROM sales;
```

> **RANK vs ROW_NUMBER vs DENSE_RANK の違い:**
>
> | 関数 | 同値の場合 | 次の順位 | 例（同値が2つ） |
> |------|-----------|---------|----------------|
> | `RANK()` | 同じ順位 | 飛ばす | 1, 2, 2, **4** |
> | `DENSE_RANK()` | 同じ順位 | 飛ばさない | 1, 2, 2, **3** |
> | `ROW_NUMBER()` | 異なる順位 | 連番 | 1, 2, 3, 4 |

```sql
-- LAG / LEAD: 前後の行の値を参照
SELECT
  date,
  amount,
  LAG(amount)  OVER (ORDER BY date) AS prev_amount,  -- 1行前の値
  LEAD(amount) OVER (ORDER BY date) AS next_amount   -- 1行後の値
FROM sales;

-- 累積合計（ROWS BETWEEN）
SELECT
  date,
  amount,
  SUM(amount) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
    AS cumulative_sum
FROM sales;
```

---

## 7. Snowflake 固有の SQL 機能

> 🔗 **検証SQL**: [`verification/08_data_types/09_snowflake_sql_features.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/08_data_types/09_snowflake_sql_features.sql)

### 7.1 QUALIFY 句

`HAVING` がGROUP BYの集計結果をフィルタするように、`QUALIFY` はウィンドウ関数の結果をフィルタします。サブクエリなしに書けるため可読性が高いです。

```sql
-- 各地域で売上ランキング1位のレコードだけを取得
SELECT
  region,
  name,
  amount,
  RANK() OVER (PARTITION BY region ORDER BY amount DESC) AS rank
FROM sales
QUALIFY rank = 1;  -- ウィンドウ関数の結果でフィルタ

-- QUALIFY なしで同じことをするには サブクエリが必要（可読性↓）
SELECT * FROM (
  SELECT region, name, amount,
         RANK() OVER (PARTITION BY region ORDER BY amount DESC) AS rank
  FROM sales
) WHERE rank = 1;
```

### 7.2 SAMPLE（サンプリング）

テーブルから一部のデータをランダムに取得します。大規模テーブルの確認やテストに便利。

```sql
-- 行数を指定（BERNOULLI 方式）
SELECT * FROM large_table SAMPLE (100 ROWS);

-- 割合を指定（約10%をサンプリング）
SELECT * FROM large_table SAMPLE (10);       -- 10%
SELECT * FROM large_table TABLESAMPLE (10);  -- 同上

-- ブロックサンプリング（SYSTEM 方式、より高速）
SELECT * FROM large_table SAMPLE SYSTEM (10);
```

### 7.3 LIMIT / TOP

```sql
-- LIMIT: 上位 N 件を返す
SELECT * FROM sales ORDER BY amount DESC LIMIT 10;

-- OFFSET: n 件スキップしてから取得（ページング）
SELECT * FROM sales ORDER BY id LIMIT 10 OFFSET 20;  -- 21〜30件目

-- TOP: LIMIT の別名（SQL Server 互換）
SELECT TOP 10 * FROM sales ORDER BY amount DESC;

-- 注意: ORDER BY なしの LIMIT は順番が不定（非決定的）
SELECT * FROM sales LIMIT 5;  -- どの5件かは保証されない
```

### 7.4 DISTINCT と GROUP BY の違い

```sql
-- DISTINCT: 重複を排除した一覧
SELECT DISTINCT region FROM sales;

-- GROUP BY + COUNT: 重複を排除しつつ集計
SELECT region, COUNT(*) FROM sales GROUP BY region;
```

---

## 8. DML（データ操作言語）の基礎

> 🔗 **検証SQL**: [`verification/08_data_types/10_dml_ddl_basics.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/08_data_types/10_dml_ddl_basics.sql)

### 8.1 データを追加する：INSERT

テーブルに新しい行を追加します。

```sql
-- 1行を挿入
INSERT INTO root_depth
VALUES (1, 'S', 'Shallow', 'cm', 30, 45);

-- カラム名を明示して挿入（推奨）
INSERT INTO root_depth (root_depth_id, root_depth_code, root_depth_name, unit_of_measure, range_min, range_max)
VALUES (1, 'S', 'Shallow', 'cm', 30, 45);

-- 複数行を一度に挿入
INSERT INTO root_depth (root_depth_id, root_depth_code, root_depth_name, unit_of_measure, range_min, range_max)
VALUES
  (2, 'M', 'Medium', 'cm', 45, 60),
  (3, 'D', 'Deep',   'cm', 60, 90);
```

### 8.2 データを更新する：UPDATE

既存の行の値を変更します。

```sql
-- 特定の行を更新
UPDATE root_depth
SET root_depth_name = 'Very Shallow'
WHERE root_depth_id = 1;

-- 複数カラムを同時に更新
UPDATE root_depth
SET range_min = 25, range_max = 40
WHERE root_depth_code = 'S';
```

> **注意**: WHERE 句を省略すると**全行が更新**されます。必ず条件を確認してから実行してください。

### 8.3 データを削除する：DELETE / TRUNCATE

| コマンド | 削除範囲 | WHERE句 | ロールバック | 処理速度 |
|---------|---------|---------|------------|---------|
| `DELETE` | 条件に合う行 | 使用可能 | 可能（トランザクション内） | 遅い（行単位） |
| `TRUNCATE` | **全行** | 使用不可 | 不可（DDL扱い） | 速い |

```sql
-- 特定の行を削除
DELETE FROM root_depth
WHERE root_depth_id = 3;

-- 全行を削除（テーブル構造は残す）
TRUNCATE TABLE root_depth;
```

> **使い分け**: 一部の行だけ消したい → `DELETE`。テーブルを空にしてやり直したい → `TRUNCATE`（速くてコストが低い）。

### 8.4 SELECT * と LIMIT

`SELECT *` は全カラムを取得するショートカットです。大量データを扱う際は `LIMIT` で行数を制限しましょう。

```sql
-- 全カラム・全行を取得（小さいテーブルや確認用）
SELECT * FROM root_depth;

-- 全カラム・上位1行のみ
SELECT * FROM root_depth LIMIT 1;

-- 特定カラムのみ取得（本番クエリでは推奨）
SELECT root_depth_name, range_min, range_max FROM root_depth;
```

> **コスト意識**: `SELECT *` は全カラムを読み込みます。Warehouseのクレジットを節約するため、必要なカラムだけを指定するのがベストプラクティスです。

### 8.5 CREATE TABLE と CREATE OR REPLACE TABLE

```sql
-- テーブルを新規作成（既存の場合はエラー）
CREATE TABLE root_depth (
  root_depth_id   NUMBER(1),
  root_depth_code TEXT(1),
  root_depth_name TEXT(7),
  unit_of_measure TEXT(2),
  range_min       NUMBER(2),
  range_max       NUMBER(2)
);

-- テーブルを作成（既存の場合は上書き・データも全削除）
CREATE OR REPLACE TABLE root_depth (
  root_depth_id   NUMBER(1),
  root_depth_code TEXT(1),
  root_depth_name TEXT(7),
  unit_of_measure TEXT(2),
  range_min       NUMBER(2),
  range_max       NUMBER(2)
);
```

> **注意**: `CREATE OR REPLACE` は既存テーブルのデータを**全て削除**して再作成します。本番環境では慎重に使用してください。

---

## 9. INFORMATION_SCHEMA と ACCOUNT_USAGE

> 🔗 **検証SQL**: [`verification/08_data_types/11_metadata_sequence_model.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/08_data_types/11_metadata_sequence_model.sql)

### 9.1 INFORMATION_SCHEMA とは

各データベース内に自動で存在するメタデータビューの集合体です。**テーブル定義・実行履歴・ロード履歴**などを確認できます。

```
データベース名.INFORMATION_SCHEMA.ビュー名
```

> **特徴**: データベース作成時に自動で作成され、**削除・名前変更・移動が不可**なシステムスキーマです。

### 9.2 よく使う INFORMATION_SCHEMA ビュー

```sql
-- テーブル一覧（スキーマ・行数・サイズ等）
SELECT TABLE_NAME, TABLE_TYPE, ROW_COUNT, BYTES
FROM my_db.INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'PUBLIC';

-- カラム定義（テーブルの構造確認）
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM my_db.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'CUSTOMERS'
ORDER BY ORDINAL_POSITION;

-- クエリ実行履歴（直近15日間・当ユーザーのみ）
SELECT QUERY_TEXT, EXECUTION_TIME, ROWS_PRODUCED, CREDITS_USED_CLOUD_SERVICES
FROM my_db.INFORMATION_SCHEMA.QUERY_HISTORY()
WHERE START_TIME >= DATEADD(day, -1, CURRENT_TIMESTAMP())
ORDER BY START_TIME DESC;

-- COPY INTO のロード履歴
SELECT FILE_NAME, STATUS, ROWS_LOADED, ERRORS_SEEN, FIRST_ERROR
FROM TABLE(my_db.INFORMATION_SCHEMA.COPY_HISTORY(
  TABLE_NAME => 'SALES',
  START_TIME => DATEADD(hours, -24, CURRENT_TIMESTAMP())
));
```

### 9.3 ACCOUNT_USAGE（全アカウント範囲）

`INFORMATION_SCHEMA` はデータベース内のみですが、`ACCOUNT_USAGE` はアカウント全体の情報を保持します。

```
SNOWFLAKE.ACCOUNT_USAGE.ビュー名
```

| ビュー | 内容 | 保持期間 |
|--------|------|---------|
| `QUERY_HISTORY` | 全ユーザーのクエリ履歴 | **1年** |
| `LOGIN_HISTORY` | ログイン履歴 | 1年 |
| `WAREHOUSE_METERING_HISTORY` | Warehouse 使用量・コスト | 1年 |
| `STORAGE_USAGE` | ストレージ使用量 | 1年 |
| `ACCESS_HISTORY` | オブジェクトへのアクセス履歴 | 1年 |
| `TABLES` | 全テーブル情報 | 1年 |

```sql
-- 過去7日間の全ユーザーのクエリを確認（ACCOUNTADMIN 権限が必要）
SELECT USER_NAME, QUERY_TEXT, EXECUTION_TIME, START_TIME
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE START_TIME >= DATEADD(day, -7, CURRENT_TIMESTAMP())
ORDER BY START_TIME DESC
LIMIT 100;

-- Warehouse 別のクレジット消費
SELECT WAREHOUSE_NAME, SUM(CREDITS_USED) AS total_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
WHERE START_TIME >= DATEADD(month, -1, CURRENT_TIMESTAMP())
GROUP BY WAREHOUSE_NAME
ORDER BY total_credits DESC;
```

> **INFORMATION_SCHEMA vs ACCOUNT_USAGE の比較**
>
> | 項目 | INFORMATION_SCHEMA | ACCOUNT_USAGE |
> |------|-------------------|---------------|
> | 範囲 | 1データベース内 | アカウント全体 |
> | データの鮮度 | リアルタイム | 最大 45〜120 分の遅延 |
> | クエリ履歴の保持期間 | **15日** | **1年** |
> | 必要な権限 | 一般ユーザーで参照可 | 要 `IMPORTED PRIVILEGES` または ACCOUNTADMIN |

---

## 10. DDL 基礎（テーブル・ビュー操作）

> 🔗 **検証SQL**: [`verification/08_data_types/10_dml_ddl_basics.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/08_data_types/10_dml_ddl_basics.sql)

### 10.1 テーブルの作成・変更・削除

```sql
-- テーブル作成
CREATE TABLE customers (
  id         INT          NOT NULL,
  name       VARCHAR(100) NOT NULL,
  email      VARCHAR(200),
  created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
  is_active  BOOLEAN      DEFAULT TRUE,
  PRIMARY KEY (id)
);

-- カラム追加
ALTER TABLE customers ADD COLUMN phone VARCHAR(20);

-- カラムの型変更
ALTER TABLE customers ALTER COLUMN email SET DATA TYPE VARCHAR(500);

-- カラム名変更
ALTER TABLE customers RENAME COLUMN phone TO mobile_phone;

-- カラム削除
ALTER TABLE customers DROP COLUMN mobile_phone;

-- テーブル名変更
ALTER TABLE customers RENAME TO clients;

-- テーブルの内容を全削除（構造は残す）
TRUNCATE TABLE clients;

-- テーブル削除
DROP TABLE clients;

-- 削除したテーブルを復元（Time Travel 内）
UNDROP TABLE clients;
```

### 10.2 ビューの作成

```sql
-- 通常ビュー（クエリを保存）
CREATE VIEW active_customers AS
  SELECT * FROM customers WHERE is_active = TRUE;

-- セキュアビュー（他ユーザーに定義を隠す）
CREATE SECURE VIEW sensitive_view AS
  SELECT id, name FROM customers;
-- ※ データ共有（Secure Data Sharing）に使うビューは SECURE が必要

-- マテリアライズドビュー（クエリ結果を物理的に保存）
CREATE MATERIALIZED VIEW mv_sales_summary AS
  SELECT region, SUM(amount) AS total
  FROM sales
  GROUP BY region;
-- ※ Enterprise Edition 以上、自動的に更新される
```

### 10.3 SHOW コマンド（オブジェクト一覧）

```sql
SHOW TABLES;                      -- テーブル一覧
SHOW TABLES IN SCHEMA my_db.public;
SHOW VIEWS;                       -- ビュー一覧
SHOW SCHEMAS;                     -- スキーマ一覧
SHOW DATABASES;                   -- データベース一覧
SHOW WAREHOUSES;                  -- Warehouse 一覧
SHOW FILE FORMATS;                -- ファイルフォーマット一覧
SHOW STAGES;                      -- ステージ一覧
SHOW ROLES;                       -- ロール一覧
SHOW GRANTS TO ROLE analyst;      -- ロールに付与された権限
SHOW GRANTS ON TABLE customers;   -- テーブルへの権限一覧

-- DESCRIBE: テーブルやビューの定義確認
DESCRIBE TABLE customers;         -- カラム定義の詳細
DESC TABLE customers;             -- 省略形

-- GET_DDL: オブジェクトの CREATE 文を取得
SELECT GET_DDL('TABLE', 'customers');
SELECT GET_DDL('VIEW',  'active_customers');
```

---

## 11. よく混乱するポイント Q&A

### Q1. VARCHAR と STRING の違いは？

**同じです。** `STRING`、`TEXT`、`NVARCHAR` はすべて `VARCHAR` の別名です。どれを使っても動作は同じ。試験では `VARCHAR` が最も多く登場します。

---

### Q2. TIMESTAMP_NTZ と TIMESTAMP_LTZ、どちらを使えばよいか？

**データウェアハウスでは `TIMESTAMP_NTZ` が推奨。**

- `TIMESTAMP_NTZ`: タイムゾーン情報なし。「2026-04-03 14:30:00」として格納・表示される
- `TIMESTAMP_LTZ`: セッションのタイムゾーン（`TIMEZONE` パラメータ）に変換して表示。ユーザーごとに見え方が変わるため、分析用途では混乱しやすい

---

### Q3. COUNT(*) と COUNT(カラム名) の違いは？

```sql
SELECT COUNT(*),        -- NULL を含む全行数
       COUNT(email)     -- NULL を除いた行数
FROM customers;
```

`COUNT(*)` は行そのものを数えるため NULL に関係なく全行数を返します。`COUNT(カラム名)` はそのカラムが NULL の行を除外します。

---

### Q4. RANK と DENSE_RANK の違いは？

```
得点: 100, 90, 90, 80

RANK():       1, 2, 2, 4  ← 2位が2人いるので次は4位（3位を飛ばす）
DENSE_RANK(): 1, 2, 2, 3  ← 2位が2人いても次は3位（飛ばさない）
ROW_NUMBER(): 1, 2, 3, 4  ← 同値でも連番（どちらが先かは不定）
```

---

### Q5. QUALIFY はいつ使うか？

ウィンドウ関数（`RANK`、`ROW_NUMBER` など）の結果でフィルタしたいときに使います。サブクエリなしに書けるため可読性が上がります。

---

## 12. シーケンスとリレーショナルデータモデル

> 🔗 **検証SQL**: [`verification/08_data_types/11_metadata_sequence_model.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/08_data_types/11_metadata_sequence_model.sql)

### 11.1 シーケンス（Sequence）とは

シーケンスは**一意のID（連番）を自動生成するカウンター機能**です。複数のテーブルに紐づく一意の識別子（UID）を重複なく割り当てるために使います。

> **なぜ必要か**: 複数ユーザーが同時にデータを挿入する場合でも、シーケンスが自動的に重複しない番号を払い出してくれます。手動でMAX(id)+1を計算するより安全・確実です。

```sql
-- シーケンスの作成（1から始まり1ずつ増加）
CREATE OR REPLACE SEQUENCE seq_author_uid
  START = 1
  INCREMENT = 1
  ORDER;  -- 順番が保証される（デフォルトはNOORDER）

-- シーケンスの現在値を確認
SELECT seq_author_uid.NEXTVAL;  -- 次の値を取得（取得するたびに増加）

-- シーケンスを使ってデータを挿入
INSERT INTO author (author_uid, first_name, last_name)
VALUES (seq_author_uid.nextval, 'Fiona', 'Macdonald');

-- 複数行の挿入（それぞれ異なるUIDが割り当てられる）
INSERT INTO author (author_uid, first_name, last_name)
VALUES
  (seq_author_uid.nextval, 'Nao', 'Watanabe'),
  (seq_author_uid.nextval, 'John', 'Smith');
```

| オプション | 説明 | デフォルト |
|-----------|------|-----------|
| `START` | 開始値 | 1 |
| `INCREMENT` | 増分 | 1 |
| `ORDER` | 番号の順序を保証 | NOORDER |

### 11.2 リレーショナルデータモデルの基礎

複数のテーブルを連携させてデータを管理する構造です。データの重複を排除し、一貫性を保つ「**正規化**」の考え方がベースになっています。

#### 主キー（PK）と外部キー（FK）

```
BOOKテーブル          AUTHORテーブル
┌──────────────┐      ┌──────────────┐
│ book_uid (PK)│      │author_uid (PK)│
│ title        │      │ first_name   │
│ ...          │      │ last_name    │
└──────────────┘      └──────────────┘
```

#### 多対多の関係と中間テーブル（Bridge Table）

「1冊の本に複数の著者がいる」「1人の著者が複数の本を書く」という多対多（N:M）の関係は、直接テーブルで表現できません。**中間テーブル（Bridge Table）** を使って解決します。

```
BOOKテーブル          BOOK_AUTHORテーブル     AUTHORテーブル
┌──────────┐          ┌────────────────┐     ┌──────────────┐
│book_uid  │◀─────────│ book_uid  (FK) │     │ author_uid   │
│title     │          │ author_uid (FK)│────▶│ first_name   │
└──────────┘          └────────────────┘     │ last_name    │
                                              └──────────────┘
                         ↑ 中間テーブル（Bridge Table）
                         両方のUIDを記録するだけのシンプルな構造
```

```sql
-- 中間テーブルの作成例
CREATE TABLE book_author (
  book_uid   NUMBER NOT NULL,
  author_uid NUMBER NOT NULL,
  PRIMARY KEY (book_uid, author_uid)  -- 複合主キー
);

-- データの挿入（本ID=1 と 著者ID=1,2 を紐づける）
INSERT INTO book_author VALUES (1, 1);  -- 本1 ↔ 著者1
INSERT INTO book_author VALUES (1, 2);  -- 本1 ↔ 著者2
```

#### JOINで複数テーブルを結合

```sql
-- 本と著者を中間テーブル経由で結合
SELECT
  b.title,
  a.first_name || ' ' || a.last_name AS author_name
FROM book b
JOIN book_author ba ON b.book_uid = ba.book_uid
JOIN author a       ON ba.author_uid = a.author_uid
ORDER BY b.title;
```

---

## 13. 地理空間型と地理空間関数

> 🔗 **検証SQL**: [`verification/08_data_types/12_geospatial_udf.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/08_data_types/12_geospatial_udf.sql)

### 13.1 GEOGRAPHY型

Snowflakeには地球上の点・線・多角形などを表現する **GEOGRAPHY型** があります。

| 型名 | 説明 |
|------|------|
| `GEOGRAPHY` | 地球の曲率を考慮した地理空間オブジェクト（WGS 84 座標系） |

```sql
-- 文字列（WKT）からGEOGRAPHYオブジェクトを作成
SELECT TO_GEOGRAPHY('POINT(-104.97 39.76)');
SELECT TO_GEOGRAPHY('LINESTRING(-104.97 39.76, -105.00 39.80)');
SELECT TO_GEOGRAPHY('POLYGON((-104.97 39.76, -105.00 39.76, -105.00 39.80, -104.97 39.80))');

-- GeoJSON文字列からも作成可能
SELECT TO_GEOGRAPHY('{"type":"Point","coordinates":[-104.97,39.76]}');
```

### 13.2 地理空間データフォーマット

| フォーマット | 形式 | 例 |
|------------|------|-----|
| **WKT（Well Known Text）** | テキスト | `POINT(-104.97 39.76)`, `LINESTRING(...)`, `POLYGON(...)` |
| **GeoJSON** | JSON | `{"type":"Point","coordinates":[-104.97,39.76]}` |

> **重要:** WKTは「**経度（Longitude）, 緯度（Latitude）**」の順（X, Y順）。一般的な地図アプリの「緯度, 経度」表記とは逆なので注意。

### 13.3 主な地理空間関数

すべて **`ST_`** プレフィックスで始まります（**S**patial **T**ype の略、業界標準の命名規約）。

| 関数 | 用途 | 出力 |
|------|------|------|
| `TO_GEOGRAPHY(wkt_or_json)` | 文字列 → GEOGRAPHYオブジェクトに変換 | GEOGRAPHY |
| `ST_MAKEPOINT(lng, lat)` | 経度・緯度の数値からポイントを作成 | GEOGRAPHY |
| `ST_DISTANCE(point_a, point_b)` | 2点間の距離（**メートル単位**） | FLOAT |
| `ST_LENGTH(linestring)` | 線の長さ（**メートル単位**） | FLOAT |
| `ST_XMIN(geog)` / `ST_XMAX(geog)` | 経度（東西）の最小/最大値 | FLOAT |
| `ST_YMIN(geog)` / `ST_YMAX(geog)` | 緯度（南北）の最小/最大値 | FLOAT |

```sql
-- 2点間の距離を計算（メートル）
SELECT ST_DISTANCE(
    ST_MAKEPOINT(-104.973, 39.765),   -- 地点A: ST_MAKEPOINT(経度, 緯度)
    ST_MAKEPOINT(-104.990, 39.750)    -- 地点B
) AS distance_meters;

-- 線の長さを計算
SELECT ST_LENGTH(
    TO_GEOGRAPHY(
        'LINESTRING(' ||
        LISTAGG(coord_pair, ',') WITHIN GROUP (ORDER BY point_id) ||
        ')'
    )
) AS trail_length_meters
FROM cherry_creek_trail
GROUP BY trail_name;
```

> **距離の単位:** Snowflakeの地理空間関数はデフォルトで**メートル**を返します。
> km変換: `÷ 1000`、マイル変換: `÷ 1609`

### 13.4 LISTAGG関数（文字列の集約）

複数行の値を区切り文字で1つの文字列に連結します。座標の列をLINESTRING形式に組み立てる際などに使います。

```sql
-- 複数の座標ペアをLINESTRING形式で結合
SELECT
    'LINESTRING(' ||
    LISTAGG(lng || ' ' || lat, ',') WITHIN GROUP (ORDER BY point_id) ||
    ')' AS my_linestring
FROM cherry_creek_trail
GROUP BY trail_name;

-- 著者名を1行にまとめる
SELECT
    book_title,
    LISTAGG(author_name, ' / ') AS all_authors
FROM book_author
GROUP BY book_title;
```

---

## 14. UDF（ユーザー定義関数）

> 🔗 **検証SQL**: [`verification/08_data_types/12_geospatial_udf.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/08_data_types/12_geospatial_udf.sql)

### 14.1 UDFとは

**UDF（User Defined Function）** は、再利用可能な処理を名前付き関数として定義する機能です。

```sql
-- 基本構文
CREATE OR REPLACE FUNCTION 関数名(引数名 型, ...)
  RETURNS 戻り値の型
  AS
  $$
    -- 関数の本体（SQL式）
  $$;
```

### 14.2 実践例：特定地点までの距離を計算するUDF

```sql
-- バージョン1: 経度・緯度を数値で受け取る
CREATE OR REPLACE FUNCTION distance_to_mc(loc_lng NUMBER(38,32), loc_lat NUMBER(38,32))
  RETURNS FLOAT
  AS
  $$
    ST_DISTANCE(
        ST_MAKEPOINT('-104.97300245114094', '39.76471253574085'),  -- 定数（固定地点）
        ST_MAKEPOINT(loc_lng, loc_lat)
    )
  $$;

-- バージョン2: GEOGRAPHYオブジェクトを受け取る（オーバーロード）
CREATE OR REPLACE FUNCTION distance_to_mc(lng_and_lat GEOGRAPHY)
  RETURNS FLOAT
  AS
  $$
    ST_DISTANCE(
        ST_MAKEPOINT('-104.97300245114094', '39.76471253574085'),
        lng_and_lat
    )
  $$;

-- 使い方（引数の型で自動的に適切なバージョンが選ばれる）
SELECT distance_to_mc(-105.00, 39.75);                     -- 数値版が使われる
SELECT distance_to_mc(ST_MAKEPOINT(-105.00, 39.75));        -- GEOGRAPHY版が使われる
SELECT name, distance_to_mc(coordinates) AS dist           -- カラムから直接（GEOGRAPHY版）
FROM competitor_locations
ORDER BY dist;
```

### 14.3 関数のオーバーロード

| 概念 | 説明 |
|------|------|
| **関数シグネチャ** | 関数名 + 引数の型の組み合わせ |
| **オーバーロード** | 同じ名前・異なる引数型で複数バージョンを定義 |

`CREATE OR REPLACE FUNCTION` で引数の型が異なれば、既存バージョンを置き換えずに**別バージョンとして共存**します。Snowflakeは呼び出し時の引数の型を見て自動的に適切なバージョンを選択します。

> **オーバーロードのメリット:** データソースによって座標の持ち方が違っても（数値カラム2つ vs GEOGRAPHYカラム1つ）、関数名を1つ覚えるだけで呼び出せます。

---

## 15. 試験対策ポイント

- [ ] 数値型（NUMBER/INT/FLOAT）の違いを説明できる
- [ ] TIMESTAMP_NTZ / TIMESTAMP_LTZ / TIMESTAMP_TZ の違いを説明できる
- [ ] VARIANT 型の最大サイズ（16 MB）を知っている
- [ ] `::` 記法で型変換できることを知っている
- [ ] TEXT → VARCHAR、NUMBER(p) → NUMBER(p,0) の自動変換を知っている
- [ ] NVL / COALESCE / NULLIF の使い分けを理解している
- [ ] IFF と CASE の使い方を知っている
- [ ] RANK / DENSE_RANK / ROW_NUMBER の違いを説明できる
- [ ] QUALIFY 句がウィンドウ関数の結果フィルタに使えることを知っている
- [ ] INFORMATION_SCHEMA と ACCOUNT_USAGE の違い（保持期間・範囲・鮮度）を説明できる
- [ ] SHOW コマンドと DESCRIBE / GET_DDL の違いを理解している
- [ ] SECURE VIEW がデータ共有に必要な理由を説明できる
- [ ] INSERT / UPDATE / DELETE / TRUNCATE の違いと使い分けを説明できる
- [ ] CREATE OR REPLACE TABLE の挙動（既存データが全削除される）を理解している
- [ ] シーケンス（SEQUENCE）の目的（一意ID自動生成）と nextval の使い方を知っている
- [ ] 多対多の関係を中間テーブル（Bridge Table）で表現できる理由を説明できる
- [ ] GEOGRAPHY型で地球上の点・線・多角形を表現できることを知っている
- [ ] WKT（Well Known Text）とGeoJSONの2つの地理空間フォーマットを区別できる
- [ ] WKTの座標順が「経度, 緯度」（X, Y順）であることを知っている
- [ ] ST_ プレフィックスがSpatial Typeの略で業界標準の命名規約であることを知っている
- [ ] ST_MAKEPOINT / ST_DISTANCE / ST_LENGTH の基本的な使い方を知っている
- [ ] Snowflakeの地理空間関数が返す距離の単位がメートルであることを知っている
- [ ] LISTAGG関数で複数行の値を1文字列に連結できることを知っている
- [ ] UDF（ユーザー定義関数）の作成構文（CREATE OR REPLACE FUNCTION）を理解している
- [ ] 関数のオーバーロード（同名・異なる引数型で複数バージョン共存）の概念を説明できる
