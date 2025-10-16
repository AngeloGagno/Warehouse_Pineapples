with source as (
   select * from {{source('defaultdb','accommodation')}}),
   renamed_columns as (select 
   id_acc as accommodation_id,
   status, 
   id_proprietario as owner_id,
   nome_acomodacao as name,
   case 
   when nome_acomodacao like 'CR-%' then 'CasaRio'
   when nome_acomodacao like 'HL-%' then 'HostelLeblon'
   else zona 
   end as zone,
   tamanho::numeric as size,
   qtde_quartos as bedrooms,
   qtde_banheiros as bathrooms,
   regexp_replace(cama, '[}{'']', '', 'g') as bed,
   cod_pais as country,
   cidade as city,
   endereco as address,
   bairro as neighborhood,
   latitude,
   longitude from source )

   select * from renamed_columns

