with sources as (
    select * from {{source('defaultdb','reviews')}}
),
renamed_columns as (
    select id_booking as booking_id,
    review_date,
    checkin_date,
    review_origin as channel_name,
    accommodation_name,
    zone,
    review_field,
    positive_review as positive_review_field,
    negative_review as negative_review_field,
    review_value::numeric,
    CASE WHEN service_value IN ('N/A', '-') THEN NULL ELSE service_value::numeric END AS service_value,
    CASE WHEN cleaning_value IN ('N/A', '-') THEN NULL ELSE cleaning_value::numeric END AS cleaning_value,
    CASE WHEN accommodation_value IN ('N/A', '-') THEN NULL ELSE accommodation_value::numeric END AS accommodation_value,
    CASE WHEN location_value IN ('N/A', '-') THEN NULL ELSE location_value::numeric END AS location_value,
    CASE WHEN truthfulness_value IN ('N/A', '-') THEN NULL ELSE truthfulness_value::numeric END AS truthfulness_value,
    CASE WHEN checkin_value IN ('N/A', '-') THEN NULL ELSE checkin_value::numeric END AS checkin_value,
    CASE WHEN communication_value IN ('N/A', '-') THEN NULL ELSE communication_value::numeric END AS communication_value
from sources)

select * from renamed_columns