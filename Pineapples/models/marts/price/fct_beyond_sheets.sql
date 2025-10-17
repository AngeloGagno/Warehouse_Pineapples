with beyond_data as (
    select * from {{ref('int_beyond_data')}}
),
remove_null_change_data as (
    select    
    name,
    replace(coalesce(avg_review_value::varchar,''),'.',',')::varchar as avg_review_value,
    price_cluster,
    base_price,
    minimum_price,
    booked_30_days,
    booked_60_days,
    booked_90_days,
    coalesce(scrap_date::varchar,'')::varchar as scrap_date
    
    from beyond_data

)
SELECT * 
FROM remove_null_change_data
