/*8. Realizar un procedimiento que complete la tabla Diferencias de precios, para los
productos facturados que tengan composición y en los cuales el precio de
facturación sea diferente al precio del cálculo de los precios unitarios por
cantidad de sus componentes, se aclara que un producto que compone a otro,
también puede estar compuesto por otros y así sucesivamente, la tabla se debe
crear y está formada por las siguientes columnas:*/

IF OBJECT_ID('Diferencias2','U') IS NOT NULL 
DROP TABLE Diferencias2
GO

CREATE TABLE Diferencias2
(
	dif_codigo char(8) NULL
	,dif_detalle char(50) NULL
	,dif_cantidad int NULL
	,dif_precio_generado decimal(12,2) NULL
	,dif_precio_facturado decimal(12,2) NULL
)

if OBJECT_ID('Ejercicio8v2','P') is not null
DROP PROCEDURE Ejercicio8v2
GO

CREATE PROCEDURE Ejercicio8v2
AS
BEGIN
	INSERT INTO Diferencias2
		SELECT IFACT.item_producto
					,P.prod_detalle
					,(
						SELECT COUNT(comp_producto)
						FROM Composicion
						WHERE comp_producto = IFACT.item_producto
						)
					,(
						SELECT SUM(prod_precio * comp_cantidad)
						FROM Producto
							INNER JOIN Composicion
								ON comp_componente = prod_codigo
						WHERE comp_producto = IFACT.item_producto
					)
					,IFACT.item_precio
				FROM Producto P
					INNER JOIN Item_Factura IFACT
						ON IFACT.item_producto = P.prod_codigo
				WHERE IFACT.item_producto IN (
												SELECT comp_producto
												FROM Composicion )
				GROUP BY --IFACT.item_tipo+IFACT.item_sucursal+IFACT.item_numero,
				IFACT.item_producto,P.prod_detalle,IFACT.item_precio
				HAVING SUM(IFACT.item_producto * IFACT.item_cantidad) <> (
																				SELECT SUM(prod_precio * comp_cantidad)
																				FROM Producto
																					INNER JOIN Composicion
																						ON comp_componente = prod_codigo
																				WHERE comp_producto = IFACT.item_producto
																				)
		END
	GO


	/*EXEC Ejercicio8v2

	select * from diferencias2*/