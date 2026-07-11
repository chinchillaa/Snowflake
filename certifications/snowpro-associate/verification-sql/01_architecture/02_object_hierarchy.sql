-- ============================================================
-- 02_object_hierarchy.sql
-- 対応まとめ: 01_アーキテクチャ基礎.md § 7. オブジェクト階層
-- 目的: Database → Schema の作成・確認・削除と USE コマンドを体験する
-- ============================================================

-- ============================================================
-- STEP 1: データベースの作成
-- ============================================================
CREATE DATABASE IF NOT EXISTS verify_garden_plants;

-- ============================================================
-- STEP 2: データベース一覧の確認
-- ============================================================
SHOW DATABASES;

-- ============================================================
-- STEP 3: データベースを選択してコンテキスト設定
-- ============================================================
USE DATABASE verify_garden_plants;

-- 現在のデータベースを確認
SELECT CURRENT_DATABASE();   -- → VERIFY_GARDEN_PLANTS

-- ============================================================
-- STEP 4: 自動作成された PUBLIC スキーマを確認してから削除
-- ============================================================
SHOW SCHEMAS;                -- PUBLIC と INFORMATION_SCHEMA が見える

DROP SCHEMA IF EXISTS verify_garden_plants.public;

-- ============================================================
-- STEP 5: 複数スキーマを新規作成
-- ============================================================
CREATE SCHEMA IF NOT EXISTS verify_garden_plants.veggies;
CREATE SCHEMA IF NOT EXISTS verify_garden_plants.fruits;
CREATE SCHEMA IF NOT EXISTS verify_garden_plants.flowers;

-- 作成後の確認
SHOW SCHEMAS;

-- ============================================================
-- STEP 6: アカウント全体のスキーマ一覧（コンテキスト不要）
-- ============================================================
SHOW SCHEMAS IN ACCOUNT;

-- ============================================================
-- STEP 7: スキーマに切り替えて完全修飾名 vs 省略名を確認
-- ============================================================
USE SCHEMA verify_garden_plants.veggies;
SELECT CURRENT_SCHEMA();     -- → VEGGIES

-- 省略名でテーブル作成（完全修飾名なし）
CREATE TABLE IF NOT EXISTS test_table (id INT, name VARCHAR(50));
SHOW TABLES;                 -- VEGGIES スキーマのテーブルが表示される

-- ============================================================
-- STEP 8: スキーマのリネーム（名前タイポの修正シミュレーション）
-- ============================================================
CREATE SCHEMA IF NOT EXISTS verify_garden_plants.weggies;   -- タイポ版を作成
ALTER SCHEMA verify_garden_plants.weggies RENAME TO verify_garden_plants.herbs;
SHOW SCHEMAS;

-- ============================================================
-- STEP 9: 後片付け
-- ============================================================
DROP DATABASE IF EXISTS verify_garden_plants;
