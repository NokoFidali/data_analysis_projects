-- Explotory Data Analysis

SELECT * FROM layoffs_staging2;

-- Which country laid off more people and raised how many funds? 
SELECT country, SUM(total_laid_off), SUM(funds_raised_millions)
FROM layoffs_staging2
GROUP BY country
ORDER BY SUM(total_laid_off) DESC, SUM(funds_raised_millions);

-- Which industry laid off more people and raised how many funds?
SELECT industry, SUM(total_laid_off), SUM(funds_raised_millions)
FROM layoffs_staging2
GROUP BY industry
ORDER BY SUM(total_laid_off) DESC, SUM(funds_raised_millions);

-- Which year most people got laid off and how many funds were raised?
SELECT YEAR(`date`), SUM(total_laid_off), SUM(funds_raised_millions)
FROM  layoffs_staging2
WHERE YEAR(`date`) IS NOT NULL
GROUP BY YEAR(`date`)
ORDER BY SUM(total_laid_off) DESC;

-- Which company laid off all the stuff?
SELECT company, percentage_laid_off
FROM layoffs_staging2
WHERE percentage_laid_off = 1; 

WITH Company_Year(company, years, total_laid_off) AS 
(
	SELECT company, YEAR(`date`), SUM(total_laid_off)
    FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
	(SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking 
	FROM Company_Year
	WHERE years IS NOT NULL)
SELECT * FROM Company_Year_Rank
WHERE ranking <=5;


SELECT * FROM layoffs_staging2;