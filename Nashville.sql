--Limpiando los datos en sql

--Select * from PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------
---- Estandarizando el formato de la fecha

--/*--1.- Se empezo intentando tomar la fecha de venta y actulizarla con el formato de fecha pero no dio resultado por lo tanto se tomaron las siguientes correciones
--Select SaleDate, CONVERT(date, saleDate)
--from PortfolioProject.dbo.NashvilleHousing
--*/

---- 2.- Se agrego una nueva columna a la tabla, con el formato de fecha
--ALTER TABLE NashvilleHousing
--ADD SaleDateConverted Date;

---- 3.- Se actualizo la nueva columna con los datos provenientes de una columna ya existente pero mantenienedo el formato de fecha
--Update NashvilleHousing
--set SaleDateConverted = CONVERT(Date, SaleDate)

---- 4.- Se hace seleccion de las columnas para apreciar que los cambios fueron relizados correctamente en diferencia a la primera consulta
--Select SaleDateConverted, CONVERT(date, saleDate)
--from PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------
----Corrigiendo direcciones de propiedades

----Hacemos un chequeo rapido de como se encuentran los datos en su forma base
--Select *
--from PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
----Nos damos cuenta que hay algunos datos que estan repitiendo 'ID' de parcelas por lo tanto deberian tener la misma direccion
----A la vez que notamos que algunos registros tienen 'UniqueID' y 'ParcelID' pero no tienen direccion.

----Aqui hacemos una consulta para revisar los registros que no tienen direccion y ordenamos por 'ParcelID' para hacer mas notoria la idea de que se tienen la misma 'ParcelID'
--Select *
--from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

----Preparamos una consulta para tener mas claro los campos que vamos a cambiar.
----Debido a que hay registros en los cuales se tiene la misma 'ParcelID' estos registros que comparten 'ParcelID' deberian tener la misma direccion por logica.
----La consulta que preparamos une dos tablas que en realidad son la misma, pero hacemos la condicion de que las junte donde el 'ParcelID' sea el mismo pero el 'UniqueID' sea distinto, ademas de que la propiedad de la tabla1 este vacia
--Select a.[UniqueID ],a.ParcelID, a.PropertyAddress,b.[UniqueID ], b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) as Si_Esta_Vacio_A
--from PortfolioProject.dbo.NashvilleHousing a
--JOIN PortfolioProject.dbo.NashvilleHousing b
--	ON a.ParcelID = b.ParcelID
--	AND a.[UniqueID ] <> b.[UniqueID ]
--where a.PropertyAddress is null

----Actualizamos la tabla1 con los datos de la tabla2 usando la funccion ISNULL("expresion que puede contener un null", "dato devuelto en caso de haberlo") = ISNULL(a.PropertyAddress, b.PropertyAddress)
----Usamos las mismas condiciones que la consulta anterior para asegurarnos de cuales son los datos que queremos cambiar.
--UPDATE a
--set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
--from PortfolioProject.dbo.NashvilleHousing a
--JOIN PortfolioProject.dbo.NashvilleHousing b
--	ON a.ParcelID = b.ParcelID
--	AND a.[UniqueID ] <> b.[UniqueID ]
--where a.PropertyAddress is null

----En este punto ya podemos hacer la primera consulta de nuevo:
--Select *
--from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID
----Notaremos que ya no nos aparece nada en la consulta debido a que ya no hay algun registro que cumpla con las condiciones.

---------------------------------------------------------------------------------------------------------------------------------------
---- Separando direcciones por direccion en columnas individuales (Direccion, Ciudad, Estado)

----Como se ven las direcciones en su forma base
--Select PropertyAddress
--from PortfolioProject.dbo.NashvilleHousing
--order by ParcelID

----Una consulta donde estamos revisando un 'String' dentro de un 'String', Substring("Donde queremos buscar?","Desde que posicion?","Que tanto buscamos?") as "Nombre del dato que queremos de vuelta en otra columna debido a que seguimos usando el select"
----Aqui lo que hicimos fue separar el String en 2, busca hasta donde hay una coma y luego devuelve el resultado menos una posicion para que no nos devuelva la coma.
----De igual manera separamos en 2, busca hasta donde esta la coma y luego devuelve el resultado una posicion mas para que no nos de la coma.
--select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress ) -1) as Address 
--	,	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress ) +1, LEN(PropertyAddress)) as Address1
--from PortfolioProject.dbo.NashvilleHousing

----Aqui vamos a agregar 2 columnas nuevas a la tabla, para despues actulizarla con los datos extraidos de la consulta anterior usando las mismas condiciones.

----Columna de Direccion
--ALTER TABLE NashvilleHousing
--add PropertySplitAddress NVARCHAR(255);

----Actulizacion en la tabla para Direccion
--Update NashvilleHousing
--set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress ) -1)



----Columna de Ciudad
--ALTER TABLE NashvilleHousing
--add PropertySplitCity NVARCHAR(255);

----Actulizacion en la tabla para ciudad

--Update NashvilleHousing
--set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress ) +1, LEN(PropertyAddress))

----Podemos apreciar la tabla entera con dos columnas nuevas al final las cuales contienen los datos nuevos de la forma en la que queremos para futuras consultas
--Select *
--from PortfolioProject.dbo.NashvilleHousing
--order by [UniqueID ]

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----Otra manera de separar un string en partes, usando la funcion PARSENAME, lo unico que se va a repetir aca, es el hecho de agregar nuevas columnas y agregar los datos

----Select * FROM PortfolioProject.dbo.NashvilleHousing

--Select PARSENAME(REPLACE(OwnerAddress, ',','.') ,3)
--,PARSENAME(REPLACE(OwnerAddress, ',','.') ,2)
--,PARSENAME(REPLACE(OwnerAddress, ',','.') ,1)
--from PortfolioProject.dbo.NashvilleHousing

----Columna de Owner direccion
--ALTER TABLE NashvilleHousing
--add OwnerSplitAddress NVARCHAR(255);

--Update NashvilleHousing
--set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.') ,3)

----Columna de Owner City
--ALTER TABLE NashvilleHousing
--add OwnerSplitCity NVARCHAR(255);

--Update NashvilleHousing
--set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.') ,2)

----Columna de Owner State
--ALTER TABLE NashvilleHousing
--add OwnerSplitState NVARCHAR(255);

--Update NashvilleHousing
--set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.') ,1)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----Cambiar las 'Y' y las 'N' por 'Yes' y 'No' en la columna de "Sold as vacant" 

---- Consulta para ordenar por grupos y saber cuantos existen
----Select distinct(SoldAsVacant), COUNT(SoldAsVacant)
----from PortfolioProject.dbo.NashvilleHousing
----group by SoldAsVacant
----order by 2
------ Estos fueron los resultados antes del cambio (despues no seran apreciables ya que seran sustituidos)
------Y = 52 , N = 399, Yes = 4623 , No = 51403

--Select SoldAsVacant,
--	Case when SoldAsVacant = 'Y' THEN 'Yes'
--		 when SoldAsVacant = 'N' THEN 'No'
--		 ELSE SoldAsVacant
--		 END
--From PortfolioProject.dbo.NashvilleHousing

--update NashvilleHousing
--	SET SoldAsVacant = Case when SoldAsVacant = 'Y' THEN 'Yes'
--		 when SoldAsVacant = 'N' THEN 'No'
--		 ELSE SoldAsVacant
--		 END

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----Remover duplicados
--WITH RowNumCTE AS(
--Select * , ROW_NUMBER()Over (Partition by PARCELID, 
--										  PropertyAddress,
--										  SalePrice,
--										  SaleDate,
--										  LegalReference
--										  ORDER BY
--											UNIQUEID
--											) row_num
--From PortfolioProject.dbo.NashvilleHousing

--)
--SELECT * 
--FROM RowNumCTE
--WHERE row_num > 1 
--ORDER BY PropertyAddress
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----Remover columnas sin uso


--SELECT *
--FROM PortfolioProject.DBO.NashvilleHousing

--alter table PortfolioProject.DBO.NashvilleHousing
--drop column OwnerAddress, TaxDistrict, PropertyAddress

--alter table PortfolioProject.DBO.NashvilleHousing
--drop column SaleDate
