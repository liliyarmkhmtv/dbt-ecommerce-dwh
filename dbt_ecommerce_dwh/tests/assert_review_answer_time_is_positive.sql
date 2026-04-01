{{ config(severity='warn') }}

select review_id
from {{ ref('fct_order_reviews') }}
where answer_time_hours < 0