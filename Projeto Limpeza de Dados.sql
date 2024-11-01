-- Data cleaning

-- 1. Remover duplicidades
-- 2. Padronizar os dados
-- 3. Valores nulos e valores em branco
-- 4. Remoção de colunas e linhas desnecessárias


-- Criando uma tabela teste, para que caso ocorra erros os algo inesperado, não afetaremos os dados originais.

CREATE TABLE layoffs_teste
LIKE layoffs;

-- Adicionados os dados da tabela principal, na nova tabela.

INSERT INTO layoffs_teste
SELECT * 
FROM layoffs;


-- 1. Identificando valor duplicados

SELECT * 
FROM layoffs_teste;



WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER
(PARTITION BY company, location,industry, 
total_laid_off, percentage_laid_off, stage,country, funds_raised_millions, `date` ) AS row_num
FROM layoffs_teste
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Selecionando alguma dado dos que estão com o 2 no 'row_num', podemos confirmar filtrando e analisando essas linhas na tabela completa.
SELECT *
FROM layoffs_teste
WHERE company = 'Casper';
-- Aqui a primeira linha e a terceira, são exatamente iguais.

-- Criando uma tabela com a coluna row_num permanente
CREATE TABLE `layoffs_teste2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_teste2;

-- Inserindo os dados
INSERT INTO layoffs_teste2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location,industry, 
total_laid_off, percentage_laid_off, stage,country,
 funds_raised_millions, `date` ) AS row_num
FROM layoffs_teste;

-- Conferindo os valores duplicados
SELECT *
FROM layoffs_teste2
WHERE row_num > 1;

-- Deletando os valores duplicados
DELETE
FROM layoffs_teste2
WHERE row_num > 1;




-- 2. Padronizando os dados

SELECT DISTINCT company ,(TRIM(company))
FROM layoffs_teste2;

-- Tirando os espaços em branco da 'coluna company'
UPDATE layoffs_teste2
SET company = TRIM(company);

-- Selecionando industry para analise inconsistencias
SELECT DISTINCT industry
FROM layoffs_teste2
ORDER BY 1;

-- Há variantes referente à Crypto, há diferentes referências.
SELECT *
FROM layoffs_teste2
WHERE industry LIKE 'crypto%';

-- Substituindo valores inconsistentes
UPDATE layoffs_teste2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


-- Substituindo valores inconsistentes
SELECT DISTINCT country
FROM layoffs_teste2
ORDER BY 1;

-- United State estava com . no final de uma das linhas, vamos remover
UPDATE layoffs_teste2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Temos algumas localidade com erros, vamos alterar
SELECT DISTINCT location
FROM layoffs_teste2
ORDER BY 1;


-- Houve um erro ao converter os dados
SELECT location
FROM layoffs_teste2
WHERE location LIKE 'DÃ%ssel%';
-- Substituindo os valores
UPDATE layoffs_teste2
SET location = 'Dusseldorf'
WHERE location LIKE 'DÃ%ssel%';


-- Também houve um erro ao escrever Florianópolis
SELECT location
FROM layoffs_teste2
WHERE location LIKE 'Florian%';
-- Substituindo os valores
UPDATE layoffs_teste2
SET location = 'Florianopolis'
WHERE location LIKE 'Florian%';


-- Também houve um erro ao escrever Florianópolis
SELECT location
FROM layoffs_teste2
WHERE location LIKE 'Malm%';
-- Substituindo os valores
UPDATE layoffs_teste2
SET location = 'Malmo'
WHERE location LIKE 'Malm%';


-- Substituindo o formatado da coluna `date` que está como text
SELECT `date`
FROM layoffs_teste2;

UPDATE layoffs_teste2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_teste2
MODIFY COLUMN `date` DATE;



-- 3. Valores nulos e em branco

-- Podemos ver que há valores nulos nessa coluna
SELECT *
FROM layoffs_teste2
WHERE industry IS NULL
OR industry  = '';

-- Conferindo industry, podemos ver que há uma linha preenchida, provavelmente, a industry é a mesma
SELECT *
FROM layoffs_teste2
WHERE company = 'Airbnb';

-- Juntamos as duas tabelas para conferir se os valores em branco se encaixariam com os que temos preenchidos
SELECT *
FROM layoffs_teste2 t1
JOIN layoffs_teste2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

-- Primeiro vamos transformar os valores em branco, por valores nulos, para que a alteração funcione
UPDATE layoffs_teste2
SET industry = NULL
WHERE industry = '';

-- Substituimos os valores nulos, pelos valores já existentes.
UPDATE layoffs_teste2 t1
JOIN layoffs_teste2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


-- 4. Removendo colunas e linhas desnecessárias
-- Eliminando linhas que não serão úteis. Temos linhas com valores que não podemos substituir.
SELECT *
FROM layoffs_teste2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_teste2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


-- Vamos exculir a coluna row_num, não será mais necessária
ALTER TABLE layoffs_teste2
DROP COLUMN row_num;










