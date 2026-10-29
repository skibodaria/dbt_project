# `dbt`Project | Winter Storm Elliot (2022) and Its Effects on Airport Performances
During the `dbt` module as a part of curriculum at [Spiced Academy / neuefische GmbH] our team executed a research project. The goal was to identify a particular weather event and see how it affected the performance of several airports (flights' delays and cancellations).<br>

The project was executed by:
* [Kai Nägle](https://github.com/kainaegle)
* [Eido Alkobi](https://github.com/EidoAlkobi)
* [Daria Skibo](https://github.com/skibodaria)

## Time & Geographical Scope
### Weather event:

During Winter Storm Elliott (December 21–28, 2022), a massive "bomb cyclone" and "flash freeze" devastated U.S. aviation. Temperatures plunged by $15$ to $20^\circ\text{C}$ in hours, turning wet runways into ice sheets. Combined with hurricane-force winds, the storm paralyzed the busiest travel week of the year.

### Airports:
|Airport|Primary Weather Impact|Operational Result|
|---|-----|--------|
|ORD (Chicago)|Blizzard & −40∘C wind chills|800+ flights cancelled early in the event|
|JFK (New York)|100 km/h winds & record cold|25%+ cancellation rate on peak days|
|EWR (Newark)|Flash freeze & infrastructure failure|Massive delays due to frozen ground equipment|
|BOS (Boston)|Coastal flooding & heavy snow|64% of schedule grounded on the worst day|
|ATL (Atlanta)|Freezing rain in a southern hub|500+ daily cancellations; huge ripple effect|

## Project Workflow & Architecture
### Data Extraction
1. **Weather Data**: Pulled historical meteorological records (temperature, wind speed, precipitation) via the [Meteostat API](https://dev.meteostat.net/api).
2. **Flight Data**: Extracted [US domestic flight](https://transtats.bts.gov) performance metrics, focusing on cancellations and delays.

### Infrastructure & Version Control
1. **Repository Management**: Initialized a new GitHub repository for version control
2. **`dbtCloud`**: Connected the repository to `dbt Cloud` to enable version-controlled data transformations and documentation

### Data Transformation (`dbt Cloud`)
1. **Staging Layer**: Created cleaned, standardized views of raw data + dropped several staging tables later. Used `DBeaver` to control results
2. **Preparation Layer**: Developed `prep_final` model to join weather and flight datasets on a shared date/airport columns

### Analysis & Insights (`PostgreSQL` + Python)
1. **Exploratory Data Analysi**s** (EDA): Used  Python to connect to the `PostgreSQL` data warehouse
2. **Hypothesis Testing**: Conducted Welch’s t-tests and calculated 95% Confidence Intervals to statistically validate the impact of the storm (temperature and wind spead mainly).
3. **Data Visualization**: Built correlation heatmaps and time-series trend lines using `Seaborn` and `Matplotlib` to communicate findings

## Main Conclusions
* The Winter Storm Elliot is visible in the weather data as a deviation in temperature between the event and non-event records;
    * to test this, we split the data for `event`(December 22-28, 2022) and `non-event`(all other dates) records and compared average temperatures in these two groups;
    * test: Welch's t-test;
    * mean temperature during the `event`: -2.85°C; mean temperature durint `non-event`: 4.78°C; mean difference: -7.62°C; 95% confidence interval: [-10.21, -5.04]; t-statistic: -5.93; p-value < 0.001
    * what it means: statistically significant drop in temperature --> selected time window captures a real and impactful weather event;
* The Winter Storm had a significant effect on flight disruptions, mainly on the cancellation rate:
    * p-value < 0.05: the difference in flight cancellations/delays between the storm days and normal days was not due to random chance. The weather likely had a statistically significant impact;
* Heatmap for different weather conditions (average temperature, average wind speed, precipitation) shows:
    * strong negative correlation between temperature and delays/cancellations;
    * moderate positive colleration between average wind speed and disruptions;
    * surprise: precipitation has a very weak correlation with cancellations and delays.