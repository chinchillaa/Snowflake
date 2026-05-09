select 'POLYGON(('|| 
    min(min_eastwest)||' '||max(max_northsouth)||','|| 
    max(max_eastwest)||' '||max(max_northsouth)||','|| 
    max(max_eastwest)||' '||min(min_northsouth)||','|| 
    min(min_eastwest)||' '||min(min_northsouth)||'))' AS my_polygon
from trails_and_boundaries;