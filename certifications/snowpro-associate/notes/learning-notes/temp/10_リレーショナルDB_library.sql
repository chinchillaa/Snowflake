-- ============================================================
-- 10_リレーショナルDB_library.sql
-- Snowflake DWW Badge 1 - リレーショナルDB設計（図書館カードカタログ）
-- ============================================================
-- 【概要】
-- 書籍・著者・関係性を3つのテーブルで管理するリレーショナルDB。
-- 第3正規形（3NF）の考え方を実践する。
--
-- テーブル構成：
--   BOOK         : 書籍情報（AUTOINCREMENT でUID自動採番）
--   AUTHOR       : 著者情報（SEQUENCEでUID採番）
--   BOOK_TO_AUTHOR: 書籍と著者の多対多関係を管理するブリッジテーブル
--
-- 一意なID（UID）の生成方法：
--   1. AUTOINCREMENT : テーブル定義に組み込む。シンプルで自動的
--   2. SEQUENCE      : 独立したオブジェクト。複数テーブルに同じIDを振れる
-- ============================================================


-- ============================================================
-- 1. データベース・コンテキスト設定
-- ============================================================

use role sysadmin;

// Create a new database and set the context to use the new database
create database library_card_catalog comment = 'DWW Lesson 10';

//Set the worksheet context to use the new database
use database library_card_catalog;


-- ============================================================
-- 2. BOOK テーブルの作成（AUTOINCREMENT）
-- ============================================================
-- 【目的】書籍情報を格納する。book_uid は自動採番
-- 【AUTOINCREMENT の動作】
--   INSERT 時に book_uid を指定しなければ、Snowflake が自動的に
--   1, 2, 3... とインクリメントして付与する
-- 【注意】INSERT 時に book_uid カラムを省略すること

use database library_card_catalog;
use role sysadmin;

// Create the book table and use AUTOINCREMENT to generate a UID for each new row
create or replace table book
(
  book_uid       number autoincrement  -- autoincrement: 自動採番（1, 2, 3...）
 ,title          varchar(50)
 ,year_published number(4,0)           -- 4桁の年（例: 2001）
);

// Insert records into the book table
// You don't have to list anything for the
// BOOK_UID field because the AUTOINCREMENT property
// will take care of it for you
insert into book(title, year_published)
values
 ('Food', 2001)
,('Food', 2006)
,('Food', 2008)
,('Food', 2016)
,('Food', 2015);

// Check your table. Does each row have a unique id?
select * from book;


-- ============================================================
-- 3. AUTHOR テーブルの作成と初期データ投入
-- ============================================================
-- 【目的】著者情報を格納する。author_uid は手動で指定（後でSEQUENCEに切替）
-- 【注意】最初の2行は手動でUID（1, 2）を指定している

// Create Author table
create or replace table author
(
   author_uid   number
  ,first_name   varchar(50)
  ,middle_name  varchar(50)
  ,last_name    varchar(50)
);

// Insert the first two authors into the Author table
insert into author(author_uid, first_name, middle_name, last_name)
values
 (1, 'Fiona',      '',       'Macdonald')
,(2, 'Gian',  'Paulo',  'Faleschini');

// Look at your table with its new rows
select *
from author;


-- ============================================================
-- 4. SEQUENCE の作成（連番オブジェクト）
-- ============================================================
-- 【目的】author_uid に自動的に連番を振るためのカウンターを作成する
-- 【SEQUENCE の特徴】
--   - テーブルとは独立したオブジェクト
--   - .nextval を呼ぶたびに次の値を返す
--   - 複数テーブルに同じIDを振ることができる（AUTOINCREMENT にはできない）
-- 【ORDER の意味】
--   ORDER を付けることで値が順番通りに採番される
--   付けないと値が 100 ずつスキップする（並列実行への対応）

-- 最初のSEQUENCE（1からスタート）
create or replace sequence library_card_catalog.public.seq_author_uid
start = 1
increment = 1
ORDER
comment = 'Use this to fill in the AUTHOR_UID every time you add a row';

use role sysadmin;

//See how the nextval function works
select seq_author_uid.nextval;
-- 実行するたびに値が増えていく（1 → 2 → 3...）


-- ============================================================
-- 5. SEQUENCE のリセットと残りの著者データ挿入
-- ============================================================
-- 【目的】すでに2行（UID=1, 2）があるので、3から再開するよう設定し直す
-- 【動作】CREATE OR REPLACE SEQUENCE で start = 3 として再作成

use role sysadmin;

//Drop and recreate the counter (sequence) so that it starts at 3
// then we'll add the other author records to our author table
create or replace sequence library_card_catalog.public.seq_author_uid
start = 3
increment = 1
ORDER
comment = 'Use this to fill in the AUTHOR_UID every time you add a row';

//Add the remaining author records and use the nextval function instead
//of putting in the numbers
insert into author(author_uid, first_name, middle_name, last_name)
values
 (seq_author_uid.nextval, 'Laura',    'K',  'Egendorf')   -- UID=3
,(seq_author_uid.nextval, 'Jan',       '',   'Grover')     -- UID=4
,(seq_author_uid.nextval, 'Jennifer',  '',   'Clapp')      -- UID=5
,(seq_author_uid.nextval, 'Kathleen',  '',   'Petelinsek') -- UID=6


-- ============================================================
-- 6. BOOK_TO_AUTHOR ブリッジテーブルの作成
-- ============================================================
-- 【目的】書籍と著者の多対多（M:N）関係を管理する
-- 【ブリッジテーブルとは】
--   1冊の書籍に複数の著者がいる（1対多）
--   1人の著者が複数の書籍を書いている（1対多）
--   この「双方向の1対多」= 多対多の関係を表現するための中間テーブル
-- 【構造】書籍UIDと著者UIDの組み合わせだけを格納する

use database library_card_catalog;
use role sysadmin;

// Create the relationships table
// this is sometimes called a "Many-to-Many table"
create table book_to_author
(
  book_uid   number
 ,author_uid number
);

//Insert rows of the known relationships
insert into book_to_author(book_uid, author_uid)
values
 (1, 1)  // This row links the 2001 book to Fiona Macdonald
,(1, 2)  // This row links the 2001 book to Gian Paulo Faleschini
,(2, 3)  // Links 2006 book to Laura K Egendorf
,(3, 4)  // Links 2008 book to Jan Grover
,(4, 5)  // Links 2016 book to Jennifer Clapp
,(5, 6)  // Links 2015 book to Kathleen Petelinsek
;


-- ============================================================
-- 7. 3テーブルJOIN（リレーションを結合して確認）
-- ============================================================
-- 【目的】BOOK_TO_AUTHOR・AUTHOR・BOOK の3テーブルを結合して
-- 　　　  「書籍名・著者名」を一覧表示する
-- 【動作】JOIN ... ON ... で結合条件（共通キー）を指定する
-- 【期待行数】6行（著者1人につき1行）

//Check your work by joining the 3 tables together
//You should get 1 row for every author
select *
from book_to_author ba           -- ba = book_to_author の別名（エイリアス）
join author a                    -- a  = author の別名
  on ba.author_uid = a.author_uid    -- 結合条件: 著者IDが一致
join book b                      -- b  = book の別名
  on b.book_uid = ba.book_uid;       -- 結合条件: 書籍IDが一致
