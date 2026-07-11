# Badge 4: SQL リファレンス

## データベース・スキーマの作成

```sql
create or replace database ZENAS_ATHLEISURE_DB;
create or replace schema ZENAS_ATHLEISURE_DB.PRODUCTS;
```

## ファイルフォーマットの作成

```sql
-- セミコロン区切り（サイズ一覧用）
create or replace file format zmd_file_format_1
    record_delimiter = ';'
    trim_space = TRUE;

-- セミコロン＋パイプ区切り（商品ライン用）
create or replace file format zmd_file_format_2
    record_delimiter = ';'
    field_delimiter = '|'
    trim_space = TRUE;

-- キャレット＋イコール区切り（コーディネート提案用）
create or replace file format zmd_file_format_3
    record_delimiter = '^'
    field_delimiter = '='
    trim_space = TRUE;
```

## ステージからのクエリ

```sql
-- ステージ内ファイルの一覧
list @PRODUCT_METADATA;

-- ステージから直接クエリ（$1, $2 表記）
select $1
from @PRODUCT_METADATA/swt_product_line.txt
    (file_format => ZMD_FILE_FORMAT_2);

-- メタデータ列の利用
select metadata$filename, count(metadata$file_row_number) as row_count
from @SWEATSUITS
group by metadata$filename;
```

## ビューの作成（非ロードデータ）

```sql
-- サイズ一覧ビュー
create or replace view sweatsuit_sizes as
select replace($1, chr(13)||chr(10)) as sizes_available
from @PRODUCT_METADATA/sweatsuit_sizes.txt
    (file_format => ZMD_FILE_FORMAT_1)
where sizes_available <> '';

-- 商品ラインビュー
create or replace view sweatband_product_line as
select replace($1, '\r\n') as product_code,
       $2 as headband_description,
       $3 as wristband_description
from @PRODUCT_METADATA/swt_product_line.txt
    (file_format => ZMD_FILE_FORMAT_2);

-- コーディネート提案ビュー
create or replace view sweatband_coordination as
select $1 as product_code,
       $2 as has_matching_sweatsuit
from @PRODUCT_METADATA/product_coordination_suggestions.txt
    (file_format => ZMD_FILE_FORMAT_3);
```

## ディレクトリテーブル

```sql
-- ステージ内ファイルのメタデータ取得
select * from directory(@SWEATSUITS);

-- ファイル名から商品名を生成
select initcap(replace(replace(relative_path, '_', ' '), '.png')) as product_name
from directory(@SWEATSUITS);
```

## テーブル作成とデータ投入

```sql
-- 商品マスタテーブル
create or replace table sweatsuits(
    color_or_style varchar(25),
    file_name varchar(50),
    price number(5,2)
);

insert into sweatsuits values
 ('Burgundy', 'burgundy_sweatsuit.png', 65),
 ('Charcoal Grey', 'charcoal_grey_sweatsuit.png', 65),
 ...;

-- アップセル対応テーブル
create or replace table upsell_mapping(
    sweatsuit_color_or_style varchar(25),
    upsell_product_code varchar(10)
);
```

## JOIN によるビュー構築

```sql
-- テーブル × ディレクトリテーブルのJOIN
create view product_list as
select initcap(replace(replace(d.relative_path,'_',' '),'.png')) as product_name,
       t.file_name, t.color_or_style, t.price, d.file_url
from sweatsuits t
join directory(@SWEATSUITS) d
  on t.color_or_style = replace(product_name, ' Sweatsuit');

-- CROSS JOIN で全組み合わせ
create or replace view catalog as
select * from product_list
cross join sweatsuit_sizes;
```

## Webカタログビュー（集大成）

```sql
create view catalog_for_website as
select color_or_style, price, file_name,
  get_presigned_url(@sweatsuits, file_name, 3600) as file_url,
  size_list,
  coalesce('Consider: ' || headband_description || ' & ' || wristband_description,
           'Consider: White, Black or Grey Sweat Accessories') as upsell_product_desc
from (
  select color_or_style, price, file_name,
    listagg(sizes_available, ' | ') within group (order by sizes_available) as size_list
  from catalog
  group by color_or_style, price, file_name
) c
left join upsell_mapping u on u.sweatsuit_color_or_style = c.color_or_style
left join sweatband_coordination sc on sc.product_code = u.upsell_product_code
left join sweatband_product_line spl on spl.product_code = sc.product_code;
```
