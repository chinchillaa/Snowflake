/*
  外部テーブル t_cherry_creek_trail を作成するスクリプト
  S3上のParquetファイルを外部ステージ経由で参照し、ファイル名をカラムとして公開する
*/

-- 外部テーブルの作成（既存の場合は置き換え）
create or replace external table MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.t_cherry_creek_trail(
my_filename varchar(100) as (metadata$filename::varchar(100)) -- メタデータからファイル名を仮想カラムとして取得
)
location = @MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.EXTERNAL_AWS_DLKW -- 外部ステージ（AWS S3）を参照
auto_refresh = true -- S3のイベント通知でメタデータを自動更新
file_format = (type = parquet); -- Parquet形式のファイルを読み込み

-- 作成した外部テーブルの内容を確認
select *
from MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.t_cherry_creek_trail;