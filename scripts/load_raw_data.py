from google.cloud import bigquery

# Construct a BigQuery client object.
client = bigquery.Client(project="dbt-ecommerce-dwh-491416")

# Set table_id to the ID of the table to create.
table_id = "dbt-ecommerce-dwh-491416.ecommerce.olist_customers"

job_config = bigquery.LoadJobConfig(
    source_format=bigquery.SourceFormat.CSV,
    skip_leading_rows=1,
    autodetect=True,
    write_disposition="WRITE_TRUNCATE",
)

file_path = "data/olist_customers_dataset.csv"

with open(file_path, "rb") as source_file:
    job = client.load_table_from_file(source_file, table_id, job_config=job_config)

job.result()  # Waits for the job to complete.

table = client.get_table(table_id)  # Make an API request.
print(
    "Loaded {} rows and {} columns to {}".format(
        table.num_rows, len(table.schema), table_id
    )
)