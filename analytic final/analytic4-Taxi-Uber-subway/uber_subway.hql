CREATE EXTERNAL TABLE IF NOT EXISTS uber_data(
pickup_date STRING,
pickup_time STRING,
pickup_lat STRING,
pickup_long STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';

CREATE EXTERNAL TABLE IF NOT EXISTS subway(
station_name STRING,
lat DOUBLE,
long DOUBLE)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';


LOAD DATA INPATH 'hdfs://172.31.36.34:9000/user/hive/warehouse/subway1' OVERWRITE INTO TABLE subway1;
LOAD DATA INPATH '/user/cloudera/distance/part-r-00000' OVERWRITE INTO TABLE uber_data;
LOAD DATA INPATH '/user/cloudera/mta.csv' OVERWRITE INTO TABLE subway;

CREATE EXTERNAL TABLE IF NOT EXISTS uber_subway_data(
station_name STRING,
pickup_date STRING,
pickup_time STRING,
pickup_lat STRING,
pickup_long STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';

INSERT OVERWRITE TABLE uber_subway_data
select subway1.station_name,uber_weather_data.pickup_date,uber_weather_data.pickup_time,uber_weather_data.pickup_lat,uber_weather_data.pickup_long from uber_weather_data JOIN subway1 ON round(uber_weather_data.pickup_lat,3) = round(subway1.pickup_lat,3) and round(uber_weather_data.pickup_long,3) = round(subway1.pickup_long,3) where description = 'SNWD';
