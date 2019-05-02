USE sakila;

-- 1.A AND 1.B
SELECT CONCAT(c.first_name, ' ', c.last_name) AS Actor_name,
       c.*
FROM   `customer` c;

-- 2.A
SELECT customer.customer_id, customer.first_name, customer.last_name FROM customer
    WHERE customer.first_name= 'JOE';

-- 2.B
SELECT customer.customer_id, customer.first_name, customer.last_name FROM customer    
    WHERE customer.last_name LIKE '%GEN%';

-- 2.C
SELECT customer.customer_id, customer.first_name, customer.last_name FROM customer    
    WHERE customer.last_name LIKE '%LI%';
    
-- 2.D
SELECT country_id, country FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3.A
ALTER TABLE actor
ADD description blob(255);

-- 3.B
ALTER TABLE actor DROP description;

-- 4.A
SELECT last_name ,COUNT(*) as count FROM actor GROUP BY last_name ORDER BY count DESC;

-- 4.B
SELECT last_name ,COUNT(*) <1 as count FROM actor GROUP BY last_name ORDER BY count DESC;

-- 4.C

SELECT actor.actor_id, actor.first_name, actor.last_name FROM actor
    WHERE actor.last_name= 'WILLIAMS';

UPDATE actor
SET 
    first_name = 'HARPO',
WHERE
    actor_id = 172;

-- 4.D
UPDATE actor
SET 
    first_name = 'GROUCHO',
WHERE
    actor_id = 172;
    
-- 5.A
SHOW CREATE TABLE actor;

-- 6.A
SELECT * FROM staff
JOIN address on address.address_id = staff.address_id;

-- 6.B Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`

SELECT * FROM staff
JOIN payment on staff.staff_id = payment.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join

SELECT fa.film_id, f.title, COUNT(distinct fa.actor_id) as count FROM film_actor fa, film f WHERE fa.film_id= f.film_id GROUP BY fa.film_id, f.title ORDER BY count DESC;

-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT film.film_id, film.title FROM film
    WHERE film.title= 'Hunchback Impossible';
    
SELECT film_id ,COUNT(*) as count FROM inventory WHERE film_id='439';

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name

SELECT customer.last_name, payment.amount FROM customer, payment WHERE payment.customer_id=customer.customer_id GROUP BY customer.customer_id ORDER BY customer.last_name;

--  7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT * FROM language WHERE name='English';
SELECT * FROM film WHERE title LIKE 'Q%' or title LIKE 'K%' and language_id=1; 

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.

SELECT * FROM film WHERE title = 'Alone Trip';
SELECT actor.first_name, actor.last_name FROM actor, film_actor WHERE actor.actor_id = film_actor.actor_id and film_id=17;

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT country_id, country FROM country WHERE country='Canada';

SELECT customer.first_name, customer.last_name, customer.email FROM customer
JOIN address on address.address_id = customer.address_id
JOIN city on city.city_id= address.city_id
WHERE city.country_id =20;

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT category_id, name FROM category WHERE name= 'Family';

SELECT film.title FROM film
JOIN film_category on film_category.film_id=film.film_id
WHERE category_id = 8;

-- 7e. Display the most frequently rented movies in descending order.

SELECT title, rental_rate FROM film ORDER BY rental_rate DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in

SELECT customer.store_id, SUM(payment.amount) FROM payment
JOIN customer on customer.customer_id= payment.customer_id
GROUP BY customer.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.

SELECT store.store_id, city.city, country.country FROM store, address, city, country
WHERE store.address_id= address.address_id
AND address.city_id = city.city_id
AND city.country_id = country.country_id;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT category.name, SUM(payment.amount) FROM category, film_category, inventory, payment, rental
WHERE film_category.category_id= category.category_id
AND inventory.film_id = film_category.film_id
AND rental.inventory_id = inventory.inventory_id
AND payment.rental_id = rental.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
-- 8b. How would you display the view that you created in 8a?
-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.