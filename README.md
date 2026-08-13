# Luxury Fitness Studio Location Analysis

A SQL analysis of luxury boutique fitness studio locations (SoulCycle, Solidcore,
CorePower Yoga, CycleBar, Equinox), built to support a research project
identifying the optimal zip code for a new luxury fitness studio in Los Angeles.

## Background

Boutique fitness is one of the fastest-growing segments of the wellness
industry, projected to grow from ~$46B to ~$75B by 2030. This project analyzes
zip-code-level demographics (population density, median home value, median
household income) across 119 existing luxury studio locations in LA, the Bay
Area, and NYC to understand what makes a zip code attractive to these brands.

This SQL analysis supports a companion research paper that ran a logistic
regression across LA zip codes (population density, home value, income,
commute time, education, and age/sex cohorts) to predict the probability of
gym presence. The regression found:

- **Population density** was the strongest positive predictor (p = 0.038)
- **Median home value** was a positive but weaker predictor (p = 0.095)
- **Long commute times (60+ min)** were negatively associated with gym presence (p = 0.009)
- **Median household income** was, somewhat counterintuitively, *not* statistically significant (p = 0.8)
- Age and sex cohorts lost significance once education, commute, and income were controlled for

Based on the model, the paper recommends targeting zip codes **93550, 93552
(Palmdale), 90280 (South Gate), 90201 (Bell), and 91792 (West Covina)** as the
next-best candidates for a new studio.

## Files

- `schema.sql` — creates the `gym_locations` table
- `data/studio_zipcodes.csv` — 119 existing luxury studio locations with Census demographics
- `analysis.sql` — SQL queries profiling existing locations using the same variables the regression found predictive
- `README.md` — this file

## How to run it

1. Install [SQLite](https://www.sqlite.org/download.html).
2. `sqlite3 gyms.db`
3. Inside the sqlite3 prompt:
   ```
   .mode csv
   .import --skip 1 data/studio_zipcodes.csv gym_locations
   ```
   (Or run `schema.sql` first to define the table, then import.)
4. `sqlite3 gyms.db < analysis.sql`

## Key findings

- **Density validates the regression's top predictor**: Equinox and SoulCycle
  locations average ~46,000–53,000 people/sq mile, the highest of any brand —
  directly consistent with density being the model's strongest significant variable.
- **NYC zip codes are far denser than LA's** (~79,500 vs ~10,500 people/sq
  mile on average) despite LA having higher average income — a concrete
  illustration of why the model weighted density over income.
- **Several zip codes host 3 competing luxury brands at once** (e.g., NYC
  10011, 10012, 10028; LA 90069, 90232, 90292, 90401) — a strong signal of a
  proven, demand-validated luxury-fitness market, beyond just a binary
  "gym present" flag.
- **CorePower has the widest footprint** (41 locations) but the lowest average
  density (~29,400/sq mile) of the five brands, suggesting a different,
  less density-dependent expansion strategy than SoulCycle or Equinox.

## Limitations

Consistent with the companion paper: zip codes are an imperfect proxy for a
gym's true service area, the existing-location dataset doesn't include the
paper's other regression variables (commute time, education, age/sex
cohorts), and "presence of a gym" is used as a proxy for success since
revenue/membership data isn't publicly available.

## Next steps

Gather demographic data for the paper's five recommended candidate zip codes
(93550, 93552, 90280, 90201, 91792) and compare them directly against the
baseline profile of existing locations calculated here.
