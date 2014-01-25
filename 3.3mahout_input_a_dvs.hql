-- This Hive query joins the 3 previously created tables: mahout_input_a, books_dvs, users_dvs.

-- drop if this table already existed.
drop table mahout_input_a_dvs;

-- To join 3 tables: mahout_input_a, books_dvs, users_dvs.
CREATE TABLE mahout_input_a_dvs
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
stored as textfile                        
as                                        
SELECT a.userid, a.bookisbn, a.rating, booktotalratings, bookavgrating, usertotalratings, useravgrating
FROM mahout_input_a a
LEFT OUTER JOIN books_dvs b ON (a.bookisbn = b.bookisbn)
LEFT OUTER JOIN users_dvs c ON (a.userid = c.userid);

-- end of hive script.
