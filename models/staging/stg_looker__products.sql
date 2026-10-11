select
    id,
    cost,
    category,
    name,
    brand,
    retail_price,
    department,
    sku,
    distribution_center_id
from {{ source('looker_ecommerce', 'products') }}
