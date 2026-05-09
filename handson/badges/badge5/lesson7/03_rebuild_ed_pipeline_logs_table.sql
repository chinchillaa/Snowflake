/*
 * ED_PIPELINE_LOGS テーブルを再構築するスクリプト
 * 既存データを削除し、ステージからJSON形式のログファイルを再読み込みする
 */

-- テーブルの全データを削除（再ロード前の初期化）
truncate table AGS_GAME_AUDIENCE.RAW.ED_PIPELINE_LOGS;

-- ステージからメタデータ付きでログデータを一括ロード
copy into AGS_GAME_AUDIENCE.RAW.ED_PIPELINE_LOGS
from (
select
    metadata$filename as log_file_name,        -- ソースファイル名（メタデータから取得）
    metadata$file_row_number as log_file_row_id,  -- ファイル内の行番号
    current_timestamp(0) as load_ltz,              -- ロード実行時刻（ローカルタイムゾーン）
    get($1, 'datetime_iso8601')::timestamp_ntz as datetime_iso8601, -- イベント発生日時（ISO8601形式）
    get($1, 'user_event')::text as user_event,   -- ユーザーイベント種別（login/logoutなど）
    get($1, 'user_login')::text as user_login,   -- ユーザーログイン名
    get($1, 'ip_address')::text as ip_address     -- ユーザーのIPアドレス
from @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE_PIPELINE -- パイプライン用の外部ステージ
)
file_format =(format_name = AGS_GAME_AUDIENCE.RAW.FF_JSON_LOGS); -- JSONログ用のファイルフォーマット