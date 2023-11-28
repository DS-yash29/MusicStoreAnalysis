USE musicstore;

# Country Wise Average , Minimum , Maximum  & Deviation of Order Value 

SELECT billing_country 'Country', ROUND(AVG(total),2) 'Average Order Value', MIN(total) 'Minimum Order Value' , MAX(total) 'Maximum Order Value' , ROUND(std(total),2) 'Standard Deviation'  
FROM invoice 
GROUP BY billing_country;

/*  ---------------------------------------------------------------------------------------------------------- */

# City That has the highest sum  of total billing amount
SELECT billing_city,ROUND(SUM(total),2) 'Total Invoice Amount' FROM invoice
GROUP BY billing_city
ORDER BY SUM(total) DESC LIMIT 1;
/*  ----------------------------------------------------------------------------------------------------------*/

# TOP 5 Countries  With Most Invoices 

SELECT billing_country,count(billing_country) AS 'Trnasaction Frequency' 
FROM invoice
GROUP BY billing_country
ORDER BY count(*) DESC LIMIT 5;

/* Conclusion :
	In Comparision to the other countries 
	The Resulting Countries has highest no. of Music fans
    With USA Leading The Chart.
    ----------------------------------------------------------------------------------------------------------
*/

# Countries Along With Their Most Sold Music Genre.

with 
	cte
    AS 
    (
SELECT t1.billing_country,t4.genre_id,t6.name,SUM(t1.total) AS Totalamt FROM invoice t1 
JOIN customer t2 ON t2.customer_id = t1.customer_id
JOIN invoice_line_id t3 ON t3.invoice_id = t1.invoice_id
JOIN track t4 ON t4.track_id = t3.track_id
JOIN album2 t5 ON t5.album_id = t4.album_id
JOIN genre t6 ON t6.genre_id = t4.genre_id
GROUP BY t1.billing_country,t6.genre_id,t6.name
	)
SELECT billing_country,name  FROM cte WHERE Totalamt IN (SELECT MAX(TotalAmt) FROM cte GROUP  BY billing_country ORDER BY Totalamt DESC)
ORDER BY Totalamt DESC;

/*
	By Using The Concept of Common Table Expressions 
    We can find out The Favourite Genre of Every Country
    This is helpful in reccomending personalized music to a particular segment of customers 
    Resulting in efficieny of sales-pitch.
    
    Here Rock is The Most Preffered Genre For Most of The Countries.
 ----------------------------------------------------------------------------------------------------------
*/

# City  Along With Their Most Sold Music Album.

with 
	cte
    AS 
    (
SELECT t1.billing_city,t5.title,SUM(t1.total) AS Totalamt FROM invoice t1 
JOIN customer t2 ON t2.customer_id = t1.customer_id
JOIN invoice_line_id t3 ON t3.invoice_id = t1.invoice_id
JOIN track t4 ON t4.track_id = t3.track_id
JOIN album2 t5 ON t5.album_id = t4.album_id
GROUP BY t1.billing_city,t5.album_id,t5.title
	)
SELECT billing_city,title  FROM cte WHERE Totalamt IN (SELECT MAX(TotalAmt) FROM cte GROUP  BY billing_city ORDER BY Totalamt DESC)
ORDER BY Totalamt DESC;

/* ------------------------------------------------------------------------------------------------------------------------ */

# Average Order Value For Each Genre Across Countries

SELECT t1.billing_country,t6.name,COUNT(t1.billing_country) AS Popularity_Count,ROUND(AVG(t1.total),2) AS averagevalue FROM invoice t1
JOIN customer t2 ON t2.customer_id = t1.customer_id
JOIN invoice_line_id t3 ON t3.invoice_id = t1.invoice_id
JOIN track t4 ON t4.track_id = t3.track_id
JOIN album2 t5 ON t5.album_id = t4.album_id
JOIN genre t6 ON t6.genre_id = t4.genre_id
GROUP BY t1.billing_country,t6.name
ORDER BY Popularity_count DESC ,averagevalue DESC ;

/*
	Significance : Provides A Deeper Understanding of the Data
    Each country along with it's various state has different set of prefferenes which is helpful in personalizing reccomendations
*/

# Buyer Who spent Most Amount  On Purchasing Albums  From Each Country
with cte as (
SELECT t1.customer_id,CONCAT(t1.first_name," ",t1.last_name) as name ,SUM(t2.total) AS total_spent,t2.billing_country FROM customer t1
JOIN invoice t2 ON t2.customer_id = t1.customer_id
GROUP BY t1.customer_id, name , t2.billing_country)
SELECT s1.customer_id,s1.name,s1.billing_country,s1.total_spent FROM cte s1 WHERE s1.total_spent IN (SELECT MAX(s2.total_spent) FROM cte s2 GROUP BY s2.billing_country);

