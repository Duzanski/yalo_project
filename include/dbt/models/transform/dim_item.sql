WITH item_cte AS (
	SELECT
		DISTINCT { { dbt_utils.generate_surrogate_key(['item_description', 'item_number']) } } as item_id,
		item_number,
		item_description
	FROM
		{ { source('sales', 'raw_sales') } }
	WHERE item_number IS NOT NULL
)
SELECT
	i.*
FROM
	item_cte i