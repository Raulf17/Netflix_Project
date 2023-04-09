----------------------- Query #1 Select * from netflix LIMIT --------------------------
SELECT TOP (10)*
FROM dbo.netflix_titles;

--select * from dbo.netflix_titles;

----------------------- Query #2:Select distinct  --------------------------
Select distinct(show_id) from dbo.netflix_titles;

----------------------- Query #3:Select where --------------------------
Select 
distinct(title) from dbo.netflix_titles
where release_year >2020;

----------------------- Query #4: Select and,or,not --------------------------
Select 
distinct(title) from dbo.netflix_titles
where release_year > 2020 and title='Blood & Water' or release_year < 2021 
and title='Kota Factory'and not country= 'India';

----------------------- Query #5: order by --------------------------
Select 
distinct(title) as name from dbo.netflix_titles
order by title; 

----------------------- Query #6: Min,Max,count,avg,sum --------------------------

Select
min(release_year) as min_release_year,
max(release_year) as max_release_year,
count(distinct release_year) as count_of_release_year,
round(avg(release_year),2) as avg_of_all_release_years,
sum(release_year) as avg_of_all_release_years
from dbo.netflix_titles;

----------------------- Query #7: Union ALL, Like --------------------------

SELECT DISTINCT 'country that Ends with ia: - ' + country AS Value
FROM dbo.netflix_titles
WHERE country LIKE '%ia'
UNION ALL
SELECT DISTINCT 'country that Starts with ia: - ' + country AS Value
FROM dbo.netflix_titles
WHERE country LIKE 'ia%'
UNION ALL
SELECT DISTINCT 'country that has ia: - ' + country AS Value
FROM dbo.netflix_titles
WHERE country LIKE '%ia%'
UNION ALL
SELECT DISTINCT 'country that starts and ends with a: - ' + country AS Value
FROM dbo.netflix_titles
WHERE country LIKE 'a%a';

----------------------- Query #8 : Union ALL, Like --------------------------
select * from dbo.netflix_titles
where country in ('India','United States','Austrailia')
order by country asc;
----------------------- Query #9 : Between --------------------------
select * from dbo.netflix_titles
where release_year between 2020 and 2021;

----------------------- Query #10 : Joins --------------------------
select
n1.show_id as Show_idtable1,
n2.type as Show_idTable2,
n2.title as Showtable2
from dbo.netflix_titles n1
join dbo.netflix_titles n2 on n1.show_id = n2.show_id;

----------------------- Query #11 : Case statements  --------------------------
select
sum(case when country='India' then 1 else 0 end) as Shows_in_India,
sum(case when country='United States' then 1 else 0 end) as Shows_in_United_States,
sum(case when country='South Africa' then 1 else 0 end) as Shows_in_South_Africa
from dbo.netflix_titles;

----------------------- Query #12 : Sub query  --------------------------
select distinct(a.title) from (select * from dbo.netflix_titles) a;

----------------------- Query #13 : WITH Statments  --------------------------

WITH top_directors AS (
    SELECT director, COUNT(*) AS num_titles
    FROM dbo.netflix_titles
    WHERE director IS NOT NULL
    GROUP BY director
    HAVING COUNT(*) > 5
)
SELECT *
FROM top_directors
ORDER BY num_titles DESC;

----------------------- Query #14 : Creating View  --------------------------

CREATE VIEW v_popular_genres AS
SELECT genre, COUNT(*) AS num_titles
FROM (
    SELECT value AS genre
    FROM dbo.netflix_titles
    CROSS APPLY STRING_SPLIT(listed_in, ',')
) AS genres
GROUP BY genre
HAVING COUNT(*) > 50;

SELECT * FROM v_popular_genres
ORDER BY num_titles DESC;

----------------------- Query #15 : Coalesce  --------------------------
select coalesce(release_year,0) as first_non_zero_value from dbo.netflix_titles;


----------------------- Query #16 : Coverting Data Types -------------------------

select cast(release_year as float) as first_non_zero_value from dbo.netflix_titles;


SELECT title, director, CAST(REPLACE(duration, ' min', '') AS INT) AS duration_in_minutes
FROM dbo.netflix_titles
WHERE type = 'Movie' AND duration IS NOT NULL;


----------------------- Query #17 : LAG/LEAD --------------------------
SELECT
    title,
    release_year,
    CASE 
        WHEN release_year = LAG(release_year) OVER (ORDER BY release_year ASC) THEN 1 
        ELSE 0 
    END AS Back_to_Back
FROM [dbo].[netflix_titles]
ORDER BY release_year ASC;
----------------------- Query #18 : Row Number --------------------------
SELECT 
    title, 
    type, 
    director,
    ROW_NUMBER() OVER (ORDER BY title ASC) as row_number
FROM [dbo].[netflix_titles]
ORDER BY title ASC;

----------------------- Query #19 : Dense Rank--------------------------
SELECT a.value FROM (
    SELECT 
        DISTINCT 'country that End with ia: - ' + country AS Value,
        DENSE_RANK() OVER (ORDER BY country ASC) AS rank 
    FROM [dbo].[netflix_titles]
    WHERE country LIKE '%ia'
) a
WHERE rank = 1

UNION ALL

SELECT a.value FROM (
    SELECT 
        DISTINCT 'first country that starts with a: - ' + country AS Value,
        DENSE_RANK() OVER (ORDER BY country ASC) AS rank 
    FROM [dbo].[netflix_titles]
    WHERE country LIKE 'a%'
) a
WHERE rank = 1

UNION ALL

SELECT a.value FROM (
    SELECT 
        DISTINCT 'country that has a and minimum length 4: - ' + country AS Value,
        DENSE_RANK() OVER (ORDER BY country ASC) AS rank 
    FROM [dbo].[netflix_titles]
    WHERE country LIKE 'a__%'
) a
WHERE rank = 1;









