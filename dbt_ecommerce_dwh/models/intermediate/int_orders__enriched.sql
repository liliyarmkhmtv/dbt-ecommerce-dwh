with orders as (
    select
        order_id,
        order_status,
        customer_id,
        order_purchased_at,
        order_approved_at,
        order_delivered_carrier_at,
        order_delivered_customer_at,
        order_estimated_delivery_date,
        date_diff(order_approved_at, order_purchased_at, DAY) as order_processing_time,
        date_diff(order_delivered_customer_at, order_approved_at, DAY) as delivery_time,
        date_diff(date(order_delivered_customer_at), order_estimated_delivery_date, DAY) as days_late,
        date(order_delivered_customer_at) > order_estimated_delivery_date as is_late
    from {{ ref('stg_ecommerce__orders') }}
),
customers as (
    select
        customer_id,
        customer_city,
        customer_state
    from {{ ref('stg_ecommerce__customers') }}  
),
order_items_agg as (
    select
        order_id,
        count(*) as total_items,
        sum(item_price) as total_items_value,
        sum(freight_value) as total_freight_value
    from {{ ref('stg_ecommerce__order_items') }}
    group by order_id
),
joined as (
    select
        orders.order_id,
        orders.order_status,
        orders.customer_id,
        customers.customer_city,
        customers.customer_state,
        order_items_agg.total_items,
        order_items_agg.total_items_value,
        order_items_agg.total_freight_value,
        orders.order_purchased_at,
        orders.order_approved_at,
        orders.order_delivered_carrier_at,
        orders.order_delivered_customer_at,
        orders.order_estimated_delivery_date,
        orders.order_processing_time,
        orders.delivery_time,
        orders.days_late,
        orders.is_late
    from orders
    left join customers on orders.customer_id = customers.customer_id
    left join order_items_agg on orders.order_id = order_items_agg.order_id
)
select * from joined