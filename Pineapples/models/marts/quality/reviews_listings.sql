with months as (
    select generate_series('2024-01-01'::date, date_trunc('month', current_date), interval '1 month') as checkin_month
),
active_listings as (
    select name as accommodation_name
    from {{ref('stg_accommodations')}}
    where status = 'ENABLED'
),
combinations as (
    select 
        m.checkin_month,
        a.accommodation_name
    from months m
    cross join active_listings a
),
filtered_data as (
    select 
        date_trunc('month', checkin_date)::date as checkin_month,
        channel_name,
        accommodation_name,
        review_value,
        accommodation_value,
        cleaning_value,
        coalesce(accommodation_value, cleaning_value) as maintenance_value,
        coalesce(service_value,communication_value) as customer_care_value
    from {{ref('stg_reviews')}}
),
aggregated_reviews as (
    select
        checkin_month,
        accommodation_name,
        channel_name,
        round(avg(review_value),2) as avg_review,
        count(review_value) as count_reviews,
        round(avg(cleaning_value),2) as avg_cleaning,
        count(cleaning_value) as count_cleaning,
        round(avg(accommodation_value),2) as avg_accommodation,
        count(accommodation_value) as count_accommodation,
        round(avg(maintenance_value),2) as avg_maintenance,
        count(maintenance_value) as count_maintenance,
        round(avg(customer_care_value),2) as avg_customer_care,
        count(customer_care_value) as count_customer_care
    from filtered_data
    group by checkin_month, accommodation_name,channel_name
),
combined as (
    select 
        c.checkin_month,
        c.accommodation_name,
        ar.channel_name,
        ar.avg_review,
        ar.count_reviews,
        ar.avg_cleaning,
        ar.count_cleaning,
        ar.avg_accommodation,
        ar.count_accommodation,
        ar.avg_maintenance,
        ar.count_maintenance,
        ar.avg_customer_care,
        ar.count_customer_care
    from combinations c
    left join aggregated_reviews ar
    on c.checkin_month = ar.checkin_month
    and c.accommodation_name = ar.accommodation_name
),
final_with_weighted as (
    select *,

        sum(coalesce(avg_review * count_reviews, 0)) over w as total_review_sum,
        sum(coalesce(count_reviews, 0)) over w as total_review_count,

        sum(coalesce(avg_cleaning * count_cleaning, 0)) over w as total_cleaning_sum,
        sum(coalesce(count_cleaning, 0)) over w as total_cleaning_count,

        sum(coalesce(avg_accommodation * count_accommodation, 0)) over w as total_accommodation_sum,
        sum(coalesce(count_accommodation, 0)) over w as total_accommodation_count,

        sum(coalesce(avg_maintenance * count_maintenance, 0)) over w as total_maintenance_sum,
        sum(coalesce(count_maintenance, 0)) over w as total_maintenance_count,

        sum(coalesce(avg_customer_care * count_customer_care, 0)) over w as total_customer_care_sum,
        sum(coalesce(count_customer_care,0)) over w as total_customer_care_count

    from combined
    window w as (
        partition by accommodation_name
        order by checkin_month
        rows between unbounded preceding and current row
    )
), final_table as (
    select 
        checkin_month::date,
        accommodation_name,
        channel_name,

        -- Médias mensais
        avg_review,
        count_reviews,
        avg_cleaning,
        count_cleaning,
        avg_accommodation,
        count_accommodation,
        avg_maintenance,
        count_maintenance,
        avg_customer_care,
        count_customer_care,

        -- Médias ponderadas acumuladas
        case when total_review_count > 0 then round(total_review_sum / total_review_count, 2) else null end as weighted_review,
        case when total_cleaning_count > 0 then round(total_cleaning_sum / total_cleaning_count, 2) else null end as weighted_cleaning,
        case when total_accommodation_count > 0 then round(total_accommodation_sum / total_accommodation_count, 2) else null end as weighted_accommodation,
        case when total_maintenance_count > 0 then round(total_maintenance_sum / total_maintenance_count, 2) else null end as weighted_maintenance,
        case when total_customer_care_count > 0 then round(total_customer_care_sum / total_customer_care_count, 2) else null end as weighted_customer_care

    from final_with_weighted
    order by accommodation_name, checkin_month
),
data_cleaned as (
    select 
        checkin_month::varchar,
        accommodation_name,
        coalesce(channel_name,'') as channel_name,

        coalesce(avg_review::varchar,'') as avg_review,
        coalesce(count_reviews::varchar,'') as count_reviews,
        coalesce(avg_cleaning::varchar,'') as avg_cleaning,
        coalesce(count_cleaning::varchar,'') as count_cleaning,
        coalesce(avg_accommodation::varchar,'') as avg_accommodation,
        coalesce(count_accommodation::varchar,'') as count_accommodation,
        coalesce(avg_maintenance::varchar,'') as avg_maintenance,
        coalesce(count_maintenance::varchar,'') as count_maintenance,
        coalesce(avg_customer_care::varchar,'') as avg_customer_care,
        coalesce(count_customer_care::varchar,'') as count_customer_care,

        coalesce(weighted_review::varchar,'') as weighted_review,
        coalesce(weighted_cleaning::varchar,'') as weighted_cleaning,
        coalesce(weighted_accommodation::varchar,'') as weighted_accommodation,
        coalesce(weighted_maintenance::varchar,'') as weighted_maintenance,
        coalesce(weighted_customer_care::varchar,'') as weighted_customer_care
    from final_table
)
,
change_dot_comma as (
    select 
        checkin_month,
        accommodation_name,
        channel_name,

        replace(avg_review,'.',',') as avg_review,
        replace(count_reviews,'.',',') as count_reviews,
        replace(avg_cleaning,'.',',') as avg_cleaning,
        replace(count_cleaning,'.',',') as count_cleaning,
        replace(avg_maintenance,'.',',') as avg_maintenance,
        replace(count_maintenance,'.',',') as count_maintenance,
        replace(avg_customer_care,'.',',') as avg_customer_care,
        replace(count_customer_care,'.',',') as count_customer_care,

        replace(weighted_review,'.',',') as weighted_review,
        replace(weighted_cleaning,'.',',') as weighted_cleaning,
        replace(weighted_maintenance,'.',',') as weighted_maintenance,
        replace(weighted_customer_care,'.',',') as weighted_customer_care

    from data_cleaned
    where channel_name in ('Airbnb','Booking')
)

select * from change_dot_comma
