WITH bookings as (
    select checkin_date,
            checkout_date,
            accommodation_id,
            booking_id from {{ref('dim_confirmed_bookings')}}
),
reviews as (
    select cleaning_value,booking_id from {{ref('int_reviews_accommodation')}}
),
checkin_ordered as (
         SELECT b.checkin_date,
            b.checkout_date,
            b.accommodation_id,
            b.booking_id,
            cleaning_value
           FROM bookings b
             LEFT JOIN reviews r ON b.booking_id::varchar = r.booking_id::varchar
          WHERE b.checkin_date::varchar >= '2025-01-01'::varchar
          ORDER BY b.accommodation_id, b.checkin_date DESC
        ), last_booking as (
 SELECT checkin_date,
    checkout_date,
    accommodation_id,
    booking_id,
    lead(booking_id) OVER (PARTITION BY accommodation_id) AS last_booking_id,
    lead(checkout_date) OVER (PARTITION BY accommodation_id) AS last_checkout,
    cleaning_value
   FROM checkin_ordered),
null_filter as (
    select * from last_booking where cleaning_value >= 0 and last_booking_id notnull
)
select last_booking_id,REPLACE(cleaning_value::varchar, '.', ',') AS cleaning_value from null_filter