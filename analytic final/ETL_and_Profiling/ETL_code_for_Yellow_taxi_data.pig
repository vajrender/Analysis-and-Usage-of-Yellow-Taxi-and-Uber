/* This code is run on Amazon EMR Cluster
Amit Nair apn263@nyu.edu */

data = LOAD '$INPUT' USING PigStorage(',') AS (VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_distance, pickup_longitude:float, pickup_latitude:float, RateCodeID, store_and_fwd_flag, dropoff_longitude:float, dropoff_latitude:float, payment_type, fare_amount, extra, mta_tax, tip_amount, tolls_amount, improvement_surcharge, total_amount);
clean1 = FOREACH data GENERATE $1, $2, $5, $6, $8, $9, $10, $18;
clean2 = FILTER clean1 By (store_and_fwd_flag=='Y') OR (store_and_fwd_flag=='N') ;
clean3 = FILTER clean2 BY pickup_latitude>40;
clean4 = FILTER clean3 BY dropoff_latitude>40;
clean5 = FILTER clean4 BY pickup_longitude<-72;
clean6 = FILTER clean5 BY dropoff_longitude<-72;
STORE clean6 INTO '$OUTPUT';
DUMP clean6;