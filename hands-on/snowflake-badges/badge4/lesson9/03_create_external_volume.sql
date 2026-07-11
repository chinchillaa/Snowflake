/*
  Icebergテーブル用の外部ボリュームを作成するスクリプト
  AWS S3バケットをストレージロケーションとして定義し、IAMロールで認証する
*/

-- 外部ボリュームの作成（既存の場合は置き換え）
create or replace external volume iceberg_external_volume
STORAGE_LOCATIONS = (
    (
        NAME = 'iceberg-s3-us-west-2' -- ストレージロケーションの識別名
        STORAGE_PROVIDER = 'S3' -- クラウドストレージプロバイダー（AWS S3）
        STORAGE_BASE_URL = 's3://uni-dlkw-iceberg' -- S3バケットのベースURL
        STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::321463406630:role/dlkw_iceberg_role' -- S3アクセス用のIAMロールARN
        STORAGE_AWS_EXTERNAL_ID = 'dlkw_iceberg_id' -- IAM信頼ポリシー用の外部ID
    )
);

DESC EXTERNAL VOLUME iceberg_external_volume;