from airflow.decorators import dag, task
from datetime import datetime
from astro import sql as aql
from astro.files import File
from astro.sql.table import Table, Metadata
from astro.constants import FileType
from airflow.providers.google.cloud.transfers.local_to_gcs import LocalFilesystemToGCSOperator
from airflow.providers.google.cloud.operators.bigquery import BigQueryCreateEmptyDatasetOperator

import sqlalchemy
from sqlalchemy import Float, String

@dag(
    start_date=datetime(2023, 1, 1),
    schedule=None,
    catchup=False,
    tags=['sales'],
)

def sales():

    upload_csv_to_gcs = LocalFilesystemToGCSOperator(
        task_id='upload_csv_to_gcs',
        src='include/dataset/sales.csv',
        dst='raw/sales.csv',
        bucket='yalo_sales_project',
        gcp_conn_id='gcp',
        mime_type='text/csv',
    )

    create_retail_dataset = BigQueryCreateEmptyDatasetOperator(
        task_id='create_retail_dataset',
        dataset_id='sales',
        gcp_conn_id='gcp',
    )
    
    gcs_to_raw = aql.load_file(
        task_id='gcs_to_raw',
        input_file=File(
            'gs://yalo_sales_project/raw/sales.csv',
            conn_id='gcp',
            filetype=FileType.CSV,

        ),
        output_table=Table(
            name='raw_sales',
            conn_id='gcp',
            metadata=Metadata(schema='sales')
        ),
        use_native_support=False,
    )

    @task.external_python(python='/usr/local/airflow/soda_venv/bin/python')
    def check_load(scan_name='check_load', checks_subpath='sources'):
        from include.soda.check_function import check

        return check(scan_name, checks_subpath)

    check_load()

sales()