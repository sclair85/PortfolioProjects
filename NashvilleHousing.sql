----------------------------------
-- Cleaning Data in SQL Queries --
----------------------------------

SELECT * 
FROM PortfolioProject..NashvilleHousing

-----------------------------
-- Standardize Date Format --
-----------------------------

SELECT SaleDateConverted, CONVERT(Date, SaleDate) 
FROM PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

Update PortfolioProject.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

-----------------------------------
-- Populate Propery Address Data --
-----------------------------------

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT housing_a.ParcelID, housing_a.PropertyAddress, housing_b.ParcelID, housing_b.PropertyAddress, 
ISNULL(housing_a.PropertyAddress, housing_b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing housing_a
JOIN PortfolioProject.dbo.NashvilleHousing housing_b
	ON housing_a.ParcelID = housing_b.ParcelID
	AND housing_a.[UniqueID ] != housing_b.[UniqueID ]
WHERE housing_a.PropertyAddress IS NULL

UPDATE housing_a
SET PropertyAddress = ISNULL(housing_a.PropertyAddress, housing_b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing housing_a
JOIN PortfolioProject.dbo.NashvilleHousing housing_b
	ON housing_a.ParcelID = housing_b.ParcelID
	AND housing_a.[UniqueID ] != housing_b.[UniqueID ]
WHERE housing_a.PropertyAddress IS NULL

---------------------------------------------------------------------
-- Breaking Address into Individual Columns (Address, City, State) --
---------------------------------------------------------------------

SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS City
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress  = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) 

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress  = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field --
------------------------------------------------------------

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END

-----------------------
-- Remove Duplicates --
-----------------------

WITH RowNumCTE AS(
SELECT *, 
	ROW_NUMBER() OVER( 
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM PortfolioProject.dbo.NashvilleHousing
-- ORDER BY ParcelID
)
DELETE  
FROM RowNumCTE
WHERE row_num > 1

/*
SELECT * 
FROM RowNumCTE
WHERE row_num > 1
*/

---------------------------
-- Delete Unused Columns --
---------------------------

SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate

