--CLEANING DATA WITH SQL

SELECT* 
from Housing_Potfolio_project..NashvilleHousing


--Standarizing date format 

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date

UPDATE NashvilleHousing
set SaleDateConverted = CONVERT(date, SaleDate)



--Populate Property Address data ( where it is NULL)

SELECT X.ParcelID, X.PropertyAddress, Y.ParcelID, Y.PropertyAddress, ISNULL(X.PropertyAddress, Y.PropertyAddress)
FROM Housing_Potfolio_project..NashvilleHousing X 
JOIN Housing_Potfolio_project..NashvilleHousing Y
ON X.ParcelID = Y.ParcelID
AND X.[UniqueID ] <> Y.[UniqueID ]
WHERE X.PropertyAddress IS NULL

UPDATE X
SET PropertyAddress = ISNULL(X.PropertyAddress, Y.PropertyAddress)
FROM Housing_Potfolio_project..NashvilleHousing X 
JOIN Housing_Potfolio_project..NashvilleHousing Y
ON X.ParcelID = Y.ParcelID
AND X.[UniqueID ] <> Y.[UniqueID ]
WHERE X.PropertyAddress IS NULL


Select PropertyAddress
from Housing_Potfolio_project..NashvilleHousing
where PropertyAddress is null   --RETURN AN AMPTY TABLE CAUSE ALL THE NULLS HAVE BEEN POPULATED





--Breaking out addresses into 3 columns (Address, City, State)
select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS Address,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS City,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS State


from Housing_Potfolio_project..NashvilleHousing


ALter table NashvilleHousing
add AddressN NVARCHAR(255), City NVARCHAR(255), State NVARCHAR(255)

Update NashvilleHousing
SET AddressN = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
City = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
State =  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)




--Replace N and Y by Yes and NO in SoldVacant

select SoldAsVacant, 
CASE WHEN SoldAsVacant= 'Y' then 'Yes'
     WHEN SoldAsVacant= 'N' THEN 'No'
	 ELSE SoldAsVacant end AS Corrected
	 from Housing_Potfolio_project..NashvilleHousing

	 UPDATE Housing_Potfolio_project..NashvilleHousing
	 SET SoldAsVacant = CASE WHEN SoldAsVacant= 'Y' then 'Yes'
     WHEN SoldAsVacant= 'N' THEN 'No'
	 ELSE SoldAsVacant end

	 select SoldAsVacant
	 from Housing_Potfolio_project..NashvilleHousing
	 where SoldAsVacant = 'Yes' or SoldAsVacant = 'No'


	 
	 --Find Duplicates
	 
	 with duplicates AS 
	( SELECT   SaleDate, OwnerName, PropertyAddress, SalePrice,LegalReference, COUNT(*) as NUM
FROM Housing_Potfolio_project..NashvilleHousing
GROUP BY SaleDate, OwnerName, PropertyAddress, SalePrice, LegalReference

HAVING COUNT(*) > 1 and OwnerName is not null
) 

select *
from duplicates


-- Delete unused  columns

ALTER TABLE Housing_Potfolio_project..NashvilleHousing
Drop COLUMN TaxDistrict

select*
from Housing_Potfolio_project..NashvilleHousing
