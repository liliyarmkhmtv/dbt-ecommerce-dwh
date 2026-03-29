with sellers as (
    select
        *
    from {{ ref('stg_ecommerce__sellers') }}
)
, order_reviews as (
    select
        order_id,
        review_score
    from {{ ref('stg_ecommerce__order_reviews') }}
)
, orders as (
    select
        order_id,
        is_late,
        order_delivered_carrier_at
    from {{ ref('int_orders__enriched') }}
)
, order_items as (
    select
        seller_id,
        count(distinct order_id) as total_orders,
        sum(item_price) as total_revenue,
        avg(review_score) as average_review_score,
        avg(cast(is_late as int64)) as late_delivery_rate,
        avg(case when order_delivered_carrier_at > shipping_limit_date 
            then 1 else 0 end) as seller_late_shipment_rate
    from {{ ref('stg_ecommerce__order_items') }}
    left join order_reviews using (order_id)
    left join orders using (order_id)
    group by seller_id
)
select
    s.seller_id,
    s.seller_city,
    s.seller_state,
    oi.total_orders,
    oi.total_revenue,
    oi.average_review_score,
    oi.late_delivery_rate,
    oi.seller_late_shipment_rate
from sellers s
left join order_items oi on s.seller_id = oi.seller_id