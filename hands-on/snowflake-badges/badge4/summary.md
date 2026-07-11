# Badge 4: Data Lake Workshop (DLKW) まとめ

## ワークショップ概要

Snowflakeの**データレイク**機能を学ぶワークショップ。データをSnowflakeテーブルにロードせずに、ステージ上のファイルに直接アクセス・分析する手法を習得する。

Zena（スムージーショップオーナー）がアスレジャー衣料品カタログのプロトタイプを構築するストーリーに沿って学習を進める。

---

## レッスン構成

| レッスン | テーマ | 主な学習内容 |
|---|---|---|
| [Lesson 2](lesson2/summary.md) | データ型・ステージの基礎 | データ構造の種類、ステージオブジェクトの本質的な役割 |
| [Lesson 3](lesson3/summary.md) | 非ロードデータの活用 | ファイルフォーマット、ビュー作成、データクレンジング |
| [Lesson 4](lesson4/summary.md) | 非構造化データとカタログ構築 | ディレクトリテーブル、JOIN、CROSS JOIN、データレイクハウス |

---

## キーワード

- **データレイク**: Snowflakeテーブルにロードせずアクセスできるデータ
- **データレイクハウス**: ロード済みデータと非ロードデータを組み合わせたアプローチ
- **非ロードデータ (Non-loaded Data)**: テーブルにロードせずステージ上で直接クエリするデータ
- **ステージオブジェクト**: クラウドフォルダへの「名前付きゲートウェイ」

---

## 作成した主なオブジェクト

| オブジェクト | 種類 | 説明 |
|---|---|---|
| `ZENAS_ATHLEISURE_DB` | Database | アスレジャー商品カタログ用DB |
| `PRODUCTS` | Schema | 商品データ格納用スキーマ |
| `SWEATSUITS` | Internal Stage | スウェットスーツ画像の格納 |
| `PRODUCT_METADATA` | Internal Stage | 商品メタデータ(テキスト)の格納 |
| `ZMD_FILE_FORMAT_1` | File Format | セミコロン区切り |
| `ZMD_FILE_FORMAT_2` | File Format | セミコロン区切り・パイプ区切り |
| `ZMD_FILE_FORMAT_3` | File Format | キャレット区切り・イコール区切り |
| `SWEATSUIT_SIZES` | View | サイズ一覧(18行) |
| `SWEATBAND_PRODUCT_LINE` | View | 商品ライン(10行) |
| `SWEATBAND_COORDINATION` | View | コーディネート提案(10行) |
| `SWEATSUITS` | Table | 商品マスタ(10色) |
| `UPSELL_MAPPING` | Table | アップセル対応表 |
| `PRODUCT_LIST` | View | 商品一覧(ディレクトリテーブルとJOIN) |
| `CATALOG` | View | 全商品×全サイズのカタログ(180行) |
| `CATALOG_FOR_WEBSITE` | View | Webカタログ用最終ビュー |
