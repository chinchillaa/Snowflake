# ============================================================
# 07_Streamlit_データ入力フォーム.py
# Snowflake DWW Badge 1 - Streamlit-in-Snowflake (SiS) データ入力フォーム
# ============================================================
# 【概要】
# Streamlit-in-Snowflake (SiS) は Snowflake 上で動作する
# Python ベースのインタラクティブ UI フレームワーク。
# SQL ではなく Python で記述する。
#
# Notebook との違い：
#   Notebook  : SQL / Python / Markdown が混在可、データ分析向け
#   Streamlit : Python のみ、UI フォーム・ダッシュボード向け
#
# 【事前準備】
# 1. GARDEN_PLANTS.FRUITS.FRUIT_DETAILS テーブルが存在すること
#    （VEGETABLE_DETAILS と同じ構造で作成する）
#
# 【注意】このファイルは Snowflake の Streamlit エディタに
# 　　　  コピーして貼り付けて使用する
# ============================================================

import streamlit as st

# ============================================================
# 1. アプリのタイトルと説明
# ============================================================
# st.title() : 大見出しを表示する
# st.write() : テキストや変数の値を表示する

st.title("Uncle Yer's Fruit Data Entry")
st.write("Enter fruit name and root depth code below:")


# ============================================================
# 2. 入力フィールドの作成
# ============================================================
# st.text_input() : テキスト入力フィールドを作成する
#   引数: ラベルテキスト（画面に表示されるラベル名）
#   戻り値: ユーザーが入力した文字列
#
# st.selectbox() : ドロップダウン選択メニューを作成する
#   第1引数: ラベルテキスト
#   第2引数: 選択肢のタプル（tuple）
#   戻り値: ユーザーが選んだ値

fn = st.text_input('Fruit Name:')          # fn = fruit name（果物名）
rdc = st.selectbox('Root Depth:', ('S', 'M', 'D'))  # rdc = root depth code


# ============================================================
# 3. Submit ボタンと処理ロジック
# ============================================================
# st.button() : ボタンを作成する
#   戻り値: ボタンが押された場合 True、押されていない場合 False
#
# Python の if 文：ボタンが押されたときだけ以下のブロックを実行
# 【重要】Python はインデント（字下げ）がブロックを表す
#          インデントが揃っていないとエラーになる

if st.button('Submit'):

    # 入力値の確認表示（デバッグ用 → 後でコメントアウト）
    # st.write('Fruit Name entered is ' + fn)
    # st.write('Root Depth Code chosen is ' + rdc)

    # ============================================================
    # 4. INSERT 文の組み立て
    # ============================================================
    # 【目的】入力値を使って SQL の INSERT 文を文字列として作成する
    # 【注意】SQL 文字列内に ' (シングルクォート) を含める場合は
    # 　　　  エスケープ文字（バックスラッシュ \）を前に付ける
    # 　　　  例: 'ma\'am' → ma'am という文字列になる

    sql_insert = (
        "insert into garden_plants.fruits.fruit_details "
        "select '" + fn + "','" + rdc + "'"
    )

    # 組み立てた SQL を確認表示（デバッグ用 → 後でコメントアウト）
    # st.write(sql_insert)

    # ============================================================
    # 5. SQL の実行とフィードバック表示
    # ============================================================
    # session.sql() : Snowflake に SQL を送信して実行する
    #   引数: 実行する SQL 文字列
    #   戻り値: 実行結果オブジェクト（DataFrame）
    #
    # st.write(result) : 実行結果を画面に表示する

    result = session.sql(sql_insert)
    st.write(result)


# ============================================================
# 【補足】SiS で利用可能な主な Streamlit 関数
# ============================================================
# st.title(text)           : 大見出し
# st.write(value)          : 値をテキストとして表示（DataFrameも可）
# st.text_input(label)     : テキスト入力欄
# st.selectbox(label, opts): ドロップダウン選択
# st.button(label)         : クリックボタン（押すと True を返す）
# session.sql(sql)         : SQL を Snowflake で実行（SiS固有）
# ============================================================
