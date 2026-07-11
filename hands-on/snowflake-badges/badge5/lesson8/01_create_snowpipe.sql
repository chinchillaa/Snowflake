/*
  Snowpipeの作成: 外部ステージに新しいJSONログファイルが到着した際に
  自動的にED_PIPELINE_LOGSテーブルへ取り込むパイプを定義する。
  AWS SNS通知をトリガーとして自動インジェストを実行する。
*/
create or replace pipe AGS_GAME_AUDIENCE.RAW.pipe_get_new_files
auto_ingest = true                                                          -- SNS通知で自動取り込みを有効化
aws_sns_topic = 'arn:aws:sns:us-west-2:321463406630:dngw_topic'             -- 自動インジェスト用のSNSトピックARN
as
copy into AGS_GAME_AUDIENCE.RAW.ED_PIPELINE_LOGS
from (
select
    METADATA$FILENAME as log_file_name                                      -- 取り込み元のファイル名
  , METADATA$FILE_ROW_NUMBER as log_file_row_id                             -- ファイル内の行番号
  , current_timestamp(0) as load_ltz                                        -- データ取り込み時刻（ローカルタイムゾーン）
  , get($1,'datetime_iso8601')::timestamp_ntz as DATETIME_ISO8601           -- JSONからISO8601形式の日時を抽出
  , get($1,'user_event')::text as USER_EVENT                                -- ユーザーイベント種別
  , get($1,'user_login')::text as USER_LOGIN                                -- ユーザーログイン名
  , get($1,'ip_address')::text as IP_ADDRESS                                -- アクセス元IPアドレス
  FROM @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE_PIPELINE                         -- JSONログが格納された外部ステージ
)
file_format = (format_name = AGS_GAME_AUDIENCE.RAW.FF_JSON_LOGS);           -- JSON形式のファイルフォーマットを指定