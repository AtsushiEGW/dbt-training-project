-- 注文ファクトテーブブル

with 
orders as (
    select * from {{ ref('stg_orders') }}
),

-- payments テーブルは今回のデー含まれていないので、
-- orders テーブルの金額情報を使用

order_items_agg as (

    select 
        order_id,


),