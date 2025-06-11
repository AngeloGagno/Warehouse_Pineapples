with sources as (
    SELECT * FROM {{source('defaultdb','owner')}}),
    renamed_columns as (
        select id_proprietario as owner_id,
        nome as name,
        documento as identification,
        telefone as phone,
        email
    from sources)
select * from renamed_columns