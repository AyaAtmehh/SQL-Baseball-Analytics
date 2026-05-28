-- PART II: SALARY ANALYSIS

-- TASK 1: View the salaries table
SELECT * FROM salaries;

-- TASK 2: Return the top 20% of teams in terms of average annual spending [Window Functions]
WITH ts AS (SELECT 	teamID, yearID, SUM(salary) AS total_spend
			FROM	salaries
			GROUP BY teamID, yearID
			), 
            
	 sp AS (SELECT	teamID, AVG(total_spend) AS avg_spend,
					NTILE(5) OVER (ORDER BY AVG(total_spend) DESC) AS spend_pct
			FROM	ts
			GROUP BY teamID)
            
SELECT	teamID, ROUND(avg_spend / 1000000, 1) AS avg_spend_millions
FROM	sp
WHERE	spend_pct = 1;

-- TASK 3: For each team, show the cumulative sum of spending over the years [Rolling Calculations]
WITH ts AS (SELECT	 teamID, yearID, SUM(salary) AS total_spend
			FROM	 salaries
			GROUP BY teamID, yearID
			) 
            
SELECT	teamID, yearID,
		ROUND(SUM(total_spend) OVER (PARTITION BY teamID ORDER BY yearID) / 1000000, 1)
			AS cumulative_sum_millions
FROM	ts;

-- TASK 4: Return the first year that each team's cumulative spending surpassed 1 billion [Min / Max Value Filtering]
WITH ts AS (SELECT	 teamID, yearID, SUM(salary) AS total_spend
			FROM	 salaries
			GROUP BY teamID, yearID
			), 
            
	 cs AS (SELECT	teamID, yearID,
					SUM(total_spend) OVER (PARTITION BY teamID ORDER BY yearID)
						AS cumulative_sum
			FROM	ts),
            
	 rn AS (SELECT	teamID, yearID, cumulative_sum,
					ROW_NUMBER() OVER (PARTITION BY teamID ORDER BY cumulative_sum) AS rn
			FROM	cs
			WHERE	cumulative_sum > 1000000000)
            
SELECT	teamID, yearID, ROUND(cumulative_sum / 1000000000, 2) AS cumulative_sum_billions
FROM	rn
WHERE	rn = 1;