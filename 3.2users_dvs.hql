-- Create a Hive table to calculate the Derived Variables of the users from bookratings.
-- Here bookratings data is mahout_input_a table in Hive, which is the result of part 2.
-- Drop the table books_dvs if already created.
DROP TABLE users_dvs;
-- Create the table with 3 columns: userid, usertotalratings, useravgrating.
create table users_dvs                    
as                                        
select userid as userid,              
count(rating) as usertotalratings,             
sum(rating)/count(rating) as useravgrating
from mahout_input_a                       
group by userid                         
order by usertotalratings desc;

-- End of the hive script.

