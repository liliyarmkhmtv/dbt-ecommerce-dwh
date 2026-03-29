with payments as (
    select * from {{ ref('stg_payments__payments') }}
),
aggregated as (
    select
        order_id,
        sum(payment_value)                                                    as total_payment_value,
        {# TODO: macro to generate the following lines: #}
        sum(case when payment_type = 'credit_card' then payment_value end)    as credit_card_value,
        sum(case when payment_type = 'boleto' then payment_value end)         as boleto_value,
        sum(case when payment_type = 'voucher' then payment_value end)        as voucher_value,
        sum(case when payment_type = 'debit_card' then payment_value end)     as debit_card_value
    from payments
    group by order_id
)
select * from aggregated