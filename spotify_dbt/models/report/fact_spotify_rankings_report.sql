{{ config(materialized='table') }}

SELECT
  date_id,
  country_id,
  COUNT(DISTINCT spotify_id) AS song_count
FROM {{ ref('fact_spotify_rankings') }}
WHERE country_id IS NOT NULL
GROUP BY date_id, country_id