/* スウェットスーツの商品マスタテーブルを作成し、初期データを投入する */

-- 商品テーブルを作成
create or replace table ZENAS_ATHLEISURE_DB.PRODUCTS.sweatsuits(
    color_or_style varchar(25),
    file_name varchar(50),
    price number(5, 2)  -- 最大5桁,小数2桁
);

-- 10色のスウェットスーツデータを投入
insert into ZENAS_ATHLEISURE_DB.PRODUCTS.sweatsuits(
    color_or_style,
    file_name,
    price
)
values
 ('Burgundy', 'burgundy_sweatsuit.png',65)
,('Charcoal Grey', 'charcoal_grey_sweatsuit.png',65)
,('Forest Green', 'forest_green_sweatsuit.png',64)
,('Navy Blue', 'navy_blue_sweatsuit.png',65)
,('Orange', 'orange_sweatsuit.png',65)
,('Pink', 'pink_sweatsuit.png',63)
,('Purple', 'purple_sweatsuit.png',64)
,('Red', 'red_sweatsuit.png',68)
,('Royal Blue',	'royal_blue_sweatsuit.png',65)
,('Yellow', 'yellow_sweatsuit.png',67);
