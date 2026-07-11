# 🎭 Melの追い上げ！

> Melの友人Camilaは、Melのプロジェクトに役立つデータを持っているようです。

> **続行するには正しい回答が必要です**

**問題:** Camilaが持っている、Melのプロジェクトに役立ちそうなデータはどれですか？

- [ ] 勤務先の病院の患者MRIデータ
- [ ] 最近の地方選挙の投票データ
- [ ] サイクリングで取得したGPSトレイルデータ
- [ ] 減量グループの体組成データ

**[送信]**

> **注意:** Google Mapsで「Cherry Creek Trail」を検索すると、「Cherry Creek Trl」と表示される場合があります。ラベルは時期によって変わることがありますが、どちらでも問題ありません。

---

# 📓 地理の復習

## 📓 Melの地理クイックレビュー

Melは地理空間データ（GeoSpatial Data）を使った作業に意欲的ですが、まずは中学校で学んだ地理の基礎を思い出す必要があります！

### 緯度（Latitude）について

- **緯度（Latitude）** は赤道（Equator）から北極・南極に向かって計測されます
- 世界のどの地点でも、緯度は常に **0度から90度** の間です
- 表記方法は2種類あります：
  - **N/S方式:** 北半球は「N」、南半球は「S」で表す
  - **正負方式:** 北半球は **正の数**、南半球は **負の数** で表す

> **続行するには正しい回答が必要です**

**問題:** 正負方式（N/Sの代わりに正/負を使うシステム）では、アメリカ本土の緯度はどちらの数で表されますか？

- [ ] 正の数（Positive）
- [ ] 負の数（Negative）

**[送信]**

### 経度（Longitude）について

- **経度（Longitude）** はグリニッジ子午線（Greenwich Meridian Line、本初子午線（Prime Meridian）とも呼ばれます）から計測されます
- 経度は常に **0度から180度** の間です
- イギリスのグリニッジ（経度0度）から東に進むと0から180まで数が増え、フィジー付近で180度に達します
- 西に進んでも同様に0から180まで数が増えます
- 表記方法は2種類あります：
  - **E/W方式:** 東半球は「E」、西半球は「W」で表す
  - **正負方式:** 東半球は **正の数**、西半球は **負の数** で表す

> **続行するには正しい回答が必要です**

**問題:** 正負方式（E/Wの代わりに正/負を使うシステム）では、アメリカ本土の経度はどちらの数で表されますか？

- [ ] 正の数（Positive）
- [ ] 負の数（Negative）

**[送信]**

---

## 📓 Melの故郷：デンバー（Denver, Colorado, USA）

- 下の図では、白い線が**緯度線**、灰色の線が**経度線**です
- Melの故郷であるコロラド州は、西経100度から西経110度の間の金色の枠で示されています

Melはデンバーに住んでいます。デンバーはコロラド州の州都です。デンバーの位置はおよそ**西経105度、北緯40度**です。MelがGoogle Mapsでデンバーの公式中心点を右クリックしたところ、以下の座標が表示されました：

`39.73962793994306, -104.99016507876348`

> **続行するには正しい回答が必要です**

**問題:** Google Mapsによると、デンバー（Colorado, USA）の緯度はいくつですか？

- [ ] 39.73958127076883, -104.9902864616834
- [ ] -105
- [ ] 40
- [ ] 39.73958127076883

**[送信]**

> **続行するには正しい回答が必要です**

**問題:** Google Mapsによると、デンバー（Colorado, USA）の経度はいくつですか？

- [ ] 39.73958127076883, -104.9902864616834
- [ ] -105
- [ ] 40
- [ ] -104.9902864616834

**[送信]**

---

# 🎭 Melの地理空間データ速習コース

## 📓 地理の速習コース

以下のウェブサイトはMelが使用したものです。必ずしも同じサイトを探索する必要はありませんが、ハンズオンで学びたい方はぜひ試してみてください。

- earth.google.com で「Cherry Creek Trail」（Denver, Colorado, USA）を検索する
- google.com/maps で「Cherry Creek Trail」を検索する
- www.openstreetmap.org を訪問する
- WKT Playground（clydedacruz.github.io/openstreetmap-wkt-playground/）を試す

> **続行するには正しい回答が必要です**

**問題:** Google Mapsである地点の座標を簡単に取得するにはどうすればよいですか？（動画で示された方法）

- [ ] ラインストリング（linestring）をダブルクリックする
- [ ] ポイント（point）を右クリックする
- [ ] ポリゴン（polygon）をCTRL+SHIFTクリックする

**[送信]**

> **続行するには正しい回答が必要です**

**問題:** Google Mapsから取得した座標をWKTポイントに変換する際、何をする必要がありますか？

**2個選択してください:**

- [ ] SouthとWestを負の符号に置き換える
- [ ] 座標を3組のカッコで囲む
- [ ] 2つの数値の間のカンマを削除する
- [ ] 緯度と経度の順序を入れ替える

**[送信]**

---

# 🎯 Camillaの地理空間データ（パート1）

## 🎯 Snowflakeスキルを実践しよう！

Melの新しい友人Camillaも、Snowflakeワークショップを受講し始めました！彼女はバッジ1と2を取得済みなので、Melのプロジェクトのデータインフラ構築を手伝うことになりました。

以下の手順に従って環境を構築してください：

1. 作成するすべてのオブジェクトが **SYSADMIN** ロールで所有されていることを確認する
2. **MELS_SMOOTHIE_CHALLENGE_DB** という名前のデータベースを作成する
3. **PUBLIC** スキーマを削除する
4. **TRAILS** という名前のスキーマを追加する
5. **TRAILS_GEOJSON** という名前の内部ステージ（Internal Named Stage）を作成する
6. **TRAILS_PARQUET** という名前の内部ステージを作成する

> **注意:** 両方のステージについて、クライアントサイド暗号化（Client-Side Encryption）で構いません。両方とも **SYSADMIN** が所有し、**TRAILS** スキーマ内にあることを確認してください。

---

## 🎯 新しいステージにファイルをロードする

以下のファイルをダウンロードしてください：

| ファイル名 | サイズ |
|---|---|
| geoJSON_files.zip | 34.2 KB |
| cherry_creek_trail.parquet | 107.9 KB |

1. **geoJSON_files.zip** を解凍し、geoJSONステージにロードする
2. **cherry_creek_trail.parquet** ファイルをParquetステージにロードする

> **続行するには正しい回答が必要です**

**問題:** 新しいステージにはそれぞれ何個のファイルがありますか？

**2個選択してください:**

- [ ] trails_geojsonに0ファイル
- [ ] trails_parquetに0ファイル
- [ ] trails_geojsonに1ファイル
- [ ] trails_parquetに1ファイル
- [ ] trails_geojsonに4ファイル
- [ ] trails_parquetに4ファイル
- [ ] trails_geojsonに9ファイル
- [ ] trails_parquetに9ファイル

**[送信]**

---

# 🎯 Camillaの地理空間データ（パート2）

## 🥋 シンプルなJSONファイルフォーマットを作成する

**FF_JSON** という名前のファイルフォーマットを作成し、タイプを **JSON** に設定してください。

**TRAILS** スキーマ内に作成し、**SYSADMIN** が所有していることを確認してください。

---

## 🎯 シンプルなParquetファイルフォーマットを作成する

**FF_PARQUET** という名前のファイルフォーマットを作成し、タイプを **PARQUET** に設定してください。

**TRAILS** スキーマ内に作成し、**SYSADMIN** が所有していることを確認してください。

---

## 🥋 TRAILS_GEOJSONステージをクエリする

シンプルな **FF_JSON** ファイルフォーマットを使って、**TRAILS_GEOJSON** ステージにクエリを実行してみましょう。

> データがまだロードされていなくても、`SELECT *` を使用できます。`SELECT $1` 記法を使う必要はありません。

---

## 🎯 TRAILS_PARQUETステージをクエリする

上記のクエリを参考にして、**TRAILS_PARQUET** ステージのデータに対するシンプルなSELECT文を作成してください。

> **続行するには正しい回答が必要です**

**問題:** TRAILS_PARQUETステージへのクエリで返された行数はいくつですか？

- [ ] 5
- [ ] 35
- [ ] 50
- [ ] 350
- [ ] 500
- [ ] 3.5K
- [ ] 5K
- [ ] 30.5K
- [ ] 50K

**[送信]**

---

# 🏁 DORA検証 — DLKW05

## 🤖 ワークシートでDORAにレポートを送信する

> **DORAのコードを編集してグリーンチェックを取得しようとしないでください。ラボの作業内容を修正してください。**

以下のSQLをワークシートで実行してください：

```sql
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
SELECT
'DLKW05' as step
 ,( select sum(tally)
   from
     (select count(*) as tally
      from mels_smoothie_challenge_db.information_schema.stages 
      union all
      select count(*) as tally
      from mels_smoothie_challenge_db.information_schema.file_formats)) as actual
 ,4 as expected
 ,'Camila\'s Trail Data is Ready to Query' as description
 );
```

### ✅ 確認

結果セクションに緑のチェックマーク ✅ が表示されれば成功です。
