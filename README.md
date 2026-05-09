# Snowflake

Snowflake 関連資格の学習ノートをまとめるディレクトリです。

## 構成

| ディレクトリ | 用途 |
| --- | --- |
| `app/` | Associate / Core / Advanced / Practical を横断する統合 Web アプリ |
| `共通/` | Associate と Core の両方で参照する基礎概念、横断トピック、学習マップ |
| `SnowPro_Associate/` | SnowPro Associate: Platform Certification 向けの元教材、確認問題、補助アプリ |
| `SnowPro_Core/` | SnowPro Core Certification 向けの確認問題、参考書メモ、学習資材 |
| `handson/` | Snowflake badge/workshop 系の実務・ハンズオン教材、共通 SQL、旧版アーカイブ |

## 使い分け

- まず `app/` を開き、Associate / Core / Advanced / Practical を横断して学習する。
- 現在 `app/` に収録済みの本文は Associate / Basic の基礎まとめであり、今後 Core、Advanced、実務ハンズオンを同じアプリへ追加する。
- `共通/00_学習マップ.md` で、Associate/Core/共通領域の対応を確認する。
- 個別の試験対策は各資格ディレクトリの `まとめ/`、`確認問題/`、`問題/` を使う。
- 重複しやすいテーマは `共通/01_共通トピック索引.md` から資格別ノートへたどる。
- Associate の各まとめに対応する実行確認用 SQL は `SnowPro_Associate/verification_sql/` を使う。
- Snowflake badge/workshop の手順、SQL、サンプル素材は `handson/badges/` を使う。

## 共通化方針

Associate と Core は、アーキテクチャ、仮想ウェアハウス、データロード、アクセス制御、データ保護、データ共有などで重なる範囲があります。
今後は重複する知識を `app/` に集約し、各記事に Track / Level / Depth / Type を付けて、資格レベルと実務レベルを同じ画面で区別できるようにします。
