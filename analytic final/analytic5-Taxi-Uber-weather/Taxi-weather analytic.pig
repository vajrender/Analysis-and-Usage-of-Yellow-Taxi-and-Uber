E = LOAD '/user/cloudera/myNewDir/sample' USING PigStorage('\t') AS (pickup_time,dropoff_time,pickup_lat:double,pickup_long:double,flag,drop_lat:double,drop_long:double,fare:double);

F = foreach E{
	GENERATE FLATTEN(STRSPLIT(pickup_time,' ',2)) AS (pdate:chararray,ptime:chararray), FLATTEN(STRSPLIT(dropoff_time,' ',2)) AS (ddate:chararray,dtime:chararray),pickup_lat,pickup_long,drop_lat,drop_long,fare;
}

Y = LOAD '/user/cloudera/myNewDir/2015_w' USING PigStorage(',')AS (date:chararray,stat:chararray,val:float);

Z = JOIN F by pdate,Y by date;
STORE Z INTO '$OUTPUT' USING PigStorage(',');
