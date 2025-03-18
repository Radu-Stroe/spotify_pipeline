{{ config(materialized='table') }}

WITH dates AS (
    SELECT DISTINCT
        snapshot_date AS date_id,
        EXTRACT(YEAR FROM snapshot_date) AS year,
        EXTRACT(MONTH FROM snapshot_date) AS month,
        EXTRACT(DAY FROM snapshot_date) AS day,
        FORMAT_DATE('%A', snapshot_date) AS day_of_week
    FROM {{ ref('stg_spotify') }}
)

SELECT * FROM dates