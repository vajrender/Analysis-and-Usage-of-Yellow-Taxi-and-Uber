/* The pig code is run on the Amazon EMR cluster
Vajrender Kumar mangalapally vkm240@nyu.edu */

records = LOAD '$INPUT' USING PigStorage(',') AS (code, date, description, temp, det1, det2, det3, det4);
records1 = LOAD 's3://vajrender/input_code.csv' AS (code, latitude, longitude);
clean1 = FOREACH records GENERATE $0, $1, $2, $3;
clean2 = join clean1 by code, records1 by code;
clean3 = FILTER clean2 BY (description=='PRCP') OR (description=='TAVG') OR (description=='SNOW') OR (description=='SNWD');
clean4 = FILTER clean3 BY (code== 'USW00094789') OR (code== 'USW00094728') OR (code== 'USC00305796') OR
 (code== 'USC00305798') OR (code== 'USC00305799') OR (code== 'USC00305804') OR(code== 'USC00305806') OR 
(code== 'USC00305816') OR (code== 'USW00014732') OR (code== 'USW00014708') OR (code== 'USC00300621') OR
(code== 'USC00300958') OR (code== 'USC00300961') OR (code== 'USC00304632') OR (code== 'US1NYKN0003') OR 
(code== 'US1NYKN0025');
clean5 = FOREACH clean4 GENERATE $0, $1, $2, $3, $5, $6;
STORE clean5 INTO '$OUTPUT';