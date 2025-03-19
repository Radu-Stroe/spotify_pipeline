{{ config(materialized='table') }}

WITH artists AS (
    SELECT DISTINCT
        artists,
        TO_HEX(MD5(artists)) AS artist_id
    FROM {{ ref('stg_spotify') }}
)

SELECT * FROM artists