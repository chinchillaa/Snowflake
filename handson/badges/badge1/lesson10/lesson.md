# 🎭 データストレージの短い歴史

## 🎭 データストレージの歴史を振り返る

---

# 🥋 図書カードカタログDBを作成する

## 🥋 新しいデータベースとテーブルを作成する

```sql
use role sysadmin;

create database library_card_catalog comment = 'DWW Lesson 10 ';

use database library_card_catalog;
```

---

# 🎭 データストレージ：エンティティとリレーションシップ

---

# 🎭 データストレージ：ERDからテーブルへ

---

# 🥋 Bookテーブルを作成してデータを投入する

## 🥋 Bookテーブルを作成する

**AUTOINCREMENT** を使って、各新規行にUID（一意識別子）を自動生成します。

```sql
use database library_card_catalog;
use role sysadmin;

create or replace table book
( book_uid number autoincrement
 , title varchar(50)
 , year_published number(4,0)
);

insert into book(title, year_published)
values
 ('Food',2001)
,('Food',2006)
,('Food',2008)
,('Food',2016)
,('Food',2015);

select * from book;
```

**BOOK_UID** フィールドにはAUTOINCREMENTプロパティが自動的に値を割り当てるため、INSERT時に指定する必要はありません。各行に一意のIDがあることを確認してください。

---

# 🥋 Authorテーブルを作成する

## 🥋 AUTHORテーブルを作成する

```sql
create or replace table author (
   author_uid number 
  ,first_name varchar(50)
  ,middle_name varchar(50)
  ,last_name varchar(50)
);

insert into author(author_uid, first_name, middle_name, last_name)  
values
(1, 'Fiona', '','Macdonald')
,(2, 'Gian','Paulo','Faleschini');

select * 
from author;
```

---

## 📓 一意識別子を生成するもう一つの方法 — シーケンス（Sequence）

Bookテーブルを作成したとき、**autoincrement** プロパティを使ってテーブルの各本に一意のIDを作成しました。これはテーブル行の一意IDを生成するシンプルで直接的な方法です。しかし、一意IDのシーケンスをより細かく制御したい場合があります。

その場合、**シーケンス**（SEQUENCE）オブジェクトを作成できます。次のラボでは、AUTHORテーブルで使用するシーケンスを作成します。

---

# 🥋 シーケンスを作成する

## 🥋 シーケンスの作成

シーケンスはカウンターです。テーブル行に一意のIDを作成するのに役立ちます。単一テーブル内で一意IDを作成する方法として **AUTO-INCREMENT** カラムがあります。これは設定が簡単で単一テーブルではうまく機能します。シーケンスを使うと、情報を異なるテーブルに分割し、すべてのテーブルに同じIDを入れて、後で簡単にリンクできるようにするパワーが得られます。

> **注意:** **ORDER** キーワードを含めないと、値が毎回100ずつスキップします。

---

## 🥋 シーケンスオブジェクトを確認する

ホームページに戻り、オブジェクトピッカーでシーケンスを見つけてください。Next Valueカラムが「1」と表示されていることに注目してください。

---

## 🥋 シーケンスをクエリする

```sql
use role sysadmin;

select seq_author_uid.nextval;
```

## 🥋 シーケンスをクエリして使用する

シーケンスをクエリするたびに、値が変わります。

クエリをさらに数回実行して、next_valueがどう変化するか確認してください。show sequencesの結果で **next_value = 4** になったら、次のタスクに進んでください。

間違えた場合は、シーケンスを再作成してやり直してください。Snowflakeでオブジェクトを再作成するには、CREATE SQL文に「OR REPLACE」を追加するか、オブジェクトをDROPして再度作成します。

---

## 🥋 2回使ってみよう！

1つのクエリで **nextval** を複数回使用できます。一般的なユースケースではなく一般的な慣行でもありませんが、試してみるのは問題ありません。

こうすると番号がスキップされることに注目してください。UIDは連番であることよりも**一意であること**の方が重要だからです。このオプションを何回か実行してみてください。すぐにリセットするので、進みすぎても心配ありません！

---

# 🥋 シーケンスをリセットしてAuthorテーブルに行を追加する

## 📓 異なる開始値でシーケンスを再作成する

シーケンスを再作成しますが、今回はテーブルにすでに2行あるため、**3** からカウントを開始します。

次にauthorテーブルに追加する行の **AUTHOR_UID** を3にしたいのです。

---

## 🥋 シーケンスをリセットしてAuthorに行を追加する

```sql
use role sysadmin;

create or replace sequence library_card_catalog.public.seq_author_uid
start = 3 
increment = 1 
ORDER
comment = 'Use this to fill in the AUTHOR_UID every time you add a row';

insert into author(author_uid,first_name, middle_name, last_name) 
values
(seq_author_uid.nextval, 'Laura', 'K','Egendorf')
,(seq_author_uid.nextval, 'Jan', '','Grover')
,(seq_author_uid.nextval, 'Jennifer', '','Clapp')
,(seq_author_uid.nextval, 'Kathleen', '','Petelinsek');
```

---

## 📓 NextVal関数について

以前、最初の2行をテーブルに追加したときは、行のUIDとして1と2をハードコードしました。今回は **.nextval** 関数を使ってUIDを追加します。今後は番号を覚えておく必要がないため、この方が便利です。

autoincrementプロパティと同様に、テーブル定義の一部としてシーケンスを使用することも可能です。その場合、カラムのデフォルト値を `seq_author_uid.nextval()` として定義できます。今回はやり直しを避けるため、INSERT文の中で関数を使用しました。

---

# 🎭 データストレージ：多対多のマッピング

## 🥋 BOOK_TO_AUTHORブリッジテーブルを作成する

このテーブルは「**多対多テーブル**（Many-to-Many Table）」とも呼ばれます。

```sql
use database library_card_catalog;
use role sysadmin;

create table book_to_author
( book_uid number
  ,author_uid number
);

insert into book_to_author(book_uid, author_uid)
values
 (1,1)
,(1,2)
,(2,3)
,(3,4)
,(4,5)
,(5,6);

select * 
from book_to_author ba 
join author a 
on ba.author_uid = a.author_uid 
join book b 
on b.book_uid=ba.book_uid; 
```

3つのテーブルを結合して確認してください。各著者につき1行、合計6行が返されるはずです。

---

# 🤖 DORA DWW15

> ⚠️ **DORAコードは絶対に編集しないでください。** グリーンチェックを得るためにDORAコードを変更するのではなく、ラボ作業を修正してください。

```sql
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (  
     SELECT 'DWW15' as step 
     ,( select count(*) 
      from LIBRARY_CARD_CATALOG.PUBLIC.Book_to_Author ba 
      join LIBRARY_CARD_CATALOG.PUBLIC.author a 
      on ba.author_uid = a.author_uid 
      join LIBRARY_CARD_CATALOG.PUBLIC.book b 
      on b.book_uid=ba.book_uid) as actual 
     , 6 as expected 
     , '3NF DB was Created.' as description  
); 
```

---

# 🏁 まとめと次のステップ

Snowflakeステージの詳細については、Snowflakeドキュメントの「Managing Snowflake Stages」セクションを参照してください。

ERD作成ツールについては、コミュニティのナレッジベース記事を参照してください。

ここまでのすべてのDORAテストに合格していれば、次に進む準備ができています！
