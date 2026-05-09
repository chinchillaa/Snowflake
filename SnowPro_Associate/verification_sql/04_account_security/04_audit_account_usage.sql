-- ============================================================
-- 04_audit_account_usage.sql
-- 対応まとめ: 04_アカウント_セキュリティ.md § 6. 監査とモニタリング
--             および § 7. ACCOUNT_USAGE スキーマ
-- 目的: ACCOUNT_USAGE の各ビューを使った監査クエリを体験する
-- 注意: ACCOUNT_USAGE には最大 45分〜3時間の遅延がある
-- ============================================================

USE DATABASE SNOWFLAKE;
USE SCHEMA ACCOUNT_USAGE;

-- ============================================================
-- STEP 1: ACCOUNT_USAGE スキーマのビュー一覧を確認
-- ============================================================
SHOW VIEWS IN SCHEMA SNOWFLAKE.ACCOUNT_USAGE;

-- ============================================================
-- STEP 2: ログイン履歴（Login History）
-- 誰がいつどこからログインしたかを確認
-- ============================================================
SELECT
  user_name,
  client_ip,
  reported_client_type,
  is_success,
  error_message,
  event_timestamp
FROM login_history
WHERE event_timestamp >= DATEADD(DAY, -7, CURRENT_TIMESTAMP())
ORDER BY event_timestamp DESC
LIMIT 20;

-- 失敗したログインのみ（不正アクセス調査）
SELECT
  user_name,
  client_ip,
  error_message,
  event_timestamp
FROM login_history
WHERE event_timestamp >= DATEADD(DAY, -7, CURRENT_TIMESTAMP())
  AND is_success = 'NO'
ORDER BY event_timestamp DESC;

-- ============================================================
-- STEP 3: クエリ履歴（Query History）
-- ============================================================
-- 過去 24 時間のクエリをユーザー別・実行時間順で表示
SELECT
  user_name,
  LEFT(query_text, 80)                       AS query_snippet,
  execution_status,
  total_elapsed_time / 1000                  AS elapsed_sec,
  bytes_scanned / 1024 / 1024               AS mb_scanned,
  warehouse_name,
  start_time
FROM query_history
WHERE start_time >= DATEADD(HOUR, -24, CURRENT_TIMESTAMP())
ORDER BY total_elapsed_time DESC
LIMIT 20;

-- ============================================================
-- STEP 4: アクセス履歴（Access History）
-- どのテーブルに誰がいつアクセスしたかを確認
-- ============================================================
SELECT
  user_name,
  query_id,
  query_start_time,
  base_objects_accessed  -- アクセスされたテーブルの JSON
FROM access_history
WHERE query_start_time >= DATEADD(DAY, -7, CURRENT_TIMESTAMP())
ORDER BY query_start_time DESC
LIMIT 20;

-- ============================================================
-- STEP 5: ストレージ使用量（Storage Usage）
-- ============================================================
SELECT
  usage_date,
  storage_bytes / 1024 / 1024 / 1024  AS storage_gb,
  stage_bytes  / 1024 / 1024 / 1024  AS stage_gb,
  failsafe_bytes / 1024 / 1024 / 1024 AS failsafe_gb
FROM storage_usage
ORDER BY usage_date DESC
LIMIT 30;

-- ============================================================
-- STEP 6: Warehouse 使用量（コスト分析）
-- ============================================================
SELECT
  warehouse_name,
  SUM(credits_used)                       AS total_credits,
  SUM(credits_used_compute)               AS compute_credits,
  SUM(credits_used_cloud_services)        AS cloud_service_credits,
  DATE_TRUNC('DAY', start_time)           AS usage_date
FROM warehouse_metering_history
WHERE start_time >= DATEADD(DAY, -30, CURRENT_TIMESTAMP())
GROUP BY warehouse_name, usage_date
ORDER BY usage_date DESC, total_credits DESC;

-- ============================================================
-- STEP 7: テーブル別ストレージ（容量管理）
-- ============================================================
SELECT
  table_schema,
  table_name,
  ACTIVE_BYTES / 1024 / 1024    AS active_mb,
  TIME_TRAVEL_BYTES / 1024 / 1024 AS time_travel_mb,
  FAILSAFE_BYTES / 1024 / 1024  AS failsafe_mb
FROM table_storage_metrics
WHERE table_catalog = CURRENT_DATABASE()
ORDER BY ACTIVE_BYTES DESC
LIMIT 20;

-- ============================================================
-- STEP 8: ロール・権限の現在状態確認（ROLES ビュー）
-- ============================================================
SELECT
  name,
  owner,
  comment,
  created_on
FROM roles
WHERE deleted_on IS NULL
ORDER BY name;
