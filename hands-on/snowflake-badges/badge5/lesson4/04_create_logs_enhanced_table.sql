/*
 * IPアドレスからIP情報共有関数の動作を確認するクエリ群
 * ipinfo_geoloc共有データベースの関数を使い、IPアドレスを整数値に変換する動作を検証する
 */

-- IPアドレス変換関数の比較：to_join_key(), to_int(), parse_ip() の出力を並べて確認
select logs.ip_address,
ipinfo_geoloc.public.to_join_key(logs.ip_address),  -- IPアドレスからJOINキー（整数範囲の先頭部分）を生成
ipinfo_geoloc.public.to_int(logs.ip_address),  -- parse_ip(ip_address, 'inet'):ipv4と同一の値を返す？
parse_ip(logs.ip_address, 'inet'):ipv4  -- to_int()と同一の値を返す？
from ags_game_audience.raw.logs;  -- ゲームログテーブルからIPアドレスを取得

-- IPアドレスのジオロケーション情報と時間帯を結合し、ゲームイベントの詳細を取得するクエリ(create table as selectで固定テーブル化)
create or replace table AGS_GAME_AUDIENCE.ENHANCED.logs_enhanced as(
select logs.ip_address
, logs.user_login as gamer_name
, logs.user_event as game_event_name
, logs.datetime_iso8601 as game_event_utc
, city      -- IPアドレスから特定された都市
, region    -- IPアドレスから特定された地域
, country   -- IPアドレスから特定された国
, timezone as gamer_ltz_name  -- IPアドレスから特定されたタイムゾーン
, convert_timezone('UTC', timezone, logs.datetime_iso8601) as game_event_ltz  -- UTCからユーザーのローカルタイムゾーンに変換
, dayname(game_event_ltz) as dow_name  -- 曜日名を取得（Mon, Tue, ...）
, time_lu.tod_name as tod_name  -- 時間帯の名称（朝、昼、夜など）
from ags_game_audience.raw.logs logs
join ipinfo_geoloc.demo.location loc  -- IPジオロケーションデータとJOIN
on ipinfo_geoloc.public.to_join_key(logs.ip_address) = loc.join_key  -- JOINキーで絞り込み
and ipinfo_geoloc.public.to_int(logs.ip_address)
between start_ip_int and end_ip_int  -- IP整数値が範囲内かを判定
join AGS_GAME_AUDIENCE.RAW.TIME_OF_DAY_LU time_lu  -- 時間帯ルックアップテーブルとJOIN
on hour(game_event_ltz) = time_lu.hour  -- ローカル時刻の「時」でマッチング
-- where user_login like '%prince%'  -- デバッグ用フィルタ（特定ユーザーに絞り込む場合にコメント解除）
);
