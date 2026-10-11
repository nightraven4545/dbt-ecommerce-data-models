{%- set order_items_status = 'Complete' -%}

with customers as (
    select
        id as user_id,
        first_name as customer_first_name,
        last_name as customer_last_name,
        country as customer_country,
        traffic_source as customer_acquisition_channel
    from {{ ref('stg_looker__users') }}
),

completed_items as (
    select
        user_id,
        sum(sale_price) as total_amount_spent,
        count(distinct id) as total_items_purchased,
        min(created_at) as first_order_completed_at,
        max(created_at) as last_order_completed_at
    from {{ ref('stg_looker__order_items') }}
    where status = '{{ order_items_status }}'
    group by user_id
)

select
    customers.user_id,
    customers.customer_first_name,
    customers.customer_last_name,
    customers.customer_country,
    customers.customer_acquisition_channel,
    completed_items.total_amount_spent,
    completed_items.total_items_purchased,
    completed_items.first_order_completed_at,
    completed_items.last_order_completed_at,
    orders.* exclude (user_id),
    web_sessions.* exclude (user_id)
from customers
left join completed_items on customers.user_id = completed_items.user_id
left join {{ ref('int_orders__pivoted') }} as orders on customers.user_id = orders.user_id
left join {{ ref('int_events__pivoted') }} as web_sessions on customers.user_id = web_sessions.user_id
