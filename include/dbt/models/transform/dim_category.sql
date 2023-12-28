WITH category_cte AS (
	SELECT DISTINCT
	    {{ dbt_utils.generate_surrogate_key(['category', 'category_name']) }} as category_id,
	    REGEXP_REPLACE(category, r'\.0$', '') as category_number,
      category_name
	FROM {{ source('sales', 'raw_sales') }}
	WHERE category IS NOT NULL
)
SELECT t.*
FROM category_cte t
