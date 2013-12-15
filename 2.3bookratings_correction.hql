-- Load the bookratings.csv file from HDFS to Hive as an external table.

-- The hive-contrib JAR is needed to support the RegexSerDe. add it.
add jar /usr/lib/hive/lib/hive_contrib.jar;
-- Note that all types must be strings for the regex serde

-- Dropping the table, if it is already exist. useful when running the script multiple times.
DROP TABLE bookratings;

-- creating an external table and loading the data through regex.
CREATE EXTERNAL TABLE bookratings (
  userid string,
  bookisbn string,
  rating string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.contrib.serde2.RegexSerDe'
WITH SERDEPROPERTIES
(
"input.regex" = "^\"(\\d+)\"\\\;\"(\\d+)\"\\\;\"(\\d+)\""
)
LOCATION '/clouderabooks/bookratings';

-- end of the script.