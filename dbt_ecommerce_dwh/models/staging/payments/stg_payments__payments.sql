with source as (
        select * from {{ source('payments', 'order_payments') }}
  ),
  casted as (
        select
            order_id,
            payment_sequential,
            payment_type,
            payment_installments,
            cast(payment_value as numeric) as payment_value

          from source
  )
  select * from casted
    