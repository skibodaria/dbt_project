WITH flights_daily AS (
    SELECT
        flight_date,
        dest,
        COUNT(*) AS total_flights,
        SUM(COALESCE(cancelled, 0)) AS cancelled_flights,
        SUM(COALESCE(diverted, 0)) AS diverted_flights,
        ROUND(SUM(COALESCE(cancelled, 0)) * 100.0 / COUNT(*), 2) AS cancellation_rate,
        ROUND(SUM(COALESCE(diverted, 0)) * 100.0 / COUNT(*), 2) AS diverted_rate,
        AVG(dep_delay) AS avg_dep_delay,
        AVG(arr_delay) AS avg_arr_delay
    --FROM {{ ref('prep_flights') }}
    FROM prep_flights
    WHERE dest IN ('JFK','ALT','BOS', 'EWR', 'ORD')
    GROUP BY flight_date, dest
),
weather_daily AS (
    SELECT
        airport_code AS dest,
        date,
        avg_temp_c,
        min_temp_c,
        max_temp_c,
        precipitation_mm,
        max_snow_mm,
        avg_wind_speed,
        avg_peakgust
    --FROM {{ ref('prep_weather_daily') }}
    FROM prep_weather_daily
),
joined AS (
    SELECT
        f.flight_date,
        f.dest,
        f.total_flights,
        f.cancelled_flights,
        f.diverted_flights,
        f.cancellation_rate,
        f.diverted_rate,
        f.avg_dep_delay,
        f.avg_arr_delay,
        w.avg_temp_c,
        w.min_temp_c,
        w.max_temp_c,
        w.precipitation_mm,
        w.max_snow_mm,
        w.avg_wind_speed,
        w.avg_peakgust
        /*CASE
            WHEN f.flight_date BETWEEN '2022-12-01' AND '2022-12-31' THEN 'event'
            ELSE 'not event'
        END AS period_type*/
    FROM flights_daily f
    LEFT JOIN weather_daily w
        ON f.dest = w.dest
       AND f.flight_date = w.date
)
SELECT *
FROM joined
ORDER BY flight_date, dest