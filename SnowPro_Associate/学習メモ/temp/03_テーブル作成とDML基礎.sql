-- ============================================================
-- 03_テーブル作成とDML基礎.sql
-- Snowflake DWW Badge 1 - テーブル作成と基本DML操作
-- ============================================================
-- 【概要】
-- DDL (Data Definition Language): テーブルなどの構造を定義する
--   → CREATE TABLE, CREATE OR REPLACE TABLE
-- DML (Data Manipulation Language): データを操作する
--   → INSERT, SELECT, UPDATE, DELETE, TRUNCATE
--
-- Snowflake のデータ型変換（自動変換）：
--   TEXT(n)   → VARCHAR(n)  ← Snowflakeが内部で自動変換
--   NUMBER(n) → NUMBER(n,0) ← 小数点以下0桁として補完
-- ============================================================


-- ============================================================
-- 1. コンテキスト設定（事前に必ず実行）
-- ============================================================

use role sysadmin;
use database GARDEN_PLANTS;
use schema VEGGIES;
use warehouse COMPUTE_WH;


-- ============================================================
-- 2. テーブルの作成
-- ============================================================
-- 【目的】植物の根の深さを管理する ROOT_DEPTH テーブルを作成する
-- 【動作】CREATE TABLE でカラム名とデータ型を定義する
-- 【注意】TEXT は内部的に VARCHAR に変換される
-- 　　　  NUMBER(1) は NUMBER(1,0) に変換される（小数なし）

create or replace table ROOT_DEPTH (
   ROOT_DEPTH_ID   number(1),   -- 根の深さID（1桁の整数）
   ROOT_DEPTH_CODE text(1),     -- 略称コード（S/M/D など1文字）→ VARCHAR(1) に変換
   ROOT_DEPTH_NAME text(7),     -- 名称（最大7文字）→ VARCHAR(7) に変換
   UNIT_OF_MEASURE text(2),     -- 単位（cm/in）
   RANGE_MIN       number(2),   -- 最小値（2桁整数）
   RANGE_MAX       number(2)    -- 最大値（2桁整数）
);

-- 【補足】CREATE OR REPLACE は既存テーブルを上書き作成する
-- 　　　  既にテーブルが存在する場合に「すでに存在します」エラーを防ぐ


-- ============================================================
-- 3. 単行INSERT
-- ============================================================
-- 【目的】ROOT_DEPTH テーブルに1行データを追加する
-- 【動作】VALUES の順番はテーブル定義のカラム順と一致させる
-- 【注意】文字列は '' で囲む。数値はそのまま記述する

insert into root_depth
values
(
    1,        -- ROOT_DEPTH_ID
    'S',      -- ROOT_DEPTH_CODE（Shallow の略）
    'Shallow', -- ROOT_DEPTH_NAME
    'cm',     -- UNIT_OF_MEASURE
    30,       -- RANGE_MIN（cm）
    45        -- RANGE_MAX（cm）
);


-- ============================================================
-- 4. 複数行INSERT（一度に複数行を挿入）
-- ============================================================
-- 【目的】複数行を1つのINSERT文でまとめて挿入する
-- 【動作】VALUES の後に (行1),(行2),... と並べる
-- 【注意】これはサンプル。実際には値を正しい内容に変えて使う
/*
THESE ARE JUST EXAMPLES!
YOU SHOULD NOT RUN THIS CODE
WITHOUT EDITING IT FOR YOUR NEEDS.
*/

-- カラム名を明示して挿入（カラム名を指定すると順番を間違えにくい）
insert into root_depth (root_depth_id, root_depth_code
     , root_depth_name, unit_of_measure
     , range_min, range_max)
values
     (2, 'M', 'Medium', 'cm', 46, 60)   -- Mediumの行
    ,(3, 'D', 'Deep',   'cm', 61, 90)   -- Deepの行
;


-- ============================================================
-- 5. SELECT（データの確認）
-- ============================================================
-- 【目的】テーブルのデータを参照する
-- 【動作】SELECT * はすべてのカラムを返す（* = アスタリスク = "すべて"）
-- 　　　  LIMIT n は返す行数を n 件に制限する（大量データの確認に有効）

-- 全件取得
SELECT * FROM ROOT_DEPTH;

-- 1件だけ取得（テーブルの中身を素早く確認したいとき）
SELECT *
FROM ROOT_DEPTH
LIMIT 1;


-- ============================================================
-- 6. DELETE（特定行の削除）
-- ============================================================
-- 【目的】条件に一致する行を削除する
-- 【動作】WHERE 句で削除対象を絞る。WHERE なしだと全行削除になるため注意
-- 【注意】削除した行は元に戻せない（Time Travel で復元は可能）

-- ROOT_DEPTH_ID が 9 の行を削除
delete from root_depth
where root_depth_id = 9;


-- ============================================================
-- 7. UPDATE（特定行の値を変更）
-- ============================================================
-- 【目的】条件に一致する行の特定カラムを更新する
-- 【動作】SET で変更するカラムと値を指定、WHERE で対象行を絞る
-- 【注意】WHERE なしだと全行が更新される

-- ROOT_DEPTH_ID が 9 の行を 7 に変更
update root_depth
set root_depth_id = 7
where root_depth_id = 9;


-- ============================================================
-- 8. TRUNCATE（テーブルの全行削除）
-- ============================================================
-- 【目的】テーブルの構造を残したまま、すべての行を削除する
-- 【動作】DELETE と異なり WHERE 句を使わない。全件一括削除
-- 【DELETE との違い】
--   DELETE   : 条件指定可能、行ごとにログを記録（低速）
--   TRUNCATE : 全件削除のみ、構造保持（高速）

-- テーブルを空にしてやり直したいときに使う
truncate table root_depth;

-- 完全修飾名で指定する場合（コンテキスト設定がなくても動く）
TRUNCATE TABLE GARDEN_PLANTS.VEGGIES.ROOT_DEPTH;
