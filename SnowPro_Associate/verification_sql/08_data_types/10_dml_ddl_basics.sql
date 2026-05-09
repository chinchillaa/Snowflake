-- ============================================================
-- 10_dml_ddl_basics.sql
-- 対応まとめ: 08_データ型_SQL基礎.md § 8. DML / § 10. DDL 基礎
-- 目的: INSERT、UPDATE、DELETE、TRUNCATE、ALTER、VIEW を確認する
-- ============================================================

CREATE DATABASE IF NOT EXISTS sql_basics_verify_db;
USE DATABASE sql_basics_verify_db;
CREATE SCHEMA IF NOT EXISTS ddl_dml_lab;
USE SCHEMA ddl_dml_lab;

CREATE OR REPLACE TABLE inventory (
  item_id NUMBER,
  item_name STRING,
  stock NUMBER
);

INSERT INTO inventory VALUES (1, 'Keyboard', 10), (2, 'Mouse', 20);
UPDATE inventory SET stock = 15 WHERE item_id = 1;
DELETE FROM inventory WHERE item_id = 2;
INSERT INTO inventory VALUES (3, 'Monitor', 5);

SELECT * FROM inventory;

ALTER TABLE inventory ADD COLUMN updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP();
CREATE OR REPLACE VIEW inventory_v AS
SELECT item_id, item_name, stock FROM inventory;

SHOW TABLES IN SCHEMA ddl_dml_lab;
SHOW VIEWS IN SCHEMA ddl_dml_lab;

TRUNCATE TABLE inventory;
DROP DATABASE IF EXISTS sql_basics_verify_db;
