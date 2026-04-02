{{
    config(
        materialized='incremental',
        unique_key='order_id'
    )
}}

select
    order_id,
    order_status,
    customer_id,
    customer_city,
    customer_state,
    total_items,
    total_items_value,
    total_freight_value,
    credit_card_value,
    boleto_value,
    voucher_value,
    debit_card_value,
    total_payment_value,
    order_purchased_at,
    order_approved_at,
    order_delivered_carrier_at,
    order_delivered_customer_at,
    order_estimated_delivery_date,
    order_processing_time,
    delivery_time,
    days_late,
    is_late
from {{ ref('int_orders__enriched') }}
left join {{ ref('int_orders__payments') }} using (order_id)

{% if is_incremental() %}

where order_purchased_at >= (select coalesce(max(order_purchased_at),'1900-01-01') from {{ this }} )

{% endif %}