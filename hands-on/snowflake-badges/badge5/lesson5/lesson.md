# 📓 プロダクション化とは何か？

## 📓 次回はどうする？

Kishoreはこれまで、ファイルからデータを抽出し、強化（変換）し、データベーステーブルにロードすることに成功しました。

その過程で、彼は以下のことを行いました：

- JSONフォーマットからリレーショナルな表現にデータを正規化した
- IPアドレス情報を使ってローカルタイムゾーンを追加した
- 各ゲーマーのローカルタイムゾーンでのタイムスタンプを計算した
- 曜日や時間帯でゲームイベントをグループ化するためのカラムを追加した

しかし、これを1回、1つのファイルに対して行っただけです。

もしAgnieが毎日新しいログファイルを取り込みたい場合はどうなるでしょうか？ 手動では大変な作業になります。

外部ファイルから強化テーブルのロードまで、データの移動を自動化するにはどうすればよいか？ これを一般的に「**プロダクション化**（Productionizing）」と呼びます。

プロダクション化にはいくつかの方法がありますが、まず過去の方法を紹介してから、モダンなSnowflake流の方法を紹介します。

---

# 🥋 Y2K時代のプロダクション化ローディング！

## 📓 ダンプ＆リフレッシュ — Y2Kパーティー！

2000年代初頭、多くのデータエンジニアはテーブルを空にして、5分ごとにすべての行を完全に再ロードしていました。

**TRUNCATE** でテーブルを空にし、**INSERT** で再ロードするというY2K時代のやり方を体験しましょう。

---

## 🥋 Y2K時代のようにTrunc & Reloadする

テーブルの全行を削除してから、すべてを再挿入します：

```sql
TRUNCATE TABLE AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;

INSERT INTO AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED (
    SELECT logs.ip_address,
           logs.user_login AS GAMER_NAME,
           logs.user_event AS GAME_EVENT_NAME,
           logs.datetime_iso8601 AS GAME_EVENT_UTC,
           city,
           region,
           country,
           timezone AS GAMER_LTZ_NAME,
           CONVERT_TIMEZONE('UTC', timezone, logs.datetime_iso8601) AS game_event_ltz,
           DAYNAME(game_event_ltz) AS DOW_NAME,
           TOD_NAME
    FROM AGS_GAME_AUDIENCE.RAW.LOGS logs
    JOIN IPINFO_GEOLOC.demo.location loc
        ON IPINFO_GEOLOC.public.TO_JOIN_KEY(logs.ip_address) = loc.join_key
        AND IPINFO_GEOLOC.public.TO_INT(logs.ip_address) BETWEEN start_ip_int AND end_ip_int
    JOIN AGS_GAME_AUDIENCE.RAW.TIME_OF_DAY_LU tod
        ON HOUR(game_event_ltz) = tod.hour
);
```

---

# 🥋 ゼロコピークローニング

## 📓 コピー＆ペーストクローニングによる再構築と置換

データウェアハウス初期には、毎晩新しいデータウェアハウスを丸ごと構築し、完成したら古いものにアーカイブ名を、新しいものに標準名を付けるという方法が使われていました。

Snowflakeにはデータベース、スキーマ、テーブルを**クローン**する機能がありますが、これは「**ゼロコピークローニング**（Zero-Copy Cloning）」と呼ばれ、2000年代のクローニングとは全く異なるものです。

> Snowflakeのクローニングは非常に高速でコストが低く、テストや開発環境のコピーを作成するのに広く使われています。**クローニング**と**タイムトラベル**（TIME TRAVEL）の組み合わせで、多くの致命的なミスを修復できます。

---

## 🥋 ゼロコピークローニングでバックアップコピーを作成する

```sql
CREATE TABLE AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED_BU
CLONE AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;
```

---

# 🥋 MERGE文の登場！

## 📓 2010年代の洗練されたアプローチ — Merge！

2000年代以降、ほとんどのデータエンジニアはTrunc & Reloadから離れ、**MERGE文**（マージ文）が主役になりました。

SQL MERGEを使うと、新しいレコードとすでにロードされたレコードを比較し、比較結果に基づいて異なる処理を行えます。

シンプルなマージを定義するために、まず以下を決めます：

- **SOURCE**（ソース）= 行の取得元 → **RAW.LOGS**
- **TARGET**（ターゲット）= 行のロード先 → **ENHANCED.LOGS_ENHANCED**

以下はマージコードの出発点です：

```sql
MERGE INTO ENHANCED.LOGS_ENHANCED e
USING RAW.LOGS r
ON r.user_login = e.GAMER_NAME
WHEN MATCHED THEN
UPDATE SET IP_ADDRESS = 'Hey I updated matching rows!';
```

> このコードは、各gamer_nameに複数の行（ログインとログアウト）があるためエラーが返されます。一意のレコードを見つけるために、datetimeフィールドとイベント名を追加する必要があります。

---

## 📓 動作するUpdate Merge

datetimeフィールドを追加することで重複エラーが解消されますが、安全のためにイベント名（例：'login'、'logoff'）も追加しました。

---

## ⁉️ 壊したものを修復する！

マージ文をLOGS_ENHANCEDテーブルで実行した場合、すべてのIPアドレスが上書きされてしまいました。修復方法は3つあります：

1. Y2Kページに戻ってテーブルの完全なTrunc & Reloadを行う
2. クローンテーブル（BUテーブル）を使ってALTER TABLE文でテーブル名をスワップする：

```sql
ALTER TABLE <壊れたテーブル> RENAME TO <一時的な名前>;
ALTER TABLE <クローン/BUテーブル> RENAME TO <元のテーブル名>;
```

3. **タイムトラベル**（TIME TRAVEL）を使ってテーブルを以前の状態に戻す

---

## 🎯 LOGS_ENHANCEDチャレンジラボ

LOGS_ENHANCEDテーブルを正常な状態（IPアドレスを上書きする前の状態）に戻してください。上記の3つの方法のいずれかを使用できます。

完了後、テーブルにはすべての行が含まれ、すべての行に正当なIPアドレスがあるはずです。

---

# 🥋 Insert Mergeを構築する

## 📓 Mergeは強力

Update Mergeの例を見ました。次は **Insert Merge** を作成します。これらは2つの異なるものではなく、MERGEの2つの異なる使い方です。

> 単一のMERGE文で、新しい行の挿入、変更された行の更新、他の行の削除を同時に行えます。

ここではシンプルに、新しい行がTARGETテーブルに**マッチしない**（NOT MATCHED）場合にのみ挿入します。

---

## 🥋 Insert Mergeを構築する

以前のコードを組み合わせて新しいコマンドを構築します：

```sql
MERGE INTO ENHANCED.LOGS_ENHANCED e
USING () r
ON r.user_login = e.GAMER_NAME
AND r.datetime_iso8601 = e.game_event_utc
AND r.user_event = e.game_event_name
WHEN NOT MATCHED THEN
INSERT ()
VALUES ();
```

> **重要：** 「WHEN MATCHED」を「**WHEN NOT MATCHED**」に変更することを忘れないでください。

---

# 🥋 タスクを使ったプロダクション化！

## 📓 Trunc & ReloadもCopy/Pasteクローニングも不要 — モダンな方法で！

Trunc & Reloadは避けたい。Copy/Pasteクローニングも避けたい。代わりに **MERGE文** を使います。これがモダンな方法です。

しかし、毎日（あるいは毎時間）ワークシートからMERGE文を手動実行するのは現実的ではありません。作業を自動化する方法が必要です。

その解決策が **スケジュールされたタスク**（Scheduled Tasks）です！

---

## 🥋 シンプルなタスクを作成する

作成したタスクは実際には何もしておらず、実行もされていません（「Suspended」と表示されています）が、タスクの作成、ウェアハウスの割り当て、スケジュールの設定がいかに簡単かがわかります。

---

# 🥋 タスクを実際に動かす

## 🥋 SYSADMINにタスク実行権限を付与する

```sql
USE ROLE ACCOUNTADMIN;
GRANT EXECUTE TASK ON ACCOUNT TO ROLE SYSADMIN;

USE ROLE SYSADMIN;

EXECUTE TASK AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED;

SHOW TASKS IN ACCOUNT;

DESCRIBE TASK AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED;
```

> **SYSADMIN** ロールがタスクを所有していても、このGRANTを実行しないとタスクをテストできません。

---

## 📓 タスクの実行

タスクを「オン」にすると5分間隔のスケジュールが開始されますが、まだそれはしません。手動でいつでも実行できます：

```sql
EXECUTE TASK AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED;
```

---

## 📓 タスク履歴の確認

タスクに関する多くの情報とその履歴を確認できます。

---

## 🥋 タスクをさらに数回実行する

```sql
EXECUTE TASK AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED;
```

---

## 🥋 エラーを発見して修正する

エラーがなければおめでとうございます！ エラーがあった場合は、Snowflakeが提供するエラーメッセージを読んで原因を特定してください。

よくある問題：**LOGS** ビューを **ACCOUNTADMIN** で編集した場合、**ACCOUNTADMIN** が所有者になります。タスクは **SYSADMIN** が所有しているため、**ACCOUNTADMIN** が所有するビューにアクセスできません。ビューの所有権を更新してください。

---

# 🎯 タスクに高度なSELECTロジックを追加する

## 📓 タスクの改善

タスクを編集して、構築した複雑なロジックを実行するようにしましょう。

---

## 🎯 タスクに高度なSELECTロジックを使用する

Trunc & Reloadで使ったロジックをタスクのロジックとして使用できます。以前のラボ作業やクエリ履歴からロジックをコピーし、タスクの `SELECT 'hello';` 句を置き換えてください。

その後、**CREATE TASK** 文を実行して新しいバージョンのタスクを再作成します。

---

## 🥋 タスクを実行してさらに行をロードしてみる

```sql
SELECT COUNT(*)
FROM AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;

EXECUTE TASK AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED;

SELECT COUNT(*)
FROM AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;
```

> **続行するには正しい回答が必要です**

**問題:** さらにレコードをロードするためにタスクに何をする必要がありますか？

- [ ] 「RESUME」の代わりに「RESUME LOAD」を実行すべきだった
- [ ] SELECTの上にINSERTを追加する
- [ ] より大きいウェアハウスを使う（COMPUTE_WHはExtra Small）
- [ ] 5分ごとではなく毎分実行する

**[送信]**

---

# 🥋 タスクを整える

## 🎯 タスクを行が挿入されるように変換する

タスクのSELECT行の直上に以下の行を追加してください：

```sql
INSERT INTO AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED
```

**CREATE OR REPLACE TASK** コマンドを実行して、古いタスクをこの新しいバージョンに置き換えます。手動でタスクを実行し、テーブルの行数が変化したか確認してください。

---

## 📓 大変だ！

タスクは動いていますが、データが積み上がっています — 良い形ではありません！

ここで新しい重要な用語を学びます：**べき等性**（IDEMPOTENCY）。

つまり、Kishoreはデータをロードするだけでなく、**各レコードを1回だけロードする**ソリューションを設計する必要があります。

Snowflakeにはべき等性のための組み込みヘルパーがありますが、今はこの特定のステップをべき等にすることに集中します。

---

# 🥋 Insert Mergeをテストする

## 📓 タスクにはSELECTだけでなくInsert Mergeが必要

重複行をすべて取り除くために、まずテーブルをTRUNCATEします。次にタスクのロジックを、単純なINSERTの代わりに **Insert MERGE** に変更します。

最初のMERGE実行時にはすべてのレコードがロードされ、2回目の実行時にはレコードがロードされないはずです。

---

## 🥋 新しいスタートのために再度Truncateする

```sql
TRUNCATE TABLE AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;
```

---

## 🎯 タスクを編集してSIMPLE INSERTの代わりにMERGE INSERTを含める

以前のラボのコードを使ってこれを実現できます！

---

## 🥋 MERGE INSERTタスクを実行する

すべての行がロードされましたか？ すべての行がNOT MATCHEDなので、LOGSのすべての行がLOGS_ENHANCEDにロードされるはずです。

> 行数は154行と異なる場合があります。IPマッチングの変更により少なくなることがあります。

---

# 📓 一口ずつ食べよう

## 📓 一口ずつ食べよう

SQLタスクがかなり複雑になっていることに気づきましたか？ SELECTがMERGEにラップされ、さらにTASKにラップされています！

一度にひとつずつ構築し、各部分が何をするか理解しました。

> Desmond Tutuの有名な言葉のように、「象の食べ方は一口ずつ」です。

タスクを作成したら、実行して成功することを確認してください：

```sql
EXECUTE TASK AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED;
```

複数回実行した場合、各レコードの複数コピーが作成されますか？ それともプロセスは**べき等**ですか？

---

## 🥋 テストサイクル（オプション）

```sql
SELECT * FROM AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;

EXECUTE TASK AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED;

SELECT * FROM AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;

INSERT INTO AGS_GAME_AUDIENCE.RAW.GAME_LOGS
SELECT PARSE_JSON('{"datetime_iso8601":"2025-01-01 00:00:00.000", "ip_address":"196.197.196.255", "user_event":"fake event", "user_login":"fake user"}');

EXECUTE TASK AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED;

SELECT * FROM AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;

DELETE FROM AGS_GAME_AUDIENCE.RAW.GAME_LOGS WHERE RAW_LOG LIKE '%fake user%';

DELETE FROM AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED WHERE GAMER_NAME = 'fake user';

SELECT * FROM AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;
```

---

# 🤖 DORA DNGW04

## 🥋 DORAチェックを実行する

> DORAのコードを編集してグリーンチェックを取得しないでください。ラボの作業を修正してください。

```sql
SELECT GRADER(step, (actual = expected), actual, expected, description) AS graded_results
FROM (
    SELECT
        'DNGW04' AS step,
        (SELECT COUNT(*) / IFF(COUNT(*) = 0, 1, COUNT(*))
         FROM TABLE(AGS_GAME_AUDIENCE.INFORMATION_SCHEMA.TASK_HISTORY(
             task_name => 'LOAD_LOGS_ENHANCED'
         ))) AS actual,
        1 AS expected,
        'Task exists and has been run at least once' AS description
);
```

---

# 🏁 レッスン5のまとめ

## 🏁 レッスン5を完了する準備はできましたか？

このレッスンは楽しかったですか？

データエンジニアを目指しているなら、楽しめたことを願います。**パイプラインのプロダクション化**はデータエンジニアのもう1つの主要な仕事です。
