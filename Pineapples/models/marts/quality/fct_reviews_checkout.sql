with source as (
    select booking_id,channel_name,accommodation_name,accommodation_zone,
    review_value from {{ref('int_reviews_accommodation')}}
),
bookings as (
    select booking_id,checkout_date from {{ref('stg_bookings')}}
),
merge_bookings_reviews as (
    select accommodation_name,
    date_trunc('month', checkout_date)::date as begin_month,
    checkout_date::date,channel_name,
    accommodation_zone, 
    replace(review_value::varchar,'.',',') as review_value from source s 
    join bookings b on s.booking_id = b.booking_id
)
select accommodation_name,
begin_month::varchar,
checkout_date::varchar,
channel_name,
accommodation_zone,
review_value from merge_bookings_reviews
order by checkout_date

