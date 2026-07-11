-- ============================================================
-- 08_ステージとファイルフォーマット.sql
-- Snowflake DWW Badge 1 - ステージ・ファイルフォーマット・COPY INTO
-- ============================================================
-- 【概要】
-- ファイルから Snowflake テーブルにデータをロードする手順：
--   1. ステージ（Stage）にファイルをアップロード
--   2. ファイルフォーマット（File Format）を定義
--   3. COPY INTO 文でステージからテーブルにロード
--
-- ステージとは：
--   ファイルを一時的に置く「待合室」のような場所。
--   Snowflake の内部ステージは S3/Azure/GCS のストレージに紐付く。
--
-- 内部ステージの種類：
--   @~           : ユーザーステージ（ユーザー専用、1ユーザー1つ）
--   @%テーブル名 : テーブルステージ（テーブル専用）
--   @ステージ名  : 名前付きステージ（任意に作成・共有可能）← このレッスンで使用
--
-- COPY INTO に必要な4要素：
--   ① テーブル（ロード先）
--   ② ステージ（ファイルの置き場）
--   ③ ファイル（ロードするファイル名）
--   ④ ファイルフォーマット（区切り文字などの定義）
-- ============================================================


-- ============================================================
-- 1. ファイルフォーマットの作成
-- ============================================================

-- ── 1-A: パイプ区切り・1ヘッダー行スキップ ──
-- 【目的】パイプ（|）で区切られたファイルをロードするためのフォーマット
-- 【注意】CSV type はカンマ以外の区切り文字にも対応する
--          TSV・パイプ区切り・スペース区切りすべて TYPE = 'CSV' で定義する

create file format garden_plants.veggies.PIPECOLSEP_ONEHEADROW
    type = 'CSV'          -- type: CSV は "Comma Separated Values" の略
                          -- ただし実際はあらゆる区切り文字のフラットファイルに使う
    field_delimiter = '|' -- field_delimiter: フィールド（列）の区切り文字
    skip_header = 1       -- skip_header: スキップするヘッダー行数（先頭1行を無視）
    ;


-- ── 1-B: カンマ区切り・ダブルクォート対応・1ヘッダー行スキップ ──
-- 【目的】カンマを含む値をダブルクォートで囲んだファイルに対応する
-- 【使用場面】"Tomato, Heirloom" のようなカンマ入りの値を正しく読み込む

create file format garden_plants.veggies.COMMASEP_DBLQUOT_ONEHEADROW
    TYPE = 'CSV'
    FIELD_DELIMITER = ','                -- カンマ区切り
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'  -- field_optionally_enclosed_by:
                                        -- 値をダブルクォートで囲むことを許可
    ;


-- ── 1-C: TSVファイル用（タブ区切り）──
-- 【目的】タブ文字で区切られた TSV ファイルをロードする
-- 【補足】\t は「タブ文字」を表すエスケープシーケンス
-- 【注意】Challenge Lab で作成する L9_CHALLENGE_FF はこの設定が正解

create file format garden_plants.veggies.L9_CHALLENGE_FF
    TYPE = 'CSV'
    FIELD_DELIMITER = '\t'   -- \t = tab（タブ文字）
    SKIP_HEADER = 1
    ;


-- ── 1-D: JSON ファイル用 ──
-- 【目的】JSON フォーマットのファイルをロードする
-- 【重要】strip_outer_array = true にすると、
--          JSON の配列 [] を無視して各要素を1行として読み込む
-- 　　　  false のままだと配列全体が1行になってしまう

create file format library_card_catalog.public.json_file_format
    type = 'JSON'
    compression = 'AUTO'      -- compression: 圧縮形式（AUTO=自動検出）
    enable_octal = FALSE      -- enable_octal: 8進数エスケープを有効にするか
    allow_duplicate = FALSE   -- allow_duplicate: 重複キーを許可するか
    strip_outer_array = TRUE  -- strip_outer_array: 外側の [] を除去するか
                              -- ← JSON配列を複数行に展開するにはここを TRUE にする
    strip_null_values = FALSE -- strip_null_values: null値のフィールドを除去するか
    ignore_utf8_errors = FALSE -- ignore_utf8_errors: UTF-8エラーを無視するか
    ;


-- ============================================================
-- 2. COPY INTO 文（ステージからテーブルへのロード）
-- ============================================================

-- ── 2-A: パイプ区切りファイルのロード ──
-- 【目的】VEG_NAME_TO_SOIL_TYPE_PIPE.txt を VEGETABLE_DETAILS_SOIL_TYPE にロード
-- 【構文解説】
--   copy into テーブル名          : ← ロード先のテーブル
--   from @ステージ名              : ← ファイルの置き場所（@は内部ステージの記法）
--   files = ('ファイル名')        : ← ロードするファイル名をシングルクォートで指定
--   file_format = (format_name=) : ← 使用するファイルフォーマット名

copy into vegetable_details_soil_type
from @util_db.public.my_internal_stage
files = ('VEG_NAME_TO_SOIL_TYPE_PIPE.txt')
file_format = (format_name = GARDEN_PLANTS.VEGGIES.PIPECOLSEP_ONEHEADROW);


-- ── 2-B: COPY INTO の汎用テンプレート ──
-- 【目的】COPY INTO の基本構文を覚えるためのテンプレート

copy into my_table_name
from @my_internal_stage
files = ('IF_I_HAD_A_FILE_LIKE_THIS.txt')
file_format = (format_name = 'EXAMPLE_FILEFORMAT');


-- ============================================================
-- 3. ステージ上のファイルを COPY INTO 前に確認する（プレビュー）
-- ============================================================
-- 【目的】ファイルをロードする前にフォーマットが正しいか確認する
-- 【動作】ステージのファイルを SELECT で直接クエリできる
-- 　　　  $1, $2, $3 は1列目、2列目、3列目を指す

-- ファイルフォーマット指定なし（生データとして確認）
select $1
from @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv;

-- ファイルフォーマットを指定して確認（解釈後のデータを確認）
select $1, $2, $3
from @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv
(file_format => garden_plants.veggies.COMMASEP_DBLQUOT_ONEHEADROW);

-- 別のフォーマットで確認（パイプ区切りとして解釈した場合）
select $1, $2, $3
from @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv
(file_format => garden_plants.veggies.PIPECOLSEP_ONEHEADROW);


-- ============================================================
-- 4. CREATE OR REPLACE FILE FORMAT（既存フォーマットの更新）
-- ============================================================
-- 【目的】ファイルフォーマットの設定を変更したいとき
-- 【動作】OR REPLACE を付けると既存フォーマットを上書き再定義できる

create or replace file format garden_plants.veggies.L9_CHALLENGE_FF
    TYPE = 'CSV'
    FIELD_DELIMITER = '\t'
    SKIP_HEADER = 1
    ;
