/*
 * MERGE文でLOGS_ENHANCEDテーブルを更新し、
 * Time Travelを使って更新前の状態を確認・復元するスクリプト
 */

-- RAW.LOGSとENHANCED.LOGS_ENHANCEDを突合し、一致する行のip_addressを更新する
merge into AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED e
using AGS_GAME_AUDIENCE.RAW.LOGS r -- ソーステーブル（生ログ）
on r.user_login = e.gamer_name           -- ユーザー名で結合
and r.datetime_iso8601 = e.game_event_utc -- イベント日時で結合
and r.user_event = e.game_event_name      -- イベント種別で結合
when matched then
update set ip_address = 'Hey, I updated matching rows'; -- 動作確認用の仮値

-- Time Travelで上記MERGE実行前のデータを確認する(Query HistoryからQuery IDを特定済)
select *
from AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED
  before(STATEMENT => '01c3dfef-0308-9466-0028-3be300115242');

-- Time Travelクローンで復元用の一時テーブルを作成する
create or replace table AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED_RESTORE
  clone AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED
  before(STATEMENT => '01c3dfef-0308-9466-0028-3be300115242');

-- 復元テーブルと元テーブルを入れ替えて復元を完了する
ALTER TABLE AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED
  SWAP WITH AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED_RESTORE;

-- 不要になった一時テーブルを削除する
DROP TABLE AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED_RESTORE;
