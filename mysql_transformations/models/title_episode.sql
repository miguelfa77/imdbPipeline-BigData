-- title_episode.sql

-- Define the model with the desired materialization (e.g., table)
{{ config(materialized='table') }}

-- SQL query to transform and cast data types
SELECT
    CAST(tconst AS VARCHAR) AS tconst,
    CAST(parentTconst AS VARCHAR) AS parentTconst,
    CAST(seasonNumber AS INT) AS seasonNumber,
    CAST(episodeNumber AS INT) AS episodeNumber
FROM {{ ref('source_title_episode') }}



SET foreign_key_checks = 0;

-- Define primary key constraint
ALTER TABLE {{ this }} 
ADD CONSTRAINT pk_{{ this }} PRIMARY KEY (tconst, parentTconst);

-- Define foreign key constraint
ALTER TABLE {{ this }}
ADD CONSTRAINT fk_{{ this }}_parentTconst FOREIGN KEY (parentTconst) 
REFERENCES {{ ref('title_ratings') }} (tconst);

ALTER TABLE {{ this }}
ADD CONSTRAINT fk_{{ this }}_tconst FOREIGN KEY (tconst) 
REFERENCES {{ ref('title_ratings') }} (tconst);

SET foreign_key_checks = 1;
