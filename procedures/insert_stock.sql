DELIMITER //

DROP PROCEDURE IF EXISTS insert_stock //

/*
Insert a stock symbol and company name into the cordurn.stock table

Examples:
CALL insert_stock('HAS', 'Hasbro Inc', @out_stock_id)
CALL insert_stock('NFLX', 'Netflix Inc', @out_stock_id);
CALL insert_stock('FIVE', 'Five Below Inc', @out_stock_id);
*/
CREATE PROCEDURE insert_stock 
(
	IN symbol VARCHAR(5),
	IN company_name VARCHAR(128),
	OUT out_stock_id INT
) 
BEGIN
	INSERT INTO cordurn.stock(symbol, company_name)
	VALUES(symbol, company_name);
	SET out_stock_id = LAST_INSERT_ID();
END //
DELIMITER ;