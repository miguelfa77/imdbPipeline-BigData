-- title_ratings.sql

-- Define the model with the desired materialization (e.g., table)
{{ config(materialized='table') }}

-- SQL query to transform and cast data types
SELECT
    CAST(tconst AS VARCHAR) AS tconst,
    CAST(averageRating AS FLOAT) AS averageRating,
    CAST(numVotes AS BIGINT) AS numVotes
FROM {{ ref('title_ratings') }}

-- Define primary key constraint
{% set pk_columns = ["tconst"] %}
ALTER TABLE {{ this }} 
ADD CONSTRAINT pk_{{ this }} PRIMARY KEY ({{ pk_columns | join(', ') }});
