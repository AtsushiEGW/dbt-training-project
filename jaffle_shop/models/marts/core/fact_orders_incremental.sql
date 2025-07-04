-- インクリメンタルモデルの例
-- 必要な分だけ更新をするモデル。すべてのデータを更新する必要がなく、より細かいスパンでの更新ができるようになる可能性がある

{{
    config(
        materialized='incremental',
        unique_key='order_id',
        on_schema_change='fail'
    )
}}

with
orders as (
    select * from {{ ref('stg_orders') }}
    {% if is_incremental() %}

    -- 増分実行時は新しい注文のみを処理
    where ordered_at > (select max(ordered_at) from {{ this }})
    {% endif %}
),

-- payments テーブルは今回のデータには含まれていないため、
-- ordersテーブルの金額情報を使用


order_items_agg as (
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
        coalesce(order_items_agg.item_count, 0) as item_count,
    from orders
    left join order_items_agg using (order_id)
)

select * from final

