-- This Hive query Creates a Hive table to calculate the Derived Variables of the books/items from bookratings.
-- Here bookratings data is mahout_input_a table in Hive, which is the result of part 2.
-- Drop the table books_dvs if already created.

DROP TABLE books_dvs;

-- Create the table with 3 columns: bookisbn, booktotalratings, bookavgrating.
create table books_dvs                    
as                                        
select bookisbn as bookisbn,              
count(rating) as booktotalratings,             
sum(rating)/count(rating) as bookavgrating
from mahout_input_a                       
group by bookisbn                         
order by booktotalratings desc;

-- End of the hive script.

