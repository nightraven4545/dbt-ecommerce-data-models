select
    id,
    name,
    latitude,
    longitude
from {{ ref('looker__distribution_centers') }}
