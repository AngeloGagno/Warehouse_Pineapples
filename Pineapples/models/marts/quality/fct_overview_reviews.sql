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
ordered_by_month as (
    select checkin_date::varchar,
    accommodation_zone, 
    round(avg(review_value),2) as review_value,
    round(avg(cleaning_value),2) as cleaning_value,
    round(avg(maintenance_value),2) as maintenance_value,
    round(avg(customer_value),2) as customer_value
    from round_num_col
    group by checkin_date,accommodation_zone
)
rename_nulls as (
    select checkin_date,accommodation_zone, 
    coalesce(review_value::varchar, '') as review_value, 
    coalesce(cleaning_value::varchar, '') as cleaning_value, 
    coalesce(maintenance_value::varchar, '') as maintenance_value,
    coalesce(customer_value::varchar,'') as customer_value from ordered_by_month order by checkin_date desc
),
replace_dot as (
    select checkin_date,accommodation_zone, 
    replace(review_value,'.',',') as review_value, 
    replace(cleaning_value,'.',',') as cleaning_value,
    replace(maintenance_value,'.',',') as maintenance_value,
    replace(customer_value,'.',',') as customer_value from rename_nulls
),
remove_unnecessary_zones as (
    select * from replace_dot where accommodation_zone in ('Zona1','Zona2','Zona3','Zona4','CasaRio','Barra'))

select * from remove_unnecessary_zones