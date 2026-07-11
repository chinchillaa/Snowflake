-- ============================================================
-- 06_semi_structured.sql
-- 対応まとめ: 03_データ管理_ロード.md § 7. 半構造化データ
-- 目的: VARIANT 型・コロン記法・FLATTEN 関数の動作を確認する
-- ============================================================

CREATE DATABASE IF NOT EXISTS verify_semi_db;
USE DATABASE verify_semi_db;
CREATE SCHEMA IF NOT EXISTS public;
USE SCHEMA public;
CREATE WAREHOUSE IF NOT EXISTS verify_wh WAREHOUSE_SIZE = 'X-SMALL' AUTO_SUSPEND = 60 AUTO_RESUME = TRUE;
USE WAREHOUSE verify_wh;

-- ============================================================
-- STEP 1: VARIANT テーブルの作成とデータ挿入
-- ============================================================
CREATE TABLE events (
  id         INT,
  event_data VARIANT
);

INSERT INTO events VALUES
(1, PARSE_JSON('{"user": {"name": "田中", "age": 30}, "action": "login",  "items": [{"product": "A", "qty": 2}, {"product": "B", "qty": 1}]}')),
(2, PARSE_JSON('{"user": {"name": "佐藤", "age": 25}, "action": "purchase","items": [{"product": "C", "qty": 5}]}')),
(3, PARSE_JSON('{"user": {"name": "山田", "age": 40}, "action": "logout",  "items": []}'));

-- ============================================================
-- STEP 2: コロン記法でネスト要素にアクセス
-- ============================================================
SELECT
  id,
  event_data:user:name::STRING      AS user_name,
  event_data:user:age::INT          AS user_age,
  event_data:action::STRING         AS action
FROM events;

-- ============================================================
-- STEP 3: ブラケット記法（同じ結果）
-- ============================================================
SELECT
  id,
  event_data['user']['name']::STRING AS user_name
FROM events;

-- ============================================================
-- STEP 4: 配列要素へのインデックスアクセス
-- ============================================================
SELECT
  id,
  event_data:items[0]:product::STRING AS first_product,
  event_data:items[0]:qty::INT        AS first_qty
FROM events;

-- ============================================================
-- STEP 5: LATERAL FLATTEN で配列を行に展開
-- ============================================================
SELECT
  e.id,
  e.event_data:user:name::STRING AS user_name,
  f.value:product::STRING        AS product,
  f.value:qty::INT               AS qty
FROM events e,
LATERAL FLATTEN(input => e.event_data:items) f;
-- 結果: id=1 が 2行（A,B）、id=2 が 1行（C）、id=3 は items が空なので 0行

-- ============================================================
-- STEP 6: FLATTEN が返す全カラムを確認（SEQ/INDEX/KEY/VALUE/PATH/THIS）
-- ============================================================
SELECT
  f.SEQ,
  f.INDEX,
  f.KEY,
  f.PATH,
  f.VALUE,
  f.THIS
FROM events e,
LATERAL FLATTEN(input => e.event_data:items) f
WHERE e.id = 1;

-- ============================================================
-- STEP 7: OBJECT 型のフラット展開（キーが動的な場合）
-- ============================================================
CREATE TABLE configs (config VARIANT);
INSERT INTO configs VALUES
(PARSE_JSON('{"host": "localhost", "port": 5432, "db": "snowflake"}'));

SELECT f.KEY, f.VALUE
FROM configs,
LATERAL FLATTEN(input => config) f;
-- KEY列に host/port/db、VALUE列に各値が展開される

-- ============================================================
-- STEP 8: VARIANT の 16 MB 制限を確認（概念確認）
-- ============================================================
-- SELECT LENGTH(TO_JSON(event_data)) AS bytes FROM events;
-- → VARIANT 1セルが 16 MB を超えるとエラーになる

-- ============================================================
-- STEP 9: 後片付け
-- ============================================================
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS configs;
DROP DATABASE IF EXISTS verify_semi_db;
DROP WAREHOUSE IF EXISTS verify_wh;
