-- ============================================================
-- 12_geospatial_udf.sql
-- 対応まとめ: 08_データ型_SQL基礎.md § 13. 地理空間型 / § 14. UDF
-- 目的: GEOGRAPHY、LISTAGG、SQL UDF を確認する
-- ============================================================

CREATE DATABASE IF NOT EXISTS sql_basics_verify_db;
USE DATABASE sql_basics_verify_db;
CREATE SCHEMA IF NOT EXISTS geo_lab;
USE SCHEMA geo_lab;

CREATE OR REPLACE TABLE offices (
  office_name STRING,
  location GEOGRAPHY
);

INSERT INTO offices VALUES
  ('Tokyo', TO_GEOGRAPHY('POINT(139.7671 35.6812)')),
  ('Osaka', TO_GEOGRAPHY('POINT(135.5023 34.6937)')),
  ('Nagoya', TO_GEOGRAPHY('POINT(136.9066 35.1815)'));

CREATE OR REPLACE FUNCTION distance_from_tokyo(loc GEOGRAPHY)
RETURNS FLOAT
AS
$$
  ST_DISTANCE(TO_GEOGRAPHY('POINT(139.7671 35.6812)'), loc)
$$;

SELECT
  office_name,
  ST_ASWKT(location) AS wkt,
  distance_from_tokyo(location) AS meters_from_tokyo
FROM offices;

SELECT LISTAGG(office_name, ', ') WITHIN GROUP (ORDER BY office_name) AS office_list
FROM offices;

DROP DATABASE IF EXISTS sql_basics_verify_db;
