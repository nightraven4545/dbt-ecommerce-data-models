select
    order_id,
    user_id,
    status,
    gender,
    created_at,
    -- these three load as naive timestamps holding UTC wall-clock time; make them tz-aware like created_at
    timezone('UTC', returned_at) as returned_at,
    timezone('UTC', shipped_at) as shipped_at,
    timezone('UTC', delivered_at) as delivered_at,
    num_of_item
from {{ source('looker_ecommerce', 'orders') }}
