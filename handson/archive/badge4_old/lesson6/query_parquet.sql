-- parquetファイルのデータを確認するクエリ
select
    *
from
    @MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.TRAILS_PARQUET (
        file_format => MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.FF_PARQUET
    );

-- cherry_creek_trailビューを作成（parquetデータからポイント情報を抽出）
    create
    or replace view cherry_creek_trail as
select
    $1 ['sequence_1']::INTEGER as point_id,
    $1 ['trail_name']::VARCHAR as trail_name,
    $1 ['latitude']::NUMBER(11, 8) as lng,
    $1 ['longitude']::NUMBER(11, 8) as lat,
from
    @MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.TRAILS_PARQUET (
        file_format => MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.FF_PARQUET
    )
order by
    point_id;

-- 座標ペアとトレイルポイントを生成するクエリ
select
    top 100 -- limit 100と同じ
    lng || ' ' || lat as coord_pair,
    -- ||で半角スペースとlng, latを結合
    'POINT(' || coord_pair || ')' as trail_point
from
    cherry_creek_trail;

-- 座標ペアをビューに追記
    create
    or replace view cherry_creek_trail as
select
    $1:sequence_1 as point_id,
    $1:trail_name::varchar as trail_name,
    $1:latitude::number(11, 8) as lng,
    $1:longitude::number(11, 8) as lat,
    lng || ' ' || lat as coord_pair
from
    @trails_parquet (file_format => ff_parquet)
order by
    point_id;


select
    'LINESTRING(' || listagg(coord_pair, ',') within group (
        order by
            point_id
    ) || ')' as my_linestring
from cherry_creek_trail
where point_id <= 2450
group by trail_name;