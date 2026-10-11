{%- set order_statuses = ['Shipped', 'Complete', 'Processing', 'Cancelled', 'Returned'] -%}

select
    user_id,
    count(distinct order_id) as num_orders,
    {%- for status in order_statuses %}
    count(distinct case when status = '{{ status }}' then order_id end) as num_orders_{{ status | lower }}
    {{- ',' if not loop.last }}
    {%- endfor %}
from {{ ref('stg_looker__orders') }}
group by user_id
