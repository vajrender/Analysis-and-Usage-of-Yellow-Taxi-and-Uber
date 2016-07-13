
CREATE EXTERNAL TABLE IF NOT EXISTS subway(
station_name STRING,
lat DOUBLE,
long DOUBLE)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';

LOAD DATA INPATH '/user/cloudera/mta.csv' OVERWRITE INTO TABLE subway;

INSERT OVERWRITE LOCAL DIRECTORY '/home/cloudera/Desktop/new' 
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ','
select subway.station_name,rev_taxi.pickup_date,rev_taxi.pickup_time,
rev_taxi.pickup_lat,rev_taxi.pickup_long from rev_taxi JOIN subway ON round(rev_taxi.pickup_lat,3) = round(subway.lat,3) and round(rev_taxi.pickup_long,3) = round(subway.long,3) where description = 'SNWD';
