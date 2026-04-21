WITH airports_reorder AS (
    SELECT
        faa,
        name,
        city,
        lat,
        lon,
        alt,
        tz,
        dst
    FROM {{ source('project_data','airports') }}
)
SELECT *
FROM airports_reorder