with source as (
    select * from {{ref('stg_airbnb_reviews')}}
),
first_day_month as (
select scrap_data,accommodation_id,review_value from 
source where scrap_data = date_trunc('month', scrap_data)
),
current_day as (
select scrap_data as actual_data,accommodation_id,review_value as actual_value from source 
where scrap_data = current_date )

select actual_data, cd.accommodation_id, actual_value - review_value as variation from current_day cd
join first_day_month fd on cd.accommodation_id = fd.accommodation_id