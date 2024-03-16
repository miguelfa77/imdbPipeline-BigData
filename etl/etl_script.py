import pandas as pd
from sqlalchemy import create_engine
import mysql.connector
import requests
import io
import time

print("Initiating ETL pipeline...")

destination_config = {
    'dbname': 'imdb',
    'user': 'user',
    'password': 'password',
    'host': 'destination_mysql'
}

def wait_for_mysql(host, max_retries=5, delay_seconds=5):
    """Wait for mySQL to become available."""
    retries = 0
    while retries < max_retries:
        try:
            engine = create_engine(
                f'mysql+mysqlconnector://{destination_config['user']}:{destination_config['password']}@{destination_config['host']}/{destination_config['dbname']}')
            print("Successfully connected to mySQL")
            return engine

        except Exception as e:
            print("Error connecting to mySQL:", e)
            retries += 1
            print(
                f"Retrying in {delay_seconds} seconds... (Attempt {retries}/{max_retries})")
            time.sleep(delay_seconds)
    print("Max retries reached. Exiting.")
    return False

engine = wait_for_mysql(host="destination_mysql")
if not engine:
    exit(1)


base_url = 'https://datasets.imdbws.com/'
file_names = [
    'name.basics',
    'title.akas',
    'title.basics',
    'title.crew',
    'title.episode',
    'title.principals',
    'title.ratings'
]

for file_name in file_names:
    url = f'https://datasets.imdbws.com/{file_name}.tsv.gz'
    response = requests.get(url)
    df = pd.read_csv(io.BytesIO(response.content), compression='gzip', sep='\t', low_memory=False, dtype='str', na_values="\\N")
    try:
        df.to_sql(name=file_name, con=engine, if_exists='replace', chunksize=1000)
        print(f'Filename {file_name}: Converted to SQL')
    except Exception as e:
        print("Error when converting df to mySQL:", e)


print("Successfully ran ETL pipeline")





