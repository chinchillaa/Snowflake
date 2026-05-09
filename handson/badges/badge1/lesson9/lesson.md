 🥋 Create a Snowflake Stage Object
🥋 Create a Snowflake Stage Object

Create a stage that points to an internal directory that can hold your files before you load them into tables.

🤖 DORA DWW10
🤖 Run This in Your Worksheet to Send a Report to DORA

NEVER EDIT DORA CODE TO GET A GREEN CHECK. EDIT YOUR LAB WORK.


--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW10' as step
  ,( 
    select count(*) 
    from UTIL_DB.INFORMATION_SCHEMA.stages
    where stage_name='MY_INTERNAL_STAGE'
    AND stage_type IS NULL
    ) as actual
  , 1 as expected
  , 'Internal stage created' as description
 ); 

🥋 Load a File into Your Stage
🥋 Download a File & Upload It To Your Stage

VEG_NAME_TO_SOIL_TYPE_PIPE.txt
536 B




📓 A Warehouse Metaphor for Loading Data

Though you can't see it, your stage is based on an AWS Storage area called an S3 bucket. If your Snowflake account was in an Azure Region, your stage would be in an Azure Blob.  Likewise, a GCP-based Snowflake account would have staging areas in GCP buckets.

You will use a COPY INTO statement to move a file from the stage into a table.  



To COPY INTO statement, it is best to have 4 things in place:

A table

A stage object

A file

A file format

The file format is sort of optional, but it's a cleaner process if you have one, and we do!


copy into my_table_name
from @my_internal_stage
files = ( 'IF_I_HAD_A_FILE_LIKE_THIS.txt')
file_format = ( format_name='EXAMPLE_FILEFORMAT' );
You already have your stage, and you have a file loaded into that stage. All you need now is a table and a file format. Once you have those, you'll be able to run a COPY INTO statement.

🥋 Use the COPY INTO Statement to Load Data
🥋 Create a Table for Soil Types

Make sure you create it in the GARDEN_PLANTS database, in the VEGGIES schema.


create or replace table vegetable_details_soil_type
( plant_name varchar(25)
 ,soil_type number(1,0)
);
🥋 Create a File Format


create file format garden_plants.veggies.PIPECOLSEP_ONEHEADROW 
    type = 'CSV'--csv is used for any flat file (tsv, pipe-separated, etc)
    field_delimiter = '|' --pipes as column separators
    skip_header = 1 --one header row to skip
    ;
🥋 A Copy Into Statement You Can Run


copy into vegetable_details_soil_type
from @util_db.public.my_internal_stage
files = ( 'VEG_NAME_TO_SOIL_TYPE_PIPE.txt')
file_format = ( format_name=GARDEN_PLANTS.VEGGIES.PIPECOLSEP_ONEHEA

🤖 DORA DWW11
🤖 Run This in Your Worksheet to Send a Report to DORA

NEVER EDIT DORA CODE TO GET A GREEN CHECK. EDIT YOUR LAB WORK.


--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
  SELECT 'DWW11' as step
  ,( select row_count 
    from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
    where table_name = 'VEGETABLE_DETAILS_SOIL_TYPE') as actual
  , 42 as expected
  , 'Veg Det Soil Type Count' as description
 ); 

 🥋 Query a File Before You Load It
🎯 Download and Upload This File Into Your Stage

LU_SOIL_TYPE.tsv
545 B
🥋 Create Another File Format


create file format garden_plants.veggies.COMMASEP_DBLQUOT_ONEHEADROW 
    TYPE = 'CSV'--csv for comma separated files
    FIELD_DELIMITER = ',' --commas as column separators
    SKIP_HEADER = 1 --one header row  
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
--this means that some values will be wrapped in double-quotes bc they have commas in them
    ;
🥋 Explore the Effect of File Formats On Data Interpretation

You can query data before you load it. Look at the data in a file we are about to load and see how the data changes based on what we tell Snowflake about how the data is formatted.


--The data in the file, with no FILE FORMAT specified
select $1
from @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv;

--Same file but with one of the file formats we created earlier  
select $1, $2, $3
from @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv
(file_format => garden_plants.veggies.COMMASEP_DBLQUOT_ONEHEADROW);

--Same file but with the other file format we created earlier
select $1, $2, $3
from @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv
(file_format => garden_plants.veggies.PIPECOLSEP_ONEHEADROW );
💪🏽 Do You Have What It Takes?

🫀 Do You WANT this Badge BAD ENOUGH?

Neither of the file formats used above seem like the right file format to load this TSV file. It's time for you to challenge yourself to figure out the magic combination of file format settings that WILL LOAD THE FILE CORRECTLY.

People who become developers have this need to "win" over computers. When we can't figure something out we might say "Ugh! Forget it!" for an hour or two but eventually our mindset comes back to, "Heck no! This computer will not win! I am smarter than it is! I CAN figure this out and I WILL figure this out!!"

We designed the next Challenge Lab to weed out the people who thought this course was going to be a Click-Next-50-Times-To-Receive-Your-Badge! kind of course. That's not what, or who, this course is for!!

We know this exercise is challenging! But we promise you already have the tools to complete this challenge. You may need to go back and do some reviewing on your own, but the information is THERE.

🎯 Challenge Lab: Create a File Format, Use it in a COPY INTO
🎯 Create a File Format That Makes the Data Look Great

Before you loaded the TSV file to your stage, you downloaded it to your local machine. Open the local file and LOOK at the file structure. Use a good text editor (NOT EXCEL, NOT GOOGLE SHEETS).

Do you see any issues in the data?  Do not edit the data. We want you to create a file format that can handle the file's data without any direct file edits.

Create a file format that will help you load files with these properties. Name the file format: L9_CHALLENGE_FF

Make sure the data looks like the screenshot below when you use your new File Format in the query.



TIPS and TRICKS

All flat files are loaded using file formats that have a type of CSV (Comma Separated Values). So, use TYPE = CSV for any flat file (TSV, Pipe Delimited, .txt, etc.).

The FIELD_DELIMITER property is very important. It should match the actual Column Separator being used in the file.

Once you create your FILE FORMAT, if you want to edit it, just add OR REPLACE to the code (as in CREATE OR REPLACE FILE FORMAT) and you will be editing the file format by re-defining it.

It is possible to load the data without creating the file format, but as you might have guessed, DORA will be looking for the L9_CHALLENGE_FF file format.

If columns in a file were separated by a tab, you would put FIELD_DELIMITER = '\t' as a property in the file format you created.

🥋 Create a Soil Type Look Up Table

Make sure you create it in the GARDEN_PLANTS database, in the VEGGIES schema. Also, make sure it is owned by the SYSADMIN role.

You can use the CONTEXT settings to make sure these things happen or you can use a combination of CONTEXT settings and fully qualifying the table name before you run the code to create the table.


create or replace table LU_SOIL_TYPE(
SOIL_TYPE_ID number,	
SOIL_TYPE varchar(15),
SOIL_DESCRIPTION varchar(75)
);
🎯 Create a COPY INTO Statement to Load the File into the Table

Create a COPY INTO command to load the file (LU_SOIL_TYPE.tsv) from your stage to the LU_SOIL_TYPE table.

Load the table by running the COPY INTO command you wrote.  DO NOT use 'SKIP_FILE' or 'CONTINUE' for the ON_ERROR option, even if the system suggests it.

Run a SELECT * on the table to see if loaded nicely.

If it didn't, truncate the table, fix the file format (or COPY INTO) and load it again.

🎯 Challenge Lab: Create a Table, Use It in a COPY INTO!
🎯 Choose a File Format, write the COPY INTO, Load the File into the Table

Start by downloading this file:

veg_plant_height.csv
781 B
Look at the data. Do not edit the data. Just look to understand it.  

Create a table called VEGETABLE_DETAILS_PLANT_HEIGHT in the VEGGIES schema. Use the header row of the file to get your column names. Choose good data types for each column.

Upload the file into your stage. (Zoom out in your browser if you cannot see the submit button)

Choose an existing file format (one you already created) that you think can be used to load the data.

Use a COPY INTO command to load the file from the Stage to the table you created. 

NOTE: The most common error is "Number of columns in file (1) does not match that of the corresponding table (4)" if you see this message, you have not chosen the correct file format. Or, sometimes, you are trying to load the wrong file. Double-check the file, file format, and table to make sure they match up.

🤖 DORA DWW12
🤖 Run This in Your Worksheet to Send a Report to DORA

NEVER EDIT DORA CODE TO GET A GREEN CHECK. EDIT YOUR LAB WORK.


--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (  
      SELECT 'DWW12' as step 
      ,( select row_count 
        from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
        where table_name = 'VEGETABLE_DETAILS_PLANT_HEIGHT') as actual 
      , 41 as expected 
      , 'Veg Detail Plant Height Count' as description   
); 

🤖 DORA DWW13
🤖 Run This in Your Worksheet to Send a Report to DORA

NEVER EDIT DORA CODE TO GET A GREEN CHECK. EDIT YOUR LAB WORK.


--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (  
     SELECT 'DWW13' as step 
     ,( select row_count 
       from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
       where table_name = 'LU_SOIL_TYPE') as actual 
     , 8 as expected 
     ,'Soil Type Look Up Table' as description   
); 

🤖 DORA DWW14
🤖 Run This in Your Worksheet to Send a Report to DORA

NEVER EDIT DORA CODE TO GET A GREEN CHECK. EDIT YOUR LAB WORK.


-- Set your worksheet drop lists
-- DO NOT EDIT THE CODE 
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from ( 
     SELECT 'DWW14' as step 
     ,( select count(*) 
       from GARDEN_PLANTS.INFORMATION_SCHEMA.FILE_FORMATS 
       where FILE_FORMAT_NAME='L9_CHALLENGE_FF' 
       and FIELD_DELIMITER = '\t') as actual 
     , 1 as expected 
     ,'Challenge File Format Created' as description  
); 

👂 Check In With DORA
🧰 Use the App To Check Your Work



The Snow-Amazing App can tell you:

What tests DORA has received from you via the GRADER function.

Whether you passed each test.

Whether each test was valid. If any tests were changed by you they are marked INVALID.

While you're in the app:

Double-check your email. Did you spell it correctly?

Double-check your display name. Is that how you want it to appear on your badge? You can use accents and any unicode characters so make your name look exactly how you want it to appear!

Make sure you have a link record that includes your ACCOUNT ID AND ACCOUNT LOCATOR. Without both pieces of information in the link record, your badge will be blocked.

Visit https://ysa.snowflakeuniversity.com(opens in a new tab)

You will need your UNI_ID and UUID to log into the YSA App, which you can find on the course registration page at training.snowflake.com:



We recommend that you store this info in a safe place, as you will need it any time you access the YSA App to check your course progress & badge status.

