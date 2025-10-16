with source as (
    select * from {{ref('int_owner_accommodations')}}
)
select * from source where accommodation_status = 'ENABLED'