CREATE EXTERNAL TABLE IF NOT EXISTS taxi_uber(

pickup_date STRING,

pickup_time STRING,

flag STRING)

ROW FORMAT DELIMITED

FIELDS TERMINATED BY ‘,’;



INSERT OVERWRITE TABLE taxi_uber
 
select pickup_date, pickup_time, ‘taxi’ as flag 
(select pickup_date,pickup_time,flag from rev_taxi where description = ’SNWD’ ) t1;


ALTER TABLE uber_weather_data ADD COLUMNS ( flag STRING);


INSERT INTO TABLE taxi_uber 

select pickup_date, pickup_time, ‘uber’ as flag from 
(select pickup_date,pickup_time,flag from uber_weather_data where description = ’SNWD’) t2;
