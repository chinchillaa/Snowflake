-- ============================================================
-- 06_Notebook_SQL変数.sql
-- Snowflake DWW Badge 1 - Notebook でのSQL・変数使用
-- ============================================================
-- 【概要】
-- Snowflake Notebook はセル単位で SQL/Python/Markdown を実行できる
-- 対話型の開発環境。Uncle Yer が花のデータを入力するために使用する。
--
-- Notebook の特徴：
--   - SQL / Python / Markdown の3種のセルが混在できる
--   - セルに名前を付けて管理できる
--   - セル間で変数を共有できる（SQL では SET / $ 記法を使用）
--   - SYSTEM$STREAMLIT_NOTEBOOK_WH ウェアハウスが自動使用される
--
-- このファイルは Notebook 内で使用したSQLコードの抽出版。
-- 実際の Notebook では各セルに分けて入力する。
-- ============================================================


-- ============================================================
-- 1. FLOWER_DETAILS テーブルの作成（事前準備）
-- ============================================================
-- 【目的】花のデータを格納するテーブルを作成する
-- 【補足】VEGETABLE_DETAILS と同じ構造（plant_name + root_depth_code）

create table garden_plants.flowers.flower_details
(
  plant_name      varchar(25)
, root_depth_code varchar(1)
);


-- ============================================================
-- 2. INSERT SELECT 構文でデータを追加（Notebook セル）
-- ============================================================
-- 【目的】Petunia のデータを FLOWER_DETAILS テーブルに追加する
-- 【動作】INSERT INTO ... SELECT 構文は VALUES の代わりに
-- 　　　  SELECT 文の結果をそのまま挿入する
-- 【使用場面】Notebook の SQL セルに記述して実行する

-- ── Notebook セル名: "add_flower" ──
insert into garden_plants.flowers.flower_details
select 'Petunia', 'M';
-- 'M' = Medium（中程度の根の深さ）


-- ============================================================
-- 3. SQL 変数の宣言（SET 文）
-- ============================================================
-- 【目的】繰り返し使う値を変数に格納して再利用する
-- 【動作】SET 変数名 = 値 で変数を宣言する
-- 　　　  参照時は $変数名 で取り出す
-- 【注意】SQL 変数は Snowflake セッション内でのみ有効

-- ── Notebook セル名: "set_root_depth_code" ──
set rdc = 'S';   -- rdc: root depth code の略

-- ── Notebook セル名: "set_flower_name" ──
set fn = 'Lilac';   -- fn: flower name の略


-- ============================================================
-- 4. 変数の確認（SELECT で参照）
-- ============================================================
-- 【目的】設定した変数の値が正しいか確認する
-- 【動作】SELECT $変数名 で変数の現在値を表示できる

-- ── Notebook セル名: "check_my_variables" ──
select $fn, $rdc;
-- 出力例: Lilac | S


-- ============================================================
-- 5. 変数を使ったINSERT（変数で動的にデータ挿入）
-- ============================================================
-- 【目的】変数に格納した値を使ってデータを挿入する
-- 【動作】INSERT INTO ... SELECT で $変数名 を値として使う
-- 【利点】変数の値を変えるだけで異なる花のデータを入力できる

-- ── Notebook セル名: "add_flower"（変数版）──
insert into garden_plants.flowers.flower_details
select $fn, $rdc;


-- ============================================================
-- 6. 挿入後のデータ確認
-- ============================================================
-- 【目的】挿入したデータが正しく登録されているか確認する

-- ── Notebook セル名: "check_the_table" ──
SELECT * FROM garden_plants.flowers.flower_details;


-- ============================================================
-- 7. 追加で入力した花のデータ（Challenge Lab）
-- ============================================================
-- 【目的】Sunflower / Lavender / Tulip を Notebook から追加する
-- 【手順】set fn と set rdc を書き換えて3回実行する

-- Sunflower（ひまわり）- 深い根
set fn = 'Sunflower';
set rdc = 'D';   -- D = Deep
insert into garden_plants.flowers.flower_details select $fn, $rdc;

-- Lavender（ラベンダー）- 浅い根
set fn = 'Lavender';
set rdc = 'S';   -- S = Shallow
insert into garden_plants.flowers.flower_details select $fn, $rdc;

-- Tulip（チューリップ）- 球根なので中程度扱い
set fn = 'Tulip';
set rdc = 'M';   -- M = Medium
insert into garden_plants.flowers.flower_details select $fn, $rdc;
