with source as (
    select * from {{ref('stg_reviews')}}
),
reviews_competencia as (
select (case 
            when date_part('day', checkin_date) >= 21 
                then date_trunc('month', checkin_date)::date + interval '21 days'
            else date_trunc('month', checkin_date)::date - interval '1 month' + interval '21 days'
        end) as competencia,review_value, communication_value, checkin_value from source
),
reviews_grouped as (
    select competencia, avg(review_value) as review,avg(communication_value) as communication,avg(checkin_value) as checkin from reviews_competencia
group by competencia
),
refactor_columns as (
    select date_trunc('month',competencia) as competencia, round(review,2) as review , round(communication,2) as communication, 
    round(checkin,2) as checkin from reviews_grouped order by competencia
),
last_month as (
    select competencia, round(((review / lag(review) over(order by competencia)) -1) * 100,2) as variacao,
    review as avaliacao_geral, communication as comunicacao, checkin
    from refactor_columns order by competencia desc
)
select * from last_month