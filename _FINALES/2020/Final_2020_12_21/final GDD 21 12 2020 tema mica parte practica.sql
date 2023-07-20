USE[EntrenadoresFinal21122020]
GO
CREATE TABLE Entrenador(
entr_id CHAR(10),
entr_nombre CHAR(50),
entr_apellido CHAR(100),
entr_especialidad_id INTEGER)
GO
CREATE TABLE Especialidad(
espe_id INTEGER,
espe_detalle CHAR(150))
GO

--Describe
exec sp_columns Entrenador
exec sp_columns Especialidad

IF OBJECT_ID('TR_RELACION_NO_IDENTIFICATIVA') IS NOT NULL
	DROP TRIGGER TR_RELACION_NO_IDENTIFICATIVA
GO
CREATE TRIGGER TR_RELACION_NO_IDENTIFICATIVA
ON Entrenador
INSTEAD OF INSERT, UPDATE
AS BEGIN
	IF EXISTS(SELECT * FROM inserted INTERSECT SELECT * FROM deleted) BEGIN
	--IF UPDATE(entr_especialidad_id) BEGIN
		DECLARE @ID_VIEJO INTEGER =
			(SELECT entr_especialidad_id FROM deleted)
		DECLARE @ID_NUEVO INTEGER =
			(SELECT entr_especialidad_id FROM inserted)
			
		IF EXISTS (SELECT espe_id FROM Especialidad WHERE espe_id = @ID_NUEVO) BEGIN
			UPDATE Entrenador SET entr_especialidad_id = @ID_NUEVO WHERE
				entr_id = (SELECT entr_id FROM inserted)
		END
	END
	ELSE BEGIN
		DECLARE @ENTR_ID CHAR(10)
		DECLARE @ESPE_CHECK INTEGER
		DECLARE C_INSERCIONES CURSOR FOR
			SELECT entr_id, entr_especialidad_id FROM inserted
				
		OPEN C_INSERCIONES
		FETCH NEXT FROM C_INSERCIONES INTO @ENTR_ID, @ESPE_CHECK
		WHILE @@FETCH_STATUS = 0 BEGIN
			IF EXISTS (SELECT espe_id FROM Especialidad WHERE espe_id = @ESPE_CHECK) BEGIN
			INSERT INTO Entrenador
				SELECT * FROM inserted WHERE @ENTR_ID = entr_id
			END
		FETCH NEXT FROM C_INSERCIONES INTO @ENTR_ID, @ESPE_CHECK
		END
		CLOSE C_INSERCIONES
		DEALLOCATE C_INSERCIONES
	END
END
GO

SELECT * FROM Entrenador
SELECT * FROM Especialidad

--Prueba de INSERT
INSERT INTO Entrenador VALUES
('A1', 'Juan', 'Ramirez', 1)
INSERT INTO Especialidad VALUES
(1, 'Futbol')
--Funciona ok. No inserta el entrenador sin antes haber insertado la especialidad

--Prueba de UPDATE
UPDATE Entrenador SET entr_especialidad_id = 2 WHERE entr_id = 'A1'
--Funciona ok. No hace ningun update si no existe la especialidad 2

--Delete
DELETE * FROM Entrenador
DELETE * FROM Especialidad

--Nota: No tira errores en general cuando haces los check. Solo no impacta los cambios
--Para ver que funca siempre hacer los select y vas a ver que no modifica nada
--O sea que el trigger funciona bien

DROP TABLE Entrenador
DROP TABLE Especialidad