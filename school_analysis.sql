-- PART I: SCHOOL ANALYSIS

-- TASK 1: View the schools and school details tables
SELECT * FROM schools;
SELECT * FROM school_details;

-- TASK 2: In each decade, how many schools were there that produced players? [Numeric Functions]
SELECT 	FLOOR(yearID / 10) * 10 AS decade, COUNT(DISTINCT schoolID) AS num_schools
FROM	schools
GROUP BY decade
ORDER BY decade;

-- TASK 3: What are the names of the top 5 schools that produced the most players? [Joins]
SELECT	 sd.name_full, COUNT(DISTINCT s.playerID) AS num_players
FROM	 schools s LEFT JOIN school_details sd
		 ON s.schoolID = sd.schoolID
GROUP BY s.schoolID
ORDER BY num_players DESC
LIMIT 	 5;

-- TASK 4: For each decade, what were the names of the top 3 schools that produced the most players? [Window Functions]
WITH ds AS (SELECT	 FLOOR(s.yearID / 10) * 10 AS decade, sd.name_full, COUNT(DISTINCT s.playerID) AS num_players
			FROM	 schools s LEFT JOIN school_details sd
					 ON s.schoolID = sd.schoolID
			GROUP BY decade, s.schoolID),
            
	 rn AS (SELECT	decade, name_full, num_players,
					ROW_NUMBER() OVER (PARTITION BY decade ORDER BY num_players DESC) AS row_num
                   
			FROM	ds)
            
SELECT	decade, name_full, num_players
FROM	rn
WHERE	row_num <= 3
ORDER BY decade DESC, row_num;



