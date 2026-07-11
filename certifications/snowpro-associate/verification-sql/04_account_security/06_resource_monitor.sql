-- ============================================================
-- 06_resource_monitor.sql
-- 対応まとめ: 04_アカウント_セキュリティ.md § 9. リソースモニター
-- 目的: Resource Monitor の作成・確認・ウェアハウスへの適用を体験する
-- 注意: SUSPEND トリガーはウェアハウスを停止させるため本番環境では慎重に設定
-- ============================================================

-- ============================================================
-- STEP 1: リソースモニターの作成
-- CREDIT_QUOTA: 消費上限クレジット数
-- FREQUENCY: リセット周期（MONTHLY / DAILY / WEEKLY / YEARLY / NEVER）
-- TRIGGERS: しきい値アクション（NOTIFY / SUSPEND / SUSPEND_IMMEDIATE）
-- ============================================================
CREATE RESOURCE MONITOR dev_monitor
  WITH CREDIT_QUOTA   = 100
       FREQUENCY      = MONTHLY
       START_TIMESTAMP = IMMEDIATELY
  TRIGGERS
    ON 75 PERCENT DO NOTIFY
    ON 90 PERCENT DO NOTIFY
    ON 100 PERCENT DO SUSPEND;

-- ============================================================
-- STEP 2: リソースモニター一覧の確認
-- ============================================================
SHOW RESOURCE MONITORS;

-- ============================================================
-- STEP 3: 特定モニターの詳細確認
-- ============================================================
DESC RESOURCE MONITOR dev_monitor;

-- ============================================================
-- STEP 4: ウェアハウスへのリソースモニター適用
-- ============================================================
-- ALTER WAREHOUSE COMPUTE_WH SET RESOURCE_MONITOR = dev_monitor;
-- → COMPUTE_WH の消費クレジットが dev_monitor で監視される

-- 適用の確認
-- SHOW WAREHOUSES LIKE 'COMPUTE_WH';

-- ============================================================
-- STEP 5: アカウントレベルのリソースモニター設定
-- 全ウェアハウスに適用（ACCOUNTADMIN 権限が必要）
-- ============================================================
-- CREATE RESOURCE MONITOR account_monitor
--   WITH CREDIT_QUOTA   = 1000
--        FREQUENCY      = MONTHLY
--        START_TIMESTAMP = IMMEDIATELY
--   TRIGGERS
--     ON 80 PERCENT DO NOTIFY
--     ON 100 PERCENT DO SUSPEND_IMMEDIATE;
--
-- ALTER ACCOUNT SET RESOURCE_MONITOR = account_monitor;

-- ============================================================
-- STEP 6: リソースモニターの変更
-- ============================================================
ALTER RESOURCE MONITOR dev_monitor
  SET CREDIT_QUOTA = 200;

SHOW RESOURCE MONITORS;

-- ============================================================
-- STEP 7: ウェアハウスからモニターを解除
-- ============================================================
-- ALTER WAREHOUSE COMPUTE_WH UNSET RESOURCE_MONITOR;

-- ============================================================
-- STEP 8: 後片付け
-- ============================================================
DROP RESOURCE MONITOR IF EXISTS dev_monitor;
