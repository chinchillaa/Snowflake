/* ステージ内のファイル情報を確認するクエリ集
   SWEATSUITS ステージに格納されたファイルのメタデータを取得する */

-- ステージ内の全ファイル一覧を表示
list @ZENAS_ATHLEISURE_DB.PRODUCTS.SWEATSUITS;

-- ファイルごとの行数を集計
select metadata$filename, count(metadata$file_row_number) as row_count
from @ZENAS_ATHLEISURE_DB.PRODUCTS.SWEATSUITS
group by metadata$filename;