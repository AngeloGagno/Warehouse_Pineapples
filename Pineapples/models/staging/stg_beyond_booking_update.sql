with sources as (
    select * from {{source('defaultdb','beyond_booking_update')}}
),
convert_data as (
    select beyond_id,
    scrap_date, booked_7_days, booked_14_days, booked_30_days,
    booked_60_days,booked_90_days
    from sources
)
select * from convert_data