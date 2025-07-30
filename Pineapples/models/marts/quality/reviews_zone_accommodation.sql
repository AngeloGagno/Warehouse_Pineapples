with reviews as (
    select * from {{ref('stg_reviews')}}
),
accommodation_data as (
    select name, size, bedrooms, neighborhood from {{ref('int_active_accommodations')}}
),
create_columns as (
select date_trunc('month', checkin_date) as checkin_date,
accommodation_name,
coalesce(zone,'Casa Rio') as zone,review_value,cleaning_value,coalesce(service_value,communication_value) as customer_value,
coalesce(accommodation_value,cleaning_value) as maintenance_value
from reviews
),
accommodation_caract as (
    select * from create_columns c left join accommodation_data a on c.accommodation_name = a.name
),
group_col as (
    select checkin_date::date, zone, avg(review_value) as review_value, 
    name, bedrooms, neighborhood, size,   -- << aqui!
    avg(cleaning_value) as cleaning_value, 
    avg(maintenance_value) as maintenance_value, avg(customer_value) as customer_value 
    from accommodation_caract
    group by checkin_date, name, zone, neighborhood, bedrooms, size 
),

round_num_col as (
    select checkin_date::varchar, 
    name, zone,neighborhood, bedrooms,size, 
    round(review_value/2,2) as review_value,
    round(cleaning_value/2,2) as cleaning_value,
    round(maintenance_value/2,2) as maintenance_value,
    round(customer_value/2,2) as customer_value
    from group_col
),
rename_nulls as (
    select checkin_date,name, zone,neighborhood, bedrooms,size, review_value, cleaning_value, coalesce(maintenance_value::varchar, '') as maintenance_value,
    coalesce(customer_value::varchar,'') as customer_value from round_num_col order by checkin_date desc
),
replace_dot as (
    select checkin_date,name, zone,neighborhood, bedrooms,size, review_value, cleaning_value,replace(maintenance_value,'.',',') as maintenance_value,
    replace(customer_value,'.',',') as customer_value from rename_nulls
),
remove_unnecessary_zones as (
    select * from replace_dot where zone in ('Zona1','Zona2','Zona3','Zona4','Casa Rio','Barra'))

select * from remove_unnecessary_zones