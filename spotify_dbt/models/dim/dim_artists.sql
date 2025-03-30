{{ config(materialized='table') }}

WITH artists AS (
    SELECT DISTINCT
        artist_name,
        TO_HEX(MD5(artist_name)) AS artist_id
    FROM {{ ref('stg_spotify') }}
)

SELECT * FROM artists