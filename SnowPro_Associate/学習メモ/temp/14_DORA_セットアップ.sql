-- ============================================================
-- 14_DORA_セットアップ.sql
-- Snowflake DWW Badge 1 - DORA 採点システムのセットアップ
-- ============================================================
-- 【概要】
-- DORA（自動採点システム）は外部の API に採点データを送信し、
-- ラボ作業の正誤を自動チェックするシステム。
--
-- 仕組み：
--   1. API Integration  : Snowflake から外部API（AWS API Gateway）への接続設定
--   2. External Function: SQL から呼び出せる外部APIの関数ラッパー
--   3. grader()         : 採点データを DORA サーバーに送信する関数
--
-- 【注意事項】
-- - 必ず ACCOUNTADMIN ロールで実行すること
-- - DORA コードは一字一句変更してはならない（HASH で改ざん検知される）
-- - 90日以内に全 DWW01〜DWW19 を完了すること
-- - GRADER 関数は UTIL_DB.PUBLIC スキーマに作成すること
-- ============================================================


-- ============================================================
-- 1. ロールの切り替え（ACCOUNTADMIN が必須）
-- ============================================================
-- 【理由】API Integration の作成には ACCOUNTADMIN 権限が必要

use role accountadmin;


-- ============================================================
-- 2. API Integration の作成
-- ============================================================
-- 【目的】Snowflake が外部の AWS API Gateway に接続するための設定
-- 【API Integration とは】
--   外部 HTTP API への接続を定義するオブジェクト。
--   どの URL へのアクセスを許可するかを事前に登録する。
--
-- 【各パラメータの意味】
--   api_provider        : APIのプロバイダー（aws_api_gateway = AWS使用）
--   api_aws_role_arn    : AWSのIAMロールのARN（Amazon Resource Name）
--                         ← Snowflake が AWS に「なりすまして」アクセスするためのロール
--   enabled             : この Integration を有効化するか（true/false）
--   api_allowed_prefixes: アクセスを許可するURLのプレフィックス（先頭部分）
--
-- 【注意】このコードは変更禁止

create or replace api integration dora_api_integration
api_provider = aws_api_gateway
api_aws_role_arn = 'arn:aws:iam::321463406630:role/snowflakeLearnerAssumedRole'
enabled = true
api_allowed_prefixes = ('https://awy6hshxy4.execute-api.us-west-2.amazonaws.com/dev/edu_dora');


-- ============================================================
-- 3. GRADER 外部関数の作成
-- ============================================================
-- 【目的】採点データを DORA サーバーに送る SQL 関数を作成する
-- 【External Function とは】
--   SQL から呼び出すと外部 API にデータを送り、結果を返す関数。
--   Snowflake 内部には処理ロジックを持たず、外部で計算・判定する。
--
-- 【引数の意味】
--   step        : チェック名（例: 'DWW01'）
--   passed      : 合否（true/false）
--   actual      : 実際の値
--   expected    : 期待値
--   description : チェックの説明文
--
-- 【context_headers の意味】
--   現在のタイムスタンプ・アカウント・ステートメント・アカウント名を
--   API リクエストのヘッダーとして自動送信する
--
-- 【注意】UTIL_DB.PUBLIC に作成すること。場所が違うと DORA が見つけられない

use role accountadmin;

create or replace external function util_db.public.grader(
      step        varchar       -- ステップ名（例: 'DWW01'）
    , passed      boolean       -- 合否（true/false）
    , actual      integer       -- 実際の値
    , expected    integer       -- 期待値
    , description varchar       -- チェックの説明
)
returns variant
api_integration = dora_api_integration
context_headers = (current_timestamp, current_account, current_statement, current_account_name)
as 'https://awy6hshxy4.execute-api.us-west-2.amazonaws.com/dev/edu_dora/grader'
;


-- ============================================================
-- 4. GRADER 関数の動作確認テスト
-- ============================================================
-- 【目的】DORA がちゃんと動いているか確認する
-- 【動作】actual = expected（123 = 123）なので passed = true になる
-- 【注意】コードは変更しないこと

use role accountadmin;
use database util_db;
use schema public;

select grader(step, (actual = expected), actual, expected, description) as graded_results from
(SELECT
 'DORA_IS_WORKING' as step
 ,(select 123) as actual
 ,123 as expected
 ,'Dora is working!' as description
);

-- ============================================================
-- 【トラブルシューティング】
-- ============================================================
-- GRADER 関数が見つからない場合:
--   → ロールが ACCOUNTADMIN になっているか確認
--   → ワークシート右上のロールドロップダウンを確認
--
-- 関数を探す:
--   show functions in account;
--
-- 関数が UTIL_DB.PUBLIC 以外にある場合のリネーム:
--   ALTER FUNCTION 古い場所.GRADER RENAME TO UTIL_DB.PUBLIC.GRADER
-- ============================================================
