-- ============================================================
-- 07_non_loaded_data.sql
-- 対応まとめ: 03_データ管理_ロード.md § 10. 非ロードデータパターン
-- 目的: DIRECTORY() 関数と GET_PRESIGNED_URL() の動作を確認する
-- 前提: ステージにファイルが存在する場合に実行する
--       （ファイルがなければ空結果が返る）
-- ============================================================

CREATE DATABASE IF NOT EXISTS verify_nonload_db;
USE DATABASE verify_nonload_db;
CREATE SCHEMA IF NOT EXISTS public;
USE SCHEMA public;
CREATE WAREHOUSE IF NOT EXISTS verify_wh WAREHOUSE_SIZE = 'X-SMALL' AUTO_SUSPEND = 60 AUTO_RESUME = TRUE;
USE WAREHOUSE verify_wh;

-- ============================================================
-- STEP 1: ディレクトリテーブルを有効にしたステージの作成
-- DIRECTORY = (ENABLE = TRUE) が必要
-- ============================================================
CREATE STAGE IF NOT EXISTS my_dir_stage
  DIRECTORY = (ENABLE = TRUE)
  COMMENT   = 'ディレクトリテーブル対応ステージ';

-- ============================================================
-- STEP 2: ディレクトリテーブルの構造確認
-- ファイルがない場合は空テーブルが返る
-- ============================================================
SELECT * FROM DIRECTORY(@my_dir_stage);
-- 列: RELATIVE_PATH, SIZE, LAST_MODIFIED, MD5, ETAG, FILE_URL

-- ============================================================
-- STEP 3: ディレクトリテーブルのリフレッシュ
-- 外部からファイルが追加された場合に実行する
-- ============================================================
ALTER STAGE my_dir_stage REFRESH;

-- ============================================================
-- STEP 4: GET_PRESIGNED_URL で署名付き一時 URL を生成
-- ファイルが存在する場合のみ機能する
-- 有効期限デフォルト: 3600秒（1時間）
-- ============================================================
/*
SELECT
  RELATIVE_PATH,
  GET_PRESIGNED_URL(@my_dir_stage, RELATIVE_PATH)           AS url_1h,
  GET_PRESIGNED_URL(@my_dir_stage, RELATIVE_PATH, 86400)    AS url_24h  -- 24時間有効
FROM DIRECTORY(@my_dir_stage)
WHERE RELATIVE_PATH LIKE '%.jpg' OR RELATIVE_PATH LIKE '%.png';
*/

-- ============================================================
-- STEP 5: ステージ上のファイルを直接クエリするビューの作成
-- ファイルをテーブルにロードせずビュー経由でクエリする
-- ============================================================
-- まずサンプルデータを JSON ステージへロードする想定の定義例
/*
CREATE FILE FORMAT ff_json TYPE = JSON;

-- ステージ上の JSON を直接クエリするビュー（非ロード）
CREATE OR REPLACE VIEW logs_from_stage AS
SELECT
  $1:datetime_iso8601::TIMESTAMP_NTZ AS log_time,
  $1:user_event::STRING              AS user_event,
  $1:user_login::STRING              AS user_login,
  $1:ip_address::STRING              AS ip_address,
  METADATA$FILENAME                  AS source_file
FROM @my_dir_stage
  (FILE_FORMAT => ff_json);
*/

-- ============================================================
-- STEP 6: ディレクトリテーブルと通常テーブルのJOIN例
-- 商品テーブルと画像ステージを結合してカタログビューを作る
-- ============================================================
CREATE TABLE IF NOT EXISTS products (
  product_id   INT,
  product_name VARCHAR(100),
  image_file   VARCHAR(200)   -- 例: 'images/product_001.jpg'
);

INSERT INTO products VALUES
(1, 'Snowflake Hat',  'images/hat.jpg'),
(2, 'Snowflake Mug',  'images/mug.jpg');

/*
-- ディレクトリテーブルと JOIN してカタログビューを作成
CREATE OR REPLACE VIEW product_catalog AS
SELECT
  p.product_id,
  p.product_name,
  GET_PRESIGNED_URL(@my_dir_stage, d.RELATIVE_PATH) AS image_url
FROM products p
JOIN DIRECTORY(@my_dir_stage) d
  ON p.image_file = d.RELATIVE_PATH;

SELECT * FROM product_catalog;
*/

-- ============================================================
-- STEP 7: 後片付け
-- ============================================================
DROP TABLE IF EXISTS products;
DROP STAGE IF EXISTS my_dir_stage;
DROP DATABASE IF EXISTS verify_nonload_db;
DROP WAREHOUSE IF EXISTS verify_wh;
