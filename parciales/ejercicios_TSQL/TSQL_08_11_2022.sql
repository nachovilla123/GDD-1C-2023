/*
2. Implementar una regla de negocio de validación en línea que permita
implementar una lógica de control de precios en las ventas. Se deberá
poder seleccionar una lista de rubros y aquellos productos de los rubros
que sean los seleccionados no podrán aumentar por mes más de un 2
%. En caso que no se tenga referencia del mes anterior no validar
dicha regla.
*/

CREATE TABLE item_factura_rechazados(
item_tipo CHAR(1),
item_sucursal CHAR(4),
item_numero CHAR(8),
item_producto CHAR(8),
item_cantidad DECIMAL(12,2),
item_precio DECIMAL(12,2)
)

/*
Implementar una regla de negocio en línea donde 

nunca una factura nueva tenga un precio de producto distinto al que figura en la tabla PRODUCTO. 

Registrar en una estructura adicional todos los casos donde se intenta guardar un precio distinto.
*/
GO
CREATE TRIGGER ejercicioParcialPreciosP2
ON Item_Factura
INSTEAD OF INSERT
AS 
BEGIN

    IF NOT EXISTS
    (    -- Me fijo si el producto insertado tiene el mismo precio en producto, sino retorna nada no lo es
        SELECT FROM Producto P
            INNER JOIN inserted    I ON
                P.prod_codigo = I.item_producto
                where P.prod_precio=I.item_precio
    )
        BEGIN
            INSERT INTO item_factura_rechazados (item_tipo,item_sucursal,item_numero,item_producto,item_cantidad,item_precio)
            SELECT * FROM inserted
        END
    ELSE
        BEGIN
            INSERT INTO Item_Factura(item_tipo,item_sucursal,item_numero,item_producto,item_cantidad,item_precio)
            SELECT * FROM inserted
        END
END