from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'airflow',
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
    'email': ['egiasuranta24@gmail.com'],          
    'email_on_failure': True,             
    'email_on_retry': False,              
    'depends_on_past': False,             
    'start_date': datetime(2024, 1, 1),  
}

with DAG(
    dag_id='dbt_pipeline',
    default_args=default_args,
    schedule_interval='0 0 * * *',
    start_date=datetime(2024, 1, 1),
    catchup=False
) as dag:

    dbt_run_bronze = BashOperator(
        task_id='dbt_run_bronze',
        bash_command='cd /opt/airflow/dbt && dbt run --select model/bronze/ --profiles-dir /opt/airflow/dbt'
    )

    dbt_run_silver = BashOperator(
        task_id = 'dbt_run_silver',
        bash_command='cd /opt/airflow/dbt && dbt run --select model/silver/ --profiles-dir /opt/airflow/dbt'
    )

    dbt_run_gold = BashOperator(
        task_id = 'dbt_run_gold',
        bash_command='cd /opt/airflow/dbt && dbt run --select model/gold/ --profiles-dir /opt/airflow/dbt'
    )

    dbt_test = BashOperator(
        task_id='dbt_test',
        bash_command='cd /opt/airflow/dbt && dbt test --profiles-dir /opt/airflow/dbt'
    )

    dbt_run_bronze >> dbt_run_silver >> dbt_run_gold >> dbt_test