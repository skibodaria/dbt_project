SELECT COUNT(*) FROM flights_all WHERE cancelled = 1 AND origin = 'JFK' AND YEAR = 2022 AND MONTH = 12; -- 297


SELECT 
	COUNT(sched_dep_time),
	SUM(CASE WHEN cancelled = 1 THEN 1 END),
	(SUM(CASE WHEN cancelled = 1 THEN 1 END) * 100) / COUNT(sched_dep_time)
FROM flights_all
WHERE YEAR = 2022 AND MONTH = 12; -- 3%

SELECT 
	COUNT(sched_dep_time),
	SUM(CASE WHEN cancelled = 1 THEN 1 END),
	(SUM(CASE WHEN cancelled = 1 THEN 1 END) * 100) / COUNT(sched_dep_time)
FROM flights_all
WHERE YEAR = 2022 AND MONTH = 2; -- 5%

SELECT 
	COUNT(sched_dep_time),
	SUM(CASE WHEN cancelled = 1 THEN 1 END),
	(SUM(CASE WHEN cancelled = 1 THEN 1 END) * 100) / COUNT(sched_dep_time)
FROM flights_all
WHERE YEAR = 2022 AND flight_date = '2022-12-22'; -- 14%

SELECT 
	flight_date,
	origin,
	COUNT(*),
	SUM(COALESCE(CASE WHEN cancelled = 1 THEN 1 END)),
	(SUM(COALESCE(CASE WHEN cancelled = 1 THEN 1 END)) * 100) / COALESCE(COUNT(sched_dep_time))
FROM flights_all
WHERE YEAR = 2022 AND MONTH = 12 AND flight_date BETWEEN '2022-12-10' AND '2022-12-31'
	AND origin IN ('JFK', 'BOS', 'EWR', 'ORD', 'ATL')
GROUP BY origin, flight_date
ORDER BY flight_date, origin;

-- December:
-- Origin + cancelled
SELECT 
    flight_date,
    origin,
    COUNT(COALESCE(sched_dep_time,0)) AS total_flights,
    --COUNT(cancelled) AS count_cancelled,
    SUM(COALESCE(cancelled, 0)) AS cancelled_flights,
    SUM(cancelled) AS no_coal_cancelled,
    SUM(diverted) AS diverted_flights,
    (SUM(Coalesce(cancelled,0))::numeric * 100) / COUNT(COALESCE(sched_dep_time,0)) AS cancellation_rate
    --(SUM(diverted)::numeric * 100) / COUNT(sched_dep_time) AS divers_rate
FROM flights_all
WHERE YEAR = 2022 
    AND MONTH = 12 
    AND flight_date BETWEEN '2022-12-10' AND '2022-12-31'
    AND origin IN ('JFK', 'BOS', 'EWR', 'ORD', 'ATL')
GROUP BY flight_date, origin
ORDER BY flight_date, origin;


SELECT 
    flight_date,
    origin,
    COUNT(*) AS total_flights,
    --COUNT(cancelled) AS count_cancelled,
    SUM(COALESCE(cancelled, 0)) AS cancelled_flights,
    SUM(cancelled) AS no_coal_cancelled,
    SUM(diverted) AS diverted_flights,
    (SUM(Coalesce(cancelled,0))::numeric * 100) / COUNT(*) AS cancellation_rate
    --(SUM(diverted)::numeric * 100) / COUNT(sched_dep_time) AS divers_rate
FROM flights_all
WHERE YEAR = 2022 
    AND MONTH = 12 
    AND flight_date BETWEEN '2022-12-10' AND '2022-12-31'
    AND origin IN ('JFK', 'BOS', 'EWR', 'ORD', 'ATL')
GROUP BY flight_date, origin
ORDER BY flight_date, origin;






-- December
-- Dest + diverted >> we can skip it
SELECT 
    flight_date,
    dest,
    COUNT(sched_arr_time) AS total_flights_arr,
    --COUNT(cancelled) AS count_cancelled,
    SUM(COALESCE(diverted, 0)) AS diverted_flights,
    SUM(diverted) AS no_coal_diverted,
    SUM(diverted) AS diverted_flights,
    -- Casting to numeric to avoid integer division (result: 0)
    (SUM(diverted)::numeric * 100) / COUNT(sched_arr_time) AS diverted_rate
FROM flights_all
WHERE YEAR = 2022 
    AND MONTH = 12 
    AND flight_date BETWEEN '2022-12-10' AND '2022-12-31'
    AND dest IN ('JFK', 'BOS', 'EWR', 'ORD', 'ATL')
GROUP BY flight_date, dest
ORDER BY flight_date, dest;


-- February
SELECT 
	origin,
	flight_date,
	COUNT(sched_dep_time),
	SUM(CASE WHEN cancelled = 1 THEN 1 END),
	(SUM(CASE WHEN cancelled = 1 THEN 1 END) * 100) / COUNT(sched_dep_time)
FROM flights_all
WHERE YEAR = 2022 AND MONTH = 2 AND flight_date BETWEEN '2022-02-22' AND '2022-02-28'
	AND origin IN ('JFK', 'BOS', 'EWR', 'ORD', 'ATL')
GROUP BY dest, flight_date
ORDER BY flight_date, dest;


SELECT COUNT(*) FROM flights_all WHERE cancelled = 1 AND origin = 'BOS' AND YEAR = 2022 AND MONTH = 12; -- 352



SELECT COUNT(*) FROM flights_all WHERE cancelled = 1 AND origin = 'EWR' AND YEAR = 2022 AND MONTH = 12; -- 311



SELECT COUNT(*) FROM flights_all WHERE cancelled = 1 AND origin = 'ORD' AND YEAR = 2022 AND MONTH = 12; -- 787


SELECT COUNT(*) FROM flights_all WHERE cancelled = 1 AND origin = 'ATL' AND YEAR = 2022 AND MONTH= 12; -- 41
SELECT COUNT(*) FROM flights_all WHERE diverted = 1 AND origin = 'ATL' AND YEAR = 2022 AND MONTH= 12; -- 0
