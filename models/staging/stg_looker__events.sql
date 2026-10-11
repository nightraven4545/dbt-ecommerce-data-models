select
    id,
    user_id::bigint as user_id, -- inferred as double because anonymous events have no user
    sequence_number,
    session_id,
    created_at,
    ip_address,
    city,
    state,
    postal_code,
    browser,
    traffic_source,
    uri,
    event_type
from {{ source('looker_ecommerce', 'events') }}
