with monthly as (
    select * from {{ ref('int_bookings_monthly_window') }}
),
daily as (
    select * from {{ ref('int_bookings_daily_counts') }}
)

select
    m.reservation_date,
    d.bookings_in_day,
    m.checkin_month,
    m.bookings,
    m.gross_payment,
    m.average_booking
from monthly m
join daily d
  on d.reservation_date = m.reservation_date
order by m.reservation_date desc, m.checkin_month desc
