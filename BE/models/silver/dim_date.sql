with date_range as (
    select
        min(order_purchase_timestamp)::date as min_date,
        greatest(
            max(order_purchase_timestamp)::date,
            max(order_delivered_customer_date)::date,
            max(order_estimated_delivery_date)::date
        ) as max_date
    from {{ ref('stg_orders') }}
),

date_spine as (
    select generate_series(
        (select min_date from date_range),
        (select max_date from date_range),
        interval '1 day'
    )::date as date_day
),

date_detail as (
    select
        cast(date_day as date) as date_day,
        extract(year from date_day)::int as year,
        extract(quarter from date_day)::int as quarter,
        extract(month from date_day)::int as month,
        trim(to_char(date_day, 'Month')) as month_name,
        to_char(date_day, 'Mon') as month_name_short,
        extract(day from date_day)::int as day_of_month,
        extract(doy from date_day)::int as day_of_year,
        extract(dow from date_day)::int as day_of_week,        
        trim(to_char(date_day, 'Day')) as day_name,
        to_char(date_day, 'Dy') as day_name_short,
        extract(week from date_day)::int as week_of_year,
        case 
            when extract(dow from date_day) in (0,6) then true 
            else false 
        end as is_weekend,
        case 
            when date_day = date_trunc('month', date_day)::date then true 
            else false 
        end as is_month_start,
        case 
            when date_day = (date_trunc('month', date_day) + interval '1 month' - interval '1 day')::date then true 
            else false 
        end as is_month_end,
        to_char(date_day, 'YYYYMM')::int as year_month,
        extract(year from date_day)::text || '-Q' || extract(quarter from date_day)::text as year_quarter
    from date_spine
)

select
    {{ dbt_utils.generate_surrogate_key(['date_day']) }} as date_key,
    date_day,
    year,
    quarter,
    year_quarter,
    month,
    month_name,
    month_name_short,
    year_month,
    day_of_month,
    day_of_year,
    day_of_week,
    day_name,
    day_name_short,
    week_of_year,
    is_weekend,
    is_month_start,
    is_month_end
from date_detail