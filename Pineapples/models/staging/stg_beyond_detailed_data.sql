with sources as (
    select * from {{source('defaultdb','beyond_detailed_data')}}
),
convert_data as (
    select beyond_id,
    beyond_status, accommodation_id, price_cluster,
    base_price::float, minimum_price::float
    from sources
)
select * from convert_data