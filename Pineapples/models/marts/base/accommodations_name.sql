with accommodations as (
    select * from {{ref('stg_accommodations')}}
),
accommodations_name as (
    select name from accommodations where status = 'ENABLED'
)
select * from accommodations_name order by name