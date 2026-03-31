select
    customer_unique_id,
    first_order_date,
    last_order_date,
    total_orders,
    total_spent,
    days_since_last_order
from {{ ref('int_customers__orders') }}