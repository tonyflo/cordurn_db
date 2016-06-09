DELIMITER //

DROP PROCEDURE IF EXISTS insert_earnings_scenario //

/*
Inserts historical earnings scenarios into the cordurn.earnings_scenario table given
a stock_id. A scenario is either worst case or best case. A worst case scenario is 
defined by buying high before a release and selling low after a release. A best case
scenario is defined by buying low before a release and selling high after a release.
Earnings releases with 'Time Not Supplied' are ignored for now.

Example:
CALL insert_earnings_scenario(405)
*/
CREATE PROCEDURE insert_earnings_scenario
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
	
	-- insert into earnings_scenario(earnings_id, before_ohlc_id, after_ohlc_id, bcs, wcs)
	select earnings_id,
		before_ohlc_id,
		after_ohlc_id,
		(after_high - before_low) / before_low AS bcs,
		(after_low - before_high) / before_high AS wcs
	from 
		(SELECT er.earnings_id,
			er.release_date,
			before_ohlc.ohlc_id as before_ohlc_id,
			after_ohlc.ohlc_id as after_ohlc_id,
			before_ohlc.low as before_low,
			before_ohlc.high as before_high,
			after_ohlc.low as after_low,
			after_ohlc.high as after_high
		FROM earnings_release er
		INNER JOIN ohlc after_ohlc
			ON er.stock_id = after_ohlc.stock_id
			AND (er.release_time = 'Before Market Open'
				 or TIME(STR_TO_DATE(er.release_time, '%h:%i:%s')) <= CAST('12:00:00' AS TIME))
			AND after_ohlc.date = er.release_date
		inner join ohlc before_ohlc
			on er.stock_id = before_ohlc.stock_id
			AND before_ohlc.date = (SELECT date -- previous trade date
									FROM before_dates bd
									WHERE bd.date < er.release_date
									ORDER BY bd.date DESC 
									LIMIT 1)
		WHERE er.stock_id = p_stock_id
		UNION ALL
		SELECT er.earnings_id,
			er.release_date,
			before_ohlc.ohlc_id as before_ohlc_id,
			after_ohlc.ohlc_id as after_ohlc_id,
			before_ohlc.low as before_low,
			before_ohlc.high as before_high,
			after_ohlc.low as after_low,
			after_ohlc.high as after_high
		FROM earnings_release er
		INNER JOIN ohlc before_ohlc
			ON er.stock_id = before_ohlc.stock_id
			AND (er.release_time = 'After Market Close'
			 	or TIME(STR_TO_DATE(er.release_time, '%h:%i:%s')) > CAST('12:00:00' AS TIME))
			AND before_ohlc.date = er.release_date
		inner join ohlc after_ohlc
			on er.stock_id = after_ohlc.stock_id
			AND after_ohlc.date = (SELECT date -- next trade date
									FROM after_dates ad
									WHERE ad.date > er.release_date
									ORDER BY ad.date ASC 
									LIMIT 1)
		WHERE er.stock_id = p_stock_id
		order by release_date
	) AS scenario;
END //
DELIMITER ;
