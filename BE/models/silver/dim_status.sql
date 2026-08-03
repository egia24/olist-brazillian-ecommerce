with order_status as (
    select
        row_number() over (order by order_status) as status_id,
        order_status::varchar(50) as order_status
    from (
        select distinct lower(trim(order_status)) as order_status
        from {{ ref('stg_orders') }}
    ) s
)   

select
    {{ dbt_utils.generate_surrogate_key(['order_status']) }} as status_key,
    status_id,
    order_status
from order_status