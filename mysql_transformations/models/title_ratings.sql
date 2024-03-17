-- title_ratings.sql

-- Define the model with the desired materialization (e.g., table)
{{ config(materialized='table') }}

-- SQL query to transform and cast data types
SELECT
    CAST(tconst AS VARCHAR) AS tconst,
    CAST(averageRating AS FLOAT) AS averageRating,
    CAST(numVotes AS BIGINT) AS numVotes
FROM {{ ref('title_ratings') }}



SET foreign_key_checks = 0;

-- Define primary key constraint
ALTER TABLE {{ this }} 
ADD CONSTRAINT pk_{{ this }} PRIMARY KEY (tconst);

SET foreign_key_checks = 1;
