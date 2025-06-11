with owner as (
    select * from {{ref('stg_owners')}}
),
accommodation as (
    select name, owner_id from {{ref('int_active_accommodations')}}
)
select o.name, o.identification, a.name as listing_name, o.email from accommodation a 
left join owner o on o.owner_id = a.owner_id 
ORDER BY o.name ASC