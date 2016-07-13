REGISTER datafu-1.2.0.jar;
Y = LOAD '/user/cloudera/distance/2015' USING PigStorage(',')AS (code:chararray,date:chararray,stat:chararray,val:float,lat2:double,long2:double);
X = LOAD '/user/cloudera/distance/uber15_sample.csv' USING PigStorage(',')AS (pickup_date:chararray,pickup_time:chararray,lat1:double,long1:double);
Z = JOIN X by pickup_date,Y by date;
A = foreach Z {

latlongarray = CONCAT((chararray)lat1,(chararray)long1);
totarray = CONCAT(pickup_date,pickup_time);
arr = CONCAT(totarray,latlongarray);
GENERATE pickup_date,pickup_time,lat1,long1,stat,val,lat2,long2,datafu.pig.geo.HaversineDistInMiles(lat1,long1,lat2,long2) AS dist,CONCAT(stat,arr) AS Uno,arr AS Unew;

}

ridegroup = GROUP A BY Uno;
lol = FOREACH ridegroup {
                sortByMax = ORDER A BY dist ASC;
                topMax = LIMIT sortByMax 1;
                GENERATE FLATTEN(topMax);
                }
lol1 = FOREACH lol GENERATE Unew,pickup_date,pickup_time,lat1,long1,stat,val,dist;
lol2 = ORDER lol1 BY pickup_date ASC, pickup_time ASC, stat Desc;
STORE lol2 INTO '/user/cloudera/distance/output' USING PigStorage(',');
