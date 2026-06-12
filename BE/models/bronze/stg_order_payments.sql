select
    order_id::VARCHAR(50) as order_id,
    payment_sequential::INT as payment_sequential,
    payment_type::VARCHAR(50) as payment_type,
    payment_installments:: INT as payment_installments,
    payment_value::NUMERIC(12,2) as payment_value

from {{ source('olist_ecommerce', 'olist_order_payments_dataset')}}