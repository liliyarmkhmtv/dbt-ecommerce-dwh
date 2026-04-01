{% snapshot customers_snapshot %}
    {{
        config(
          target_schema='snapshots',
          unique_key='customer_unique_id',
          strategy='check',
          check_cols=['customer_city', 'customer_state'],
        )
    }}
    select distinct
        customer_unique_id,
        customer_city,
        customer_state,
        customer_zip_code_prefix
    from {{ ref('stg_ecommerce__customers') }}
    qualify row_number() over (partition by customer_unique_id order by customer_id) = 1
{% endsnapshot %}