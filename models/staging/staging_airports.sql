WITH airports_regions_join AS (
    SELECT * 
    FROM {{source('project_data', 'airports')}}
    LEFT JOIN {{source('project_data', 'regions')}}
    USING (country)
)
SELECT * FROM airports_regions_join