import pandas as pd
import os
import mysql.connector
import requests
import io

print("Initiating ETL pipeline...")


destination_mysql_config = {
    'dbname': 'imdb',
    'user': 'user',
    'password': 'password',
    'host': 'destination_mysql'
}

conn = mysql.connector.connect(
    user=destination_mysql_config['user'],
    password=destination_mysql_config['password'],
    host=destination_mysql_config['host'],
    database=destination_mysql_config['dbname']
)

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
    df.to_sql(name=file_name, engine=conn, if_exists='replace')
    print(f'Filename {file_name}: Converted to SQL')



print("Successfully ran ETL pipeline")





