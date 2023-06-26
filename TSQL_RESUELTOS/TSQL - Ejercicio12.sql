/*12. Cree el/los objetos de base de datos necesarios para que nunca un producto
pueda ser compuesto por s� mismo. Se sabe que en la actualidad dicha regla se
cumple y que la base de datos es accedida por n aplicaciones de diferentes tipos
y tecnolog�as. No se conoce la cantidad de niveles de composici�n existentes.*/

CREATE FUNCTION dbo.Ejercicio12Func(@Componente char(8))
RETURNS BIT

AS
BEGIN
	DECLARE @ProdAux char(8)

	IF EXISTS ( SELECT *
				FROM Composicion
				WHERE comp_producto = @Componente
				)
		BEGIN
			RETURN 1
		END
		
	DECLARE cursor_componente CURSOR
	 	FOR SELECT C.comp_producto
		FROM Composicion C
		WHERE C.comp_componente = @Componente
		
	OPEN cursor_componente
	FETCH NEXT from cursor_componente
	INTO @ProdAux
	WHILE @@FETCH_STATUS = 0
		BEGIN
			IF(dbo.Ejercicio12Func(@Componente)) = 1 -- ACA COMO LLAMO A LA EJECUCION DE LA MISMA FUNCION???
			BEGIN
				Return 1
			END
		FETCH NEXT from cursor_componente
		INTO @ProdAux
		END
	CLOSE cursor_componente
	DEALLOCATE cursor_componente
	RETURN 0
	END
GO

CREATE TRIGGER Ejercicio12 ON COMPOSICION AFTER INSERT
AS
BEGIN
	IF EXISTS (SELECT comp_producto FROM inserted WHERE dbo.Ejercicio12Func(comp_producto) = 1)
		BEGIN
			PRINT 'Un producto no puede componerse a si mismo ni ser parte de un producto que se compone a si mismo'
			ROLLBACK TRANSACTION
			RETURN
		END
END
GO

SELECT * FROM Composicion

INSERT INTO Composicion
VALUES(1, '00001104','00001104')