# 🎭 INSERT文はすぐに面倒になる

## 🎭 Uncle Yerがロードウィザードとファイルフォーマットについて学ぶ

---

## 📓 Vegetable Detailsテーブルのデータ

次のページで、Uncle Yerが作成した21行のデータを含むファイルをダウンロードします。Uncle Yerは「Deep」「Shallow」「Medium」という単語を頭文字だけに短縮し、データをCSVファイルとして保存しました。

**CSV** とは **Comma Separated Values**（カンマ区切り値）の略です。ファイル内の各行の値がカンマで区切られていることを意味します。CSVファイルをExcelやGoogle Sheetsで開くと、これらのプログラムがカンマを区切り文字として解釈し、値を異なるカラムに表示します。

ExcelやSheetsで開くのではなく、**メモ帳**（Notepad）や **BBEdit** などのシンプルなテキストエディタで開くようにしてください。そうすると、行の値を区切るカンマが見えます。カンマ以外の文字が区切りに使われることもあるため、シンプルなテキストエディタでファイルを確認する方法を知っておくことが重要です。

---

> **続行するには正しい回答が必要です**

**問題:** Uncle YerのCSVファイルをExcelやSheetsではなく、シンプルなテキストエディタで開くべき理由は何ですか？

- [ ] 一部の植物名にタブが含まれているから
- [ ] Excelは著作権で保護されているから
- [ ] 大文字になっていない単語を確認できるから
- [ ] カンマが各行の値をどのように区切っているかを確認できるから

**[送信]**

---

## 🥋 Vegetable Detailsテーブルを作成する

```sql
create table garden_plants.veggies.vegetable_details
(
plant_name varchar(25)
, root_depth_code varchar(1)    
);
```

---

## 🥋 ファイルからテーブル行をロードする（AからK）

### 🥋 ファイルをダウンロードする

> **veggie_details_a_to_k_comma_opt_enclosed.csv** (288 B)

### 🥋 ファイルをVegetable Detailsテーブルにアップロードする

---

## 🥋 ファイルからテーブル行をロードする（KからZ）

### 🥋 2つ目のファイルをダウンロードする

> **veggie_details_k_to_z_pipe.csv** (283 B)

### 🎯 チャレンジラボ: 2つ目のファイルをテーブルにロードする

先ほどと同じ方法で、同じテーブルにファイルをロードしてください。ロード時に少なくとも1つの設定を変更する必要があることに注意してください。

今回、カラムの区切り文字はカンマ**ではありません**。

> **ヒント:** CSVファイルのカラムや行の区切り文字を確認したい場合は、Excelではなくシンプルなテキストエディタを使用してください。Windowsでは**メモ帳**、Macでは**TextEdit**が適しています。

2つ目のファイル（KからZ）をロードしてください。

次に、ワークシートでSELECT文を実行してテーブルを確認してください。**42行**表示されるはずです。ソート順を逆にすると、Zucchiniが先頭に表示され、2つ目のファイルがロードされたことを確認できます。

誤って同じファイルを2回ロードしてやり直したい場合は、TRUNCATEコマンドを実行してテーブルを空にしてください。

```sql
TRUNCATE TABLE GARDEN_PLANTS.VEGGIES.VEGETABLE_DETAILS;
```

その後、ロードプロセスを最初からやり直してください。

---

## 🤖 DORA DWW06

> ⚠️ **DORAコードは絶対に編集しないでください。** グリーンチェックを得るためにDORAコードを変更するのではなく、ラボ作業を修正してください。

ワークシートのロールを **ACCOUNTADMIN** に設定し、データベースとスキーマをGRADER関数のある場所に設定してください。

```sql
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW06' as step
 ,( select count(*) 
   from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
   where table_name = 'VEGETABLE_DETAILS') as actual
 , 1 as expected
 ,'VEGETABLE_DETAILS Table' as description
); 
```

---

# 🎯 テーブルデータの確認

## 🎯 Vegetable Detailsテーブルを確認する

このチャレンジラボにはステップバイステップの手順はありませんが、いくつかの目標達成のためのガイダンスがあります。

1. データを確認する
2. データセットで2回表示される植物名に気づく
3. 重複行を削除する方法を見つける
4. データを再度確認する

**Spinach** の行が2つあることに気づきます。1つは浅い根（Shallow）の「S」、もう1つは深い根（Deep）の「D」です。深い根の行を削除する必要があります。

まず「D」の行を特定し、**ROOT_DEPTH_CODE** カラムが「D」のSpinach行のみを削除してください。

その後、すべてのデータを再度確認して、植物名が2回表示されるものがないことを確認してください。

---

> **続行するには正しい回答が必要です**

**問題:** 最近の作業を振り返りましょう。以下のうち、実行したタスクをすべて選んでください。

**6個選択してください:**

- [ ] VEGETABLE_DETAILSテーブルに42行をロードした
- [ ] PLANT_NAMEカラムの各値のカウントを示すチャートを確認した
- [ ] PLANT_NAMEが「Celery」の行が2つあることを発見した
- [ ] PLANT_NAMEが「Spinach」の行が2つあることを発見した
- [ ] PLANT_NAMEが「Arugula」の行が2つあることを発見した
- [ ] ROOT_DEPTH_CODEが「D」の行を1つ削除した
- [ ] 41行であることを確認した
- [ ] チャートを使ってPLANT_NAMEカラムの各値のカウントが1であることを確認した

**[送信]**

---

## 🤖 DORA DWW07

> ⚠️ **DORAコードは絶対に編集しないでください。** グリーンチェックを得るためにDORAコードを変更するのではなく、ラボ作業を修正してください。

```sql
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW07' as step
 ,( select row_count 
   from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
   where table_name = 'VEGETABLE_DETAILS') as actual
 , 41 as expected
 , 'VEG_DETAILS row count' as description
); 
```

---

# 🏁 次に進む準備はできていますか？

## ✅ 以下を確認してください

- [ ] **ROOT_DEPTH** テーブルに3行あるか？
- [ ] **VEGETABLE_DETAILS** テーブルに41行あるか？
- [ ] 両方のテーブルが **GARDEN_PLANTS** データベースの **VEGGIES** スキーマにあるか？

すべてに「はい」と答えられれば、次に進みましょう！そうでなければ、正しくない部分を修正してください！
