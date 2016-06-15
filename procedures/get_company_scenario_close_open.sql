DELIMITER //

DROP PROCEDURE IF EXISTS get_company_scenario_close_open //

/*
Gets the prior close and after open and percent change given a stock_id

Example:
CALL get_company_scenario_close_open(3568)
*/
CREATE PROCEDURE get_company_scenario_close_open
(
	IN p_stock_id INT
)
BEGIN
	select earnings_scenario_id,
		release_date,
		percent,
		bef.close,
		aft.open
	from earnings_release er 
	inner join scenario_close_open sco
		on er.earnings_id = sco.earnings_id
	inner join ohlc bef
		on bef.ohlc_id = sco.before_close_id
	inner join ohlc aft
		on aft.ohlc_id = sco.after_open_id
	where er.stock_id = p_stock_id
	order by release_date desc;

END //
DELIMITER ;
