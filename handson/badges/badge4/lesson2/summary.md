# Lesson 2: データ型・ステージの基礎

## 学習目標

Snowflakeのデータ型の全体像を理解し、ステージオブジェクトの本質的な役割を学ぶ。

---

## 学んだこと

### 1. データ構造の3分類

| 種類 | 説明 | 例 |
|---|---|---|
| **構造化データ (Structured)** | 行と列で整然と整理されたデータ | RDBのテーブル、CSV |
| **半構造化データ (Semi-structured)** | 一定のパターンはあるが行列に収まらない | JSON, XML, Parquet |
| **非構造化データ (Unstructured)** | 行列やパターンに収まらないデータ | 画像, 動画, 音声, PDF |

### 2. Snowflakeのデータ型

以下のデータ型を確認（`UTIL_DB.PUBLIC.my_data_types` テーブルで実践）:

- `NUMBER` - 数値
- `VARCHAR` - 文字列
- `BOOLEAN` - 真偽値
- `FLOAT` - 浮動小数点数
- `DATE` - 日付
- `TIMESTAMP_TZ` - タイムゾーン付きタイムスタンプ
- `VARIANT` - 半構造化データ格納用
- `ARRAY` - 配列
- `OBJECT` - キーバリュー形式
- `GEOGRAPHY` - 地理空間データ
- `GEOMETRY` - 幾何データ
- `VECTOR` - ベクトルデータ

### 3. ステージの本質

- ステージ = クラウドフォルダへの**名前付きゲートウェイ**
- テーブルではなくファイルを格納するための仮想ロケーション
- 内部ステージ (Internal Named Stage) を利用

### 4. 作成したオブジェクト

```
ZENAS_ATHLEISURE_DB
  └── PRODUCTS (スキーマ)
       ├── @SWEATSUITS (内部ステージ - スウェットスーツ画像10枚)
       └── @PRODUCT_METADATA (内部ステージ - テキストファイル3つ)
```

#### ステージ内ファイル

**@PRODUCT_METADATA:**
- `sweatsuit_sizes.txt` - サイズ一覧
- `swt_product_line.txt` - 商品ラインデータ
- `product_coordination_suggestions.txt` - コーディネート提案

**@SWEATSUITS/CLOTHING:**
- 10色のスウェットスーツ画像 (`.png`)

---

## DORA チェック: DLKW01

ステージ `PRODUCT_METADATA` と `SWEATSUITS` が正しく作成されているか検証。
