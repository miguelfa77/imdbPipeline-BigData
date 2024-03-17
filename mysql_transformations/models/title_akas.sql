-- title_akas.sql

-- Define the model with the desired materialization (e.g., table)
{{ config(materialized='table') }}

-- SQL query to transform and cast data types
SELECT
    CAST(titleId AS VARCHAR) AS tconst,
    CAST(ordering AS INT) AS ordering,
    CAST(title AS VARCHAR) AS title,
    CAST(region AS VARCHAR) AS region,
    CAST(language AS VARCHAR) AS language,
    CAST(types AS VARCHAR) AS types,
    CAST(attributes AS VARCHAR) AS attributes,
    CASE
        WHEN isOriginalTitle = 1 THEN TRUE
        ELSE FALSE
    END AS isOriginalTitle
FROM {{ ref('title_akas') }}



SET foreign_key_checks = 0;

-- Define primary key constraint
ALTER TABLE {{ this }} 
ADD CONSTRAINT pk_{{ this }} PRIMARY KEY (tconst);

-- Define foreign key constraint
ALTER TABLE {{ this }}
ADD CONSTRAINT fk_{{ this }}_title_akas FOREIGN KEY (tconst) 
REFERENCES {{ ref('title_ratings') }} (tconst);

ALTER TABLE {{ this }}
ADD CONSTRAINT fk_{{ this }}_title_akas FOREIGN KEY (ordering) 
REFERENCES {{ ref('title_principals') }} (ordering);

SET foreign_key_checks = 1;

