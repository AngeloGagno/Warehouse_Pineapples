with airbnb_reviews as (
    select * from {{ref('int_data_filter_airbnb_reviews')}}
)

select * from airbnb_reviews where rejection_alert = TRUE