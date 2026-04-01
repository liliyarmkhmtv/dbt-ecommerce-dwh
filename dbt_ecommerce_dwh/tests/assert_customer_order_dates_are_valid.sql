{{ config(severity='warn') }}

select customer_unique_id
from {{ ref('dim_customers') }}
where first_order_date > last_order_date