DELIMITER //

DROP PROCEDURE IF EXISTS sanatize_earnings_release //

/*
Sanatize earnings release data

Example:
CALL sanatize_earnings_release;
*/
CREATE PROCEDURE sanatize_earnings_release()
BEGIN
	SET SQL_SAFE_UPDATES = 0;

	-- update garbase release time to 'Time Not Supplied'
	UPDATE earnings_release dest,
	(SELECT * FROM earnings_release
	WHERE release_time != 'Before Market Open'
		AND release_time != 'After Market Close' 
		AND release_time != 'Time Not Supplied'
		AND release_time NOT LIKE '% ET'
		AND release_time NOT LIKE '%:%:%') src
	SET dest.release_time = 'Time Not Supplied'
	WHERE src.earnings_id = dest.earnings_id;

	-- update time from 12 hour 'HH:MM [ap]m ET' to 24 hour 'HH:MM:00'
	UPDATE earnings_release dest,
	(SELECT * FROM earnings_release
	WHERE release_time LIKE '% ET') src
	SET dest.release_time = TIME( STR_TO_DATE( src.release_time, '%h:%i %p' ) )
	WHERE src.earnings_id = dest.earnings_id;

	SET SQL_SAFE_UPDATES = 1;

END //
DELIMITER ;