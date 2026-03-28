with source as (
        select * from {{ source('ecommerce', 'orders') }}
  ),
  renamed as (
      select
        order_id,
        customer_id,
        order_status,
        order_purchase_timestamp as order_purchased_at,
        order_approved_at,
        order_delivered_carrier_date as order_delivered_carrier_at,
        order_delivered_customer_date as order_delivered_customer_at,
        cast(order_estimated_delivery_date as date) as order_estimated_delivery_date

      from source
  )
  select * from renamed
    