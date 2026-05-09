--MERGEのテストサイクル。以下のコマンドを使って、MERGEが正しく動作するか確認します

--テーブルの現在のレコード数を確認しておきます
select * from AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;

--MERGEを数回実行します。この時点では新しい行は追加されないはずです
EXECUTE TASK AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED;

--行数が変わっていないか確認します
select * from AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;

--raw.game_logsテーブルにテスト用のレコードを挿入します
--user_eventフィールドを毎回変えることで「新しい」レコードを作れます
--ip_addressやdatetime_iso8601を変更すると不必要に複雑になるので避けましょう
--user_loginを変更するとテスト後にダミーレコードを削除しにくくなります
INSERT INTO AGS_GAME_AUDIENCE.RAW.LOGS
select PARSE_JSON('{"datetime_iso8601":"2025-01-01 00:00:00.000", "ip_address":"196.197.196.255", "user_event":"fake event", "user_login":"fake user"}');

--新しい行を挿入したら、再度MERGEを実行します
EXECUTE TASK AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED;

--行が追加されたか確認します
select * from AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;

--MERGEが正しく動作していることを確認できたら、Rawテーブルのダミーレコードを削除します
delete from ags_game_audience.raw.game_logs where raw_log like '%fake user%';

--Enhancedテーブルのダミー行も削除しておきましょう
delete from AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED
where gamer_name = 'fake user';

--行数が最初の状態に戻っていることを確認します
select * from AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED; 
