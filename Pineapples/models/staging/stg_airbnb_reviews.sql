with sources as (
SELECT * from {{sources('defaultdb','airbnb_reviews')}}
),
renamed_columns as (
    select * from sources
),
replaced_columns as ( 
    select scrap_id, 
    scrap_data,
    accommodation_id,
    accommodation_name,
    replace(airbnb_account_id,'.0','') as airbnb_account_id,
    accommodation_link,
    channel_name,
    local_status,
    publishiment_status,
    alert,
    sync_alert,
    rejection_alert,
    warning_alert,
    review_count,
    cleanliness_value,
    location_value,
    truthfulness_value,
    checkin_value,
    communication_value
)
select * from replaced_columns