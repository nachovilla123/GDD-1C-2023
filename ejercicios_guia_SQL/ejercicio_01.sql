
/* Mostrar el código, razón social de todos los clientes cuyo límite de crédito sea mayor o
igual a $ 1000 ordenado por código de cliente.

Elegi ordenarlos de manera ascendente pero con DESC = descendente 

*/
SELECT clie_codigo,clie_razon_social FROM Cliente WHERE clie_limite_credito >= 1000 ORDER BY clie_codigo ASC