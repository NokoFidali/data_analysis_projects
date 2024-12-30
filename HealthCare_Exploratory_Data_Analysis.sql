-- Exploratory Data Analysis
SELECT `Age Group`, COUNT(`Age Group`) AS count
FROM healthcare_unique
GROUP BY `Age Group`
ORDER BY count DESC;

-- Which gender is attacked more?
SELECT Gender, COUNT(Gender) AS count
FROM healthcare_unique
GROUP BY Gender;

-- Which bloodtype is attacked more?
SELECT `Blood Type`, COUNT(`Blood Type`) AS count
FROM healthcare_unique
GROUP BY `Blood Type`
ORDER BY count DESC;

-- Which insurance_provider is used by many patients?
SELECT `Insurance Provider`, COUNT(`Insurance Provider`) AS count 
FROM healthcare_unique
GROUP BY `Insurance Provider`
ORDER BY count DESC;

-- Avarage cost of medical conditions?
SELECT `Medical Condition`, ROUND(AVG(`Billing Amount`), 2) AS `Average Amount` 
FROM healthcare_unique
GROUP BY `Medical Condition`
ORDER BY `Average Amount` DESC;

-- Average time at hospital
SELECT `Medical Condition`, ROUND(AVG(`Days in Hospital`), 2) AS `Average Days`
FROM healthcare_unique
GROUP BY `Medical Condition`
ORDER BY `Average Days` DESC;


-- Count occurrences of medical conditions by test results, ordered by condition and count
SELECT 
    `Medical Condition` AS `Condition`, 
    `Test Results` AS `Results`, 
    COUNT(`Medical Condition`) AS `Condition Count`
FROM 
    healthcare_unique
GROUP BY 
    `Medical Condition`, `Test Results`
ORDER BY 
    `Medical Condition`, `Condition Count` DESC;
    
 
WITH medical_medication AS (
	SELECT `Medical Condition`, Medication, COUNT(`Medical Condition`) AS count,
	ROW_NUMBER() OVER(
		PARTITION BY `Medical Condition` ORDER BY COUNT(`Medical Condition`) DESC
		) as row_num
	FROM healthcare_unique
	GROUP BY `Medical Condition`, Medication
)
SELECT * FROM medical_medication
WHERE row_num = 1
ORDER BY count DESC
;

-- Medical conditions per year 
SELECT `Year`, COUNT(`Year`) as count
FROM healthcare_unique
GROUP BY `Year`
ORDER BY count DESC;

-- Blood type medical condition
WITH RankedBloodTypeCondition AS (
	SELECT `Blood Type`, `Medical Condition`, COUNT(`Blood Type`) AS count,
    ROW_NUMBER() OVER(
		PARTITION BY `Blood Type` ORDER BY COUNT(`Blood Type`) DESC 
    ) AS row_num
	FROM healthcare_unique
    GROUP BY `Blood Type`, `Medical Condition`
    )
SELECT * 
FROM RankedBloodTypeCondition
WHERE row_num = 1;

-- Most Common Medical Condition by Blood Type
WITH YearMedicalCondition AS (
	SELECT `Year`, `Medical Condition`, COUNT(`Year`),
    ROW_NUMBER() OVER(
		PARTITION BY `Year` ORDER BY COUNT(`YEAR`) DESC
    ) AS row_num
    FROM healthcare_unique
    GROUP BY `Year`, `Medical Condition`
)
SELECT * 
FROM YearMedicalCondition
WHERE row_num = 1;

-- Top Medical Condition by Average Billing Amount Per Year 
WITH RankedBilling AS (
	SELECT `Year`, `Medical Condition`, ROUND(AVG(`Billing Amount`), 2) AS average_billing,
    ROW_NUMBER() OVER(
		PARTITION BY `Year` ORDER BY ROUND(AVG(`Billing Amount`), 2) DESC
    ) AS row_num
	FROM healthcare_unique
	GROUP BY `Year`, `Medical Condition`
	ORDER BY `Year`)

SELECT * 
FROM RankedBilling 
WHERE row_num = 1
;

SELECT *
FROM healthcare_unique;



