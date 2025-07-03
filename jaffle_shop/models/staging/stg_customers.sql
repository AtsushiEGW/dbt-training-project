-- 顧客データのステージングモデル

select
    id as customer_id,
    name as customer_name
from {{ ref('raw_customers') }}