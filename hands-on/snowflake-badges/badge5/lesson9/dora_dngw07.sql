select GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
SELECT
'DNGW07' as step
 ,( select count(*)/count(*) from snowflake.account_usage.query_history
    where query_text like '%case when game_session_length < 10%'
  ) as actual
 ,1 as expected
 ,'Curated Data Lesson completed' as description
 ); 