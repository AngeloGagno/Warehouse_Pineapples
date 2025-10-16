with bookings_accommodations as (
    select * from {{ref('int_booking_accommodations')}}
)
select * from bookings_accommodations where booking_status in ('PAID','UNPAID','CONFIRMED')