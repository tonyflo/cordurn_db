DELIMITER //

DROP PROCEDURE IF EXISTS insert_earnings_release //

/*
CALL populate_historical_earnings('2016-06-09', 'After Market Close', 'HRB', 'H & R Block Inc')
CALL populate_historical_earnings('2016-06-09', 'After Market Close', 'NFLX', 'Netflix Inc')
*/
CREATE PROCEDURE insert_earnings_release
(
	release_date DATE,
	release_time VARCHAR(25),
	symbol VARCHAR(5),
	company_name VARCHAR(128)
) 
BEGIN
	SET @stock_id = (SELECT stock_id FROM cordurn.stock s WHERE s.symbol = symbol);
	IF @stock_id IS NULL THEN
		CALL insert_stock(symbol, company_name, @stock_id);
	END IF;

	# TODO: use stock_id to insert into cordurn.earnings_release
END //
DELIMITER ;
