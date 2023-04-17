/*9. Mostrar el código del jefe, código del empleado que lo tiene como jefe, nombre del
mismo y la cantidad de depósitos que ambos tienen asignados.*/

select J.empl_codigo as codigo_jefe,
	   J.empl_nombre as nombre_jefe,
       J.empl_apellido as apellido_jefe,
	   E.empl_codigo as codigo_empleado,
	   E.empl_nombre as nombre_empleado,
       E.empl_apellido as apellido_empleado,
	   count (D.depo_encargado)as depositos_dirigidos_entre_los_2
 From Empleado J

 Join Empleado E ON E.empl_jefe = J.empl_codigo

 Join DEPOSITO D ON (D.depo_encargado = E.empl_codigo OR D.depo_encargado = E.empl_jefe) 
 group by  J.empl_codigo ,
	   J.empl_nombre ,
       J.empl_apellido ,
	   E.empl_codigo ,
	   E.empl_nombre ,
       E.empl_apellido 