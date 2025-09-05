with sources as (
    select * from {{source('defaultdb','beyond_detailed_data')}}
),
convert_data as (
    select beyond_id,
    beyond_status, accommodation_id, price_cluster,
    base_price::float, minimum_price::float, last_booking_date, furthest_checkin_date
    from sources
)
select * from convert_data