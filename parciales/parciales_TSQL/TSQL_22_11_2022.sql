/*

1. Implementar una regla de negocio en línea donde se valide que nunca
un producto compuesto pueda estar compuesto por componentes de
rubros distintos a el.
*/

-- RETORNA 1 si tiene componentes de rubros distintos
create function productoComposicionTieneComponentesDeRubrosDistintos(@producto char(8))
RETURNS int 
AS
BEGIN 
	DECLARE @rubroIdCompProducto char(4),@rubroCompComponente char(4)

	-- obtenemos el rubro de nuestro producto compuesto
	set @rubroIdCompProducto = (select P.prod_rubro 
								from Producto P 
								where P.prod_codigo = @producto)

	-- declaramos cursor para recorrer los componetes 
	DECLARE cursor_composicion CURSOR
	FOR	 SELECT 
			P.prod_rubro
		 FROM Composicion C
			INNER JOIN Producto P 
				ON P.prod_codigo = C.comp_componente

		 WHERE C.comp_producto = @producto

	OPEN cursor_composicion
		FETCH NEXT FROM cursor_composicion INTO @rubroCompComponente
		WHILE(@@FETCH_STATUS = 0)
			BEGIN
				--si el rubro que compone al producto es distinto , entonces termina la funcion
				IF(@rubroIdCompProducto <> @rubroCompComponente)
					BEGIN
						RETURN 1
					END

				FETCH NEXT FROM cursor_composicion INTO @rubroCompComponente
			END
	CLOSE cursor_composicion
	DEALLOCATE cursor_composicion
	
	-- NO TIENE COMPONENTES DE RUBROS DISTINTOS
	RETURN 0

END





-------- TRIGGER
GO 
CREATE TRIGGER triggerParcial2 ON Producto INSTEAD OF UPDATE,INSERT 
AS
BEGIN
	IF(select dbo.productoComposicionTieneComponentesDeRubrosDistintos(I.prod_codigo) from inserted I) = 1
		BEGIN 
			 
			RAISERROR ('PRODUCTO COMPUESTO NO PUEDE TENER COMPONENTES DE DISTINTO RUBRO', 16, 1)
		
			ROLLBACK TRANSACTION
		END
END


