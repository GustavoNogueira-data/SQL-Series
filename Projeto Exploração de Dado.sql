-- Análise exploratória de dados
SELECT *
FROM layoffs_teste2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_teste2;

SELECT *
FROM layoffs_teste2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC
;

SELECT *
FROM layoffs_teste2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC
;

SELECT company, MAX(total_laid_off)
FROM layoffs_teste2
GROUP BY company
ORDER BY 2 DESC;

SELECT industry, MAX(total_laid_off)
FROM layoffs_teste2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, MAX(total_laid_off)
FROM layoffs_teste2
GROUP BY country
ORDER BY 2 DESC;

SELECT `date`, MAX(total_laid_off)
FROM layoffs_teste2
GROUP BY `date`
ORDER BY 1 DESC;

SELECT YEAR(`date`), MAX(total_laid_off)
FROM layoffs_teste2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT SUBSTRING(`date`,6,2) AS `Mounth`, SUM(total_laid_off)
FROM layoffs_teste2
GROUP BY `Mounth`;

SELECT SUBSTRING(`date`,1,7) AS `Mounth`, SUM(total_laid_off)
FROM layoffs_teste2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Mounth`
ORDER BY 1 ASC;


WITH Total_acumulado AS
(
SELECT SUBSTRING(`date`,1,7) AS `Mounth`, SUM(total_laid_off) AS total
FROM layoffs_teste2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Mounth`
ORDER BY 1 ASC
)
SELECT `Mounth`, total,
SUM(total) OVER (ORDER BY `Mounth`)
FROM Total_acumulado;


WITH Company_Year (Company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off) AS total
FROM layoffs_teste2
GROUP BY company, YEAR(`date`)
),
Company_Year_Rank AS
(
SELECT *,
DENSE_RANK () OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;





























