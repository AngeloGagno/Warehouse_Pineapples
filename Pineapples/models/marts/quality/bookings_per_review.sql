with bookings as (
    select * from {{ref('stg_bookings')}}
),
reviews as (
    select * from {{ref('stg_reviews')}}
),

airbnb_bookings as (select count(*) bookings, date_trunc('month',checkin_date) as month from bookings where booking_status in ('CONFIRMED','PAID','UNPAID') and sale_channel = 'Airbnb' and checkin_date between '2025-01-01'
and current_date
group by month),

airbnb_reviews as (select count(*) as reviews, date_trunc('month',checkin_date) as month from reviews where channel_name = 'Airbnb' and checkin_date between '2025-01-01'
and current_date
group by month),

booking_bookings as (select count(*) bookings, date_trunc('month',checkin_date) as month from bookings where booking_status in ('CONFIRMED','PAID','UNPAID') and sale_channel = 'Booking.com' and checkin_date between '2025-01-01'
and current_date
group by month),

booking_reviews as (select count(*) as reviews, date_trunc('month',checkin_date) as month from reviews where channel_name = 'Booking' and checkin_date between '2025-01-01'
and current_date
group by month)

select b.month::date, b.bookings / r.reviews::numeric as bookings_per_review_airbnb,  
bb.bookings / br.reviews::numeric as bookings_per_review_booking from airbnb_bookings b 
join airbnb_reviews r on b.month = r.month 
join booking_bookings bb on b.month = bb.month
join booking_reviews br on b.month = br.month