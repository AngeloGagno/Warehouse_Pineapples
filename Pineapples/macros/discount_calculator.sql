-- macros/calc_ajuste.sql
{% macro calc_ajuste(col_booked, col_review, hi_threshold=70, low_threshold=50, review_cutoff=8.8) %}
CASE
  WHEN {{ col_booked }} >= {{ hi_threshold }} THEN 0.0
  WHEN {{ col_booked }} <= {{ low_threshold }} THEN
    CASE WHEN {{ col_review }} >= {{ review_cutoff }} THEN -0.3 ELSE -0.35 END
  ELSE
    CASE WHEN {{ col_review }} >= {{ review_cutoff }} THEN -0.2 ELSE -0.25 END
END
{% endmacro %}
