--Fucntions

--CREATE FUNCTION <FUNCTION name> (
--	PARAMETER1 <DATA TYPE>
--	PARAMETER1 <DATA TYPE>
--)
--RETURNS <RETURN value DATA TYPE> AS 
--$$
--	BEGIN
--	FUNCTION body; <-actual code running our function
--	END
--$$
--LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION double_num (
	num INTEGER
)
RETURNS INTEGER AS 
$$
	BEGIN
	RETURN num * 2;
	END
$$
LANGUAGE plpgsql;

SELECT double_num(5);    --<-selecting our RETURN value


----------------- ADD late fee amount (via a parameter) ---------------------

SELECT *
FROM payment ;


CREATE OR REPLACE FUNCTION late_fee (
	_payment_id INTEGER,      -- <-PARAMETERS put line BEFORE, name anything I want
	_customer_id INTEGER,
	late_fee_amount NUMERIC(4,2)
)
RETURNS NUMERIC(4,2) AS 
$$
	BEGIN 
	UPDATE payment 
	SET amount = amount + late_fee_amount
	WHERE payment_id = _payment_id AND customer_id = _customer_id;
	RETURN amount;
	END;
$$
LANGUAGE plpgsql;

SELECT late_fee(17504, 341, 1.00);

------------------------ with VOID , NO return --------------------------
DROP FUNCTION add_late_fee;

CREATE OR REPLACE FUNCTION late_fee (
	_payment_id INTEGER,      -- <-PARAMETERS put line BEFORE, name anything I want
	_customer_id INTEGER,
	late_fee_amount NUMERIC(4,2)
)
RETURNS INTEGER AS 
$$
	BEGIN 
	UPDATE payment 
	SET amount = amount + late_fee_amount
	WHERE payment_id = _payment_id AND customer_id = _customer_id;
	RETURN late_fee_amount;
	END;
$$
LANGUAGE plpgsql;
----TRY
CREATE OR REPLACE FUNCTION late_fee (
	_payment_id INTEGER,      -- <-PARAMETERS put line BEFORE, name anything I want
	_customer_id INTEGER,
	late_fee_amount NUMERIC(4,2)
)
RETURNS INTEGER AS 
$$
	BEGIN 
	UPDATE payment 
	SET amount = amount + late_fee_amount
	WHERE payment_id = _payment_id AND customer_id = _customer_id;
	RETURN amount FROM payment WHERE payment_id  = payment_id ;
	END;
$$
LANGUAGE plpgsql;

SELECT *
FROM payment 
WHERE payment_id  = 17504;

------ update function, update actors last name---------
--class exercise -- worked- try with a funcion

SELECT *
FROM actor;

CREATE OR REPLACE FUNCTION actor_last_name (
	_actor_id INTEGER,
	new_last_name VARCHAR(100)
)
RETURNS VOID AS 
$$
	BEGIN 
	UPDATE actor 
	SET last_name = new_last_name
	WHERE actor_id = _actor_id;
	END;
$$
LANGUAGE plpgsql;


----------- Will's example ------ change last name --------------

SELECT *
FROM actor;

CREATE OR REPLACE FUNCTION change_actor_ln(
	_actor_id INTEGER,
	_first_name VARCHAR(50),
	_last_name VARCHAR(50),
	new_last_name VARCHAR(50)
)
RETURNS VARCHAR(50) AS 
$function$
--$$
	BEGIN 
	UPDATE actor 
	SET last_name = new_last_name
	WHERE actor_id = _actor_id;
	RETURN CONCAT(_first_name,' ', new_last_name) AS full_name;
	END;
$function$
--$$
LANGUAGE plpgsql;

SELECT change_actor_ln(2, 'Penelope', 'Guiness', 'Jennings');

----------CREATING PROCEDURES:--------------

--updates RETURN date ON rental table

SELECT *
FROM rental 
WHERE return_date IS NULL; --WHEN looking FOR NULL VALUES IS OR IS NOT NULL

CREATE OR REPLACE PROCEDURE update_return_date(
	_rental_id INTEGER, --parameters
	_customer_id INTEGER
	
)
AS $$
	BEGIN 
		UPDATE rental --WHAT ARE WE UPDATING
		SET return_date = current_date --setting COLUMN value giving valu
		WHERE rental_id = _rental_id AND customer_id = _customer_id;  --set 2 conditions to what we are updating, make sure its RIGHT customer
		COMMIT; 
	END;
$$
LANGUAGE plpgsql;


--call PROCEDURE 

CALL update_return_date(11541, 335); --addd in req arguments 

--see it in system, make sure u have the right customer id #

SELECT *
FROM rental 
WHERE rental_id = 11541;

--add actor into actor table

SELECT *
FROM actor ;
--#1
CREATE OR REPLACE PROCEDURE add_actor(
	_first_name VARCHAR(50), --we'll need these TO see
	_last_name VARCHAR(50)
)AS 
$$
	BEGIN 
		INSERT INTO actor( --INSERT INTO actor table
			first_name,
			last_name
		) VALUES (
			_first_name,--parameters or args we pass IN
			_last_name
		);
		COMMIT;
	END;
$$
LANGUAGE plpgsql;

CALL add_actor('Tom', 'Hardy') --#3

SELECT *
FROM actor 
WHERE first_name = 'Tom' AND last_name = 'Hardy'; --#2, #4 see the added actor

-------DELETE entry----

CREATE OR REPLACE PROCEDURE delete_inv (
	_inventory_id INTEGER,
	_film_id INTEGER
)AS 
$$
	BEGIN 
		DELETE FROM inventory
		WHERE film_id = _film_id AND inventory_id = _inventory_id;
		COMMIT;
	END
$$
LANGUAGE plpgsql;

SELECT *
FROM inventory; 

CALL delete_inv(6,1)

--if its been rented



