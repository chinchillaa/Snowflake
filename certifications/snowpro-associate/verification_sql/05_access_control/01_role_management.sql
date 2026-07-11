-- ============================================================
-- 01_role_management.sql
-- 対応まとめ: 05_アクセス制御_ロール.md § 3. ロール管理
-- 目的: ロールの作成・付与・継承・RBAC 階層を体験する
-- ============================================================

-- ============================================================
-- STEP 1: 現在のロール確認
-- ============================================================
SELECT CURRENT_ROLE();
SHOW ROLES;

-- ============================================================
-- STEP 2: カスタムロールの作成
-- ============================================================
CREATE ROLE IF NOT EXISTS analyst_role
  COMMENT = '分析担当ロール（検証用）';

CREATE ROLE IF NOT EXISTS junior_analyst_role
  COMMENT = '初級アナリストロール（検証用）';

SHOW ROLES LIKE '%analyst%';

-- ============================================================
-- STEP 3: ロール階層の設定（ロールへのロール付与）
-- analyst_role → junior_analyst_role の上位に位置する
-- ============================================================
GRANT ROLE junior_analyst_role TO ROLE analyst_role;

-- 階層の確認
SHOW GRANTS ON ROLE analyst_role;
SHOW GRANTS TO ROLE analyst_role;

-- ============================================================
-- STEP 4: ユーザーへのロール付与
-- ============================================================
-- GRANT ROLE analyst_role TO USER 自分のユーザー名;
-- SHOW GRANTS TO USER 自分のユーザー名;

-- ============================================================
-- STEP 5: デフォルトロールの確認（ACCOUNT_USAGE.USERS）
-- ============================================================
SELECT
  name,
  default_role,
  has_rsa_public_key,
  created_on
FROM SNOWFLAKE.ACCOUNT_USAGE.USERS
WHERE deleted_on IS NULL
ORDER BY created_on DESC
LIMIT 10;

-- ============================================================
-- STEP 6: システム定義ロールの確認
-- ACCOUNTADMIN > SYSADMIN > PUBLIC など
-- ============================================================
SHOW ROLES;
-- → ACCOUNTADMIN, SYSADMIN, SECURITYADMIN, USERADMIN, PUBLIC が確認できる

-- ============================================================
-- STEP 7: 後片付け
-- ============================================================
DROP ROLE IF EXISTS junior_analyst_role;
DROP ROLE IF EXISTS analyst_role;
