-- ============================================================
-- 07_tagging.sql
-- 対応まとめ: 05_アクセス制御_ロール.md § 9. タグ（Object Tagging）
-- 目的: Object Tag の作成・付与・確認・マスキングポリシーとの連携を体験する
-- ============================================================

-- ============================================================
-- STEP 1: 検証用データベースの準備
-- ============================================================
CREATE DATABASE IF NOT EXISTS tag_verify_db;
USE DATABASE tag_verify_db;
CREATE SCHEMA IF NOT EXISTS tag_schema;
USE SCHEMA tag_schema;

-- ============================================================
-- STEP 2: タグの作成
-- ============================================================
CREATE TAG IF NOT EXISTS sensitivity
  ALLOWED_VALUES 'PUBLIC', 'INTERNAL', 'CONFIDENTIAL', 'RESTRICTED'
  COMMENT = 'データ機密レベルを示すタグ';

CREATE TAG IF NOT EXISTS data_owner
  COMMENT = 'データオーナー（部署）を示すタグ';

-- ============================================================
-- STEP 3: タグ一覧の確認
-- ============================================================
SHOW TAGS IN SCHEMA tag_schema;

-- ============================================================
-- STEP 4: テーブルとカラムにタグを付与
-- ============================================================
CREATE TABLE IF NOT EXISTS pii_table (
  user_id  NUMBER,
  name     VARCHAR(100),
  email    VARCHAR(200),
  zipcode  VARCHAR(10)
);

-- テーブルレベルのタグ
ALTER TABLE pii_table SET TAG sensitivity = 'CONFIDENTIAL';
ALTER TABLE pii_table SET TAG data_owner = 'Marketing';

-- カラムレベルのタグ
ALTER TABLE pii_table MODIFY COLUMN email
  SET TAG sensitivity = 'RESTRICTED';

ALTER TABLE pii_table MODIFY COLUMN name
  SET TAG sensitivity = 'CONFIDENTIAL';

-- ============================================================
-- STEP 5: タグの確認
-- ============================================================
-- テーブルのタグを確認
SELECT SYSTEM$GET_TAG('tag_schema.sensitivity', 'pii_table', 'table') AS table_sensitivity;

-- カラムのタグを確認
SELECT SYSTEM$GET_TAG('tag_schema.sensitivity', 'tag_verify_db.tag_schema.pii_table.email', 'column') AS col_sensitivity;

-- ============================================================
-- STEP 6: ACCOUNT_USAGE でタグ参照情報を確認
-- ============================================================
SELECT
  tag_name,
  tag_value,
  object_name,
  object_kind,
  column_name
FROM SNOWFLAKE.ACCOUNT_USAGE.TAG_REFERENCES
WHERE tag_database = 'TAG_VERIFY_DB'
ORDER BY object_name;

-- ============================================================
-- STEP 7: タグによるデータ分類の確認（Data Classification）
-- TAG_REFERENCES ビューで機密データ一覧を取得
-- ============================================================
SELECT
  object_name,
  column_name,
  tag_name,
  tag_value
FROM SNOWFLAKE.ACCOUNT_USAGE.TAG_REFERENCES
WHERE tag_name = 'SENSITIVITY'
  AND tag_value IN ('CONFIDENTIAL', 'RESTRICTED')
ORDER BY object_name, column_name;

-- ============================================================
-- STEP 8: タグの解除
-- ============================================================
ALTER TABLE pii_table UNSET TAG sensitivity;
ALTER TABLE pii_table MODIFY COLUMN email UNSET TAG sensitivity;

-- ============================================================
-- STEP 9: 後片付け
-- ============================================================
DROP TAG IF EXISTS sensitivity;
DROP TAG IF EXISTS data_owner;
DROP DATABASE IF EXISTS tag_verify_db;
