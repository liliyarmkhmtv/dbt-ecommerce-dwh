{{ config(severity='warn') }}

select order_id
from {{ ref('fct_orders') }}
where order_status = 'delivered'
  and order_delivered_customer_at is null