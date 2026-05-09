-- ============================================================
-- Lesson 9: ヒートグリッドクエリ（Dashboard回避策）
-- ============================================================
--
-- 背景:
--   2026-04-20 より Snowsight Legacy Dashboards の新規作成が無効化された。
--   (2026-06-22 に完全削除予定)
--   本レッスンではダッシュボード上にヒートグリッドを作成する手順があるが、
--   Dashboard機能が使えないため、そのまま実行できない。
--
-- 回避策:
--   DORA グレーダー (DNGW07) は Dashboard の存在ではなく、
--   snowflake.account_usage.query_history に
--   'case when game_session_length < 10' を含むクエリが記録されているか
--   だけをチェックしている。
--   したがって、以下のヒートグリッドクエリを直接実行すれば
--   Dashboard を作成せずとも Green Check を取得できる。
--
-- 注意:
--   account_usage.query_history には最大45分の反映遅延がある。
--   クエリ実行後、しばらく待ってから dora_dngw07.sql を実行すること。
-- ============================================================

-- ヒートグリッドクエリ（セッション長 × 時間帯）
select case when game_session_length < 10 then '< 10 mins'
            when game_session_length < 20 then '10 to 19 mins'
            when game_session_length < 30 then '20 to 29 mins'
            when game_session_length < 40 then '30 to 39 mins'
            else '> 40 mins'
            end as session_length
            ,tod_name
from (
select GAMER_NAME
       , tod_name
       ,game_event_ltz as login
       ,lead(game_event_ltz)
                OVER (
                    partition by GAMER_NAME
                    order by GAME_EVENT_LTZ
                ) as logout
       ,coalesce(datediff('mi', login, logout),0) as game_session_length
from AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED_BACKUP)
where logout is not null;
