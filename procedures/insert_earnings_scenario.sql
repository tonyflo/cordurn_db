DELIMITER //

DROP PROCEDURE IF EXISTS insert_earnings_scenario //

/*
CALL insert_earnings_scenario(1656)
*/
CREATE PROCEDURE insert_earnings_scenario
(
	IN stock_id INT
)
BEGIN

	-- todo: if exists logic
	create temporary table dts (date DATE);
	insert into dts(date)
	select date FROM ohlc
	WHERE stock_id = 1656
	ORDER BY date ASC;

	SELECT er.earnings_id,
		er.stock_id,
		er.release_date,
		er.release_time,
		ohlc_before.low as after_low,
		ohlc_before.high as after_high,
		ohlc_after.low as before_low,
		ohlc_after.high as before_high
	FROM earnings_release er
	INNER JOIN ohlc ohlc_before
		ON er.stock_id = ohlc_before.stock_id
		AND er.release_time = 'Before Market Open'
		AND ohlc_before.date = er.release_date
	inner join ohlc ohlc_after
		on er.stock_id = ohlc_after.stock_id
		AND ohlc_after.date = (SELECT date -- previous trade date
								FROM dts d
								WHERE d.date < '2016-03-03'-- er.release_date
								ORDER BY d.date DESC 
								LIMIT 1)
	WHERE er.stock_id = 1656;
	drop table dts;

/*
-- UNION ALL

	SELECT *
	FROM earnings_release er
	INNER JOIN ohlc ohlc_after
		ON er.stock_id = ohlc_after.stock_id
	WHERE er.stock_id = stock_id
		AND er.release_time = 'After Market Close'
		AND er.release_date = ohlc_after.date; -- current trade date
*/

END //
DELIMITER ;
