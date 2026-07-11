create or replace table vegetable_details_soil_type
( plant_name varchar(25)
 ,soil_type number(1,0)
);

create file format garden_plants.veggies.PIPECOLSEP_ONEHEADROW
    type = 'CSV'
    field_delimiter = '|'
    skip_header = 1
    ;

copy into vegetable_details_soil_type
from @util_db.public.my_internal_stage
files = ( 'VEG_NAME_TO_SOIL_TYPE_PIPE.txt')
file_format = (format_name = GARDEN_PLANTS.VEGGIES.PIPECOLSEP_ONEHEADROW);