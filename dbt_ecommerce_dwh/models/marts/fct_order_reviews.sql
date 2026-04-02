{{
    config(
        materialized='incremental',
        unique_key='order_id'
    )
}}

select
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_created_at,
    review_answered_at,
    review_comment_message is not null as has_comment,
    timestamp_diff(review_answered_at, review_created_at, HOUR) as answer_time_hours
from {{ ref('int_order_reviews__deduped') }}

{% if is_incremental() %}

where review_created_at >= (select coalesce(max(review_created_at), '1900-01-01') from {{ this }})
   or review_answered_at >= (select coalesce(max(review_answered_at), '1900-01-01') from {{ this }})

{% endif %}