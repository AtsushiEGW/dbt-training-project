-- models/staging/stg_items.sql
-- 注文アイテムデータのステージングモデル

select
    id as item_id,
    order_id,
    sku as product_sku
from {{ ref('raw_items') }}
