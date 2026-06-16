# Snowflake → Palantir Foundry Data Pipeline

A production-style data engineering project demonstrating an end-to-end pipeline from **Snowflake** (cloud data warehouse) to **Palantir Foundry** (data operating system) using the Direct Source Connection method.

---

## 📐 Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     SNOWFLAKE                           │
│  Database: AAVYA_TRAINING  │  Region: Azure Central IN  │
│                                                         │
│  ┌─────────────┐  ┌──────────────┐  ┌───────────────┐  │
│  │  VENDOR     │  │   INVOICE    │  │   LINE_ITEM   │  │
│  │  (Dim)      │  │   (Fact)     │  │   (Fact)      │  │
│  └──────┬──────┘  └──────┬───────┘  └───────┬───────┘  │
│         └────────────────┼──────────────────┘           │
│                          │                              │
└──────────────────────────┼──────────────────────────────┘
                           │  Direct Source Connection
                           │  (Egress Policy Configured)
                           ▼
┌─────────────────────────────────────────────────────────┐
│                 PALANTIR FOUNDRY                         │
│                                                         │
│   Raw Datasets → Pipeline Transforms → Ontology Objects │
│                                                         │
│   ┌──────────┐   ┌──────────────┐   ┌───────────────┐  │
│   │  Raw     │──▶│  Transform   │──▶│   Ontology    │  │
│   │  Datasets│   │  (PySpark)   │   │   (Objects)   │  │
│   └──────────┘   └──────────────┘   └───────────────┘  │
└─────────────────────────────────────────────────────────┘
```

---

## 📁 Repository Structure

```
snowflake-foundry-pipeline/
│
├── snowflake/
│   ├── ddl/
│   │   ├── create_vendor.sql         # Vendor dimension table
│   │   ├── create_invoice.sql        # Invoice fact table
│   │   └── create_line_item.sql      # Line item fact table
│   ├── seed/
│   │   ├── vendor_seed.sql           # Sample vendor data
│   │   ├── invoice_seed.sql          # Sample invoice data
│   │   └── line_item_seed.sql        # Sample line item data
│   └── queries/
│       └── validation_checks.sql     # Row count & null checks
│
├── foundry/
│   ├── connection/
│   │   └── egress_policy_notes.md    # Egress config steps
│   └── transforms/
│       ├── vendor_clean.py           # PySpark transform
│       ├── invoice_enriched.py       # Join invoice + vendor
│       └── line_item_summary.py      # Aggregation transform
│
├── docs/
│   ├── architecture.md               # Full architecture notes
│   ├── setup_guide.md                # Step-by-step setup
│   └── troubleshooting.md            # Common errors & fixes
│
├── requirements.txt
└── README.md
```

---

## 🗄️ Dataset Schema

### VENDOR (Dimension)
| Column | Type | Description |
|---|---|---|
| vendor_id | VARCHAR | Primary key |
| vendor_name | VARCHAR | Supplier name |
| category | VARCHAR | Service/product category |
| country | VARCHAR | Vendor country |
| created_at | TIMESTAMP | Record created date |

### INVOICE (Fact)
| Column | Type | Description |
|---|---|---|
| invoice_id | VARCHAR | Primary key |
| vendor_id | VARCHAR | FK → VENDOR |
| invoice_date | DATE | Date of invoice |
| due_date | DATE | Payment due date |
| total_amount | FLOAT | Invoice total |
| status | VARCHAR | PAID / PENDING / OVERDUE |

### LINE_ITEM (Fact)
| Column | Type | Description |
|---|---|---|
| line_item_id | VARCHAR | Primary key |
| invoice_id | VARCHAR | FK → INVOICE |
| description | VARCHAR | Item description |
| quantity | INT | Units |
| unit_price | FLOAT | Price per unit |
| line_total | FLOAT | quantity × unit_price |

---

## ⚙️ Setup Guide

### 1. Snowflake Setup
```sql
-- Create database and schema
CREATE DATABASE AAVYA_TRAINING;
CREATE SCHEMA AAVYA_TRAINING.VENDOR_DATA;

-- Run DDL scripts in order
-- snowflake/ddl/create_vendor.sql
-- snowflake/ddl/create_invoice.sql
-- snowflake/ddl/create_line_item.sql

-- Seed sample data
-- snowflake/seed/vendor_seed.sql
-- snowflake/seed/invoice_seed.sql
-- snowflake/seed/line_item_seed.sql
```

### 2. Palantir Foundry Connection
1. Navigate to **Data Connection** → **New Source** → **Snowflake**
2. Enter account identifier in format: `<org>-<account>.snowflakecomputing.com`
3. Configure **Egress Policy** to allow outbound to Snowflake endpoint
4. Test connection and sync datasets
5. Validate row counts match source

### 3. Foundry Transforms
```python
# Example: invoice_enriched.py
from transforms.api import transform, Input, Output

@transform(
    output=Output("/pipeline/invoice_enriched"),
    invoices=Input("/raw/invoice"),
    vendors=Input("/raw/vendor"),
)
def compute(invoices, vendors, output):
    df_inv = invoices.dataframe()
    df_ven = vendors.dataframe()
    enriched = df_inv.join(df_ven, on="vendor_id", how="left")
    output.write_dataframe(enriched)
```

---

## 🔍 Key Learnings

- Snowflake account identifier format matters — use `orgname-accountname` not the legacy format
- Egress policies in Foundry must explicitly whitelist the Snowflake hostname
- Cross-region connections (Azure Central India → Foundry) can cause latency; use the nearest Foundry stack
- Build logs in Foundry show infrastructure errors separately from transform errors — check both panels

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Source Warehouse | Snowflake (Azure Central India) |
| Integration | Palantir Foundry Direct Source Connection |
| Transforms | PySpark (Foundry Code Workbook) |
| Language | Python 3, SQL |
| Cloud | Microsoft Azure |

---

## 📬 Author

**Dinesh Kumar Reddy Nandimandalam**  
Data Engineer · Hyderabad, India  
📧 diineshnandimandalam@gmail.com
