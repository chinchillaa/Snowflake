-- ============================================================
-- 09_テーブル_soil_type.sql
-- Snowflake DWW Badge 1 - 土壌タイプ関連テーブルの作成
-- ============================================================
-- 【概要】
-- COPY INTO のロード先として使う2つのテーブル。
-- どちらも GARDEN_PLANTS.VEGGIES スキーマに作成する。
--
--   VEGETABLE_DETAILS_SOIL_TYPE : 野菜名と土壌タイプIDの対応表
--   LU_SOIL_TYPE                : 土壌タイプのルックアップテーブル（LU = Look Up）
-- ============================================================


-- ============================================================
-- 1. コンテキスト設定
-- ============================================================

use role sysadmin;
use database GARDEN_PLANTS;
use schema VEGGIES;
use warehouse COMPUTE_WH;


-- ============================================================
-- 2. VEGETABLE_DETAILS_SOIL_TYPE テーブルの作成
-- ============================================================
-- 【目的】野菜名と土壌タイプIDを対応付けるテーブル
-- 【ロード元】VEG_NAME_TO_SOIL_TYPE_PIPE.txt（パイプ区切り）
-- 【期待行数】42行（DORA DWW11 で確認）

create or replace table vegetable_details_soil_type
(
  plant_name varchar(25)  -- 野菜名
 ,soil_type  number(1,0)  -- 土壌タイプID（1桁の整数、小数なし）
);


-- ============================================================
-- 3. LU_SOIL_TYPE テーブルの作成（ルックアップテーブル）
-- ============================================================
-- 【目的】土壌タイプIDと土壌名・説明を格納するマスタテーブル
-- 【LU（Look Up）とは】IDと名称の対応を保持する参照用テーブル
-- 　　　  「ID だけでは分からない情報を調べるための辞書」
-- 【ロード元】LU_SOIL_TYPE.tsv（タブ区切り）
-- 【期待行数】8行（DORA DWW13 で確認）

create or replace table LU_SOIL_TYPE
(
  SOIL_TYPE_ID   number,           -- 土壌タイプの一意なID
  SOIL_TYPE      varchar(15),      -- 土壌タイプ名（例: Sandy, Clay など）
  SOIL_DESCRIPTION varchar(75)     -- 土壌の詳細説明
);


-- ============================================================
-- 4. データ確認（ロード後）
-- ============================================================

-- VEGETABLE_DETAILS_SOIL_TYPE の確認（42行期待）
SELECT * FROM GARDEN_PLANTS.VEGGIES.VEGETABLE_DETAILS_SOIL_TYPE;
SELECT count(*) FROM GARDEN_PLANTS.VEGGIES.VEGETABLE_DETAILS_SOIL_TYPE;

-- LU_SOIL_TYPE の確認（8行期待）
SELECT * FROM GARDEN_PLANTS.VEGGIES.LU_SOIL_TYPE;
SELECT count(*) FROM GARDEN_PLANTS.VEGGIES.LU_SOIL_TYPE;


-- ============================================================
-- 5. FRUIT_DETAILS テーブルの作成（Streamlit 用）
-- ============================================================
-- 【目的】Streamlit フォームから果物データを入力するためのテーブル
-- 【構造】VEGETABLE_DETAILS と同じ構造（VEGETABLE_DETAILS のDDLをコピーして作成）

create table garden_plants.fruits.fruit_details
(
  plant_name      varchar(25)
, root_depth_code varchar(1)
);

-- データ確認
SELECT * FROM GARDEN_PLANTS.FRUITS.FRUIT_DETAILS;
