-- Change sale date into standardized date format

select SaleDate, convert(date, SaleDate)
from [Housing Project Database]..Housing_Data$

update Housing_Data$
set SaleDate = convert(date, SaleDate)

-- Populate the null property address data

select PropertyAddress
from [Housing Project Database]..Housing_Data$
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Housing Project Database]..Housing_Data$ a
Join [Housing Project Database]..Housing_Data$ b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]

update a 
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Housing Project Database]..Housing_Data$ a
Join [Housing Project Database]..Housing_Data$ b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--Turning the OwnerAddress column into 3 columns (Street Address, City, State)

select OwnerAddress
from [Housing Project Database]..Housing_Data$

select PARSENAME(replace(OwnerAddress, ',', '.') , 3)
, PARSENAME(replace(OwnerAddress, ',', '.') , 2)
, PARSENAME(replace(OwnerAddress, ',', '.') , 1)
from [Housing Project Database]..Housing_Data$


alter table Housing_Data$
add OwnerSplitAddress Nvarchar(255);

update Housing_Data$
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',', '.') , 3)

alter table Housing_Data$
add OwnerSplitCity Nvarchar(255);

update Housing_Data$
set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',', '.') ,2)

alter table Housing_Data$
add OwnerSplitState Nvarchar(255);

update Housing_Data$
set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',', '.') ,1)

-- Change the 'Y' and 'N' to 'Yes' and 'No' in the SoldAsVacant Column

select SoldAsVacant
from Housing_Data$
where SoldAsVacant = 'N'
	or SoldAsVacant = 'Y'

select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
from Housing_Data$

update Housing_Data$
set SoldAsVacant = 
		case when SoldAsVacant = 'Y' then 'Yes'
			 when SoldAsVacant = 'N' then 'No'
			 else SoldAsVacant
			 end

-- Remove duplicates from the dataset

with RowNumCTE as(
select *,
	ROW_NUMBER() over (
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by
					UniqueID
					) row_numb

from Housing_Data$
)
delete
from RowNumCTE
where row_numb = 2

-- delete columns that aren't useful anymore

 alter table housing_data$
 drop column OwnerAddress, TaxDistrict
  
  select *
  from Housing_Data$
