with accommodation as (
    select * from {{ref('stg_accommodations')}}
),
beyond_detailed_data as (
    select * from {{ref('stg_beyond_detailed_data')}}
),
beyond_booking_update as (
    select * from {{ref('stg_beyond_booking_update')}}
),
filtered_data as (SELECT 
    sa.name,
    bd.price_cluster,
    bd.base_price,
    bd.minimum_price,
    bd.last_booking_date,
    sbbu.booked_30_days,
    sbbu.booked_60_days,
    sbbu.booked_90_days
FROM beyond_detailed_data bd
JOIN accommodation sa ON sa.accommodation_id = bd.accommodation_id
JOIN (
    SELECT DISTINCT ON (beyond_id) *
    FROM beyond_booking_update
    ORDER BY beyond_id, scrap_date DESC
) sbbu ON bd.beyond_id = sbbu.beyond_id
WHERE bd.beyond_status IS TRUE
ORDER BY sa.name)
select * from filtered_data