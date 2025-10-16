with airbnb_reviews as (
    select * from {{ref('stg_airbnb_reviews')}}
),
todays_reviews as (

    select * from airbnb_reviews where scrap_data = CURRENT_DATE
    order by accommodation_name
)
select * from todays_reviews    