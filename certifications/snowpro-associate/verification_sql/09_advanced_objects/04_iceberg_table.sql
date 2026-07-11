-- ============================================================
-- 04_iceberg_table.sql
-- 対応まとめ: 09_高度なオブジェクト_データレイク.md § 4. Apache Icebergテーブル
-- 目的: Iceberg テーブル作成と DML 例を確認する
-- 注意: 実行には External Volume が必要
-- ============================================================

CREATE DATABASE IF NOT EXISTS iceberg_verify_db
  CATALOG = 'SNOWFLAKE'
  EXTERNAL_VOLUME = 'iceberg_external_volume';

USE DATABASE iceberg_verify_db;
CREATE SCHEMA IF NOT EXISTS iceberg_lab;
USE SCHEMA iceberg_lab;

CREATE ICEBERG TABLE trail_points (
  point_id NUMBER,
  trail_name STRING,
  distance_km NUMBER(10,2)
)
BASE_LOCATION = 'trail_points';

INSERT INTO trail_points VALUES
  (1, 'Cherry Creek Trail', 1.25),
  (2, 'Cherry Creek Trail', 2.10);

UPDATE trail_points SET distance_km = 2.25 WHERE point_id = 2;
DELETE FROM trail_points WHERE point_id = 1;

SELECT * FROM trail_points;

DROP DATABASE IF EXISTS iceberg_verify_db;
