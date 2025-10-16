with occupancy as (
    select * from {{ref('dim_occupancy_month')}}
)
select 
month,
avg(occupancy_rate_pct),
accommodation_zone as zone
from occupancy
where month between '2025-01-01' and '2026-12-01'
group by zone, month