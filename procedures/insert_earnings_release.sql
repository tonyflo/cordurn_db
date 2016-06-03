DELIMITER //

DROP PROCEDURE IF EXISTS insert_earnings_release //

/*
CALL insert_earnings_release('2016-06-09', 'After Market Close', 'HRB', 'H & R Block Inc')
CALL insert_earnings_release('2016-05-09', 'After Market Close', 'RAX', 'Rackspace Hosting Inc')
CALL insert_earnings_release('2016-06-02', 'After Market Close', 'FIVE', 'Five Below Inc')
*/
CREATE PROCEDURE insert_earnings_release
(
	IN release_date DATE,
	IN release_time VARCHAR(25),
	IN symbol VARCHAR(5),
	IN company_name VARCHAR(128)
) 
BEGIN
	
	# insert into cordurn.stock if the stock symbol doesn't exist
	SET @stock_id = (SELECT stock_id FROM cordurn.stock s WHERE s.symbol = symbol);
	IF @stock_id IS NULL THEN
		CALL insert_stock(symbol, company_name, @stock_id);
	END IF;

	# use stock_id to insert into cordurn.earnings_release
	INSERT INTO cordurn.earnings_release(stock_id, release_date, release_time) 
	VALUES(@stock_id, release_date, release_time);

END //
DELIMITER ;
