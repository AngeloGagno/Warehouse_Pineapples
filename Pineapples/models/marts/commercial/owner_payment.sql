with accommodation as (
    select * from {{ ref('int_accommodations_code_margin')}} 
),
bookings as (
    select * from {{ref('int_confirmed_bookings')}}
),
owner_payment as (
    select date_trunc('month',b.checkin_date)::date as month, a.name as name,
    sum((b.net_payment - b.portal_payment) * ((100-a.margin)/100)) as owner_payment 
    from bookings b join accommodation a on b.accommodation_id = a.accommodation_id
    group by a.name, date_trunc('month',b.checkin_date)::date
)
select * from owner_payment