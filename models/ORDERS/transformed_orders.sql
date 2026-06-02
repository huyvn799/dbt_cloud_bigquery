with base_orders as (

    select
        order_id,
        customer_id,
        order_date,
        order_status,
        order_amount
    from {{ source('bigquery_source', 'orders') }}

),

transformed as (

    select
        cast(order_id as int64) as order_id,
        cast(customer_id as int64) as customer_id,
        cast(order_date as date) as order_date,
        date_diff(current_date(), order_date, DAY) as days_since_order,
        lower(trim(order_status)) as order_status,
        CASE 
            WHEN order_status = 'Completed' THEN TRUE
            ELSE FALSE
        END AS is_completed,
        cast(order_amount as numeric) as order_amount,
        current_timestamp() as created_at

    from base_orders

)

select *
from transformed