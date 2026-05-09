-- ============================================================
-- 03_session_params.sql
-- 対応まとめ: 04_アカウント_セキュリティ.md § 5. セッション管理
--             および § 10. パラメータ
-- 目的: セッション変数・パラメータの設定・確認・継承を体験する
-- ============================================================

-- ============================================================
-- STEP 1: 現在のセッションパラメータを一覧表示
-- ============================================================
SHOW PARAMETERS;
-- → SESSION レベルで有効なパラメータが一覧表示される

-- ============================================================
-- STEP 2: アカウント / ユーザー / セッション レベルのパラメータ確認
-- ============================================================
SHOW PARAMETERS IN ACCOUNT;
SHOW PARAMETERS IN USER ADMIN;      -- ← 自分のユーザー名に変更して実行
SHOW PARAMETERS IN SESSION;

-- ============================================================
-- STEP 3: セッションレベルでパラメータを設定
-- ============================================================
-- タイムゾーンの設定
ALTER SESSION SET TIMEZONE = 'Asia/Tokyo';
SELECT CURRENT_TIMESTAMP();         -- 日本時間で表示されることを確認

ALTER SESSION SET TIMEZONE = 'UTC';
SELECT CURRENT_TIMESTAMP();         -- UTC に戻ることを確認

-- ============================================================
-- STEP 4: 日付・タイムスタンプの出力形式
-- ============================================================
ALTER SESSION SET DATE_OUTPUT_FORMAT = 'DD/MM/YYYY';
SELECT CURRENT_DATE();              -- → 28/04/2026 形式で表示

ALTER SESSION SET DATE_OUTPUT_FORMAT = 'YYYY-MM-DD';
SELECT CURRENT_DATE();              -- → 2026-04-28 に戻る

ALTER SESSION SET TIMESTAMP_OUTPUT_FORMAT = 'YYYY-MM-DD HH24:MI:SS TZH:TZM';
SELECT CURRENT_TIMESTAMP();

-- ============================================================
-- STEP 5: クエリタイムアウト
-- ============================================================
ALTER SESSION SET STATEMENT_TIMEOUT_IN_SECONDS = 30;
SHOW PARAMETERS LIKE 'STATEMENT_TIMEOUT_IN_SECONDS' IN SESSION;

-- 元に戻す
ALTER SESSION UNSET STATEMENT_TIMEOUT_IN_SECONDS;

-- ============================================================
-- STEP 6: QUERY_TAG でクエリを分類
-- ============================================================
ALTER SESSION SET QUERY_TAG = 'project:verification_test';

-- このセッションで実行するクエリにタグが付く
SELECT CURRENT_TIMESTAMP();

-- ACCOUNT_USAGE で後から確認
SELECT query_id, query_text, query_tag, start_time
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE query_tag = 'project:verification_test'
  AND start_time >= DATEADD(HOUR, -1, CURRENT_TIMESTAMP())
ORDER BY start_time DESC;

ALTER SESSION UNSET QUERY_TAG;

-- ============================================================
-- STEP 7: セッション変数（SET / GET）
-- ============================================================
SET my_db    = 'SNOWFLAKE_SAMPLE_DATA';
SET max_rows = 10;

-- 変数の参照（$ を付ける）
SELECT $my_db    AS db_name;
SELECT $max_rows AS row_limit;

-- 変数を USE コマンドで使う（IDENTIFIER() でラップ）
USE DATABASE IDENTIFIER($my_db);

-- 変数の削除
UNSET my_db;
UNSET max_rows;

-- ============================================================
-- STEP 8: パラメータの継承確認（セッション > ユーザー > アカウント）
-- ============================================================
-- アカウントレベルのパラメータを確認
SHOW PARAMETERS LIKE 'TIMEZONE' IN ACCOUNT;

-- セッションで上書き
ALTER SESSION SET TIMEZONE = 'America/New_York';
SHOW PARAMETERS LIKE 'TIMEZONE' IN SESSION;
-- → KEY=TIMEZONE, VALUE=America/New_York, LEVEL=SESSION と表示される

-- セッション設定を解除（ユーザー/アカウント設定に戻る）
ALTER SESSION UNSET TIMEZONE;
SHOW PARAMETERS LIKE 'TIMEZONE' IN SESSION;
