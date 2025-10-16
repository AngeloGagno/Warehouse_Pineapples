-- models/intermediate/int_stays_by_day.sql
with bookings as (
  select * from {{ ref('int_booking_accommodations') }}
),
confirmed_bookings as (
  select zone,checkin_date,checkout_date,accommodation_id from bookings
  where booking_status in ('PAID','CONFIRMED','UNPAID')
)
select
  cb.accommodation_id,
  gs::date as day
from confirmed_bookings cb
cross join lateral generate_series(
  cb.checkin_date::date,
  (cb.checkout_date::date - interval '1 day'),
  interval '1 day'
) as gs
where cb.checkin_date is not null
  and cb.checkout_date is not null
