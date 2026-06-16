-- =============================================================
-- Seed Data — VENDOR, INVOICE, LINE_ITEM
-- Run after DDL scripts
-- =============================================================

-- VENDOR seed data
INSERT INTO AAVYA_TRAINING.VENDOR_DATA.VENDOR VALUES
    ('V001', 'Infosys BPM Ltd',       'IT Services',      'India',   'procurement@infosys.com',   TRUE,  CURRENT_TIMESTAMP()),
    ('V002', 'Tata Consultancy Svcs', 'IT Services',      'India',   'billing@tcs.com',           TRUE,  CURRENT_TIMESTAMP()),
    ('V003', 'AWS India Pvt Ltd',     'Cloud Services',   'India',   'invoices@aws.com',          TRUE,  CURRENT_TIMESTAMP()),
    ('V004', 'Snowflake Inc',         'Data Platform',    'USA',     'billing@snowflake.com',     TRUE,  CURRENT_TIMESTAMP()),
    ('V005', 'Zoho Corporation',      'SaaS Tools',       'India',   'accounts@zoho.com',         TRUE,  CURRENT_TIMESTAMP());

-- INVOICE seed data
INSERT INTO AAVYA_TRAINING.VENDOR_DATA.INVOICE VALUES
    ('INV-001', 'V001', '2024-01-15', '2024-02-15', 125000.00, 'INR', 'PAID',    CURRENT_TIMESTAMP()),
    ('INV-002', 'V002', '2024-02-01', '2024-03-01',  98500.50, 'INR', 'PAID',    CURRENT_TIMESTAMP()),
    ('INV-003', 'V003', '2024-02-10', '2024-03-10',  43200.00, 'USD', 'PENDING', CURRENT_TIMESTAMP()),
    ('INV-004', 'V004', '2024-03-01', '2024-04-01',  12000.00, 'USD', 'PENDING', CURRENT_TIMESTAMP()),
    ('INV-005', 'V005', '2024-01-20', '2024-02-20',   5400.00, 'INR', 'OVERDUE', CURRENT_TIMESTAMP()),
    ('INV-006', 'V001', '2024-03-15', '2024-04-15', 134000.00, 'INR', 'PENDING', CURRENT_TIMESTAMP());

-- LINE_ITEM seed data
INSERT INTO AAVYA_TRAINING.VENDOR_DATA.LINE_ITEM (line_item_id, invoice_id, description, quantity, unit_price) VALUES
    ('LI-001', 'INV-001', 'Application Support - Jan 2024',      1,  85000.00),
    ('LI-002', 'INV-001', 'Infrastructure Management - Jan 2024',1,  40000.00),
    ('LI-003', 'INV-002', 'Cloud Migration Consulting',          5,  18000.00),
    ('LI-004', 'INV-002', 'Project Management Hours',           15,   2300.00),
    ('LI-005', 'INV-003', 'EC2 Reserved Instances',             12,   3200.00),
    ('LI-006', 'INV-003', 'S3 Storage (TB)',                    24,    150.00),
    ('LI-007', 'INV-004', 'Snowflake Credits - Feb 2024',      100,    120.00),
    ('LI-008', 'INV-005', 'CRM License - Annual',               3,   1800.00),
    ('LI-009', 'INV-006', 'Application Support - Mar 2024',      1,  90000.00),
    ('LI-010', 'INV-006', 'Security Compliance Audit',           1,  44000.00);

