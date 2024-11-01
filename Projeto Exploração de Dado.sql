-- Análise exploratória de dados
SELECT *
FROM layoffs_teste2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_teste2;

-- Podemos observar que a maior parte das demissões foram do setor de construção.
SELECT *
FROM layoffs_teste2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC
;

-- Filtrando pela quantidade de fundos arrecadados em milhões.
SELECT company, location, industry, `date`, country, funds_raised_millions
FROM layoffs_teste2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC
;

-- Filtrando pela número máximo de demissões
SELECT company, MAX(total_laid_off)
FROM layoffs_teste2
GROUP BY company
ORDER BY 2 DESC;

-- Filtrando o número máximo de demissões por tipo de industria.
SELECT industry, MAX(total_laid_off)
FROM layoffs_teste2
GROUP BY industry
ORDER BY 2 DESC;

-- Máximo de demissõe por país.
SELECT country, MAX(total_laid_off)
FROM layoffs_teste2
GROUP BY country
ORDER BY 2 DESC;

-- Filtrando Máximo de demissõe por data.
SELECT `date`, MAX(total_laid_off)
FROM layoffs_teste2
GROUP BY `date`
ORDER BY 1 DESC;

-- Filtrando Máximo de demissõe por ano.
SELECT YEAR(`date`), MAX(total_laid_off)
FROM layoffs_teste2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Filtrando Máximo de demissõe por mês.
SELECT SUBSTRING(`date`,6,2) AS `Mounth`, SUM(total_laid_off)
FROM layoffs_teste2
GROUP BY `Mounth`;

-- Filtrando Máximo de demissõe por ano/mês.
SELECT SUBSTRING(`date`,1,7) AS `Mounth`, SUM(total_laid_off)
FROM layoffs_teste2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Mounth`
ORDER BY 1 ASC;

-- Total acumulado de demissões ao longo dos meses.
WITH Total_acumulado AS
(
SELECT SUBSTRING(`date`,1,7) AS `Mounth`, SUM(total_laid_off) AS total
FROM layoffs_teste2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Mounth`
ORDER BY 1 ASC
)
SELECT `Mounth`, total,
SUM(total) OVER (ORDER BY `Mounth`) AS Total_acumulado
FROM Total_acumulado;


-- Ranking dos maiores números de demissões.
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






























