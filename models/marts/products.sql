with products as (
    select
        id as product_id,
        name as product_name,
        category as product_category,
        department as product_department
    from {{ ref('stg_looker__products') }}
),

sold_inventory as (
    select
        product_id,
        sum(cost) as cost_of_goods_sold
    from {{ ref('stg_looker__inventory_items') }}
    where sold_at is not null
    group by product_id
),

sales as (
    select
        product_id,
        sum(sale_price) as sales_amount
    from {{ ref('stg_looker__order_items') }}
    group by product_id
)

select
    products.product_id,
    products.product_name,
    products.product_category,
    products.product_department,
    sales.sales_amount,
    sold_inventory.cost_of_goods_sold,
    sales.sales_amount - sold_inventory.cost_of_goods_sold as profit
from products
left join sold_inventory on products.product_id = sold_inventory.product_id
left join sales on products.product_id = sales.product_id
