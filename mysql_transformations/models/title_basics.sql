-- title_basics.sql

-- Define the model with the desired materialization (e.g., table)
{{ config(materialized='table') }}

-- SQL query to transform and cast data types
SELECT
    CAST(tconst AS VARCHAR) AS tconst,
    CAST(titleType AS VARCHAR) AS titleType,
    CAST(primaryTitle AS VARCHAR) AS primaryTitle,
    CAST(originalTitle AS VARCHAR) AS originalTitle,
    CASE
        WHEN isAdult = 1 THEN TRUE
        ELSE FALSE
    END AS isAdult,
    CAST(startYear AS YEAR) AS startYear,
    CAST(endYear AS YEAR) AS endYear,
    CAST(runtimeMinutes AS INT) AS runtimeMinutes,
    CAST(genres AS VARCHAR) AS genres
FROM {{ ref('title_basics') }}


SET foreign_key_checks = 0;

-- Define primary key constraint
ALTER TABLE {{ this }} 
ADD CONSTRAINT pk_{{ this }} PRIMARY KEY (tconst, genres);

SET foreign_key_checks = 1;
