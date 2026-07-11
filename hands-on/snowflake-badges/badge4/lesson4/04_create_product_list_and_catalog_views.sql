/* 商品テーブルとステージのディレクトリテーブルを結合し、
   商品カタログ用のビューを作成するクエリ集 */

-- 商品テーブルとディレクトリテーブルを結合して商品一覧ビューを作成
create view ZENAS_ATHLEISURE_DB.PRODUCTS.product_list as
select
    initcap(
        replace(replace(d.relative_path, '_', ' '), '.png')
    ) as product_name, -- ファイル名から商品名を生成
    t.file_name,
    t.color_or_style,
    t.price,
    d.file_url -- 画像への参照URL
from
    ZENAS_ATHLEISURE_DB.PRODUCTS.SWEATSUITS t
    join directory(@ZENAS_ATHLEISURE_DB.PRODUCTS.SWEATSUITS) d on t.COLOR_OR_STYLE = replace(product_name, ' Sweatsuit'); -- 色名で結合

-- 商品一覧とサイズをクロス結合して全組み合わせのカタログビューを作成
create or replace view ZENAS_ATHLEISURE_DB.PRODUCTS.catalog as
select *
from ZENAS_ATHLEISURE_DB.PRODUCTS.PRODUCT_LIST p
cross join ZENAS_ATHLEISURE_DB.PRODUCTS.SWEATSUIT_SIZES;

-- カタログの総レコード数を確認
select count(*)
from ZENAS_ATHLEISURE_DB.PRODUCTS.CATALOG;