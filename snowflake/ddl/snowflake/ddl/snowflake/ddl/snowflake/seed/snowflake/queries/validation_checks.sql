-- =============================================================
-- Validation Checks — Run after seeding to verify data quality
-- =============================================================

-- Row counts
SELECT 'VENDOR'    AS table_name, COUNT(*) AS row_count FROM AAVYA_TRAINING.VENDOR_DATA.VENDOR
UNION ALL
SELECT 'INVOICE'   AS table_name, COUNT(*) AS row_count FROM AAVYA_TRAINING.VENDOR_DATA.INVOICE
UNION ALL
SELECT 'LINE_ITEM' AS table_name, COUNT(*) AS row_count FROM AAVYA_TRAINING.VENDOR_DATA.LINE_ITEM;

-- Orphan check: invoices without matching vendor
SELECT invoice_id FROM AAVYA_TRAINING.VENDOR_DATA.INVOICE
WHERE vendor_id NOT IN (SELECT vendor_id FROM AAVYA_TRAINING.VENDOR_DATA.VENDOR);

-- Orphan check: line items without matching invoice
SELECT line_item_id FROM AAVYA_TRAINING.VENDOR_DATA.LINE_ITEM
WHERE invoice_id NOT IN (SELECT invoice_id FROM AAVYA_TRAINING.VENDOR_DATA.INVOICE);

-- Invoice totals vs sum of line items (reconciliation)
SELECT
    i.invoice_id,
    i.total_amount                         AS invoice_total,
    SUM(li.line_total)                     AS line_item_sum,
    i.total_amount - SUM(li.line_total)    AS variance
FROM AAVYA_TRAINING.VENDOR_DATA.INVOICE i
LEFT JOIN AAVYA_TRAINING.VENDOR_DATA.LINE_ITEM li ON i.invoice_id = li.invoice_id
GROUP BY i.invoice_id, i.total_amount
HAVING ABS(variance) > 0.01
ORDER BY ABS(variance) DESC;

-- Status distribution
SELECT status, COUNT(*) AS count, SUM(total_amount) AS total_value
FROM AAVYA_TRAINING.VENDOR_DATA.INVOICE
GROUP BY status
ORDER BY total_value DESC;

