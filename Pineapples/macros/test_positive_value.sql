{% test positive_value(model,column_name) %}

with validator as (
    select {{column_name}}::float as column_name
    from model
 
),
validate_positive_value as (
    select column_name from validator
    where column_name >= 0
)
select * from validate_positive_value

{% endtest %}