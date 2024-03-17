-- title_crew.sql

-- Define the model with the desired materialization (e.g., table)
{{ config(materialized='table') }}

-- SQL query to transform and cast data types
SELECT
    CAST(tconst AS VARCHAR) AS tconst,
    CAST(directors AS VARCHAR) AS directors,
    CAST(writers AS VARCHAR) AS writers
FROM {{ ref('source_title_crew') }}

-- Define primary key constraint
{% set pk_columns = ["tconst"] %}
ALTER TABLE {{ this }} 
ADD CONSTRAINT pk_{{ this }} PRIMARY KEY ({{ pk_columns | join(', ') }});

-- Define foreign key constraint
ALTER TABLE {{ this }}
ADD CONSTRAINT fk_{{ this }}_title_crew FOREIGN KEY (tconst) 
REFERENCES {{ ref('title_ratings') }} (tconst);