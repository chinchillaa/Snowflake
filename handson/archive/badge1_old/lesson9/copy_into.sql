create or replace table GARDEN_PLANTS.VEGGIES.VEGETABLE_DETAILS_PLANT_HEIGHT
(
    plant_name varchar(25),
    UOM varchar(1),
    Low_End_of_Range NUMBER(3,0),
    High_End_of_Range NUMBER(3,0)    
);

select $1, $2, $3, $4
from @UTIL_DB.PUBLIC.MY_INTERNAL_STAGE/veg_plant_height.csv
(file_format => GARDEN_PLANTS.VEGGIES.COMMASEP_DBLQUOT_ONEHEADROW);

copy into GARDEN_PLANTS.VEGGIES.VEGETABLE_DETAILS_PLANT_HEIGHT
from @UTIL_DB.PUBLIC.MY_INTERNAL_STAGE/veg_plant_height.csv
file_format = (format_name = GARDEN_PLANTS.VEGGIES.COMMASEP_DBLQUOT_ONEHEADROW);