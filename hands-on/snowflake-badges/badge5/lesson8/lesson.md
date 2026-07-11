# 🥋 Snowpipeをセットアップしよう！

## 📓 ハブ＆スポーク型Pub/Subシステムの威力

KishoreがSNSトピックとバケットのイベント通知を設定した（実際にはSnowflake Education Servicesチームが設定しましたが、ここではKishoreが設定したことにしましょう）ので、あなたや他のワークショップ参加者はCREATE PIPEステップを実行するだけでOKです！

全員が同じCREATE PIPEステートメントを、同じSNSトピック値で実行するだけで、動くSnowpipeが手に入ります！

さっそく以下のコードを実行しましょう！

---

## 🥋 Snowpipeを作成する

```sql
CREATE OR REPLACE PIPE PIPE_GET_NEW_FILES
auto_ingest=true
aws_sns_topic='arn:aws:sns:us-west-2:321463406630:dngw_topic'
AS 
COPY INTO ED_PIPELINE_LOGS
FROM (
    SELECT 
    METADATA$FILENAME as log_file_name 
  , METADATA$FILE_ROW_NUMBER as log_file_row_id 
  , current_timestamp(0) as load_ltz 
  , get($1,'datetime_iso8601')::timestamp_ntz as DATETIME_ISO8601
  , get($1,'user_event')::text as USER_EVENT
  , get($1,'user_login')::text as USER_LOGIN
  , get($1,'ip_address')::text as IP_ADDRESS    
  FROM @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE_PIPELINE
)
file_format = (format_name = ff_json_logs);
```

---

## 📓 イベント駆動パイプラインの進捗

イベント駆動パイプラインを完成させるために、あと1ステップ残っています。既存の **LOAD_LOGS_ENHANCED** タスクを更新して、**PL_GAME_LOGS** テーブルではなく **ED_PIPELINE_LOGS** テーブルからロードするように変更する必要があります。パイプラインを完成させるには、以前セットアップした **LOAD_LOGS_ENHANCED** タスクを編集してRESUMEします！

---

## 🎯 LOAD_LOGS_ENHANCEDタスクを更新する

旧パイプラインには2つのタスクがありました。新しいパイプラインでは1つのタスクと1つのSnowpipeを使用します。引き続き使用するタスクは、新しい構成に合わせて編集が必要です。

1. まず **LOGS_ENHANCED** テーブルをTRUNCATEして、現在のパイプラインの結果だけを確認できるようにします（念のためクローンを先に作成しても構いません。**LOGS_ENHANCED_BACKUP** という名前にするとよいでしょう）

2. **LOAD_LOGS_ENHANCED** タスクを編集し、**PL_LOGS** ではなく **ED_PIPELINE_LOGS** からロードするように変更します。タスクが実行中の場合は、先にSUSPENDしてください

3. ROOTタスクを使わなくなるため、**LOAD_LOGS_ENHANCED** のトリガーとして使えません。`after AGS_GAME_AUDIENCE.RAW.GET_NEW_FILES` の行を `SCHEDULE = '5 Minutes'` に戻す必要があります

4. タスクをRESUMEします（1日の学習を終えるときは必ずSUSPENDし、次回再開時にオンに戻してください）

> **注意:** この時点で1つのPIPEと1つのTASKが同時に実行されている可能性があります！リソースモニターがブロックした場合は、今日の日次クレジットクォータを2または3に変更してください。

---

## 🪄 チャレンジラボのヒント

1. MERGEタスクの定義をコピーしてワークシートに貼り付けます

2. `r` のSELECT定義を修正し、正しいと思う内容に変更します。ハイライトして単独で実行してテストしてください

3. 次に、`MERGE` から最後までをハイライトしてMERGEを実行します。行がロードされなくても問題ありません。エラーが出なければOKです。完全なステートメントを実行してタスクを新しいバージョンに置き換え、その後タスクをRESUMEします（トリガー型タスクではなく5分ごとに実行されるように編集することを忘れないでください）

---

## 📓 PIPEのアクティビティを確認する

> **注意:** 確認には **ACCOUNTADMIN** に切り替える必要がある場合があります。

**COPY HISTORY** を表示することで、Snowpipeがトリガーされて新しいファイルを処理し、新しいデータ行をロードしていることを確認できます。

**TASK HISTORY** ページでも同様の情報を確認できます。そちらもチェックしてみてください！

Snowpipeが動作していないように見える場合、以下のコマンドで確認・再開できます。

Snowpipeが停止しているように見える場合：

```sql
ALTER PIPE ags_game_audience.raw.PIPE_GET_NEW_FILES REFRESH;
```

パイプが実行中か確認する場合：

```sql
select parse_json(SYSTEM$PIPE_STATUS( 'ags_game_audience.raw.PIPE_GET_NEW_FILES' ));
```

---

# 📓 イベント駆動ロード + CDC

## 📓 完全にイベント駆動？

新しいPipeがパイプライン全体を「イベント駆動」にしたわけではないことにお気づきでしょう。

| ステップ | 駆動方式 | 説明 |
|---|---|---|
| ステップ1 | 時間駆動 | バケットへのファイル書き込みは時間ベースのまま。これはシミュレーション環境だからです。実際にはゲーマーが様々なタイミングでログインし、ログはより自然なペースで到着します |
| ステップ2 | **イベント駆動** | Snowpipeにより実現！ |
| ステップ3 | 時間駆動 | 残念ですが、タスクとパイプという2つの重要なパイプラインデバイスを実際に体験できました。ただし、ステップ3をもう少し「応答性の高い」ものにする方法があります |

ステップ3をより応答性の高いものにするために、**ストリーム（STREAM）** を追加できます。

**ストリーム**は非常に高度で複雑になり得ますが、ここで作成するストリームはごく基本的なものです。実務でストリームを効果的に使うには、より高度なSnowflakeトレーニングを受けるか、自分で調べて実験する必要があります。ここではストリームの存在と最も基本的な仕組みを知ることが目的です。

ストリームは最後のタスクを置き換えるものでもなく、イベント駆動にするものでもありませんが、パイプラインをより**効率的**にします。**変更データキャプチャ（Change Data Capture = CDC）** と呼ばれるテクニックを使えるようにするからです。

---

## 🥋 ストリームを作成する

テーブルへの変更を追跡するストリームを作成します：

```sql
create or replace stream ags_game_audience.raw.ed_cdc_stream 
on table AGS_GAME_AUDIENCE.RAW.ED_PIPELINE_LOGS;
```

作成したストリームを確認します：

```sql
show streams;
```

変更が保留中かどうかを確認します（初回はFALSEが返されます。Snowpipeが新しいファイルをロードした後はTRUEになります）：

```sql
select system$stream_has_data('ed_cdc_stream');
```

---

## 🎯 LOAD_LOGS_ENHANCEDタスクをSUSPENDする

これまで使ってきた **LOAD_LOGS_ENHANCED** タスクは**すべての行**を確認して **LOGS_ENHANCED** テーブルに追加済みかどうかをチェックしていました。このタスクが何年も実行され続けたらどれだけ無駄になるか想像してみてください。膨大なコンピュートリソースを浪費することになります！

より効率的な新しいMERGEタスクを作成するので、**LOAD_LOGS_ENHANCED** タスクを今すぐSUSPENDしてください。もう必要ありません。
