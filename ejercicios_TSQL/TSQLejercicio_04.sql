/*
4. Cree el/los objetos de base de datos necesarios para 
actualizar la columna de empleado empl_comision con la sumatoria del total de lo vendido por ese empleado a lo largo del último año. 

Se deberá retornar el código del vendedor que más vendió (en monto) a lo largo del último año.
*/


alter FUNCTION totalVentaUltimoAnioEmpleado(@empleado NUMERIC(6)) 
RETURNS DECIMAL(12,2)
AS
BEGIN
RETURN  isnull((
                select Sum(isnull(F.fact_total,0)) 
                from Factura F 
                where F.fact_vendedor = @empleado and
                      YEAR(fact_fecha) = 2012 
                ),0)
END
-- la base de datos no esta actualizada  y por eso pongo del 2012.
-- para el a actual usar: --WHERE YEAR(F.fact_fecha) = YEAR(GETDATE()) - 1


select E.empl_codigo, dbo.totalVentaUltimoAnioEmpleado(E.empl_codigo) as total from Empleado E



select * from Empleado
select * from Factura

ALTER PROCEDURE actualizar_comision_empleados
AS
BEGIN

    declare @mayor_vendedor numeric(6) = (
    SELECT TOP 1
    F.fact_vendedor
        FROM Factura F
                ORDER BY(dbo.totalVendidoUltimoAnio(F.fact_vendedor)) DESC)

    BEGIN TRANSACTION
        UPDATE Empleado SET empl_comision = dbo.totalVendidoUltimoAnio(empl_codigo)
            WHERE dbo.totalVendidoUltimoAnio(empl_codigo) IS NOT NULL
    COMMIT

    PRINT 'El codigo del empleado con mayor ventas es el número ' + @mayor_vendedor
END


exec actualizar_comision_empleados;
SELECT * FROM Empleado



ALTER FUNCTION totalVendidoUltimoAnio(@empleado NUMERIC(6))
    RETURNS DECIMAL (12,2)
as
    BEGIN
return(SELECT TOP 1
        SUM(F.fact_total)
        FROM Factura F
                WHERE YEAR(F.fact_fecha) >= 2012 AND F.fact_vendedor = @empleado
                ORDER BY(SUM(F.fact_total)) DESC)
END

--  WHERE YEAR(F.fact_fecha) >= 2012 se podria usar..



------------------------OTRA ALTERNATIVA----------------------------
ALTER PROC Ejercicio4 (@EmplQueMasVendio numeric(6,0) OUTPUT)
AS
BEGIN

UPDATE Empleado Set empl_comision = (
										SELECT SUM(F.fact_total)
										FROM Factura F
												WHERE YEAR(fact_fecha) = (
																			SELECT TOP 1 YEAR(fact_fecha)
																			FROM Factura
																			ORDER BY fact_fecha DESC
																			)
													AND F.fact_vendedor = empl_codigo 
									)

-- aca no esta filtrando por comision del ultimo año. si hay uno q no vendio nada el año corriente pero el año pasado era el mejor
-- lo devolvemos a el
set @EmplQueMasVendio = (SELECT TOP 1 empl_codigo
						   FROM Empleado
						   ORDER BY empl_comision DESC)
RETURN
END

--
DECLARE @vendedor_que_mas_vendio numeric(6,0)
EXEC Ejercicio4 @EmplQueMasVendio = @vendedor_que_mas_vendio OUTPUT
SELECT @vendedor_que_mas_vendio AS [Vendedor que mas vendio]

SELECT * FROM Empleado