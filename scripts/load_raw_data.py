from google.cloud import bigquery

project = "dbt-ecommerce-dwh-491416"
tables = {'ecommerce.customers': 'data/olist_customers_dataset.csv',
          'ecommerce.order_items': 'data/olist_order_items_dataset.csv',
          'ecommerce.order_reviews': 'data/olist_order_reviews_dataset.csv',
          'ecommerce.orders': 'data/olist_orders_dataset.csv',
          'ecommerce.products': 'data/olist_products_dataset.csv',
          'ecommerce.sellers': 'data/olist_sellers_dataset.csv',
          'ecommerce.product_category_name_translation': 'data/product_category_name_translation.csv',
          'geo.geolocation': 'data/olist_geolocation_dataset.csv',
          'payments.order_payments': 'data/olist_order_payments_dataset.csv'}

client = bigquery.Client(project=project)

job_config = bigquery.LoadJobConfig(
    source_format=bigquery.SourceFormat.CSV,
    skip_leading_rows=1,
    autodetect=True,
    write_disposition="WRITE_TRUNCATE",
    allow_quoted_newlines=True,
    ignore_unknown_values=True
)

for table_name, file_path in tables.items():
    with open(file_path, "rb") as source_file:
        job = client.load_table_from_file(source_file, f"{project}.{table_name}", job_config=job_config)

        job.result()  # Waits for the job to complete.

        table = client.get_table(f"{project}.{table_name}")  # Make an API request.
        print(
            "Loaded {} rows and {} columns to {}".format(
                table.num_rows, len(table.schema), f"{project}.{table_name}"
            )
        )