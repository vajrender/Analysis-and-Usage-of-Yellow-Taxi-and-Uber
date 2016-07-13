ALTER TABLE rev_taxi ADD COLUMNS (distance DOUBLE, flag INT);

CREATE EXTERNAL TABLE IF NOT EXISTS taxi_distance(
pickup_date STRING,
pickup_time STRING,
pickup_long DOUBLE,
pickup_lat DOUBLE,
distance DOUBLE
flag STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';


INSERT TABLE taxi_distance 
select 
    pickup_date,
    pickup_time,
    pickup_long,
    pickup_lat,
    distance,
    flag
from
(select
    pickup_date,
    pickup_time,
    pickup_long,
    pickup_lat,
    description,
    (2) AS flag,
    (2 * asin(
    sqrt(
      cos(radians(pickup_lat)) *
      cos(radians(40.7073)) *
      pow(sin(radians((pickup_long - (-73.96934))/2)), 2)
          +
      pow(sin(radians((pickup_lat - 40.7073)/2)), 2)

    )
  ) * 3956) AS distance
from rev_taxi
where 
description = 'SNWD') taxi2
where 
distance < 2;


INSERT TABLE taxi_distance 
select 
    pickup_date,
    pickup_time,
    pickup_long,
    pickup_lat,
    distance,
    flag
from
(select
    pickup_date,
    pickup_time,
    pickup_long,
    pickup_lat,
    description,
    (4) AS flag,
    (2 * asin(
    sqrt(
      cos(radians(pickup_lat)) *
      cos(radians(40.7073)) *
      pow(sin(radians((pickup_long - (-73.96934))/2)), 2)
          +
      pow(sin(radians((pickup_lat - 40.7073)/2)), 2)

    )
  ) * 3956) AS distance
from rev_taxi
where 
description = 'SNWD') taxi2
where 
distance < 4 AND distance > 2;


INSERT TABLE taxi_distance 
select 
    pickup_date,
    pickup_time,
    pickup_long,
    pickup_lat,
    distance,
    flag
from
(select
    pickup_date,
    pickup_time,
    pickup_long,
    pickup_lat,
    description,
    (6) AS flag,
    (2 * asin(
    sqrt(
      cos(radians(pickup_lat)) *
      cos(radians(40.7073)) *
      pow(sin(radians((pickup_long - (-73.96934))/2)), 2)
          +
      pow(sin(radians((pickup_lat - 40.7073)/2)), 2)

    )
  ) * 3956) AS distance
from rev_taxi
where 
description = 'SNWD') taxi2
where 
distance < 6 AND distance > 4;



/* lat2 and lon2 values are given as user inputs */

INSERT OVERWRITE DIRECTORY 's3://projdata230293/taxi_distance/'  select * from taxi_distance;
