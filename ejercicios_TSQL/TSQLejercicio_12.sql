/*
12. Cree el/los objetos de base de datos necesarios para que nunca un producto
pueda ser compuesto por sí mismo. Se sabe que en la actualidad dicha regla se
cumple y que la base de datos es accedida por n aplicaciones de diferentes tipos
y tecnologías. No se conoce la cantidad de niveles de composición existentes.
*/


CREATE TRIGGER EJ12 ON Composicion AFTER INSERT
AS
BEGIN
	IF EXISTS( SELECT comp_producto FROM inserted WHERE dbo.EJ12_comp_producto_dentro_de_si_mismo(comp_producto) = 1)
		BEGIN
			PRINT 'Un producto no puede componerse a si mismo ni ser parte de un producto que se compone a si mismo'
			ROLLBACK TRANSACTION
			RETURN
		END
END
GO

-- esta funcion me dice si un comp_producto esta dentro de si mismo, 1 si esta, 0 si no
CREATE FUNCTION EJ12_comp_producto_dentro_de_si_mismo(@comp_producto char(8))
RETURNS int
AS
BEGIN
	-- si esta dentro de si mismo en el primer nivel
	IF EXISTS( SELECT * FROM Composicion C1
			   WHERE C1.comp_componente = @comp_producto)
	BEGIN
		RETURN 1
	END
	
	DECLARE @comp_componente_aux char(8)

	DECLARE cursor_composicion CURSOR 
	FOR SELECT
		C.comp_componente
		FROM Composicion C
		WHERE C.comp_componente = @comp_producto

	OPEN cursor_composicion

		FETCH NEXT FROM cursor_composicion INTO @comp_componente_aux

		WHILE(@@FETCH_STATUS = 0)
		BEGIN
			--ACCIONES
			if(dbo.EJ12_comp_producto_dentro_de_si_mismo(@comp_componente_aux) = 1)
			BEGIN
				RETURN 1
			END

			FETCH NEXT FROM cursor_composicion INTO @comp_componente_aux
		END
	CLOSE cursor_composicion
	DEALLOCATE cursor_composicion

	RETURN 0 -- Si llego hasta aca, no esta compuesto por si mismo
END
	
SELECT * FROM Composicion
WHERE comp_producto = '99999999'

INSERT INTO Composicion
VALUES(1, '99999999','99999999')