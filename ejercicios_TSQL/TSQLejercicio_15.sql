/*
15. Cree el/los objetos de base de datos necesarios para que el objeto principal
reciba un producto como parametro y retorne el precio del mismo.
Se debe prever que el precio de los productos compuestos sera la sumatoria de
los componentes del mismo multiplicado por sus respectivas cantidades. No se
conocen los nivles de anidamiento posibles de los productos. Se asegura que
nunca un producto esta compuesto por si mismo a ningun nivel. El objeto
principal debe poder ser utilizado como filtro en el where de una sentencia
select.
*/


alter function ej15(@articulo char(8))
RETURNS decimal(12,2)
as
begin
	Declare @PrecioAcumulado decimal(12,2) = 0

	-- es un producto compuesto
	if EXISTS ( SELECT * FROM Composicion C WHERE C.comp_producto = @articulo )
		BEGIN
			DECLARE @comp_componente char(8),@comp_cantidad decimal(12,2),@precio_comp_componente decimal(12,2)

			declare cursor_subcomponentes cursor
				for select
					C1.comp_componente,
					C1.comp_cantidad,
					P1.prod_precio
					from Composicion C1 
						INNER JOIN Producto P1 ON P1.prod_codigo = C1.comp_componente
					WHERE C1.comp_producto = @articulo
				OPEN cursor_subcomponentes

				FETCH NEXT FROM cursor_subcomponentes INTO @comp_componente,@comp_cantidad,@precio_comp_componente 
						WHILE(@@FETCH_STATUS = 0)
							BEGIN
								if EXISTS ( SELECT * FROM Composicion C WHERE C.comp_producto = @comp_componente )
									BEGIN
										SET @PrecioAcumulado = @PrecioAcumulado + dbo.ej15(@comp_componente)
									END
								else
									begin
										SET @PrecioAcumulado = @PrecioAcumulado + (@comp_cantidad * @precio_comp_componente)
									end
								FETCH NEXT FROM cursor_subcomponentes INTO @comp_componente,@comp_cantidad,@precio_comp_componente 
							END
				CLOSE cursor_subcomponentes
				DEALLOCATE cursor_subcomponentes
			RETURN @PrecioAcumulado
			
		END
	ELSE -- es un producto simple
		BEGIN
			set  @PrecioAcumulado = @PrecioAcumulado + (select ISNULL(P.prod_precio,0) from Producto P WHERE  P.prod_codigo = @articulo)
		END
	return @PrecioAcumulado
end





select P.prod_codigo ,P.prod_precio, dbo.ej15(P.prod_codigo) AS MIFUNCION from Producto P WHERE P.prod_codigo = '00000030'

SELECT * FROM Composicion C 

SELECT (C.comp_producto) , dbo.ej15(C.comp_producto) FROM Composicion C 