with margin as (
    select * from {{ref('stg_accommodations_margin')}}
),
accommodation as (
    select accommodation_id,name,neighborhood from {{ref('stg_accommodations')}}
)

select accommodation_id ,
case
	when a."name" = 'J804' then 0
	when margin is null and a.neighborhood = 'São Paulo' then 15
	when margin is null then 25
	else margin
	end as margin from accommodation a left join margin am on a.name = am.accommodation_name