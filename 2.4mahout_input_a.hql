-- Load the bookratings records from Hive table to a new table without NULL’s.

-- Drop the table, if it is already exist. useful when running the script multiple times.
DROP TABLE MAHOUT_INPUT_A;

-- Capture the information as a CSV. 
CREATE TABLE MAHOUT_INPUT_A
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
AS
SELECT userid as userid,
       bookisbn as bookisbn,
       rating as rating
from bookratings
WHERE bookisbn != "";
-- end of the hive script.