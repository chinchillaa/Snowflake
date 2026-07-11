-- ============================================================
-- 13_JSON_Twitterデータとビュー.sql
-- Snowflake DWW Badge 1 - Twitter JSONデータのクエリとビュー作成
-- ============================================================
-- 【概要】
-- 実際の Twitter の生 JSON データ（nutrition_tweets.json）を使って
-- 複雑なネスト構造をクエリする実践演習。
--
-- 使用するデータ構造（一部）：
--   raw_status:id               : ツイートID
--   raw_status:created_at       : 投稿日時
--   raw_status:user:name        : ユーザー名（ネスト）
--   raw_status:entities:hashtags: ハッシュタグの配列（深いネスト）
--   raw_status:entities:urls    : URLの配列（深いネスト）
--
-- VIEW（ビュー）とは：
--   SELECT クエリに名前を付けて保存したもの。
--   実行するたびに最新のデータを返す（データは持たない）。
--   複雑なクエリを再利用するときに使う。
-- ============================================================


-- ============================================================
-- 1. TWEET_INGEST テーブルとデータベースの準備
-- ============================================================
-- 【前提】
--   - SOCIAL_MEDIA_FLOODGATES データベースが作成済みであること
--   - TWEET_INGEST テーブルが存在し、9行のデータがロード済みであること

use role sysadmin;
use database SOCIAL_MEDIA_FLOODGATES;
use schema PUBLIC;


-- ============================================================
-- 2. シンプルなJSONクエリ（コロン記法）
-- ============================================================

//simple select statements -- are you seeing 9 rows?
select raw_status
from tweet_ingest;

-- エンティティ（ハッシュタグ・URL・メンションなどを含む）を取得
select raw_status:entities
from tweet_ingest;

-- entities の中の hashtags 配列を取得
select raw_status:entities:hashtags
from tweet_ingest;


-- ============================================================
-- 3. 配列インデックスでアクセス
-- ============================================================
-- 【目的】各ツイートの最初のハッシュタグを取得する
-- 【構文】配列[n] でインデックス指定（0始まり）
-- 　　　  .text は hashtag オブジェクトの text フィールドを参照

//Explore looking at specific hashtags by adding bracketed numbers
//This query returns just the first hashtag in each tweet
select raw_status:entities:hashtags[0].text
from tweet_ingest;

//This version adds a WHERE clause to get rid of any tweet that
//doesn't include any hashtags
select raw_status:entities:hashtags[0].text
from tweet_ingest
where raw_status:entities:hashtags[0].text is not null;


-- ============================================================
-- 4. 日時のキャストと並び替え
-- ============================================================
-- 【目的】ツイートの投稿日時を DATE 型としてキャストして並び替える
-- 【::date】 VARCHAR の日時文字列を DATE 型に変換するキャスト
-- 【ORDER BY】並び替えの方向（デフォルトは昇順 ASC）

//Perform a simple CAST on the created_at key
//Add an ORDER BY clause to sort by the tweet's creation date
select raw_status:created_at::date
from tweet_ingest
order by raw_status:created_at::date;


-- ============================================================
-- 5. FLATTEN で URL / ハッシュタグの配列を展開
-- ============================================================
-- 【目的】各ツイートの URLs・hashtags を1行ずつ展開して確認する
-- 【補足】1ツイートに複数ハッシュタグがあると、展開後は複数行になる

//Flatten statements can return nested entities only (and ignore the higher level objects)

-- URL を展開（書き方①: LATERAL FLATTEN）
select value
from tweet_ingest
,lateral flatten
(input => raw_status:entities:urls);

-- URL を展開（書き方②: TABLE(FLATTEN) ← 書き方①と結果は同じ）
select value
from tweet_ingest
,table(flatten(raw_status:entities:urls));

//Flatten and return just the hashtag text, CAST the text as VARCHAR
select value:text::varchar as hashtag_used   -- value はFLATTEN展開した各要素
from tweet_ingest
,lateral flatten
(input => raw_status:entities:hashtags);


-- ============================================================
-- 6. 複数フィールドを組み合わせたクエリ
-- ============================================================
-- 【目的】どのユーザーのどのツイートでどのハッシュタグが使われたかを一覧化
-- 【動作】ツイートID・ユーザー名・ハッシュタグを横断して取得

//Add the Tweet ID and User ID to the returned table
//so we could join the hashtag back to its source tweet
select raw_status:user:name::text  as user_name     -- ネストしたユーザー名
      ,raw_status:id               as tweet_id      -- ツイートID
      ,value:text::varchar         as hashtag_used  -- FLATTENで展開したハッシュタグ
from tweet_ingest
,lateral flatten
(input => raw_status:entities:hashtags);


-- ============================================================
-- 7. ビュー（VIEW）の作成
-- ============================================================

-- ── 7-A: URL 正規化ビュー ──
-- 【目的】URL データを正規化されたテーブルのように見せるビューを作成する
-- 【CREATE OR REPLACE VIEW ... AS (SELECT ...)】
-- 　　　  ビューに名前を付けてクエリを保存する
-- 　　　  SELECT * すると都度クエリが実行される（データはビューに保存されない）

create or replace view social_media_floodgates.public.urls_normalized as
(
  select raw_status:user:name::text   as user_name
        ,raw_status:id                as tweet_id
        ,value:display_url::text      as url_used    -- display_url: 表示用のURL
  from tweet_ingest
  ,lateral flatten
  (input => raw_status:entities:urls)
);

-- ── 7-B: ハッシュタグ正規化ビュー（Challenge Lab） ──
-- 【目的】ハッシュタグデータを正規化されたテーブルのように見せるビューを作成する
-- 【注意】DWW19 で HASHTAGS_NORMALIZED ビューの存在を確認される

create or replace view social_media_floodgates.public.hashtags_normalized as
(
  select raw_status:user:name::text   as user_name
        ,raw_status:id                as tweet_id
        ,value:text::varchar          as hashtag_used
  from tweet_ingest
  ,lateral flatten
  (input => raw_status:entities:hashtags)
);

-- ビューの確認
SELECT * FROM social_media_floodgates.public.urls_normalized;
SELECT * FROM social_media_floodgates.public.hashtags_normalized;
