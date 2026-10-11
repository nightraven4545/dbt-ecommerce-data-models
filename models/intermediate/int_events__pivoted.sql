{%- set channels = ['Adwords', 'Email', 'Facebook', 'Organic', 'YouTube'] -%}
{%- set browsers = ['Chrome', 'Firefox', 'Safari', 'IE', 'Other'] -%}

select
    user_id,
    count(distinct session_id) as num_web_sessions,
    {%- for channel in channels %}
    count(distinct case when traffic_source = '{{ channel }}' then session_id end) as num_sessions_from_{{ channel | lower }},
    {%- endfor %}
    {%- for browser in browsers %}
    count(distinct case when browser = '{{ browser }}' then session_id end) as num_sessions_on_{{ browser | lower }}
    {{- ',' if not loop.last }}
    {%- endfor %}
from {{ ref('stg_looker__events') }}
where user_id is not null
group by user_id
