-- ============================================================
-- 03_copy_into.sql
-- 対応まとめ: 03_データ管理_ロード.md § 4. COPY INTO コマンド
--             および § 9. データ変換（ロード時の加工）
-- 目的: COPY INTO の各オプション・VALIDATION_MODE を体験する
-- 前提: Snowflake のサンプルデータを使った模擬ロードを行う
-- ============================================================

CREATE DATABASE IF NOT EXISTS verify_copy_db;
USE DATABASE verify_copy_db;
CREATE SCHEMA IF NOT EXISTS public;
USE SCHEMA public;
CREATE WAREHOUSE IF NOT EXISTS verify_wh WAREHOUSE_SIZE = 'X-SMALL' AUTO_SUSPEND = 60 AUTO_RESUME = TRUE;
USE WAREHOUSE verify_wh;

-- ============================================================
-- STEP 1: ロード先テーブルの作成
-- ============================================================
CREATE TABLE IF NOT EXISTS customers (
  id        NUMBER,
  name      VARCHAR(100),
  email     VARCHAR(200),
  region    VARCHAR(50)
);

-- ============================================================
-- STEP 2: ステージと File Format の準備
-- ============================================================
CREATE STAGE IF NOT EXISTS copy_stage;

CREATE FILE FORMAT csv_hdr
  TYPE            = CSV
  FIELD_DELIMITER = ','
  SKIP_HEADER     = 1;

-- ============================================================
-- STEP 3: COPY INTO の基本ロード（ステージから）
-- ※ このデモでは実ファイルがないため構文確認のみ
-- 実際にファイルをアップロードする場合は SnowSQL で PUT を使用
-- ============================================================
/*
COPY INTO customers
FROM @copy_stage
FILE_FORMAT = (FORMAT_NAME = csv_hdr);
*/

-- ============================================================
-- STEP 4: VALIDATION_MODE でエラーチェック（ロードなし）
-- ※ ファイルを @copy_stage に PUT した後に実行する
-- ============================================================
/*
COPY INTO customers
FROM @copy_stage
FILE_FORMAT = (FORMAT_NAME = csv_hdr)
VALIDATION_MODE = RETURN_ALL_ERRORS;
-- → エラー行が返される（実際のロードは行われない）
*/

-- ============================================================
-- STEP 5: ON_ERROR オプション別の動作確認
-- ============================================================
/*
-- デフォルト（ABORT_STATEMENT）: エラーで即座に中止
COPY INTO customers FROM @copy_stage FILE_FORMAT = (FORMAT_NAME = csv_hdr)
ON_ERROR = ABORT_STATEMENT;

-- CONTINUE: エラー行をスキップして続行
COPY INTO customers FROM @copy_stage FILE_FORMAT = (FORMAT_NAME = csv_hdr)
ON_ERROR = CONTINUE;

-- SKIP_FILE: エラーのあるファイルをスキップ
COPY INTO customers FROM @copy_stage FILE_FORMAT = (FORMAT_NAME = csv_hdr)
ON_ERROR = SKIP_FILE;
*/

-- ============================================================
-- STEP 6: PATTERN オプションで特定ファイルだけロード
-- ============================================================
/*
COPY INTO customers
FROM @copy_stage
PATTERN      = '.*customers.*[.]csv'   -- "customers" を含む CSV のみ
FILE_FORMAT  = (FORMAT_NAME = csv_hdr)
ON_ERROR     = CONTINUE;
*/

-- ============================================================
-- STEP 7: ロード時にデータ変換（COPY INTO + SELECT）
-- ============================================================
/*
COPY INTO customers (id, name, email, region)
FROM (
  SELECT
    $1::NUMBER,           -- 1列目を数値に変換
    UPPER($2),            -- 2列目を大文字に
    LOWER($3),            -- 3列目を小文字に
    NVL($4, 'UNKNOWN')    -- 4列目がNULLなら 'UNKNOWN'
  FROM @copy_stage
)
FILE_FORMAT = (FORMAT_NAME = csv_hdr);
*/

-- ============================================================
-- STEP 8: ロード履歴の確認
-- COPY INTO を実行した後に確認する
-- ============================================================
SELECT *
FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(
  TABLE_NAME  => 'CUSTOMERS',
  START_TIME  => DATEADD(HOURS, -24, CURRENT_TIMESTAMP())
));

-- ============================================================
-- STEP 9: COPY INTO でテーブル → ステージ（アンロード）
-- ============================================================
/*
COPY INTO @copy_stage/export/
FROM (SELECT * FROM customers WHERE region = 'APAC')
FILE_FORMAT = (TYPE = CSV HEADER = TRUE);
*/

-- ============================================================
-- STEP 10: 後片付け
-- ============================================================
DROP DATABASE IF EXISTS verify_copy_db;
DROP WAREHOUSE IF EXISTS verify_wh;
