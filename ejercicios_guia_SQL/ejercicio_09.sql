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




------------------------- VERSION BORDA ABAJO FORMA DISTINTA: muestra los campos x separado -------------

SELECT 
E.empl_jefe as Jefe,
E.empl_codigo as Codigo_Empleado,
E.empl_nombre as Nombre_Empleado,
 ISNULL((SELECT 
        COUNT(D1.depo_encargado)
        FROM DEPOSITO D1
        where D1.depo_encargado = e.empl_codigo
        group by D1.depo_encargado 
),0) AS Deposito_Empleado,
Deposito_Jefe = (
    SELECT 
        COUNT(D2.depo_encargado)
        FROM DEPOSITO D2
        where D2.depo_encargado = e.empl_jefe
        group by D2.depo_encargado 
)
    FROM Empleado E 
    where E.empl_jefe IS NOT NULL
    order by E.empl_jefe

/*aparte para pensarlo

 /*encuentro un empleado y le encuentro cuantos depositos tiene a cargo
 select J.empl_codigo as codigo_jefe,
	   J.empl_nombre as nombre_jefe,
       J.empl_apellido as apellido_jefe,
	   count(D.depo_encargado)as depositos_a_cargo
 From Empleado J
 Join DEPOSITO D ON D.depo_encargado = J.empl_codigo 

group by J.empl_codigo,
	   J.empl_nombre ,
       J.empl_apellido 

*/ 