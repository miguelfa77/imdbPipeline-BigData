{{ config(materialized='table') }}

-- SQL query to transform and cast data types
SELECT
    CAST(nconst AS VARCHAR) AS nconst,  -- Assuming you want to cast text to VARCHAR
    CAST(primaryName AS VARCHAR) AS primaryName,
    CAST(birthYear AS YEAR) AS birthYear,    -- Assuming you want to cast double to FLOAT
    CAST(deathYear AS YEAR) AS deathYear,
    CAST(primaryProfession AS VARCHAR) AS primaryProfession,
    CAST(knownForTitles AS VARCHAR) AS knownForTitles
FROM {{ ref('name_basics') }}

-- Define primary key constraint
{% set pk_columns = ["nconst"] %}  -- Assuming column1 is the primary key
ALTER TABLE {{ this }} 
ADD CONSTRAINT pk_{{ this }} PRIMARY KEY ({{ pk_columns | join(', ') }});