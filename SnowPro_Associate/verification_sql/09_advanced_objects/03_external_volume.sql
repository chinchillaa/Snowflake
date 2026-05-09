-- ============================================================
-- 03_external_volume.sql
-- 対応まとめ: 09_高度なオブジェクト_データレイク.md § 3. 外部ボリューム
-- 目的: Iceberg 用の External Volume 定義例を確認する
-- 注意: 実行には実在するクラウドストレージと権限が必要
-- ============================================================

-- STEP 1: External Volume 作成例
CREATE OR REPLACE EXTERNAL VOLUME iceberg_external_volume
  STORAGE_LOCATIONS = (
    (
      NAME = 'iceberg-s3-us-west-2'
      STORAGE_PROVIDER = 'S3'
      STORAGE_BASE_URL = 's3://my-iceberg-bucket/'
      STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::123456789012:role/snowflake_iceberg_role'
      STORAGE_AWS_EXTERNAL_ID = 'snowflake-iceberg-external-id'
    )
  );

SHOW EXTERNAL VOLUMES;
DESC EXTERNAL VOLUME iceberg_external_volume;

DROP EXTERNAL VOLUME IF EXISTS iceberg_external_volume;
