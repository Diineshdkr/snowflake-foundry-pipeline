# =============================================================
# Transform: line_item_summary
# Aggregates line items per invoice and vendor
# Palantir Foundry Code Workbook — PySpark
# =============================================================

from transforms.api import transform, Input, Output
from pyspark.sql import functions as F


@transform(
    output=Output("/AAVYA_TRAINING/pipeline/line_item_summary"),
    line_items=Input("/AAVYA_TRAINING/raw/line_item"),
    invoice_enriched=Input("/AAVYA_TRAINING/pipeline/invoice_enriched"),
)
def compute(line_items, invoice_enriched, output):
    df_li  = line_items.dataframe()
    df_inv = invoice_enriched.dataframe()

    # Aggregate line items per invoice
    li_agg = df_li.groupBy("invoice_id").agg(
        F.count("line_item_id").alias("total_line_items"),
        F.sum("line_total").alias("computed_total"),
        F.avg("unit_price").alias("avg_unit_price"),
        F.max("line_total").alias("largest_line_item")
    )

    # Join with enriched invoice for full context
    summary = li_agg.join(
        df_inv.select("invoice_id", "vendor_id", "vendor_name", "category",
                      "invoice_date", "status", "total_amount", "is_overdue"),
        on="invoice_id",
        how="left"
    ).withColumn(
        "variance",
        F.round(F.col("total_amount") - F.col("computed_total"), 2)
    )

    output.write_dataframe(summary)

