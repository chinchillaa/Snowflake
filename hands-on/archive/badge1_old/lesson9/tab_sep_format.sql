create file format GARDEN_PLANTS.VEGGIES.L9_CHALLENGE_FF
    type = 'CSV'
    field_delimiter = '\t'
    skip_header = 1
    ;

copy into GARDEN_PLANTS.VEGGIES.LU_SOIL_TYPE
from @UTIL_DB.PUBLIC.MY_INTERNAL_STAGE/LU_SOIL_TYPE.tsv
file_format =(format_name = GARDEN_PLANTS.VEGGIES.L9_CHALLENGE_FF);

select * from GARDEN_PLANTS.VEGGIES.LU_SOIL_TYPE;