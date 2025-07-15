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
        accommodation_name,
        review_value,
        coalesce(accommodation_value,cleaning_value) as maintenance_value
    from {{ref('stg_reviews')}}
),
aggregated_reviews as (
    select
        checkin_month,
        accommodation_name,
        avg(review_value) as avg_review,
        count(review_value) as count_reviews,
        avg(maintenance_value) as avg_maintenance,
        count(maintenance_value) as count_maintenance
    from filtered_data
    group by checkin_month, accommodation_name
),
combined as (
    select 
        c.checkin_month,
        c.accommodation_name,
        ar.avg_review,
        ar.count_reviews,
        ar.avg_maintenance,
        ar.count_maintenance
    from combinations c
    left join aggregated_reviews ar
    on c.checkin_month = ar.checkin_month
    and c.accommodation_name = ar.accommodation_name
),
final_with_weighted as (
    select *,
        sum(coalesce(avg_review * count_reviews, 0)) over w as total_review_sum,
        sum(coalesce(count_reviews, 0)) over w as total_review_count,
        sum(coalesce(avg_maintenance * count_maintenance, 0)) over w as total_maintenance_sum,
        sum(coalesce(count_maintenance, 0)) over w as total_maintenance_count
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

    -- Médias mensais
    avg_review,
    count_reviews,
    avg_maintenance,
    count_maintenance,

    -- Médias ponderadas acumuladas
    case when total_review_count > 0 then round(total_review_sum / total_review_count, 2) else null end as weighted_review,
    case when total_maintenance_count > 0 then round(total_maintenance_sum / total_maintenance_count, 2) else null end as weighted_maintenance

from final_with_weighted
order by accommodation_name, checkin_month
),
data_cleaned as (
    select checkin_month::varchar,
    accommodation_name,
    coalesce(avg_review::varchar,'') as avg_review,
    coalesce(count_reviews::varchar,'') as count_reviews,
    coalesce(avg_maintenance::varchar,'') as avg_maintenance,
    coalesce(count_maintenance::varchar,'') as count_maintenance,    
    coalesce(weighted_review::varchar,'') as weighted_review,
    coalesce(weighted_maintenance::varchar,'') as weighted_maintenance
    from final_table
),
change_dot_comma as (
    select checkin_month,
    accommodation_name,
    replace(avg_review,'.',',') as avg_review,
    replace(count_reviews,'.',',') as count_reviews,
    replace(avg_maintenance,'.',',') as avg_maintenance,
    replace(count_maintenance,'.',',') as count_maintenance,
    replace(weighted_review,'.',',') as weighted_review,
    replace(weighted_maintenance,'.',',') as weighted_maintenance
    from data_cleaned
)
select * from change_dot_comma