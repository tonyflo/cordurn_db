/*
DROP TABLE cordurn.scenario_close_open
*/
CREATE TABLE cordurn.scenario_close_open
(
	earnings_scenario_id INT AUTO_INCREMENT NOT NULL,
	earnings_id INT NOT NULL,
	before_close_id BIGINT NOT NULL, -- close before release
	after_open_id BIGINT NOT NULL, -- open after release
	percent DECIMAL(10,6) NOT NULL, -- percent increase or decrease
	PRIMARY KEY (earnings_scenario_id),
	FOREIGN KEY (earnings_id) REFERENCES earnings_release(earnings_id),
	FOREIGN KEY (before_close_id) REFERENCES ohlc(ohlc_id),
	FOREIGN KEY (after_open_id) REFERENCES ohlc(ohlc_id),
	CONSTRAINT uc_earnings_id UNIQUE (earnings_id)
)