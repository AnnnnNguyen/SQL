--I.Subquesries:
--Ex1:
SELECT
	te2.EventID ,
	te2.EventName,
	te2.EventDate 
FROM
	tblEvent te2
WHERE
	te2.EventDate >
(
	SELECT
		max(te.EventDate)
	FROM
		tblEvent te
	where
		te.CountryID = 21);
		
	
--Ex2:
SELECT
	te2.EventID ,
	te2.EventName
FROM
	tblEvent te2
where
	len(te2.EventName)>
	(
	SELECT
		avg(len(te.EventName)) as [avg length]
	FROM
		tblEvent te );
		
--Ex3:
SELECT
	te.EventID ,
	te.EventName ,
	tc.ContinentID,
	tc2.ContinentName 
FROM
	tblEvent te
left join tblCountry tc on
	tc.CountryID = te.CountryID
left join tblContinent tc2 on
	tc.ContinentID = tc2.ContinentID 
where
	tc.ContinentID in 
(
	SELECT
		top 3 tc.ContinentID
	FROM
		tblEvent te2
	left join tblCountry tc on
		te2.CountryID = tc.CountryID
	group by
		tc.ContinentID
	order by
		count(EventID));


--Ex4: 
SELECT distinct
	tc.CountryID ,
	tc.CountryName
FROM
	tblEvent te
left join tblCountry tc on
	te.CountryID = tc.CountryID
where
	tc.CountryID in 
(
	SELECT
		te.CountryID
	FROM
		tblEvent te
	group BY
		te.CountryID
	HAVING
		count(EventID)>8);

--Ex5:
SELECT
	te.EventID ,
	te.EventName
FROM
	tblEvent te
left join tblCountry tc2 on
	te.CountryID = tc2.CountryID
where
	tc2.CountryID not in
(
	SELECT
		top 30
		tc.CountryID
	FROM
		tblCountry tc
	order by
		tc.CountryName desc)
	and te.CategoryID not in
(
	SELECT
		top 15
	tc.CategoryID
	FROM
		tblCategory tc
	order by
		tc.CategoryName desc);
		
--II.CTEs
--Ex1:
with thisandthat as
(
select
	te.EventID,
	case
		when te.EventDetails like '%this%' then 1
		else 0
	end as Ifthis,
	case
		when te.EventDetails like '%that%' then 1
		else 0
	end as Ifthat
from
	tblEvent te
),
Step2 as
(select 
	distinct
	tat.Ifthis,
	tat.Ifthat,
	count(te.EventID) as [Number of events]
FROM
	tblEvent te
left join thisandthat tat on
	te.EventID = tat.EventID
group by
	tat.Ifthis,
	tat.Ifthat)
	
SELECT
	te.EventName ,
	te.EventDetails
FROM
	tblEvent te
left join thisandthat tt on
	te.EventID = tt.EventID
where
	tt.Ifthis > 0
	and tt.Ifthat >0;


--Ex2:
SELECT
	CountryName,
	EventName
from
	(
	SELECT
		te.EventName ,
		te.CountryID
	FROM
		tblEvent te
	where
		right(te.EventName,
		1) in ('n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z')) as Second_half_Derived
left join tblCountry tc on
	tc.CountryID = Second_half_Derived.CountryID;

--Ex3:
with episodeIDmp as 
(
SELECT
	te2.EpisodeId
FROM
	tblEpisode te2
left join tblDoctor td on
	td.DoctorId = te2.DoctorId
left join tblAuthor ta on
	ta.AuthorId = te2.AuthorId
where
	ta.AuthorName like '%MP%')
	--1.
SELECT 
	te.EpisodeId ,
	te.Title
FROM
	tblEpisode te
left join episodeIDmp on
	te.EpisodeId = episodeIDmp.EpisodeID 
where
	te.EpisodeId = episodeIDmp.EpisodeID
	--2.
SELECT distinct
	tc.CompanionName
FROM
	tblEpisode te
left join episodeIDmp on
	te.EpisodeId = episodeIDmp.EpisodeID
left join tblEpisodeCompanion tec on
	tec.EpisodeId = te.EpisodeId 
left join tblCompanion tc on
	tc.CompanionId = tec.CompanionId  
where
	te.EpisodeId = episodeIDmp.EpisodeID;


--Ex4:
with noneowl as
(
SELECT
	te.EventID ,
	te.EventName,
	te.CountryID
FROM
	tblEvent te
where
	te.EventDetails not like '%o%'
	AND 
	te.EventDetails not like '%w%'
	AND
	te.EventDetails not like '%l%'),
Step2 as 
(
SELECT
	noneowl.CountryID,
	te.EventName,
	te.CategoryID
FROM
	tblEvent te
left join noneowl on
	noneowl.CountryID = te.CountryID
where
	noneowl.CountryID = te.CountryID)

SELECT distinct
	te.EventName ,
	te.EventDate ,
	tc.CategoryName
FROM
	tblEvent te
left join tblCategory tc on
	tc.CategoryID = te.CategoryID
inner join Step2 s2 on
	te.CategoryID = s2.CategoryID
where
	te.CategoryID = s2.CategoryID
order BY
	te.EventDate;


--Ex4: In class
with notowlevents as
(
SELECT
	*
FROM
	tblEvent te
where
	EventDetails not like '%o%'
	and EventDetails not like '%l%'
	and EventDetails not like '%w%')
,
othereventisnonowlcountries as 
(
SELECT tc.CountryName ,
tc.CountryID ,
te2.EventName ,
te2.CategoryID 
from
	notowlevents noe
left join tblCountry tc on
	tc.CountryID = noe.countryid
inner join tblEvent te2 on
	noe.countryid = te2.CountryID)

SELECT
	distinct tc2.CategoryName ,
	te3.EventName 
from
	othereventisnonowlcountries io
left join tblCategory tc2 on
	io.CategoryID = tc2.CategoryID
left join tblEvent te3 on
	te3.CategoryID = io.CategoryID;
	
--Ex5: 
with Era as
(
SELECT
	case
		when (1 + year(te.EventDate)/ 100) <= 19 then '19th century and earlier'
		when (1 + year(te.EventDate)/ 100) = 20 then '20th century'
		else '21st century'
	end as Era,
	te.EventID
FROM
	tblEvent te)

select
	Era.Era,
	count(te.EventID) as [Number of Events]
FROM
	tblEvent te
left join Era on
	te.EventID = Era.EventID
group BY
	Era.Era;