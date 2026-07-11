/* 各ビューのデータ確認用クエリ — ファイルフォーマットとビューが正しく作成されたか検証する */

-- コーディネート提案ビューの確認（商品コードとスウェットスーツのマッチング有無）
select product_code, has_matching_sweatsuit
from zenas_athleisure_db.products.sweatband_coordination;

-- 商品ラインビューの確認（商品コード・ヘッドバンド説明・リストバンド説明）
select product_code, headband_description, wristband_description
from zenas_athleisure_db.products.sweatband_product_line;

-- スウェットスーツのサイズ一覧ビューの確認
select sizes_available
from zenas_athleisure_db.products.sweatsuit_sizes;