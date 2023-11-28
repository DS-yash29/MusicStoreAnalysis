use musicstore;

# Most Popular Album : In Terms of No of Times Sold.

SELECT t2.album_id,t1.title,COUNT(t2.album_id) as 'No of times sold' FROM album2 t1
JOIN track t2 ON  t2.album_id = t1.album_id
JOIN invoice_line_id t3 ON t3.track_id = t2.track_id
JOIN invoice t4 ON t4.invoice_id = t3.invoice_id
GROUP BY t2.album_id , t1.title
ORDER BY COUNT(t2.album_id) DESC ;

/*
	Use Case :
	Help Music Companies in investing in a certain brand , album & genre more frequent and aggresive than others 
     ----------------------------------------------------------------------------------------------------------
*/

# Most Sold Album : 


SELECT t2.album_id,t1.title,ROUND(SUM(t4.total),2) as 'Total Sales'  FROM album2 t1
JOIN track t2 ON  t2.album_id = t1.album_id
JOIN invoice_line_id t3 ON t3.track_id = t2.track_id
JOIN invoice t4 ON t4.invoice_id = t3.invoice_id
GROUP BY t2.album_id , t1.title
ORDER BY SUM(t4.total) DESC ;

# Most Popular Track of a Particular Genre
SELECT t2.title , t1.name FROM track t1
JOIN album2 t2 ON t2.album_id = t1.album_id
JOIN invoice_line_id t3 ON t3.track_id = t1.track_id
JOIN invoice t4 ON t4.invoice_id = t3.invoice_id
GROUP BY t1.album_id
ORDER BY COUNT(t1.track_id) ;

/*
 -----------------------------------------------------------------------------------------------------------------------------
 */
