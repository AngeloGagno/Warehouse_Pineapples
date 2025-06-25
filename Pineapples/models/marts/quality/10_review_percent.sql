with source as (
    SELECT * from {{ref('stg_reviews')}}
),
reviews_by_month_zone as (
select  date_trunc('month', review_date) as month,avg(review_value)/2 as review,
avg(cleaning_value)/2 as cleaning,
avg(communication_value)/2 as communication,
coalesce(zone,'Casa Rio') as zone 
from source
group by date_trunc('month', review_date),zone
)
select * from reviews_by_month_zone order by month