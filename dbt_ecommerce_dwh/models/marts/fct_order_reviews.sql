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