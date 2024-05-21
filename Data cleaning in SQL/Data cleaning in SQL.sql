-- Cleaning data in SQL querries

Select *
From PortfolioUse.dbo.JustSomeRandomNashvilleHousing


--Standardize date format

Select SaleDate, convert (date,SaleDate)
From PortfolioUse.dbo.JustSomeRandomNashvilleHousing

Update JustSomeRandomNashvilleHousing
Set SaleDate = convert (date,SaleDate)

Alter table JustSomeRandomNashvilleHousing
add SaleDateConverted Date;

Update JustSomeRandomNashvilleHousing
 Set SaleDateConverted = convert (date,SaleDate)

 -- Populate property address data

 Select *
From PortfolioUse.dbo.JustSomeRandomNashvilleHousing
--Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
From PortfolioUse.dbo.JustSomeRandomNashvilleHousing a 
join PortfolioUse.dbo.JustSomeRandomNashvilleHousing b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
--Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
From PortfolioUse.dbo.JustSomeRandomNashvilleHousing a 
join PortfolioUse.dbo.JustSomeRandomNashvilleHousing b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


-- Breaking out address into individual columns


 Select PropertyAddress
From PortfolioUse.dbo.JustSomeRandomNashvilleHousing
--Where PropertyAddress is null
--Order by ParcelID

Select
Substring (PropertyAddress,1,CHARINDEX(',', PropertyAddress) -1) as Address,
Substring (PropertyAddress,CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as Address
From PortfolioUse.dbo.JustSomeRandomNashvilleHousing

Alter table JustSomeRandomNashvilleHousing
add PropertySplitAddress Nvarchar(255);

Update JustSomeRandomNashvilleHousing
 Set PropertySplitAddress = Substring (PropertyAddress,1,CHARINDEX(',', PropertyAddress) -1)


 Alter table JustSomeRandomNashvilleHousing
add PropertySplitCity Nvarchar(255);

Update JustSomeRandomNashvilleHousing
 Set PropertySplitCity = Substring (PropertyAddress,CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))



Select *
From PortfolioUse.dbo.JustSomeRandomNashvilleHousing


Select OwnerAddress
From PortfolioUse.dbo.JustSomeRandomNashvilleHousing

Select 
PARSENAME (Replace(OwnerAddress,',','.'),3),
PARSENAME (Replace(OwnerAddress,',','.'),2),
PARSENAME (Replace(OwnerAddress,',','.'),1)
From PortfolioUse.dbo.JustSomeRandomNashvilleHousing


Alter table JustSomeRandomNashvilleHousing
add OwnerSplitAddress Nvarchar(255);

Update JustSomeRandomNashvilleHousing
 Set OwnerSplitAddress = PARSENAME (Replace(OwnerAddress,',','.'),3)


 Alter table JustSomeRandomNashvilleHousing
add OwnerSplitCity Nvarchar(255);

Update JustSomeRandomNashvilleHousing
 Set OwnerSplitCity = PARSENAME (Replace(OwnerAddress,',','.'),2)


 Alter table JustSomeRandomNashvilleHousing
add OwnerSplitState Nvarchar(255);

Update JustSomeRandomNashvilleHousing
 Set OwnerSplitState = PARSENAME (Replace(OwnerAddress,',','.'),1)

 Select *
From PortfolioUse.dbo.JustSomeRandomNashvilleHousing

--Alter table JustSomeRandomNashvilleHousing
--Drop Column PropertySplitState


-- Change Y and N to YES and NO in "Sold as vacant" field


Select Distinct SoldAsVacant, count (SoldAsVacant)
From PortfolioUse.dbo.JustSomeRandomNashvilleHousing
Group by SoldAsVacant
Order by 2




Select SoldAsVacant,
Case When SoldAsVacant = 'Y' then 'Yes'
     When SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 End
From PortfolioUse.dbo.JustSomeRandomNashvilleHousing

Update JustSomeRandomNashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' then 'Yes'
     When SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 End





-- Remove duplicates

With RowNumCTE as (
Select *,
ROW_NUMBER() over (
Partition by ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 Order by
			  UniqueID)
			  row_num

From PortfolioUse.dbo.JustSomeRandomNashvilleHousing
--Order by ParcelID
)
Select * 
From RowNumCTE
Where row_num >1
--Order by PropertyAddress


-- Delete Unused columns

Select *
From PortfolioUse.dbo.JustSomeRandomNashvilleHousing

Alter table JustSomeRandomNashvilleHousing
Drop column OwnerAddress, TaxDistrict, PropertyAddress

Alter table JustSomeRandomNashvilleHousing
Drop column SaleDate