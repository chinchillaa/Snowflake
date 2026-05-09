# Snowflake

Snowflake 関連資格の学習ノートをまとめるディレクトリです。

## 構成

| ディレクトリ | 用途 |
| --- | --- |
| `共通/` | Associate と Core の両方で参照する基礎概念、横断トピック、学習マップ |
| `SnowPro_Associate/` | SnowPro Associate: Platform Certification 向けのまとめ、確認問題、学習アプリ |
| `SnowPro_Core/` | SnowPro Core Certification 向けの確認問題、参考書メモ、学習資材 |
| `handson/` | Snowflake badge/workshop 系の実践教材、共通 SQL、旧版アーカイブ |

## 使い分け

- まず `共通/00_学習マップ.md` で、Associate/Core/共通領域の対応を確認する。
- 個別の試験対策は各資格ディレクトリの `まとめ/`、`確認問題/`、`問題/` を使う。
- 重複しやすいテーマは `共通/01_共通トピック索引.md` から資格別ノートへたどる。
- Associate の各まとめに対応する実行確認用 SQL は `SnowPro_Associate/verification_sql/` を使う。
- Snowflake badge/workshop の手順、SQL、サンプル素材は `handson/badges/` を使う。

## 共通化方針

Associate と Core は、アーキテクチャ、仮想ウェアハウス、データロード、アクセス制御、データ保護、データ共有などで重なる範囲があります。
ただし、試験ごとに求められる深さと問題形式が異なるため、既存ノートを無理に統合せず、共通ディレクトリを入口として参照先を整理します。
