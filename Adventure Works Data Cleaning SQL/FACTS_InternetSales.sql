-- Clean FactInternetSales Table

SELECT 
[ProductKey],
[OrderDateKey],
[DueDateKey],
[ShipDateKey],
[CustomerKey],
--[PromotionKey]
--[CurrencyKey]
--[SalesTerritoryKey]
[SalesOrderNumber],
--[SalesOrderLineNumber]
--[RevisionNumber]
--[OrderQuantity]
--[UnitPrice]
--[ExtendedAmount]
--[UnitPriceDiscountPct]
--[DiscountAmount]
--[ProductStandardCost]
--[TotalProductCost]
[SalesAmount]
--[TaxAmt]
--[Freight]
--[CarrierTrackingNumber]
--[CustomerPONumber]
--[OrderDate]
--[DueDate]
--[ShipDate]
  FROM [AdventureWorksDW2019].[dbo].[FactInternetSales]
  where left(OrderDateKey, 4) >= year(getdate()) -2 --queries only the past 2 years of sales
  order by OrderDateKey asc