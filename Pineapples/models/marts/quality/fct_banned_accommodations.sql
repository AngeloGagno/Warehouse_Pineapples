with airbnb_reviews as (
    select * from {{ref('dim_airbnb_accommodations_today')}}
)

select * from airbnb_reviews where rejection_alert = TRUE
order by accommodation_name