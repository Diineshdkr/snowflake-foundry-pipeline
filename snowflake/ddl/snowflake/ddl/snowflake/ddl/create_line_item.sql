-- =============================================================
-- LINE_ITEM Fact Table
-- Database: AAVYA_TRAINING | Schema: VENDOR_DATA
-- =============================================================

CREATE OR REPLACE TABLE AAVYA_TRAINING.VENDOR_DATA.LINE_ITEM (
    line_item_id    VARCHAR(20)     NOT NULL PRIMARY KEY,
    invoice_id      VARCHAR(20)     NOT NULL REFERENCES INVOICE(invoice_id),
    description     VARCHAR(255),
    quantity        INT             NOT NULL DEFAULT 1,
    unit_price      FLOAT           NOT NULL DEFAULT 0.0,
    line_total      FLOAT           GENERATED ALWAYS AS (quantity * unit_price),
    created_at      TIMESTAMP_NTZ   DEFAULT CURRENT_TIMESTAMP()
);

COMMENT ON TABLE AAVYA_TRAINING.VENDOR_DATA.LINE_ITEM IS 'Fact table storing individual line items per invoice';

