-- ============================================================
-- 05_テーブル_vegetable_details.sql
-- Snowflake DWW Badge 1 - VEGETABLE_DETAILS テーブルの作成と操作
-- ============================================================
-- 【概要】
-- Uncle Yer の野菜データを格納するテーブル。
-- CSVファイルからデータをロードする（Load Wizard または COPY INTO）。
--
-- テーブル設計：
--   plant_name     : 植物名（最大25文字）
--   root_depth_code: 根の深さコード（S/M/D の1文字）
--                    ROOT_DEPTH テーブルと結合することで詳細を参照できる
--
-- データ投入方法（3種類）：
--   1. INSERT 文（ワークシートから手動入力）
--   2. Load Wizard（UI からファイルを選択）← このレッスンで使用
--   3. COPY INTO（ステージから一括ロード）← Lesson 9 で使用
-- ============================================================


-- ============================================================
-- 1. コンテキスト設定
-- ============================================================

use role sysadmin;
use database GARDEN_PLANTS;
use schema VEGGIES;
use warehouse COMPUTE_WH;


-- ============================================================
-- 2. VEGETABLE_DETAILS テーブルの作成
-- ============================================================
-- 【目的】野菜の名前と根の深さコードを格納するテーブルを作成する
-- 【動作】garden_plants.veggies スキーマ内に作成される
-- 【補足】完全修飾名（DB.スキーマ.テーブル名）で指定しているため、
-- 　　　  コンテキスト設定がなくても動作する

create table garden_plants.veggies.vegetable_details
(
  plant_name      varchar(25)  -- 植物名（最大25文字）
, root_depth_code varchar(1)   -- 根の深さコード（S/M/D）
);


-- ============================================================
-- 3. データ確認（ロード後）
-- ============================================================
-- 【目的】Load Wizard または COPY INTO でデータをロードした後に確認する
-- 【期待値】42行（ファイルA〜K: 21行 + ファイルK〜Z: 21行）
-- 　　　　  ただし Spinach の重複行を削除後は 41行

SELECT * FROM GARDEN_PLANTS.VEGGIES.VEGETABLE_DETAILS;

-- 行数確認
SELECT count(*) FROM GARDEN_PLANTS.VEGGIES.VEGETABLE_DETAILS;


-- ============================================================
-- 4. 重複行の削除（Spinach の D コードを削除）
-- ============================================================
-- 【目的】Spinach が2行あるため、誤データ（根が深い）を削除する
-- 　　　  Spinach は浅根（S）のみ正しい
-- 【動作】WHERE 句で plant_name と root_depth_code 両方を指定して
-- 　　　  対象行を特定してから削除

-- まず削除対象行を SELECT で確認
SELECT *
FROM GARDEN_PLANTS.VEGGIES.VEGETABLE_DETAILS
WHERE plant_name = 'Spinach'
  AND root_depth_code = 'D';

-- 確認後に削除
DELETE FROM GARDEN_PLANTS.VEGGIES.VEGETABLE_DETAILS
WHERE plant_name = 'Spinach'
  AND root_depth_code = 'D';


-- ============================================================
-- 5. テーブルをリセット（やり直し時）
-- ============================================================
-- 【目的】同じファイルを誤って二重ロードした場合などにリセットする
-- 【動作】TRUNCATE はテーブル構造を保持したまま全データを削除する

TRUNCATE TABLE GARDEN_PLANTS.VEGGIES.VEGETABLE_DETAILS;

-- TRUNCATEした後は Load Wizard または COPY INTO でロードし直す
