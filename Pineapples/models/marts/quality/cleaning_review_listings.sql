with reviews as (
    select * from {{ref('reviews_listings')}}
),
cleaning_reviews as (
    select checkout_month, accommodation_name,avg_review,
    count_reviews,avg_cleaning,count_cleaning,
    weighted_review,weighted_cleaning from reviews
)
select * from maintenance_reviews