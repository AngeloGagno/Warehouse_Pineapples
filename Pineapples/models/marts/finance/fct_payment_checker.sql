with source as (
    select * from {{ref('dim_confirmed_bookings')}}
),
filtered_portal_reference as (
select booking_id, 
(gross_payment - portal_payment) as payment ,
split_part(portal_reference,'-',2)  as portal_reference,  
to_char(checkin_date, 'DD-MM-YYYY') AS checkin_date
from source where 
sale_channel in ('Booking.com', 'Airbnb') and 
checkin_date between CURRENT_DATE - INTERVAL '365 days' and CURRENT_DATE )

select * from filtered_portal_reference
