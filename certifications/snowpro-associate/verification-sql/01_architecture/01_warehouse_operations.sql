-- ============================================================
-- 01_warehouse_operations.sql
-- 対応まとめ: 01_アーキテクチャ基礎.md § 3. Virtual Warehouse
-- 目的: Warehouseの作成・サイズ変更・停止・再開・削除を体験する
-- ============================================================

-- ============================================================
-- STEP 1: Warehouseの作成
-- AUTO_SUSPEND=300（5分）、AUTO_RESUME=TRUE が推奨設定
-- ============================================================
CREATE WAREHOUSE IF NOT EXISTS verify_wh
  WAREHOUSE_SIZE = 'X-SMALL'
  AUTO_SUSPEND   = 300
  AUTO_RESUME    = TRUE
  INITIALLY_SUSPENDED = TRUE
  COMMENT = '検証用 Warehouse';

-- ============================================================
-- STEP 2: Warehouseの一覧確認
-- SIZE, STATE, AUTO_SUSPEND 列に注目する
-- ============================================================
SHOW WAREHOUSES;

-- ============================================================
-- STEP 3: 使用するWarehouseを指定
-- ============================================================
USE WAREHOUSE verify_wh;

-- ============================================================
-- STEP 4: Warehouseのサイズをスケールアップ
-- サイズ変更は即座に反映される（再起動不要）
-- ============================================================
ALTER WAREHOUSE verify_wh SET WAREHOUSE_SIZE = 'SMALL';

-- 変更後の状態を確認
SHOW WAREHOUSES LIKE 'VERIFY_WH';

-- ============================================================
-- STEP 5: Warehouseを手動で停止・再開する
-- ============================================================
ALTER WAREHOUSE verify_wh SUSPEND;
-- → STATE が SUSPENDED になることを確認

ALTER WAREHOUSE verify_wh RESUME;
-- → STATE が STARTED になることを確認

-- ============================================================
-- STEP 6: AUTO_SUSPEND / AUTO_RESUME の設定変更
-- ============================================================
ALTER WAREHOUSE verify_wh SET
  AUTO_SUSPEND = 60    -- 1分でサスペンド（検証用に短く設定）
  AUTO_RESUME  = TRUE;

-- ============================================================
-- STEP 7: Warehouseの削除（後片付け）
-- ============================================================
DROP WAREHOUSE IF EXISTS verify_wh;
