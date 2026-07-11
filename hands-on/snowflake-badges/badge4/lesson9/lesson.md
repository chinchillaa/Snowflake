# 📓 これらは一体何なのか？

## 📓 マテリアライズドビュー（Materialized View）、外部テーブル（External Table）、Icebergテーブル

> ライオンとトラとクマ、なんてこった！ -- ドロシー、オズの魔法使い

でも私たちの場合は：

- **マテリアライズドビュー**と、
- **外部テーブル**と、
- **Icebergテーブル**！

なんてこった！これらは一体何なのか？

簡単に言えば、これらのオブジェクトはすべて、正規化が不十分な（おそらくロードされていない）データを、より正規化された（おそらくロード済みの）データのように見せ、パフォーマンスを発揮させるための試みです。

> **続行するには正しい回答が必要です**

**問題:** マテリアライズドビュー、外部テーブル、Icebergテーブルは一般的に何に使われますか？

- [ ] データをSnowflakeに素早くロードするため
- [ ] データをSnowflakeから素早くアンロードするため
- [ ] ロードされていないデータへの高パフォーマンスアクセスを提供するため
- [ ] データをSnowflakeにETL（抽出、変換、ロード）するため

**[送信]**

---

## 📓 マテリアライズドビューとは？

**マテリアライズドビュー（Materialized View）** は、固定化されたビューのようなものです（多かれ少なかれテーブルのように見え、動作します）。

大きな違いは、基礎となるデータの一部が変更された場合、Snowflakeが自動的にリフレッシュの必要性を認識することです。

- 集中的なロジックを持つビューを頻繁にクエリするが、頻繁には**変更されない**場合に、マテリアライズドビューを作成することがよく選択されます
- ステージ上のデータの上にマテリアライズドビューを**直接**配置することはできないため、トレイルデータにはマテリアライズドビューを使用できません

> **続行するには正しい回答が必要です**

**問題:** 「通常の」ビューをステージの上に直接配置できますか？

- [ ] はい
- [ ] いいえ

**[送信]**

---

## 📓 外部テーブルとは？

**外部テーブル（External Table）** は、ロードされていないデータの上に配置されるテーブルです（最近のビューと似ていますね？）。

- 外部テーブルは**ステージフォルダ**を指します（はい、やり方を知っています！）
- **ファイルフォーマット**（またはフォーマット属性）への参照を含みます — このワークショップのほとんどでビューに対して行ってきたのと同様です

しかし、docs.snowflake.com を見ると、外部テーブルの構文は威圧的に見えます。簡単に理解でき経験のある部分と、少しわかりにくい部分に分解してみましょう。

| 馴染みのある部分 | 新しいが理解しやすい部分 | 難しい部分 |
|---|---|---|
| PATH と CAST の定義 | 列名を先に書き、AS の後に定義を記述（ビューとは逆順） | パーティショニングスキーム |
| ファイルフォーマットの参照 | **AUTO_REFRESH** プロパティ | ストリーミングメッセージ通知統合 |

> パーティショニングスキームやストリーミングメッセージ通知統合は、データエンジニアリングハンズオンワークショップでより詳しく学べます。

では、既存のビューの代わりに外部テーブルを作成してみるべきでしょうか？もちろん！最も必要不可欠な行のみを含めることから始め、外部テーブルについて反復的に学んでいきましょう。

> **続行するには正しい回答が必要です**

**問題:** 次のうち、ステージの上に直接配置できるのはどれですか？

- [ ] 外部テーブル
- [ ] 「通常の」ビュー
- [ ] マテリアライズドビュー

**[送信]**

---

## 🥋 外部テーブルを作成してみましょう

### 🥋 超シンプルで最小限の外部テーブルを作成する

この文をコピー＆ペーストして、作成できる最も最小限のテーブルを体感しましょう。

```sql
create or replace external table T_CHERRY_CREEK_TRAIL(
    my_filename varchar(100) as (metadata$filename::varchar(100))
)
location= @trails_parquet
auto_refresh = true
file_format = (type = parquet);
```

---

### 📓 外部テーブルに外部ストレージが必要な理由

名前から想像できるように、外部テーブルは元々**外部ストレージ**を念頭に置いて作られました。

MelとZenaはラピッドプロトタイプを構築しています。それがロードされていないデータを使用する理由です。しかし、ほとんどの場合、組織がデータのロードを避ける理由は以下の通りです：

- まだ完全に非正規化したくない
- セキュリティやガバナンスの理由でデータをSnowflakeに移動できない
- データの複数のコピーを持ちたくなく、データが他のシステムでも利用可能である必要がある
- Snowflakeへの**ベンダーロックイン**を避けたい

外部に保存されたデータは通常、**Azure Blobストレージ**、**GCPバケット**、または**AWS S3バケット**にあります。

> Essentialsバッジワークショップでは、Azure・GCP・AWSのアカウントに登録させないようにしています。この場合、AWS S3バケットを設定し、同じCherry Creek Trail Parquetファイルをロードしています。これにより、自分のAWSアカウントを設定することなく、外部テーブルの探索を続けることができます。

---

## 🥋 外部テーブルをもう一度試しましょう！

### 🥋 外部テーブル用の外部ステージを作成する

### 🥋 超シンプルで最小限の外部テーブルをもう一度作成する

ファイル名の長さを変更し、ステージの名前を新しい外部ステージに変更してから、コマンドを再度実行してください。

### ✅ 確認

テーブル作成後、`SELECT *` を実行して結果が返ることを確認してください。

---

## 🥋 マテリアライズドビューをもう一度試しましょう

### 📓 マテリアライズドビューを覚えていますか？

数ページ前にお伝えしたことを覚えていますか：

> *ステージ上のデータの上にマテリアライズドビューを配置することはできないため、トレイルデータにはマテリアライズドビューを使用できません。*

重要な詳細を省略していました。**外部テーブルがステージに基づいていても、外部テーブルの上にマテリアライズドビューを配置することはできます！**

つまり、間に外部テーブルを最初に置けば、ステージ上のデータの上にマテリアライズドビューを配置することができるのです！

最新のビューでは、いくつかのことを行います：

1. Parquetファイルの経度と緯度が入れ替わっているエラーを覚えておき、問題を修正する
2. トレイルに沿った3500ポイントすべてについて、メラニーズ・カフェまでの距離を計算する

> これはマテリアライズドビューと外部テーブルの素晴らしい使用例です。計算はやや集中的ですが、場所は変わりません。通常のビューを使用すると、実行されるたびに距離を何度も再計算します。マテリアライズドビューを使用すると、Cherry Creek Trailが変わるか、メラニーズ・カフェが別の建物に移転した場合にのみ変更されます。

---

### 🥋 新しい外部テーブルのセキュアマテリアライズドビューを作成する

セキュアマテリアライズドビュー（Secure Materialized View）にして、`SMV_CHERRY_CREEK_TRAIL` と名付けてください。元の `CHERRY_CREEK_TRAIL` ビューのコピーを出発点として使用します。

```sql
create secure materialized view MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.SMV_CHERRY_CREEK_TRAIL(
    POINT_ID,
    TRAIL_NAME,
    LNG,
    LAT,
    COORD_PAIR,
    DISTANCE_TO_MELANIES
) as
select
 value:sequence_1 as point_id,
 value:trail_name::varchar as trail_name,
 value:latitude::number(11,8) as lng,
 value:longitude::number(11,8) as lat,
 lng||' '||lat as coord_pair,
 locations.distance_to_mc(st_makepoint(lng, lat)) as distance_to_melanies
from t_cherry_creek_trail;
```

---

## ✅ DORA DLKW09

### 🤖 ワークシートでこれを実行してDORAにレポートを送信する

> **緑のチェックを取得するためにDORAコードを編集しないでください。ラボの作業を編集してください。**

```sql
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
  SELECT
  'DLKW09' as step
  ,( select row_count
       from mels_smoothie_challenge_db.information_schema.tables
       where table_schema = 'TRAILS'
       and table_name = 'SMV_CHERRY_CREEK_TRAIL'
    ) as actual
  ,3526 as expected
  ,'Secure Materialized View Created' as description
 );
```

---

## 📓 Apache Icebergテーブルとは？

### 📓 Apache Icebergテーブル

**Iceberg**はオープンソースのテーブルタイプです。**Apache Iceberg**技術はApacheが所有し、オープンソースライセンスの下で提供されています。

**Icebergテーブル**は、Parquetファイル（使用してきたCherry Creek Trailsファイルのような）の上に重ねることができる機能のレイヤーで、ファイルをロード済みデータのように動作させます。この点ではファイルフォーマットに似ていますが、それ以上のものです。

> **IcebergテーブルのデータはSnowflakeを通じて編集可能です！** テーブルだけでなく（テーブル名のような）、そのテーブルが提供するデータ（列と行のデータ値のような）も編集可能です。Snowflakeでロードされていないparquetファイルの上にIcebergテーブルを作成し、SQLを使って**INSERT**や**UPDATE**文でデータを操作できるようになります。

---

### 📓 これですべてが変わる

Snowflakeはしばしば構造化（Structured）で正規化されたデータのソリューション（よく**データウェアハウス**と呼ばれるもの）と考えられています。しばらくの間、**データレイク**が唯一の前進する道だと言う人がいました。最近では、最良のソリューションは**データレイクハウス（Data Lakehouse）**（2つの用語を合わせて両方必要だと言っている）だと多くの人が言っています。

Snowflakeはそのすべてになることができ、Icebergテーブルは素晴らしい追加機能です。

> **続行するには正しい回答が必要です**

**問題:** 次の文のうち正しいものはどれですか？

**3個選択してください:**

- [ ] ファイルフォーマットの参照を含めれば、Snowflake外部ステージの上にマテリアライズドビューを作成できます
- [ ] 間に外部テーブルレイヤーを含めれば、Snowflake外部ステージの上にマテリアライズドビューを作成できます
- [ ] Snowflakeは創業者がスキーが大好きだったため、氷山にちなんで独自のIcebergテーブルに名前を付けました！
- [ ] Icebergテーブルはオープンソースであり、Apacheによって開発、保守、ライセンスされています
- [ ] Snowflakeの外部テーブルを使用して、INSERTやUPDATE文でParquetファイルを編集できます
- [ ] SnowflakeのIcebergテーブルを使用すると、INSERTやUPDATE文でParquetファイルを編集できるようになります

**[送信]**

---

## 🥋 Iceberg外部ボリュームとユーザーの設定

このDocsチュートリアルに従って、Icebergのハンズオン体験に必要なオブジェクトと権限の一部を設定しました。自分のAWS（または他のクラウド）アカウントでIcebergテーブルを設定する場合は、上記のリンクを参照してください。

> **参考:** チュートリアルの2ページ目では、データベースとウェアハウスは作成していません。データベースは後で自分で作成し、自分のウェアハウスを使用します。

次の一連の手順（Docsチュートリアルに記載）は、あなたが行わなくて済むように代わりに行いました。

**チュートリアルの3ページ目（事前設定済み）:**

- `uni-dlkw-iceberg` というバケットを作成しました（公開表示可能）
- `dlkw-iceberg-learner-access-policy` というアクセスポリシーを作成しました
- `dlkw_iceberg_role` というロールを作成し、External IDには `dlkw_iceberg_id` を使用しました

> **外部ボリューム（External Volume）** は1990年代の外付けハードドライブのようなものと考えてください。ストレージの塊であり、この場合はSnowflakeの外部にあります（クラウド内にあります）。

> **注意:** 上記の手順はあなたの代わりに行いました。**以下の手順はあなたが行う必要があります。**

---

### 🥋 外部ボリュームの作成

このワークショップの残りの部分では、**ACCOUNTADMIN**ロールを使用して作業してください。これにより、コアタスクに集中でき、権限の付与について心配する必要がなくなります。

```sql
CREATE OR REPLACE EXTERNAL VOLUME iceberg_external_volume
   STORAGE_LOCATIONS =
      (
         (
            NAME = 'iceberg-s3-us-west-2'
            STORAGE_PROVIDER = 'S3'
            STORAGE_BASE_URL = 's3://uni-dlkw-iceberg'
            STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::321463406630:role/dlkw_iceberg_role'
            STORAGE_AWS_EXTERNAL_ID = 'dlkw_iceberg_id'
         )
      );
```

---

### 🥋 ボリュームを確認する（ユーザー情報も取得する）

```sql
DESC EXTERNAL VOLUME iceberg_external_volume;
```

YSAバッジ管理アプリを使用して、DLKW Link Rowに**Iceberg Volume User**を追加してください。

- https://ysa.snowflakeuniversity.com にアクセスしてください
- YSAアプリにログインするには**UNI_ID**と**UUID**が必要です（training.snowflake.comのコース登録ページで確認できます）

> この情報は安全な場所に保管することをお勧めします。コースの進捗やバッジの状況を確認するためにYSAアプリにアクセスする際に必要になります。

---

## 🥋 Apache Iceberg DBとテーブルの設定

### 🥋 Icebergデータベースの作成

```sql
create database my_iceberg_db
  catalog = 'SNOWFLAKE'
  external_volume = 'iceberg_external_volume';
```

---

### 🥋 テーブルの作成

このテーブルは「Cherry Creek Trail」の `CCT` で始まり、テーブル名の末尾にトライアルアカウントロケーターが追加されます。これにより、各ユーザーが互いのテーブルを上書きすることを防ぎます。

> **注意:** これを試みて権限の問題が表示された場合は、5分待ってから再試行してください。

```sql
set table_name = 'CCT_'||current_account();

create iceberg table identifier($table_name) (
    point_id number(10,0),
    trail_name string,
    coord_pair string,
    distance_to_melanies decimal(20,10),
    user_name string
)
  base_location = $table_name
  as
  select top 100
      point_id,
      trail_name,
      coord_pair,
      distance_to_melanies,
      current_user()
  from MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.SMV_CHERRY_CREEK_TRAIL;
```

新しいテーブルに対してSELECTを実行するには、次を試してください：

```sql
select * from identifier($table_name);
```

---

### 📓 Apache Icebergテーブル作成時のトラブルシューティング

- SnowflakeトライアルアカウントがAWS上にないか、**US-West（Oregon）** リージョンにない場合、Icebergテーブルを作成できません。アカウントは移動できません。唯一の選択肢は、正しいリージョンで新しいトライアルをやり直すことです
- YSAアプリにUSER ARNを入力すると、ユーザーは直ちにポリシーに追加されます。YSAアプリを更新してから**約10分後**にテーブルを作成することをお勧めします
- 待ちすぎると（数日など）、ユーザーがポリシーからキューアウトされる可能性があります。同時にポリシーを共有できるユーザー数は**約25人**に制限されています
- 2025年4月時点では、学習者はポリシーに**約2日間**留まっています
- ウィンドウを逃した場合は、バッジ管理アプリに再度入り、再保存してタイムスタンプを更新する必要がある場合があります

---

## 📓 ここで何がすごいのか？

Apache Icebergテーブルを作成したので、任意の行の任意の値を編集してみてください。

```sql
update identifier($table_name)
set user_name = 'I am amazing!!'
where point_id = 1;
```

動きましたね？そして他のSnowflakeテーブルと全く同じように動作しました。

では、何がすごいのかと思っているかもしれません。これらのIcebergテーブルは他のSnowflakeテーブルと同じように見えますよね？

> 実は、この騒ぎは（現場の開発者としての）あなたよりも、**CEO**、**CTO**、**CFO**の方が気にすることです。Snowflakeの新しいIceberg機能は、経営陣にSnowflakeに**ロックインされていない**という安心感を提供します。特定のデータセットにとって最も理にかなう場合にSnowflakeの外部にデータを保存でき、Snowflakeを学びやすく使いやすくしているすべてのことを犠牲にすることなく実現できます。

これで、上司や将来の上司にIcebergテーブルの経験があることを伝えることができ、きっと喜ばれることでしょう。
