with sources as (
    select * from {{ref('stg_reviews')}}
),
reviews_10_count as (
select date_trunc('month',checkin_date)::date as month, 
CASE
    when review_value = 10 then 1
    else 0
    END as review_10_count,
CASE
    when checkin_value = 10 then 1
    else 0
    END as checkin_10_count,
CASE 
    when checkin_value IS NOT NULL then 1
    else 0
    END as null_checkin_count,
CASE 
    when communication_value = 10 then 1
    else 0
    END as communication_10_count,
CASE 
    when communication_value IS NOT NULL then 1
    else 0
    END as null_communication_count
from sources
),
percent_10_reviews as (
    select month,
    count(*) as reviews,
    sum(review_10_count)::float / count(*) as reviews_10_percent,
    sum(checkin_10_count)::float / NULLIF(sum(null_checkin_count), 0) as checkin_10_percent,
    sum(communication_10_count)::float /  NULLIF(sum(null_communication_count), 0)  as communication_10_percent
from reviews_10_count
group by month),
int_10_reviews as (
    select month,
    reviews,
    round((reviews_10_percent * 100)::numeric,2) as reviews_10_percent,
    round((checkin_10_percent * 100)::numeric,2)  as checkin_10_percent,
    round((communication_10_percent * 100)::numeric,2) as communication_10_percent
from percent_10_reviews order by month desc)

select * from int_10_reviews

