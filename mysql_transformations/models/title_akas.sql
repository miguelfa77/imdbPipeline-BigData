-- title_akas.sql

-- Define the model with the desired materialization (e.g., table)
{{ config(materialized='table') }}

-- SQL query to transform and cast data types
SELECT
    CAST(titleId AS VARCHAR) AS titleId,
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

-- Define primary key constraint
{% set pk_columns = ["titleId"] %}
ALTER TABLE {{ this }} 
ADD CONSTRAINT pk_{{ this }} PRIMARY KEY ({{ pk_columns | join(', ') }});
