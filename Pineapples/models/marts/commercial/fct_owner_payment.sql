with accommodation as (
    select * from {{ ref('int_accommodations_code_margin')}} 
),
bookings as (
    select net_payment,checkin_date,portal_payment,accommodation_id from {{ref('dim_confirmed_bookings')}}
),
owner_payment as (
    select date_trunc('month',b.checkin_date)::date as month,
    a.accommodation_name,
    sum((b.net_payment - b.portal_payment) * ((100-a.margin)/100)) as owner_payment 
    from bookings b 
    join accommodation a on b.accommodation_id = a.accommodation_id
    group by 1,2
)
select * from owner_payment