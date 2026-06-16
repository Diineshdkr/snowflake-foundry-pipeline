# =============================================================
# Transform: invoice_enriched
# Joins INVOICE with VENDOR to enrich invoice records
# Palantir Foundry Code Workbook — PySpark
# =============================================================

from transforms.api import transform, Input, Output
from pyspark.sql import functions as F


@transform(
    output=Output("/AAVYA_TRAINING/pipeline/invoice_enriched"),
    invoices=Input("/AAVYA_TRAINING/raw/invoice"),
    vendors=Input("/AAVYA_TRAINING/raw/vendor"),
)
def compute(invoices, vendors, output):
    df_inv = invoices.dataframe()
    df_ven = vendors.dataframe()

    # Enrich invoices with vendor metadata
    enriched = df_inv.join(
        df_ven.select("vendor_id", "vendor_name", "category", "country"),
        on="vendor_id",
        how="left"
    )

    # Derive payment status flag and days overdue
    enriched = enriched.withColumn(
        "is_overdue",
        F.when(
            (F.col("status") == "OVERDUE") | 
            ((F.col("status") == "PENDING") & (F.col("due_date") < F.current_date())),
            True
        ).otherwise(False)
    ).withColumn(
        "days_since_due",
        F.when(
            F.col("due_date").isNotNull(),
            F.datediff(F.current_date(), F.col("due_date"))
        ).otherwise(None)
    )

    output.write_dataframe(enriched)

