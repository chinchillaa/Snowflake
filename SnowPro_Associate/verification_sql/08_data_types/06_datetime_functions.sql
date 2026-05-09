-- ============================================================
-- 06_datetime_functions.sql
-- 対応まとめ: 08_データ型_SQL基礎.md § 4. 日付・時刻関数
-- 目的: 日付加減算、切り捨て、抽出を確認する
-- ============================================================

SELECT
  CURRENT_DATE() AS current_date,
  CURRENT_TIMESTAMP() AS current_ts,
  DATEADD(day, 7, CURRENT_DATE()) AS plus_7_days,
  DATEDIFF(day, '2026-04-01'::DATE, '2026-04-10'::DATE) AS diff_days,
  DATE_TRUNC(month, '2026-04-29 12:34:56'::TIMESTAMP_NTZ) AS month_start,
  EXTRACT(year FROM '2026-04-29'::DATE) AS year_num,
  EXTRACT(dow FROM '2026-04-29'::DATE) AS day_of_week;
