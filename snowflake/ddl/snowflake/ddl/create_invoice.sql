-- =============================================================
-- INVOICE Fact Table
-- Database: AAVYA_TRAINING | Schema: VENDOR_DATA
-- =============================================================

CREATE OR REPLACE TABLE AAVYA_TRAINING.VENDOR_DATA.INVOICE (
    invoice_id      VARCHAR(20)     NOT NULL PRIMARY KEY,
    vendor_id       VARCHAR(20)     NOT NULL REFERENCES VENDOR(vendor_id),
    invoice_date    DATE            NOT NULL,
    due_date        DATE,
    total_amount    FLOAT           NOT NULL DEFAULT 0.0,
    currency        VARCHAR(5)      DEFAULT 'USD',
    status          VARCHAR(20)     CHECK (status IN ('PAID', 'PENDING', 'OVERDUE', 'CANCELLED')),
    created_at      TIMESTAMP_NTZ   DEFAULT CURRENT_TIMESTAMP()
);

COMMENT ON TABLE AAVYA_TRAINING.VENDOR_DATA.INVOICE IS 'Fact table storing invoice-level billing records per vendor';

