{{
    config(
        materialized='table'
    )
}}

select
    store_id,
    {% for product_type in get_product_types() %}
    count(
        distinct
        case when p.type = '{{ product_type }}' then i.sku end
        ) as {{ product_type }}_proudct_count
    {% if not loop.last %}, {% endif %}
    {% endfor %}
from {{ ref('stg_orders') }} as o
join {{ ref('stg_items') }} as i
    on o.order_id = i.order_id
join {{ ref('stg_products') }} as p
    on i.product_sku = p.product_sku
group by store_id