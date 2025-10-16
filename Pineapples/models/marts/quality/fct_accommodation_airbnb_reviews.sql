with airbnb_reviews as (
    select * from {{ref('dim_airbnb_accommodations_today')}}
)

select * from airbnb_reviews