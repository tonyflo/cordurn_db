/*
DROP TABLE cordurn.ohlc
*/
CREATE TABLE cordurn.ohlc
(
	stock_id INT NOT NULL,
	date DATE NOT NULL,
	open DECIMAL(13,6) UNSIGNED NOT NULL,
	high DECIMAL(13,6) UNSIGNED NOT NULL,
	low DECIMAL(13,6) UNSIGNED NOT NULL,
	close DECIMAL(13,6) UNSIGNED NOT NULL,
	adj_close DECIMAL(13,6) UNSIGNED,
	volume INT UNSIGNED,
	FOREIGN KEY (stock_id) REFERENCES stock(stock_id),
	CONSTRAINT uc_stock_id_release_date UNIQUE (stock_id, date)
)