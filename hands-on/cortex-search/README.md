# Cortex Search ハンズオン学習コース

> Snowflake Cortex Search を一切知らない人が、Snowsight 上で **手を動かしながら** 基礎から実践まで学べるカリキュラム。

---

## 特徴

- **全て Snowflake 上で完結** — ローカル環境のセットアップ不要
- **ハンズオン形式** — 各 Step で「やること」が明確。実行 → 確認のサイクル
- **段階的に深まる** — 基本検索 → フィルタ活用 → RAG パイプライン構築
- **確認クイズ・演習付き** — 各レッスン末尾で理解度をセルフチェック

---

## 前提条件

- Snowflake アカウント（SYSADMIN ロール推奨）
- SQL の基本知識（SELECT / CREATE が書ける）
- Snowsight にログインできる
- ウェアハウスが利用可能であること

---

## Cortex Search とは

Snowflake Cortex Search は、テキストデータに対する **セマンティック検索（意味検索）** をマネージドサービスとして提供する機能。

従来の LIKE / CONTAINS による単純な文字列マッチングではなく、テキストの **意味** を理解した検索が可能になる。

### ユースケース

- ドキュメント検索（社内 FAQ、マニュアル）
- RAG（Retrieval-Augmented Generation）パイプラインの検索部分
- カタログ検索（商品説明から類似商品を探す）
- ナレッジベースの構築

---

## カリキュラム構成

| # | レッスン | 所要時間 | 内容 |
|---|---------|---------|------|
| 1 | [Cortex Search を体感する](lesson_01/lesson_01_what_is_cortex_search.md) | 25分 | サービス作成 → 基本検索 → セマンティック検索の威力を体感 |
| 2 | [フィルタと属性で精密検索](lesson_02/lesson_02_filters_and_attributes.md) | 30分 | FILTER / COLUMNS 指定 → メタデータ活用 → 検索精度向上 |
| 3 | [実践: RAG パイプライン構築](lesson_03/lesson_03_rag_pipeline.md) | 35分 | Cortex Search + COMPLETE() で質問応答システムを構築 |

**合計**: 約 1.5 時間

---

## クイックスタート

### 1. データベースを作成する（SQL Worksheet で1回だけ実行）

```sql
CREATE DATABASE IF NOT EXISTS CORTEX_SEARCH_LEARN;
CREATE SCHEMA IF NOT EXISTS CORTEX_SEARCH_LEARN.DATA;
CREATE SCHEMA IF NOT EXISTS CORTEX_SEARCH_LEARN.SEARCH;
```

### 2. Lesson 1 から順に進める

→ [Lesson 1: Cortex Search を体感する](lesson_01/lesson_01_what_is_cortex_search.md) から開始！

---

## ソースデータ

各レッスンで使用するサンプルデータはレッスン内で作成する（追加のデータ準備不要）。

| レッスン | データ | 内容 |
|---------|--------|------|
| 1 | 製品 FAQ | 簡単な Q&A テキスト（10件） |
| 2 | 技術ドキュメント | カテゴリ・タグ付きドキュメント（20件） |
| 3 | ナレッジベース | 部署別ドキュメント（30件） |

---

## 学習のコツ

1. **必ず手を動かす** — 読むだけでは身につかない。各 Step の SQL を実行する
2. **検索クエリを変えてみる** — 同じサービスに様々なクエリを投げて挙動を観察する
3. **LIKE 検索と比較する** — セマンティック検索との違いを体感する
4. **エラーを恐れない** — サービス作成時のパラメータを変えて実験する
5. **チェックポイントで立ち止まる** — 期待する結果と実際が異なる場合は先に進まず原因を調べる

---

## このコースの位置づけ

```
hands-on/
├── cortex_search/     ← このコース
├── (今後追加予定)
│   ├── cortex_analyst/
│   ├── snowpipe_streaming/
│   ├── dynamic_tables/
│   └── ...
├── archive/
├── badges/
└── common_sql/
```

各機能ごとにディレクトリを分け、同じフォーマットで学習コンテンツを拡張していく。
