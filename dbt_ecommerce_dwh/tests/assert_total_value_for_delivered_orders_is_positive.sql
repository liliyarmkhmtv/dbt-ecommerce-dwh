{{ config(severity='warn') }}

select order_id
from {{ ref('fct_orders') }}
where order_status = 'delivered' and total_payment_value < 0