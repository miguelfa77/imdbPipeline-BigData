-- title_principals.sql

-- Define the model with the desired materialization (e.g., table)
{{ config(materialized='table') }}

-- SQL query to transform and cast data types
SELECT
    CAST(tconst AS VARCHAR) AS tconst,
    CAST(ordering AS INT) AS ordering,
    CAST(nconst AS VARCHAR) AS nconst,
    CAST(category AS VARCHAR) AS category,
    CAST(job AS VARCHAR) AS job,
    CAST(characters AS VARCHAR) AS characters
FROM {{ ref('title_principals') }}



SET foreign_key_checks = 0;

-- Define primary key constraint
ALTER TABLE {{ this }} 
ADD CONSTRAINT pk_{{ this }} PRIMARY KEY (tconst, nconst);

-- Define foreign key constraints
ALTER TABLE {{ this }}
ADD CONSTRAINT fk_{{ this }}_title_principals FOREIGN KEY (tconst) 
REFERENCES {{ ref('title_ratings') }} (tconst);

ALTER TABLE {{ this }}
ADD CONSTRAINT fk_{{ this }}_title_principals FOREIGN KEY (nconst) 
REFERENCES {{ ref('name_basics') }} (nconst);

SET foreign_key_checks = 1;
