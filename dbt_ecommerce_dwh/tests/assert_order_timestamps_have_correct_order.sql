{{ config(severity='warn') }}

select order_id
from {{ ref('fct_orders') }}
where order_purchased_at is not null
    and order_approved_at is not null
    and order_purchased_at > order_approved_at
union all
select order_id
from {{ ref('fct_orders') }}
where order_approved_at is not null
    and order_delivered_carrier_at is not null
    and order_approved_at > order_delivered_carrier_at
union all
select order_id
from {{ ref('fct_orders') }}
where order_delivered_carrier_at is not null
    and order_delivered_customer_at is not null
    and order_delivered_carrier_at > order_delivered_customer_at