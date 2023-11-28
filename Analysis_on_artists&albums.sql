use musicstore;

# Query  that returns customer's Personal Details of all rock music listeners 

SELECT DISTINCT email,CONCAT(first_name," ",last_name) AS fullname FROM customer t1
JOIN invoice t2 ON t1.customer_id = t2.customer_id 
JOIN invoice_line_id t3 ON t3.invoice_id = t2.invoice_id
JOIN track t4 ON t4.track_id = t3.track_id 
JOIN genre t5 ON t5.genre_id = t4.genre_id
WHERE t5.name LIKE 'Rock' ORDER  BY email ;

/*
	The Above Query is Useful For Finding Customers Preferences of genre 
    Which becomes very useful in personalized sales pitch
     ---------------------------------------------------------------------------------------------------------------
*/

# Top Artists Who Have Sang Rock Music Most number of times

SELECT t5.name , COUNT(t4.album_id) AS nooftimessang FROM album2 t1
JOIN track t4 ON t4.album_id = t1.album_id
JOIN artist t5 ON t5.artist_id = t1.artist_id
WHERE t4.genre_id = (SELECT genre_id FROM genre WHERE name LIKE 'Rock')
GROUP BY t5.name
ORDER BY nooftimessang DESC ;

# Track list Which Has Duration greater that the average duration

SELECT name,milliseconds FROM track 
WHERE milliseconds > (SELECT AVG(milliseconds) FROM track) 
ORDER BY milliseconds DESC;
