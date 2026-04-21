{{ config(materialized='table') }}

WITH flights_daily AS (
    SELECT
        flight_date,
        origin AS faa,
        COUNT(*) AS total_flights,
        SUM(COALESCE(cancelled, 0)) AS cancelled_flights,
        SUM(COALESCE(diverted, 0)) AS diverted_flights,
        ROUND(SUM(COALESCE(cancelled, 0)) * 100.0 / COUNT(*), 2) AS cancellation_rate,
        AVG(dep_delay) AS avg_dep_delay,
        AVG(arr_delay) AS avg_arr_delay
    FROM {{ ref('prep_flights') }}
    GROUP BY flight_date, origin
),

weather_daily AS (
    SELECT
        faa,
        date,
        avg_temp,
        min_temp,
        max_temp,
        precipitation,
        snow,
        wind_speed,
        wind_peak_gust
    FROM {{ ref('prep_weather_daily') }}
),

joined AS (
    SELECT
        f.flight_date,
        f.faa,
        f.total_flights,
        f.cancelled_flights,
        f.diverted_flights,
        f.cancellation_rate,
        f.avg_dep_delay,
        f.avg_arr_delay,
        w.avg_temp,
        w.min_temp,
        w.max_temp,
        w.precipitation,
        w.snow,
        w.wind_speed,
        w.wind_peak_gust,
        CASE
            WHEN f.flight_date BETWEEN '2022-12-22' AND '2022-12-28' THEN 'event'
            ELSE 'non_event'
        END AS period_type
    FROM flights_daily f
    LEFT JOIN weather_daily w
        ON f.faa = w.faa
       AND f.flight_date = w.date
)

SELECT *
FROM joined
ORDER BY flight_date, faa