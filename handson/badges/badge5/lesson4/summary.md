# Lesson 4 サマリー — データ強化とETLパイプライン構築

## 学習目標

- **ETL** と **ELT** の違いと使い分けを理解する
- データレイヤー（RAW → ENHANCED → CURATED）の概念を理解する
- **PARSE_IP** 関数と **Marketplace** データを使ってIPアドレスからタイムゾーンを取得できる
- **CONVERT_TIMEZONE** 関数でUTCからローカル時刻に変換できる
- **CTAS**（Create Table As Select）で強化テーブルを作成できる

---

## 学んだこと

### ETL vs ELT

| パターン | 処理順序 | 説明 |
|---|---|---|
| **ETL** | Extract → Transform → Load | 変換してからロード |
| **ELT** | Extract → Load → Transform | ロードしてから変換 |

> **なぜ順序はそれほど重要ではないのか:** 実務では抽出・変換・ロードの順序は柔軟に変わります。このワークショップでは実際にELT（ロード後に変換）を行いましたが、業界では総称して「ETL」と呼ぶことが一般的です。大切なのは順序ではなく、各ステップが正しく行われることです。

### データレイヤーのアーキテクチャ

```
RAW（生データ）
    ↓ 変換・強化
ENHANCED（強化データ）
    ↓ さらなる精製
CURATED（キュレーション済みデータ）
```

| レイヤー | スキーマ | データの状態 |
|---|---|---|
| **RAW** | AGS_GAME_AUDIENCE.RAW | JSONそのまま、最小限の解析 |
| **ENHANCED** | AGS_GAME_AUDIENCE.ENHANCED | タイムゾーン・曜日・時間帯を追加 |
| **CURATED** | （後のレッスンで使用） | 最終的な分析用データ |

> **なぜレイヤーを分けるのか:** データの精製レベルをスキーマで分離することで、問題発生時にどの段階で問題が起きたかを特定しやすくなります。また、RAWデータを保持しておけば、変換ロジックを修正した後にいつでもやり直すことができます。これは「データの不可逆な変換を避ける」という重要なベストプラクティスです。

### PARSE_IP関数

Snowflakeの **PARSE_IP** 関数はIPアドレスを構造化されたオブジェクトに変換します。

```sql
SELECT PARSE_IP('107.217.231.17', 'inet');
```

| プロパティ | 説明 | 取得方法 |
|---|---|---|
| **host** | 元のIPアドレス文字列 | `:host` |
| **family** | IPv4 or IPv6 | `:family` |
| **ipv4** | 数値形式のIPアドレス | `:ipv4` |

> **なぜIPアドレスを数値に変換するのか:** IPアドレスの範囲検索（BETWEEN）を行う際、文字列比較（`'107.217.231.17'`）では正しい結果が得られません。数値形式（`1809442577`）に変換することで、数学的な大小比較が正確に行えます。これがIPInfoのジオロケーションテーブルで `start_ip_int` / `end_ip_int` が整数カラムになっている理由です。

### Snowflake Marketplaceの活用

**IPInfo** のジオロケーションデータは Snowflake Marketplace から無料のサンプルとして入手できます。

```
IPINFO_GEOLOC（データベース：Marketplace共有）
├── DEMO スキーマ
│   └── LOCATION ビュー（IPアドレス範囲 → 地理情報のマッピング）
└── PUBLIC スキーマ
    ├── TO_JOIN_KEY() 関数
    └── TO_INT() 関数
```

> **なぜIPInfoが独自の関数を提供しているのか:** PARSE_IPとBETWEEN句を使った素朴な結合は動作しますが、パフォーマンスが低いです。IPInfoの **TO_JOIN_KEY** 関数は、結合対象の行数を大幅に絞り込む「プリフィルタ」として機能します。これにより、数百万行のロケーションテーブルとの結合が効率的になります。

### 効率的な結合の比較

| アプローチ | 使用する関数 | パフォーマンス |
|---|---|---|
| 素朴な方法 | PARSE_IP + BETWEEN | 遅い（全行スキャン） |
| 最適化された方法 | TO_JOIN_KEY + TO_INT + BETWEEN | 速い（結合キーで絞り込み） |

```sql
SELECT logs.ip_address, logs.user_login, logs.user_event,
       logs.datetime_iso8601, city, region, country, timezone
FROM AGS_GAME_AUDIENCE.RAW.LOGS logs
JOIN IPINFO_GEOLOC.demo.location loc
ON IPINFO_GEOLOC.public.TO_JOIN_KEY(logs.ip_address) = loc.join_key
AND IPINFO_GEOLOC.public.TO_INT(logs.ip_address)
BETWEEN start_ip_int AND end_ip_int;
```

> **なぜすべてのIPアドレスがマッチしないのか:** IPInfoの無料サンプルデータにはすべてのIPアドレス範囲が含まれているわけではありません。また、VPNを使用しているゲーマーのIPアドレスは、実際の物理的な位置とは異なる場所にマッピングされる可能性があります。

### CONVERT_TIMEZONE関数

UTCタイムスタンプをゲーマーのローカルタイムに変換します。

```sql
CONVERT_TIMEZONE('UTC', timezone, logs.datetime_iso8601) AS game_event_ltz
```

> **なぜ3つの引数が必要なのか:** 第1引数は「元のタイムゾーン」（ここではUTC）、第2引数は「変換先のタイムゾーン」（IPInfoから取得したゲーマーのタイムゾーン）、第3引数は「変換するタイムスタンプ」です。元のタイムゾーンを明示しないと、Snowflakeはセッションのデフォルトタイムゾーンを使ってしまい、正確な変換ができません。

### DAYNAME関数とルックアップテーブル

ローカル時刻から**曜日名**と**時間帯名**を導出します：

| 強化カラム | 使用する関数/テーブル | 例 |
|---|---|---|
| **DOW_NAME** | DAYNAME(timestamp) | 'Sat', 'Mon' |
| **TOD_NAME** | TIME_OF_DAY_LU テーブルとの結合 | 'Early evening', 'Late at night' |

> **なぜルックアップテーブルを使うのか:** 「Early morning」「Late evening」などの時間帯ラベルは、HOUR()関数の数値（0〜23）から直接導出できません。ルックアップテーブル（参照テーブル）を用意して結合することで、ビジネスロジック（どの時間帯がどのラベルに対応するか）をSQL内にハードコーディングする必要がなくなります。ラベルを変更したい場合はテーブルの値を更新するだけで済みます。

### CTAS（Create Table As Select）

複雑なSELECT文の結果を新しいテーブルとして保存します。

```sql
CREATE TABLE AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED AS (
    SELECT ...
);
```

> **なぜCTASは「長期的なソリューションではない」のか:** CTASはSELECTの結果をその時点のスナップショットとして保存します。ソースデータが更新されても、CTASで作ったテーブルは自動的には更新されません。プロダクション環境では、定期的にデータを更新する仕組み（タスク、パイプなど）が必要です。CTASはプロトタイプや一回限りの作業に適しています。

### LOGS_ENHANCEDテーブルの最終カラム構成

| カラム名 | 元のカラム/導出元 | 説明 |
|---|---|---|
| IP_ADDRESS | logs.ip_address | ゲーマーのIPアドレス |
| GAMER_NAME | logs.user_login | ゲーマーのログイン名 |
| GAME_EVENT_NAME | logs.user_event | イベント種別（login/logoff） |
| GAME_EVENT_UTC | logs.datetime_iso8601 | UTC+0でのイベント日時 |
| CITY | loc.city | IPから推定された都市 |
| REGION | loc.region | IPから推定された地域 |
| COUNTRY | loc.country | IPから推定された国 |
| GAMER_LTZ_NAME | loc.timezone | ゲーマーのタイムゾーン名 |
| GAME_EVENT_LTZ | CONVERT_TIMEZONE計算 | ローカル時刻でのイベント日時 |
| DOW_NAME | DAYNAME計算 | 曜日名 |
| TOD_NAME | ルックアップテーブル結合 | 時間帯名 |

---

## 🤖 DORAチェック — DNGW03

```sql
SELECT GRADER(step, (actual = expected), actual, expected, description) AS graded_results
FROM (
    SELECT
        'DNGW03' AS step,
        (SELECT COUNT(*)
         FROM AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED
         WHERE dow_name = 'Sat'
         AND tod_name = 'Early evening'
         AND gamer_name LIKE '%prajina') AS actual,
        2 AS expected,
        'Playing the game on a Saturday evening' AS description
);
```

> **このチェックが確認していること:** Kishoreの妹Prajinaが土曜日の夕方（Early evening）にプレイした記録が2行（ログインとログオフ）存在することを検証しています。これは、タイムゾーン変換（UTC → ローカル）、曜日計算（DAYNAME）、時間帯結合（TIME_OF_DAY_LU）がすべて正しく動作していることを一度に確認するテストです。

---

## ✅ 完了チェックリスト

- [ ] **ENHANCED** スキーマが **AGS_GAME_AUDIENCE** データベースに存在する
- [ ] **LOGS_ENHANCED** テーブルが11カラムで作成されている
- [ ] タイムゾーン変換が正しく動作している（テストレコードで確認）
- [ ] 曜日名と時間帯名が正しく割り当てられている
- [ ] DNGW03のDORAチェックがグリーンチェック ✅ を返す
