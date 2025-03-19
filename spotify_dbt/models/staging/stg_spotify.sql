WITH ranked_spotify AS (
    SELECT
        spotify_id,
        name,
        artists,
        COALESCE(country, 'GLOBAL') AS country,
        snapshot_date,
        daily_rank,
        daily_movement,
        weekly_movement,
        popularity,
        is_explicit,
        duration_ms,
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
        ROW_NUMBER() OVER (
            PARTITION BY spotify_id, snapshot_date
            ORDER BY daily_rank ASC, country ASC
        ) AS rank_order
    FROM `spotify-sandbox-453505.spotify_radu_dataset.spotify_top_songs`
)

SELECT *
FROM ranked_spotify
WHERE rank_order = 1  -- ✅ Keeps only the highest-ranked version per song per day