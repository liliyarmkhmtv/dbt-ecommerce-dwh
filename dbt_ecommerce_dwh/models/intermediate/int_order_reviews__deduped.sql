with ranked_reviews as (
    select
        review_id,
        order_id,
        review_score,
        review_comment_title,
        review_comment_message,
        review_created_at,
        review_answered_at,
        row_number() over (partition by order_id order by review_created_at desc) as review_rank

    from {{ ref('stg_ecommerce__order_reviews') }}
)
select
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_created_at,
    review_answered_at
from ranked_reviews
where review_rank = 1
