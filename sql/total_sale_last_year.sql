SELECT
    p.category,
    SUM(trr.total_price) AS total_sales_last_year
FROM transaction_row AS trr
JOIN "transaction" AS t ON t.id = trr.transaction_id
JOIN product AS p ON p.id = trr.product_id
WHERE
    t.complete = TRUE
    AND t.complete_date >= date_trunc('year', current_date) - INTERVAL '1 year'
    AND t.complete_date <  date_trunc('year', current_date)
-- GROUP BY
    -- p.category;