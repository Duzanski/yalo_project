WITH category_cte AS (
	SELECT DISTINCT
	    {{ dbt_utils.generate_surrogate_key(['category', 'category_name']) }} as category_id,
	    CAST(REGEXP_REPLACE(category, r'\.0$', '') as INT64) as category_number,
      	category_name
	FROM {{ source('sales', 'raw_sales') }}
	WHERE category IS NOT NULL
	LIMIT 1000
)
SELECT t.*
FROM category_cte t
