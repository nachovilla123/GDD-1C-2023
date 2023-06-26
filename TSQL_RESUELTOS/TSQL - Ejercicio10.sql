/*10. Crear el/los objetos de base de datos que ante el intento de borrar un artículo
verifique que no exista stock y si es así lo borre en caso contrario que emita un
mensaje de error.*/

ALTER TRIGGER Ejercicio10 ON Producto INSTEAD OF DELETE
AS
BEGIN

IF(
	SELECT SUM(S.stoc_cantidad)
	FROM STOCK S
		INNER JOIN deleted D
			ON D.prod_codigo = S.stoc_producto
	GROUP BY S.stoc_producto
	) > 0
	BEGIN
		ROLLBACK TRANSACTION
		PRINT 'No se puede borrar porque el articulo tiene stock'
	END
ELSE 
	BEGIN
	DELETE FROM STOCK
		WHERE stoc_producto IN (
								SELECT prod_codigo
								FROM deleted)
	DELETE FROM Producto
		WHERE prod_codigo IN (
								SELECT prod_codigo
								FROM deleted)
	END
END

/*
DELETE FROM Producto WHERE prod_codigo = '00003821'

SELECT * FROM Producto where prod_codigo = '00003821'

DELETE FROM Producto WHERE prod_codigo = '00006247'

SELECT * FROM Producto where prod_codigo = '00006247'

select stoc_producto,SUM(stoc_cantidad)
from STOCK
	INNER JOIN Producto
		ON prod_codigo = stoc_producto
GROUP BY stoc_producto
ORDER BY 2

*/