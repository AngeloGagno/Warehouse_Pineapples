with source as (
    select * from {{ref('dim_reviews_month')}}
),
round_num_col as (
    select checkin_date::varchar,
    accommodation_zone, 
    round(review_value/2,2) as review_value,
    round(cleaning_value/2,2) as cleaning_value,
    round(maintenance_value/2,2) as maintenance_value,
    round(customer_value/2,2) as customer_value
    from source
),
rename_nulls as (
    select checkin_date,accommodation_zone, review_value, cleaning_value, coalesce(maintenance_value::varchar, '') as maintenance_value,
    coalesce(customer_value::varchar,'') as customer_value from round_num_col order by checkin_date desc
),
replace_dot as (
    select checkin_date,accommodation_zone, review_value, cleaning_value,replace(maintenance_value,'.',',') as maintenance_value,
    replace(customer_value,'.',',') as customer_value from rename_nulls
),
remove_unnecessary_zones as (
    select * from replace_dot where accommodation_zone in ('Zona1','Zona2','Zona3','Zona4','CasaRio','Barra'))

select * from remove_unnecessary_zones