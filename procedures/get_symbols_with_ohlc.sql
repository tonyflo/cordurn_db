DELIMITER //

DROP PROCEDURE IF EXISTS get_symbols_with_ohlc //

/*
Returns symbols and their id that have price DATA

Example:
CALL get_symbols_with_ohlc;
*/
CREATE PROCEDURE get_symbols_with_ohlc()
BEGIN
	SELECT DISTINCT s.stock_id, s.symbol
	FROM ohlc o
	INNER JOIN stock s
		ON s.stock_id = o.stock_id;
END //
DELIMITER ;
