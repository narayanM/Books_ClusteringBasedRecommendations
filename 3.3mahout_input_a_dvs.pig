-- This Apache Pig script calculates Book and User Derived Variables and JOINs them with mahout_input_a data. 
-- This single pig script does the combined job of previous 2 hive scripts.



-- To Import the Hive table data (part 2 output) into pig to calculate DV's.
input_a = LOAD '/user/hive/warehouse/mahout_input_a/000000_0' USING PigStorage(',') AS (userid:long, bookisbn:long, rating:float);
-- We define the ratings field as float, instead of int, because: float data type is required, in order to get the double datatype for the results of EVALs like: AVG, SUM.

-- Grouping the imported data on BookISBN's
grp_books = GROUP input_a BY bookisbn;

-- Calculating BookTotalRatings and BookAvgRating of each book.
cal_count_sum_books = FOREACH grp_books GENERATE group AS bookisbn, COUNT(input_a.rating) AS booktotalratings, AVG(input_a.rating) AS bookavgrating;
-- EVAL functions like AVG, SUM, etc are case sensitive. they need to be in caps.

-- Grouping the imported data on UserID's.
grp_users = GROUP input_a BY userid;

-- Calculating UserTotalRatings and UserAvgRating of each user.
cal_count_sum_users = FOREACH grp_users GENERATE group AS userid , COUNT(input_a.rating) AS usertotalratings, AVG(input_a.rating) AS useravgrating;

-- JOINing imported data and BookDV's.
join_books = JOIN input_a BY bookisbn, cal_count_sum_books BY bookisbn;

-- JOINing above and userDV's.
join_users = JOIN join_books BY userid, cal_count_sum_users BY userid;	

-- Filtering out excess columns (column 3 and 6) from above, i.e. repeated bookisbn and userid, which have come due to above joins.
filter_columns = FOREACH join_users GENERATE $0 AS userid, $1 AS bookisbn, $2 AS rating, $4 AS booktotalratings, $5 AS bookavgrating, $7 AS usertotalratings, $8 AS useravgrating;

-- Storing the above result into HDFS using tab column delimiter.
STORE filter_columns INTO '/clouderabooks/part3/mahout_input_a_dvs_pig' USING PigStorage('\t');
