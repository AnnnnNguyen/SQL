--III. CALCULATION:
--Ex1:
SELECT
	EventName,
	len(EventName) as [length]
FROM
	tblEvent te
order by
	len(EventName);
--Ex2:
SELECT
	concat(EventName, ' ', tc.CategoryID) as [Events name and category number]
FROM
	tblEvent te
inner join tblCategory tc on
	te.CategoryID = tc.CategoryID;
	
-- Ex3:
SELECT
	tc.ContinentID,
	tc.ContinentName,
	Summary,
	isnull(Summary,
	'No summary') as [Isnull],
	COALESCE (Summary,
	'No summary') as [Coalesce],
	case
		when tc.Summary is null then 'No summary'
		else tc.Summary
	end as [Case when]
FROM
	tblContinent tc;

--Ex4: --Bai nay em ra dap an nhung code dai dong qua co cach nao ngan hon khong a?
SELECT 
	case
		when ContinentID in (1, 3) then '1 or 3'
		when ContinentID in (5, 6) then '5 or 6'
		when ContinentID in (2, 4) then '2 or 4'
		when ContinentID = 7 then '7'
		else 'Otherwise'
	end as [Continent Id],
	case
		when ContinentID in (1, 3) then 'Eurasia'
		when ContinentID in (5, 6) then 'Americas'
		when ContinentID in (2, 4) then 'Somewhere hot'
		when ContinentID = 7 then 'Somewhere cold'
		else 'Somewhere else'
	end as [Belongs to],
	case
		when ContinentID in (1, 3) then 'Europe or Asia'
		when ContinentID in (5, 6) then 'North and South America'
		when ContinentID in (2, 4) then 'Africa and Autralia'
		when ContinentID = 7 then 'Antartica'
		else 'International'
	end as [Actual continent (for interest)]
FROM
	tblContinent tc
group by
	case
		when ContinentID in (1, 3) then 'Eurasia'
		when ContinentID in (5, 6) then 'Americas'
		when ContinentID in (2, 4) then 'Somewhere hot'
		when ContinentID = 7 then 'Somewhere cold'
		else 'Somewhere else'
	end,
	case
		when ContinentID in (1, 3) then '1 or 3'
		when ContinentID in (5, 6) then '5 or 6'
		when ContinentID in (2, 4) then '2 or 4'
		when ContinentID = 7 then '7'
		else 'Otherwise'
	end,
	case
		when ContinentID in (1, 3) then 'Europe or Asia'
		when ContinentID in (5, 6) then 'North and South America'
		when ContinentID in (2, 4) then 'Africa and Autralia'
		when ContinentID = 7 then 'Antartica'
		else 'International'
	end
order by 
	[Continent ID];

--Ex5:
SELECT
	*,
	KmSquared%20761 as [AreaLeftOver],
	((KmSquared - KmSquared%20761)/ 20761) as [WalesUnit],
	round(KmSquared/20761,0) as [walestimes],
	concat(Country, ' could accomodate Wales ',((KmSquared - KmSquared%20761)/ 20761), ' times'),
	concat(round(KmSquared/20761,0),' x Wales plus ',KmSquared%20761,' sq.km') as Walescomparison
FROM
	CountriesByArea cba
order by
	abs(KmSquared -20761) ;


--Ex6:
SELECT
	EventName
FROM
	tblEvent te2
WHERE
	left(EventName,
	1) like '[aeuoi]'
	AND right(EventName,
	1) like '[aeuoi]';


--Ex7:
SELECT
	EventName
FROM
	tblEvent te2
WHERE
	left(EventName,
	1) like right(EventName,
	1);

--IV. Calculation using date:
--Ex1:
SELECT
	EventID,
	format(EventDate,
	'dd/MM/yyyy') as [Event date],
	EventName ,
	EventDetails
FROM
	tblEvent te
WHERE
	year(EventDate) = 2001
order BY
	EventDate ;

--Ex2:
select
	datediff(day, '2001-03-22', getdate());

select
	te.EventID,
	te.EventName ,
	EventDate ,
	abs(datediff(day, '2001-03-22', EventDate)) as [Difference]
from
	tblEvent te
order by
	abs(datediff(day, '2001-03-22', EventDate));

--Ex3:
SELECT 
	EventDate,
	EventName ,
	concat(datename(weekday, te.EventDate), ' ', datepart(day, te.EventDate),
	case when datepart(day, te.EventDate) in (01, 21, 31) then 'st'
		when datepart(day, te.EventDate) in (02, 22) then 'nd'
		when datepart(day, te.EventDate) in (03, 23) then 'rd'
		else 'th'
		end) as [Date]
FROM
	tblEvent te
where 
	concat(datename(weekday, te.EventDate), ' ', datepart(day, te.EventDate),
	case when datepart(day, te.EventDate) in (01, 21, 31) then 'st'
		when datepart(day, te.EventDate) in (02, 22) then 'nd'
		when datepart(day, te.EventDate) in (03, 23) then 'rd'
		else 'th'
		end) like 'Friday 13th'
	or  
		concat(datename(weekday, te.EventDate), ' ', datepart(day, te.EventDate),
	case when datepart(day, te.EventDate) in (01, 21, 31) then 'st'
		when datepart(day, te.EventDate) in (02, 22) then 'nd'
		when datepart(day, te.EventDate) in (03, 23) then 'rd'
		else 'th'
		end) like 'Thursday 12th'
	or
		concat(datename(weekday, te.EventDate), ' ', datepart(day, te.EventDate),
	case when datepart(day, te.EventDate) in (01, 21, 31) then 'st'
		when datepart(day, te.EventDate) in (02, 22) then 'nd'
		when datepart(day, te.EventDate) in (03, 23) then 'rd'
		else 'th'
		end) like 'Saturday 14th'
order by
	EventName;


--Ex4:
SELECT
	EventName ,
	concat(datename(weekday, EventDate), ' ', datepart(day, EventDate), 
	case when datepart(day, EventDate) in (01, 21, 31) then 'st'
	when datepart(day, EventDate) in (02, 22) then 'nd'
	when datepart(day, EventDate) in (03, 23) then 'rd'
	else 'th'
	end, ' ', datename(month, EventDate), ' ', year(EventDate))
FROM
	tblEvent te
order by
	EventDate;
