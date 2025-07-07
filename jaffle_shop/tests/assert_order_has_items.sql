
-- すべての注文に少なくとも１つ以上のアイテムが含まれていることを確認するテスト

with
orders as (
    select
        order_id
    from {{ ref('stg_orders') }}
),

order_items as (
    select
        order_id,
        count(*) as item_count
    from {{ ref('stg_items') }}
    group by order_id
),

-- アイテムのない注文を検出
orders_without_items as (
    select
        o.order_id
    from orders as o
    left join order_items as oi using (order_id)
    where oi.order_id is null
)

select *
from orders_without_items
