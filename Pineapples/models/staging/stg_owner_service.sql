with sources as (

    select * from {{source('defaultdb','atendimento_proprietario')}}
),
renamed_columns as (
    select id_atendimento as id,
    data::date as registered_date,
    canal as channel,
    origem as origin, 
    imovel as accommodation,
    assunto as topic,
    detalhamento as details
    from sources
)
select * from renamed_columns