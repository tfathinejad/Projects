use sakila;

-- 1a. Display the first and last names of all actors from the table actor.

select * from actor;

select first_name, last_name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

SELECT upper(concat(first_name,' ', last_name)) AS 'Actor_Name' FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

select actor_id,
first_name,
last_name
from actor
where
first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:

select first_name, last_name from actor 
where last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

select first_name, last_name from actor
where last_name like '%LI%'
order by last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

select country_id, country 
from country
where country in
("Afghanistan", "Bangladesh", "China");

-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.

alter table actor
add column Middle_Name text;

select first_name, Middle_Name, last_name from actor;

-- 3c. Now delete the middle_name column.

alter table actor
drop Middle_Name;

-- 4a. List the last names of actors, as well as how many actors have that last name.

select last_name, count(*) from actor 
group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
-- alter table actor
-- add column first_name_count integer
-- insert into first_name_count SELECT first_name, count(*) from actor
-- group by first_name;


-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.


update actor 
set first_name = 'HARPO'
where last_name = 'WILLIAMS';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)
-- Write a single SQL Query to change all entries in the column that match "HARPO" to "GROUCHO" and those matching "GROUCHO" (before running  the query) to "MUCHO GROUCHO"

update actor
set first_name =
case
	when first_name = 'HARPO' then 'GROUCHO'
    else 
    'MUCHO GROUCHO'
    end
where actor_id = 172;
-- Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it? 
-- Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html:
-- show create table address;
-- or 
select *
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='address';

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

select staff.first_name, staff.last_name, address.address
from staff
join address on 
(address.address_id = staff.address_id);

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

select payment.amount
from payment
join staff on
(staff.staff_id = payment.staff_id)
where payment.payment_date like '%2005-08%'
group by staff.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
-- Question: I only get one film title back, why is that? shouldn't i get more?

select film.title, count(film_actor.actor_id) as 'Number of Actors'
from film_actor
inner join film on
film.film_id = film_actor.film_id
group by film.title
order by 'Number of Actors' desc;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select count(inventory_id) as 'Number of Copies'
from inventory
join film on 
film.film_id = inventory.film_id
where title = 'Hunchback Impossible'; 

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
-- ![Total amount paid](Images/total_payment.png)
-- 
-- SELECT customer_id, sum(amount), first_name, last_name
-- FROM customer
-- INNER JOIN payment USING (customer_id)
-- GROUP BY customer_id
-- ORDER BY last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
-- SELECT film.title
-- FROM film
-- WHERE film.title like 'K%'
-- or film.

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select actor.first_name, actor.last_name
from actor
where actor_id in
(select actor_id from 
film_actor
where film_id in 
(select film_id from
film
where film.title = 'Alone Trip')); 

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.



-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films. 