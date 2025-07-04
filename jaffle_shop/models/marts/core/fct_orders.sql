-- 注文ファクトテーブブル

with 
orders as (
    select * 
    from {{ source('jaffle_shop_raw', 'orders')}}
),

-- payments テーブルは今回のデー含まれていないので、
-- orders テーブルの金額情報を使用

order_items_agg as (
    -- 一つのオーダーで複数の商品が購入されるため
    -- 何種類の商品を購入したか、合計でいくつの商品を購入したか
    -- という数値をオーダー毎に算出する
    select 
        order_id,
        count(distinct product_sku) as product_count,
        count(*) as item_count
    from {{ ref('stg_items') }}
    group by order_id
),

final as (
    select
        orders.order_id,
        orders.customer_id,
        orders.ordered_at,
        orders.subtotal_dollars,
        orders.tax_paid_dollars,
        orders.order_total_dollars,
        coalesce(order_items_agg.product_count, 0) as product_count,
        coalesce(order_items_agg.item_count, 0) as item_count
    from orders 
    left join order_items_agg using (order_id)
)

select * from final