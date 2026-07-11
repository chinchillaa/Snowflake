-- ============================================================
-- 01_account_info.sql
-- 対応まとめ: 04_アカウント_セキュリティ.md § 1. Snowflakeアカウント
-- 目的: アカウント識別子・リージョン・現在の接続情報を確認する
-- ============================================================

-- ============================================================
-- STEP 1: 現在のアカウント情報を確認
-- ============================================================
SELECT
  CURRENT_ACCOUNT()           AS account_locator,   -- 例: xy12345
  CURRENT_REGION()            AS region,            -- 例: AWS_AP_NORTHEAST_1
  CURRENT_ORGANIZATION_NAME() AS organization,      -- Organization名
  CURRENT_USER()              AS current_user,
  CURRENT_ROLE()              AS current_role,
  CURRENT_DATABASE()          AS current_db,
  CURRENT_SCHEMA()            AS current_schema,
  CURRENT_WAREHOUSE()         AS current_wh;

-- ============================================================
-- STEP 2: Account URL の確認（接続文字列の構成要素）
-- ACCOUNT_LOCATOR.REGION.snowflakecomputing.com
-- ============================================================
SELECT
  CURRENT_ACCOUNT() || '.' ||
  LOWER(CURRENT_REGION()) || '.snowflakecomputing.com' AS account_url;

-- ============================================================
-- STEP 3: ACCOUNT_USAGE でアカウント内のユーザー一覧を確認
-- ============================================================
SELECT
  name,
  login_name,
  display_name,
  default_role,
  default_warehouse,
  created_on,
  last_success_login
FROM SNOWFLAKE.ACCOUNT_USAGE.USERS
WHERE deleted_on IS NULL
ORDER BY created_on DESC
LIMIT 20;

-- ============================================================
-- STEP 4: Organization 情報（ORGADMIN ロールが必要な場合あり）
-- ============================================================
-- SHOW ORGANIZATION ACCOUNTS;
-- → Organization 配下の全アカウント一覧（ORGADMIN権限が必要）
