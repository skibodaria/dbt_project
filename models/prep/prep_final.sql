WITH departures AS (
    SELECT 
    	origin, 
    	flight_date, 
    	COUNT(*) AS flights_out,
    	SUM(COALESCE(cancelled, 0)) AS cancelled_flights_o,
        SUM(COALESCE(diverted, 0)) AS diverted_flights_o,
        ROUND(SUM(COALESCE(cancelled, 0)) * 100.0 / COUNT(*), 2) AS cancellation_rate_o,
        ROUND(SUM(COALESCE(diverted, 0)) * 100.0 / COUNT(*), 2) AS diverted_rate_o,
        AVG(dep_delay)* INTERVAL '1 min' AS avg_dep_delay_o
        --AVG(arr_delay)* INTERVAL '1 min' AS avg_arr_delay_o
    --FROM prep_flights
    FROM{{ref('prep_flights')}}
    WHERE origin IN ('JFK','ATL','BOS', 'EWR', 'ORD')
      AND flight_date BETWEEN '2022-12-01' AND '2022-12-31'
    GROUP BY origin, flight_date
),
arrivals AS (
    SELECT 
    	dest, 
    	flight_date, 
    	COUNT(*) AS flights_in,
    	SUM(COALESCE(cancelled, 0)) AS cancelled_flights_d,
        SUM(COALESCE(diverted, 0)) AS diverted_flights_d,
        ROUND(SUM(COALESCE(cancelled, 0)) * 100.0 / COUNT(*), 2) AS cancellation_rate_d,
        ROUND(SUM(COALESCE(diverted, 0)) * 100.0 / COUNT(*), 2) AS diverted_rate_d,
        --AVG(dep_delay)* INTERVAL '1 min' AS avg_dep_delay_d,
        AVG(arr_delay)* INTERVAL '1 min' AS avg_arr_delay_d
    FROM{{ref('prep_flights')}} 
    WHERE dest IN ('JFK','ATL','BOS', 'EWR', 'ORD')
      AND flight_date BETWEEN '2022-12-01' AND '2022-12-31'
    GROUP BY dest, flight_date
), 
airport_stats AS (
	SELECT
		d.origin AS airport_code,
		d.flight_date AS date,
		d.count_out,
		a.count_in,
		d.count_out + a.count_in AS total_flights,
		d.cancellation_rate_o AS origin_cancelled_rate,
		a.cancellation_rate_d AS dest_cancelled_rate,
		d.cancelled_flights_o + a.cancelled_flights_d AS total_cancelled_num,
		d.diverted_flights_o + a.diverted_flights_d AS total_diverted_num,
		d.diverted_rate_o AS origin_diverted_rate,
		a.diverted_rate_d AS dest_diverted_rate,
		d.avg_dep_delay_o AS avg_dep_delay,
		a.avg_arr_delay_d AS avg_arr_delay
	FROM departures d
	JOIN arrivals a ON d.origin = a.dest AND d.flight_date=a.flight_date
	)
SELECT *
	FROM airport_stats AS astat
JOIN {{ref('staging_weather_daily')}}  AS w
	USING (airport_code, date)
ORDER BY date, astat.airport_code