/*
DROP TABLE cordurn.stock
*/
CREATE TABLE cordurn.stock
(
	stock_id INT NOT NULL AUTO_INCREMENT,
	symbol VARCHAR(5) NOT NULL,
	company_name VARCHAR(128) NOT NULL,
	PRIMARY KEY (stock_id),
	UNIQUE (symbol),
	UNIQUE (company_name)
)