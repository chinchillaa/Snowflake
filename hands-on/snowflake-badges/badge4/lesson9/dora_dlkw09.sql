select GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
  SELECT
  'DLKW09' as step
  ,( select row_count
       from mels_smoothie_challenge_db.information_schema.tables
       where table_schema = 'TRAILS'
       and table_name = 'SMV_CHERRY_CREEK_TRAIL'
    ) as actual
  ,3526 as expected
  ,'Secure Materialized View Created' as description
 );