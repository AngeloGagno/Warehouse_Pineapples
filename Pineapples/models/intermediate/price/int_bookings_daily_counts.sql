with src as (
    select * from {{ ref('dim_confirmed_bookings') }}
),

daily as (
    select
        date_trunc('day', reservation_date)::date as reservation_date,
        count(*) as bookings_in_day
    from src
    group by 1
)

select * from daily
