{{
    config(
        materialized='table'
    )
}}

select
    order_id,
    customer_id,
    ordered_at,
    store_id,
    order_total_dollars
from {{ ref('fact_orders') }}
{{ limit_data_in_dev('ordered_at', 7) }}