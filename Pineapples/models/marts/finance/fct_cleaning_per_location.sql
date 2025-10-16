-- models/marts/core/fct_cleaning_cost_center_monthly.sql
with extras as (
  select * from {{ ref('stg_bookings_extras') }}
),
confirmed as (
  select * from {{ ref('dim_confirmed_bookings') }}
),
cost_map as (
  select * from {{ ref('dim_cost_center') }}
),
filtered as (
  select
    date_trunc('month', b.checkin_date)::date as month,
    cm.cost_center_name,
    e.net_price
  from confirmed b
  join extras e
    on e.booking_id = b.booking_id
  join cost_map cm
    on cm.accommodation_id = b.accommodation_id
  where e.reference = '10'
)
select
  cost_center_name,
  month,
  sum(net_price) as month_value
from filtered
group by 1,2
order by month desc, cost_center_name
