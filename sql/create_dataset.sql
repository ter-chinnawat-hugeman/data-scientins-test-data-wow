CREATE TABLE daily_demand_dataset AS
SELECT
    p.id                                AS product_id,
    p.name                              AS product_name,
    p.price                             AS listed_price,
    cat.id                              AS category_id,
    cat.name                            AS category_name,
    s.id                                AS supplier_id,
    s.name                              AS supplier_name,
    c.id                                AS supplier_country_id,
    c.name                              AS supplier_country_name,
    date_trunc('day', t.created_date)::date AS day,
    SUM(CASE WHEN trr.return_reason IS NULL THEN trr.quantity     ELSE 0 END) AS total_qty_sold,
    SUM(CASE WHEN trr.return_reason IS NULL THEN trr.total_price  ELSE 0 END) AS total_revenue,
    AVG(CASE WHEN trr.return_reason IS NULL THEN trr.price        ELSE NULL END) AS avg_unit_price,
    SUM(CASE WHEN trr.return_reason IS NOT NULL THEN trr.quantity ELSE 0 END) AS return_qty,
    COUNT(*) FILTER (WHERE trr.return_reason IS NOT NULL) AS return_count,
    CASE WHEN COUNT(*) FILTER (WHERE trr.return_reason IS NOT NULL) > 0
         THEN TRUE ELSE FALSE END AS is_return,     
    COALESCE(SUM(inv.quantity),0)       AS total_inventory_qty,
    COALESCE(SUM(inv.incoming),0)       AS total_incoming_qty,
    COALESCE(SUM(inv.outgoing),0)       AS total_outgoing_qty,
    COUNT(DISTINCT inv.warehouse)       AS num_warehouses,
    COUNT(DISTINCT wc.id)               AS num_warehouse_countries
FROM        transaction_row trr
JOIN        "transaction" t         ON t.id = trr.transaction_id
JOIN        product p              ON p.id = trr.product_id
JOIN        supplier s             ON s.id = p.supplier
JOIN        country c              ON c.id = s.country         
JOIN        category cat           ON cat.id = p.category
LEFT JOIN   inventory inv          ON inv.product  = p.id
LEFT JOIN   warehouse w            ON w.id         = inv.warehouse
LEFT JOIN   country wc             ON wc.id        = w.country 
WHERE
    t.complete       = TRUE
    AND trr.complete = TRUE
    AND p.is_active  = TRUE
    AND s.is_active  = TRUE
GROUP BY
    p.id, p.name, p.price,
    cat.id, cat.name,
    s.id, s.name,
    c.id, c.name,
    date_trunc('day', t.created_date)::date;