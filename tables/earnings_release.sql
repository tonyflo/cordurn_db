/*
DROP TABLE cordurn.earnings_release
*/
CREATE TABLE cordurn.earnings_release
(
	earnings_id INT NOT NULL AUTO_INCREMENT UNIQUE,
	stock_id INT NOT NULL,
	release_date DATE NOT NULL,
	release_time VARCHAR(25) NOT NULL,
	PRIMARY KEY (earnings_id),
	FOREIGN KEY (stock_id) REFERENCES stock(stock_id),
	CONSTRAINT uc_stock_id_release_date UNIQUE (stock_id, release_date)
)