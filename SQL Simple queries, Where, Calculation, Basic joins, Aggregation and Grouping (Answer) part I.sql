
--I. Simple queries
--Ex1:
select
	EventName,
	EventDate
from
	tblEvent te
order by
	EventDate DESC;
	
--I.Ex2:
SELECT
	top 5 
	EventName as What,
	EventDetails as Details
from
	tblEvent te
order by
	EventDate;
	
--I.Ex3:
select
	TOP 3
	CategoryID,
	CategoryName 
from
	tblCategory
order by
	CategoryName desc;

--I.Ex4:

	select
		top 2 
	EventName,
		EventDetails
	from
		tblEvent te
	order by
		EventDate;
	
	select
		top 2
	EventName,
		EventDetails
	from
		tblEvent te2
	order by
		EventDate DESC;
	
	
--II. Where:
--Ex1:
select
	*
from
	tblEvent te
where
	CategoryID = 11;
	
--II.Ex2:
select
	*
from
	tblEvent te
where
	year(EventDate) = 2005
	and month(EventDate) = 2;

--II.Ex3:
select
	*
from
	tblEvent te
where
	EventName like '%Teletubbies%'
	or EventName like '%Pandy%';

--II.Ex4:
select
	*
from
	tblEvent te
where
	EventDetails like '%Water%'
	or CountryID in (8, 22, 30, 35)
	or CategoryID = 4
	and year(EventDate) >= 1970;

--II.Ex5:
select
	*
from
	tblEvent te
where
	EventDetails like '%Train%'
	or CategoryID != 14;

--II.Ex6:
select
	*
from
	tblEvent te
where
	CountryID = 13
	and EventName not like '%Space%'
	and EventDetails not like '%Space%';
	
--II.Ex7:
select
	*
from
	tblEvent te
where
	CategoryID = 6 or CategoryID = 5
	and(EventDetails not like '%War%'
	or EventDetails not like '%Death%');
	
--V.Basix joins:
--V.Ex1:
select
	Title,
	AuthorName
from
	tblEpisode te
left join tblAuthor ta on
	te.AuthorId = ta.AuthorId
where 
	EpisodeType like '%pecial%'
order BY 
	Title;

--V.Ex2:
select
	td.DoctorNumber,
	td.DoctorName,
	Title,
	EpisodeId,
	EpisodeNumber,
	EpisodeDate 
from
	tblEpisode te
left join tblDoctor td on
	te.DoctorId = td.DoctorId
where
	EpisodeDate like '%2010%'; 


--V.Ex3:
select
	tc.CountryName,
	te.EventName,
	te.EventDate
from
	tblCountry tc
inner join tblEvent te on
	tc.CountryID = te.CountryID
order by
	te.EventDate;


--V.Ex4:
select
	te.EventName,
	tc.ContinentName,
	tc2.CountryName 
from
	(tblContinent tc
	left join tblCountry tc2 on
	tc.ContinentID = tc2.ContinentID)
	left join tblEvent te on
	te.CountryID = tc2.CountryID 
where 
	tc.ContinentName like '%Antarctic%' or
	tc2.CountryName like '%Russia%'
order BY 
	te.EventName;


--V.Ex5: 
select
	*
from
	tblCategory tc
inner join tblEvent te on
	tc.CategoryID = te.CategoryID
order by 
	te.CategoryID;
	--There are 459 rows in full result table.

select
	tc.CategoryName,
	te.EventName
from
	tblCategory tc
full join tblEvent te on
	tc.CategoryID = te.CategoryID
order by 
	tc.CategoryName;
	--There are 461 rows in total.

select
	tc.CategoryName,
	te.EventName
from
	tblCategory tc
full join tblEvent te on
	tc.CategoryID = te.CategoryID
where 
	te.EventName is null
order by 
	tc.CategoryName;

--V.Ex6:
select 
	ta.AuthorName,
	te2.Title,
	te.EnemyName 
from tblEnemy te 
	inner join tblEpisodeEnemy tee on 
	te.EnemyId = tee.EpisodeEnemyId 
	inner join tblEpisode te2 on
	tee.EpisodeEnemyId = te2.EpisodeId 
	inner join tblAuthor ta on
	te2.EpisodeId = ta.AuthorId
WHERE
	EnemyName like '%Daleks%';


--V.Ex7:
select 
	te2.EnemyName,
	te2.Description,
	ta.AuthorName,
	te.Title,
	td2.DoctorName,
	len(ta.AuthorName),
	len(te.Title),
	len(td2.DoctorName),
	len(te2.EnemyName),
	(len(ta.AuthorName)+len(te2.EnemyName)+len(te.Title)+len(td2.DoctorName)) as [total length]
from
	tblEpisode te 
inner join tblAuthor ta on
	te.AuthorId = ta.AuthorId
inner join tblDoctor td2 on
	td2.DoctorId = te.DoctorId 
inner join tblEpisodeEnemy tee on
	tee.EpisodeId = te.EpisodeId 
inner join tblEnemy te2 on
	te2.EnemyId = tee.EnemyId
where
	(len(ta.AuthorName)+len(te2.EnemyName)+len(te.Title)+len(td2.DoctorName))<40;

--V.Ex8:
select
	tc.CountryName,
	te.EventName 
from
	tblCountry tc
full join tblEvent te on
	tc.CountryID = te.CountryID
where
	te.EventName is null;

--VI.Aggregation and grouping:
--VI.Ex1:
select
	ta.AuthorId,
	ta.AuthorName,
	count (distinct te.EpisodeID) as [# eps],
	max(te.EpisodeDate) as latest,
	min(te.EpisodeDate) as earliest
from
	tblEpisode te
inner join tblAuthor ta on
	te.AuthorId = ta.AuthorId
group BY 
	ta.AuthorId,
	ta.AuthorName 
order BY 
	count (distinct te.EpisodeId) desc;

--VI.Ex2:
select 
	tc.CategoryName,
	count (te.CategoryID) as [# events]
from
	tblCategory tc
inner join tblEvent te on
	tc.CategoryID = te.CategoryID
group by 
	tc.CategoryName
order BY 
	count(te.CategoryID);
	
--VI.Ex3:
select 
	count(te.EventID) as [number of events],
	min(te.EventDate) as [First Date],
	max(te.EventDate) as [Last Date]
from tblEvent te;

--VI.Ex4:
SELECT
	tc.ContinentName,
	tc2.CountryName,
	count(te.EventID) as [Number of events]
from
	tblContinent tc
inner join tblCountry tc2 on
	tc.ContinentID = tc2.ContinentID
inner join tblEvent te on
	te.CountryID = tc2.CountryID
group BY 
	tc.ContinentName, 
	tc2.CountryName
order BY 
	count(te.EventID);

--VI.Ex5:
SELECT
	ta.AuthorId,
	ta.AuthorName,
	td.DoctorId,
	td.DoctorName,
	count(DISTINCT te.EpisodeId) as [Number of episodes]
FROM
	tblAuthor ta
left join tblEpisode te on
	te.AuthorId = ta.AuthorId
left join tblDoctor td on
	td.DoctorId = te.DoctorId
group BY 
	ta.AuthorId,
	ta.AuthorName,
	td.DoctorName,
	td.DoctorId
having 
	count(DISTINCT te.EpisodeId) > 5;

--VI.Ex6:
SELECT 
	year(te.EpisodeDate) as [episode year],
	te2.EnemyName,
	year(td.BirthDate) as [D's year of birth],
	count(DISTINCT tee.EpisodeId) as [Number of episodes]
FROM
	tblEpisode te
inner join tblEnemy te2 on
	te2.EnemyId = te.EpisodeId
inner join tblDoctor td on
	td.DoctorId = te.DoctorId
inner join tblEpisodeEnemy tee on
	tee.EnemyId = te2.EnemyId
where 
	year(td.BirthDate) < 1970
group BY 
	te2.EnemyName,
	year(te.EpisodeDate),
	year(td.BirthDate)
HAVING 
	count(distinct tee.EpisodeId) >1
;

--VI.Ex7:

select
	left(tc.CategoryName,1) as [category initials],
	count(*) as [number of events],
	avg(len(te.EventName)) as [avg length]
FROM tblCategory tc 
	inner join tblEvent te on
	te.CategoryID = tc.CategoryID
group BY 
	left(tc.CategoryName,1) 
	;

--VI.Ex8:
SELECT
	1+ (year(te.EventDate)/100) as Century,
	count(distinct te.EventID) as [Number events]
FROM
	tblEvent te
group by
	1+ (year(te.EventDate)/100);
--VI. Ex6:
/* Write a query to list out for each episode year and enemy the number of episodes made, but in addition:
●	Only show episodes made by doctors born before 1970; and
●	Omit rows where an enemy appeared in only one episode in a particular year (sl episode <1, neu sl enemy id>1 nghia la trong eps day phai co 2 enemy => ko phai de bai yeu cau).
*/
select 
	year(tee.EpisodeDate) as [Episode year],
	tee2.EnemyId,
	year(td.BirthDate) as [D' year of birth],
	count(distinct tee.EpisodeId) as [appear]
FROM
	tblEpisode tee
inner join tblEpisodeEnemy tee2 on
	tee.EpisodeId = tee2.EpisodeId
inner join tblDoctor td on
	td.DoctorId = tee.DoctorId
where 
	year(td.BirthDate) < 1970
group BY 
	year(tee.EpisodeDate),
	tee2.EnemyId ,
	year(td.BirthDate)
HAVING 
	count(distinct tee.EpisodeId) >1
	
--VI. Ex7:
/*Create a query which shows two statistics for each category initial:
1.	The number of events for categories beginning with this letter; and
2.	The average length in characters of the event name for categories beginning with this letter.
*/
SELECT 
	left(tc.CategoryName,
	1) as [Category initials],
	count(distinct te.EventID) as [number of events],
	avg(len(te.EventName)) as [average length]
FROM
	tblEvent te
inner join tblCategory tc on
	te.CategoryID = tc.CategoryID
group BY 
	left(tc.CategoryName,
	1)
order BY 
	left(tc.CategoryName,
	1);

--VI. Ex8:
SELECT 
	CONCAT((year(EventDate)-1)/100+1, 
	 case when right((year(EventDate)-1)/100+1,1) =1 then 'st'
	 when right((year(EventDate)-1)/100+1,1) =2 then 'nd'
	 when right((year(EventDate)-1)/100+1,1) =3 then 'rd'
	 else 'th'
	 end,
	 ' century'),
	 count(distinct te.EventID) as [number events]
FROM tblEvent te 
group by
	(year(EventDate)-1)/100+1;

SELECT distinct year(EventDate),
1 +(year(EventDate)-1)/100 as century
from tblEvent te 
