# 📓 データとやり取りする他の方法！

## 📓 データ行を作成したりデータとやり取りする他の方法

このレッスンでは、**Snowflakeノートブック**（Snowflake Notebook）と **Streamlit-in-Snowflake**（SiS）のデータ入力フォームの作成と使用方法を学びます。

まず、データを入力するための新しいテーブルを作成しましょう。

---

## 🥋 VEGETABLE_DETAILSテーブルからCREATE TABLEコードをコピーする

---

# 🥋 Snowflakeノートブックを作成する

## 🥋 Snowflakeノートブックを作成してマークダウンセルを追加する

> **注意:** ノートブック名にアポストロフィを含めることはできなくなりました。代わりに「Uncle Yers Root Depth Notebook」という名前を使用してください。

---

## 📓 マークダウン（Markdown）とは？

**マークダウン**（Markdown）はプレーンテキストの記号を使ってテキストをフォーマットする方法です。マークダウンについては多くの場所で読むことができますし、Snowflakeドキュメントでも確認できます。

自由にマークダウンを探索してみてください。

---

## 🥋 サンプルセルを削除する

**マークダウンセルのみ**が残るまで、このプロセスを繰り返してください。

---

# 🥋 ノートブックにセルを追加する

## 🥋 SQLセルを追加して名前を付ける

## 🥋 ノートブックセルにINSERT文を入力する

```sql
insert into garden_plants.flowers.flower_details
select 'Petunia','M';
```

## 🥋 INSERT文を貼り付けてセルを実行する

---

## 🎯 新しいセルを作成してSELECT *を入力する

- 新しいSQLセルを作成する
- 「check_the_table」と名前を付ける
- **flower_details** テーブルに対するSELECT *文を記述する
- セルを実行する

---

# 🥋 ノートブックで変数を使用する

## 🎯 さらに2つのセルを作成してセルを並べ替える

3つのSQLセルを追加で作成してください。

- 1つ目を「set_flower_name」と名前を付ける（中身は空のまま）
- 2つ目を「set_root_depth_code」と名前を付ける（中身は空のまま）
- 3つ目を「check_my_variables」と名前を付ける（中身は空のまま）

セルを並べ替えてください。

---

## 🥋 新しいSQLセルに内容を入力して実行する

```sql
set rdc = 'S';
set fn = 'Lilac';
select $fn, $rdc;
```

---

## 🥋 花の名前と根の深さコードを変数に置き換える

---

## 🥋 最後のセルを実行してINSERTを確認する

---

# 🥋 ノートブックの仕上げ

## 🥋 マークダウンセルを編集する

ノートブックはプロセスフローを他の人と共有するために使えます。TsaiはUncle Yerが異なるプロセスタスクのやり方を覚えておけるよう、いくつかのノートブックをセットアップするかもしれません。

---

## 🎯 ノートブックを使ってFlower Detailテーブルに3行追加する

- **Sunflower** — 深い根（Deep）
- **Lavender** — 浅い根（Shallow）
- **Tulip** — 球根であり根ではないが、中程度の根の深さ（Medium）とする

---

## 🥋 最後のセルを実行して挿入した行を確認する

---

# 🤖 DORA DWW08

> ⚠️ **DORAコードは絶対に編集しないでください。** グリーンチェックを得るためにDORAコードを変更するのではなく、ラボ作業を修正してください。

ワークシートのロールを **ACCOUNTADMIN** に、データベースとスキーマをGRADER関数のある場所に設定してください。

```sql
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from ( 
   SELECT 'DWW08' as step 
   ,( select iff(count(*)=0, 0, count(*)/count(*))
      from table(information_schema.query_history())
      where query_text like 'execute NOTEBOOK%Uncle Yer%') as actual 
   , 1 as expected 
   , 'Notebook success!' as description 
); 
```

---

# 🥋 SiSフォームを作成する

## 🎯 Fruit Detailsテーブルを作成する — 他の2つのDetailsテーブルをモデルにする

---

## 🥋 Streamlit-in-Snowflakeデータ入力フォームを作成する

---

## 🥋 サンプルコードの大部分を削除する

コード側の画面で、18行目から最後までのすべてのコードを削除してください。そして左上隅の「Run」をクリックします。

---

# 🥋 SiSフォームでデータ入力を有効化する

## 🥋 フォームのタイトルと説明行を編集する

編集するたびに、右上隅の「Run」ボタンをクリックしてください。

---

## 🥋 入力フィールドを追加する

```python
st.text_input('Fruit Name:')
st.selectbox('Root Depth:', ('S','M','D'))
```

---

## 📓 入力をキャプチャする変数を追加する

ノートブックでは2つの変数を宣言しました。花の名前には「fn」、根の深さコードには「rdc」という変数名を使いました。

このStreamlitフォームでは、SQLコードではなく**Python**を書いているため、SETキーワードは不要です。代わりに以下のように書きます：

```python
fn =
```

および

```python
rdc =
```

入力コードの前に置くと、フィールドに入力された内容が変数に格納されます。

---

# 🥋 フォーム入力のキャプチャ

## 🎯 変数fnとrdcを設定する

- **Fruit Name** フィールドに入力された内容が **fn** という変数に格納されるようにコードを変更してください。
- **Root Depth** セレクトボックスで選択された内容が **rdc** という変数に格納されるようにコードを変更してください。

---

## 🥋 送信ボタンを追加する

```python
if st.button('Submit'):
    st.write('Fruit Name entered is ' + fn)
    st.write('Root Depth Code chosen is ' + rdc)
```

---

## 📓 Pythonの規約

Pythonでは、if文の後に同じレベルでインデントされたすべての行が実行されます。少なくとも1行のインデントされた行が必要です。

インデントされた行がない場合、そのIF文は存在する意味がありません。赤い矢印やアンダーラインの破線が表示された場合、Pythonがインデントについて混乱しています。

一般的にPythonはインデントに非常に厳格です（SQLは気にしません！）。

ほとんどのPythonエディタでは、ある行でタブを使い別の行で4つのスペースを使うことはできません。一貫性が必要です。ただし、**Streamlit-in-Snowflake**（SiS）はこれを自動的に処理してくれます。

---

# 🥋 INSERT文を準備する

## 🥋 データベースにデータを書き込む準備をする

ifブロックの一部として以下の行を追加してください。

```python
sql_insert = 'insert into garden_plants.fruits.fruit_details select '+fn+','+rdc
st.write(sql_insert)
```

---

## 📓 エスケープ文字（Escape Character）

INSERT文を構築するために、文字列と変数を使いました。文字列と変数の間には + 記号がありました。文字列部分はシングルクォートで囲まれていました。しかし、出力にシングルクォートを追加する必要があります。Pythonに対して、どのシングルクォートが文字列を囲んでいて、どのシングルクォートが文字列の一部であるかをどう伝えるのでしょうか？

コーディングでは、ジョブを実行している記号（文字列の囲みなど）と、出力の一部として必要な記号を区別するために、**エスケープ文字**（Escape Character）を前に付けます。

エスケープ文字は「次に見る文字は文字通りに解釈してください。ここではジョブを実行していません」という意味です。

Pythonでのエスケープ文字は**バックスラッシュ**（\）です。

以下のコードはPythonにとって紛らわしいです：

```python
my_greeting_string = 'Hello ma'am'
```

しかし、ma'amのアポストロフィにバックスラッシュを追加すると意味が通ります：

```python
my_greeting_string = 'Hello ma\'am'
```

「H」の前のクォートと「m」の後のクォートは挨拶を囲むジョブを実行しています。ma'amの中のクォートは挨拶の一部です。

---

## 🥋 INSERT文を修正する

---

# 🥋 入力内容をデータベースに書き込む

## 🥋 一部のwrite行をコメントアウトする

行を削除することもできますが、コメントアウトしておけば、トラブルシューティングが必要な場合に簡単に元に戻せます。

---

## 🥋 SQLを実行して結果メッセージを確認する

`st.write(sql_insert)` の行をコメントアウトしてください。

以下の2行を追加し、アプリを実行して（Submitボタンをクリックして）ください：

```python
result = session.sql(sql_insert)
st.write(result)
```

---

## 🎯 Fruit Detailsテーブルを確認してさらに行を追加する

SiSアプリ／入力フォームから移動して、**FRUIT_DETAILS** テーブルに行が追加されたか確認してください。

アプリが動作することを確認したら、さらに2行追加してください（合計3行）。

任意のフルーツ名と根の深さの設定を使用できます。

---

# 🤖 DORA DWW09

> ⚠️ **DORAコードは絶対に編集しないでください。** グリーンチェックを得るためにDORAコードを変更するのではなく、ラボ作業を修正してください。

GRADER関数を実行するために必要なコンテキストメニューを設定してください。

ワークシートのロールを **ACCOUNTADMIN** に、データベースとスキーマをGRADER関数のある場所に設定してください。

```sql
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW09' as step
 ,( select iff(count(*)=0, 0, count(*)/count(*)) 
    from snowflake.account_usage.query_history
    where query_text like 'execute streamlit "GARDEN_PLANTS"."FRUITS".%'
   ) as actual
 , 1 as expected
 ,'SiS App Works' as description
); 
```

---

# 🏁 まとめと次のステップ

Snowflakeノートブックの詳細については、Snowflakeドキュメントの「About Snowflake Notebooks」を参照してください。

Streamlit in Snowflakeの詳細については、Snowflakeドキュメントの「About Streamlit in Snowflake」を参照してください。

ここまでのすべてのタスクとDORAテストを完了していれば、次のセクションに進む準備ができています！
