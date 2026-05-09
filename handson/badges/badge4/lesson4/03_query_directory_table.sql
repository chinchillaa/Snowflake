/* ステージ内のファイル情報を取得するクエリ集
   directory テーブル関数を使い、SWEATSUITS ステージのファイル一覧を操作する */

-- ステージ内の全ファイル情報を取得
select
    *
from
    directory(@ZENAS_ATHLEISURE_DB.PRODUCTS.SWEATSUITS);

-- ファイル名から商品名を段階的に整形する
select
    replace(relative_path, '_', ' ') as no_under_scores_filename, -- アンダースコアをスペースに置換
    replace(no_under_scores_filename, '.png') as just_words_filename, -- 拡張子を除去
    initcap(just_words_filename) as product_name -- 各単語の先頭を大文字に変換
from
    directory(@ZENAS_ATHLEISURE_DB.PRODUCTS.SWEATSUITS);

-- ネスト: 上記の段階的な変換を1行にまとめたバージョン
select initcap(replace(replace(relative_path, '_', ' '), '.png')) as product_name
from directory(@ZENAS_ATHLEISURE_DB.PRODUCTS.SWEATSUITS);