{{ config(materialized='table') }}

-- SQL query to transform and cast data types
SELECT
    CAST(nconst AS VARCHAR) AS nconst,  
    CAST(primaryName AS VARCHAR) AS primaryName,
    CAST(birthYear AS YEAR) AS birthYear,   
    CAST(deathYear AS YEAR) AS deathYear,
    CAST(primaryProfession AS VARCHAR) AS primaryProfession,
    CAST(knownForTitles AS VARCHAR) AS knownForTitles
FROM {{ ref('name_basics') }}

SET foreign_key_checks = 0;

-- Define primary key constraint
ALTER TABLE {{ this }} 
ADD CONSTRAINT pk_{{ this }} PRIMARY KEY (nconst);

SET foreign_key_checks = 1;