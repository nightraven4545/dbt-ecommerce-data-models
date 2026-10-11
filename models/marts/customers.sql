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
    where status = 'Complete'
    group by user_id
),

orders as (
    select
        user_id,
        count(distinct order_id) as num_orders,
        count(distinct case when status = 'Shipped' then order_id end) as num_orders_shipped,
        count(distinct case when status = 'Complete' then order_id end) as num_orders_complete,
        count(distinct case when status = 'Processing' then order_id end) as num_orders_processing,
        count(distinct case when status = 'Cancelled' then order_id end) as num_orders_cancelled,
        count(distinct case when status = 'Returned' then order_id end) as num_orders_returned
    from {{ ref('stg_looker__orders') }}
    group by user_id
),

web_sessions as (
    select
        user_id,
        count(distinct session_id) as num_web_sessions
    from {{ ref('stg_looker__events') }}
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
    orders.num_orders,
    orders.num_orders_shipped,
    orders.num_orders_complete,
    orders.num_orders_processing,
    orders.num_orders_cancelled,
    orders.num_orders_returned,
    web_sessions.num_web_sessions
from customers
left join completed_items on customers.user_id = completed_items.user_id
left join orders on customers.user_id = orders.user_id
left join web_sessions on customers.user_id = web_sessions.user_id
