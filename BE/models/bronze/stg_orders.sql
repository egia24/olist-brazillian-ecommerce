select 
    order_id::varchar(50)                                as id,
    customer_id::varchar(50)                             as customer_id,
    order_status::VARCHAR(50)                            as status,
    NULLIF(order_purchase_timestamp, '')::timestamp      as order_purchase,
    NULLIF(order_approved_at, '')::timestamp             as order_approved_at,
    NULLIF(order_delivered_carrier_date, '')::timestamp  as order_delivered_carrier_date,
    NULLIF(order_delivered_customer_date, '')::timestamp as order_delivered_customer_date,
    NULLIF(order_estimated_delivery_date, '')::timestamp as order_estimated_delivery_date
from {{source('olist_ecommerce', 'olist_orders_dataset')}}