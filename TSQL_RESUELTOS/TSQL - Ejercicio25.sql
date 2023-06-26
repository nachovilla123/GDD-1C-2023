/*25. Desarrolle el/los elementos de base de datos necesarios para que no se permita
que la composición de los productos sea recursiva, o sea, que si el producto A
compone al producto B, dicho producto B no pueda ser compuesto por el
producto A, hoy la regla se cumple.*/

CREATE TRIGGER dbo.ejercicio25 ON Composicion FOR INSERT,UPDATE
AS
BEGIN
	DECLARE @producto char(8)
	DECLARE @componente char(8)
	DECLARE cursor_comp CURSOR FOR (
										SELECT comp_producto,comp_componente
										FROM inserted)
	OPEN cursor_comp
	FETCH NEXT FROM cursor_comp
	INTO @producto,@componente
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF EXISTS( SELECT *
				   FROM Composicion
				   WHERE comp_producto = @componente
						AND comp_componente = @producto)
		BEGIN
			RAISERROR('El producto %s ya compone al producto %s, por lo tanto no es posible insertar',1,1,@componente,@producto)
			ROLLBACK TRANSACTION
		END
	FETCH NEXT FROM cursor_comp
	INTO @producto,@componente
	END
	CLOSE cursor_comp
	DEALLOCATE cursor_comp
END
GO
