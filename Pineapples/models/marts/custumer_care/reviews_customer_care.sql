with source as (
    select * from {{ref('stg_reviews')}}
),
reviews_competencia as (
select (case 
            when date_part('day', checkin_date) >= 21 
                then date_trunc('month', checkin_date)::date + interval '21 days'
            else date_trunc('month', checkin_date)::date - interval '1 month' + interval '21 days'
        end) as competencia,coalesce(service_value,communication_value) as review_value, communication_value, checkin_value from source
),
reviews_grouped as (
    select competencia, avg(review_value) as review,avg(communication_value) as communication,avg(checkin_value) as checkin from reviews_competencia
group by competencia
),
refactor_columns as (
    select date_trunc('month',competencia)::date as competencia, round(review,2) as review , round(communication,2) as communication, 
    round(checkin,2) as checkin from reviews_grouped order by competencia
),
last_month as (
    select competencia::varchar, replace(round(((review / lag(review) over(order by competencia)) -1) * 100,2)::varchar,'.',',') as variacao,
    review as avaliacao_geral, 
    replace(communication::varchar,'.',',') as  comunicacao, 
    replace(checkin::varchar,'.',',') as checkin
    from refactor_columns order by competencia desc
),
remove_nulls as (
    select competencia,coalesce(variacao,'') as variacao, avaliacao_geral, coalesce(comunicacao,'') as comunicacao, coalesce(checkin,'') as checkin 
    from last_month
)
select * from remove_nulls