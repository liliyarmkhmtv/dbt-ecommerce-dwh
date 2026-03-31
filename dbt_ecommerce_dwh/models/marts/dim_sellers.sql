select
    seller_id,
    seller_city,
    seller_state,
    total_orders,
    total_revenue,
    safe_divide(total_revenue, total_orders) as avg_order_value,
    average_review_score,
    late_delivery_rate,
    seller_late_shipment_rate
from {{ ref('int_sellers__metrics') }}