-- Data Cleaning      

SELECT * FROM health_care.healthcare_dataset;

CREATE TABLE healthcare_staging
LIKE healthcare_dataset;

-- copying healthcare_dataset data 
INSERT healthcare_staging
SELECT *
FROM healthcare_dataset;

UPDATE healthcare_staging
SET name = CONCAT(UPPER(SUBSTRING(Name, 1, 1)), LOWER(SUBSTRING(Name, 2)));

SELECT * FROM healthcare_staging;

-- change column label to lowercase and replace empty character with hyphen 

DESCRIBE healthcare_staging;

-- remove duplicates 

-- option 1
SELECT `Name`, Age, `Medical Condition`, `Blood Type`, Gender, `Date of Admission`, COUNT(*) AS cnt
FROM healthcare_staging
GROUP BY `Name`, Age, `Medical Condition`, `Blood Type`, Gender, `Date of Admission`
HAVING cnt > 1;

-- option 2 
WITH duplicates_cte AS 
(
	SELECT *, 
	ROW_NUMBER() OVER (
	PARTITION BY `Name`, Age, Gender, `Blood Type`, `Medical Condition`, `Date of Admission`, Doctor, Hospital, `Insurance Provider`, `Billing Amount`, 'Room Number'
    ORDER BY `Date of Admission` DESC) as row_num
	FROM healthcare_staging
) 

SELECT * FROM duplicates_cte
WHERE row_num > 1;

-- option 3
CREATE TABLE healthcare_unique AS
SELECT DISTINCT *
FROM healthcare_staging;

ALTER TABLE healthcare_unique
MODIFY COLUMN `Discharge Date` DATE;

-- Add age group column 

ALTER TABLE healthcare_unique
ADD COLUMN `Age Group` VARCHAR(20);

UPDATE healthcare_unique
SET `Age Group` =
	CASE 
		WHEN Age < 18 THEN 'child'
        WHEN Age >= 18 AND Age < 30 THEN 'young_adult'  
        WHEN Age >= 30 AND Age < 45 THEN 'adult'
        WHEN Age >= 45 AND Age < 60 THEN 'middle_age'
        WHEN Age >= 60 AND Age < 85 THEN 'old_age'
		ELSE 'Elderly'
	END;

-- Add days in hospital column and calculate it 
ALTER TABLE healthcare_unique
ADD COLUMN `Days in Hospital` INT;

UPDATE healthcare_unique
SET `Days in Hospital` = DATEDIFF(`Discharge Date`, `Date of Admission`);

-- Add year column and calculate it 
ALTER TABLE healthcare_unique
ADD COLUMN `Year` INT;

UPDATE healthcare_unique
SET `Year` = YEAR(`Date of Admission`);

SELECT * FROM healthcare_unique;



