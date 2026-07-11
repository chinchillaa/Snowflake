## 問題1

**問:** どのビュータイプが、Snowflakeの内部最適化の一部を使用しないですか？

- 永続ビュー（Permanent Views）
- **正解:** セキュアビュー（Secure views）
- マテリアライズドビュー（Materialized Views）
- 外部ビュー（External Views）

## 解説

✅ **セキュアビュー（Secure views）**

通常のビューでは、内部最適化によって間接的にデータがユーザーに露出する可能性があります。セキュアビューは、Snowflakeの内部最適化の一部を除去することで、基礎データを非表示にします。

https://docs.snowflake.com/en/user-guide/views-secure

**分野:** セキュリティ

---

## 問題2

**問:** Snowsightのワークシートについてのどのステートメントが正しいですか？

- どのワークシートのコンテキスト（ロール、ウェアハウス、スキーマ、データベース）も変更できない
- **正解:** 各ワークシートに異なるコンテキスト（ロール、ウェアハウス、スキーマ、データベース）を設定できる
- **正解:** 各ワークシートは異なるセッションとして機能する
- 全てのワークシートは同じセッションを共有する

## 解説

✅ **各ワークシートに異なるコンテキストを設定できる / 各ワークシートは異なるセッションとして機能する**

ワークシートビューでは、クエリが実行されるプライマリロールと、クエリの実行に使用する仮想ウェアハウスを選択できます。また、デフォルトのデータベースとスキーマも選択でき、各ワークシートは独立したセッションです。

https://docs.snowflake.com/en/user-guide/ui-snowsight

**分野:** ツールとインターフェース

---

## 問題3

**問:** フェイルセーフをサポートするSnowflakeの最低エディションはどれですか？

- **正解:** Standard
- Business Critical
- Virtual Private Snowflake
- Enterprise

## 解説

✅ **Standard**

フェイルセーフは全てのSnowflakeエディションでサポートされているため、フェイルセーフをサポートする最低エディションはStandardエディションです。

https://docs.snowflake.com/en/user-guide/data-failsafe

**分野:** フェイルセーフ

---

## 問題4

**問:** Snowflakeがマイクロパーティション内のデータについて保存するメタデータはどれですか？該当するものを全て選択してください。

- **正解:** マイクロパーティション内の各列の値の範囲
- **正解:** 個別の値の数
- **正解:** 最適化と効率的な処理のための追加プロパティ

## 解説

✅ **列の値の範囲 / 個別の値の数 / 最適化のための追加プロパティ**

これらはSnowflakeがマイクロパーティション用に保存するメタデータの有効な例です。Snowflakeは各マイクロパーティションの各列の最大値と最小値をメタデータに保存します。このメタデータを使用して、クエリ処理時にどのパーティションを読み取るかを決定できます。また、各パーティションの各列の個別値の数と、クエリ最適化を支援するその他の情報も保存します。

https://docs.snowflake.com/en/user-guide/tables-clustering-micropartitions

**分野:** アーキテクチャ

---

## 問題5

**問:** 真か偽か：Snowflakeはパートナーソフトウェアがロードした後にデータを変換できる。

- **正解:** True
- False

## 解説

✅ **True**

パートナーソフトウェアを通じてSnowflakeにデータがロードされた後、Snowflake SQL または他のメカニズムを使用してSnowflake内でデータを変換できます。

**分野:** データのロードとアンロード

---

## 問題6

**問:** Snowflakeで列レベルのセキュリティを実装する必要があります。どのテクニックを使用できますか？2つ選択してください。

- **正解:** 外部トークン化（External Tokenization）
- 行レベルセキュリティ（Row-level security）
- **正解:** 動的データマスキング（Dynamic Data Masking）
- オブジェクトセキュリティ（Object Security）

## 解説

✅ **外部トークン化（External Tokenization） / 動的データマスキング（Dynamic Data Masking）**

Snowflakeはマスキングポリシーをサポートしており、列に適用して列レベルのセキュリティを提供できます。列レベルセキュリティは動的データマスキングまたは外部トークン化によって実現されます。

https://docs.snowflake.com/en/user-guide/security-column

**分野:** セキュリティ

---

## 問題7

**問:** 以下のどれがタイムトラベルのSQL拡張機能ですか？

- TIME
- **正解:** BEFORE
- **正解:** UNDROP
- TIMETRAVEL
- **正解:** AT

## 解説

✅ **BEFORE / UNDROP / AT**

タイムトラベルクエリをサポートするために、SnowflakeはSQLの特別な拡張機能をサポートしています。SELECTステートメントや、テーブル・スキーマ・データベースのクローン作成時に使用できるATおよびBEFOREステートメントをサポートします。また、テーブル・スキーマ・完全なデータベースをドロップ後に復元するためのUNDROPステートメントもサポートします。

https://docs.snowflake.com/en/user-guide/data-time-travel#time-travel-sql-extensions

**分野:** タイムトラベル

---

## 問題8

**問:** 作成後、他のテーブルタイプに変換できないものはどれですか？2つ選択してください。

- Permanent（永続）
- **正解:** Temporary（一時）
- **正解:** Transient（過渡）

## 解説

✅ **Temporary（一時） / Transient（過渡）**

一度作成されると、一時テーブルと過渡テーブルは他のテーブルタイプに変更できません。

https://docs.snowflake.com/en/user-guide/tables-temp-transient#creating-a-temporary-table

https://docs.snowflake.com/en/user-guide/tables-temp-transient#creating-a-transient-table-schema-or-database

**分野:** Snowflake's Catalog and objects

---

## 問題9

**問:** SnowpipeおよびCOPY INTOコマンドを通じてテーブルにロードされたデータの履歴を取得するにはどのメソッドを使用できますか？

- **正解:** ACCOUNT_USAGEスキーマのCOPY_HISTORYビューにクエリを実行する
- ACCOUNT_USAGEスキーマのLOAD_HISTORYビューにクエリを実行する
- INFORMATION_SCHEMAのQUERY_HISTORYテーブル関数を使用する
- ACCOUNT_USAGEスキーマのPIPE_USAGE_HISTORYビューにクエリを実行する

## 解説

✅ **ACCOUNT_USAGEスキーマのCOPY_HISTORYビューにクエリを実行する**

ACCOUNT_USAGEスキーマのCOPY_HISTORYビューは、COPYコマンドまたはSnowpipeによる継続的なデータロードのどちらかを通じてロードされたデータの履歴を表示するために使用できます。COPY_HISTORYビューは過去365日間の履歴を表示します。LOAD_HISTORYビューはCOPYコマンドのみのデータを表示します。PIPE_USAGE_HISTORYビューはSnowpipeの履歴のみを表示します。

https://docs.snowflake.com/en/sql-reference/account-usage/copy_history

**分野:** アカウント使用量と監視

---

## 問題10

**問:** Snowflakeのアーキテクチャでユーザー認証と認可を担当するレイヤーはどれですか？

- **正解:** クラウドサービス（Cloud Services）
- クエリ処理（Query Processing）
- クライアントツール（Client Tools）
- データベースストレージ（Database Storage）

## 解説

✅ **クラウドサービス（Cloud Services）**

クラウドサービスレイヤーが認証と認可を管理します。ユーザーがログインすると、クラウドサービスレイヤーが資格情報を検証します。ユーザーがクエリを送信すると、クラウドサービスレイヤーがクエリプランを解析して最適化します。

https://docs.snowflake.com/en/user-guide/intro-key-concepts

**分野:** アーキテクチャ

---

## 問題11

**問:** 真か偽か：ネットワークポリシーを使用して特定のIPアドレスへのアクセスを許可または拒否できる。

- False
- **正解:** True

## 解説

✅ **True**

管理者はネットワークポリシーを通じて特定のIPアドレスへのアクセスを許可または拒否するようにシステムを設定できます。ネットワークポリシーは、ポリシー名、許可されたIPアドレスのカンマ区切りリスト、およびブロックされたIPアドレスのリストで構成されます。

https://docs.snowflake.com/en/user-guide/network-policies

**分野:** セキュリティ

---

## 問題12

**問:** ACCOUNT_USAGEスキーマのビューを通じてアクセスできる履歴データは何日分ですか？

- 7日
- **正解:** 365日
- 90日
- 1日

## 解説

✅ **365日**

ACCOUNT USAGEスキーマは、アカウントレベルでの使用量メトリクスとメタデータ情報を提供するいくつかのビューで構成されています。ACCOUNT_USAGEビューが提供するデータはリアルタイムではなく、ビューによって45分〜3時間のラグがあります。これらのビューのデータは最大365日間保持されます。

https://docs.snowflake.com/en/sql-reference/account-usage#differences-between-account-usage-and-information-schema

**分野:** アカウント使用量と監視

---

## 問題13

**問:** テーブルステージを使用してEMPLOYEEというテーブルにデータをロードする場合、有効なステートメントはどれですか？2つ選択してください。

- COPY INTO EMPLOYEE FROM TABLE_STAGE;
- **正解:** COPY INTO EMPLOYEE FROM @%EMPLOYEE;
- **正解:** COPY INTO EMPLOYEE;
- COPY INTO EMPLOYEE SELECT * FROM TABLE_STAGE;

## 解説

✅ **COPY INTO EMPLOYEE FROM @%EMPLOYEE; / COPY INTO EMPLOYEE;**

テーブルステージからデータをロードする場合、FROM句を省略できます。その場合、Snowflakeは自動的にテーブルステージからデータをロードすると見なします。したがって、`COPY INTO EMPLOYEE;` と `COPY INTO EMPLOYEE FROM @%EMPLOYEE;` の両方が正しいです。

https://docs.snowflake.com/en/user-guide/data-load-local-file-system-copy#table-stage

**分野:** データのロードとアンロード

---

## 問題14

**問:** マルチクラスター仮想ウェアハウスに関する正しいステートメントはどれですか？該当するものを全て選択してください。

- **正解:** マルチクラスター仮想ウェアハウスは、標準の仮想ウェアハウスと同様に自動サスペンドまたは自動レジュームを設定できる
- マルチクラスター仮想ウェアハウスは自動サスペンドまたは自動レジュームを設定できない
- **正解:** マルチクラスター仮想ウェアハウスは、変化するワークロード需要に応じて仮想ウェアハウスを自動的に追加または削除する
- マルチクラスター仮想ウェアハウスのクラスターは手動で追加または削除する必要がある

## 解説

✅ **自動サスペンド・レジューム設定可能 / ワークロードに応じて自動追加・削除**

仮想ウェアハウスの同時ワークロードが最大に達すると、新しいクエリはキューに入ります。マルチクラスター仮想ウェアハウスは必要に応じてクラスターを追加することでこれに対応します。需要が下がると、追加クラスターは削除されます。マルチクラスター仮想ウェアハウスは他の仮想ウェアハウスと同様にサスペンドまたはレジュームでき、自動サスペンド・自動レジュームも設定できます。

https://docs.snowflake.com/en/user-guide/warehouses-multicluster

**分野:** アーキテクチャ

---

## 問題15

**問:** マテリアライズドビューを正しく説明しているものはどれですか？該当するものを全て選択してください。

- マテリアライズドビューをベーステーブルと同期するにはアクティブな仮想ウェアハウスが必要
- 基礎テーブルのデータが変更された場合、マテリアライズドビューは手動で更新する必要がある
- **正解:** Snowflakeが管理するサービスがマテリアライズドビューをベーステーブルと同期し続ける
- **正解:** 基礎テーブルのデータが変更された場合、マテリアライズドビューは自動的に更新される

## 解説

✅ **Snowflake管理サービスが同期 / 基礎テーブル変更時に自動更新**

マテリアライズドビューはSELECTクエリに基づいてデータを事前計算するビューです。基礎テーブルが更新されると、マテリアライズドビューは自動的にリフレッシュされ、追加のメンテナンスは不要です。Snowflakeが管理するサービスがユーザーの操作を妨げることなくバックグラウンドで更新を行います。

https://docs.snowflake.com/en/user-guide/views-materialized

**分野:** パフォーマンスの概念

---

## 問題16

**問:** 組織のセキュリティポリシーにより、テーブルの特定の行をユーザーがクエリできないようにする必要があります。この要件を満たすためにどのSnowflake機能を使用できますか？2つ選択してください。

- 外部ビュー（External Views）
- **正解:** 行アクセスポリシー（Row Access Policies）
- 列レベルセキュリティ（Column Level Security）
- **正解:** セキュアビュー（Secure Views）

## 解説

✅ **行アクセスポリシー（Row Access Policies） / セキュアビュー（Secure Views）**

セキュアビューはテーブルから特定の行のみを返すために使用できます。また、セキュアビューはSnowflakeの内部最適化の一部を削除することで基礎データを非表示にします。あるいは、行レベルセキュリティ（RLS）を使用して特定の行のみを返すこともできます。RLSは行アクセスポリシーを作成することで実装されます。

https://docs.snowflake.com/en/user-guide/views-secure
https://docs.snowflake.com/en/user-guide/security-row-intro

**分野:** セキュリティ

---

## 問題17

**問:** 真か偽か：Snowflakeのデータプロバイダーがデータコンシューマーとデータを共有する場合、データコンシューマーは追加のストレージコストを請求されない。

- False
- **正解:** True

## 解説

✅ **True**

クラウドサービスレイヤーのメタデータ操作により、データを物理的にコピーすることなくデータ共有が可能です。プロバイダーアカウントがデータストレージを保存し支払うため、データコンシューマーはストレージに追加料金を払う必要がありません。ただし、データコンシューマーは共有データでクエリを実行するために使用されるコンピューティングの費用を支払います。

https://docs.snowflake.com/en/user-guide/data-sharing-intro#how-does-secure-data-sharing-work

**分野:** データ共有

---

## 問題18

**問:** 真か偽か：ストアドプロシージャは値を返す必要がある。

- True
- **正解:** False

## 解説

✅ **False**

ストアドプロシージャは必要に応じて単一の値または表形式データを返すこともできますが、ストアドプロシージャが値を返す必要はありません。

https://docs.snowflake.com/en/developer-guide/stored-procedures-vs-udfs

**分野:** Snowflake機能の拡張

---

## 問題19

**問:** 未入力テーブルのクラスタリング深度はいくつですか？

- 1
- -1
- **正解:** ゼロ（Zero）
- 1000

## 解説

✅ **ゼロ（Zero）**

入力済みテーブルの場合、クラスタリング深度は特定の列のオーバーラップするマイクロパーティションの平均深度です。クラスタリング深度は1（よくクラスタリングされたテーブル）から始まり、より大きな数になる可能性があります。未入力テーブルの場合、クラスタリング深度はゼロです。

https://docs.snowflake.com/en/user-guide/tables-clustering-micropartitions#label-clustering-depth

**分野:** パフォーマンスの概念

---

## 問題20

**問:** ユーザーがミディアムサイズの仮想ウェアハウスで完了に2時間かかった複雑なクエリを実行しました。ユーザーが6時間後に新しいセッションでクエリを再実行したところ、ほぼ即座に結果が返されました。この素早い実行の理由は何ですか？

- 基礎テーブルのデータが削除されたため、処理するものがなくてクエリが速かった
- ブラウザキャッシュから結果が取得された
- **正解:** クエリ結果キャッシュを使用して結果が即座に返された
- ユーザーステージから結果が取得されたため実行が速かった

## 解説

✅ **クエリ結果キャッシュを使用して結果が即座に返された**

Snowflakeはクエリを実行すると、そのクエリの結果を一定期間キャッシュします。保存されたクエリ結果はクエリ結果キャッシュと呼ばれます。クエリ結果キャッシュは、以前に実行したクエリと類似していて、クエリされているテーブルのデータに変更がない場合に、将来のクエリを満たすために使用できます。

https://docs.snowflake.com/en/user-guide/querying-persisted-results

**分野:** パフォーマンスの概念

---

## 問題21

**問:** 復旧のためにレプリケーションの設定が必要なシナリオはどれですか？該当するものを全て選択してください。

- 管理者が先週、本番テーブルを誤ってドロップした
- 昨日本番環境にロールアウトされた新しいデータパイプラインが本番テーブルの全行を削除した
- **正解:** プライマリSnowflakeインスタンスをホストしているクラウドプラットフォームが失敗し、利用できなくなった
- 93日前に3つの本番テーブルを破損したデータ破損の問題が発見された
- **正解:** プライマリSnowflakeインスタンスをホストしているクラウドリージョンが壊滅的な障害によりダウンし、データが利用できない

## 解説

✅ **クラウドプラットフォーム障害 / クラウドリージョン壊滅的障害**

クラウドプロバイダーまたはリージョンがダウンすると、Snowflakeユーザーに影響が生じる可能性があります。影響を最小限に抑えるため、クラウドプロバイダーの停止に備えてSnowflakeをユーザーが利用できる状態を維持する必要があります。

Snowflakeのアカウントレベルのレプリケーションとデータベースレプリケーションは、プライマリアカウントから異なるリージョンまたはクラウドプラットフォームの1つ以上のセカンダリアカウントに重要なアカウントオブジェクトとデータを同期します。

https://docs.snowflake.com/en/user-guide/account-replication-intro

**分野:** データ保護

---

## 問題22

**問:** Snowflakeがサポートする半構造化ファイル形式はどれですか？該当するものを全て選択してください。

- YAML
- **正解:** AVRO
- **正解:** JSON
- **正解:** ORC
- PDF

## 解説

✅ **AVRO / JSON / ORC**

Snowflakeにはいくつかの半構造化データ形式のサポートが組み込まれています。SnowflakeはJSON、Avro、ORC、Parquet、XMLをサポートしています。

https://docs.snowflake.com/en/user-guide/semistructured-intro.html

**分野:** データのロードとアンロード

---

## 問題23

**問:** 真か偽か：INFORMATION_SCHEMAのビューのデータはリアルタイムである。

- **正解:** True
- False

## 解説

✅ **True**

INFORMATION_SCHEMAビューを通じて提供されるデータはリアルタイムであり、提供される情報に遅延はありません。リアルタイムデータを表示する要件がある場合は、INFORMATION SCHEMAのビューを使用する必要があります。

https://docs.snowflake.com/en/sql-reference/account-usage#differences-between-account-usage-and-information-schema

**分野:** アカウント使用量と監視

---

## 問題24

**問:** タイムトラベルとフェイルセーフストレージに関する正しいステートメントはどれですか？該当するものを全て選択してください。

- **正解:** 一時テーブルの最大タイムトラベル期間は1日
- 一時テーブルには7日間のフェイルセーフストレージがある
- 一時テーブルの最大タイムトラベル期間は7日
- **正解:** 一時テーブルにはフェイルセーフストレージがない

## 解説

✅ **最大タイムトラベル期間は1日 / フェイルセーフストレージなし**

過渡テーブルと一時テーブルにはフェイルセーフ機能がないため、これらのテーブルのデータはゼロ日のフェイルセーフストレージを通過します。また、過渡テーブルと一時テーブルの最大タイムトラベルは1日です。

https://docs.snowflake.com/en/user-guide/tables-temp-transient

**分野:** タイムトラベル

---

## 問題25

**問:** 以下のうちクローンできるものはどれですか？

- **正解:** データベース（Databases）
- **正解:** スキーマ（Schemas）
- **正解:** テーブル（Tables）
- 内部名前付きステージ（Internal Named Stages）

## 解説

✅ **データベース / スキーマ / テーブル**

名前付き内部ステージはクローンできません。データベースまたはスキーマをクローンする場合、名前付き内部ステージを指すSnowpipeはクローンされません。名前付き外部ステージはクローンできます。テーブルステージはテーブルに関連付けられているため、テーブルがクローンされると自動的にクローンされます。また、外部テーブルもクローンできません。

https://docs.snowflake.com/en/user-guide/object-clone#cloning-and-stages

**分野:** クローニング

---

## 問題26

**問:** 管理者がMARKETINGデータベースのPUBLICスキーマにマテリアライズドビューを作成できるようにロールにアクセスを付与する必要があります。必要な権限を提供するステートメントはどれですか？

- GRANT MATERIALIZED VIEW ON SCHEMA MARKETING.PUBLIC TO ROLE <role_name>;
- **正解:** GRANT CREATE MATERIALIZED VIEW ON SCHEMA MARKETING.PUBLIC TO ROLE <role_name>;
- GRANT CREATE MATERIALIZED VIEW ON SCHEMA MARKETING.PUBLIC TO <role_name>;
- GRANT MATERIALIZED VIEW ON SCHEMA MARKETING.PUBLIC TO <role_name>;

## 解説

✅ **GRANT CREATE MATERIALIZED VIEW ON SCHEMA MARKETING.PUBLIC TO ROLE <role_name>;**

正しい構文は `GRANT CREATE MATERIALIZED VIEW ON SCHEMA <schema_name> TO ROLE <role_name>;` です。

https://docs.snowflake.com/en/user-guide/views-materialized#privileges-on-a-materialized-view-s-schema

**分野:** セキュリティ

---

## 問題27

**問:** SnowflakeのEnterpriseエディションでタイムトラベルの最大期間はどれですか？

- 1日
- 45日
- 0日
- **正解:** 90日

## 解説

✅ **90日**

Snowflakeエディションによって、タイムトラベルの期間は1〜90日の範囲になる場合があります。Standardエディションでは1日のタイムトラベルが可能です。EnterpriseバージョンおよびそれEE以上のバージョンでは最大90日のタイムトラベルが可能です。

https://docs.snowflake.com/en/user-guide/data-time-travel#data-retention-period

**分野:** タイムトラベル

---

## 問題28

**問:** GETコマンドはどの目的で使用されますか？

- Snowflakeテーブルから任意のタイプのステージにデータをダウンロードする
- オンプレミスシステム上の外部ステージからデータをダウンロードする
- **正解:** 内部ステージからオンプレミスシステムにデータをダウンロードする
- 内部ステージからクラウドストレージにデータをダウンロードする

## 解説

✅ **内部ステージからオンプレミスシステムにデータをダウンロードする**

GETコマンドは内部ステージからオンプレミスシステムにデータをダウンロードするために使用されます。PUTコマンドはオンプレミスシステムから内部ステージにデータをアップロードします。外部ステージへのデータのダウンロードまたはアップロードには、クラウドプロバイダーのユーティリティやその他のツールが使用されます。

https://docs.snowflake.com/en/user-guide/data-unload-overview#bulk-unloading-process

**分野:** データのロードとアンロード

---

## 問題29

**問:** Snowflakeのストリームオブジェクトに関して正しいステートメントはどれですか？該当するものを全て選択してください。

- **正解:** マテリアライズドビューはストリームをサポートしない
- **正解:** ストリームオブジェクトはテーブルへのDML変更（挿入、更新、削除）を行レベルで記録する
- ストリームオブジェクトは数年間テーブルのDML変更を追跡できる
- 外部テーブルはストリームをサポートしない

## 解説

✅ **マテリアライズドビューはストリームをサポートしない / ストリームはDML変更を行レベルで記録する**

マテリアライズドビューは現在ストリームをサポートしていません。

Snowflakeストリームは、新しいデータの追加（挿入）、既存データの変更（更新）、データの削除などのテーブルへの変更を追跡するのに役立ちます。最後のオフセット以降に変更されたデータのみをクエリおよび処理できます。

ストリームオブジェクトは指定されたデータ保持期間内のソーステーブルへのDML変更を監視・記録します。その後、ストリームは古くなり、DML変更は利用できなくなります。

外部テーブルはストリームをサポートしています。Snowflakeの挿入専用ストリームは、挿入と更新の両方を新しい行としてキャプチャすることで外部テーブルへの変更を追跡しますが、削除操作は無視されます。

https://docs.snowflake.com/en/user-guide/streams-intro

**分野:** ストリーム

---

## 問題30

**問:** 既存のリソースモニターを表示および変更できるのはどれですか？該当するものを全て選択してください。

- システムの任意のユーザー
- **正解:** アカウント管理者（ACCOUNTADMINロールを持つ人）
- システム管理者（SYSADMINロールを持つ人）
- **正解:** リソースモニターのMONITORおよびMODIFY権限を持つユーザー

## 解説

✅ **アカウント管理者（ACCOUNTADMIN） / MONITORおよびMODIFY権限を持つユーザー**

権限の観点から、リソースモニターを作成できるのはアカウント管理者（ACCOUNTADMINロールを持つユーザー）のみです。ただし、アカウント管理者はリソースモニターの設定を表示・変更できるように他のユーザーに権限を付与できます。リソースモニターのMONITORおよびMODIFY権限により、他のユーザーが特定のリソースモニターを表示・変更できます。

https://docs.snowflake.com/en/user-guide/resource-monitors#access-control-privileges-for-resource-monitors

**分野:** アカウント使用量と監視

---

## 問題31

**問:** SYSADMINロールを持つJohnがクエリを実行しました。別のユーザーJaneがSnowsightのクエリ履歴を使用してJohnが実行したクエリの結果を表示しようとしました。以下のうちどれが結果を正しく説明していますか？

- **正解:** JaneはJohnが実行したクエリの結果セットを見ることができない
- JaneはJohnが権限を付与した場合のみJohnが実行したクエリの結果セットを見ることができる
- JaneはJohnもSYSADMINロールの一部である場合のみJohnが実行したクエリの結果セットを見ることができる
- JaneはACCOUNTADMINロールを持っている場合のみJohnが実行したクエリの結果セットを見ることができる

## 解説

✅ **JaneはJohnが実行したクエリの結果セットを見ることができない**

自分が実行した履歴クエリの結果のみを見ることができます。プライバシー上の理由から、クエリ詳細ページは他のユーザーが実行したクエリの結果を表示しません（そのクエリの詳細を見る権限があっても同様です）。

https://docs.snowflake.com/en/user-guide/ui-history#viewing-query-details-and-results

**分野:** セキュリティ

---

## 問題32

**問:** 真か偽か：クロスクラウドまたはクロスリージョンのデータ共有のためにレプリケーションを設定する場合、データプロバイダーはデータコンシューマーごとに1回データをレプリケートする必要がある。

- **正解:** False
- True

## 解説

✅ **False**

クラウドまたはリージョンごとに1つのデータインスタンスのみをレプリケートする必要があります。インスタンスがレプリケートされると、複数のコンシューマーがこのデータを使用できます。

https://docs.snowflake.com/en/user-guide/secure-data-sharing-across-regions-plaforms
https://docs.snowflake.com/en/user-guide/secure-data-sharing-across-regions-plaforms#data-sharing-considerations

**分野:** データ共有

---

## 問題33

**問:** マテリアライズドビューをサポートするSnowflakeの最低エディションはどれですか？

- Standard
- **正解:** Enterprise
- Business Critical
- Virtual Private Snowflake

## 解説

✅ **Enterprise**

マテリアライズドビューをサポートするSnowflakeの最低エディションはEnterpriseです。Enterpriseエディション以上の全エディションもマテリアライズドビューをサポートします。

https://docs.snowflake.com/en/user-guide/intro-editions.html

**分野:** ライセンスと機能

---

## 問題34

**問:** SQL Workbench、DBeaver、ErwinはSnowflakeパートナーエコシステムのどのタイプのパートナーですか？

- **正解:** SQL開発と管理（SQL Development and Management）
- データ統合（Data Integration）
- 機械学習とデータサイエンス（Machine Learning & Data Science）
- セキュリティ、ガバナンス、オブザービリティ（Security, Governance & Observability）

## 解説

✅ **SQL開発と管理（SQL Development and Management）**

これらは全てSnowflakeのSQL開発と管理パートナーです。

https://docs.Snowflake.com/en/user-guide/ecosystem.html

**分野:** パートナー

---

## 問題35

**問:** Snowflakeがサポートする認証メカニズムはどれですか？該当するものを全て選択してください。

- 平文パスワード認証（Plain Text Password authentication）
- MD5認証（MD5 authentication）
- **正解:** キーペア認証（Key Pair Authentication）
- **正解:** 多要素認証（Multi-factor authentication）

## 解説

✅ **キーペア認証 / 多要素認証**

多要素認証はSnowflakeのログインプロセスに追加の保護を加えます。Snowflakeは従来のユーザー名/パスワード認証のより安全な代替手段としてキーペア認証を提供します。さらに、Snowflakeはフェデレーション認証をサポートしており、ユーザーはSAML 2.0準拠のシングルサインオン（SSO）を通じてアクセスできます。

**分野:** セキュリティ

---

## 問題36

**問:** SnowflakeのどのエディションがSnowflakeの内部ステージへのプライベート接続をサポートしていますか？

- Enterprise Edition
- **正解:** Virtual Private Snowflake (VPS) エディション
- **正解:** Business Critical Edition
- Standard Edition

## 解説

✅ **Virtual Private Snowflake (VPS) / Business Critical Edition**

プライベート接続により、Snowflakeインスタンスへのアクセスがセキュアな接続を経由することを保証し、インターネットベースのアクセスを完全にブロックすることも可能です。SnowflakeへのプライベートはBusiness Criticalエディション以上が必要です。

**分野:** ライセンスと機能

---

## 問題37

**問:** クエリ結果キャッシュの再利用はどのパラメーターを使用して無効にできますか？

- **正解:** USE_CACHED_RESULT
- ENABLE_QUERY_RESULT_CACHE
- PURGE_CACHED_RESULTS
- DISABLE_QUERY_RESULT_CACHE

## 解説

✅ **USE_CACHED_RESULT**

クエリ結果キャッシュはデフォルトで有効になっていますが、USE_CACHED_RESULTパラメーターを使用してセッション、ユーザー、またはアカウントレベルで無効にできます。

https://docs.snowflake.com/en/user-guide/querying-persisted-results

**分野:** パフォーマンスの概念

---

## 問題38

**問:** MARKETINGスキーマのCUSTOMERテーブルに対してSearch Optimizationを追加、設定、または削除できるように、MKT_USERSというロールに正しい権限を付与するステートメントはどれですか？

- GRANT SEARCH OPTIMIZATION ON SCHEMA MARKETING TO ROLE MKT_USERS;
- GRANT ADD SEARCH OPTIMIZATION ON TABLE CUSTOMER TO ROLE MKT_USERS;
- **正解:** GRANT ADD SEARCH OPTIMIZATION ON SCHEMA MARKETING TO ROLE MKT_USERS;
- GRANT SEARCH OPTIMIZATION ON TABLE CUSTOMER TO ROLE MKT_USERS;

## 解説

✅ **GRANT ADD SEARCH OPTIMIZATION ON SCHEMA MARKETING TO ROLE MKT_USERS;**

テーブルに対して検索最適化を追加、設定、または削除するには、テーブルに対するOWNERSHIP権限と、テーブルを含むスキーマに対するADD SEARCH OPTIMIZATION権限が必要です。構文は `GRANT ADD SEARCH OPTIMIZATION ON SCHEMA <schema_name> TO ROLE <role>` です。

https://docs.snowflake.com/en/user-guide/search-optimization-service#what-access-control-privileges-are-needed-for-the-search-optimization-service

**分野:** セキュリティ

---

## 問題39

**問:** SNOWFLAKE_SAMPLE_DATA.TPCH_SF1スキーマのCUSTOMERテーブルを考えてください。仮想ウェアハウスはサスペンド状態ですが、自動レジュームが設定されています。以下のどのクエリが仮想ウェアハウスを再開させますか？該当するものを全て選択してください。

- **正解:** SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;
- USE SNOWFLAKE_SAMPLE_DATA.TPCH_SF1;
- SHOW TABLES LIKE '%CUSTOMER%';
- **正解:** SELECT C_MKTSEGMENT,SUM(C_ACCTBAL) FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER GROUP BY C_MKTSEGMENT;
- DESCRIBE TABLE SNOWFLAKE_SAMPLE_DATA.TPCH_SF1;
- SELECT COUNT(*) FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;

## 解説

✅ **SELECT * ... / SELECT C_MKTSEGMENT,SUM(C_ACCTBAL)...**

メタデータキャッシュまたはクラウドサービス操作はアクティブな仮想ウェアハウスを必要としません。他のクエリにはアクティブな仮想ウェアハウスが必要です。

統計は各テーブル、マイクロパーティション、列のクラウドサービスレイヤーのメタデータキャッシュに保持されます。クエリが単に行数をカウントするだけであれば、メタデータキャッシュが結果を返せます。同様に、クラウドサービスレイヤーはテーブル定義（DESCRIBE）やスキーマ内のテーブルリスト（SHOW TABLES LIKE）を提供できます。

**分野:** アーキテクチャ

---

## 問題40

**問:** リソースモニターは何のために使用されますか？

- キューに入っているクエリ数を監視する
- 仮想ウェアハウスを自動的にスケールアップ・ダウンする
- 各仮想ウェアハウスのリソース割り当てを監視する
- **正解:** 仮想ウェアハウスのコストとクレジット使用を制御する

## 解説

✅ **仮想ウェアハウスのコストとクレジット使用を制御する**

リソースモニターは仮想ウェアハウスのコスト管理と予期しないクレジット使用を避けるのに役立ちます。リソースモニターは定義された上限に対してクレジット使用を監視し、上限の一定割合に達すると管理者に通知し、必要に応じて仮想ウェアハウスをサスペンドすることでクレジット使用を制御できます。

https://docs.snowflake.com/en/user-guide/resource-monitors

**分野:** アカウント使用量と監視

---

## 問題41

**問:** Snowflakeシステムのストレージコストに貢献するものはどれですか？

- **正解:** 過渡テーブル（Transient tables）
- **正解:** 一時テーブル（Temporary Tables）
- **正解:** 永続テーブル（Permanent tables）
- 外部テーブル（External tables）

## 解説

✅ **過渡テーブル / 一時テーブル / 永続テーブル**

外部テーブルのデータはSnowflake外部のクラウドストレージに保存されるため、外部テーブルはストレージコストに貢献しません。ただし、永続テーブル、一時テーブル、過渡テーブルはそれぞれ異なるストレージコストに貢献します。

https://docs.snowflake.com/en/user-guide/cost-understanding-data-storage#temporary-and-transient-tables-costs

**分野:** コストと価格

---

## 問題42

**問:** 仮想ウェアハウスをより大きなサイズにスケールアップする場合、正しいものはどれですか？該当するものを全て選択してください。

- **正解:** 新しいサイズへの課金は、より大きな仮想ウェアハウスの全ての新しいノードがプロビジョニングされるまで開始されない
- 仮想ウェアハウスをより小さなサイズにスケールダウンできない
- **正解:** サイズの増加は仮想ウェアハウスで既に実行中のクエリに影響しない
- 既存の全クエリは終了し、再送信する必要がある
- **正解:** 新しいクエリのみがより大きな仮想ウェアハウスサイズの恩恵を受ける

## 解説

✅ **新ノードプロビジョニング後に課金開始 / 既存クエリに影響なし / 新クエリのみ恩恵を受ける**

仮想ウェアハウスをスケールアップすると、より大きな仮想ウェアハウスの全ての新しいノードがプロビジョニングされるまで新しいサイズへの課金は開始されません。新しいクエリのみが変更されたサイズの影響を受け、仮想ウェアハウスの既存クエリは影響を受けません。

https://docs.snowflake.com/en/user-guide/warehouses-

**分野:** パフォーマンスの概念

---

## 問題43

**問:** マルチクラスター仮想ウェアハウスの最大クラスター数はいくつですか？

- 24
- **正解:** 10
- 50
- 1

## 解説

✅ **10**

マルチクラスター仮想ウェアハウスは同時に1〜10の異なるクラスターをサポートします。サポートされるクラスターの最小数は1で、許可されるクラスターの最大数は10です。

https://docs.snowflake.com/en/user-guide/warehouses-multicluster#what-is-a-multi-cluster-warehouse

**分野:** パフォーマンスの概念

---

## 問題44

**問:** 真か偽か：テーブルがクローンされた後、元のテーブルをドロップするとクローンもドロップされる。

- True
- **正解:** False

## 解説

✅ **False**

クラウドサービスレイヤーのマイクロパーティションとメタデータにより、クローンされたテーブルのメタデータが既存のマイクロパーティションを参照するため、迅速かつ効率的なゼロコピークローニングが可能です。ソースとクローンされたアイテムは独立しているため、一方のデータを変更しても他方には影響しません。例えば、ソーステーブルを完全にドロップしてもクローンされたテーブルには影響しません。

https://docs.snowflake.com/en/user-guide/tables-storage-considerations#label-cloning-tables

**分野:** クローニング

---

## 問題45

**問:** PUBLICロールに関する正しいステートメントはどれですか？該当するものを全て選択してください。

- PUBLICロールは事前定義されておらず、アカウント管理者が作成する必要がある
- **正解:** PUBLICロールはSnowflakeシステムで最も権限の低いロールである
- PUBLICロールはSnowflakeシステムで最も権限の高いロールである
- **正解:** PUBLICロールはSnowflakeの全てのユーザーに自動的に割り当てられる

## 解説

✅ **最も権限が低いロール / 全ユーザーに自動割り当て**

PUBLICロールはSnowflakeの既製ロールの1つです。PUBLICロールは最も少ない権限を持ち、全てのユーザーに自動的に割り当てられます。

https://docs.snowflake.com/en/user-guide/security-access-control-overview#system-defined-roles

**分野:** セキュリティ

---

## 問題46

**問:** SnowflakeのタスクについてのどのステートメントはXXXですか？該当するものを全て選択してください。

- **正解:** タスクはEXECUTE TASKコマンドを使用して手動で実行できる
- 単一のタスクでは、ユーザーは事前定義されたスケジュールで複数のSQLステートメントを実行できる
- **正解:** タスクは定義されたスケジュールで単一のSQLコマンドまたはステートメントを実行できる
- タスクは特定の権限なしに作成できる

## 解説

✅ **EXECUTE TASKコマンドで手動実行可能 / 定義されたスケジュールで単一SQL実行**

EXECUTE TASKコマンドを使用すると、スタンドアロンタスクまたはタスクグラフのルートタスクを手動でトリガーできます。

各Snowflakeタスクは単一のSQLコマンドまたはステートメントの実行に限定されています。複数のSQLステートメントを同じタスク定義内で実行することはできません。

Snowflakeタスクを作成するには、タスクが配置されるスキーマに対して"CREATE TASK"権限が必要です。

https://docs.snowflake.com/en/sql-reference/sql/execute-task
https://docs.snowflake.com/en/sql-reference/sql/create-task#required-parameters

**分野:** タスク

---

## 問題47

**問:** 新しいシェアを作成できるのはどれですか？該当するものを全て選択してください。

- SECURITY ADMINロールを持つユーザー
- **正解:** CREATE SHARE権限を持つロールを持つユーザー
- SYSADMINロールを持つユーザー
- **正解:** ACCOUNTADMINロールを持つユーザー

## 解説

✅ **CREATE SHARE権限を持つロール / ACCOUNTADMINロール**

シェアを作成できるのはACCOUNTADMINロールを持つユーザーまたはCREATE SHARE権限が付与されているユーザーのみです。

https://docs.snowflake.com/en/user-guide/data-sharing-gs

**分野:** データ共有

---

## 問題48

**問:** 仮想ウェアハウスが起動し、5分15秒間使用されてシャットダウンされました。顧客は何秒分請求されますか？

- 360秒
- 3600秒
- **正解:** 315秒
- 0秒

## 解説

✅ **315秒**

Snowflakeのクレジットは1秒単位で請求されます。仮想ウェアハウスが5分15秒間実行された場合、315秒（5×60+15）が請求されます。ただし、最低60秒の請求が適用されるため、仮想ウェアハウスが最初の1分以内に起動してシャットダウンされた場合は、最低60秒のクレジット使用が適用されます。

**分野:** アーキテクチャ

---

## 問題49

**問:** 真か偽か：COPYコマンドはSELECTクエリを使用してデータをアンロードできる。

- False
- **正解:** True

## 解説

✅ **True**

COPYコマンドはテーブルまたはビューからデータをアンロード/エクスポートできるほか、クエリ（SELECT）を使用してデータをアンロードすることも可能です。

https://docs.snowflake.com/en/user-guide/data-unload-overview#bulk-unloading-using-queries

**分野:** データのロードとアンロード

---

## 問題50

**問:** S3ステージから特定のファイルリストをロードする場合、正しい構文はどれですか？（ファイル名はdelta1.csv、delta2.csv、delta3.csv、ステージはmy_stage、テーブルはmy_tableとします）

- **正解:** COPY INTO my_table FROM @my_stage files=('delta1.csv', 'delta2.csv', 'delta3.csv')
- COPY INTO my_table FROM @my_stage/delta1.csv,@my_stage/delta2.csv,@my_stage/delta3.csv
- COPY delta1.csv,delta2.csv,delta3.csv INTO my_table FROM @my_stage

## 解説

✅ **COPY INTO my_table FROM @my_stage files=('delta1.csv', 'delta2.csv', 'delta3.csv')**

COPYコマンドに正確なファイル名を指定することで、それらのファイルのみがアクセスされてロードされます。

https://docs.snowflake.com/en/user-guide/data-load-considerations-load#lists-of-files

**分野:** データのロードとアンロード

---

## 問題51

**問:** ACCOUNT_USAGEスキーマのACCESS_HISTORYビューで達成できることはどれですか？2つ選択してください。

- ログインしたユーザーが使用したロールを特定する
- **正解:** アクセスされたデータ、いつ、誰がアクセスしたかを特定する
- システムにログインした人を特定する
- **正解:** 使用されておらずクエリされていないデータを特定するのに役立つ

## 解説

✅ **アクセスされたデータ・いつ・誰がアクセスしたかを特定 / 未使用データの特定**

ACCESS_HISTORYビューを使用して、アクセスされたデータ、いつ、誰がアクセスしたかを特定できます。この情報を使用して、全くアクセスされていないデータも特定できます。

https://docs.snowflake.com/en/user-guide/access-history#benefits

**分野:** アカウント使用量と監視

---

## 問題52

**問:** データベースをクローンする際、現在のロールはソースデータベースに対して（最低限）どの権限が必要ですか？

- **正解:** USAGE
- WRITE
- SELECT

## 解説

✅ **USAGE**

テーブルをクローンするにはソーステーブルへのSELECT権限が必要です。Pipe、Stream、Taskのクローンにはオーナーシップ権限が必要です。それ以外のクローン可能なオブジェクトには全てUSAGE権限が必要です。

https://docs.snowflake.com/en/sql-reference/sql/create-clone#general-usage-notes

**分野:** クローニング

---

## 問題53

**問:** Snowflakeのストレージコストに貢献するものはどれですか？該当するものを全て選択してください。

- クエリ結果キャッシュ（Query Result Cache）
- **正解:** 過渡テーブル（Transient Tables）
- **正解:** 一時テーブル（Temporary Tables）
- ウェアハウスキャッシュ（Warehouse Cache）
- **正解:** 永続テーブル（Permanent Tables）

## 解説

✅ **過渡テーブル / 一時テーブル / 永続テーブル**

永続テーブルに保存されたデータはストレージコストに計上されます。一時テーブルと過渡テーブルに保存されたデータも、ドロップまたはデータがクリアされるまでストレージコストに貢献します。フェイルセーフストレージとタイムトラベルストレージのデータもストレージコストに貢献します。過渡テーブルと一時テーブルはフェイルセーフストレージコストには貢献せず、最大1日のタイムトラベルコストがかかります。キャッシュはストレージコストの決定には考慮されません。クエリ結果キャッシュとメタデータキャッシュはクラウドサービスレイヤーの一部であり、ウェアハウスキャッシュ（ローカルディスクキャッシュ）は仮想ウェアハウスの一部でストレージコストには貢献しません。

https://docs.snowflake.com/en/user-guide/cost-understanding-overall

**分野:** コストと価格

---

## 問題54

**問:** Snowpipeの使用が最適な選択肢となるシナリオはどれですか？

- 毎月到着する大きなファイルをロードしている
- ユーザーが頻繁な戦術的クエリを実行している
- ユーザーが大規模なデータサイエンスワークロードを実行している
- **正解:** 頻繁に到着する少量のデータをロードする必要がある

## 解説

✅ **頻繁に到着する少量のデータをロードする必要がある**

Snowpipeは、データがメッセージングまたはストリーミング方式で継続的に到着し、ほぼ即座にデータをロードする必要がある場合に最適な方法です。

https://docs.snowflake.com/en/user-guide/data-load-snowpipe-intro

**分野:** データのロードとアンロード

---

## 問題55

**問:** Snowflakeの共有を通じて、データプロバイダーは誰とデータを共有できますか？該当するものを全て選択してください。

- **正解:** Snowflakeを使用していない顧客（Non-Snowflake customer）
- **正解:** 別のSnowflake顧客
- Google Driveユーザー
- One Driveユーザー
- **正解:** 複数のSnowflake顧客

## 解説

✅ **Snowflake未使用顧客 / 別のSnowflake顧客 / 複数のSnowflake顧客**

Snowflake顧客、Snowflake未使用顧客、またはその両方の組み合わせなど、複数のコンシューマーとデータを共有できます。

**分野:** データ共有

---

## 問題56

**問:** 真か偽か：Snowflakeはクラウドで実行するように改修された既存のデータベーステクノロジーに基づいている。

- True
- **正解:** False

## 解説

✅ **False**

Snowflakeはクラウド向けに設計されており、ゼロから設計されています。Snowflakeはコンピュートとストレージを分離する新しいハイブリッドアーキテクチャを実装しています。

**分野:** アーキテクチャ

---

## 問題57

**問:** Snowflakeはデータをロードするためにどの2つのアプローチを許可していますか？

- **正解:** 継続的データロード（Continuous Data Loading）
- 断続的データロード（Intermittent Data Loading）
- **正解:** バルクデータロード（Bulk Data Loading）

## 解説

✅ **継続的データロード / バルクデータロード**

Snowflakeは主に2つの方法でデータロードをサポートします。COPYコマンドはバルクデータまたは大きなファイルのロードに使用できます。COPYコマンドはテーブルへのデータロードに仮想ウェアハウスの使用が必要です。もう1つの方法はSnowpipeを通じたデータロードです。Snowpipeはデータがメッセージングまたはストリーミング方式で継続的に到着する場合に最適な技術です。

https://docs.snowflake.com/en/user-guide/data-load-overview#bulk-vs-continuous-loading

**分野:** データのロードとアンロード

---

## 問題58

**問:** COPYコマンドがサポートする変換はどれですか？該当するものを全て選択してください。

- **正解:** 列の並び替え（Reorder columns）
- **正解:** 列の省略（Omit columns）
- **正解:** 列のキャスト（Cast columns）
- 他のテーブルとの結合（Join with other tables）

## 解説

✅ **列の並び替え / 列の省略 / 列のキャスト**

COPYコマンドを使用してテーブルにデータをロードする際、Snowflakeはロード中にデータの簡単な変換を行うことができます。ロードプロセス中に、COPYコマンドは列の順序の変更、1つ以上の列の省略、指定したデータ型へのキャスト、値の切り捨てが可能です。結合、フィルター、集計、FLATTENの使用などの複雑な変換はサポートされていません。

https://docs.snowflake.com/en/user-guide/data-load-overview#id2

**分野:** データのロードとアンロード

---

## 問題59

**問:** マテリアライズドビューのリフレッシュ方法を正しく説明しているものはどれですか？

- マテリアライズドビューは手動でのみリフレッシュできる
- **正解:** 基礎テーブルのデータが変更された場合、マテリアライズドビューは自動的に更新される
- **正解:** マテリアライズドビューはSnowflakeが管理するサービスによって自動的にリフレッシュされる
- マテリアライズドビューをリフレッシュするには追加のSQLステートメントをスケジュールする必要がある
- REFRESH_ON_BASE_TABLE_UPDATEパラメーターを使用してマテリアライズドビューの自動リフレッシュを設定できる

## 解説

✅ **基礎テーブル変更時に自動更新 / Snowflake管理サービスが自動リフレッシュ**

基礎テーブルが更新されると、マテリアライズドビューは自動的にリフレッシュされ、追加のメンテナンスは不要です。Snowflakeが管理するサービスがユーザーの操作を妨げることなくバックグラウンドで更新を行います。

https://docs.snowflake.com/en/user-guide/views-materialized

**分野:** パフォーマンスの概念

---

## 問題60

**問:** プレサインドURLに関する正しいものはどれですか？該当するものを全て選択してください。

- **正解:** プレサインドURLの有効期限を設定できる
- プレサインドURLは24時間後に期限切れになる
- **正解:** プレサインドURLは認証や認可なしにユーザーやアプリケーションにアクセスを提供するのに適している
- **正解:** プレサインドURLを持つ誰でも、そのURLを使用して参照されているファイルにアクセスできる
- **正解:** プレサインドURLはアクセストークンで生成され、認証なしにアクセスできる

## 解説

✅ **有効期限の設定可能 / 認証不要でアクセス可能 / URL所持者誰でもアクセス可能 / アクセストークンで生成**

プレサインドURLはWebブラウザを使用してファイルにアクセスするためのシンプルなHTTPS URLです。プレサインドURLはプレサインドアクセストークンを使用して生成されます。ユーザーは認可なしにプレサインドURLを通じてファイルに一時的にアクセスできます。プレサインドURLの有効期間は設定可能で、必要な期間に設定できます。

https://docs.snowflake.com/en/user-guide/unstructured-intro#types-of-urls-available-to-access-files

**分野:** データ変換

---

## 問題61

**問:** Snowflakeのクラウドサービスレイヤーはどの機能を提供しますか？該当するものを全て選択してください。

- **正解:** データ共有（Data Sharing）
- データのストレージ（Storage for data）
- **正解:** クローニング（Cloning）
- **正解:** トランザクション制御・ACID準拠（Transaction control / ACID compliance）

## 解説

✅ **データ共有 / クローニング / トランザクション制御・ACID準拠**

Snowflakeのデータ共有、クローニング、データ交換機能はすべてメタデータを使用してクラウドサービスレイヤーを通じて管理されます。クラウドサービスレイヤーはACID準拠も提供します。ACIDとは、データベースシステムがトランザクションをユニットとして分離して実行し、コミットまたはロールバックすることで、システムの一貫性を確保することを意味します。

**分野:** アーキテクチャ

---

## 問題62

**問:** 現在のセッションで実行された最新クエリのクエリIDを見つけるために使用できるものはどれですか？2つ選択してください。

- **正解:** SELECT LAST_QUERY_ID();
- **正解:** SELECT LAST_QUERY_ID(-1);
- SELECT LAST_QUERY_ID(2);
- SELECT LAST_QUERY_ID(1);
- SELECT LAST_QUERY_ID(-2);

## 解説

✅ **SELECT LAST_QUERY_ID(); / SELECT LAST_QUERY_ID(-1);**

LAST_QUERY_ID関数は現在のセッション内の指定されたクエリのクエリIDを返します。この関数はセッション内のクエリの位置を指定する数値をパラメーターとして受け取ります。パラメーターは正または負の値を取れます。負の値はセッション内の最新クエリを取得することを意味します（-1=最新クエリ、-2=2番目に新しいクエリ、など）。関数はデフォルトで-1なので、値が指定されない場合は最新クエリのIDを返します。正の数はセッション内の最初のクエリから順に返します（1=最初のクエリ、2=2番目のクエリ、など）。

https://docs.snowflake.com/en/sql-reference/functions/last_query_id

**分野:** General

---

## 問題63

**問:** クエリプロファイルで、TableScanオペレーターは何を表しますか？

- テーブルへのレコードの追加
- 特定の条件で2つの入力を結合する
- ステージオブジェクトに保存されたデータへのアクセス
- **正解:** 単一テーブルへのアクセス

## 解説

✅ **単一テーブルへのアクセス**

TableScanオペレーターは単一テーブルへのアクセスを表します。

https://docs.snowflake.com/en/user-guide/ui-query-profile#data-access-and-generation-operators

**分野:** パフォーマンスの概念

---

## 問題64

**問:** Snowflakeアーキテクチャのコンピュートレイヤーはどの機能を担当していますか？

- **正解:** クエリ処理（Query Processing）
- クエリ計画（Query Planning）
- クエリ最適化（Query Optimization）
- クエリ結果のキャッシュ（Cache Query Results）

## 解説

✅ **クエリ処理（Query Processing）**

コンピュートレイヤーはクエリ処理またはクエリ実行を担当します。クエリ計画と最適化はクラウドサービスレイヤーが行います。クエリ結果キャッシュはクラウドサービスレイヤーに保存・管理されます。

https://docs.snowflake.com/en/user-guide/intro-key-concepts

**分野:** アーキテクチャ

---

## 問題65

**問:** Snowflake Marketplaceに関する正しいものはどれですか？

- **正解:** Snowflake Marketplaceを使用して、顧客は会社外からデータをSnowflakeインスタンスにインポートし、自社データを強化するために活用できる
- **正解:** Snowflake Marketplaceは、データセットを購入・販売できるオンラインマーケットプレイスである
- Snowflake Marketplace上の全てのデータセットは有料で提供される
- Snowflake Marketplaceを使用して、顧客は異なるデータセットに入札でき、最高入札者のみがデータセットにアクセスできる

## 解説

✅ **外部データのインポートとデータ強化が可能 / データセットを購入・販売できるマーケットプレイス**

Snowflake Marketplaceは、様々な組織が提供するサードパーティデータセットを見つけてアクセスするためのマーケットプレイスです。これらのサードパーティデータセットは一般的に有料ですが、無料で提供されることもあります。入札はなく、データセットは誰でも利用可能です（無料または有料）。

https://other-docs.snowflake.com/en/collaboration/collaboration-marketplace-about.html

**分野:** データ共有

---

## 問題66

**問:** マルチクラスター仮想ウェアハウスに関する正しいステートメントはどれですか？該当するものを全て選択してください。

- **正解:** マルチクラスター仮想ウェアハウスはクエリ需要が減少すると追加クラスターを自動的に削除する
- マルチクラスター仮想ウェアハウスは自動サスペンドまたは自動レジュームを設定できない
- **正解:** マルチクラスター仮想ウェアハウスは、同時クエリが既存の仮想ウェアハウスで処理できない数に増加すると追加クラスターを自動的に追加する
- **正解:** マルチクラスター仮想ウェアハウス機能にはEnterpriseエディション以上が必要

## 解説

✅ **需要減少時に自動削除 / 需要増加時に自動追加 / Enterpriseエディション以上が必要**

マルチクラスター仮想ウェアハウスは、同時ユーザー数が単一仮想ウェアハウスのキャパシティを超える場合に使用されます。Enterpriseエディションがマルチクラスター仮想ウェアハウス機能の使用に必要です。自動追加・削除以外の動作は通常の仮想ウェアハウスと同様で、サスペンド・レジュームや自動サスペンド・自動レジュームも設定できます。

https://docs.snowflake.com/en/user-guide/warehouses-multicluster

**分野:** アーキテクチャ

---

## 問題67

**問:** ディレクトリテーブルのメタデータをリフレッシュするためにイベント通知を使用するコストに関して正しいものはどれですか？該当するものを全て選択してください。

- リフレッシュ操作は無料である
- **正解:** リフレッシュ操作には小額のメンテナンスコストが請求される
- イベント通知は無料である
- **正解:** イベント通知には追加コストが請求される

## 解説

✅ **リフレッシュ操作には小額のメンテナンスコスト / イベント通知には追加コスト**

ディレクトリテーブルのメタデータのリフレッシュには、通知経由か手動（ALTER STAGE <stage-name> REFRESH経由）かに関わらず、小額のメンテナンスコストが請求されます。このコストはクラウドサービスコストとして計上されます。さらに、クラウドプラットフォームの通知を使用する場合、請求明細にSnowpipe料金として表示される追加コストが請求されます。

https://docs.snowflake.com/en/user-guide/data-load-dirtables-intro#billing-for-directory-tables

**分野:** データ変換

---

## 問題68

**問:** Partner Connectを通じてパートナーに接続するプロセスで作成されるオブジェクトについて正しいものはどれですか？該当するものを全て選択してください。

- PC_<partner>_DBデータベースはシステムに他のデータベースがない場合にのみ作成される
- **正解:** パートナーはPC_<partner>_USERを使用してSnowflakeインスタンスに接続する
- **正解:** PC_<partner>_ROLEにより、パートナーアプリケーションはPUBLICロールに付与されたオブジェクトにアクセスできる
- **正解:** PC_<partner>_DBデータベースは空で、データのロードまたは保存に使用できる
- PC_<partner>_WH仮想ウェアハウスはシステムに他の仮想ウェアハウスがない場合にのみ作成される

## 解説

✅ **PC_<partner>_USERで接続 / PC_<partner>_ROLEはPUBLICロール権限を継承 / PC_<partner>_DBは空で使用可能**

PC_<partner>_DBは空の状態で作成されます。ただし、必要に応じて既存のデータベースを使用するように設定できます。PC_<partner>_ROLEはPUBLICロールの権限を継承します。パートナーアプリケーションがシステム内のオブジェクトにアクセスできるように追加権限を付与できます。このロールはSYSADMINにも付与されます。

https://docs.snowflake.com/en/user-guide/ecosystem-partner-connect#connecting-with-a-snowflake-partner

**分野:** パートナー

---

## 問題69

**問:** 以下のマルチクラスター仮想ウェアハウス設定のうち、オートスケールモードで実行されているものはどれですか？

- **正解:** MIN_CLUSTER_COUNT = 1 / MAX_CLUSTER_COUNT = 5
- MIN_CLUSTER_COUNT = 3 / MAX_CLUSTER_COUNT = 3
- MIN_CLUSTER_COUNT = 1 / MAX_CLUSTER_COUNT = 1
- **正解:** MIN_CLUSTER_COUNT = 2 / MAX_CLUSTER_COUNT = 4
- MIN_CLUSTER_COUNT = 0 / MAX_CLUSTER_COUNT = 0

## 解説

✅ **MIN=1,MAX=5 / MIN=2,MAX=4**

マルチクラスター仮想ウェアハウスは最大化モードまたはオートスケールモードで作成できます。オートスケールモードはマルチクラスターの最小クラスターと最大ウェアハウス数に異なる値を選択することで有効になります。最大化モードはマルチクラスターの最小と最大ウェアハウス数を同じ値に設定することで有効になります。

https://docs.snowflake.com/en/user-guide/warehouses-multicluster#setting-the-scaling-policy-for-a-multi-cluster-warehouse

**分野:** パフォーマンスの概念

---

## 問題70

**問:** Snowflakeで継続的に到着するデータをロードするために使用できるものはどれですか？

- SnowStorm
- **正解:** Snowpipe
- SnowFast
- SnowTrickle

## 解説

✅ **Snowpipe**

SnowflakeはサーバーレスサービスであるSnowpipeを使用して継続的なデータロードを可能にします。Snowpipeはマイクロバッチ方式でデータをロードでき、各実行で少量のデータをロードします。Snowpipeはサーバーレスであり独自のコンピューティング能力を持つため、処理に仮想ウェアハウスを必要としません。Snowpipeのコストは仮想ウェアハウス費用とは別に請求されます。

https://docs.snowflake.com/en/user-guide/data-load-snowpipe-intro

**分野:** データのロードとアンロード

---

## 問題71

**問:** Snowsightのワークシートビューで、クエリが実行されるコンテキストを設定するために選択できるものはどれですか？

- テーブル（Table）
- ユーザー（User）
- **正解:** スキーマ（Schema）
- **正解:** 仮想ウェアハウス（Virtual Warehouse）
- **正解:** ロール（Role）
- **正解:** データベース（Database）

## 解説

✅ **スキーマ / 仮想ウェアハウス / ロール / データベース**

クエリが実行されるプライマリロールと、クエリの実行に使用する仮想ウェアハウスを選択できます。また、デフォルトのデータベースとスキーマも選択でき、指定したデータベースとスキーマのテーブルにプレフィックスを付ける必要がなくなります。

https://docs.snowflake.com/en/user-guide/ui-snowsight

**分野:** ツールとインターフェース

---

## 問題72

**問:** Snowflakeが動作変更リリースを行う頻度はどれですか？

- 2週間に1回
- 週に1回
- **正解:** 月に1回
- 年に1回

## 解説

✅ **月に1回**

月に1回、Snowflakeは「動作変更リリース」もリリースします。これらの既存の動作への変更は、既にサービスを使用している顧客に影響を与える可能性があります。2ヶ月にわたって、新しい動作は全員に採用されます。最初の月は、顧客がオプトインしない限り新しい動作は有効になりません。2番目の月では、新しい動作は自動的に有効になりますが、顧客は必要に応じてオプトアウトできます。

https://docs.snowflake.com/en/user-guide/intro-releases

**分野:** アカウント

---

## 問題73

**問:** Snowflakeへのプライベート接続をサポートするSnowflakeの最低エディションはどれですか？

- Enterprise
- Standard
- Virtual Private Snowflake
- **正解:** Business Critical

## 解説

✅ **Business Critical**

プライベート接続により、Snowflakeインスタンスへのアクセスがセキュアな接続を経由することを確保し、インターネットベースのアクセスを完全にブロックすることも可能です。SnowflakeへのプライベートはBusiness Criticalエディション以上が必要です。

**分野:** ライセンスと機能

---

## 問題74

**問:** 以下のコマンドを正常に実行するにはどのロールが必要ですか？ SHOW ORGANIZATION ACCOUNTS;

- **正解:** ORGADMIN
- ACCOUNTADMIN
- SYSADMIN
- SECURITYADMIN

## 解説

✅ **ORGADMIN**

"SHOW ORGANIZATION ACCOUNTS"コマンドを実行できるのはORGADMINロールを持つユーザーのみです。

https://docs.snowflake.com/en/sql-reference/sql/show-organization-accounts

**分野:** セキュリティ

---

## 問題75

**問:** Snowflakeのロール階層で権限はどのように継承されますか？

- 階層の同じレベルのロールのみが権限を継承する
- **正解:** ロールの権限は階層内のそのロールより上の全てのロールに継承される
- 直接の親ロールのみが権限を継承する
- 直接の子ロールのみが権限を継承する

## 解説

✅ **階層内の上位全ロールに継承される**

ロールは他のロールに付与されてロール階層を作成することもできます。ロールに関連付けられた権限は、そのロールより上の階層内の全てのロールに継承されます。

https://docs.snowflake.com/en/user-guide/security-access-control-overview

**分野:** セキュリティ

---

## 問題76

**問:** Snowflakeの権限とロールについて正しいものはどれですか？該当するものを全て選択してください。

- **正解:** 権限はロールに割り当てられる
- 権限はユーザーに直接割り当てられる
- 新しいカスタムロールは作成できない
- **正解:** ロールはユーザーに割り当てられる

## 解説

✅ **権限はロールに割り当て / ロールはユーザーに割り当て**

Snowflakeのアクセス制御は、ロールに権限を割り当て、ユーザーにロールを割り当てるロールベースアクセス制御（RBAC）アプローチに基づいています。ロールに付与された権限は、そのロールの全ユーザーに継承されます。

https://docs.snowflake.com/en/user-guide/security-access-control-overview

**分野:** セキュリティ

---

## 問題77

**問:** マイクロパーティションを正しく説明しているステートメントはどれですか？

- マイクロパーティションのデータは行ストレージ形式で整理されている
- マイクロパーティションは可変で更新できる
- **正解:** マイクロパーティションのデータは列形式で整理されている
- **正解:** マイクロパーティションは不変である

## 解説

✅ **列形式で整理 / 不変**

Snowflakeパーティションは不変であり、一度作成されると変更できません。テーブルデータは個別のマイクロパーティションにマッピングされ、さらに列形式で整理されます。

https://docs.snowflake.com/en/user-guide/tables-clustering-micropartitions.html

**分野:** アーキテクチャ

---

## 問題78

**問:** MARKETINGデータベースのPUBLICスキーマのCUSTOMERテーブルのオーナーです。ANALYSTというロールにCUSTOMERテーブルへのSELECTアクセスを付与するには、どのオブジェクトにどの権限を提供する必要がありますか？該当するものを全て選択してください。

- grant SELECT on database MARKETING to role ANALYST;
- grant READ on schema PUBLIC to role ANALYST;
- **正解:** grant SELECT on table CUSTOMER to role ANALYST;
- **正解:** grant USAGE on schema PUBLIC to role ANALYST;
- grant SELECT on schema PUBLIC to role ANALYST;
- **正解:** grant USAGE on database MARKETING to role ANALYST;

## 解説

✅ **SELECT on table CUSTOMER / USAGE on schema PUBLIC / USAGE on database MARKETING**

ANALYSTロールがテーブルからデータを読み取るにはテーブルへのSELECT権限が必要です。ただし、ANALYSTロールにテーブルを含むスキーマとデータベースを使用する権限がなければクエリを実行できません。USAGE権限により、USE DATABASEまたはUSE SCHEMAコマンドの実行、またはフルネームスペース（MARKETING.PUBLIC.CUSTOMER）でテーブルにアクセスできます。

**分野:** セキュリティ

---

## 問題79

**問:** Snowflakeの顧客がデータを最初にロードせずにクエリできるメカニズムはどれですか？

- **正解:** 外部テーブル（External Table）
- COPY
- Snowpipe
- 仮想テーブル（Virtual Table）

## 解説

✅ **外部テーブル（External Table）**

Snowflakeは外部テーブルと呼ばれるテーブルの代替アプローチを提供しており、外部クラウドストレージにデータを保存したままテーブルを作成できます。外部テーブルはデータをSnowflakeにロードする必要をなくします。外部テーブルの場合、テーブルの定義はSnowflakeのメタデータに保存されますが、テーブルのデータはSnowflake外に保存されます。

https://docs.snowflake.com/en/user-guide/tables-external-intro

**分野:** データのロードとアンロード

---

## 問題80

**問:** SnowflakeがSaaS（Software-as-a-Service）製品と見なされる理由はどれですか？該当するものを全て選択してください。

- **正解:** Snowflakeはクラウドで実行され、インターネット経由で利用可能である
- **正解:** 顧客はハードウェアを調達、インストール、管理する必要がない
- **正解:** 従量課金ライセンスを提供し、使用したリソースと機能のみを支払う
- **正解:** Snowflakeは定期的にソフトウェアを更新し、全てのアカウントがこれらの更新を自動的に受け取るため、手動インストール、メンテナンス、パッチは不要

## 解説

✅ **クラウドでインターネット経由利用 / ハードウェア管理不要 / 従量課金 / 自動更新**

これらは全てSoftware-as-a-Service製品の特徴です。

**分野:** ライセンスと機能

---

## 問題81

**問:** 多要素認証（MFA）はどれに対して有効にできますか？該当するものを全て選択してください。

- **正解:** ODBC
- **正解:** Python
- Snowpipe
- **正解:** Snowflake WebUI

## 解説

✅ **ODBC / Python / Snowflake WebUI**

MFAは全てのSnowflakeアカウントでデフォルトで有効になっており、全てのSnowflakeエディションで利用可能です。Webインターフェース、SnowSQL、各種コネクターとドライバーを含む全てのSnowflakeクライアントツールがMFAをサポートします。SnowpipeはSnowflakeが管理するサーバーレスサービスであり、ユーザーがログインできないためMFAは必要ありません。

https://docs.snowflake.com/en/user-guide/security-mfa

**分野:** セキュリティ

---

## 問題82

**問:** 真か偽か：Snowflakeの大きなテーブルには数百万または数億のマイクロパーティションが含まれる可能性がある。

- False
- **正解:** True

## 解説

✅ **True**

特定のテーブルのマイクロパーティション数は主にそのテーブルのデータ量に依存します。非常に大きなテーブルでは、マイクロパーティション数は数百万または数億に達する可能性があります。

https://docs.snowflake.com/en/user-guide/tables-clustering-micropartitions

**分野:** アーキテクチャ

---

## 問題83

**問:** フェイルセーフストレージからデータを取得できるのはどれですか？

- **正解:** Snowflakeサポート
- 顧客
- 誰でも
- クラウドプロバイダー

## 解説

✅ **Snowflakeサポート**

データがフェイルセーフストレージに入ると、Snowflakeサポートのみがデータの取得を支援できます。顧客はフェイルセーフストレージにアクセスできません。クラウドプロバイダーはフェイルセーフストレージかどうかにかかわらず、Snowflakeが保存するデータにアクセスできません。

https://docs.snowflake.com/en/user-guide/data-failsafe

**分野:** フェイルセーフ

---

## 問題84

**問:** Snowflakeはどのアクセス制御方法を許可していますか？該当するものを全て選択してください。

- 管理アクセス制御（Management access control / MAC）
- グローバルアクセス制御（Global access control / GAC）
- **正解:** 裁量アクセス制御（Discretionary access control / DAC）
- **正解:** ロールベースアクセス制御（Role-based access control / RBAC）

## 解説

✅ **裁量アクセス制御（DAC） / ロールベースアクセス制御（RBAC）**

Snowflakeのアクセス制御システムはRBACのアイデアに基づいており、ロールに権限を付与し、ユーザーにロールを付与します。Snowflakeはまた裁量アクセス制御（DAC）もサポートしており、オブジェクトを作成したロールがそのオブジェクトを所有し、他のロールにアクセスを提供できることを意味します。

https://docs.snowflake.com/en/user-guide/security-access-control-overview

**分野:** セキュリティ

---

## 問題85

**問:** 真か偽か：ストアドプロシージャを作成して実行するには、最低でもEnterpriseエディションが必要である。

- **正解:** False
- True

## 解説

✅ **False**

全てのSnowflakeエディションがストアドプロシージャをサポートするため、ストアドプロシージャを作成・実行するために必要な最低エディションはStandardエディションです。

https://docs.snowflake.com/en/user-guide/intro-editions.html

**分野:** ライセンスと機能

---

## 問題86

**問:** 真か偽か：Snowflake Scriptingはストアドプロシージャの作成に使用できる。

- False
- **正解:** True

## 解説

✅ **True**

Snowflake Scriptingは通常ストアドプロシージャの作成に使用されますが、ストアドプロシージャ外の手続き型コードの作成にも使用できます。

https://docs.snowflake.com/en/sql-reference/stored-procedures-snowflake-scripting

**分野:** Snowflake機能の拡張

---

## 問題87

**問:** Snowflakeの内部ステージについて正しいものはどれですか？2つ選択してください。

- 名前付き内部ステージは新しいファイルのために自動的に作成される
- ファイルはデフォルトの名前付き内部ステージに自動的にアップロードされる
- **正解:** テーブルには自動的に内部ステージが割り当てられる
- **正解:** ユーザーには自動的に内部ステージが割り当てられる

## 解説

✅ **テーブルには自動的に内部ステージが割り当てられる / ユーザーには自動的に内部ステージが割り当てられる**

テーブルステージは各テーブルに自動的に作成される内部ステージであり、そのテーブルへのデータロードに使用できます。各ユーザーもユーザー作成時に自動的に内部ステージオブジェクトが作成されます。

https://docs.snowflake.com/en/user-guide/data-load-local-file-system-create-stage#types-of-internal-stages

**分野:** データのロードとアンロード

---

## 問題88

**問:** ディレクトリテーブルをクエリしたときの結果セットに含まれる列はどれですか？該当するものを全て選択してください。

- IS_ENCRYPTED
- **正解:** ETAG
- **正解:** LAST_MODIFIED
- **正解:** MD5
- IS_DELETED

## 解説

✅ **ETAG / LAST_MODIFIED / MD5**

ディレクトリテーブルをクエリすると、結果セットにはステージオブジェクト内の各ファイルのFILE_URLが含まれます。また、ファイルのサイズ（バイト単位）、最終更新タイムスタンプ、MD5チェックサム、およびファイルの内容が変更された場合に変わるETAGファイルなどの追加メタデータも含まれます。

https://docs.snowflake.com/en/user-guide/data-load-dirtables-manage#output

**分野:** データ変換

---

## 問題89

**問:** Snowflakeアカウント間でデータが共有される場合、コンシューマー側で共有データを使用するためにどのタイプのデータベースが作成されますか？

- Permanent（永続）
- Temporary（一時）
- Open Access（オープンアクセス）
- Writable（書き込み可能）
- **正解:** Read-only（読み取り専用）

## 解説

✅ **Read-only（読み取り専用）**

コンシューマーはSharedオブジェクトから読み取り専用データベースを作成します。

https://docs.snowflake.com/en/user-guide/data-sharing-intro#how-does-secure-data-sharing-work

**分野:** データ共有

---

## 問題90

**問:** 複数のアカウントのレプリケーションを有効にするために必要なロールはどれですか？

- SECURITYADMIN
- **正解:** ORGADMIN
- ACCOUNTADMIN
- SYSADMIN

## 解説

✅ **ORGADMIN**

ソースとターゲットデータベースのレプリケーションを有効にするにはORGADMINを使用する必要があります。

https://docs.snowflake.com/en/user-guide/database-replication-config#prerequisite-enable-replication-for-accounts-in-the-organization

**分野:** セキュリティ

---

## 問題91

**問:** 真か偽か：シェアには少なくとも1つのコンシューマーが追加されている必要がある。

- **正解:** False
- True

## 解説

✅ **False**

Snowflakeシェアはコンシューマーを追加せずに定義できます。シェアには後から1つ以上のコンシューマーを追加できます。

**分野:** データ共有

---

## 問題92

**問:** クエリプロファイルに表示される「Bytes spilled to local storage」（ローカルストレージへのバイトスピル）を最もよく説明しているのはどれですか？

- 「Bytes spilled to local storage」はクエリ実行中に剪定されたマイクロパーティションの数である
- 「Bytes spilled to local storage」はGETコマンドを使用してダウンロードされたデータの量を示す
- **正解:** 「Bytes spilled to local storage」はメモリに収まらず仮想ウェアハウスの一時ストレージにスピルされなければならなかったデータ量を示す
- 「Bytes spilled to local storage」はSnowsightを使用してダウンロードされたデータ量を示す

## 解説

✅ **メモリに収まらず仮想ウェアハウスの一時ストレージにスピルされたデータ量**

Snowflakeは操作がメモリに収まらない場合、ウェアハウスのローカルディスクにデータを保存します。データスピルはより多くのIO操作を必要とし、ディスクアクセスはメモリアクセスより遅いため、クエリを遅くします。ローカルディスクがいっぱいになると、Snowflakeはリモートクラウドストレージにデータをスピルします。

https://docs.snowflake.com/en/user-guide/ui-query-profile#queries-too-large-to-fit-in-memory

**分野:** パフォーマンスの概念

---

## 問題93

**問:** 完了したクエリのクエリプロファイルのスニペットを考えてください。ハイライトされた統計を正確に説明しているものはどれですか？

- クエリプロファイルは非効果的なパーティション剪定を示している
- **正解:** クエリプロファイルは効果的なパーティション剪定を示している
- **正解:** クエリプロファイルはクエリに対して仮想ウェアハウスが小さすぎることを示している
- クエリプロファイルは仮想ウェアハウスキャッシュが使用されたことを示している

## 解説

✅ **効果的なパーティション剪定 / 仮想ウェアハウスが小さすぎる**

パーティション剪定は、スキャンされたパーティション数が合計パーティション数よりはるかに少ない場合に発生します。Snowflakeは操作がメモリに収まらない場合、ウェアハウスのローカルディスクにデータを保存します。

https://docs.snowflake.com/en/user-guide/ui-query-profile

**分野:** パフォーマンスの概念

---

## 問題94

**問:** 大きなテーブルのクラスタリングキーを定義する際に考慮すべき点はどれですか？

- **正解:** JOIN文で頻繁に使用される列をクラスタリングする
- **正解:** WHERE句で頻繁に使用される列をクラスタリングする
- 全ての数値列をクラスタリングする
- 全ての文字列列をクラスタリングする

## 解説

✅ **JOIN文で頻繁に使用される列 / WHERE句で頻繁に使用される列**

クラスタリングキーを定義する際の最初の候補クラスタリング列は、WHERE句またはその他の選択的フィルターで頻繁に使用される列です。また、結合に使用される列も考慮できます。さらに、列のカーディナリティ（個別値の数）も重要です。効果的なパーティション剪定を可能にするために十分に高いカーディナリティを持つ列を選択しつつ、Snowflakeがデータをマイクロパーティションに効率的にグループ化できるほど低いカーディナリティである必要があります。

https://docs.snowflake.com/en/user-guide/tables-clustering-keys

**分野:** パフォーマンスの概念

---

## 問題95

**問:** 真か偽か：パフォーマンスの問題を防ぐために、INFORMATION_SCHEMAを使用するクエリが十分に選択的でない場合はエラーが返される。

- False
- **正解:** True

## 解説

✅ **True**

INFORMATION SCHEMAクエリで指定されたフィルターが十分に選択的でない場合、次のエラーが返されます：「Information schema query returned too much data. Please repeat the query with more selective predicates.」（情報スキーマクエリが多すぎるデータを返しました。より選択的な述語でクエリを繰り返してください。）

https://docs.snowflake.com/en/sql-reference/info-schema#general-usage-notes

**分野:** アカウント使用量と監視

---

## 問題96

**問:** クラスタリングキーを定義することがクエリパフォーマンス向上にどのように役立ちますか？

- クラスタリングキーを定義すると、Snowflakeがクエリ結果を事前計算する
- **正解:** クラスタリングキーの一部である列にクエリが述語を使用する場合、最適なパーティション剪定が発生する
- クラスタリングキーが定義されると、Snowflakeが異なるコンピュートクラスターにデータを分散する

## 解説

✅ **クラスタリングキーの列に述語を使用する場合に最適なパーティション剪定が発生する**

特定の列でテーブルをクラスタリングすることで、クエリ処理から不要なパーティションを排除してクエリを最適化できます。クラスタリングキーを定義してテーブルを再クラスタリングすることで、クラスタリングキーに従ってデータをマイクロパーティションに効果的に再分配し、クラスタリングされた列で述語または結合するクエリへの最適なアクセスを確保します。

https://docs.snowflake.com/en/user-guide/tables-clustering-keys

**分野:** パフォーマンスの概念

---

## 問題97

**問:** 他のSnowflakeアカウントとデータを共有するために必要なSnowflakeの最低エディションはどれですか？

- Enterprise
- Business Critical
- **正解:** Standard
- Virtual Private Snowflake

## 解説

✅ **Standard**

データ共有は全てのSnowflakeエディションでサポートされているため、それをサポートする最低エディションはStandardエディションです。

https://docs.snowflake.com/en/user-guide/intro-editions.html

**分野:** ライセンスと機能

---

## 問題98

**問:** Snowflakeでのスケールアウトを正確に説明している文章はどれですか？該当するものを全て選択してください。

- **正解:** スケールアウトはマルチクラスター仮想ウェアハウスの使用によって達成される
- **正解:** スケールアウトはクエリのキューイングを減らすのに役立つ
- スケールアウトは仮想ウェアハウスのサイズを増減することによって達成される

## 解説

✅ **マルチクラスター仮想ウェアハウスによって達成 / クエリキューイングの削減に役立つ**

仮想ウェアハウスには定義されたコンピューティングリソースセットがあります。キューの問題を解決するために、Snowflakeはマルチクラスター仮想ウェアハウスを提供します。マルチクラスター仮想ウェアハウスは需要に基づいて動的に追加クラスターを追加します。需要が減少すると、追加クラスターは廃止されます。このプロセスはスケールアウト（またはスケールバック）またはオートスケーリングとも呼ばれます。

**分野:** パフォーマンスの概念

---

## 問題99

**問:** データ共有をサポートしないSnowflakeエディションはどれですか？

- **正解:** Virtual Private Snowflake (VPS)
- Enterprise
- Business Critical
- Standard

## 解説

✅ **Virtual Private Snowflake (VPS)**

Virtual Private Snowflake (VPS)は分離されたメタデータ、コンピュート、ストレージを持つため、セキュアデータ共有、Marketplaceなどを使用できません。VPSアカウントには共有機能がありません。

**分野:** データ共有

---

## 問題100

**問:** Snowflakeのリーダーアカウントを正しく説明しているものはどれですか？

- リーダーアカウントは外部テーブルにアクセスするために必要である
- リーダーアカウントは部門間でクエリコストを分配するために使用される
- リーダーアカウントはテスト目的のみに使用される
- **正解:** リーダーアカウントはSnowflakeを使用していないユーザーとデータを共有するために使用できる

## 解説

✅ **Snowflakeを使用していないユーザーとデータを共有するために使用できる**

リーダーアカウントを作成することで、Snowflakeを使用していないユーザーや組織とデータを共有できます。このリーダーアカウントはデータプロバイダーが共有目的のみのために作成します。

https://docs.snowflake.com/en/user-guide/data-sharing-reader-create

**分野:** データ共有

---

## 問題101

**問:** Snowsightがサポートするチャートタイプはどれですか？該当するものを全て選択してください。

- **正解:** スコアカード（Scorecards）
- **正解:** 棒グラフ（Bar Charts）
- パレート図（Pareto Charts）
- 円グラフ（Pie Charts）
- エリアチャート（Area charts）

## 解説

✅ **スコアカード / 棒グラフ**

Snowsightは以下をサポートします：棒グラフ（Bar charts）、折れ線グラフ（Line charts）、散布図（Scatterplots）、ヒートグリッド（Heat grids）、スコアカード（Scorecards）。

https://docs.snowflake.com/en/user-guide/ui-snowsight-visualizations

**分野:** ツールとインターフェース

---

## 問題102

**問:** Snowflakeのリーダーアカウントについてのどのステートメントが正しいですか？該当するものを全て選択してください。

- 単一のリーダーアカウントは異なるプロバイダーが共有するデータにアクセスできる
- **正解:** リーダーアカウントのサポートリクエストはプロバイダーアカウントを通じて提出する必要がある
- **正解:** リーダーアカウントはリーダーアカウントを作成したプロバイダーアカウントが共有するデータのみにアクセスできる
- リーダーアカウントはサポートリクエストを提出できる

## 解説

✅ **サポートリクエストはプロバイダーアカウント経由 / 作成したプロバイダーのデータのみアクセス可能**

リーダーアカウントはSnowflakeのライセンス契約を持たないため、サポートにアクセスできません。代わりに、リーダーアカウントを作成したプロバイダーアカウントがサポートリクエストを管理します。リーダーアカウントを作成したプロバイダーアカウントのデータのみをリーダーアカウントが使用できます。

https://docs.snowflake.com/en/user-guide/data-sharing-reader-create

**分野:** データ共有

---

## 問題103

**問:** Snowflakeはテーブルデータをどの形式で保存しますか？

- **正解:** 独自形式（A proprietary format）
- JSON
- CSVおよびTSVファイル
- Parquet形式

## 解説

✅ **独自形式（A proprietary format）**

Snowflakeは、AWS S3、Azure Blob Storage、Google Cloud StorageなどのクラウドオブジェクトストレージのSnowflake独自形式でデータを保存します。ユーザーは実際のファイルを見たり、データの保存方法を確認したり、ファイルに直接アクセスしたりすることはできません。

**分野:** アーキテクチャ

---

## 問題104

**問:** マルチクラスター仮想ウェアハウスが最小クラスター数1、最大クラスター数3で設定されているとします。この仮想ウェアハウスは最大化モードですか？

- **正解:** No（いいえ）
- Yes（はい）

## 解説

✅ **No（いいえ）**

マルチクラスター仮想ウェアハウスは最大化モードまたはオートスケールモードで作成できます。最大化モードはマルチクラスターの最小と最大ウェアハウス数を同じ値に設定することで有効になります。この設定（最小1、最大3）は異なる値のためオートスケールモードです。

https://docs.snowflake.com/en/user-guide/warehouses-multicluster#setting-the-scaling-policy-for-a-multi-cluster-warehouse

**分野:** パフォーマンスの概念

---

## 問題105

**問:** SnowflakeでUDFを作成するためにサポートされている言語はどれですか？

- **正解:** JavaScript
- **正解:** Python
- **正解:** Java
- C#
- **正解:** SQL
- C++

## 解説

✅ **JavaScript / Python / Java / SQL**

SQL、Java、JavaScript、PythonはSnowflakeでUDFを作成するために使用できます。

https://docs.snowflake.com/en/sql-reference/udf-overview#supported-languages

**分野:** Snowflake機能の拡張

---

## 問題106

**問:** Snowflakeアーキテクチャで同じレイヤーを指す用語はどれですか？該当するものを全て選択してください。

- **正解:** サービスレイヤー（Services Layer）
- ストレージレイヤー（Storage Layer）
- 仮想ウェアハウス（Virtual Warehouses）
- **正解:** クラウドサービスレイヤー（Cloud Services Layer）

## 解説

✅ **サービスレイヤー / クラウドサービスレイヤー**

クラウドサービスレイヤーとサービスレイヤーという用語は同義語として使用されます。

https://docs.snowflake.com/en/user-guide/intro-key-concepts#cloud-services

**分野:** アーキテクチャ

---

## 問題107

**問:** クエリプロファイルについて正しいものはどれですか？該当するものを全て選択してください。

- クエリプロファイルは完了していないクエリには利用できない
- **正解:** クエリのクエリプランを表示する
- **正解:** 全ステップのグラフィカル表現を表示する
- **正解:** クエリプロファイルは実行中、完了、または失敗した全クエリで利用可能

## 解説

✅ **クエリプランを表示 / グラフィカル表現を表示 / 全クエリで利用可能**

クエリプロファイルはクエリ実行の詳細を提供します。指定されたクエリの処理プランの主要コンポーネントのグラフィカル表現と各コンポーネントの統計、全体的なクエリ情報と統計を表示します。クエリプロファイルは実行中、完了、または失敗した全クエリで利用可能です。

https://docs.snowflake.com/en/user-guide/ui-query-profile

**分野:** パフォーマンスの概念

---

## 問題108

**問:** Snowflakeのアーキテクチャについて正しいステートメントはどれですか？該当するものを全て選択してください。

- Snowflakeはコンピュートとストレージが密結合したモノリシックアーキテクチャを使用する
- **正解:** Snowflakeではストレージを変更せずにコンピュートリソースを増減できる
- Snowflakeではストレージが増加するたびにコンピュートも増加する必要がある
- **正解:** Snowflakeのストレージとコンピュートは互いに独立している

## 解説

✅ **ストレージ変更なしにコンピュートを増減可能 / ストレージとコンピュートは独立**

Snowflakeはコンピュートとストレージを分離する新しいハイブリッドアーキテクチャを実装しています。このハイブリッドアーキテクチャにより、ストレージの変更なしにコンピュートを増減でき、逆も同様です。

**分野:** アーキテクチャ

---

## 問題109

**問:** 仮想ウェアハウスをリサイズするために必要な権限はどれですか？

- **正解:** MODIFY
- USAGE
- ALTER
- MONITOR

## 解説

✅ **MODIFY**

MODIFY権限はロールが仮想ウェアハウスのサイズを変更できるようにします。

https://docs.snowflake.com/en/sql-reference/sql/alter-warehouse#access-control-requirements

**分野:** セキュリティ

---

## 問題110

**問:** データベース管理者として、大きなテーブルに新しいクラスタリングキーを定義しました。Snowflakeがデータを再クラスタリングする間、何が起きると予想されますか？該当するものを全て選択してください。

- **正解:** Snowflakeがマイクロパーティションでデータを再分配している間も、SELECTクエリは通常通り実行される
- Snowflakeがマイクロパーティションでデータを再分配している間、SELECTクエリは実行がブロックされる
- Snowflakeがマイクロパーティションでデータを再分配している間、DMLクエリは許可されない
- **正解:** Snowflakeがマイクロパーティションでデータを再分配している間も、DMLクエリは通常通り実行される

## 解説

✅ **SELECTクエリは通常通り実行 / DMLクエリも通常通り実行**

Snowflakeの再クラスタリング操作はユーザーに透過的であり、DMLまたはSELECTクエリをブロックしません。再クラスタリング中のテーブルは、クエリ、更新、変更される際に他のテーブルとまったく同じように動作します。

https://docs.snowflake.com/en/user-guide/tables-auto-reclustering#non-blocking-dml

**分野:** パフォーマンスの概念

---

## 問題111

**問:** Tri-Secret Secure暗号化で組み合わされるキーはどれですか？2つ選択してください。

- **正解:** Snowflakeが管理するキー（Snowflake-managed）
- 公開鍵（Public key）
- ハッシュキー（Hash key）
- **正解:** 顧客が管理するキー（Customer-managed）

## 解説

✅ **Snowflakeが管理するキー / 顧客が管理するキー**

Tri-Secret SecureはSnowflakeが管理するキーと顧客が管理するキーの組み合わせを指し、データを保護するための複合マスターキーを作成します。Tri-Secret SecureはBusiness Criticalエディション以上が必要で、Snowflakeサポートに連絡することで有効化できます。

https://docs.snowflake.com/en/user-guide/security-encryption-manage

**分野:** セキュリティ

---

## 問題112

**問:** Snowflakeの顧客が実行する必要がない活動はどれですか？該当するものを全て選択してください。

- **正解:** データセンターレベルでのハードウェアの高可用性の設定とテスト
- ユーザーアクセスと権限の管理
- **正解:** Snowflakeデータベースをインストールするためのハードウェアのプロビジョニング
- **正解:** Snowflakeデータベースソフトウェアのインストール
- **正解:** データセンターの物理的セキュリティの確保

## 解説

✅ **ハードウェア高可用性の設定・テスト / ハードウェアプロビジョニング / ソフトウェアインストール / 物理セキュリティの確保**

SaaSとしてのSnowflakeは、顧客がデータセンターとその物理的セキュリティを管理したり、ハードウェアやソフトウェアをインストールしたり、高可用性を管理したりする必要がありません。

**分野:** ライセンスと機能

---

## 問題113

**問:** データベースまたはスキーマがクローンされた場合、そのデータベース内のSnowpipeに関して正しいステートメントはどれですか？

- **正解:** 内部ステージを参照するSnowpipeはクローンされない
- 外部ステージを参照するSnowpipeはクローンされない
- 内部ステージを参照するSnowpipeはクローンされる
- **正解:** 外部ステージを参照するSnowpipeはクローンされる

## 解説

✅ **内部ステージを参照するSnowpipeはクローンされない / 外部ステージを参照するSnowpipeはクローンされる**

データベースまたはスキーマがクローンされた場合、名前付き内部ステージを指すSnowpipeはクローンされません。外部ステージを参照するSnowpipeはクローンされます。

https://docs.snowflake.com/en/user-guide/object-clone#cloning-and-pipes

**分野:** クローニング

---

## 問題114

**問:** シェアを作成できるのはどれですか？該当するものを全て選択してください。

- **正解:** CREATE SHARE権限を持つロール
- **正解:** ACCOUNTADMINロール
- SECURITYADMINロール
- SYSADMINロール

## 解説

✅ **CREATE SHARE権限を持つロール / ACCOUNTADMINロール**

シェアはACCOUNTADMINロールまたは明示的にCREATE SHARE権限が付与されたロールのみが作成できます。

https://docs.snowflake.com/en/user-guide/data-sharing-gs

**分野:** データ共有

---

## 問題115

**問:** 真か偽か：一時テーブルのタイムトラベル保持期間が終了すると、一時テーブルの履歴データはSnowflakeサポートでも復元できない。

- **正解:** True
- False

## 解説

✅ **True**

過渡テーブルと一時テーブルにはフェイルセーフ機能がないため、これらのテーブルのデータはゼロ日のフェイルセーフストレージを通過します。また、過渡テーブルと一時テーブルの最大タイムトラベルは1日です。したがって、これらのテーブルのタイムトラベル期間が完了すると、履歴データを復元する方法はありません。

https://docs.snowflake.com/en/user-guide/tables-temp-transient

**分野:** データ保護

---

## 問題116

**問:** Snowflake Webインターフェースのクエリ履歴は何日間保持されますか？

- **正解:** 14日
- 365日
- 30日
- 6ヶ月

## 解説

✅ **14日**

クエリ履歴ページでは、実行済みおよび現在実行中のクエリの履歴を表示できます。クエリ履歴ページは過去14日間に実行されたクエリの履歴を表示できます。

https://docs.snowflake.com/en/user-guide/ui-snowsight-activity#query-history

**分野:** アカウント使用量と監視

---

## 問題117

**問:** 真か偽か：必要に応じて仮想ウェアハウスのサイズを増減できる。

- **正解:** True
- False

## 解説

✅ **True**

仮想ウェアハウスはクエリの複雑さが増した場合に十分なパフォーマンスを確保するためにスケールアップできます。スケールダウンは一般的にクエリの複雑さが減少したことに応じて行われます。

https://docs.snowflake.com/en/user-guide/warehouses-considerations

**分野:** パフォーマンスの概念

---

## 問題118

**問:** Snowflakeでクエリパフォーマンスを向上させる方法はどれですか？

- **正解:** クラスタリングキー（Clustering Keys）
- 結合インデックス（Join Indices）
- セカンダリインデックス（Secondary Indices）
- クエリヒント（Query Hints）

## 解説

✅ **クラスタリングキー（Clustering Keys）**

特定の列でテーブルをクラスタリングすることで、クエリ処理から不要なパーティションを排除してクエリを最適化できます。

https://docs.snowflake.com/en/user-guide/tables-clustering-keys

**分野:** パフォーマンスの概念

---

## 問題119

**問:** SELECTクエリ仕様から取得した事前計算済みデータセットを格納して将来の使用のために保存するものを表す用語はどれですか？

- ビュー（View）
- セキュアビュー（Secure View）
- **正解:** マテリアライズドビュー（Materialized View）
- 出力ビュー（Output View）

## 解説

✅ **マテリアライズドビュー（Materialized View）**

マテリアライズドビューはSELECTクエリに基づいてデータを事前計算するビューです。クエリの結果は事前計算され、将来同様のクエリのパフォーマンスを向上させるために物理的に保存されます。基礎テーブルが更新されると、マテリアライズドビューは自動的にリフレッシュされます。

https://docs.snowflake.com/en/user-guide/views-materialized

**分野:** パフォーマンスの概念

---

## 問題120

**問:** 仮想ウェアハウスのスケールアップ/ダウンとスケールアウトについて正しいステートメントはどれですか？該当するものを全て選択してください。

- **正解:** 仮想ウェアハウスのスケールアウトとスケールバックはSnowflakeによって自動的に行われる
- **正解:** 仮想ウェアハウスのスケールアップとスケールダウンは手動プロセスである
- 仮想ウェアハウスのスケールアップとスケールダウンはSnowflakeによって自動的に管理される
- 仮想ウェアハウスのスケールアウトとスケールバックは手動プロセスである

## 解説

✅ **スケールアウト・スケールバックは自動 / スケールアップ・スケールダウンは手動**

マルチクラスター仮想ウェアハウスはキューの問題を解決するために需要に基づいて動的（かつ自動的）に追加クラスターを追加します。スケールアップとスケールダウンは手動プロセスです。

https://docs.snowflake.com/en/user-guide/warehouses-multicluster

**分野:** パフォーマンスの概念

---

## 問題121

**問:** ストアドプロシージャを作成する良い理由とならない要件はどれですか？

- **正解:** 2つの値の平均を計算する
- 長期間使用されていないテーブルを見つけてドロップする
- 共有された一時データを毎日クリーンアップするための一連のSQLを実行する
- 新しいユーザーとそのユーザーの新しいデータベースを作成するための一連のSQLステートメントを実行する

## 解説

✅ **2つの値の平均を計算する**

ストアドプロシージャとUDFは似ているように見えますが、異なる目的に役立ちます。UDFの役割は入力を受け取り、計算を行い、値を返すことであり、ストアドプロシージャの役割は1つ以上のSQLクエリを実行することです。したがって、2つの値の平均を計算することはUDFで最もよく処理されます。

https://docs.snowflake.com/en/sql-reference/stored-procedures-overview

**分野:** Snowflake機能の拡張

---

## 問題122

**問:** プロキシまたはファイアウォールを通じたアクセスのためにSnowsightを設定する際に、Snowsightの完全修飾URLとポートを決定するために使用される関数はどれですか？

- **正解:** SYSTEM$ALLOWLIST
- SYSTEM$REFERENCE
- SYSTEM$GET_TAG
- SYSTEM$GENERATE_SAML_CSR

## 解説

✅ **SYSTEM$ALLOWLIST**

プロキシやファイアウォールを使用してSnowsightに接続するには、完全修飾URLとポート値をプロキシサーバーまたはファイアウォール設定に追加する必要があります。SYSTEM$ALLOWLIST関数の戻り値のSNOWSIGHT_DEPLOYMENTアイテムを使用して、完全修飾SnowsightのURLとポートを確認します。

https://docs.snowflake.com/en/user-guide/ui-snowsight-gs#accessing-sf-web-interface-through-a-proxy-or-firewall

**分野:** セキュリティ

---

## 問題123

**問:** 仮想ウェアハウスサイズの例として正しいものはどれですか？

- Low
- **正解:** X-Small
- **正解:** Medium
- High
- **正解:** 6X-Large

## 解説

✅ **X-Small / Medium / 6X-Large**

SnowflakeはX-Small、Small、Medium、Largeなどのようなサイズのラベルを使用して仮想ウェアハウスの選択を簡単にしています。

https://docs.snowflake.com/en/user-guide/warehouses-overview

**分野:** アーキテクチャ

---

## 問題124

**問:** 真か偽か：Snowflakeはクラスタリングキーに最大3〜4列を推奨している。

- **正解:** True
- False

## 解説

✅ **True**

Snowflakeはクラスタリングキーに最大3〜4列を使用することを推奨しています。クラスタリングキーの列数が増えるとメンテナンスコストが高くなり、クラスタリングコストを正当化するほどの十分な利益が得られません。

https://docs.snowflake.com/en/user-guide/tables-clustering-keys

**分野:** パフォーマンスの概念

---
