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
file_names = {
    'name.basics': 'name_basics',
    'title.akas': 'title_akas',
    'title.basics': 'title_basics',
    'title.crew': 'title_crew',
    'title.episode': 'title_episode',
    'title.principals': 'title_principals',
    'title.ratings': 'title_ratings'
}

CHUNKSIZE = 100000
for file_name in file_names.keys():
    url = f'https://datasets.imdbws.com/{file_name}.tsv.gz'
    response = requests.get(url)
    chunks = pd.read_csv(io.BytesIO(response.content), compression='gzip', sep='\t', low_memory=False, na_values="\\N",chunksize=CHUNKSIZE)
    first_chunk = True
    for chunk in chunks:
        try:
            if first_chunk:
                chunk.to_sql(name=file_names[file_name], con=engine, if_exists='replace', index=False, chunksize=CHUNKSIZE)
                first_chunk = False
            else:
                chunk.to_sql(name=file_names[file_name], con=engine, if_exists='append', index=False, chunksize=CHUNKSIZE)
        except Exception as e:
            print("Error when converting df to mySQL:", e)
            break
    print(f'Filename {file_name}: Converted to SQL')


print("Successfully ran ETL pipeline")





