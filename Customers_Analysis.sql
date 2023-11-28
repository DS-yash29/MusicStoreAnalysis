use musicstore;
/* 
	CUSTOMERS's ANALYSIS
    Imp Metrics : 
		Total Purchase of a customer
		Highest Purchase Made by a customer
		Avg Purchase of customers
		No-of purchases 
        Their Favourite Artists
        Their Favourite Genre
        Their Favourite Album
*/

# Imp Key Metric's of Customers Purchases 

SELECT t1.customer_id,CONCAT(t1.first_name," ",t1.last_name) AS name ,ROUND(SUM(t2.total),2) AS totalpurchase, MAX(t2.total) AS highestpurchase ,MIN(t2.total) AS lowestpurchase, ROUND(AVG(t2.total),2)  AS averagespent,ROUND(stddev(t2.total),2) AS spread , COUNT(t2.customer_id) AS purchase_count FROM customer t1
JOIN invoice t2 ON t2.customer_id = t1.customer_id
GROUP BY t1.customer_id,name
ORDER BY spread DESC;

/* Imp Statistical Measures Such as Average , Min , Max Standard Deviation , Count
	Are imp matrix when working with Numeric Data
*/

# Customer's Favourite Artists

with cte AS (
SELECT t1.customer_id,t6.artist_id , COUNT(*) AS purchasefreq FROM customer t1
JOIN invoice t2 ON t2.customer_id = t1.customer_id
JOIN invoice_line_id t3 ON t3.invoice_id = t2.invoice_id
JOIN track t4 ON t4.track_id = t3.track_id
JOIN album2 t5 ON t5.album_id = t4.album_id
JOIN artist t6 ON t6.artist_id = t5.artist_id
GROUP BY t1.customer_id , t6.artist_id
)
SELECT DISTINCT CONCAT(t3.first_name," ",t3.last_name) as cust_name, t4.name AS artist FROM cte t1  
JOIN customer t3 ON t3.customer_id = t1.customer_id
JOIN artist t4 ON t4.artist_id = t1.artist_id
WHERE purchasefreq IN (SELECT MAX(purchasefreq) FROM cte t2 where (t1.customer_id = t2.customer_id))
ORDER BY cust_name;

# Customer Favorite Genre

with cte AS (
SELECT t1.customer_id,t5.genre_id , COUNT(*) AS purchasefreq FROM customer t1
JOIN invoice t2 ON t2.customer_id = t1.customer_id
JOIN invoice_line_id t3 ON t3.invoice_id = t2.invoice_id
JOIN track t4 ON t4.track_id = t3.track_id
JOIN genre t5 ON t5.genre_id = t4.genre_id
GROUP BY t1.customer_id , t5.genre_id
)
SELECT DISTINCT CONCAT(t3.first_name," ",t3.last_name) as cust_name, t4.name AS genre_name FROM cte t1  
JOIN customer t3 ON t3.customer_id = t1.customer_id
JOIN genre t4 ON t4.genre_id = t1.genre_id
WHERE purchasefreq IN (SELECT MAX(purchasefreq) FROM cte t2 where (t1.customer_id = t2.customer_id))
ORDER BY cust_name;

# Customer Favourite Album
with cte AS (
SELECT t1.customer_id,t5.album_id , COUNT(*) AS purchasefreq FROM customer t1
JOIN invoice t2 ON t2.customer_id = t1.customer_id
JOIN invoice_line_id t3 ON t3.invoice_id = t2.invoice_id
JOIN track t4 ON t4.track_id = t3.track_id
JOIN album2 t5 ON t5.album_id = t4.album_id
GROUP BY t1.customer_id , t5.album_id
)
SELECT DISTINCT CONCAT(t3.first_name," ",t3.last_name) as cust_name, t4.title AS album FROM cte t1  
JOIN customer t3 ON t3.customer_id = t1.customer_id
JOIN album2 t4 ON t4.album_id = t1.album_id
WHERE purchasefreq IN (SELECT MAX(purchasefreq) FROM cte t2 where (t1.customer_id = t2.customer_id))
ORDER BY cust_name;
