DELIMITER //

DROP PROCEDURE IF EXISTS insert_scenario_close_open //

/*
Inserts historical earnings scenarios into the cordurn.scenario_close_open table given
a stock_id. A scenario is defined as buying the close price before an earnings release
and selling the open prices after an earnings release.
TODO:
* Releases with specific times are incorrectly delt with
* Earnings releases with 'Time Not Supplied' are ignored for now.

Example:
CALL insert_scenario_close_open(6820)
*/
CREATE PROCEDURE insert_scenario_close_open
(
	IN p_stock_id INT
)
BEGIN
	DROP TEMPORARY TABLE IF EXISTS before_dates;
	create temporary table before_dates (date DATE);
	insert into before_dates(date)
	select date FROM ohlc
	WHERE ohlc.stock_id = p_stock_id
	ORDER BY date ASC;

	DROP TEMPORARY TABLE IF EXISTS after_dates;
	create temporary table after_dates (date DATE);
	insert into after_dates(date)
	select date FROM ohlc
	WHERE ohlc.stock_id = p_stock_id
	ORDER BY date ASC;
	
	insert into scenario_close_open(earnings_id, before_close_id, after_open_id, percent)
	select earnings_id,
		before_close_id,
		after_open_id,
		CAST((after_open - before_close) / before_close as DECIMAL(10,6)) AS percent
	from 
		(SELECT er.earnings_id,
			er.release_date,
			before_close.ohlc_id as before_close_id,
			after_open.ohlc_id as after_open_id,
			before_close.close as before_close,
			after_open.high as after_open
		FROM earnings_release er
		INNER JOIN ohlc after_open
			ON er.stock_id = after_open.stock_id
			AND er.release_time != 'After Market Close'
			AND er.release_time != 'Time Not Supplied'
			AND (er.release_time = 'Before Market Open'
				 or TIME(STR_TO_DATE(er.release_time, '%T')) <= CAST('12:00:00' AS TIME))
			AND after_open.date = er.release_date
		inner join ohlc before_close
			on er.stock_id = before_close.stock_id
			AND before_close.date = (SELECT date -- previous trade date
									FROM before_dates bd
									WHERE bd.date < er.release_date
									ORDER BY bd.date DESC 
									LIMIT 1)
		WHERE er.stock_id = p_stock_id
		UNION ALL
		SELECT er.earnings_id,
			er.release_date,
			before_close.ohlc_id as before_close_id,
			after_open.ohlc_id as after_open_id,
			before_close.close as before_close,
			after_open.open as after_open
		FROM earnings_release er
		INNER JOIN ohlc before_close
			ON er.stock_id = before_close.stock_id
			AND er.release_time != 'Before Market Open'
			AND er.release_time != 'Time Not Supplied'
			AND (er.release_time = 'After Market Close'
			 	or TIME(STR_TO_DATE(er.release_time, '%T')) > CAST('12:00:00' AS TIME))
			AND before_close.date = er.release_date
		inner join ohlc after_open
			on er.stock_id = after_open.stock_id
			AND after_open.date = (SELECT date -- next trade date
									FROM after_dates ad
									WHERE ad.date > er.release_date
									ORDER BY ad.date ASC 
									LIMIT 1)
		WHERE er.stock_id = p_stock_id
		order by release_date
	) AS scenario;
END //
DELIMITER ;
