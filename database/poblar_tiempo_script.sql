SET NOCOUNT ON;

DECLARE @FechaInicio DATETIME;
DECLARE @FechaFin DATETIME;

-- Obtiene automáticamente el rango real de las órdenes
SELECT 
    @FechaInicio = MIN(FechaOrden),
    @FechaFin = MAX(ISNULL(FechaEnvio, FechaOrden))
FROM KentFoods.dbo.Ordenes;

-- Ajusta al año calendario completo
SET @FechaInicio = DATEFROMPARTS(YEAR(@FechaInicio), 1, 1);
SET @FechaFin = DATEFROMPARTS(YEAR(@FechaFin), 12, 31);

-- Bucle para poblar la tabla Tiempo respetando los tipos exactos
WHILE @FechaInicio <= @FechaFin
BEGIN
    INSERT INTO Tiempo (ID_TIEMPO, AÑO, MES, NOMBRE_MES, DIA, HORA)
    SELECT 
        CAST(FORMAT(@FechaInicio, 'yyyyMMdd') AS INT) AS ID_TIEMPO,
        CAST(YEAR(@FechaInicio) AS SMALLINT) AS AÑO,
        CAST(MONTH(@FechaInicio) AS TINYINT) AS MES,
        DATENAME(month, @FechaInicio) AS NOMBRE_MES,
        CAST(DAY(@FechaInicio) AS TINYINT) AS DIA,
        CAST(0 AS TINYINT) AS HORA
    WHERE NOT EXISTS (
        SELECT 1 FROM Tiempo WHERE ID_TIEMPO = CAST(FORMAT(@FechaInicio, 'yyyyMMdd') AS INT)
    );

    SET @FechaInicio = DATEADD(day, 1, @FechaInicio);
END;
