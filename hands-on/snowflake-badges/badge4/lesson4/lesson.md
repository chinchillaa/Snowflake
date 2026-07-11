# 📓 非ロードデータは簡単！

## 📓 非ロードデータをもっと活用しよう！

メタデータファイルのために**ファイルフォーマット**を作成し、それを使って**ビュー**を作りました。とても簡単でしたね？

---

Zena（とあなた）は、まず2つの**ステージ**オブジェクトを作成し、そこにファイルをアップロードするところから始めました。

Zenaはそのうちの1つ、**PRODUCT_METADATA**ステージに注力しました。このステージには**構造化データ**（Structured Data）ファイルのみが含まれています。**ファイルフォーマット**と**ビュー**を使って、データをSnowflakeテーブルにロードしなくても簡単にアクセスできることを学びました。

Zenaにはもう1つのステージがあります。次は**SWEATSUITS**ステージを使いたいのですが、このステージには画像が含まれています。

画像は**非構造化データ**（Unstructured Data）に分類されるため、フラットファイルと同じように簡単にアクセスできるかどうか気になるところです。

Zenaはとりあえず試してみることにしました！

---

## 🎯 SWEATSUITS ステージで LIST コマンドを実行する

**SWEATSUITS**ステージに対して**LIST**コマンドを実行してみましょう。

何が表示されますか？

> **続行するには正しい回答が必要です**

**問題:** 先ほど作成したSWEATSUITSステージでLISTコマンドを実行するとどうなりますか？

- [ ] 靴の画像が表示される
- [ ] 結果ペインにファイルの一覧が表示される
- [ ] エラーメッセージが出る
- [ ] ユニコードの文字化けが表示される

**[送信]**

---

# 📓 非構造化・非ロードデータ

## 📓 非構造化の非ロードデータをクエリしてみよう！

Zenaは**SWEATSUITS**ステージに焦点を移し、前のステージと同じ手順を繰り返す予定です。LISTコマンドでファイル一覧を確認できました。次は `$1`, `$2`, `$3` という方法で非ロード／外部データの列にアクセスしようとしていますが、うまくいくでしょうか？

データをクエリしたら、**ファイルフォーマット**を使ってデータを見やすくすることもできるのでしょうか？

しかし、エラーメッセージが出てしまいました！

---

## 🥋 非構造化データファイルをクエリしてみる

以下のSQLを実行してみましょう：

```sql
select $1
from @sweatsuits/purple_sweatsuit.png;
```

> **続行するには正しい回答が必要です**

**問題:** SWEATSUITステージのファイルに対して `SELECT $1` を実行するとどうなりますか？

- [ ] 靴の画像が表示される
- [ ] 結果ペインにファイルの一覧が表示される
- [ ] エラーメッセージが出る
- [ ] ユニコードの文字化けが表示される

**[送信]**

---

## 🥋 非ロード非構造化データのクエリ

### 🥋 何が起こっているのか？

Zenaは原因を探ることにしました。Snowflakeがファイルを半構造化データとして読み込もうとしているのではないかと推測し、簡単なテストを行いました。

画像ファイルをシンプルなテキストエディタで開くと、Snowflakeもテキストエディタと同じようなものを見ているのだろうと考えました。もっと良い方法が必要です。ファイルの中身を複数行に分割して表示するのではなく、ファイルの一覧を取得したいのです。

---

## 🥋 2つの組み込みメタデータ列を使ってクエリする

以下のSQLを実行してみましょう：

```sql
select metadata$filename, metadata$file_row_number
from @sweatsuits/purple_sweatsuit.png;
```

> **続行するには正しい回答が必要です**

**問題:** 上記のクエリは何を返しましたか？

- [ ] 別のブラウザウィンドウに画像が表示された
- [ ] Purple Sweatsuitファイルを表す1行が返された
- [ ] Purple Sweatsuitファイルを表す大量の行が返された
- [ ] UTF8の文字化けが表示された

**[送信]**

---

## 🎯 LIST コマンドに近い結果を返すクエリを書く

ファイル名で**GROUP BY**して、以下のような結果になるクエリを書けますか？

**MAX**関数や**COUNT**を使って、ステージ内の全ファイルの相対的なファイルサイズを把握してみましょう。

---

# 📓 ファイルフォーマット？ いいえ、ディレクトリテーブルです！

## 📓 非構造化データにファイルフォーマットは使えない

`SELECT $1` によるクエリ方法が非構造化データに使えないのと同様に、**ファイルフォーマット**も使えません。

ファイルフォーマットには6つの種類があります：

| フォーマット |
|---|
| CSV |
| JSON |
| XML |
| PARQUET |
| ORC |
| AVRO |

この中に「PDF」「Image」「PNG」「JPG」はありません。

画像にはもっと良い方法が必要です。幸い、その方法は存在します！

それが**ディレクトリテーブル**（Directory Table）です。ステージを作成したときに、ディレクトリテーブルが自動的にセットアップされています。気づかなかったかもしれませんが、有効な状態で存在しています。

---

## 🥋 ステージのディレクトリテーブルをクエリする

以下のSQLを実行してみましょう：

```sql
select * 
from directory(@sweatsuits);
```

> **続行するには正しい回答が必要です**

**問題:** ディレクトリテーブルのクエリはどの列を返しますか？

**6個選択してください:**

- [ ] MD5
- [ ] Relative Size
- [ ] Size
- [ ] ETag
- [ ] Last Modified
- [ ] File Path
- [ ] Relative Path
- [ ] URL
- [ ] File URL

**[送信]**

---

# 📓 ディレクトリテーブルで関数は使えるか？

## 📓 ディレクトリテーブルで関数は使える？

Zenaは、画像ファイルをフラットファイルと同じ方法ではクエリできないことを確認しました。また、ファイルに関する情報を取得するにはディレクトリテーブルを使うのが良いことも分かりました。次に気になるのは、ディレクトリテーブルでどこまでできるかということです。

列に対して関数を実行できるでしょうか？そして、データを見やすくする**SELECT**を作ったら、その上にビューを作れるでしょうか？

---

## 🥋 まずディレクトリテーブルで関数が動くか確認する

以下のSQLを実行してみましょう：

```sql
select REPLACE(relative_path, '_', ' ') as no_underscores_filename
, REPLACE(no_underscores_filename, '.png') as just_words_filename
, INITCAP(just_words_filename) as product_name
from directory(@sweatsuits);
```

---

## 📓 SnowflakeのクールなSQLトリック！

**AS**構文で定義した列を、同じSELECT文の次の行ですぐに使えることに気づきましたか？これは他の多くのデータベースシステムでは使えない機能で、複雑な構文を開発する際にとても便利です。

ZenaはSQLの初心者なので試してみたところ、うまくいきました！関数を**ネスト**（入れ子に）する代わりに3つの列を作ってゴールに到達できることは分かっています。テストが終わったので、次は関数を段階的にネストしていきます。

---

## 🎯 3つの関数を1つのステートメントにネストする

最初の1つは例として用意しています。

すべてを1つの列にネストして「**PRODUCT_NAME**」と名前を付けられますか？

最初からうまくいくとは限りません（SQL経験者でない限り）。関数を1つずつ追加して、次の関数に進んでください。各段階のコピーを保存しておくと、失敗したときに最後に成功したバージョンに戻れます。

> **続行するには正しい回答が必要です**

**問題:** ある関数を別の関数の中に入れることを何と呼びますか？

- [ ] コラプシング（Collapsing）
- [ ] トランケーティング（Truncating）
- [ ] コアレッシング（Coalescing）
- [ ] ネスティング（Nesting）

**[送信]**

---

# 🥋 ディレクトリテーブルを他のテーブルと結合できる？

## 📓 関数が使えるなら、結合は？

Zenaはディレクトリテーブルに対して、通常の内部Snowflakeテーブルと同じように関数を使うことができました。

では、ディレクトリテーブルを通常の内部Snowflakeテーブルと**結合**（JOIN）できるでしょうか？試してみたいと思います。

それがうまくいけば、ディレクトリテーブルと内部テーブルを、以前作成した外部ステージデータのビューとも結合できるでしょうか？それも試してみたいです！

Zenaと一緒にやってみましょう！

---

## 🥋 Zenaのデータベースに内部テーブルを作成する

以下のSQLでテーブルを作成し、データを挿入します：

```sql
create or replace table zenas_athleisure_db.products.sweatsuits (
	color_or_style varchar(25),
	file_name varchar(50),
	price number(5,2)
);
```

テーブルにデータを挿入します：

```sql
insert into zenas_athleisure_db.products.sweatsuits 
          (color_or_style, file_name, price)
values
 ('Burgundy', 'burgundy_sweatsuit.png',65)
,('Charcoal Grey', 'charcoal_grey_sweatsuit.png',65)
,('Forest Green', 'forest_green_sweatsuit.png',64)
,('Navy Blue', 'navy_blue_sweatsuit.png',65)
,('Orange', 'orange_sweatsuit.png',65)
,('Pink', 'pink_sweatsuit.png',63)
,('Purple', 'purple_sweatsuit.png',64)
,('Red', 'red_sweatsuit.png',68)
,('Royal Blue', 'royal_blue_sweatsuit.png',65)
,('Yellow', 'yellow_sweatsuit.png',67);
```

---

## 🎯 これらを結合できますか？

このチャレンジラボには詳しい手順はありません。ディレクトリテーブルと新しい**sweatsuits**テーブルを結合できますか？

ヒントが必要であれば、こちらをご覧ください。

---

## 🥋 3テーブル結合 - CROSS JOIN を含む！

### 🎯 * を列のリストに置き換える

利用可能な列を絞り込み、以下のような結果を返すようにしましょう。

**PRODUCT_LIST**という名前のビューを作成してください。

---

## 📓 CROSS JOIN を追加する

Zenaは**PRODUCT_LIST**ビューのすべての色と、先ほど作成した**SWEATSUIT_SIZES**ビューのすべてのサイズについて、架空のスウェットスーツのリスティングを作成する必要があります。

これは簡単な**CROSS JOIN**で実現できます。クロス結合は「**デカルト積**（Cartesian Product）」とも呼ばれます。データ専門家がデカルト積について話すとき、意図したよりも多くのレコードが生成されてしまった悪い結合のことを指す場合が多いです。しかし今回は、デカルト積（乗法的な結合）が目的です。

> クロス結合は外部結合（Outer Join）とは異なります。どちらの結合も行数の「爆発」を引き起こす可能性がありますが、結果の列構成は異なります。

Zenaが本物のアスレジャーウェブサイトを構築していたなら、すべての色のスウェットスーツをすべてのサイズで提供するのではなく、在庫があるスウェットスーツのサイズ行だけを作りたいでしょう。しかし今回は概念実証（Proof of Concept）なので、**CROSS JOIN**は高速で最適です！

---

## 🥋 CROSS JOIN を追加する

以下のSQLを実行してみましょう：

```sql
select * 
from product_list p
cross join sweatsuit_sizes;
```

---

## 🎯 SELECT文をビューに変換する

上記のSELECTの上にビューを作成し、**CATALOG**と名前を付けてください。

ビューはZenaのデータベースの**Products**スキーマに作成し、**SYSADMIN**ロールが所有するようにしてください。

**CATALOG**ビューは180行を返す必要があります。

---

## 🤖 DORA DLKW03

### 🤖 ワークシートでこれを実行してDORAにレポートを送信する

> DORAのコードを編集してグリーンチェックを取得しないでください。ラボの作業を修正してください。

```sql
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
 SELECT
 'DLKW03' as step
 ,( select count(*) from ZENAS_ATHLEISURE_DB.PRODUCTS.CATALOG) as actual
 ,180 as expected
 ,'Cross-joined view exists' as description
);
```

結果セクションにグリーンチェック ✅ が表示されるはずです。

---

# 🥋 できることを、できる場所で、できる方法で

## 📓 データレイクとは？

このワークショップは「データレイクワークショップ（DLKW）」と呼ばれていますが、「**データレイク**」（Data Lake）とは具体的に何を意味するのかまだ議論していませんでした。データレイクの比喩は、2011年にPentaho社のCTO（最高技術責任者）だったJames Dixon氏によって紹介されました。

Dixon氏はこう述べています：

> データマートを、洗浄・パッケージ化・構造化されてすぐに消費できるボトルウォーターの店だと考えるなら、データレイクは、より自然な状態にある大きな水域です。データレイクの中身はソースからストリームとして流れ込み、さまざまなユーザーがレイクに来て調べたり、潜ったり、サンプルを採取したりできます。
>
> — James Dixon

Snowflakeで**データレイク**と言うとき、通常は従来のSnowflakeテーブルにロードされていないデータを指します。これらの従来のテーブルは「**ネイティブ**」Snowflakeテーブルや「通常の」テーブルとも呼ばれます。

すでに見てきたように、Snowflakeテーブルの外にある構造化データや半構造化データは、**ビュー**、**ファイルフォーマット**、**SQLクエリ**といったSnowflakeの馴染みのあるツールで簡単にアクセス・分析できます。

また、Snowflakeにロードされていない非構造化データは、**ディレクトリテーブル**という特別なSnowflakeツールでアクセスできることも学びました。ディレクトリテーブルは関数、結合、内部テーブル、標準ビューと組み合わせて使えることも確認しました。

そして、ロード済みデータと非ロードデータを組み合わせることがシンプルでシームレスなプロセスであることも分かりました。一部のデータがロード済みで一部が非ロード状態のとき、2種類のデータを結合してクエリできます。これは**データレイクハウス**（Data Lakehouse）と呼ばれることがあります。

> **続行するには正しい回答が必要です**

**問題:** Snowflakeでデータレイクと言うとき、何を意味しますか？

- [ ] データが簡単に流れ、停滞しないため常に新鮮である
- [ ] ストリームと呼ばれるSnowflakeオブジェクトを使って内部Snowflakeテーブルにロードされたデータ
- [ ] Snowflakeテーブルの外に置かれているが、Snowflakeのツールでアクセスできるデータ
- [ ] ストリームと呼ばれるツールではアクセスできないデータ

**[送信]**

---

## 📓 できることを、できる場所で — Snowflakeの多彩な「方法」で

データ駆動型組織でのあなたの役割に応じて：

- データをSnowflakeテーブルに移動する権限がある場合もあれば、ない場合もあります
- Snowflakeテーブルに既にロードされたデータを更新する権限がある場合もあれば、ない場合もあります
- あるステージから別のステージにデータをコピーする権限がある場合もあれば、ない場合もあります

Snowflakeは、**できることを、できる場所で**行えるようにしています。Snowflakeは新しい「方法」をツールセットに追加し続けているからです。

つまり、ある部門の担当者が「あのテーブルにUPDATE文を実行すればいい」と考える一方で、同じ目標を達成しようとする別の担当者はSnowflakeの自分の領域でビューを修正する必要があるかもしれません。さらに別の人は、クラウドフォルダにファイルを追加し、そのファイルの上にステージとビューを作成して、他の誰かがロードしたデータと結合するかもしれません。

さまざまなHands-On Essentialsワークショップが、Snowflakeの「何を」「どうやって」を学ぶのに役立ちます。

このワークショップは特に「どこで」に焦点を当てています。ここでの「どこで」とは、Snowflakeのネイティブテーブルの**外部**です。

---

## 📓 Zenaのこれまでの作業

Zenaはデータをロードしないことで、ウェブサイトのプロトタイプを非常に素早く開発できました。

また、内部テーブルを追加して非ロードデータとの結合にも使いました。さらにもう1つ内部テーブルを追加して、いくつかのことをしたいと思っています。概念実証が形になってきています！

---

## 🥋 アップセルテーブルを追加してデータを投入する

マッピングテーブルを作成します：

```sql
create table zenas_athleisure_db.products.upsell_mapping
(
sweatsuit_color_or_style varchar(25)
,upsell_product_code varchar(10)
);
```

アップセルテーブルにデータを挿入します：

```sql
insert into zenas_athleisure_db.products.upsell_mapping
(
sweatsuit_color_or_style
,upsell_product_code 
)
VALUES
('Charcoal Grey','SWT_GRY')
,('Forest Green','SWT_FGN')
,('Orange','SWT_ORG')
,('Pink', 'SWT_PNK')
,('Red','SWT_RED')
,('Yellow', 'SWT_YLW');
```

---

# 🥋 力技の連続？ それとも粘り強い工夫？

## 📓 データをそのまま置いておくと…

データをレイクに残す — つまり「着地した場所にそのまま置く」— つまりステージに残す場合、データをクレンジング・正規化・保存する時間や権限がない開発者は、利用可能なものから必要なものを得るために創造的になる必要があります。

Zenaの場合、ウェブサイトのプロトタイプを早く完成させたいだけです！彼女は自分の方法を**粘り強く工夫する力**だと考えています。

開発者として、他の人のコードを見て「この混乱を書いたとき、何を考えていたんだろう？」と思うことがよくあります。

- KlausはZenaのコードについてそう思います
- ZenaはMelのコードについてそう思います
- MelはKlausのコードについてそう思います

以下のビューをどう思いますか？Zenaがウェブサイトプロトタイプのために書いたものです（ちょっとすごいですよね？）

---

## 🥋 Zenaのアスレジャー・ウェブカタログ・プロトタイプ用ビュー

以下のSQLでビューを作成します：

```sql
create view catalog_for_website as 
select color_or_style
,price
,file_name
, get_presigned_url(@sweatsuits, file_name, 3600) as file_url
,size_list
,coalesce('Consider: ' ||  headband_description || ' & ' || wristband_description, 'Consider: White, Black or Grey Sweat Accessories')  as upsell_product_desc
from
(   select color_or_style, price, file_name
    ,listagg(sizes_available, ' | ') within group (order by sizes_available) as size_list
    from catalog
    group by color_or_style, price, file_name
) c
left join upsell_mapping u
on u.sweatsuit_color_or_style = c.color_or_style
left join sweatband_coordination sc
on sc.product_code = u.upsell_product_code
left join sweatband_product_line spl
on spl.product_code = sc.product_code;
```

---

## 🤖 DORA DLKW04

### 🤖 ワークシートでこれを実行してDORAにレポートを送信する

> DORAのコードを編集してグリーンチェックを取得しないでください。ラボの作業を修正してください。

```sql
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
SELECT
'DLKW04' as step
 ,( select count(*) 
  from zenas_athleisure_db.products.catalog_for_website 
  where upsell_product_desc not like '%e, Bl%') as actual
 ,6 as expected
 ,'Relentlessly resourceful' as description
);
```

結果セクションにグリーンチェック ✅ が表示されるはずです。

---

# 🖼️ ZenaはMelに会う準備ができた！

## 🖼️ Zenaのウェブカタログ・プロトタイプ！

ZenaはMelに新しいアスレジャーカタログのプロトタイプを見せたいと思い、電話で伝えました。

ZenaはアプリのWebアドレスを教え、MelはZenaに数日以内に何かを送ると約束しました。

あなたもこのアプリを作成できます。Zenaのウェブカタログ・プロトタイプの自分バージョンを作るのは完全に**オプション**です。試してみたい場合、約15分かかります。

2つの方法をご紹介します：

1. シンプルなコードで作る方法（手動作業が少し多い）
2. やや複雑な方法で作る方法（本番アプリに近い形）

DABWワークショップを受講していない場合、少し難しく感じるかもしれません。受講していなくても試せますが、行き詰まった場合はDABWワークショップの受講をお勧めします。

---

## 🥋 ZenaのSiSプロトタイプアプリを構築する（オプション）

### 🥋 Zenaの Streamlit アプリを作成する（オプション）

以下のPythonコードを使います：

```python
import streamlit as st
from snowflake.snowpark.context import get_active_session
from snowflake.snowpark.functions import col
import pandas as pd

st.title("Zena's Amazing Athleisure Catalog")

session = get_active_session()

table_colors = session.sql("select color_or_style from catalog_for_website")
pd_colors = table_colors.to_pandas()

option = st.selectbox('Pick a sweatsuit color or style:', pd_colors)

product_caption = 'Our warm, comfortable, ' + option + ' sweatsuit!'

table_prod_data = session.sql("select file_name, price, size_list, upsell_product_desc, file_url from catalog_for_website where color_or_style = '" + option + "';")
pd_prod_data = table_prod_data.to_pandas() 

price = '$' + str(pd_prod_data['PRICE'].iloc[0])+'0'
file_name = pd_prod_data['FILE_NAME'].iloc[0]
size_list = pd_prod_data['SIZE_LIST'].iloc[0]
upsell = pd_prod_data['UPSELL_PRODUCT_DESC'].iloc[0]
url = pd_prod_data['FILE_URL'].iloc[0]

st.image(image=url, width=400, caption=product_caption)
st.markdown('**Price:** '+ price)
st.markdown('**Sizes Available:** ' + size_list)
st.markdown('**Also Consider:** ' + upsell)
```

---

## 🥋 画像表示の調整（オプション）

### 🥋 アプリのステージに画像のコピーをロードする

画像ファイルのコピーをアプリのステージにロードしてください。

ファイルをロードしたら、アプリを再実行すると動作するはずです。

---

## 📓 2つ目の方法 - 事前署名URL（Pre-signed URL）

**事前署名URL**（Pre-signed URL）は、期間限定のアクセス権限を持つリンクを提供することで、外部ユーザーに画像を配信する方法です。

**CATALOG_FOR_WEBSITE**ビューを見ると、すでに使用可能な事前署名URLが作成されていることが分かります。ビューがクエリされると、タイマーが開始されます。URLには3600秒（1時間）の画像アクセス権が付与されます。

現在、アプリコードの21行目でfile_urlをデータフレームに取り込み、29行目でURLという変数に設定しています。しかし、その後この変数は使われていません。

アプリの最後の行にコメントアウトされたコードがあります。ハッシュ記号を削除してアプリを実行すると、事前署名URLが表示されます。

---

## 🥋 画像ソースを置き換える

---

# 🏁 まとめと次のステップ

このレッスンでは以下を学びました：

- **非構造化データ**（画像など）は `SELECT $1` やファイルフォーマットではクエリできない
- **ディレクトリテーブル**を使って非構造化データのファイル情報にアクセスできる
- ディレクトリテーブルでは**関数**や**結合**が通常のテーブルと同様に使える
- **CROSS JOIN**を使ってデカルト積を意図的に作成できる
- **データレイク**とはSnowflakeテーブルにロードせずにアクセスできるデータのこと
- **データレイクハウス**はロード済みデータと非ロードデータを組み合わせたアプローチ
- **事前署名URL**で外部ユーザーに期間限定で画像を配信できる
