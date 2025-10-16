with source as (
    select * from {{ ref('dim_confirmed_bookings') }}
),

filtered_table as (
    select
        reservation_date::date as reservation_date,
        date_trunc('month', checkin_date)::date as checkin_month,
        (checkout_date - checkin_date) as nights,
        gross_payment
    from source
),

-- janela: do mês da reservation_date até +3 meses
monthly_window as (
    select
        reservation_date,
        checkin_month,
        nights,
        gross_payment
    from filtered_table
    where checkin_month between date_trunc('month', reservation_date)
                           and (date_trunc('month', reservation_date)::date + interval '3 months')
),

agg as (
    select
        reservation_date,
        checkin_month,
        count(*)                  as bookings,
        sum(gross_payment)        as gross_payment,
        avg(gross_payment)        as average_booking
    from monthly_window
    group by 1,2
)

select * from agg
