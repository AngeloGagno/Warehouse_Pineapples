with src as (
  select * from {{ ref('stg_bookings') }}
)
select
  booking_id,
  checkin_date::date        as checkin_date,
  checkout_data::data       as checkout_date,
  reservation_date::date        as booking_date
  case when booking_status in ('CONFIRMED','PAID','UNPAID') then 1 else 0 end as is_effective_booking,
  case lower(sale_channel)
    when 'booking.com' then 'Booking'
    else initcap(sale_channel)
  end as channel_norm
from src
where checkin_date is not null
