{{ config(materialized='table') }}

WITH enriched AS (
    SELECT
        f.spotify_id,
        s.song_name,
        s.album_name,
        s.album_release_date,

        f.artist_id,
        a.artists AS artist_name,

        f.country_id,
        f.date_id,
        d.year,
        d.month,
        d.day,
        d.day_of_week,

        f.daily_rank,
        f.popularity,
        f.is_explicit,
        f.duration_ms
    FROM {{ ref('fact_spotify_rankings') }} f
    LEFT JOIN {{ ref('dim_songs') }} s ON f.spotify_id = s.spotify_id
    LEFT JOIN {{ ref('dim_artists') }} a ON f.artist_id = a.artist_id
    LEFT JOIN {{ ref('dim_dates') }} d ON f.date_id = d.date_id
),

song_presence_flags AS (
    SELECT
        spotify_id,
        MAX(CASE WHEN country_id = 'Global' THEN 1 ELSE 0 END) AS is_global,
        MAX(CASE WHEN country_id != 'Global' THEN 1 ELSE 0 END) AS is_local
    FROM enriched
    GROUP BY spotify_id
),

classification AS (
    SELECT
        spotify_id,
        CASE
            WHEN is_global = 1 AND is_local = 1 THEN 'Global & Local'
            WHEN is_global = 1 AND is_local = 0 THEN 'Global Only'
            WHEN is_global = 0 AND is_local = 1 THEN 'Local Only'
            ELSE 'Unclassified'
        END AS global_local_class
    FROM song_presence_flags
)

SELECT
    e.spotify_id,
    e.song_name,
    e.album_name,
    e.album_release_date,
    e.artist_id,
    e.artist_name,
    e.country_id,
    e.date_id,
    e.year,
    e.month,
    e.day,
    e.day_of_week,
    e.daily_rank,
    e.popularity,
    e.is_explicit,
    e.duration_ms,
    c.global_local_class
FROM enriched e
LEFT JOIN classification c ON e.spotify_id = c.spotify_id