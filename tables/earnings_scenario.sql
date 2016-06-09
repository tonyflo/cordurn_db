/*
DROP TABLE cordurn.earnings_scenario
select * from earnings_scenario
*/
CREATE TABLE cordurn.earnings_scenario
(
	earnings_scenario_id INT AUTO_INCREMENT NOT NULL,
	earnings_id INT NOT NULL,
	before_ohlc_id BIGINT NOT NULL, -- ohlc before release
	after_ohlc_id BIGINT NOT NULL, -- ohlc after release
	bcs DECIMAL(10,6) NOT NULL, -- best case scenario
	wcs DECIMAL(10,6) NOT NULL, -- worst case scenario
	PRIMARY KEY (earnings_scenario_id),
	FOREIGN KEY (earnings_id) REFERENCES earnings_release(earnings_id),
	FOREIGN KEY (before_ohlc_id) REFERENCES ohlc(ohlc_id),
	FOREIGN KEY (after_ohlc_id) REFERENCES ohlc(ohlc_id),
	CONSTRAINT uc_earnings_id UNIQUE (earnings_id)
)
