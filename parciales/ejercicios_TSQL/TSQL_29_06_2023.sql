/*
2. Suponiendo que se aplican los siguientes cambios en el modelo de
datos:

Cambio 1) create table provincia (id 'int primary key, nómbre char(100)) ;
Cambio 2) alter table cliente add pcia_id int null:

Crear el]los objetos necesarios para implementar el concepto de foreign
key entre 2 cliente y provincia,

Nota: No se permite agregar una constraint de tipo FOREIGN KEY entre la
tabla y el campo agregado.

*/


IF EXISTS (SELECT name FROM sys.objects WHERE name = 'ClienteProvinciaAdd' AND type = 'TR') DROP TRIGGER ClienteProvinciaAdd;  
GO  

IF EXISTS (SELECT name FROM sys.objects WHERE name = 'ClienteProvinciaUpdate' AND type = 'TR') DROP TRIGGER ClienteProvinciaUpdate;  
GO  

CREATE TRIGGER ClienteProvinciaUpdate ON Cliente INSTEAD OF UPDATE

AS

BEGIN
	SET NOCOUNT ON;

	IF ( UPDATE (pcia_id) )  
		BEGIN
			IF EXISTS ( SELECT * FROM Provincia A INNER JOIN Inserted B ON A.id = B.pcia_id ) 
				BEGIN
					UPDATE
						Cliente 
					SET
						pcia_id = i.pcia_id
					FROM
						Inserted i 
					WHERE
						Cliente.clie_codigo = i.clie_codigo
				END;
			ELSE
				BEGIN
					RAISERROR ('La Provincia que desea actualizar no Existe', 16, 10); 
				END;
		END
	ELSE
		BEGIN
			UPDATE
				Cliente 
			SET
				clie_codigo = i.clie_codigo , 
				clie_razon_social = i.clie_razon_social , 
				clie_telefono = i.clie_telefono , 
				clie_domicilio = i.clie_domicilio , 
				clie_limite_credito = i.clie_limite_credito , 
				clie_vendedor = i.clie_vendedor
			FROM
				Inserted i 
			WHERE
				Cliente.clie_codigo = i.clie_codigo
		END;
END

GO

CREATE TRIGGER ClienteProvinciaAdd ON Cliente INSTEAD OF INSERT

AS

BEGIN
	SET NOCOUNT ON;

	IF EXISTS ( SELECT * FROM Provincia A INNER JOIN Inserted B ON A.id = B.pcia_id ) 
		BEGIN
			INSERT INTO
				Cliente 
			SELECT
				i.clie_codigo , 
				i.clie_razon_social , 
				i.clie_telefono , 
				i.clie_domicilio , 
				i.clie_limite_credito , 
				i.clie_vendedor ,
				i.pcia_id
			FROM
				Inserted i 
		END
	ELSE
		BEGIN
			RAISERROR ('La Provincia que desea insertar no Existe', 16, 10); 
		END;
END

GO