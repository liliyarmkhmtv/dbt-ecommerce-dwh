with source as (
        select * from {{ source('ecommerce', 'sellers') }}
  ),
  casted as (
      select
        seller_id,
        cast(seller_zip_code_prefix as string) as seller_zip_code_prefix,
        seller_city,
        seller_state

      from source
  )
  select * from casted
    