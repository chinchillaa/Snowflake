-- ============================================================
-- 01_stages.sql
-- 対応まとめ: 03_データ管理_ロード.md § 2. ステージ（Stage）
-- 目的: Internal Named Stage の作成・ファイル一覧・削除を体験する
-- ============================================================

-- ============================================================
-- STEP 1: 検証用データベース・スキーマを準備
-- ============================================================
CREATE DATABASE IF NOT EXISTS verify_stage_db;
USE DATABASE verify_stage_db;
CREATE SCHEMA IF NOT EXISTS public;
USE SCHEMA public;

-- ============================================================
-- STEP 2: Named Stage の作成（最もよく使うステージ）
-- ============================================================
CREATE STAGE IF NOT EXISTS my_named_stage
  COMMENT = '検証用 Named Stage';

-- ============================================================
-- STEP 3: ステージ一覧の確認
-- ============================================================
SHOW STAGES;                         -- 現在のスキーマのステージ
SHOW STAGES IN SCHEMA verify_stage_db.public;

-- ============================================================
-- STEP 4: User Stage と Table Stage のリスト確認
-- （PUT したファイルがある場合のみ内容が表示される）
-- ============================================================
LIST @~;                             -- User Stage（個人専用）
LIST @my_named_stage;                -- Named Stage

-- 存在するテーブルのTable Stageを確認
CREATE TABLE IF NOT EXISTS demo_table (id INT, name VARCHAR(50));
LIST @%demo_table;                   -- Table Stage

-- ============================================================
-- STEP 5: Named Stage の詳細設定（圧縮・暗号化）を確認
-- ============================================================
DESC STAGE my_named_stage;
-- → URL, FILE_FORMAT, COPY_OPTIONS, DIRECTORY 等の設定が確認できる

-- ============================================================
-- STEP 6: 外部ステージの作成例（S3）
-- ※実際に接続するには STORAGE_INTEGRATION が必要。
--   以下はドライラン（構文確認）用の例。
-- ============================================================
/*
CREATE STORAGE INTEGRATION s3_integration
  TYPE                      = EXTERNAL_STAGE
  STORAGE_PROVIDER          = 'S3'
  ENABLED                   = TRUE
  STORAGE_AWS_ROLE_ARN      = 'arn:aws:iam::123456789012:role/my_role'
  STORAGE_ALLOWED_LOCATIONS = ('s3://my-bucket/data/');

CREATE STAGE my_s3_stage
  URL                 = 's3://my-bucket/data/'
  STORAGE_INTEGRATION = s3_integration
  COMMENT             = '外部S3ステージ';
*/

-- ============================================================
-- STEP 7: 後片付け
-- ============================================================
DROP TABLE IF EXISTS demo_table;
DROP STAGE IF EXISTS my_named_stage;
DROP DATABASE IF EXISTS verify_stage_db;
