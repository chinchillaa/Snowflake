/* スウェットバンドのコーディネート提案データを読み込むためのフォーマット定義とビュー作成 */

-- キャレット(^)区切り・イコール(=)区切りのファイルフォーマットを作成（前後の空白を除去）
create
or replace file format ZENAS_ATHLEISURE_DB.PRODUCTS.zmd_file_format_3 record_delimiter = '^' field_delimiter = '=' trim_space = TRUE;

-- ステージ内のファイル一覧を確認
list @ZENAS_ATHLEISURE_DB.PRODUCTS.PRODUCT_METADATA;

-- 商品コードとスウェットスーツとのマッチング有無を表示するビューを作成
create
or replace view zenas_athleisure_db.products.SWEATBAND_COORDINATION as(
    select
        $1 as product_code,
        $2 as has_matching_sweatsuit
    from
        @ZENAS_ATHLEISURE_DB.PRODUCTS.PRODUCT_METADATA/product_coordination_suggestions.txt (
            file_format => ZENAS_ATHLEISURE_DB.PRODUCTS.ZMD_FILE_FORMAT_3
        )
);