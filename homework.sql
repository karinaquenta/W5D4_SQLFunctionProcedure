--Function:
SELECT *
FROM payment 
WHERE payment_id = '17504';

DROP FUNCTION late_fee;
CREATE OR REPLACE FUNCTION late_fee (
	_payment_id INTEGER,  
	_customer_id INTEGER,
	late_fee_amount NUMERIC(4,2)
)
RETURNS NUMERIC(4,2) AS 
$$
	BEGIN 
	UPDATE payment 
	SET amount = amount + late_fee_amount
	WHERE payment_id = _payment_id AND customer_id = _customer_id;
	RETURN amount FROM payment WHERE payment_id = _payment_id;
	END;
$$
LANGUAGE plpgsql;

SELECT late_fee(17504, 341, 1.00);


--Procedure: Added an actor to actor table

SELECT *
FROM actor ;
--#1
CREATE OR REPLACE PROCEDURE add_actor(
	_first_name VARCHAR(50), 
	_last_name VARCHAR(50)
)AS 
$$
	BEGIN 
		INSERT INTO actor( 
			first_name,
			last_name
		) VALUES (
			_first_name,
			_last_name
		);
		COMMIT;
	END;
$$
LANGUAGE plpgsql;

CALL add_actor('Karina', 'Quenta') --#2

SELECT *
FROM actor 
WHERE first_name = 'Karina' AND last_name = 'Quenta'; --#3
