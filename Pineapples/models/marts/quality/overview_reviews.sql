with source as (
    select * from {{ref('stg_reviews')}}
),
create_columns as (
select date_trunc('month', checkin_date) as checkin_date,
coalesce(zone,'Casa Rio') as zone,review_value,cleaning_value,accommodation_value,checkin_value
from source
),
group_col as (
    select checkin_date, zone, avg(review_value) as review_value, 
    avg(cleaning_value) as cleaning_value, 
    avg(accommodation_value) as accommodation_value, avg(checkin_value) as checkin_value 
    from create_columns
    group by checkin_date, zone
),
round_num_col as (
    select checkin_date, zone, round(review_value,2) as review_value,
    round(cleaning_value,2) as cleaning_value,
    round(accommodation_value,2) as accommodation_value,
    round(checkin_value,2) as checkin_value
    from group_col
)
select * from round_num_col order by checkin_date desc