/*
Formas de meter datos

    select @CANTIDAD = (select count(*) from Empleado where empl_jefe is null)

    set @CANTIDAD = (select count(*) from Empleado where empl_jefe is null)

    Select @CANTIDAD = count(*) from Empleado where empl_jefe is null
*/



-- fecha de ahora
    WHERE YEAR(F.fact_fecha) = YEAR(GETDATE()) - 1
