-- 1. Create a new user with the username "rentaluser" and the password "rentalpassword"
CREATE USER rentaluser WITH PASSWORD 'rentalpassword';
GRANT CONNECT ON DATABASE dvdrental TO rentaluser;

-- 2. Grant "rentaluser" SELECT permission for the "customer" table.
GRANT SELECT ON customer TO rentaluser;

-- 3. Create a new user group called "rental" and add "rentaluser" to the group.
CREATE ROLE rental;
GRANT rental TO rentaluser;

-- 4. Grant the "rental" group INSERT and UPDATE permissions for the "rental" table.
SET ROLE rentaluser;
SHOW ROLE;

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
VALUES (CURRENT_DATE, 111, 222, CURRENT_DATE, 3, NOW());

UPDATE rental SET return_date = '2024-02-04' WHERE rental_id = 1;

RESET ROLE;

-- 5. Revoke the "rental" group's INSERT permission for the "rental" table.
REVOKE INSERT ON rental FROM rental;

SET ROLE rentaluser;
SHOW ROLE;

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
VALUES (CURRENT_DATE, 333, 444, CURRENT_DATE, 3, NOW());

RESET ROLE;

-- 6. Create a personalized role for any customer already existing in the dvd_rental database.
CREATE ROLE client_BETTY_WHITE LOGIN PASSWORD 'password_for_BETTY_WHITE';

CREATE POLICY select_own_data_policy ON rental
FOR SELECT
TO client_BETTY_WHITE
USING (customer_id = 14);
  
CREATE POLICY select_own_data_policy ON payment
FOR SELECT
TO client_BETTY_WHITE
USING (customer_id = 14);
  
CREATE POLICY select_own_data_policy ON customer
FOR SELECT
TO client_BETTY_WHITE
USING (customer_id = 14);

GRANT SELECT ON TABLE rental, payment, customer TO client_BETTY_WHITE;

SET ROLE client_BETTY_WHITE;
