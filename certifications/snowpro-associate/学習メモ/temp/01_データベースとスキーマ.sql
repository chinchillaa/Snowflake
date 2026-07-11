-- ============================================================
-- 01_データベースとスキーマ.sql
-- Snowflake DWW Badge 1 - データベース・スキーマ操作
-- ============================================================
-- 【概要】
-- Snowflake のデータ格納の最上位単位が「データベース」、
-- その中の区画が「スキーマ」。
-- DB を作成すると INFORMATION_SCHEMA と PUBLIC が自動生成される。
-- INFORMATION_SCHEMA は削除・リネーム不可。PUBLIC は自由に操作可能。
-- ============================================================


-- ============================================================
-- 1. ロールの確認・切り替え
-- ============================================================
-- 【目的】オブジェクトを作成するロールによってオーナーが決まる（DAC原則）
-- 【注意】USE ROLE を実行してからオブジェクトを作成すること

use role sysadmin;


-- ============================================================
-- 2. データベースの作成
-- ============================================================
-- 【目的】Uncle Yer の植物ショップ用データベースを作成する
-- 【動作】実行したロール（SYSADMIN）がオーナーになる
-- 【注意】DB作成時に INFORMATION_SCHEMA と PUBLIC が自動生成される

create database GARDEN_PLANTS;

-- その他のレッスンで使うデータベース
create database UTIL_DB;            -- DORA（採点システム）用
create database LIBRARY_CARD_CATALOG comment = 'DWW Lesson 10';  -- リレーショナルDB演習用
create database SOCIAL_MEDIA_FLOODGATES;  -- Twitter JSONデータ用


-- ============================================================
-- 3. データベース・スキーマの一覧確認
-- ============================================================
-- 【目的】現在のロールから見えるDBやスキーマを確認する
-- 【動作】SHOW DATABASES は所有・アクセス可能なDB一覧を返す

show databases;

-- 【動作】SHOW SCHEMAS はコンテキストに設定されたDBのスキーマ一覧を返す
show schemas;

-- 【動作】IN ACCOUNT を付けると全DBのスキーマを横断して表示する
-- 　　　  コンテキストのDB設定に関係なく全件返る
show schemas in account;


-- ============================================================
-- 4. スキーマの削除
-- ============================================================
-- 【目的】GARDEN_PLANTS に自動作成された PUBLIC スキーマを削除する
-- 【注意】INFORMATION_SCHEMA は削除不可（Snowflakeが管理する読み取り専用）
-- 【補足】「DROP = Delete」と同義

use database GARDEN_PLANTS;

drop schema PUBLIC;


-- ============================================================
-- 5. スキーマの新規作成
-- ============================================================
-- 【目的】Uncle Yer のデータを野菜・果物・花で分類するスキーマを作る
-- 【動作】スキーマはDBの中に作成される。コンテキストDBを事前に設定するか、
-- 　　　  DB名を完全修飾名（GARDEN_PLANTS.VEGGIES など）で指定する

create schema GARDEN_PLANTS.VEGGIES;
create schema GARDEN_PLANTS.FRUITS;
create schema GARDEN_PLANTS.FLOWERS;


-- ============================================================
-- 6. スキーマのリネーム（ALTERによる修正）
-- ============================================================
-- 【目的】スキーマ名をタイポした場合などに修正する
-- 【動作】ALTER SCHEMA ... RENAME TO で名前を変更できる
-- 【使用場面】「WEGGIES」とタイポしてしまった場合の修正例

-- 同じDB内でリネーム
ALTER SCHEMA GARDEN_PLANTS.WEGGIES RENAME TO GARDEN_PLANTS.VEGGIES;

-- 別のDBからGARDEN_PLANTSに移動（誤ったDBに作った場合）
ALTER SCHEMA DEMO_DB.VEGGIES RENAME TO GARDEN_PLANTS.VEGGIES;


-- ============================================================
-- 7. LIBRARY_CARD_CATALOG データベースの初期セットアップ
-- ============================================================
-- 【目的】リレーショナルDB演習（Lesson 10）用のコンテキスト設定
-- 【動作】USE DATABASE でコンテキストを切り替えると、
-- 　　　  以降のクエリでDB名を省略できる

use role sysadmin;

-- // は Snowflake Worksheet の行コメント（-- と同じ）
// Create a new database and set the context to use the new database
create database library_card_catalog comment = 'DWW Lesson 10';

//Set the worksheet context to use the new database
use database library_card_catalog;
