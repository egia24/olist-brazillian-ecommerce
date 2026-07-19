select
    row_number() over(partition by order_status) as status_id,
    order_status::VARCHAR(50)
from {{ref('stg_orders')}}
