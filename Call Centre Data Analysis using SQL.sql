-------------------------------------------------------------------------------------------------------------
##################      Data Analysis project- Using SQL to Clean and Analyse Data. #########################
--------------------------------------------------------------------------------------------------------------

#    In this project we use a dataset from ‘Real World Fake Data’. The one that I chose is the ‘call center’ dataset.
#    Clean it a bit then analyse it. And at last, used Tableau to visualize the data.
#    The call-center dataset basically has over 32,900 records of data that describers calls made to various call centres. It includes the ID of the call , 
#    duration of the call in minutes, the name of the person who called, their satisfaction score and many other attributes.

# First we will Create a Database called Callcentre
CREATE DATABASE Callcentre;

# USE this Database Callcentre
USE Callcentre;

# Create a Table Where we will import our csv file 

CREATE Table Calls (
        ID  CHAR(50), 
        cust_name CHAR(50),
        sentiment CHAR(50),
        csat_score INT,
	    call_timestamp CHAR (10),
		reason CHAR (20),
	    city CHAR (20),
	    state CHAR (20),
	    channel CHAR (20),
	    response_time CHAR (20),
	    call_duration_minutes INT,
		call_center CHAR (20)
        );
        
# See the Table
SELECT count(*) FROM Calls;
        
# Used to delet all the records from table
truncate Calls;
        
# Now we will import Data (csv file to table ) to Table by clicking right click on calls 
SELECT * FROM Calls;
SELECT COUNT(*) FROM Calls;
SELECT * FROM Calls limit 10;

-------------------------------------------- CLEANING THE DATA ----------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
# SQL SAFE Updates statement is used to disable the SQL safe updates mode
SET SQL_SAFE_UPDATES = 0;

# Now we will convert String format to date format
UPDATE Calls SET call_timestamp = str_to_date(call_timestamp, "%m/%d/%Y");

#  replace the value of 0 with NULL for the "csat_score" column
UPDATE Calls SET csat_score = NULL WHERE csat_score = 0;

SET SQL_SAFE_UPDATES = 1;

# Checking all Changes
SELECT * FROM Calls limit 10;

------------------------------------------------- EXPLORING THE DATA --------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

# Lets check the Dimensions of our Dataset that is number of Rows and Columns
SELECT Count(*) AS rows_num from Calls;
SELECT Count(*) AS column_num FROM callcentre WHERE Table_name ='Calls';

# Checking Distinct Values from Dataset
SELECT DISTINCT sentiment FROM calls;
SELECT DISTINCT reason FROM calls;
SELECT DISTINCT channel FROM calls;
SELECT DISTINCT response_time FROM calls;
SELECT DISTINCT call_center FROM calls;

#The count and precentage from total of each of the distinct values we got
SELECT sentiment, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1) AS pct
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT reason, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1) AS pct
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT channel, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1) AS pct
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT response_time, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1) AS pct
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT call_center, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1) AS pct
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT state, COUNT(*) FROM calls GROUP BY 1 ORDER BY 2 DESC;

SELECT DAYNAME(call_timestamp) as Day_of_call, COUNT(*) num_of_calls FROM calls GROUP BY 1 ORDER BY 2 DESC;

# Aggregations
# Gives MIN MAX AND AVG 
SELECT MIN(csat_score) AS min_score, MAX(csat_score) AS max_score, ROUND(AVG(csat_score),1) AS avg_score
FROM calls WHERE csat_score != 0; 

# Gives Earliest date and Most Recent dates 
SELECT MIN(call_timestamp) AS earliest_date, MAX(call_timestamp) AS most_recent FROM calls;

# Tells Min Max and Avg of Call duration
SELECT MIN(call_duration_minutes) AS min_call_duration, MAX(call_duration_minutes) AS max_call_duration, AVG(call_duration_minutes) AS avg_call_duration FROM calls;

SELECT call_center, response_time, COUNT(*) AS count
FROM calls GROUP BY 1,2 ORDER BY 1,3 DESC;

# Gives AVG According to the centre
SELECT call_center, AVG(call_duration_minutes) FROM calls GROUP BY 1 ORDER BY 2 DESC;

# Gives Average According to channel
SELECT channel, AVG(call_duration_minutes) FROM calls GROUP BY 1 ORDER BY 2 DESC;

# Counts According to State
SELECT state, COUNT(*) FROM calls GROUP BY 1 ORDER BY 2 DESC;

# Counts According to State with reason
SELECT state, reason, COUNT(*) FROM calls GROUP BY 1,2 ORDER BY 1,2,3 DESC;

# Counts According to State with sentiment
SELECT state, sentiment , COUNT(*) FROM calls GROUP BY 1,2 ORDER BY 1,3 DESC;

# Avg of csat score according to State
SELECT state, AVG(csat_score) as avg_csat_score FROM calls WHERE csat_score != 0 GROUP BY 1 ORDER BY 2 DESC;

#Avg of call_duration According to sentiment
SELECT sentiment, AVG(call_duration_minutes) FROM calls GROUP BY 1 ORDER BY 2 DESC;

# Max of Call duration According to call_timestamp using window function
SELECT call_timestamp, MAX(call_duration_minutes) OVER(PARTITION BY call_timestamp) AS max_call_duration FROM calls GROUP BY 1 ORDER BY 2 DESC;

SELECT cust_name, MIN(call_duration_minutes) OVER (PARTITION BY cust_name) AS Weak_customer FROM calls GROUP BY cust_name ORDER BY call_duration_minutes DESC;











        
        
        