
with source_owner as (
    select * from {{ref('stg_owners')}}
),
source_accommodation as (
select * from {{ref('stg_accommodations')}}),

owner_accommodations as(
    select 
    o.name as owner_name,
    a.status as accommodation_status,
    a.zone as accommodation_zone,
    a.address as accommodation_address,
    o.identification as owner_identification, 
    a.name as listing_name, 
    o.email as owner_email
    from source_owner o
    join source_accommodation a on o.owner_id = a.owner_id
)
select * from owner_accommodations