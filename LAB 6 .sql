-- challenge: Creating a Customer Summary Report 
-- Step 1: Create a View: 
-- 	Create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
use sakila ; 
CREATE VIEW view_customer AS 
SELECT customer.customer_id, customer.first_name, customer.email, customer.address_id, count(*) as rental_count
FROM customer
INNER JOIN rental ON rental.customer_id = customer.customer_id 
GROUP BY  customer_id ; 

-- Step 2: Create a Temporary Table
-- create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- Supprimez la table temporaire si elle existe pour assurer une exécution propre
DROP TEMPORARY TABLE IF EXISTS temp_total_amount;
CREATE TEMPORARY TABLE temp_total_amount AS  
SELECT 
    payment.customer_id, 
    SUM(payment.amount) AS total_paid 
FROM 
    payment 
GROUP BY 
    payment.customer_id; 

-- STEP 3 :  Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.

WITH customer_summary as (
select view_customer.customer_id, 
view_customer.first_name,
 view_customer.email, 
 view_customer.address_id, 
 view_customer.rental_count,
 temp_total_amount.total_paid  
from view_customer
inner join temp_total_amount on temp_total_amount.customer_id = view_customer.customer_id
)
Select * from customer_summary ; 

