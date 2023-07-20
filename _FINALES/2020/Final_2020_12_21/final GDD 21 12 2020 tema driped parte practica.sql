USE[EntrenadoresFinal21122020]
GO

--Create tables
CREATE TABLE Entrenador(
entr_id CHAR(10) PRIMARY KEY,
entr_nombre CHAR(50),
entr_apellido CHAR(100),
entrenado_por_id CHAR(10))
GO
CREATE TABLE Especialidad(
espe_id INTEGER PRIMARY KEY,
espe_detalle CHAR(150))
GO
CREATE TABLE Entrenador_Especialidad(
enes_entrenador_id CHAR(10) NOT NULL,
enes_especialidad_id INTEGER NOT NULL,
enes_hs_semanales INTEGER)
GO
ALTER TABLE Entrenador_Especialidad
ADD CONSTRAINT pk_entr_espe PRIMARY KEY (enes_entrenador_id, enes_especialidad_id)
--Por alguna razon no me dejaba crear la tabla con una clave primaria compuesta

--Alter tables FK
ALTER TABLE Entrenador
ADD CONSTRAINT fk_entr_por_id FOREIGN KEY
(entrenado_por_id)
REFERENCES Entrenador (entr_id)
GO
ALTER TABLE Entrenador_Especialidad
ADD CONSTRAINT fk_entr_id FOREIGN KEY
(enes_entrenador_id)
REFERENCES Entrenador (entr_id)
GO
ALTER TABLE Entrenador_Especialidad
ADD CONSTRAINT fk_espe_detalle FOREIGN KEY
(enes_especialidad_id)
REFERENCES Especialidad (espe_id)
GO

--Describe
exec sp_columns Entrenador
exec sp_columns Especialidad
exec sp_columns Entrenador_Especialidad

--Drop
DROP TABLE Entrenador
DROP TABLE Especialidad
DROP TABLE Entrenador_Especialidad

--Select
SELECT * FROM Entrenador
SELECT * FROM Especialidad
SELECT * FROM Entrenador_Especialidad

--Ejercicio
IF OBJECT_ID('FX_CALCULA_ENTRENADOS') IS NOT NULL
	DROP FUNCTION FX_CALCULA_ENTRENADOS
GO
CREATE FUNCTION FX_CALCULA_ENTRENADOS(@X CHAR(10))
	RETURNS INTEGER
AS
BEGIN
	DECLARE @N INTEGER
	
	SET @N = 
	(SELECT ISNULL(SUM(DBO.FX_CALCULA_ENTRENADOS(entr_id) + 1), 0)
	FROM Entrenador
	WHERE entrenado_por_id = @X)
	
	RETURN @N
END
GO

IF OBJECT_ID('FX_CALCULA_HORAS_ENTRENADOS') IS NOT NULL
	DROP FUNCTION FX_CALCULA_HORAS_ENTRENADOS
GO
CREATE FUNCTION FX_CALCULA_HORAS_ENTRENADOS(@X CHAR(10))
	RETURNS INTEGER
AS
BEGIN
	DECLARE @Z INTEGER
	
	SET @Z =
	ISNULL((SELECT SUM(DBO.FX_CALCULA_HORAS_ENTRENADOS(enes_entrenador_id) + enes_hs_semanales)
	FROM Entrenador_Especialidad es
	INNER JOIN Entrenador e ON es.enes_entrenador_id = e.entr_id
	WHERE e.entrenado_por_id = @X), 0)
	
	RETURN @Z
END
GO

IF OBJECT_ID('PR_INFO_ENTRENADOR') IS NOT NULL
	DROP PROCEDURE PR_INFO_ENTRENADOR
GO
CREATE PROCEDURE PR_INFO_ENTRENADOR(@X CHAR(10))
AS
BEGIN
	DECLARE @N INTEGER
	
	DECLARE @HORASDIRECTAS INTEGER = (SELECT enes_hs_semanales FROM Entrenador_Especialidad WHERE enes_entrenador_id = @X)
	DECLARE @Z INTEGER
	
	SET @N = (SELECT DBO.FX_CALCULA_ENTRENADOS(@X))
	SET @Z = (SELECT DBO.FX_CALCULA_HORAS_ENTRENADOS(@X))
	SET @Z = @Z + @HORASDIRECTAS
	
	PRINT 'El entrenador ' + @X + ' tiene un nivel ' + CAST(@N AS VARCHAR(10)) + ' y sus dependientes acumulan ' + CAST(@Z AS VARCHAR(10)) + ' horas semanales'
END
GO

INSERT INTO Entrenador VALUES
('A2', 'Juan', 'Ramirez', 'A2')
INSERT INTO Entrenador VALUES
('A3', 'Pedro', 'Gonzalez', 'A2')
INSERT INTO Entrenador VALUES
('A4', 'Nicolas', 'Perez', 'A3')
INSERT INTO Entrenador VALUES
('A5', 'Gonzalo', 'Lopez', 'A4')
INSERT INTO Entrenador VALUES
('A6', 'Ramiro', 'Vazquez', 'A5')

INSERT INTO Especialidad VALUES
(1, 'Futbol')
INSERT INTO Especialidad VALUES
(2, 'Basquet')
INSERT INTO Especialidad VALUES
(3, 'Natacion')
INSERT INTO Especialidad VALUES
(4, 'Golf')
INSERT INTO Especialidad VALUES
(5, 'Tenis')

INSERT INTO Entrenador_Especialidad VALUES
('A2', 1, 10)
INSERT INTO Entrenador_Especialidad VALUES
('A3', 2, 20)
INSERT INTO Entrenador_Especialidad VALUES
('A4', 3, 15)
INSERT INTO Entrenador_Especialidad VALUES
('A5', 4, 25)
INSERT INTO Entrenador_Especialidad VALUES
('A6', 5, 30)

--Prueba
EXEC PR_INFO_ENTRENADOR 'A5'
--Es correcto porque el entrenador A5 tiene 25 horas propias y 30 de su entrenado subsiguiente

EXEC PR_INFO_ENTRENADOR 'A3'
--Correcto tambien con un nivel de 3 y suma 90 que es lo pedido

