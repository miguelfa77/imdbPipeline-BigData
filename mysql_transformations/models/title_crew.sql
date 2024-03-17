-- title_crew.sql

-- Define the model with the desired materialization (e.g., table)
{{ config(materialized='table') }}

-- SQL query to transform and cast data types
SELECT
    CAST(tconst AS VARCHAR) AS tconst,
    CAST(directors AS VARCHAR) AS directors,
    CAST(writers AS VARCHAR) AS writers
FROM {{ ref('source_title_crew') }}



SET foreign_key_checks = 0;

-- Define primary key constraint
ALTER TABLE {{ this }} 
ADD CONSTRAINT pk_{{ this }} PRIMARY KEY (tconst);

-- Define foreign key constraint
ALTER TABLE {{ this }}
ADD CONSTRAINT fk_{{ this }}_title_crew FOREIGN KEY (tconst) 
REFERENCES {{ ref('title_ratings') }} (tconst);

SET foreign_key_checks = 1;