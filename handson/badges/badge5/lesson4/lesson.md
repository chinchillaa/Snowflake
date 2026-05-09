# 📓 ETL? それとも ELT?

## 📓 抽出、変換、ロード

データエンジニアの主な仕事は **ETLパイプライン** を構築することです。ETLは **Extract（抽出）**、**Transform（変換）**、**Load（ロード）** の頭文字です。

これまでのレッスンで、Agnieがデータを抽出し（2回）、Kishoreがそれをロードしました（2回）。**LOGS** ビューを作成したとき、JSONを個別のカラムに解析しましたが、これも変換の一種と見なせます。

つまり、今回は Extract-Load-Transform の順番で作業しました。しかし、文字の順序にこだわりすぎないことが大切です。データエンジニアとして働けば、抽出・変換・ロードをたくさん行うことになります。

> このワークショップの残りでは、ステップの順序に関わらず **ETL** と呼びます。

---

## 📓 変換後の状態を定義する

データエンジニアの仕事は、**RAW**（生）データを顧客が求める形に精製することです。多くの組織では、データエンジニアは抽出されたデータへのアクセスを与えられ、最終目標（変換後の最終状態）を伝えられます。そこに到達する手順を決めるのはデータエンジニアの裁量です。

これらの選択を「**設計**（Design）」、その結果としてできる構造やプロセスを「**アーキテクチャ**（Architecture）」と呼びます。

データエンジニアは一連のETLステップを実行するため、データが一定の精製レベルに達していることが期待される異なる「**レイヤー**」を持ちます。このワークショップでのレイヤーは：

| レイヤー | 説明 |
|----------|------|
| **RAW** | 生データ |
| **ENHANCED** | 強化されたデータ |
| **CURATED** | キュレーション済みデータ |

---

# 📓 IPアドレス情報を強化する戦略

## 📓 プロジェクトステータスミーティング

チームがランチで進捗を報告します。BSAとしてのTsaiは「**要件のキャプチャ**」を行います。全員が合意でき、作業が完了したとみなせる定義を書き留めようとします。

---

> **続行するには正しい回答が必要です**

**問題:** キックオフミーティング以降のチームの進捗は何ですか？ **該当するものをすべて選択してください。**

- [ ] AgnieがフィードにLTZフィールドを追加し、IP_ADDRESSを削除した
- [ ] AgnieがフィードにIP_ADDRESSを追加し、AGENTを削除した
- [ ] Kishore（とあなた）が新しいバージョンのファイルを正常にロードした
- [ ] Kishore（とあなた）が変更されたフィードがRAW_LOGSテーブルを壊すことを発見した
- [ ] Kishoreのデータテストで、タイムスタンプがUTC+0で来ていることが判明した
- [ ] Kishoreのデータテストで、タイムスタンプがUTC-6で来ていることが判明した
- [ ] チームメンバーが、ローカルタイムゾーンを今すぐフィードに追加できることを確認した
- [ ] チームメンバーが、ローカルタイムゾーンを今すぐフィードに追加できないことを確認した

**[送信]**

---

## 📓 次のステップ

KishoreはIPアドレスを**ジオロケーション**（地理的位置特定）できること、そしてそこからタイムゾーンを推定できることに気づきました。

AgnieはVPNの使用がIPジオロケーションを狂わせる可能性があると指摘しましたが、チームはIPアドレスを使うことは、タイムゾーン情報がまったくないよりはましだと合意しました。

Kishoreは有料のルックアップAPIサービスやダウンロード可能なデータベースファイルなど多くのオプションを検討しましたが、TsaiがSnowflake **Marketplace** にIPアドレスベースのタイムゾーンルックアップを共有で提供している企業がないか確認することを提案しました。

Kishoreは **IPInfo** というリスティングを見つけました。サンプルデータは無料で、少なくとも一部のゲーマーの位置を特定できます。

> Kishoreの最初のデータ**変換**は、各行にタイムゾーンを追加してログデータを**強化**（ENHANCE）することです。

---

## 🎯 SnowflakeのPARSE_IP関数を使う

- Kishoreの妹のログファイルを見つけ、KishoreのVRヘッドセットに割り当てられたIPアドレスをコピーする
- 以下のコードにIPアドレスを貼り付けて実行する：

```sql
SELECT PARSE_IP('<ip address>', 'inet');
```

---

> **続行するには正しい回答が必要です**

**問題:** PARSE_IP関数から返されるプロパティ（キー）はどれですか？ **該当するものをすべて選択してください。**

- [ ] IP_FIELDS
- [ ] IP_TYPE
- [ ] IPV4
- [ ] SNOWFLAKE$TYPE
- [ ] HOST
- [ ] FAMILY
- [ ] NETMASK_PREFIX_LENGTH

**[送信]**

---

## 🎯 PARSE_IPの結果フィールドを取り出す

PARSE_IPの結果から値を取り出すには、閉じ括弧の後にコロンと名前を追加します：

```sql
SELECT PARSE_IP('107.217.231.17', 'inet'):host;
SELECT PARSE_IP('107.217.231.17', 'inet'):family;
```

Kishoreのヘッドセットに割り当てられたIPアドレスを使って、**ipv4** プロパティを取り出してください。この値は比較しやすい数値形式のIPアドレスです。

---

> **続行するには正しい回答が必要です**

**問題:** KishoreのヘッドセットのIPアドレスをipv4形式で表した値はどれですか？

- [ ] 107.217.231.17
- [ ] 63.235.11.128
- [ ] 1680412832
- [ ] 1809442577

**[送信]**

---

## 🎯 強化インフラストラクチャの作成

- データベースに **ENHANCED** という名前の新しいスキーマを作成する

---

# 🥋 MarketplaceのIPInfoデータ

## 📓 IPInfo無料サンプルデータを見つける

**IPInfo** は、チームが探しているIP情報を提供しています。無料のサンプルリスティングがあり、すぐにアクセスできます。

---

> **続行するには正しい回答が必要です**

**問題:** 新しい **IPINFO_GEOLOC** データベースに含まれるスキーマについて正しいものはどれですか？ **該当するものをすべて選択してください。**

- [ ] RAWという名前のスキーマがある
- [ ] PUBLICという名前のスキーマがある
- [ ] DEMOという名前のスキーマがある
- [ ] INFORMATION_SCHEMAという名前のスキーマがある

**[送信]**

---

> **続行するには正しい回答が必要です**

**問題:** **IPINFO_GEOLOC** データベースで、「LOCATION」というビューはどのスキーマにありますか？

- [ ] RAWスキーマ
- [ ] PUBLICスキーマ
- [ ] DEMOスキーマ
- [ ] INFORMATION_SCHEMAスキーマ

**[送信]**

---

> **続行するには正しい回答が必要です**

**問題:** **IPINFO_GEOLOC** データベースで、「TO_INT」という関数はどのスキーマにありますか？

- [ ] RAWスキーマ
- [ ] PUBLICスキーマ
- [ ] DEMOスキーマ
- [ ] INFORMATION_SCHEMAスキーマ

**[送信]**

---

# 🥋 ログとロケーションの結合

## 🥋 KishoreとPrajinaのタイムゾーンを検索する

PARSE_IP関数を使って、KishoreのヘッドセットのIPアドレスからタイムゾーンを検索します：

```sql
SELECT start_ip, end_ip, start_ip_int, end_ip_int, city, region, country, timezone
FROM IPINFO_GEOLOC.demo.location
WHERE PARSE_IP('100.41.16.160', 'inet'):ipv4
BETWEEN start_ip_int AND end_ip_int;
```

---

## 🥋 全員のタイムゾーンを検索する

PARSE_IP関数を使用してログとロケーションテーブルを結合し、各行にタイムゾーンを追加します：

```sql
SELECT logs.*,
       loc.city,
       loc.region,
       loc.country,
       loc.timezone
FROM AGS_GAME_AUDIENCE.RAW.LOGS logs
JOIN IPINFO_GEOLOC.demo.location loc
WHERE PARSE_IP(logs.ip_address, 'inet'):ipv4
BETWEEN start_ip_int AND end_ip_int;
```

> 上記のクエリで284行すべてが返されなくても心配しないでください。AgnieのデータのすべてのIPアドレスが共有データに掲載されているわけではありません。

---

## 📓 コストはどれくらい？

IPInfoのジオロケーション共有を使ったタイムゾーン検索は、Kishoreのデータパイプラインの重要な部分になります。データは無料ですが、クエリを実行する人はウェアハウスの使用時間についてSnowflakeに料金を支払います。

クエリを実行した後は、**クエリプロファイル**（Query Profile）を確認して「**パフォーマンス**」が良いか確認することが重要です。

---

# 🥋 より効率的なタイムゾーン検索

## 📓 共有の一部としての関数

IPInfoが提供する2つの関数に注目します：

- **TO_JOIN_KEY** 関数 — IPアドレスを、マッチする可能性のある行の範囲との結合に役立つ整数に変換します
- **TO_INT** 関数 — IPアドレスを整数に変換し、文字列として比較する必要をなくします

---

## 🥋 IPInfoの関数を使った効率的な検索

```sql
SELECT logs.ip_address,
       logs.user_login,
       logs.user_event,
       logs.datetime_iso8601,
       city,
       region,
       country,
       timezone
FROM AGS_GAME_AUDIENCE.RAW.LOGS logs
JOIN IPINFO_GEOLOC.demo.location loc
ON IPINFO_GEOLOC.public.TO_JOIN_KEY(logs.ip_address) = loc.join_key
AND IPINFO_GEOLOC.public.TO_INT(logs.ip_address)
BETWEEN start_ip_int AND end_ip_int;
```

> IPInfoの共有データは時間とともに変わります。今後のDORAチェックでは行数のカウントは行いませんので、返された行の内容に注目してください。

---

# 🎯 LTZカラムの追加！

## 📓 ローカルタイムカラムを作成する

ログの各行には、ゲームイベント（ログインまたはログオフ）が発生した日時のタイムスタンプがあります。Kishoreの計算とテストから、これらのタイムスタンプは **UTC+0** であると確信しています。

これで多くのゲーマーのローカルタイムゾーンがわかりました。この3つの情報を使って、ゲームイベントのローカル日時を含む新しいカラムを作成できます。

Kishoreは docs.snowflake.com で見つけた **CONVERT_TIMEZONE** 関数を使用します。

---

## 🎯 SELECTにローカルタイムゾーンカラムを追加する

- 最後に実行したコードブロックに **GAME_EVENT_LTZ** というカラムを追加する
- 新しいカラムを作成したら、Kishoreの妹が作ったテストレコードを使って変換が正しく動作しているか確認する

---

# 🖼️ 追加の強化を計画する

## 🖼️ アップデートと計画

Kishoreはチームに素晴らしいニュースを伝えます。昼休みにAgnieとTsaiとZoomミーティングを行いました。

---

> **続行するには正しい回答が必要です**

**問題:** Kishoreがチームに報告できる前回のミーティング以降の成果は何ですか？ **該当するものをすべて選択してください。**

- [ ] IPアドレスを解析するSnowflake関数を見つけて使った
- [ ] ローカルタイムゾーンをデータに割り当てるMarketplaceデータ共有を見つけた
- [ ] タイムゾーンを使ってイベントタイムスタンプをローカルからUTCに変換できた
- [ ] タイムゾーンを使ってイベントタイムスタンプをUTCからローカルに変換できた

**[送信]**

---

## 📓 さらなるデータ強化の計画

チームは以下の3つの強化を計画しました：

1. **Agnie** — ゲーマーが1日のどの時間帯にプレイしているか知りたい（放課後？夕方？深夜？）
2. **Tsai** — 平日と週末のどちらにプレイしているかも役立つと提案
3. **Kishore** — ログインからログアウトまでのプレイ時間を算出できると考えている

---

## 🎯 DOW_NAMEカラムを追加する

**DAYNAME** 関数を使って、曜日名（Day of Week）を **DOW_NAME** というカラムとしてSELECTに追加してください。ローカルタイムゾーンの日時値を使用して、ローカル時間の曜日を取得してください。

> ドキュメントページが難しい場合は、ページの下部にスクロールするか、右側の見出しの「EXAMPLES」リンクをクリックしてコードサンプルを確認してください。

---

# 🥋 時間帯の強化を有効にする

## 📓 時間帯の割り当て

Agnieはゲーマーが1日のどの「時間帯」にプレイしているか知りたいのですが、数値ではなく「放課後」や「朝食前」のようなラベルを求めています。

議論の末、KishoreとAgnieは「Early morning」「Mid-morning」のようなラベルを使うことで合意しました。

---

## 🥋 テーブルを作成して値を挿入する

```sql
CREATE TABLE AGS_GAME_AUDIENCE.RAW.TIME_OF_DAY_LU (
    hour NUMBER,
    tod_name VARCHAR(25)
);

INSERT INTO TIME_OF_DAY_LU
VALUES
(6,'Early morning'), (7,'Early morning'), (8,'Early morning'),
(9,'Mid-morning'), (10,'Mid-morning'),
(11,'Late morning'), (12,'Late morning'),
(13,'Early afternoon'), (14,'Early afternoon'),
(15,'Mid-afternoon'), (16,'Mid-afternoon'),
(17,'Late afternoon'), (18,'Late afternoon'),
(19,'Early evening'), (20,'Early evening'),
(21,'Late evening'), (22,'Late evening'), (23,'Late evening'),
(0,'Late at night'), (1,'Late at night'), (2,'Late at night'),
(3,'Toward morning'), (4,'Toward morning'), (5,'Toward morning');
```

---

## 🥋 テーブルを確認する

```sql
SELECT tod_name, LISTAGG(hour, ',')
FROM TIME_OF_DAY_LU
GROUP BY tod_name;
```

---

# 🎯 時間帯の割り当て

## 📓 SQLスキルを伸ばそう！

現在のSELECTと新しい時間帯テーブルを結合し、**TOD_NAME** を結果に含めます。

---

## 🎯 関数を使った結合

データ強化の **TOD_NAME** を作成するには、新しい時間帯テーブルを既存のSELECTのテーブルと結合する必要があります。

新しいルックアップテーブルの「hour」カラムをON句のリンクポイントとして使用してください。ローカルタイムスタンプカラムから数値の時間を取得するために、Snowflakeの**日付と時刻関数**グループの関数が必要です。

> **ヒント：** 基本的な結合構文は以下の通りです：
> ```sql
> SELECT *
> FROM main_table
> JOIN lookup_table
> ON a_function_that_returns_an_hour = lookup_table.hour;
> ```

---

# 🥋 CTASコマンドの使用

## 🎯 SELECTのカラム名を変更する

以下のようにカラム名を変更してください：

| 元のカラム | 新しい名前 |
|-----------|-----------|
| logs.user_login | **GAMER_NAME** |
| logs.user_event | **GAME_EVENT_NAME** |
| logs.datetime_iso8601 | **GAME_EVENT_UTC** |
| timezone | **GAMER_LTZ_NAME** |

---

## 📓 クエリの複雑さ

SELECT文がかなり複雑になってきました。結果をどこかに移動するのが良いでしょう。データはもはやRAWではなく、**ENHANCED** と呼ぶにふさわしくなっています。

**CTAS**（Create Table As Select）文を使って、テーブルを素早く作成できます。長期的なソリューションではありませんが、プロセスロジックを構築する際のステッピングストーンです。

---

## 🥋 SELECTをテーブルに変換する

```sql
CREATE TABLE AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED AS (
    SELECT my stuff
);
```

---

## 🎯 テーブルを確認する

以下の方法でチェックしてください：

- 新しいテーブルに対してSELECT *を実行できるか？
- 行数は期待通りか？
- カラム数と名前は正しいか？
- テーブルは意図したスキーマとデータベースにあるか？
- テーブルを所有するロールは意図したものか？

---

# 🤖 DORA DNGW03

## 🥋 DORAチェックを実行する

> DORAのコードを編集してグリーンチェックを取得しないでください。ラボの作業を修正してください。

```sql
SELECT GRADER(step, (actual = expected), actual, expected, description) AS graded_results
FROM (
    SELECT
        'DNGW03' AS step,
        (SELECT COUNT(*)
         FROM AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED
         WHERE dow_name = 'Sat'
         AND tod_name = 'Early evening'
         AND gamer_name LIKE '%prajina') AS actual,
        2 AS expected,
        'Playing the game on a Saturday evening' AS description
);
```

結果セクションにグリーンチェックが表示された場合のみ続行してください。

---

# 🏁 レッスン4のまとめ

## 🏁 レッスン4を完了する準備はできましたか？

このレッスンは楽しかったですか？

データエンジニアを目指しているなら、楽しめたことを願います。**抽出・変換・ロード**はデータエンジニアの仕事の基本です。

もし楽しめなかった場合は、自分が本当に楽しめる仕事を探すことも検討してみてください！
