with accommodation_bookings as (
    select * from {{ref('dim_confirmed_bookings')}}
),

bookings_per_zone as (
    select 
        case 
            when city = 'São Paulo' then 'Sao Paulo'
            else zone
        end as zone,
        checkout_date,
        city

    from accommodation_bookings
),
checkouts_day as (
    select 
        TO_CHAR(date_trunc('month', checkout_date), 'YYYY-MM-DD')::varchar as month_begin, 
        checkout_date::varchar, 
        coalesce(zone::varchar,'Casa Rio') as zone,  
        count(*) as checkouts_zone,
        sum(count(*)) OVER (PARTITION BY checkout_date) as checkouts_day   
    from bookings_per_zone
    group by checkout_date, coalesce(zone::varchar,'Casa Rio')
)
select * from checkouts_day
