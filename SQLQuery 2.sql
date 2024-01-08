SELECT *
       FROM [project].[dbo].[Nashvile]

	   --strandised the date

	alter table nashvile
	add Sale_Date date

	update Nashvile
	set sale_date = CONVERT(date,saledate)

	--- In this step we are adding another column that Sale_date at first and then updating the value of that column



	-- populating the address

	select uniqueID, count(distinct(uniqueID)) No_of_unique_ID
from nashvile
group by [UniqueID ]
order by No_of_unique_ID

--- we rand that command to check if there any unique ID that is same.

	select a.parcelID,b.PropertyAddress,a.PropertyAddress
	from nashvile a
	join nashvile b
	on a.parcelID = b.ParcelID
	where a.PropertyAddress is null and b.PropertyAddress is not null
	
	-- The property address which doesn't have any address in it are the same address that has the same parcel ID

	update a
	set a.propertyaddress = ISNULL(a.propertyaddress,b.propertyaddress)
	from nashvile a
	join nashvile b
	on a.parcelID = b.ParcelID
	where a.PropertyAddress is null and b.PropertyAddress is not null

	-- we've assigned the same property address to the property address which was null and having the same parcelID

	select 
	substring(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) as Address
	from nashvile
	-- The address columns is messy with both street address and city, we are going split that into two columns, one in which the city displays and other one one has street address in it.

alter table nashvile
	add City nvarchar(255)

	update Nashvile
	set city = substring(propertyaddress,CHARINDEX(',',propertyaddress)+1,LEN(PropertyAddress))

alter table nashvile
	add street_address nvarchar(255)

	update Nashvile
	set street_address = substring(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) 

	-- The owner's address column is also messy, we're going to separate into three columns but instead of doing it using substring method we're going to use the prasename method. since parsename will only work on periods.
	-- We're going to segregate the address into 3 periods by using '.'

	 alter table nashvile
	add owners_street_address nvarchar(255),
	 city_name nvarchar(255),
	state nvarchar(255)

	update Nashvile
	set owners_street_address=parsename(replace(owneraddress,',','.'),3) ,
	city_name=parsename(replace(owneraddress,',','.'),2) ,
	state = parsename(replace(owneraddress,',','.'),1)




	--- Now we're going to clean the soldasvacant column as 52 of the Yes are in single letter i.e.Y, and 399 of the No are in N. 

	select distinct(soldasvacant),count(soldasvacant)
	from Nashvile
	group by SoldAsVacant
	-- WE're going to use the case statement to change N to no and Y to Yes.



	alter table nashvile
	add Sold_as_vacant nvarchar(355)

	update Nashvile
	set sold_as_vacant=case
	when SoldAsVacant = 'Y' then 'yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end

	select distinct(sold_as_vacant),count(sold_as_vacant)
	from Nashvile
	group by (sold_as_vacant)

	--- now everything got sorted out, here we could've used the same column to make the necessity arrangements that has been made, but for everthing i'm creating a new columns to showcase the work that I did.




	-- WE're now going to delete the unused columns 

	alter table nashvile
	drop column propertyaddress,saledate,soldasvacant,owneraddress