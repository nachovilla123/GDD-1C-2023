/* Mostrar el c�digo, raz�n social de todos los clientes cuyo l�mite de cr�dito sea mayor o
igual a $ 1000 ordenado por c�digo de cliente.

Elegi ordenarlos de manera ascendente pero con DESC = descendente 

*/

/*no dice como ordenarlo :D*/ 
SELECT clie_codigo,clie_razon_social FROM Cliente WHERE clie_limite_credito >= 1000 ORDER BY clie_codigo ASC


/* ejemplo basico de join*/
Select clie_codigo,clie_razon_social,clie_vendedor,e.empl_apellido,e.empl_nombre
 from Cliente c Join Empleado e ON c.clie_vendedor = e.empl_codigo


 select 



select 



/* este anda y ta bien. corregido por profe.*/
SELECT 


/* encontrar el jefe de un empleado :D*/
select e.empl_nombre empleado_nombre,
	   e.empl_apellido empleado_apellido,
	   e.empl_jefe codigo_jefe_asociado,
	   j.empl_apellido apellido_jefe,
	   j.empl_nombre nombre_jefe,
	   j.empl_codigo codigo_jefe,
	   j.empl_jefe jefe_del_jefe
 from Empleado e join Empleado j on e.empl_jefe = j.empl_codigo