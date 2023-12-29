WITH date_cte AS (  
  SELECT DISTINCT
   {{ dbt_utils.generate_surrogate_key(['date']) }} as date_id,
    date,
  FROM {{ source('sales', 'raw_sales') }}
  WHERE date IS NOT NULL
  LIMIT 1000  
)
SELECT
  date_id,
  date as full_date,
  EXTRACT(YEAR FROM date) AS year,
  EXTRACT(MONTH FROM date) AS month,
  EXTRACT(DAY FROM date) AS day,
  EXTRACT(QUARTER FROM date) AS hour
FROM date_cte