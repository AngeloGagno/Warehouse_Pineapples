with stg_accommodations as (
  select
    accommodation_id,
    name as accommodation_name,
    zone as accommodation_zone,
    size as accommodation_size,
    bedrooms as accommodation_bedrooms,
    city as accommodation_city,
    neighborhood as accommodation_neighborhood
  from {{ref('stg_accommodations') }}
),
stg_reviews as (
  select
    booking_id,
    accommodation_name,
    cast(review_date as date)      as review_date,
    cast(checkin_date as date)     as checkin_date,
    channel_name,
    cast(review_value as decimal(5,2))        as review_value,
    cast(service_value as decimal(5,2))       as service_value,
    cast(cleaning_value as decimal(5,2))      as cleaning_value,
    cast(accommodation_value as decimal(5,2)) as accommodation_value,
    cast(location_value as decimal(5,2))      as location_value,
    cast(truthfulness_value as decimal(5,2))  as truthfulness_value,
    cast(checkin_value as decimal(5,2))       as checkin_value,
    cast(communication_value as decimal(5,2)) as communication_value
  from {{ ref('stg_reviews') }}
),
accommodations_reviews as (
    select 
    a.accommodation_name,
    a.accommodation_zone,
    a.accommodation_size,
    a.accommodation_bedrooms,
    a.accommodation_city,
    a.accommodation_neighborhood,
    r.booking_id,
    r.review_date,
    r.checkin_date,
    r.channel_name,
    r.review_value,
    r.service_value,
    r.cleaning_value,
    r.accommodation_value,
    r.location_value,
    r.truthfulness_value,
    r.checkin_value,
    r.communication_value
    from stg_accommodations a 
    join stg_reviews r on a.accommodation_name = r.accommodation_name
)
select * from accommodations_reviews