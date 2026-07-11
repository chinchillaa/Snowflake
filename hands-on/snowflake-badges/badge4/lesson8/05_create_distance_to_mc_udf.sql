/* 指定地点からメルズ・スムージー・チャレンジのメイン拠点（Monte Carlo）までの距離を計算するUDFを作成するスクリプト */

-- 経度・緯度を個別の数値引数として受け取るバージョン
create
or replace function MELS_SMOOTHIE_CHALLENGE_DB.LOCATIONS.distance_to_mc(loc_lng number(38, 32), loc_lat number(38, 32)) returns float as $$
        st_distance(
            st_makepoint('-104.97300245114094', '39.76471253574085'), -- Monte Carloの固定座標（経度, 緯度）
            st_makepoint(loc_lng, loc_lat) -- 比較対象の地点座標
        )
    $$;

-- テスト用の座標変数（Troubled Child の位置）
set tc_lng='-105.00532059763648'; 
set tc_lat='39.74548137398218';


-- GEOGRAPHY型を引数として受け取るバージョン（より柔軟な入力に対応）
CREATE OR REPLACE FUNCTION MELS_SMOOTHIE_CHALLENGE_DB.LOCATIONS.distance_to_mc(lng_and_lat GEOGRAPHY)
  RETURNS FLOAT
  AS
  $$
   st_distance(
        st_makepoint('-104.97300245114094','39.76471253574085') -- Monte Carloの固定座標
        ,lng_and_lat -- 比較対象のGEOGRAPHYポイント
        )
  $$
  ;

SELECT
 name
 ,cuisine
 ,distance_to_mc(coordinates) AS distance_to_melanies
 ,*
FROM  competition
ORDER by distance_to_melanies;