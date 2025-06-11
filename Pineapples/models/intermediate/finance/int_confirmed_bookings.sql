with sources as (SELECT * from {{ref('stg_bookings')}}),
confirmed_bookings as (
    select * from sources where booking_status in ('CONFIRMED','PAID','UNPAID')
)
select * from confirmed_bookings