with accommodations as (
    select * from {{ref('stg_accommodations')}}
)
select accommodation_id, name as accommodation_name, zone as accommodation_zone from accommodations where status = 'ENABLED'
    order by accommodation_name
