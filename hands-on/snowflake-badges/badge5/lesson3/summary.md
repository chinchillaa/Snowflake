# Lesson 3 サマリー — タイムゾーンの理解とデータ調査

## 学習目標

- **UTC**、**GMT**、**LTZ**、**NTZ** の違いを理解する
- Snowflakeのセッションタイムゾーンを変更できる
- ソースデータのタイムゾーンを特定するための調査手法を学ぶ
- LOGSビューを更新して新しいフィールド構成に対応できる

---

## 学んだこと

### タイムゾーンの基本概念

| 略語 | 正式名称 | 意味 |
|---|---|---|
| **GMT** | Greenwich Mean Time | グリニッジ標準時（歴史的な基準） |
| **UTC** | Universal Time, Coordinated | 協定世界時（現代のグローバル標準） |
| **LTZ** | Local Time Zone | ローカルタイムゾーン（各地域の現地時刻） |
| **NTZ** | No Time Zone | タイムゾーン情報なし |
| **Zulu Time** | — | UTC+0の軍事用語（Zは「Zulu」） |

> **なぜUTCがGMTより好まれるのか:** GMTは特定の国（イギリス）に紐づいた名前ですが、UTCは国に依存しないグローバルな標準です。技術的にはGMT+0とUTC+0は同じ時刻を指しますが、国際的なデータ処理では中立的なUTCが推奨されます。

### Snowflakeのタイムゾーン設定

Snowflakeでは、タイムゾーンを**セッション**（Session）単位で変更できます。

```sql
ALTER SESSION SET timezone = 'UTC';
```

> **なぜSnowflakeのデフォルトが「America/Los_Angeles」なのか:** Snowflakeはカリフォルニア州サンマテオで設立されました。そのため、すべてのトライアルアカウントのデフォルトタイムゾーンが太平洋時間（America/Los_Angeles）に設定されています。これはUTC-7（夏時間中）またはUTC-8（標準時間中）に相当します。

### Snowflakeのタイムスタンプ型の比較

| 型 | 説明 | タイムゾーン情報 |
|---|---|---|
| **TIMESTAMP_NTZ** | タイムゾーンなしのタイムスタンプ | 含まない |
| **TIMESTAMP_LTZ** | ローカルタイムゾーンのタイムスタンプ | セッション設定を使用 |
| **TIMESTAMP_TZ** | タイムゾーン付きのタイムスタンプ | 明示的に含む |

> **なぜタイムスタンプ型の選択が重要なのか:** TIMESTAMP_NTZで格納されたデータは、セッションのタイムゾーン設定に影響されません。一方、TIMESTAMP_LTZはセッション設定に応じて表示が変わります。データの意味を正確に保つためには、用途に合った型を選ぶことが不可欠です。

### ソースデータのタイムゾーン調査

タイムゾーン情報がない（NTZ）データに遭遇した場合、以下の3つの方法で調査します：

1. **知っている人に聞く** — ソースシステムの開発者に直接確認
2. **ドキュメントを調べる** — APIドキュメントやフォーラムを検索
3. **テストデータで検証する** — 既知の時刻にアクションを取り、記録されたデータと比較

> **なぜテストデータによる検証が最も信頼性が高いのか:** ドキュメントが古い・不正確な場合や、開発者がすぐに回答できない場合があります。自分でテストデータを生成し、既知の時刻（写真で記録するなど）と比較すれば、実際の動作を直接確認できます。Kishoreはこの方法で、datetimeがUTC+0で記録されていることを突き止めました。

### フィードの更新とビューの対応

Agnieがフィードのフィールドを変更しました：

| 変更 | フィールド | 理由 |
|---|---|---|
| 追加 | **IP_ADDRESS** | ジオロケーションによるタイムゾーン推定に有用 |
| 削除 | **AGENT** | チームが不要と判断 |

この結果、GAME_LOGSテーブルには2種類のレコードが混在します：

```
GAME_LOGS テーブル（534行）
├── 旧レコード（250行）: AGENTあり、IP_ADDRESSなし
└── 新レコード（284行）: AGENTなし、IP_ADDRESSあり
```

> **なぜテーブルから古い行を削除しないのか:** VARIANTカラムの**スキーマオンリード**（Schema-on-Read）の利点を活かします。テーブルには生データをそのまま保持し、ビュー側でWHERE句を使ってフィルタリングします。これにより、元データを失うリスクなく新しいスキーマに対応できます。

### LOGSビューの更新

ビューを `CREATE OR REPLACE VIEW` で再定義し、以下の変更を行います：

- **AGENT** カラムを除外する
- **IP_ADDRESS** カラムを追加する
- 旧レコードを除外する **WHERE** 句を追加する（`RAW_LOG:ip_address::text IS NOT NULL`）

> **なぜCREATE OR REPLACEを使うのか:** Snowflakeでビューの定義を変更するには、ビューを一度削除して再作成するか、`CREATE OR REPLACE VIEW` を使います。後者は1文で完了し、依存関係を壊すリスクが低いため推奨されます。

### テストレコードの検索テクニック

部分一致検索には **ILIKE** とワイルドカード **%** を使います：

```sql
WHERE USER_LOGIN ILIKE '%kishore%'
```

| 演算子 | 大文字小文字 | 用途 |
|---|---|---|
| **LIKE** | 区別する | 正確なパターンマッチ |
| **ILIKE** | 区別しない | 柔軟な検索（推奨） |

> **なぜLIKEではなくILIKEを使うのか:** ゲーマー名は「kingKishore」「KishoreDaKing」「kishore_123」など大文字小文字が混在する可能性があります。ILIKEは大文字小文字を区別しないため、より多くのパターンにマッチします。

---

## 🤖 DORAチェック — DNGW02

```sql
SELECT GRADER(step, (actual = expected), actual, expected, description) AS graded_results
FROM (
    SELECT
        'DNGW02' AS step,
        (SELECT SUM(tally) FROM (
            SELECT (COUNT(*) * -1) AS tally FROM AGS_GAME_AUDIENCE.RAW.LOGS
            UNION ALL
            SELECT COUNT(*) AS tally FROM AGS_GAME_AUDIENCE.RAW.GAME_LOGS
        )) AS actual,
        250 AS expected,
        'View is filtered' AS description
);
```

> **このチェックが確認していること:** GAME_LOGS（テーブル）の行数からLOGS（ビュー）の行数を引いた差が250であることを検証しています。テーブルに534行あり、ビューが284行を返す場合、534 - 284 = 250となり、古い250行が正しくフィルタリングされていることを確認しています。

---

## ✅ 完了チェックリスト

- [ ] **LOGS** ビューが284行を返す
- [ ] **LOGS** ビューが **IP_ADDRESS** カラムを含む
- [ ] **LOGS** ビューが **AGENT** カラムを含まない
- [ ] テストレコードでdatetimeがUTC+0で記録されていることを確認した
- [ ] DNGW02のDORAチェックがグリーンチェック ✅ を返す
