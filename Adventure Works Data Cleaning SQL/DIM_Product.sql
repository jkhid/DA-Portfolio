-- Clean DIM_Product Table

SELECT
p.[ProductKey],
p.[ProductAlternateKey] as ProductItemCode,
--[ProductSubcategoryKey]
--[WeightUnitMeasureCode]
--[SizeUnitMeasureCode]
p.[EnglishProductName] as ProductName,
pc.EnglishProductCategoryName as ProductCategory,
ps.EnglishProductSubcategoryName as SubCategory,
--[SpanishProductName]
--[FrenchProductName]
--[StandardCost]
--[FinishedGoodsFlag]
p.[Color] as ProductColor,
--[SafetyStockLevel]
--[ReorderPoint]
round(p.[ListPrice], 2) as ListPrice,
p.[Size] as ProductSize,
--[SizeRange]
--[Weight]
--[DaysToManufacture]
p.[ProductLine] as ProductLine,
--[DealerPrice]
--[Class]
--[Style]
p.[ModelName] as ProductModelName,
--[LargePhoto]
p.[EnglishDescription] as EnglishDescription,
--[FrenchDescription]
--[ChineseDescription]
--[ArabicDescription]
--[HebrewDescription]
--[ThaiDescription]
--[GermanDescription]
--[JapaneseDescription]
--[TurkishDescription]
--[StartDate]
--[EndDate]
isnull(p.status, 'Outdated') as ProductStatus
FROM [AdventureWorksDW2019].[dbo].[DimProduct] as p
left join dbo.DimProductSubcategory as ps
	on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
left join dbo.DimProductCategory as pc
	on pc.ProductCategoryKey = ps.ProductCategoryKey
order by p.ProductKey asc