{{ config(
    materialized='incremental',
    unique_key='spotify_id',
    partition_by={"field": "date_id", "data_type": "DATE"},
    cluster_by=["country_id"]
) }}

WITH rankings AS (
    SELECT
        s.spotify_id,
        a.artist_id,
        c.country_id,
        d.date_id,
        s.daily_rank,
        s.daily_movement,
        s.weekly_movement,
        s.popularity,
        s.is_explicit,
        s.duration_ms
    FROM {{ ref('stg_spotify') }} s
    LEFT JOIN {{ ref('dim_artists') }} a ON s.artist_name = a.artist_name
    LEFT JOIN {{ ref('dim_countries') }} c ON s.country = c.country_id
    LEFT JOIN {{ ref('dim_dates') }} d ON s.snapshot_date = d.date_id
    {% if is_incremental() %}
    WHERE s.snapshot_date > (SELECT MAX(date_id) FROM {{ this }})
    {% endif %}
)

SELECT * FROM rankings