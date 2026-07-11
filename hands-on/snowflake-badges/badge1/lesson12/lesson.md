# 🎭 ネストされたJSON（Nested JSON）

---

# 🥋 ネストされた著者＆書籍JSONデータのロードとクエリ

## 🥋 ネストされたJSONデータ用のテーブルとファイルフォーマットを作成する

```sql
create or replace table library_card_catalog.public.nested_ingest_json 
(
  raw_nested_book VARIANT
);
```

---

## 🎯 このラボ用のデータファイルをダウンロードする

> **json_book_author_nested.txt** (956 B)

---

## 🎯 ネストされたJSONファイルをロードする

**NESTED_INGEST_JSON** テーブルにデータをアップロードしてください。ネストされていないJSONデータ用に作成したファイルフォーマットを使用できます。

---

## 🥋 ネストされたJSONデータをクエリする

```sql
select raw_nested_book
from nested_ingest_json;

select raw_nested_book:year_published
from nested_ingest_json;

select raw_nested_book:authors
from nested_ingest_json;
```

---

## 🥋 ネストされたデータにFLATTENコマンドを使用する

```sql
select value:first_name
from nested_ingest_json
,lateral flatten(input => raw_nested_book:authors);

select value:first_name
from nested_ingest_json
,table(flatten(raw_nested_book:authors));

SELECT value:first_name::varchar, value:last_name::varchar
from nested_ingest_json
,lateral flatten(input => raw_nested_book:authors);

select value:first_name::varchar as first_nm
, value:last_name::varchar as last_nm
from nested_ingest_json
,lateral flatten(input => raw_nested_book:authors);
```

返されるフィールドに **CAST** コマンドを追加して型を指定し、**AS** を使って新しいカラム名を割り当てることができます。

---

# 🎭 ネストされたエンティティのPATH記法

---

# 🤖 DORA DWW17

> ⚠️ **DORAコードは絶対に編集しないでください。** グリーンチェックを得るためにDORAコードを変更するのではなく、ラボ作業を修正してください。

```sql
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (   
     SELECT 'DWW17' as step 
      ,( select row_count 
        from LIBRARY_CARD_CATALOG.INFORMATION_SCHEMA.TABLES 
        where table_name = 'NESTED_INGEST_JSON') as actual 
      , 5 as expected 
      ,'Check number of rows' as description  
); 
```

---

# 🎭 古いTwitterツイート

## 🥋 オンラインパーサーでデータを探索する

### 🎯 このラボ用のデータファイルをダウンロードする

> **nutrition_tweets.json** (46.6 KB)

### 🥋 ダウンロードしたJSONファイルをオンラインツールで確認する

以下のJSONツールを別のタブで開いてください: https://jsoneditoronline.org/

---

> **続行するには正しい回答が必要です**

**問題:** ファイルに含まれるツイートの数はいくつですか？

- [ ] 5
- [ ] 6
- [ ] 7
- [ ] 8
- [ ] 9
- [ ] 10
- [ ] 11

**[送信]**

---

> **続行するには正しい回答が必要です**

**問題:** #Tea ハッシュタグを含むツイートをしたユーザーは誰ですか？

- [ ] Total Well Being (brrsmit406)
- [ ] Health Tips Ever (HealthTipsEver)
- [ ] Denon Stacy MS RD LD (rdtipoftheday)
- [ ] Westside Strength (WSC_Coach)
- [ ] Satina Cotton (Satin06)

**[送信]**

---

> **続行するには正しい回答が必要です**

**問題:** 豆からデザートを作ることについて話しているユーザーは誰ですか？

- [ ] Total Well Being (brrsmit406)
- [ ] Health Tips Ever (HealthTipsEver)
- [ ] Denon Stacy MS RD LD (rdtipoftheday)
- [ ] Westside Strength (WSC_Coach)
- [ ] Satina Cotton (Satin06)

**[送信]**

---

# 🥋 ネストされたツイートJSONデータのロードとクエリ

## 🎯 ツイートデータベースインフラストラクチャを作成する

- **SOCIAL_MEDIA_FLOODGATES** という名前のデータベースを作成する
- 新しいデータベースの **PUBLIC** スキーマに **TWEET_INGEST** というテーブルを作成する。新しいテーブルにはカラムが1つだけ必要です（JSONデータなのでデータ型はわかるはずです）。カラム名は **RAW_STATUS** にしてください
- JSONタイプのファイルフォーマットを作成する
- ツイートデータをテーブルにロードするCOPY INTO文を作成する。ファイルをどこかにステージする必要があります — 場所は自分で決めてください

ファイルをロードした後、9つの個別の行（1ツイートにつき1行）が表示されるはずです。

---

## 🥋 ネストされたJSONツイートデータに対して簡単なクエリを実行する

```sql
select raw_status
from tweet_ingest;

select raw_status:entities
from tweet_ingest;

select raw_status:entities:hashtags
from tweet_ingest;

select raw_status:entities:hashtags[0].text
from tweet_ingest;

select raw_status:entities:hashtags[0].text
from tweet_ingest
where raw_status:entities:hashtags[0].text is not null;

select raw_status:created_at::date
from tweet_ingest
order by raw_status:created_at::date;
```

角括弧付きの番号を追加して、特定のハッシュタグを取得できます。WHERE句を追加すると、ハッシュタグを含まないツイートを除外できます。**created_at** キーに対してCAST（型変換）を行い、ORDER BY句でツイートの作成日でソートできます。

---

> **続行するには正しい回答が必要です**

**問題:** ファイル内のツイートで最も多かった日付はどれですか？

- [ ] 2019年5月10日
- [ ] 2019年6月28日
- [ ] 2019年7月3日
- [ ] 2019年8月22日
- [ ] 2019年9月14日

**[送信]**

---

# 🥋 エンティティのFlattenと分離

## 🥋 FLATTENのINPUTを変更してエンティティを分離する

```sql
select value
from tweet_ingest
,lateral flatten
(input => raw_status:entities:urls);

select value
from tweet_ingest
,table(flatten(raw_status:entities:urls));
```

---

> **続行するには正しい回答が必要です**

**問題:** 上記の2つのクエリはFLATTENコマンドの使い方が少し異なります。返されるデータにどのような影響がありますか？

- [ ] 最初のクエリの方が多くのURLを返す
- [ ] 2番目のクエリの方が多くのURLを返す
- [ ] 最初のクエリの方が適切にフォーマットされたデータを返す
- [ ] 2番目のクエリの方が適切にフォーマットされたデータを返す
- [ ] 返される結果に違いはないようである

**[送信]**

---

## 🥋 ネストされたJSONツイートデータをクエリする

```sql
select value:text::varchar as hashtag_used
from tweet_ingest
,lateral flatten
(input => raw_status:entities:hashtags);

select raw_status:user:name::text as user_name
,raw_status:id as tweet_id
,value:text::varchar as hashtag_used
from tweet_ingest
,lateral flatten
(input => raw_status:entities:hashtags);
```

ハッシュタグテキストだけをFlattenして返すことができます。また、ツイートIDとユーザーIDを追加して、ハッシュタグを元のツイートに結合できるようにします。

---

# 🤖 DORA DWW18

> ⚠️ **DORAコードは絶対に編集しないでください。** グリーンチェックを得るためにDORAコードを変更するのではなく、ラボ作業を修正してください。

```sql
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
   SELECT 'DWW18' as step
  ,( select row_count 
    from SOCIAL_MEDIA_FLOODGATES.INFORMATION_SCHEMA.TABLES 
    where table_name = 'TWEET_INGEST') as actual
  , 9 as expected
  ,'Check number of rows' as description  
 );
```

---

# 🥋 ハッシュタグを正規化する

## 🥋 URLデータを「正規化」された形で表示するビューを作成する

```sql
create or replace view social_media_floodgates.public.urls_normalized as
(select raw_status:user:name::text as user_name
,raw_status:id as tweet_id
,value:display_url::text as url_used
from tweet_ingest
,lateral flatten
(input => raw_status:entities:urls)
);
```

---

## 🎯 ハッシュタグデータを正規化された形で表示するビューを作成する

**HASHTAGS_NORMALIZED** という名前のビューを作成してください。

SELECT * を実行した結果が、正規化されたテーブルのように表示されるようにしてください。

---

# 🤖 DORA DWW19

> ⚠️ **DORAコードは絶対に編集しないでください。** グリーンチェックを得るためにDORAコードを変更するのではなく、ラボ作業を修正してください。

```sql
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
  SELECT 'DWW19' as step
  ,( select count(*) 
    from SOCIAL_MEDIA_FLOODGATES.INFORMATION_SCHEMA.VIEWS 
    where table_name = 'HASHTAGS_NORMALIZED') as actual
  , 1 as expected
  ,'Check number of rows' as description
 ); 
```

> JSONのパース方法について詳しくは、コミュニティのナレッジベース記事を参照してください。

---

# 🎉 バッジの時間です！

## 🎉 おめでとうございます！最後まで到達しました！

すべての要件を満たしていれば、バッジは自動的に発行されます。自動化フローに問題が発生したまれなケースでのみ、スタッフが介入します。DWWバッジは毎週何百人もの学習者に発行されるため、すべての要件を確認し、問題を自分で修正してください。アプリはセルフサービスで解決できるように設計されています。

---

## 🚀 次のステップ

このコースを楽しんだ方には、次のワークショップ **Collaboration, Marketplace, & Cost Estimation Workshop（CMCW）** への進学を強くお勧めします。

CMCWでは、データロードの高速化や開発時間の短縮のヒントを学べます。また、Snowflakeを効果的に使うために不可欠な**コスト見積もり**（および基本的なコスト管理）もカバーしています。

---

## 🤖 DORAで確認しましょう！

すべてのDWW DORAテストに合格していれば、このコースのバッジが発行されます。

YSAアプリにログインして確認してください: https://ysa.snowflakeuniversity.com

- メールアドレスのスペルを再確認してください
- 表示名を再確認してください。バッジに表示される名前です。アクセントやUnicode文字を使用できます
- リンクレコードに**アカウントID**と**アカウントロケーター**の両方が含まれていることを確認してください。両方の情報がないと、バッジの発行がブロックされます
- DORAラボチェックの記録を確認してください。すべてのDORAテスト（DWW01からDWW19）が**PASSING**かつ**VALID**として表示されているはずです。テストが欠けている場合や、PASSINGだがVALIDでない（またはその逆の）場合は、そのレッスンを再度実施してください

すべて正しく行っていれば、「Badges Awarded」エントリーの1つとしてDWWが表示されます。

> **注意:** コースワーク完了からバッジのメール通知受信まで最大1時間かかる場合があります。

YSAアプリへのログインには **UNI_ID** と **UUID** が必要です。これらは training.snowflake.com のコース登録ページで確認できます。

---

🎉 コースを完了していただき、ありがとうございます。おめでとうございます！ 🎉
