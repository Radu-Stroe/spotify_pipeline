{{ config(materialized='table') }}

WITH base AS (
    SELECT
        f.spotify_id,
        s.song_name,
        f.country_id,
        f.date_id,
        f.daily_rank,
        f.popularity
    FROM {{ ref('fact_spotify_rankings') }} f
    LEFT JOIN {{ ref('dim_songs') }} s ON f.spotify_id = s.spotify_id
)

SELECT * FROM base