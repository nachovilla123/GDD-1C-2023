/*5. Realizar un procedimiento que complete con los datos existentes en el modelo
provisto la tabla de hechos denominada Fact_table tiene las siguiente definici�n:
Create table Fact_table
( anio char(4),
mes char(2),
familia char(3),
rubro char(4),
zona char(3),
cliente char(6),
producto char(8),
cantidad decimal(12,2),
monto decimal(12,2)
)
Alter table Fact_table
Add constraint primary key(anio,mes,familia,rubro,zona,cliente,producto)*/


IF OBJECT_ID('Fact_table','U') IS NOT NULL 
DROP TABLE Fact_table
GO
Create table Fact_table
	(
	anio char(4) NOT NULL, --YEAR(fact_fecha)
	mes char(2) NOT NULL, --RIGHT('0' + convert(varchar(2),MONTH(fact_fecha)),2)
	familia char(3) NOT NULL,--prod_familia
	rubro char(4) NOT NULL,--prod_rubro
	zona char(3) NOT NULL,--depa_zona
	cliente char(6) NOT NULL,--fact_cliente
	producto char(8) NOT NULL,--item_producto
	cantidad decimal(12,2) NOT NULL,--item_cantidad
	monto decimal(12,2)--asumo que es item_precio debido a que es por cada producto, 
				   --asumo tambien que el precio ya esta determinado por total y no por unidad (no debe multiplicarse por cantidad)
)
Alter table Fact_table
Add constraint pk_Fact_table_ID primary key(anio,mes,familia,rubro,zona,cliente,producto)
GO

IF OBJECT_ID('Ejercicio5','P') IS NOT NULL
DROP PROCEDURE Ejercicio5
GO

CREATE PROCEDURE Ejercicio5
AS
BEGIN
	INSERT INTO Fact_table
	SELECT YEAR(fact_fecha)
		,RIGHT('0' + convert(varchar(2),MONTH(fact_fecha)),2)
		,prod_familia
		,prod_rubro
		,depa_zona
		,fact_cliente
		,prod_codigo
		,SUM(item_cantidad)
		,sum(item_precio)
	FROM Factura F
		INNER JOIN Item_Factura IFACT
			ON IFACT.item_tipo =f.fact_tipo AND IFACT.item_sucursal = F.fact_sucursal AND IFACT.item_numero = F.fact_numero
		INNER JOIN Producto P
			ON P.prod_codigo = IFACT.item_producto
		INNER JOIN Empleado E
			ON E.empl_codigo = F.fact_vendedor
		INNER JOIN Departamento D
			ON D.depa_codigo = E.empl_departamento
	GROUP BY YEAR(fact_fecha)
		,RIGHT('0' + convert(varchar(2),MONTH(fact_fecha)),2)
		,prod_familia
		,prod_rubro
		,depa_zona
		,fact_cliente
		,prod_codigo
END
GO




/*
EXEC Ejercicio5

SELECt * 
FROM Fact_table*/