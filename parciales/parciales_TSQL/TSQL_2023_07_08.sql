/*
nota:9 sin comentarios

2. Por un error de programación la tabla item factura le ejecutaron DROP a la primary key y a sus foreign key.
Este evento permitió la inserción de filas duplicadas (exactas e iguales) y también inconsistencias debido a la falta de FK.
Realizar un algoritmo que resuelva este inconveniente depurando los datos de manera coherente y lógica y que deje la estructura de la tabla item factura de manera correcta.
*/
CREATE TABLE Item_Factura_Nueva (
    item_tipo char(1),
    item_sucursal char(4),
    item_numero char(8),
    item_producto char(8),
    item_cantidad decimal(12,2),
	item_precio decimal(12,2)
);

INSERT INTO Item_Factura_Nueva (item_tipo, item_sucursal, item_numero, item_producto, item_cantidad, item_precio)
SELECT DISTINCT item_tipo, item_sucursal, item_numero, item_producto, item_cantidad, item_precio
FROM Item_Factura;

TRUNCATE TABLE Item_Factura;

INSERT INTO Item_Factura (item_tipo, item_sucursal, item_numero, item_producto, item_cantidad, item_precio)
SELECT item_tipo, item_sucursal, item_numero, item_producto, item_cantidad, item_precio
FROM Item_Factura_Nueva;

ALTER TABLE Item_Factura
ADD FOREIGN KEY (item_tipo, item_sucursal, item_numero) REFERENCES Factura (fact_tipo, fact_sucursal, fact_numero);

ALTER TABLE Item_Factura
ADD FOREIGN KEY (item_producto) REFERENCES Producto (prod_codigo);

DROP TABLE Item_Factura_Nueva;