# Lesson 1 サマリー — 環境セットアップとDORA設定

## 学習目標

- Snowflakeトライアルアカウントの環境を正しく構成できる
- **DORA** 自動採点システムをセットアップして動作確認ができる
- オブジェクトの**所有権**（OWNERSHIP）と**ロール**（ROLE）の関係を理解する
- **ワークシートコンテキスト**（WORKSHEET CONTEXT）の意味と設定方法を理解する

---

## 学んだこと

### トライアルアカウントの前提条件

このワークショップ（Badge 5: DNGW）は、Badge 1〜2の完了を前提とし、Badge 3〜4の完了が推奨されています。

> **なぜ前提条件があるのか:** Badge 5ではJSON解析、外部ステージ、COPY INTOなど多くの概念を前提知識として扱います。Badge 1〜4で段階的にこれらを学んでいるため、未完了の場合はラボ作業で躓く可能性が高くなります。

### 必須オブジェクトの確認

| オブジェクト | 種類 | 要件 |
|---|---|---|
| **COMPUTE_WH** | ウェアハウス | サイズXS、自動サスペンド有効 |
| **UTIL_DB** | データベース | DORA GRADER関数のホーム |
| **UTIL_DB.PUBLIC** | スキーマ | GRADER関数を格納 |

> **なぜSYSADMINが所有すべきなのか:** Snowflakeではオブジェクトにアクセスするには、そのオブジェクトの所有者ロール（または権限を委譲されたロール）である必要があります。ワークショップ全体を通じて **SYSADMIN** を使うため、上記のオブジェクトもすべて **SYSADMIN** が所有していないと、後のレッスンで権限エラーが発生します。

### デフォルト値の設定

ユーザーにデフォルト値を設定すると、ワークシートを開くたびにコンテキストが自動的にセットされます。

```sql
ALTER USER <ユーザー名> SET default_role = 'SYSADMIN';
ALTER USER <ユーザー名> SET default_warehouse = 'COMPUTE_WH';
ALTER USER <ユーザー名> SET default_namespace = 'UTIL_DB.PUBLIC';
```

> **なぜデフォルト値を設定するのか:** ワークシートを開くたびにロール・ウェアハウス・スキーマを手動で設定するのは煩雑です。デフォルト値を設定しておくと、意図しないロール（例: **ACCOUNTADMIN**）でオブジェクトを誤って作成してしまうリスクも減ります。

| 設定項目 | 設定値 | 効果 |
|---|---|---|
| default_role | SYSADMIN | ログイン時のデフォルトロール |
| default_warehouse | COMPUTE_WH | クエリ実行時のデフォルトウェアハウス |
| default_namespace | UTIL_DB.PUBLIC | デフォルトのデータベース.スキーマ |

### DORAのセットアップ

**DORA**（自動採点システム）は、ラボの作業が正しく完了しているかを自動的にチェックする仕組みです。セットアップには2つのスクリプトが必要です：

1. **API Integration** の追加スクリプト
2. **GRADER関数** の追加スクリプト

> **なぜACCOUNTADMINが必要なのか:** GRADER関数の実行にはACCOUNTADMINロールが必要です。これは、GRADER関数が外部APIへの通信（API Integration）を使用しており、この機能はセキュリティ上の理由からACCOUNTADMINのみが作成・管理できるためです。

### DORAの動作確認

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

> **このクエリが確認していること:** actual（実際の値）とexpected（期待値）を比較し、一致していればグリーンチェックを返します。ここでは単に123 = 123を確認しているだけなので、GRADER関数が正しくインストールされ呼び出せることをテストしています。

### YSAアプリでのリンク設定

学習アカウント（learn.snowflake.com）とSnowflakeトライアルアカウントをDORAに紐づけるために、**YSAアプリ**でリンク行を作成する必要があります。

> **なぜワークショップごとに新しいリンク行が必要なのか:** DORAは各ワークショップを個別に追跡しています。同じトライアルアカウントを使っていても、新しいワークショップ（DNGW）用のリンク行を作成しないと、DORAがどのチェック結果をどのワークショップに紐づけるかわかりません。

---

## ✅ 完了チェックリスト

- [ ] Snowflakeトライアルアカウントを使用している
- [ ] YSAアプリでDNGWリンク行を作成した
- [ ] API Integrationスクリプトを実行した
- [ ] GRADER関数を追加し、動作確認が成功した
- [ ] OWNERSHIP と CURRENT ROLE の関係を理解している
- [ ] ワークシートコンテキストの設定方法を理解している
