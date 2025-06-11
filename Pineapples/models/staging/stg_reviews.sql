with sources as (
    select * from {{source('defaultdb','reviews')}}
),
renamed_columns as (
    select id_booking as booking_id,
    review_date,
    checkin_date,
    channel_name,
    accommodation_name,
    zone,
    review_field,
    positive_review as positive_review_field,
    negative_review as negative_review_field,
    review_value,
    NULLIF(service_value, 'N/A')::numeric as service_value,
    NULLIF(cleaning_value, 'N/A')::numeric as cleaning_value,
    NULLIF(accommodation_value, 'N/A')::numeric as accommodation_value,
    NULLIF(location_value, 'N/A')::numeric as location_value,
    NULLIF(truthfulness_value, 'N/A')::numeric as truthfulness_value,
    NULLIF(checkin_value, 'N/A')::numeric as checkin_value,
    NULLIF(communication_value, 'N/A')::numeric as communication_value from sources)

select * from renamed_columns