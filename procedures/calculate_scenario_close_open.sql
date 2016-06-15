DELIMITER //

DROP PROCEDURE IF EXISTS calculate_scenario_close_open //

/*
Sort the close-open scenarios by a Bayesian rating.

Bayesian formula:
	weighted rating (WR) = (v ÷ (v+m)) × R + (m ÷ (v+m)) × C
	
	where:
	* R = average for the movie (mean) = (Rating)
	* v = number of votes for the movie = (votes)
	* m = minimum votes required to be listed in the Top 250 (currently 1300)
	* C = the mean vote across the whole report (currently 6.8)

TODO:
* Eliminate duplication between multiple statements
* Okay parameters?
* Clean up variable names

Example:
CALL calculate_scenario_close_open
*/
CREATE PROCEDURE calculate_scenario_close_open()
BEGIN

	SET @min_releases = 5; -- minimum number of release in order be be considered

	-- calculate the average number of times that stocks are up after a release
	SET @average_up = (
		SELECT AVG(r)
		FROM (
			SELECT a.stock_id,
				SUM(a.percent > 0) / COUNT(a.stock_id) r, -- percent of 'percents up'
				COUNT(*) v -- num of releases
			FROM (
				SELECT sco.earnings_id,
					sco.percent,
					er.stock_id
				FROM scenario_close_open sco
				INNER JOIN earnings_release er
					ON er.earnings_id = sco.earnings_id
			) a
			GROUP BY a.stock_id
			ORDER BY r DESC
		) b
	);

	SELECT s.stock_id,
		s.symbol,
		s.company_name,
		(v / (v+5)) * r + (@min_releases / (v + @min_releases)) * @average_up AS bay_rating
	FROM (
		SELECT a.stock_id,
			SUM(a.percent > 0) / COUNT(a.stock_id) r, -- percent of 'percents up'
			COUNT(*) v -- num of releases
		FROM (
			SELECT sco.earnings_id,
				sco.percent,
				er.stock_id
			FROM scenario_close_open sco
			INNER JOIN earnings_release er
				ON er.earnings_id = sco.earnings_id
		) a
		GROUP BY  a.stock_id
		ORDER BY r DESC
	) b
	INNER JOIN stock s
		ON s.stock_id = b.stock_id
	ORDER BY bay_rating DESC;
END //
DELIMITER ;