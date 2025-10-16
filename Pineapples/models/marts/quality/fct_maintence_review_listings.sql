with reviews as (
    select * from {{ref('reviews_listings')}}
),
maintenance_reviews as (
    select checkout_month, accommodation_name,avg_review,
    count_reviews,avg_maintenance,count_maintenance,
    weighted_review,weighted_maintenance from reviews
)
select * from maintenance_reviews

