-- =============================================================
-- VENDOR Dimension Table
-- Database: AAVYA_TRAINING | Schema: VENDOR_DATA
-- =============================================================

CREATE OR REPLACE TABLE AAVYA_TRAINING.VENDOR_DATA.VENDOR (
    vendor_id       VARCHAR(20)     NOT NULL PRIMARY KEY,
    vendor_name     VARCHAR(100)    NOT NULL,
    category        VARCHAR(50),
    country         VARCHAR(50),
    contact_email   VARCHAR(100),
    is_active       BOOLEAN         DEFAULT TRUE,
    created_at      TIMESTAMP_NTZ   DEFAULT CURRENT_TIMESTAMP()
);

COMMENT ON TABLE AAVYA_TRAINING.VENDOR_DATA.VENDOR IS 'Dimension table storing supplier/vendor master data';

