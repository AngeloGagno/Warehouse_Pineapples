with confirmed_bookings as (
    select * 
    from {{ref('int_confirmed_bookings')}}
    where checkout_date >= '2024-07-01' 
      and checkout_date <= current_date
),
accommodation_zone as (
    select accommodation_id, zone, city 
    from {{ref('stg_accommodations')}}
),
bookings_per_zone as (
    select 
        case 
            when a.city = 'São Paulo' then 'Sao Paulo'
            else a.zone
        end as zone,
        b.checkout_date,
        a.city
    from confirmed_bookings b 
    join accommodation_zone a 
      on b.accommodation_id::varchar = a.accommodation_id::varchar
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
