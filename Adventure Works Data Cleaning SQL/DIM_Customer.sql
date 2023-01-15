-- Clean DIM_Customers Table

SELECT  
c.CustomerKey as CustomerKey,
--[GeographyKey],
--[CustomerAlternateKey],
--[Title],
c.FirstName as FirstName,
--[MiddleName]
c.LastName as LastName,
c.FirstName + ' ' + c.LastName as FullName,
case c.Gender
	when 'M' then 'Male' 
	when 'F' then 'Female' 
	end as Gender,
--[NameStyle],
--[BirthDate],
--[MaritalStatus],
--[Suffix],
--[EmailAddress],
--[YearlyIncome],
--[TotalChildren],
--[NumberChildrenAtHome],
--[EnglishEducation],
--[SpanishEducation],
--[FrenchEducation],
--[EnglishOccupation],
--[SpanishOccupation],
--[FrenchOccupation],
--[HouseOwnerFlag],
--[NumberCarsOwned],
--[AddressLine1],
--[AddressLine2],
--[Phone],
[DateFirstPurchase],
g.City as CustomerCity
--[CommuteDistance],
FROM [AdventureWorksDW2019].[dbo].[DimCustomer] as c
Left Join dbo.DimGeography as g
	on g.geographykey = c.geographykey
Order By CustomerKey ASC