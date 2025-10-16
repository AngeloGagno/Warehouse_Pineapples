
with owner_accommodations as (
    select * from {{ref('dim_accommodations_enabled_owners')}}
)
select     
    owner_name,
    owner_identification, 
    listing_name, 
    owner_email
    from owner_accommodations a 
ORDER BY owner_name
