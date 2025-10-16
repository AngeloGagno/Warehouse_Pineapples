with reviews_accommodations as (
    select * from {{ref('int_reviews_accommodation')}}

),
reviews_consolidaded as (
select date_trunc('month', checkin_date) as checkin_date,
accommodation_name,
accommodation_zone,
review_value,
cleaning_value,
coalesce(service_value,communication_value) as customer_value,
coalesce(accommodation_value,cleaning_value) as maintenance_value
from reviews_accommodations
)
select * from reviews_consolidaded