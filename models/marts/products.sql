-- Sales and cost come from the same order lines. inventory_items is deliberately not used for cost:
-- in this dataset order lines only ever point at unsold inventory units, so inventory-based COGS is ~0.
with products as (
    select
        id as product_id,
        name as product_name,
        category as product_category,
        department as product_department,
        cost
    from {{ ref('stg_looker__products') }}
),

kept_sales as (
    select
        product_id,
        sum(sale_price) as sales_amount,
        count(*) as units_sold
    from {{ ref('stg_looker__order_items') }}
    where status not in ('Cancelled', 'Returned')
    group by product_id
),

final as (
    select
        products.product_id,
        products.product_name,
        products.product_category,
        products.product_department,
        {{ coalesce_and_round('kept_sales.sales_amount') }} as sales_amount,
        {{ coalesce_and_round('kept_sales.units_sold * products.cost') }} as cost_of_goods_sold
    from products
    left join kept_sales on products.product_id = kept_sales.product_id
)

select
    *,
    round(sales_amount - cost_of_goods_sold, 2) as profit
from final
