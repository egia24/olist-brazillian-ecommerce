with casting as(
    SELECT
        
        seller_id::VARCHAR(50) as seller_id,
        seller_zip_code_prefix::VARCHAR(10) as seller_zip_code_prefix,
        seller_city::VARCHAR(100) as seller_city,
        seller_state::CHAR(2) as seller_state
    FROM {{ ref('stg_sellers') }}
),

transform as(
    select
        seller_id,
        seller_zip_code_prefix,
        initcap(trim(regexp_replace(seller_city, '\s+', ' ', 'g'))) as seller_city,
        upper(trim(seller_state)) as seller_state
    from casting
),

seller_dedup as(
    select 
        *,
        row_number() over(partition by seller_id order by seller_id) as rn
    from transform
)

select
    {{ dbt_utils.generate_surrogate_key(['seller_id']) }} as seller_key,
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
from seller_dedup
where rn = 1 and seller_id is not null