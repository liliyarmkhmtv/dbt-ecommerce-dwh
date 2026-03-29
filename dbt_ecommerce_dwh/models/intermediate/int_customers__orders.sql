with customers as (
    select
        *
    from {{ ref('stg_ecommerce__customers') }}
),
payments as (
    select
        order_id,
        total_payment_value
    from {{ ref('int_orders__payments') }}
)
select
    customer_unique_id,
    min(order_purchased_at) as first_order_date,
    max(order_purchased_at) as last_order_date,
    count(orders.order_id) as total_orders,
    sum(total_payment_value) as total_spent,
    TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), max(order_purchased_at), DAY) as days_since_last_order
from customers
left join {{ ref('int_orders__enriched') }} orders on customers.customer_id = orders.customer_id
left join payments on orders.order_id = payments.order_id
group by customer_unique_id