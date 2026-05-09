use role accountadmin;
-- SYSADMINロールでタスクをテストするには、この権限付与が必要です
-- タスクのオーナーがSYSADMINであっても、この設定は必須です
grant execute task on account to role SYSADMIN;
grant usage on warehouse COMPUTE_WH to role SYSADMIN;

use role sysadmin; 

-- これでSYSADMINロールでもタスクを実行できるようになります
execute task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED;

-- SHOWコマンドでタスクの一覧を確認できます
show tasks in account;

-- DESCRIBEコマンドではタスクの詳細を確認できます
describe task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED;
