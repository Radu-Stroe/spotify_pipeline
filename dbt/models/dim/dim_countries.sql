{{ config(materialized='table') }}

WITH countries AS (
    SELECT DISTINCT
        COALESCE(country, 'Global') AS country_id
    FROM {{ ref('stg_spotify') }}
)

SELECT * FROM countries