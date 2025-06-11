with source as (
select * from {{ref('stg_accommodations')}}),
active_listings as(
    select * from source where status = 'ENABLED'
)
select * from active_listings