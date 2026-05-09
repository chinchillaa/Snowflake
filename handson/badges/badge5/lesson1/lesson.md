# 🎭 Kishoreに会おう！

Kishoreは、Snowflakeを使ってデータエンジニア（Data Engineer）を目指す登場人物です。このワークショップでは、彼の視点を通じてSnowflakeの実践的なスキルを学びます。

---

> **続行するには正しい回答が必要です**

**問題:** 動画によると、Kishoreの目標の職業は何ですか？

- [ ] Database Administrator
- [ ] Data Scientist
- [ ] Data Engineer
- [ ] Reporting Analyst
- [ ] Support Analyst
- [ ] VR Game Developer

**[送信]**

---

> **続行するには正しい回答が必要です**

**問題:** 動画によると、Agnieszkaの夢の職業は何ですか？

- [ ] Database Administrator
- [ ] Data Scientist
- [ ] Data Engineer
- [ ] Reporting Analyst
- [ ] Support Analyst
- [ ] VR Game Developer

**[送信]**

---

> ⛔ **動画を見て、質問に答え、テキストを読みましょう**
>
> すべての質問に**正しく**回答しないとワークショップを進められません。各質問は何度でもやり直せます。
>
> 動画は短く、最大1.5倍速で視聴できます。動画を見ない場合は、トランスクリプトを最後までスクロールし、クリックしてください。
>
> このワークショップは、軽いトーンでシナリオ主導、比喩が豊富で、ハンズオン形式、インタラクティブ性が高く、最終的にバッジを取得できます。

❕❕❕ **先に進めない場合**

動画を**最後まで**見ましたか？ すべての質問に**正しく**回答しましたか？

---

# 🧭 トライアルアカウントのセットアップ

## 📓 前提条件

以下のワークショップを完了していることを前提としています：

- **Badge 1:** Data Warehousing Workshop
- **Badge 2:** Collaboration, Marketplace & Cost Estimation Workshop

以下も完了していると理想的です：

- **Badge 3:** Data Application Builders Workshop
- **Badge 4:** Data Lake Workshop

---

## 🥋 AWSでSnowflakeトライアルアカウントに登録する

以前のワークショップで使ったトライアルアカウントを**そのまま使い続ける**ことができます。下記の要件を確認してください。

新しいSnowflakeトライアルが必要な場合は、こちらのリンクを使用してください：
https://signup.snowflake.com/?trial=student&cloud=aws&region=us-west-2&utm_source=handsonessentials&utm_campaign=uni-dngw#

---

## 📓 トライアルアカウントのセットアップ確認

- **COMPUTE_WH** という名前のウェアハウスがあるか確認してください（サイズ **XS**、自動サスペンド有効）。なければ作成してください。
- **UTIL_DB** という名前のデータベースがあるか確認してください。なければ作成し、**DORA GRADER** 関数のホームとして使います。
- **SYSADMIN** ロールが **COMPUTE_WH**、**UTIL_DB** データベース、**UTIL_DB.PUBLIC** スキーマを所有していることを確認してください。

---

## 🎯 デフォルト値の設定

ユーザーに**デフォルト値**（DEFAULT）を設定しておくと、ワークシートのコンテキストが自動的に設定され便利です。

KishoreのSnowflakeアカウントでのユーザー名は **KISHOREK** です。彼は以下のコマンドを実行します：

```sql
ALTER USER KISHOREK SET default_role = 'SYSADMIN';
ALTER USER KISHOREK SET default_warehouse = 'COMPUTE_WH';
ALTER USER KISHOREK SET default_namespace = 'UTIL_DB.PUBLIC';
```

---

# 🎭 DORAをセットアップしよう！

## 🥋 2つのDORAセットアップスクリプトを実行する

DORAをセットアップする前に、**UTIL_DB** データベースの作成が必要になる場合があります。作成前にロールを **SYSADMIN** に設定してください。

セットアップスクリプトは公式ページで入手できます。トラブルシューティングセクションにも動画が用意されています。

---

## ✅ DORAは動作していますか？ 以下を実行して確認しましょう！

```sql
USE ROLE ACCOUNTADMIN;

SELECT UTIL_DB.PUBLIC.GRADER(step, (actual = expected), actual, expected, description) AS graded_results
FROM (
    SELECT
        'DORA_IS_WORKING' AS step,
        (SELECT 123) AS actual,
        123 AS expected,
        'Dora is working!' AS description
);
```

> **トラブルシューティング：**
> - GRADER関数が見つからないというエラーが出た場合、ワークシートの右上でロールが **ACCOUNTADMIN** に設定されているか確認してください。
> - それでもエラーが出る場合、Snowflakeのワークシートピッカーで「GRADER」を検索してみてください。
> - 最初のDORAチェックから最後のチェックまで**90日間**の期限があります。期限を過ぎた場合は、古いテストを再実行する必要があります。

---

# 👂 DORAはリスニング中！

## 📓 Snowflakeトライアルアカウントの情報を登録する

learn.snowflake.com のアカウント（このテキストが表示されている場所）と、ラボ作業を行うSnowflakeトライアルアカウントがあります。DORAがどのラボとどの学習アカウントを紐づけるかを知るために、アプリで登録が必要です。

アプリでできること：

- ✏️ 名前やメールアドレスの編集
- ⭐ 表示名のフォーマット — バッジに表示される名前です
- 🔗 学習アカウントとSnowflakeトライアルアカウントの**リンク**を作成
- 🤖 実行したDORAラボチェックの進捗を確認

アプリのURL: https://ysa.snowflakeuniversity.com

ログインには **UNI_ID** と **UUID** が必要です。これらは training.snowflake.com のコース登録ページで確認できます。

> この情報は安全な場所に保管してください。YSAアプリにアクセスするたびに必要になります。

このワークショップでは、まず新しい **DNGW** リンク行を作成してください。同じSnowflakeトライアルアカウントを使い続けている場合でも、新しいリンク行の作成が必要です。

---

# 🏁 レッスン1のまとめ

## ✅ レッスン1を完了する準備はできましたか？

以下のすべてが当てはまりますか？

- [ ] Snowflakeトライアルアカウントを使用している（雇用主のアカウントや他の学習者のアカウントではない）
- [ ] DORA is Listeningページのアプリを使って、Snowflakeトライアルアカウントの情報を送信した
- [ ] DORAスクリプトを実行して、API Integrationをアカウントに追加した
- [ ] DORAスクリプトを実行して、**GRADER** 関数をアカウントに追加し、どのデータベースとスキーマにあるか把握している
- [ ] オブジェクトの**所有権**（OWNERSHIP）と**現在のロール**（CURRENT ROLE）がSnowflakeオブジェクトへのアクセスと使用にどう影響するか理解している
- [ ] **ワークシートコンテキスト**（WORKSHEET CONTEXT）設定がどこに表示され、Snowflakeにどう影響し、どう変更するか理解している

すべて当てはまれば、次のレッスンに進む準備ができています！
