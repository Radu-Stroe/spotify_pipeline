{{ config(materialized='table') }}

WITH ranked_songs AS (
    SELECT
        spotify_id,
        name AS song_name,
        album_name,
        album_release_date,
        danceability,
        energy,
        key,
        loudness,
        mode,
        speechiness,
        acousticness,
        instrumentalness,
        liveness,
        valence,
        tempo,
        time_signature,
        snapshot_date,
        ROW_NUMBER() OVER (PARTITION BY spotify_id ORDER BY snapshot_date DESC) AS row_num  -- ✅ Keep latest snapshot
    FROM {{ ref('stg_spotify') }}
)

SELECT
    spotify_id,
    song_name,
    album_name,
    album_release_date,
    danceability,
    energy,
    key,
    loudness,
    mode,
    speechiness,
    acousticness,
    instrumentalness,
    liveness,
    valence,
    tempo,
    time_signature
FROM ranked_songs
WHERE row_num = 1  -- ✅ Only keep the latest entry per song