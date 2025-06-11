with sources as (
SELECT * from {{source('defaultdb','bookings')}}),
renamed_columns as (
    select id_booking as booking_id,
    portal_reference,
    check_in_data as checkin_date,
    check_out_data as checkout_date,
    reservation_date,
    update_date,
    status as booking_status,
    accommodation_code as accommodation_id,
    sale_channel,
    total_payment as gross_payment,
    net_payment,
    extra_value as extra_payment,
    portal_comission as portal_payment,
    extra_descrition as extra_description from sources
),
change_data_type as (
    select booking_id,
    portal_reference,
    to_date(checkin_date,'YYYY-MM-DD') as checkin_date,
    to_date(checkout_date,'YYYY-MM-DD') as checkout_date,
    to_date(reservation_date,'YYYY-MM-DD') as reservation_date,
    to_date(update_date,'YYYY-MM-DD') as update_date,
    booking_status,
    accommodation_id,
    sale_channel,
    gross_payment,
    net_payment,
    extra_payment,
    portal_payment,
    REPLACE(extra_description, '''', '"')::jsonb AS extra_description
 from renamed_columns
)
select * from change_data_type
