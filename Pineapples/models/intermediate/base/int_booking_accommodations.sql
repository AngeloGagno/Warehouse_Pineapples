with source_accommodation as (
    select * from {{ref('stg_accommodations')}}

),
source_bookings as (
    select * from {{ref('stg_bookings')}}
),
booking_accommodation as (
    select 
    b.booking_id,
    b.portal_reference,
    b.checkin_date,
    b.checkout_date,
    b.reservation_date,
    b.update_date,
    b.booking_status,
    b.accommodation_id,
    b.sale_channel,
    b.gross_payment,
    b.net_payment,
    b.extra_payment,
    b.portal_payment,
    a.name as accommodation_name,
    a.zone,
    a.status as accommodation_status,
    a.bedrooms,
    a.neighborhood,
    a.city
    from source_bookings b 
    join source_accommodation a on b.accommodation_id = a.accommodation_id
    )

select * from booking_accommodation