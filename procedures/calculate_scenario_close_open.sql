DELIMITER //

DROP PROCEDURE IF EXISTS calculate_scenario_close_open //

/*
Sort the close-open scenarios by a Bayesian rating.

Example:
CALL calculate_scenario_close_open
*/
CREATE PROCEDURE calculate_scenario_close_open()
BEGIN
	/* todo: run this to get average 'percent up'
	select avg(r) from (
		select a.stock_id,
			sum(a.percent > 0) / count(a.stock_id) r, -- percent of 'percents up'
			count(*) v -- num of releases
		from (SELECT sco.earnings_id,
				sco.percent,
				er.stock_id
			from scenario_close_open sco
			inner join earnings_release er
				on er.earnings_id = sco.earnings_id
		) a
		group by a.stock_id
		order by r desc
	) b
	*/

	select s.stock_id,
		s.symbol,
		s.company_name,
		(v / (v+5)) * r + (5 / (v + 5)) * 0.5789 bay
	from (
		select a.stock_id,
			sum(a.percent > 0) / count(a.stock_id) r, -- percent of 'percents up'
			count(*) v -- num of releases
		from (SELECT sco.earnings_id,
				sco.percent,
				er.stock_id
			from scenario_close_open sco
			inner join earnings_release er
				on er.earnings_id = sco.earnings_id
		) a
		group by a.stock_id
		order by r desc
	) b
	inner join stock s
		on s.stock_id = b.stock_id
	order by bay desc;
END //
DELIMITER ;