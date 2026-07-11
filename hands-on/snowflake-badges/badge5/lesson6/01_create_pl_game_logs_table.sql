/*
 * パイプライン用ゲームログテーブル (PL_GAME_LOGS) の作成とデータロード
 * 外部ステージからJSONログを取り込み、RAWスキーマに格納する
 */

drop table AGS_GAME_AUDIENCE.RAW.PL_GAME_LOGS;

-- テーブルを作成する
create or replace table AGS_GAME_AUDIENCE.RAW.PL_GAME_LOGS (
	RAW_LOG VARIANT
);

-- パイプライン用ステージ内の特定ログファイルの存在を確認
list @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE_PIPELINE;

-- ステージ上のJSONファイルの中身をプレビューする
select $1
from @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE_PIPELINE/logs_101_110_0_0_0.json;

-- パイプライン用ステージから追加のログデータをテーブルにロードする
copy into AGS_GAME_AUDIENCE.RAW.PL_GAME_LOGS
from @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE_PIPELINE
file_format = (format_name = AGS_GAME_AUDIENCE.RAW.FF_JSON_LOGS);

select *
from AGS_GAME_AUDIENCE.RAW.PL_GAME_LOGS;