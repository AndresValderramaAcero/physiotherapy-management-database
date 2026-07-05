--=============================================
--       ////       TABLAS         ////      --
-- ============================================

--==========================================================
--					TABLA PACIENTE
--     Almacena la información principal del paciente.
--==========================================================
Create table Paciente (
	Id_Paciente BIGINT PRIMARY KEY,
	Nombre VARCHAR(50),
	Apellido_Paterno Varchar(50),
	Apellido_Materno Varchar(50),
	Fecha_Nacimiento varchar(10),
	Edad_Gestacional varchar(10),
	Edad_Cronologia varchar(10),
	Edad_Corregida Varchar(10),
	Nombre_Madre Varchar(250),
	Perimetro_Cefalico VARCHAR(50),
	Percentil VARCHAR(6),
	Asimetrias Varchar(250),
	Examinador Varchar(60)
)

--==========================================================
--					TABLA RevisionPaciente
--     Almacena la información del paciente a la hora de 
--        hacer medidas preliminares en la revision.
--==========================================================


Create table RevisionPaciente(
   Fecha_Evaluacion DATE NOT NULL,
   Id_Paciente BIGINT NOT NULL, --FOREIGN KEY
   Nombre VARCHAR(50),
   Apellido_Paterno Varchar(50),
   Apellido_Materno Varchar(50),
   Fecha_Nacimiento DATE,
   Edad_Gestacional varchar(10),
   Edad_Cronologia varchar(10),
   Edad_Corregida Varchar(10),
   Nombre_Madre Varchar(250),
   Perimetro_Cefalico VARCHAR(50),
   Percentil VARCHAR(6),
   Examinador Varchar(60),
   Asimetrias Varchar(250),
   CONSTRAINT PK_Revision_Paciente PRIMARY KEY (Id_Paciente, Fecha_Evaluacion) 
)

--==========================================================
--					TABLAS EVALUATIVAS
--     Almacena la información del paciente(puntuacion) que
--                 obtuvo en cada prueba
--==========================================================

Create table ParesCraneales(
	Id_ParesCranales int Primary key identity(1,1),
	Apariencia_Facial int,
	Apariencia_Ocular int,
	Respuesta_Auditiva int,
	Respuesta_Visual int,
	Succion_Deglucion int,
	Observacion varchar(250),
	Total int
)

Create table Postura(
	Id_Postura int Primary Key identity(1,1),
	Cabeza int, 
	Tronco int,
	Brazos int,
	Manos int,
	Piernas int,
	Pies int,
	Observacion varchar(250),
	Total int
)

Create table Movimiento (
	Id_Movimiento int Primary key identity(1,1),
	Cantidad int,
	Tipo_Caracter int,
	Observacion varchar(250),
	Total int
)

Create table Valoracion_Tono(
	Id_Valoracion int Primary key identity(1,1),
	Signo_Bufanda int,
	Elevacion_Pasiva int,
	Pronacion int,
	Abductores int,
	Angulo_Popliteo int,
	Drosiflexion int,
	Incorporar int,
	Suspension int,
	Observacion varchar(250),
	Total int
)

Create table Reflejos_Reacciones_Posturales(
	Id_Reflejos_Reacciones_Posturales int Primary key  identity(1,1),
	Osteotendinosos int,
	Proteccion_Brazo int,
	Suspension_Vertical int,
	Inclinacion_lateral int,
	Paracaidas int,
	Observacion varchar(250),
	Total int
)

Create table Hitos_Motores(
	Id_Hitos_Motores int Primary key  identity(1,1),
	Control_Cefalico Varchar(250),
	Sedestacion varchar(250),
	Presion_Voluntaria varchar(250),
	Mov_Piernas varchar(250),
	Volteo varchar(250),
	Gateo varchar(250),
	Bipedestacion varchar(250),
	Deambulacion varchar(250),
	Observacion varchar(250),
)

Create table Conducta(
	Id_Conducta int Primary key  identity(1,1),
	Estado_Alerta int,
	Estado_Emocional int,
	Sociabilidad int,
	Observacion varchar(250),
	Total int
) 

--==========================================================
--					    TABLA RESULTADOS
--     Almacena la información de los resultados del paciente
--                  en cada una de las pruebas
--==========================================================

Create table Resultados(
   Id_Resultados int Primary key  identity(1,1),
   Fecha_Evaluacion Varchar(15) NOT NULL, --FOREIGN KEY
   Id_Paciente BIGINT NOT NULL, --FOREIGN KEY
   Id_Pares int, --FOREIGN KEY
   Id_Postura int, --FOREIGN KEY
   Id_Movimientos int, --FOREIGN KEY
   Id_Valoracion int, --FOREIGN KEY
   Id_RRPostulares int, --FOREIGN KEY
   Id_Conducta int, --FOREIGN KEY
   Id_Hitos int, --FOREIGN KEY
   Total_Hammer int,
   Observacion Varchar(250)
)

--=============================================
--       ////       FORANEAS       ////      --
-- ============================================

ALTER TABLE [RevisionPaciente] ADD CONSTRAINT [fk_paciente_revision] FOREIGN KEY (id_Paciente) REFERENCES Paciente (id_Paciente)
GO

ALTER TABLE Resultados ADD CONSTRAINT [fk_paciente_Resultados] FOREIGN KEY (Id_Paciente, Fecha_Evaluacion) REFERENCES RevisionPaciente (id_Paciente, Fecha_Evaluacion);
GO

ALTER TABLE Resultados ADD CONSTRAINT [fk_resultados_Pares] FOREIGN KEY (Id_pares) REFERENCES ParesCraneales (Id_ParesCranales)
GO

ALTER TABLE Resultados ADD CONSTRAINT [fk_resultados_Postura] FOREIGN KEY (Id_Postura) REFERENCES Postura (Id_Postura)
GO

ALTER TABLE Resultados ADD CONSTRAINT [fk_resultados_Movimiento] FOREIGN KEY (Id_Movimientos) REFERENCES Movimiento (Id_Movimiento)
GO

ALTER TABLE Resultados ADD CONSTRAINT [fk_resultados_Valoracion] FOREIGN KEY (Id_Valoracion) REFERENCES Valoracion_Tono (Id_Valoracion)
GO

ALTER TABLE Resultados ADD CONSTRAINT [fk_resultados_RRPostulares] FOREIGN KEY (Id_RRPostulares) REFERENCES Reflejos_Reacciones_Posturales (Id_Reflejos_Reacciones_Posturales)
GO

ALTER TABLE Resultados ADD CONSTRAINT [fk_resultados_Conducta] FOREIGN KEY (Id_Conducta) REFERENCES Conducta (Id_Conducta)
GO

ALTER TABLE Resultados ADD CONSTRAINT [fk_resultados_Hitos] FOREIGN KEY (Id_Hitos) REFERENCES Hitos_Motores (Id_Hitos_Motores)
GO

--=============================================
--       ////   Procedimientos     ////      --
-- ============================================
--=============================================
--              ---PACIENTES---              --
-- ============================================
--=============================================
--                Buscar                     --
-- ============================================
CREATE PROCEDURE BuscarPaciente
    @id_Paciente BIGINT,
    @fecha_evaluacion VARCHAR(15) 
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Verificar si ya existe en Revision_Paciente para la fecha actual
    IF NOT EXISTS (SELECT 1 FROM RevisionPaciente 
                   WHERE id_Paciente = @id_Paciente 
                   AND Fecha_Evaluacion = @fecha_evaluacion)
    BEGIN
        -- Insertar los datos ACTUALES del paciente en Revision_Paciente
        INSERT INTO RevisionPaciente (
           Fecha_Evaluacion,
		   Id_Paciente,
		   Nombre,
		   Apellido_Paterno,
		   Apellido_Materno,
		   Fecha_Nacimiento,
		   Edad_Gestacional,
		   Edad_Cronologia,
		   Edad_Corregida,
		   Nombre_Madre,
		   Perimetro_Cefalico,
		   Percentil,
		   Asimetrias,
	       Examinador
        )
        SELECT 
		  @fecha_evaluacion,
          Id_Paciente,
		  Nombre,
		  Apellido_Paterno,
		  Apellido_Materno,
		  Fecha_Nacimiento,
		  Edad_Gestacional,
		  Edad_Cronologia,
		  Edad_Corregida,
		  Nombre_Madre, 
		  Perimetro_Cefalico,
		  Percentil,
		  Asimetrias,
	      Examinador
        FROM Paciente
        WHERE id_Paciente = @id_Paciente
    END
    
    -- SIEMPRE retornar los datos ACTUALES de la tabla Pacientes
    SELECT 
   Id_Paciente,
	Nombre,
	Apellido_Paterno,
	Apellido_Materno,
	Fecha_Nacimiento,
	Edad_Gestacional,
	Edad_Cronologia,
	Edad_Corregida,
	Nombre_Madre,
	Perimetro_Cefalico,
    Percentil,
	Asimetrias,
	Examinador
    FROM Paciente 
    WHERE id_Paciente = @id_Paciente
END

--=============================================
--                Inserta                   --
-- ============================================
ALTER PROCEDURE InsertarPaciente
	@Id_Paciente BIGINT,
	@Nombre VARCHAR(50),
	@Apellido_Paterno VARCHAR(50),
	@Apellido_Materno VARCHAR(50),
	@Fecha_Nacimiento VARCHAR(10),
	@Edad_Gestacional VARCHAR(10),
	@Edad_Cronologia VARCHAR(10),
	@Edad_Corregida VARCHAR(10),
	@Nombre_Madre VARCHAR(250),
	@Perimetro_Cefalico VARCHAR(50),
    @Percentil VARCHAR(6),
	@Examinador VARCHAR(60),
	@Asimetrias VARCHAR(250)
AS
BEGIN
    SET NOCOUNT OFF;  -- Cambiar a OFF para que devuelva el número de filas afectadas
    
    BEGIN TRY
        -- Verificar si ya existe el paciente
        IF EXISTS (SELECT 1 FROM Paciente WHERE id_Paciente = @Id_Paciente)
        BEGIN
            RAISERROR('Ya existe un paciente con esta identificación', 16, 1);
            RETURN;
        END
        
        -- Insertar el nuevo paciente
        INSERT INTO Paciente (
		   Id_Paciente,
		   Nombre,
		   Apellido_Paterno,
		   Apellido_Materno,
		   Fecha_Nacimiento,
		   Edad_Gestacional,
		   Edad_Cronologia,
		   Edad_Corregida,
		   Nombre_Madre,
		   Perimetro_Cefalico,
		   Percentil,
		   Asimetrias,
	       Examinador 
        ) 
        VALUES (
            @Id_Paciente,
			@Nombre,
			@Apellido_Paterno,
			@Apellido_Materno,
			@Fecha_Nacimiento,
			@Edad_Gestacional,
			@Edad_Cronologia,
			@Edad_Corregida,
			@Nombre_Madre,
			@Perimetro_Cefalico,
		    @Percentil,
			@Asimetrias,
			@Examinador
        );
        
        -- Opcional: Devolver el ID insertado
        SELECT @Id_Paciente as ID_Insertado, @@ROWCOUNT as FilasAfectadas;
        
    END TRY
    BEGIN CATCH
        -- Manejar errores
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE(); 
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END

--=============================================
--           ACTUALIZAR - EDITAR             --
-- ============================================
ALTER PROCEDURE ActualizarPaciente
    @id_Paciente BIGINT,
    @Nombre VARCHAR(50),
    @Apellido_Paterno VARCHAR(50),
    @Apellido_Materno VARCHAR(50),
    @Fecha_Nacimiento VARCHAR(10),
    @Edad_Gestacional VARCHAR(10),
    @Edad_Cronologia VARCHAR(10),
    @Edad_Corregida VARCHAR(10),
    @Nombre_Madre VARCHAR(250),
    @Perimetro_Cefalico VARCHAR(50),
    @Percentil VARCHAR(6),
    @Asimetrias VARCHAR(250),
    @Examinador VARCHAR(60)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @RowsAffected INT = 0
     
   -- Verificar si el paciente existe
    IF EXISTS (SELECT 1 FROM Paciente WHERE id_Paciente = @id_Paciente)
    BEGIN      
        UPDATE Paciente
        SET 
            Nombre = @Nombre,
            Apellido_Paterno = @Apellido_Paterno,
            Apellido_Materno = @Apellido_Materno,
            Fecha_Nacimiento = @Fecha_Nacimiento,
            Edad_Gestacional = @Edad_Gestacional,
            Edad_Cronologia = @Edad_Cronologia,
            Edad_Corregida = @Edad_Corregida,
            Nombre_Madre = @Nombre_Madre,
            Perimetro_Cefalico = @Perimetro_Cefalico,
            Percentil = @Percentil,
            Asimetrias = @Asimetrias,
            Examinador = @Examinador
        WHERE id_Paciente = @id_Paciente
        
       SET @RowsAffected = @@ROWCOUNT
    END
    
    -- Retornar el número de filas afectadas para verificación
    SELECT @RowsAffected as FilasAfectadas
END

--=============================================
--              ---PRUEBAS---                --
-- ============================================
--=============================================
--           Empezar Prueba                  --
-- ============================================
alter PROCEDURE Empezar_Prueba
    @Fecha_Evaluacion VARCHAR(15),
    @ID BIGINT,
    @Nombre VARCHAR(100), 
    @Apellido_Paterno Varchar(50),
    @Apellido_Materno Varchar(50),
    @Fecha_Nacimiento varchar(10),
    @Edad_Gestacional VARCHAR(10),
    @Edad_Cronologia varchar(10),
    @Edad_Corregida Varchar(10),
    @Nombre_Madre Varchar(250),
    @Perimetro_Cefalico VARCHAR(50),
    @Percentil VARCHAR(6),
    @Examinador Varchar(60),
    @Asimetrias Varchar(250)
AS
BEGIN
    -- Verificar si ya existe una revisión para este paciente en esta fecha
    IF EXISTS (SELECT 1 FROM RevisionPaciente 
               WHERE id_Paciente = @ID AND Fecha_Evaluacion = @Fecha_Evaluacion)
    BEGIN
        -- ACTUALIZAR registro existente
        UPDATE RevisionPaciente
        SET 
            Nombre = @Nombre,
			Apellido_Paterno =@Apellido_Paterno,
			Apellido_Materno = @Apellido_Materno,
			Fecha_Nacimiento = @Fecha_Nacimiento,
			Edad_Gestacional = @Edad_Gestacional,
			Edad_Cronologia = @Edad_Cronologia,
			Edad_Corregida = @Edad_Corregida,
			Nombre_Madre = @Nombre_Madre,
			Perimetro_Cefalico= @Perimetro_Cefalico,
			Percentil = @Percentil ,
	        Examinador = @Examinador
        WHERE id_Paciente = @ID AND Fecha_Evaluacion = @Fecha_Evaluacion
    END
    ELSE
    BEGIN
        -- INSERTAR nuevo registro
        INSERT INTO RevisionPaciente(
            Fecha_Evaluacion,
			Id_Paciente,
			Nombre, 
			Apellido_Paterno,
			Apellido_Materno,
			Fecha_Nacimiento,
			Edad_Gestacional,
			Edad_Cronologia,
			Edad_Corregida,
			Nombre_Madre,
			Perimetro_Cefalico,
			Percentil,
			Examinador,
			Asimetrias
        ) 
        VALUES (
            @Fecha_Evaluacion,
			@ID,
			@Nombre, 
			@Apellido_Paterno,
			@Apellido_Materno,
			@Fecha_Nacimiento,
			@Edad_Gestacional,
			@Edad_Cronologia,
			@Edad_Corregida,
			@Nombre_Madre,
			@Perimetro_Cefalico,
			@Percentil,
			@Examinador,
			@Asimetrias
        )
    END
END
--=============================================
--           ///PARES CRANEALES//            --
-- ============================================
CREATE PROCEDURE ParesCraneales_Save
	@Apariencia_Facial INT,
	@Apariencia_Ocular  INT,
	@Respuesta_Auditiva  INT,
	@Respuesta_Visual  INT,
	@Succion_Deglucion  INT,
	@Observacion VARCHAR(250),
	@Total  INT
AS
BEGIN
INSERT INTO ParesCraneales (Apariencia_Facial,Apariencia_Ocular,Respuesta_Auditiva,Respuesta_Visual,Succion_Deglucion,Observacion,Total) Values (@Apariencia_Facial,@Apariencia_Ocular,@Respuesta_Auditiva,@Respuesta_Visual,@Succion_Deglucion,@Observacion,@Total)
END

--=============================================
--               ///POSTURA//                --
-- ============================================
CREATE PROCEDURE Postura_Save
	@Cabeza INT, 
	@Tronco INT,
	@Brazos INT,
	@Manos INT,
	@Piernas INT,
	@Pies INT,
	@Observacion VARCHAR(250),
	@Total INT
AS
BEGIN
INSERT INTO Postura(Cabeza,Tronco,Brazos,Manos,Piernas,Pies,Observacion,Total) Values (@Cabeza,@Tronco,@Brazos,@Manos,@Piernas,@Pies,@Observacion,@Total)
END

--=============================================
--             ///MOVIMIENTOS//             --
-- ============================================
CREATE PROCEDURE Movimientos_Save
	@Cantidad INT,
	@Tipo_caracter INT,
	@Observacion VARCHAR(250),
	@Total INT
AS
BEGIN
INSERT INTO Movimiento(Cantidad,Tipo_Caracter,Observacion,Total) Values (@Cantidad,@Tipo_caracter,@Observacion,@Total)
END

--=============================================
--           ///Valoracion_Tono//            --
-- ============================================
CREATE PROCEDURE Valoracion_Save
	@Signo_Bufanda INT,
	@Elevacion_Pasiva INT,
	@Pronacion INT,
	@Abductores INT,
	@Angulo_Popliteo INT,
	@Drosiflexion INT,
	@Incorporar INT,
	@Suspension INT,
	@Observacion VARCHAR(250),
	@Total INT
AS
BEGIN
INSERT INTO Valoracion_Tono(Signo_Bufanda,Elevacion_Pasiva,Pronacion,Abductores,Angulo_Popliteo,Drosiflexion,Incorporar,Suspension,Observacion,Total) Values (@Signo_Bufanda,@Elevacion_Pasiva,@Pronacion,@Abductores,@Angulo_Popliteo,@Drosiflexion,@Incorporar,@Suspension,@Observacion,@Total)
END

--=============================================
--    ///Reflejos_Reacciones_Posturales///   --
-- ============================================
CREATE PROCEDURE Reflejos_Reacciones_Posturales_Save
	@Osteotendinosos INT,
	@Proteccion_Brazo INT,
	@Suspension_Vertical INT,
	@Inclinacion_lateral INT,
	@Paracaidas INT,
	@Observacion VARCHAR(250),
	@Total INT
AS
BEGIN
INSERT INTO Reflejos_Reacciones_Posturales(Osteotendinosos,Proteccion_Brazo,Suspension_Vertical,Inclinacion_lateral,Paracaidas,Observacion,Total) Values (@Osteotendinosos,@Proteccion_Brazo,@Suspension_Vertical,@Inclinacion_lateral,@Paracaidas,@Observacion,@Total)
END

Delete from Valoracion_Tono
--=============================================
--               ///Conducta///              --
-- ============================================
CREATE PROCEDURE Conducta_Save
	@Estado_Alerta INT,
	@Estado_Emocional INT,
	@Sociabilidad INT,
	@Observacion VARCHAR(250),
	@Total INT
AS
BEGIN
INSERT INTO Conducta(Estado_Alerta,Estado_Emocional,Sociabilidad,Observacion,Total) Values (@Estado_Alerta,@Estado_Emocional,@Sociabilidad ,@Observacion,@Total)
END

--=============================================
--          ///Hitos_Motores///              --
-- ============================================
CREATE PROCEDURE Hitos_Motores_Save
	@Control_Cefalico Varchar(250),
	@Sedestacion Varchar(250),
	@Presion_Voluntaria Varchar(250),
	@Mov_Piernas Varchar(250),
	@Volteo Varchar(250),
	@Gateo Varchar(250),
	@Bipedestacion Varchar(250),
	@Deambulacion Varchar(250),
	@Observacion VARCHAR(250)
AS
BEGIN
INSERT INTO  Hitos_Motores(Control_Cefalico,Sedestacion,Presion_Voluntaria,Mov_Piernas,Volteo,Gateo,Bipedestacion,Deambulacion,Observacion) Values (@Control_Cefalico,@Sedestacion,@Presion_Voluntaria,@Mov_Piernas,@Volteo,@Gateo,@Bipedestacion,@Deambulacion,@Observacion)
END
 
--=============================================
--         ///Guardar Hammersmith///         --
-- ============================================
ALTER PROCEDURE ResultadosHammersmith
    @PuntajeGlobal INT,
    @ObservacionGlobal VARCHAR(250),
    @id_paciente BIGINT,
    @Fecha_Evaluacion VARCHAR(15)
AS
BEGIN

    SET NOCOUNT ON;
	 -- Verificar que no exista ya un registro Global_ para este paciente en esta fecha
    IF EXISTS (SELECT 1 FROM Resultados 
               WHERE Id_Paciente = @id_paciente 
               AND Fecha_Evaluacion  = @Fecha_Evaluacion)
    BEGIN
        RAISERROR('Ya existe un registro de evaluación EFIN para este paciente en esta fecha.', 16, 1)
        RETURN
    END

    -- Declaración y obtención de los IDs de las tablas relacionadas
    DECLARE @id_Pares INT = (SELECT MAX(Id_ParesCranales) FROM ParesCraneales);
    DECLARE @id_Postura INT = (SELECT MAX(Id_Postura) FROM Postura);
    DECLARE @id_Movimientos INT = (SELECT MAX(Id_Movimiento) FROM Movimiento);
    DECLARE @id_ValTono INT = (SELECT MAX(Id_Valoracion) FROM Valoracion_Tono);
    DECLARE @id_RRPosturales INT = (SELECT MAX(Id_Reflejos_Reacciones_Posturales) FROM Reflejos_Reacciones_Posturales);
    DECLARE @id_Conducta INT = (SELECT MAX(Id_Conducta) FROM Conducta);
    DECLARE @id_Hitos INT = (SELECT MAX(Id_Hitos_Motores) FROM Hitos_Motores);


       INSERT INTO Resultados(Fecha_Evaluacion, Id_Paciente, Id_Pares, Id_Postura, Id_Movimientos, Id_Valoracion, Id_RRPostulares, Id_Conducta, Id_Hitos, Total_Hammer, Observacion)
        VALUES (@Fecha_Evaluacion, @id_paciente, @id_Pares, @id_Postura, @id_Movimientos, @id_ValTono, @id_RRPosturales, @id_Conducta, @id_Hitos, @PuntajeGlobal, @ObservacionGlobal);

END

--=============================================
--       ///Historial_Hammersmith///         --
-- ============================================
Alter Procedure Evaluacion_Hammersmith
	@id_paciente BIGINT,
	@Fecha_atencion VARCHAR(15)
AS
	BEGIN
	SET NOCOUNT ON;
		SELECT

		--	DATOS DEL PACIENTE
			Rp.Id_Paciente,
			Rp.Nombre,
			Rp.Apellido_Paterno,
			Rp.Apellido_Materno,
			Rp.Fecha_Nacimiento,
			Rp.Edad_Corregida,
			Rp.Edad_Cronologia,
			Rp.Edad_Gestacional,
			Rp.Asimetrias,
			Rp.Percentil,
			Rp.Perimetro_Cefalico,
			Rp.Nombre_Madre,
			Rp.Examinador,

		-- RESULTADOS DE LA PRUEBA HAMMERSMITH
			Re.Total_Hammer,
			Re.Observacion AS RE_Observacion,
			Re.Fecha_Evaluacion,

		--RESULTADO DE CADA PRUEBA
			Pc.Total AS PC_Total,
			Po.Total AS PO_Total,
			Mo.Total AS MO_Total,
			Vt.Total AS VT_Total,
			RRPos.Total AS RRPOS_Total,

		-- RESUMEN DE LOS APARTADOS
		--PARES CRANEALES
			Case
				WHEN Pc.Apariencia_Facial = 3 THEN 'Sonrie y/o reacciona a los estimulos cerrando los ojos y haciendo muecas'
				WHEN Pc.Apariencia_Facial = 2 THEN 'No es optima, pero tampoco suficientemente mala como para puntuar 1'
				WHEN Pc.Apariencia_Facial = 1 THEN 'Cierra los ojos, pero no completamente. Pobre expresividad facial'
				WHEN Pc.Apariencia_Facial = 0 THEN 'Facies inexpresivas. No reacciona a los estimulos'
			END AS PC_Apariencia_Facial,

			CASE
				WHEN Pc.Apariencia_Ocular = 3 THEN 'Movimientos oculares conjugados normales'
				WHEN Pc.Apariencia_Ocular = 2 THEN 'No es optima, pero tampoco suficientemente mala como para puntuar 1'
				WHEN Pc.Apariencia_Ocular = 1 THEN 'Desviacion intermitente de los ojos o movimientos anormales intermitentes'
				WHEN Pc.Apariencia_Ocular = 0 THEN 'Desviacion permanente de los ojos o mivimientos anormales continuos'
			END AS PC_Apariencia_Ocular,

			CASE
				WHEN Pc.Respuesta_Auditiva = 3 THEN 'Respuesta normal en ambos lados'
				WHEN Pc.Respuesta_Auditiva = 2 THEN 'No es optima, pero tampoco suficientemente mala como para puntuar 1'
				WHEN Pc.Respuesta_Auditiva = 1 THEN 'Respuesta dudosa o asimetrica'
				WHEN Pc.Respuesta_Auditiva = 0 THEN 'No reacciona al estimulo'
			END AS PC_Respuesta_Auditiva,

			CASE
				WHEN Pc.Respuesta_Visual = 3 THEN 'Sigue el objeto en un aro completo'
				WHEN Pc.Respuesta_Visual = 2 THEN 'No es optima, pero tampoco suficientemente mala como para puntuar 1'
				WHEN Pc.Respuesta_Visual = 1 THEN 'Sigue el objeto en un arco incompleto, o de forma asimetrica'
				WHEN Pc.Respuesta_Visual = 0 THEN 'No sigue el objeto'
			END AS PC_Respuesta_Visual,

			CASE
				WHEN Pc.Succion_Deglucion = 3 THEN 'Buena succion y deglucion'
				WHEN Pc.Succion_Deglucion = 2 THEN 'No es optima, pero tampoco suficientemente mala como para puntuar 1'
				WHEN Pc.Succion_Deglucion = 1 THEN 'Pobre succion y deglucion'
				WHEN Pc.Succion_Deglucion = 0 THEN 'No reflejo de succion, imposibilidad para tragar'
			END AS PC_Sccion_Deglucion,

			Pc.Observacion AS PC_Observacion_Pares_Craneales,

		--POSTURA
			CASE
				WHEN Po.Cabeza = 3 THEN 'Recta, en la linea media'
				WHEN Po.Cabeza = 2 THEN 'No es optima, pero tampoco suficientemente mala como para puntuar 1'
				WHEN Po.Cabeza = 1 THEN 'Ligeramente inclinada hacia un lado o hacia delante / atras'
				WHEN Po.Cabeza = 0 THEN 'Marcadamente inclinada hacia un lado o hacia delante / atras'
			END AS PO_Cabeza,

			CASE
				WHEN Po.Tronco = 3 THEN 'Recto'
				WHEN Po.Tronco = 2 THEN 'No es optima, pero tampoco suficientemente mala como para puntuar 1'
				WHEN Po.Tronco = 1 THEN 'Ligeramente encorvado o inclinado hacia un lado'
				WHEN Po.Tronco = 0 THEN 'Muy curvado / Hiperextendido hacia atras / Se dobla hacia un lado'
			END AS PO_Tronco,

			CASE
				WHEN Po.Brazos = 3 THEN 'En posicion neutra, rectos o ligeramente flexionados'
				WHEN Po.Brazos = 2 THEN 'No es optima, pero tampoco suficientemente mala como para puntuar 1'
				WHEN Po.Brazos = 1 THEN 'Rotacion interna o externa leve-moderada y/o postura distonica intermitente'
				WHEN Po.Brazos = 0 THEN 'Rotacion interna o externa marcada y/o Postura distonica o hemiplejica mantenida'
			END AS PO_Brazos,

			CASE
				WHEN Po.Manos = 3 THEN 'Manos abiertas'
				WHEN Po.Manos = 2 THEN 'No es optima, pero tampoco suficientemente mala como para puntuar 1'
				WHEN Po.Manos = 1 THEN 'Pulgar en aduccion y/o manos cerradas de forma intermitente'
				WHEN Po.Manos = 0 THEN 'Pulgar en aduccion y/o manos cerradas de forma continua'
			END AS PO_Manos,

			CASE 
				WHEN Po.Piernas = 3 THEN 'Puede estar sentado manteniendo la esplada recta y las piernas extendidas o ligeramente flexionadas'
				WHEN Po.Piernas = 2 THEN 'No es optima, pero tampoco suficientemente mala como para puntuar 1'
				WHEN Po.Piernas = 1 THEN 'Puede estar sentado con la espalda recta, pero las rodillas estan flexionadas 15-20°. Rotacion marcada, interna o externa'
				WHEN Po.Piernas = 0 THEN 'Pulgar en aduccion y/o manos cerradas de forma continua'
			END AS PO_Piernas,

			CASE 
				WHEN Po.Pies = 3 THEN 'Rectos, en posicion neutra. Dedos rectos en posicion intermedia entre flexion y extension'
				WHEN Po.Pies = 2 THEN 'No es optima, pero tampoco suficientemente mala como para puntuar 1'
				WHEN Po.Pies = 1 THEN 'Rotacion leve interna o externa. Tendencia a ponerse de puntillas; o dedos hiperextendidos o encogidos de forma intermitente'
				WHEN Po.Pies = 0 THEN 'Rotacion marcada interna o externa desde el tobillo. Tendencia a estar de puntillas; o dedos hiperextendidos o encogidos(en garra) de forma continua'
			END AS PO_Pies,

			Po.Observacion AS PO_Observacion,

		--MOVIMIENTOS
			CASE 
				WHEN Mo.Cantidad = 3 THEN 'Normales'
				WHEN Mo.Cantidad = 2 THEN 'No es optima, pero tampoco suficientemente mala como para puntuar 1'
				WHEN Mo.Cantidad = 1 THEN 'Excesivos o lentos-perezosos'
				WHEN Mo.Cantidad = 0 THEN 'Muy escasos o ausentes'
			END AS MO_Cantidad,

			CASE 
				WHEN Mo.Tipo_Caracter = 3 THEN 'Fluidos, sueltos y/o alternantes'
				WHEN Mo.Tipo_Caracter = 2 THEN 'No es optima, pero tampoco suficientemente mala como para puntuar 1'
				WHEN Mo.Tipo_Caracter = 1 THEN 'Bruscos, entrecortados y/o temblor leve'
				WHEN Mo.Tipo_Caracter = 0 THEN 'Bruscos rigidos y sincronicos, Espasmos en extension, Atetoides, Ataxicos, Temblores intensos, Espasmos mioclonicos y/o Distonicos'
			END AS MO_Tipo_Caracter,

			Mo.Observacion as MO_Observacion,

		--VALORACION DEL TONO
			CASE 
				WHEN Vt.Signo_Bufanda = 3 THEN 'Posicion Optima del codo respecto a la linea media del cuerpo'
				WHEN Vt.Signo_Bufanda = 2 THEN 'No es optima, pero tampoco suficientemente mala como para puntuar 1'
				WHEN Vt.Signo_Bufanda = 1 THEN 'Posicion estable del codo aunque un poco deficiente'
				WHEN Vt.Signo_Bufanda = 0 THEN 'Posicion pesima del codo con respecto a la linea media del cuerpo'
			END AS VT_Signo_Bufanda,

			CASE 
				WHEN Vt.Elevacion_Pasiva = 3 THEN 'Existe resistencia, pero se puede vencer'
				WHEN Vt.Elevacion_Pasiva = 2 THEN 'La resistencia es dificil de vencer'
				WHEN Vt.Elevacion_Pasiva = 1 THEN 'No hay ninguna resistencia'
				WHEN Vt.Elevacion_Pasiva = 0 THEN 'PLa resistencia es excesiva, no se puede vencer'
			END AS VT_Elevacion_Pasiva,

			CASE 
				WHEN Vt.Pronacion = 3 THEN 'Pronacion y supinacion completas, no hay resistencia'
				WHEN Vt.Pronacion = 2 THEN 'No es optima, pero tampoco suficientemente mala como para puntuar 1'
				WHEN Vt.Pronacion = 1 THEN 'Pronacion y supinacion completas. Existe resistencia, pero se puede vencer'
				WHEN Vt.Pronacion = 0 THEN 'No se puede realizar la pronacion / supinacion de manera completa porque hay excesiva resistencia'
			END AS VT_Pronacion_Supinacion,

			CASE 
				WHEN Vt.Abductores = 3 THEN 'El angulo que se forma entre las piernas es de 150°-80°'
				WHEN Vt.Abductores = 2 THEN 'El angulo que se forma entre las piernas es entre 150°-160°'
				WHEN Vt.Abductores = 1 THEN 'El angulo que se forma entre las piernas es mayor de 170°'
				WHEN Vt.Abductores = 0 THEN 'El angulo que se forma entre las piernas es menor de 80°'
			END AS VT_Abductores,

			CASE 
				WHEN Vt.Angulo_Popliteo = 3 THEN 'El angulo que se forma entre el muslo y la pierna es de 150°-100°'
				WHEN Vt.Angulo_Popliteo = 2 THEN 'El angulo que se forma entre el muslo y la pierna es de 150°-160°'
				WHEN Vt.Angulo_Popliteo = 1 THEN 'El angulo que se forma entre el muslo y la pierna es de 90° o mayor que 170°'
				WHEN Vt.Angulo_Popliteo = 0 THEN 'El angulo que se forma entre el muslo y la pierna es menor de 80°'
			END AS VT_Angulo_Popliteo,

			CASE 
				WHEN Vt.Drosiflexion = 3 THEN 'El angulo que se forma entre la pierna y el pie es de 30°-85°'
				WHEN Vt.Drosiflexion = 2 THEN 'El angulo que se forma entre la pierna y el pie es de 20°-30°'
				WHEN Vt.Drosiflexion = 1 THEN 'El angulo que se forma entre la pierna y el pie es menor de 20° o 90°'
				WHEN Vt.Drosiflexion = 0 THEN 'El angulo que se forma entre la pierna y el pie es mayor de 90°'
			END AS VT_Dorsiflexion_Tobillo,

			CASE 
				WHEN Vt.Incorporar = 3 THEN 'Pone la cabeza de manera recta y erguida'
				WHEN Vt.Incorporar = 2 THEN 'No es optima, pero tampoco suficientemente mala como para puntuar 1°'
				WHEN Vt.Incorporar = 1 THEN 'Se presenta un pequedbolez en el cuello cuando se sujeta por las muñecas'
				WHEN Vt.Incorporar = 0 THEN 'No hay resistencia del cuello. Por ende se dobla la cabeza hacia atras'
			END AS VT_Incorporar,

			CASE 
				WHEN Vt.Suspension = 3 THEN 'Espalda recta'
				WHEN Vt.Suspension = 2 THEN 'No es optima, pero tampoco suficientemente mala como para puntuar 1'
				WHEN Vt.Suspension = 1 THEN 'Espalda levemente inclinada'
				WHEN Vt.Suspension = 0 THEN 'Espalda todalmente doblada (Forma de U)'
			END AS VT_Suspension,

			Vt.Observacion AS VT_Observacion,
			
		--REFLEJOS Y REACCIONES POSTURALES
			CASE 
				WHEN RRPos.Osteotendinosos = 3 THEN 'Se obtienen facilmente: Bicipital, rotuliano y aquileo'
				WHEN RRPos.Osteotendinosos = 2 THEN 'No es optima, pero tampoco suficientemente mala como para puntuar 1'
				WHEN RRPos.Osteotendinosos = 1 THEN 'Se obtienen ligeramente: Bicipital, rotuliano y aquileo'
				WHEN RRPos.Osteotendinosos = 0 THEN 'Ausentismo de: Bicipital, rotuliano y aquileo'
			END AS RRPOS_Osteotendinosos,

			CASE 
				WHEN RRPos.Proteccion_Brazo = 3 THEN 'Brazo y mano extendidos'
				WHEN RRPos.Proteccion_Brazo = 2 THEN 'No es optima, pero tampoco suficientemente mala como para puntuar 1'
				WHEN RRPos.Proteccion_Brazo = 1 THEN 'Brazo semi-flexionado'
				WHEN RRPos.Proteccion_Brazo = 0 THEN 'Brazo completamente flexionado			'
			END AS RRPOS_Proteccion_Brazo,

			CASE 
				WHEN RRPos.Suspension_Vertical = 3 THEN 'Mueve las piernas (Patalea con ambas piernas por igual)'
				WHEN RRPos.Suspension_Vertical = 2 THEN 'No es optima, pero tampoco suficientemente mala como para puntuar 1'
				WHEN RRPos.Suspension_Vertical = 1 THEN 'Mueve las piernas poco o mueve mas una de ellas'
				WHEN RRPos.Suspension_Vertical = 0 THEN 'No mueve las piernas aunque se le estimule; o piernas cruzadas (En tijera)'
			END AS RRPOS_Suspension_Vertical,

			CASE 
				WHEN RRPos.Inclinacion_lateral = 3 THEN 'Se restablece de la inclinacion sin falencias ni en el tronco, miembros y/o cabeza'
				WHEN RRPos.Inclinacion_lateral = 2 THEN 'No es optima, pero tampoco suficientemente mala como para puntuar 1'
				WHEN RRPos.Inclinacion_lateral = 1 THEN 'Presenta las extremidades rigidas al momento de inclinarlo hacia un lado'
				WHEN RRPos.Inclinacion_lateral = 0 THEN 'Cuerpo doblado completamente haceidno un arco con la espalda'
			END AS RRPOS_Inclinacion_Lateral,
			 
			CASE 
				WHEN RRPos.Paracaidas = 3 THEN 'Brazos totalmente Extendidos'
				WHEN RRPos.Paracaidas = 2 THEN 'No es optima, pero tampoco suficientemente mala como para puntuar 1'
				WHEN RRPos.Paracaidas = 1 THEN 'Brazos contraidos'
			END AS RRPOS_Paracaidas,

			RRPos.Observacion as RRPOS_Observacion ,

		--CONDUCTA
			CASE 
				WHEN Co.Estado_Alerta = 6 THEN 'Alerta, mantiene el interes'
				WHEN Co.Estado_Alerta = 5 THEN 'Pierde el interes'
				WHEN Co.Estado_Alerta = 4 THEN 'Despierto/a pero no muestra interes'
				WHEN Co.Estado_Alerta = 3 THEN 'Somnoliento/a, pero se despierta facilmente'
				WHEN Co.Estado_Alerta = 2 THEN 'Letargico/a'
				WHEN Co.Estado_Alerta = 1 THEN 'No se le puede despertar'
			END AS CO_Estado_Alerta,

			CASE 
				WHEN Co.Estado_Emocional = 5 THEN 'Alegre'
				WHEN Co.Estado_Emocional = 4 THEN 'Indiferente'
				WHEN Co.Estado_Emocional = 3 THEN 'Se muestra irritable cuando nos aproximamos'
				WHEN Co.Estado_Emocional = 2 THEN 'Irritable, puede ser consolado por la madre'
				WHEN Co.Estado_Emocional = 1 THEN 'Irritable, no se le puede consolar'
			END AS CO_Estado_Emocional,

			CASE 
				WHEN Co.Sociabilidad = 4 THEN 'Sociable, busca el contacto'
				WHEN Co.Sociabilidad = 3 THEN 'Acepta el contacto'
				WHEN Co.Sociabilidad = 2 THEN 'Inseguro/a, vacila cuando nos aproximamos'
				WHEN Co.Sociabilidad = 1 THEN 'Evita el contacto'
			END AS CO_Sociabilidad,

			Co.Observacion as CO_Observacion ,
			Co.Total AS CO_TOTAL,

		--HITOS MOTORES
			Hm.Control_Cefalico AS HM_Control_Cefalico,
			Hm.Sedestacion AS HM_Sedestacion,
			Hm.Presion_Voluntaria AS HM_Presion_Voluntaria,
			Hm.Mov_Piernas AS HM_Mov_Piernas,
			Hm.Volteo AS HM_Volteo,
			Hm.Gateo AS HM_Gateo,
			Hm.Bipedestacion AS HM_Bipedestacion,
			Hm.Deambulacion AS HM_Deambulacion,
			Hm.Observacion AS HM_Observacion

		FROM RevisionPaciente Rp 
		INNER JOIN Paciente Pa on Pa.Id_Paciente = Rp.Id_Paciente
		LEFT JOIN Resultados Re on Re.Id_Paciente = Rp.Id_Paciente AND Re.Fecha_Evaluacion = @Fecha_atencion
		LEFT JOIN Conducta Co on Co.Id_Conducta = Re.Id_Conducta
		LEFT JOIN Valoracion_Tono Vt on Vt.Id_Valoracion = Re.Id_Valoracion
		LEFT JOIN Reflejos_Reacciones_Posturales RRPos on RRPos.Id_Reflejos_Reacciones_Posturales = Re.Id_RRPostulares
		LEFT JOIN Postura Po on Po.Id_Postura = Re.Id_Postura
		LEFT JOIN Hitos_Motores Hm on Hm.Id_Hitos_Motores = Re.Id_Hitos
		LEFT JOIN ParesCraneales Pc on Pc.Id_ParesCranales = Re.Id_Pares
		LEFT JOIN Movimiento Mo on Mo.Id_Movimiento = Re.Id_Movimientos
		WHERE Pa.id_Paciente = @id_paciente AND Rp.Fecha_Evaluacion = @Fecha_atencion;
END

--=============================================
--         InterpretacionResultados          --
-- ============================================
Create view ResumenEvaluacion
AS
Select 
	RP.Id_Paciente,
	Re.Fecha_Evaluacion,
	Re.Total_Hammer,
	CASE
		WHEN Total_Hammer > 60 THEN 'Un puntaje por encima de 60 es un buen predictor de que el niño podrá caminar de forma independiente, sin necesidad de ayudas para la movilidad. Esto se correlaciona con el nivel GMFCS I.'
		WHEN Total_Hammer >= 40 and Total_Hammer <= 60 THEN 'Un puntaje en este rango sugiere que el niño probablemente podrá caminar, pero posiblemente con la ayuda de dispositivos como andadores o muletas. Esto se correlaciona con los niveles GMFCS II y III.'
		ELSE ' Un puntaje total en la prueba HINE por debajo de 40 predice con alta probabilidad que el niño tendrá limitaciones motoras severas. Las imágenes muestran que probablemente requerirá ayudas para la movilidad como sillas de ruedas o andadores especiales. Esto se correlaciona con los niveles GMFCS IV y V.'
	END Resultados_Hammer
FROM RevisionPaciente RP INNER JOIN Resultados Re ON Re.Id_Paciente = RP.Id_Paciente
	 AND RP.Fecha_Evaluacion = Re.Fecha_Evaluacion
