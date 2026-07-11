# 🎭 DORAに会おう！

## 🧰 API Integrationを作成する

「API Integrationの作成」の意味を理解する必要はありません。以下のコードを実行するだけです（**ACCOUNTADMIN** ロールを使用してください）。

```sql
use role accountadmin;

create or replace api integration dora_api_integration
api_provider = aws_api_gateway
api_aws_role_arn = 'arn:aws:iam::321463406630:role/snowflakeLearnerAssumedRole'
enabled = true
api_allowed_prefixes = ('https://awy6hshxy4.execute-api.us-west-2.amazonaws.com/dev/edu_dora');
```

---

## 🧰 GRADER関数を作成する

「GRADER関数の作成」の意味を理解する必要はありません。以下のコードを実行するだけです（**ACCOUNTADMIN** ロールを使用してください）。

```sql
use role accountadmin;  

create or replace external function util_db.public.grader(
      step varchar
    , passed boolean
    , actual integer
    , expected integer
    , description varchar)
returns variant
api_integration = dora_api_integration 
context_headers = (current_timestamp, current_account, current_statement, current_account_name) 
as 'https://awy6hshxy4.execute-api.us-west-2.amazonaws.com/dev/edu_dora/grader'
; 
```

---

## 🤖 GRADER関数は動作していますか？

```sql
use role accountadmin;
use database util_db; 
use schema public; 

select grader(step, (actual = expected), actual, expected, description) as graded_results from
(SELECT 
 'DORA_IS_WORKING' as step
 ,(select 123) as actual
 ,123 as expected
 ,'Dora is working!' as description
); 
```

> **トラブルシューティング:**
> - GRADER関数が存在しないというメッセージが表示された場合、ワークシートの右上でロールが **ACCOUNTADMIN** に設定されているか確認してください。
> - それでもエラーが出る場合、ワークシートで `show functions in account;` を実行してください。
> - GRADER関数が **UTIL_DB.PUBLIC** スキーマにない場合、2つの方法があります：
>   1. 関数を移動する: `ALTER FUNCTION GARDEN_PLANTS.VEGGIE.GRADER RENAME TO UTIL_DB.PUBLIC.GRADER`
>   2. GRADERの呼び出し前のUSE DATABASE行を編集する
>
> **注意:** 最初のDORAチェックから最後のDORAチェックまで**90日間**の期限があります。期限を過ぎた場合は、古いテストを再実行する必要があります。

---

## 🧰 準備完了！

DORAチェックスクリプトが動作したら、本番のDORAコードチェックに進む準備ができています！

---

# 🥋 コードチェックの準備

## 🥋 コードを使って作業を確認する

**GARDEN_PLANTS** データベースに3つのスキーマをセットアップし、1つのスキーマを削除するよう求められました。いくつかのコードを実行して、これらのタスクが完了しているか確認しましょう。

```sql
select * 
from garden_plants.information_schema.schemata;
```

> **続行するには正しい回答が必要です**

**問題:** GARDEN_PLANTSデータベースにはいくつのスキーマがありますか（あるべきですか）？

- [ ] 2
- [ ] 3
- [ ] 4

**[送信]**

---

## 📓 何を間違えたか？

クエリを実行して予期しない結果が出た場合、以下の可能性があります：

- スキーマ名にタイプミスがある（例: 「VEGGIES」ではなく「WEGGIES」）
- スキーマを間違ったデータベースに作成した（例: **GARDEN_PLANTS** ではなく **UTIL_DB**）
- オブジェクトが見えるロールになっていない（例: **ACCOUNTADMIN** で作成したが、ワークシートは **SYSADMIN** に設定）

## 📓 修正方法

タイプミスの場合：

```sql
ALTER SCHEMA GARDEN_PLANTS.WEGGIES RENAME TO GARDEN_PLANTS.VEGGIES;
```

間違った場所の場合：

```sql
ALTER SCHEMA DEMO_DB.VEGGIES RENAME TO GARDEN_PLANTS.VEGGIES;
```

見つからない場合：ワークシートのロール設定を変更するか、オブジェクトの所有権を移転してください。

---

## 🥋 スキーマ名を確認する

作成したスキーマが正しい名前を持っているか確認しましょう。このコードが3行返さない場合、スキーマ名が異なる可能性があります。

```sql
SELECT * 
FROM GARDEN_PLANTS.INFORMATION_SCHEMA.SCHEMATA
where schema_name in ('FLOWERS','FRUITS','VEGGIES'); 
```

## 🥋 正しい名前のスキーマ数をカウントする

```sql
select count(*) as schemas_found, '3' as schemas_expected 
from GARDEN_PLANTS.INFORMATION_SCHEMA.SCHEMATA
where schema_name in ('FLOWERS','FRUITS','VEGGIES'); 
```

---

## 📓 INFORMATION_SCHEMAを使ったメタデータのクエリ

**メタデータ**（Metadata）とは「データに関するデータ」のことです。

すべてのSnowflakeデータベースに作成される **INFORMATION_SCHEMA** にはメタデータが格納されています。つまり、データベース、スキーマ、テーブル、ビューなどの数や名前、その他の詳細情報を保持しています。

上記のクエリでは、**INFORMATION_SCHEMA** を使って作業の結果を確認しています。

---

# 🔍 メタデータとは？

> **続行するには正しい回答が必要です**

**問題:** メタデータの定義は何ですか？

- [ ] メタに関するデータ
- [ ] 他のデータの上にあるデータ
- [ ] データに関するデータ

**[送信]**

---

> **続行するには正しい回答が必要です**

**問題:** Snowflakeはメタデータの一部をどこに保存していますか？

- [ ] 各アカウントの **INFORMATION_DB** データベース
- [ ] 各データベースの **METADATA_SCHEMA** スキーマ
- [ ] 各データベースの **INFO_METADATA** スキーマ
- [ ] 各データベースの **INFORMATION_SCHEMA** スキーマ

**[送信]**

---

> **続行するには正しい回答が必要です**

**問題:** 作成したスキーマを自分の目で確認するだけではなく、なぜコードで確認するのですか？

**3個選択してください:**

- [ ] スペルミスがあっても目では気づかないかもしれないが、コードでチェックすれば見つけられる
- [ ] 何らかの理由でチェックを自動化したい場合があるから
- [ ] コーディングは楽しいから

**[送信]**

---

# 🤖 DORAコードチェック

## 🤖 DORA DWW01

スキーマに関するレポートをDORAに送信します。

> ⚠️ **DORAコードは絶対に編集しないでください。** グリーンチェックを得るためにDORAコードを変更するのではなく、ラボ作業を修正してください。

```sql
use database UTIL_DB;
use schema PUBLIC;
use role ACCOUNTADMIN;

select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT
 'DWW01' as step
 ,( select count(*)  
   from GARDEN_PLANTS.INFORMATION_SCHEMA.SCHEMATA 
   where schema_name in ('FLOWERS','VEGGIES','FRUITS')) as actual
  ,3 as expected
  ,'Created 3 Garden Plant schemas' as description
); 
```

---

## 🤖 DORA DWW02

```sql
use database UTIL_DB;
use schema PUBLIC;
use role ACCOUNTADMIN;

select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW02' as step 
 ,( select count(*) 
   from GARDEN_PLANTS.INFORMATION_SCHEMA.SCHEMATA 
   where schema_name = 'PUBLIC') as actual 
 , 0 as expected 
 ,'Deleted PUBLIC schema.' as description
); 
```

---

## 🤖 DORA DWW03

```sql
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW03' as step 
 ,( select count(*) 
   from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
   where table_name = 'ROOT_DEPTH') as actual 
 , 1 as expected 
 ,'ROOT_DEPTH Table Exists' as description
); 
```

---

## 🥋 クエリ履歴を使ってテスト結果を確認する

---

## 🤖 DORA DWW04

```sql
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW04' as step
 ,( select count(*) as SCHEMAS_FOUND 
   from UTIL_DB.INFORMATION_SCHEMA.SCHEMATA) as actual
 , 2 as expected
 , 'UTIL_DB Schemas' as description
); 
```

---

## 🤖 DORA DWW05

```sql
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from ( 
 SELECT 'DWW05' as step 
,( select row_count 
  from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
  where table_name = 'ROOT_DEPTH') as actual 
, 3 as expected 
,'ROOT_DEPTH row count' as description
); 
```

---

# 👂 DORAはリスニング中！

## 🧰 Snowflakeトライアルアカウントの情報を登録する

learn.snowflake.com のアカウントと、ラボ作業を行うSnowflakeトライアルアカウントがあります。DORAがどのラボとどの学習アカウントを紐づけるかを知るために、アプリで登録が必要です。

アプリでできること：

- ✏️ 名前やメールアドレスの編集
- ⭐ 表示名のフォーマット — バッジに表示される名前です
- 🔗 学習アカウントとSnowflakeトライアルアカウントの**リンク**を作成
- 🤖 実行したDORAラボチェックの進捗を確認

アプリのURL: https://ysa.snowflakeuniversity.com

ログインには **UNI_ID** と **UUID** が必要です。これらは training.snowflake.com のコース登録ページで確認できます。

> この情報は安全な場所に保管してください。YSAアプリにアクセスするたびに必要になります。
