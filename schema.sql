-- schema.sql
-- Table matching data/studio_zipcodes.csv: existing luxury boutique fitness
-- studio locations (SoulCycle, Solidcore, CorePower, CycleBar, Equinox) with
-- zip-code-level Census demographics.

CREATE TABLE gym_locations (
    franchise                 TEXT NOT NULL,   -- soulcycle, solidcore, corepower, cyclebar, equinox
    city                      TEXT NOT NULL,   -- LA, SF, NYC, Bay Area, Socal
    zipcode                   TEXT NOT NULL,
    median_household_income   INTEGER,
    population                INTEGER,
    population_density        INTEGER,         -- per sq mile
    median_home_value         INTEGER,         -- Census top-codes this at $1,000,001
    housing_units              INTEGER
);

-- To load the data (from the project's data/ folder), run in Terminal:
--   sqlite3 gyms.db
--   sqlite> .mode csv
--   sqlite> .import --skip 1 data/studio_zipcodes.csv gym_locations
