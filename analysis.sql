-- analysis.sql
-- Queries that profile existing luxury gym locations using the same variables
-- the research paper's logistic regression found predictive of gym presence:
-- population density and median home value (significant), vs. income and
-- age/sex cohorts (not significant). This SQL analysis validates that profile
-- against the actual existing locations, ahead of evaluating new candidate
-- zip codes (93550, 93552, 90280, 90201, 91792 from the paper's recommendation).

-- 1. Baseline profile: average characteristics across ALL existing luxury gym
--    zip codes. This is the target profile a new zip code should resemble.
SELECT
    ROUND(AVG(median_household_income), 0) AS avg_income,
    ROUND(AVG(population_density), 0)      AS avg_density_per_sqmi,
    ROUND(AVG(median_home_value), 0)       AS avg_home_value,
    ROUND(AVG(population), 0)              AS avg_population
FROM gym_locations;

-- 2. Profile by franchise: how does each brand's typical location differ?
--    (paper frames each franchise as a distinct luxury-fitness segment)
SELECT
    franchise,
    COUNT(*)                                AS num_locations,
    ROUND(AVG(median_household_income), 0)  AS avg_income,
    ROUND(AVG(population_density), 0)       AS avg_density_per_sqmi,
    ROUND(AVG(median_home_value), 0)        AS avg_home_value
FROM gym_locations
GROUP BY franchise
ORDER BY avg_home_value DESC;

-- 3. Zip codes with MULTIPLE franchises present. The paper treats "gym
--    presence" as binary, but zip codes with 2+ competing brands are a
--    stronger signal of a proven, saturated luxury-fitness market.
SELECT
    zipcode,
    city,
    COUNT(DISTINCT franchise) AS num_franchises,
    GROUP_CONCAT(DISTINCT franchise) AS franchises_present
FROM gym_locations
GROUP BY zipcode, city
HAVING num_franchises > 1
ORDER BY num_franchises DESC;

-- 4. Top 10 existing zip codes ranked by density + home value combined,
--    the two variables the paper's model found statistically significant
--    (p = 0.038 and p = 0.095 respectively). Income (p = 0.8) is included
--    for reference only, since the paper found it was NOT a significant
--    predictor despite the intuitive assumption that it would be.
SELECT
    zipcode,
    city,
    franchise,
    population_density,
    median_home_value,
    median_household_income
FROM gym_locations
ORDER BY population_density DESC, median_home_value DESC
LIMIT 10;

-- 5. City-level comparison: average profile per metro area. The paper
--    focuses on LA specifically, so this shows how LA's existing gym zip
--    codes compare to SF/Bay Area and NYC as external reference points.
SELECT
    city,
    COUNT(*)                                AS num_locations,
    ROUND(AVG(median_household_income), 0)  AS avg_income,
    ROUND(AVG(population_density), 0)       AS avg_density_per_sqmi,
    ROUND(AVG(median_home_value), 0)        AS avg_home_value
FROM gym_locations
GROUP BY city
ORDER BY avg_home_value DESC;
