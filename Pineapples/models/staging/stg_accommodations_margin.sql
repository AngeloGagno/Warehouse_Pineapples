with sources as (
    SELECT * FROM {{source('defaultdb','accommodations_margin')}}
),
renamed_columns as (
SELECT accommodation as accommodation_name, margin 
from sources
)
select * from renamed_columns