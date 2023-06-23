/*
3. Cree el/los objetos de base de datos necesarios para corregir la tabla empleado
en caso que sea necesario. Se sabe que debería existir un único gerente general
(debería ser el único empleado sin jefe). Si detecta que hay más de un empleado
sin jefe deberá elegir entre ellos el gerente general, el cual será seleccionado por
mayor salario. Si hay más de uno se seleccionara el de mayor antigüedad en la
empresa. Al finalizar la ejecución del objeto la tabla deberá cumplir con la regla
de un único empleado sin jefe (el gerente general) y deberá retornar la cantidad
de empleados que había sin jefe antes de la ejecución.
*/

-- las funciones no pueden modificar los datos
-- o es un store procedure o un trigger. el trigger es cuando algo se ejecuta, cuando hay un evento
-- para este caso nosotros vamos a querer correr este ejercicio cuando nosotros lo decidamos

-- OUPUT ES PARA QUE DEVUELVA UN VALOR

CREATE PROCEDURE EJ3 @CANTIDAD INT OUTPUT
As
begin

select @CANTIDAD = (select count(*) from Empleado where empl_jefe is null)

update Empleado SET empl_jefe = (select top 1 empl_codigo from Empleado 
where empl_jefe is null order by empl_salario desc, empl_ingreso
)
where empl_jefe is null AND empl_codigo <> (select top 1 empl_codigo from Empleado 
where empl_jefe is null order by empl_salario desc, empl_ingreso
)
end

DECLARE @EMPLEADOS INT
SET @EMPLEADOS = 0

EXEC DBO.EJ3 @EMPLEADOS
PRINT @EMPLEADOS

--yo no puedo ver el resultado correcto porque deberia estar en un store procedure. no se puede mostrar en consola.


/*
Formas de meter datos

select @CANTIDAD = (select count(*) from Empleado where empl_jefe is null)

set @CANTIDAD = (select count(*) from Empleado where empl_jefe is null)

Select @CANTIDAD = count(*) from Empleado where empl_jefe is null
*/