SELECT*
FROM ['Nashville Housing$']

--Standardize Date Format
SELECT SalesDateConverted, CONVERT(Date,SaleDate)
FROM ['Nashville Housing$']

UPDATE ['Nashville Housing$']
SET SaleDate=CONVERT(Date,SaleDate)


ALTER TABLE ['Nashville Housing$']
ADD SalesDateConverted Date;

UPDATE ['Nashville Housing$']
SET SalesDateConverted=CONVERT(Date,SaleDate)

--Populate Property Address Data

SELECT*
FROM ['Nashville Housing$']
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM ['Nashville Housing$']A
JOIN ['Nashville Housing$']B
ON A.ParcelID=B.ParcelID
AND A.[UniqueID ]<>B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

UPDATE A
SET PropertyAddress=ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM ['Nashville Housing$']A
JOIN ['Nashville Housing$']B
ON A.ParcelID=B.ParcelID
AND A.[UniqueID ]<>B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

--Breaking out address into individual columns(adress, City, State)
SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))AS Address
FROM ['Nashville Housing$']

ALTER TABLE ['Nashville Housing$']
ADD PropertySplitAddress NVARCHAR(255);

UPDATE ['Nashville Housing$']
SET PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE ['Nashville Housing$']
ADD PropertySplitCity NVARCHAR(255);

UPDATE ['Nashville Housing$']
SET PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))

SELECT*
FROM ['Nashville Housing$']



SELECT OwnerAddress
FROM ['Nashville Housing$']

SELECT--PARSENAME DOES THINGS BACKWARDS AND RECOGNIZES PERIODS INSTEAD OF COMMAS
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM ['Nashville Housing$']

ALTER TABLE ['Nashville Housing$']
ADD OwnerSplitAdress NVARCHAR(255);

UPDATE ['Nashville Housing$']
SET OwnerSplitAdress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE ['Nashville Housing$']
ADD OwnerSplitCity NVARCHAR(255);

UPDATE ['Nashville Housing$']
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)
ALTER TABLE ['Nashville Housing$']
ADD OwnerSplitState NVARCHAR(255);

UPDATE ['Nashville Housing$']
SET OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT*
FROM ['Nashville Housing$']

--CHANGING Y AND N TO YES OR NO USING CASE STATEMENT

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM ['Nashville Housing$']
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant='Y' THEN 'Yes'
WHEN SoldAsVacant='N' THEN 'No'
ELSE SoldAsVacant
END
FROM ['Nashville Housing$']

UPDATE ['Nashville Housing$']
SET SoldAsVacant=CASE WHEN SoldAsVacant='Y' THEN 'Yes'
WHEN SoldAsVacant='N' THEN 'No'
ELSE SoldAsVacant
END

-- REMOVING DUPLICATES
WITH RowNumCte AS(
SELECT*,
ROW_NUMBER () OVER(
PARTITION BY ParcelID, PropertyAddress,SalePrice,SaleDate,LegalReference
ORDER BY uniqueID
)ROWNUM
FROM ['Nashville Housing$'])
--SELECT *
DELETE
FROM RowNumCte
WHERE ROWNUM>1
--ORDER BY PropertyAddress

--DELETE UNUSED COLUMNS
SELECT*
FROM ['Nashville Housing$']

ALTER TABLE ['Nashville Housing$']
DROP COLUMN TaxDistrict
