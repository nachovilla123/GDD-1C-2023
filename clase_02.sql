/* Mostrar el código, razón social de todos los clientes cuyo límite de crédito sea mayor o
igual a $ 1000 ordenado por código de cliente.

Elegi ordenarlos de manera ascendente pero con DESC = descendente 

*/

/*no dice como ordenarlo :D*/ 
SELECT clie_codigo,clie_razon_social FROM Cliente WHERE clie_limite_credito >= 1000 ORDER BY clie_codigo ASC


/* ejemplo basico de join*/
Select clie_codigo,clie_razon_social,clie_vendedor,e.empl_apellido,e.empl_nombre
 from Cliente c Join Empleado e ON c.clie_vendedor = e.empl_codigo


 select  prod_codigo , prod_detalle , f.fami_detalle from Producto p JOIN Familia f on p.prod_familia = f.fami_id



select  prod_codigo , prod_detalle , f.fami_detalle , r.rubr_detalle from Producto p JOIN Familia f on p.prod_familia = f.fami_id /* aca me trae un conjunto y con el segundo join lo vincula al otro*/       JOIN Rubro r on p.prod_rubro = r.rubr_id



/* este anda y ta bien. corregido por profe.*/
SELECT  pr.prod_detalle producto, p.prod_detalle nombre_producto,  c.comp_producto nombre_componente,  c.comp_componente componente,  c.comp_cantidad cantidad FROM Composicion c JOIN Producto p       ON p.prod_codigo = c.comp_componente       JOIN Producto pr          ON pr.prod_codigo = c.comp_producto


/* encontrar el jefe de un empleado :D*/
select e.empl_nombre empleado_nombre,
	   e.empl_apellido empleado_apellido,
	   e.empl_jefe codigo_jefe_asociado,
	   j.empl_apellido apellido_jefe,
	   j.empl_nombre nombre_jefe,
	   j.empl_codigo codigo_jefe,
	   j.empl_jefe jefe_del_jefe
 from Empleado e join Empleado j on e.empl_jefe = j.empl_codigo