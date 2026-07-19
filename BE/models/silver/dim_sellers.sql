with stg_sellers as(
    SELECT
        seller_id::VARCHAR(50),
        seller_postal_code_prefix::NUMERIC(10,2) AS postal_code_prefix,
        seller_city::VARCHAR(100),
        seller_state::VARCHAR(3)
    FROM {{ ref('stg_sellers') }}
)

with seller_dedup as(
    select 
        *,
        row_number() over(partition by seller_id) as rn 
)

select
    * 
from seller_dedup
where rn = 1