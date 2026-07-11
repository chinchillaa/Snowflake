# 🎯 キュレーションデータ（Curated Data）

## 🎯 タスクとパイプを停止する

- 実行中のタスクがあれば、停止してください。
- パイプが実行中であれば、一時停止してください。以下のようなコマンドを使います：

```sql
alter pipe mypipe set pipe_execution_paused = true;
```

このコース以降、タスクやパイプは使用しません。代わりに、データについてもう少し学び、その後コースは完了です。

---

## 📓 キュレーション層（CURATED Layer）を作成する

データエンジニアの仕事は、データの強化（Enhanced）が完了した時点で終わる場合があります。

一部の組織では、行レベルを超えて何らかの集計や分析を行うことは、データエンジニアの仕事ではありません。

しかし別の組織では、データエンジニアがデータを強化レベルを超えて**キュレーション済み**（Curated）の状態まで進めることがあります。その場合、アナリストやデータサイエンティストの作業をより速く、より効果的にするための追加処理を行います。

この最終レッスンでは、データ品質をチェックするための簡単な分析として、ダッシュボードチャートを作成します。また、行をより小さく意味のあるデータセットにロールアップするために使えるウィンドウ関数（Windowing Function）も見ていきます。

---

## 🎯 キュレーション層を作成する

- **AGS_GAME_AUDIENCE** データベースに **CURATED** という名前のスキーマを作成してください。
- スキーマのオーナーが **SYSADMIN** であることを確認してください。

---

# 🥋 簡易分析のためのダッシュボード

## 📓 Snowflakeダッシュボード

Snowflakeにはチャートとテーブルを一緒に表示できるダッシュボードがあります。TableauやLookerなどのツールで作成できるものほど高度ではありませんが、データの簡易分析に使用できます。ダッシュボードはSnowflakeの比較的新しい機能で、今後のリリースで多くの改善が予定されていますが、現時点では制限があります。

Kishoreの目標はデータをロードしてAgnieにオーディエンス分析をさせることでしたが、プロジェクトを彼女に引き渡す前に簡単なデータ可視化を行いたいと考えています。

---

## 🥋 新しいダッシュボードを作成してタイルを追加する

## 🥋 チャートを作成する

以前作成したLOGS_ENHANCEDテーブルのクローンを覚えていますか？ **LOGS_ENHANCED_BACKUP** という名前で、約150行のデータが入っています。チャートにはこれを使います。

```sql
select distinct gamer_name, city
from ags_game_audience.enhanced.logs_enhanced_backup;
```

タイルをドラッグして異なる位置に移動できます。高さや幅の調整もできます。

ページに2つのGamer Citiesタイル（テーブルとチャート）が表示された場合、テーブルタイルを削除しないでください。代わりに、右クリックして「UNPLACE TILE」を選択してください。

---

## 📓 Agnieのオーディエンスはどこからプレイしているか？

Agnieのゲームオーディエンスの大半は、アメリカのコロラド州デンバーにいます。Kishore、Agnie、Tsai全員がデンバーに住み、働き、交友関係を持ち、友人や家族にプロジェクトを紹介しているため、これは当然の結果です。

ポーランドのワルシャワは、Agnieの叔父・叔母・いとこが住んでいることで説明がつきます。いとこの一人がワルシャワのゲーマー掲示板でゲームを宣伝していました。

ポーランドのグダニスクには、Agnieの祖父母が住んでいます。

ウィスコンシン州のケノーシャとシェボイガンは、Agnieが育ち大学に通った都市です。SNSにゲームについて投稿したため、学校の友人がゲームを試したのでしょう。

Tsaiの姉妹はケニアで海外学期を過ごしています。

---

# 🥋 タイルを増やして分析を深める

## 🎯 時間帯チャートを追加する

- タイルを複製する
- 名前を「Time of Day」に編集する
- クエリに以下のコードを使用する：

```sql
select tod_name as time_of_day
           , count(*) as tally
     from ags_game_audience.enhanced.logs_enhanced_backup 
     group by  tod_name
     order by tally desc;  
```

さまざまなチャートオプションを試してみてください。ダッシュボードチャートはクールですが、操作が難しいこともあります。棒グラフの向きの変更が難しい場合や、複数色のバーを選択できない場合があります。数分間利用可能なコントロールを理解する程度にして、フラストレーションをためないようにしましょう！

---

## 📓 データとダッシュボードの制限

ステージファイルに書き込まれるデータは3日間のみをカバーしているため、ヒートマップに3日間しか表示されないのは当然です。

前述の通り、Snowflakeダッシュボードにはまだ改善の余地があります。現時点では、本番用ダッシュボードではなく、簡易分析にのみ使用してください。

---

# 🥋 ユーザーごとのイベント集約

## 📓 最も重要なことは？

KishoreはENHANCED_LOGSチャートを見て、Agnieが興味を持つと考えています。

各ゲーマーに対して2つのイベント（ログインとログアウト）があることに気づき、実際のログイン・ログアウトデータはAgnieにとってあまり価値がないと思いますが、各ゲーマーのプレイ時間合計（**game_session_length**）は非常に興味深く価値のある指標になると考えます。時間帯とプレイ時間の長さに強い相関があるかどうかも確認したいと思います。

Agnieから依頼されていませんが、Kishoreは30分ほど費やして、セッション時間の計算と時間帯ラベルとの分析がどれくらい簡単かを調べることにしました。

---

## 🥋 ListAggでログインとログアウトのイベントをロールアップする

```sql
select GAMER_NAME
      , listagg(GAME_EVENT_LTZ,' / ') as login_and_logout
from AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED 
group by gamer_name;
```

これは行を集約する手軽な方法ですが、行のロールアップの目的は、ユーザーがシステムにログインした時間とログアウトした時間を比較してプレイ時間のメトリクスを得ることです。より洗練された方法が必要です。

---

## 🥋 プレイヤーごとのゲーム内時間を計算するウィンドウデータ

```sql
select GAMER_NAME
       ,game_event_ltz as login 
       ,lead(game_event_ltz) 
                OVER (
                    partition by GAMER_NAME 
                    order by GAME_EVENT_LTZ
                ) as logout
       ,coalesce(datediff('mi', login, logout),0) as game_session_length
from AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED
order by game_session_length desc;
```

---

## 🥋 ヒートグリッドのコード

以下のコードをダッシュボードタイルのクエリに入力してください。

セッション時間をバケット化するCASE文を追加しています。

```sql
select case when game_session_length < 10 then '< 10 mins'
            when game_session_length < 20 then '10 to 19 mins'
            when game_session_length < 30 then '20 to 29 mins'
            when game_session_length < 40 then '30 to 39 mins'
            else '> 40 mins' 
            end as session_length
            ,tod_name
from (
select GAMER_NAME
       , tod_name
       ,game_event_ltz as login 
       ,lead(game_event_ltz) 
                OVER (
                    partition by GAMER_NAME 
                    order by GAME_EVENT_LTZ
                ) as logout
       ,coalesce(datediff('mi', login, logout),0) as game_session_length
from AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED_BACKUP)
where logout is not null;
```

---

## 🎯 セッション時間×時間帯のヒートグリッドを追加する

ウィンドウデータの集約を使って、時間帯とセッション時間の相関を示すヒートグリッドをダッシュボードに追加できますか？（残念ながら時間帯を適切にソートできないので、ダッシュボードの挙動に任せましょう！）

---

# 🤖 DORA DNGW07

> ⚠️ **DORAコードは絶対に編集しないでください。** グリーンチェックを得るためにDORAコードを変更するのではなく、ラボ作業を修正してください。

```sql
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
SELECT
'DNGW07' as step
 ,( select count(*)/count(*) from snowflake.account_usage.query_history
    where query_text like '%case when game_session_length < 10%'
  ) as actual
 ,1 as expected
 ,'Curated Data Lesson completed' as description
 ); 
```

---

# 🏁 レッスン9のまとめ

## 🏁 レッスン9を完了する準備はできましたか？

おめでとうございます！このコースのすべてのレッスンを完了しました！
