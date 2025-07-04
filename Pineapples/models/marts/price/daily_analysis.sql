with source as (
    select * from {{ref('int_confirmed_bookings')}}
),
filtered_table as (
select reservation_date, date_trunc('month', checkin_date)::date as month , 
(checkout_date - checkin_date) as nights, 
gross_payment 
from source
),
ordered_month as (
select reservation_date,
month,
nights,gross_payment from filtered_table
), 
grouped_by_data as (
select reservation_date, 
month as checkin_month, 
count(*) as bookings, 
sum(gross_payment) as gross_payment, 
avg(gross_payment) as average_booking
from ordered_month
where 
month between date_trunc('month', current_date) and date_trunc('month', current_date)::date + INTERVAL '3 months'
group by reservation_date, month 
order by reservation_date desc,month desc
)
select * from grouped_by_data