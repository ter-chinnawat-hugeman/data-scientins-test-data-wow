WITH cat_daily_qty AS (
    SELECT
        p.category AS category_id,
        DATE_TRUNC('day', i.updated_date)::date AS day,
        SUM(i.quantity) AS total_qty
    FROM inventory i
    JOIN product p ON p.id = i.product
    GROUP BY p.category, DATE_TRUNC('day', i.updated_date)::date
),
out_of_stock AS (
    SELECT
        category_id,
        day
    FROM cat_daily_qty
    WHERE total_qty <= 0
),
grouped AS (
    SELECT
        category_id,
        day,
        day - ROW_NUMBER() OVER (
            PARTITION BY category_id
            ORDER BY day
        ) AS grp
    FROM out_of_stock
)
SELECT
    category_id,
    MIN(day) AS start_date,
    MAX(day) AS end_date,
    COUNT(*) AS num_days
FROM grouped
GROUP BY category_id, grp
ORDER BY category_id, start_date;