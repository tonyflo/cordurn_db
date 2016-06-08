/*
DROP TABLE cordurn.earnings_scenario
*/
CREATE TABLE cordurn.earnings_scenario
(
	earnings_scenario_id INT AUTO_INCREMENT NOT NULL,
	earnings_id INT NOT NULL,
	before_ohlc_id BIGINT NOT NULL, -- ohlc before release
	after_ohlc_id BIGINT NOT NULL, -- ohlc after release
	wcs DECIMAL NOT NULL, -- worst case scenario
	bcs DECIMAL NOT NULL, -- best case scenario
	PRIMARY KEY (earnings_scenario_id),
	FOREIGN KEY (earnings_id) REFERENCES earnings_release(earnings_id),
	FOREIGN KEY (before_ohlc_id) REFERENCES ohlc(ohlc_id),
	FOREIGN KEY (after_ohlc_id) REFERENCES ohlc(ohlc_id),
	CONSTRAINT uc_earnings_id UNIQUE (earnings_id)
)
