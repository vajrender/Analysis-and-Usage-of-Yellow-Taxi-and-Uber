/* Manish Reddy Chinthalaphani mc5410@nyu.edu*/

X = LOAD '/user/cloudera/projtry1/workbook3.csv' USING PigStorage(',')AS (Date,Time,LocationID);

Y = LOAD '/user/cloudera/projtry1/uber_14_final.csv' USING PigStorage(',')AS (LocationID,Lat,Long);

Z = join X by LocationID, Y by LocationID;

A = FOREACH Z GENERATE $0,$1,$4,$5;

STORE A INTO '/user/cloudera/uber_2014_final00.csv' USING PigStorage(',');

