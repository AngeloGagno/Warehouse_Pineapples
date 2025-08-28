with source as (
    select booking_id,channel_name,accommodation_name,zone,
    review_value from {{ref('stg_reviews')}}
),
accommodations as (
    select name, status from {{ref('int_active_accommodations')}}
),
bookings as (
    select booking_id,checkout_date from {{ref('stg_bookings')}}
),
merge_bookings_reviews as (
    select name,
    date_trunc('month', checkout_date)::date as begin_month,
    checkout_date::date,channel_name,zone, 
    replace(review_value::varchar,'.',',') as review_value from source s 
    join bookings b on s.booking_id = b.booking_id
    join accommodations a on s.accommodation_name = a.name
)
select name,begin_month::varchar,checkout_date::varchar,
channel_name,zone,review_value from merge_bookings_reviews
order by checkout_date

