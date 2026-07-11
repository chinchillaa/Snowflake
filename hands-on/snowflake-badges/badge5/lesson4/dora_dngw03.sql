select GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
  SELECT
   'DNGW03' as step
   ,( select count(*) 
      from ags_game_audience.enhanced.logs_enhanced
      where dow_name = 'Sat'
      and tod_name = 'Early evening'   
      and gamer_name like '%prajina'
     ) as actual
   ,2 as expected
   ,'Playing the game on a Saturday evening' as description
); 