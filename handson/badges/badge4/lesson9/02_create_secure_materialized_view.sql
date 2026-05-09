/*
  セキュアマテリアライズドビュー SMV_CHERRY_CREEK_TRAIL を作成するスクリプト
  外部テーブル T_CHERRY_CREEK_TRAIL のParquetデータを整形し、
  各地点からメラニーズカフェまでの距離を算出して事前集計する
*/

-- セキュアマテリアライズドビューの作成（既存の場合は置き換え）
create or replace secure materialized view MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.SMV_CHERRY_CREEK_TRAIL(
	POINT_ID,
	TRAIL_NAME,
	LNG,
	LAT,
	COORD_PAIR,
    DISTANCE_TO_MELANIES -- メラニーズカフェまでの距離
) as
select 
 $1:sequence_1 as point_id, -- Parquetファイルから地点IDを取得
 $1:trail_name::varchar as trail_name, -- トレイル名
 $1:latitude::number(11,8) as lng, -- 経度
 $1:longitude::number(11,8) as lat, -- 緯度
 lng||' '||lat as coord_pair, -- 経度・緯度を結合した座標ペア
 MELS_SMOOTHIE_CHALLENGE_DB.LOCATIONS.DISTANCE_TO_MC(st_makepoint(lng, lat)) as distance_to_melanies -- UDFでメラニーズカフェまでの距離を計算
from MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.T_CHERRY_CREEK_TRAIL; -- 外部テーブルを参照