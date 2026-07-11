/* スウェットバンド商品ラインのファイルフォーマット定義とビュー作成
   ステージ上のテキストファイルを読み込むためのフォーマットとビューを設定する */

-- セミコロン区切り・パイプ区切りのファイルフォーマットを作成（前後の空白を除去）
create
or replace file format ZENAS_ATHLEISURE_DB.PRODUCTS.zmd_file_format_2 record_delimiter = ';' field_delimiter = '|' trim_space = TRUE;

-- ステージ内のファイル一覧を確認
list @ZENAS_ATHLEISURE_DB.PRODUCTS.PRODUCT_METADATA;

-- スウェットバンド商品ラインのビューを作成（ステージ上のテキストファイルを直接参照）
create
or replace view ZENAS_ATHLEISURE_DB.PRODUCTS.sweatband_product_line as (
    select
        replace($1, '\r\n') as product_code, -- 改行コード(CRLF)を除去して商品コードとする
        $2 as headband_description,
        $3 as wristband_description
    from
        @ZENAS_ATHLEISURE_DB.PRODUCTS.PRODUCT_METADATA/swt_product_line.txt (
            file_format => ZENAS_ATHLEISURE_DB.PRODUCTS.ZMD_FILE_FORMAT_2
        )
);