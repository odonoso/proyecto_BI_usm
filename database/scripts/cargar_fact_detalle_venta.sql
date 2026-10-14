SELECT 

    -- Llaves de la tabla de hechos

    d.OrdenID AS ID_ORDEN,

    d.ProductoID AS ID_PROD,
 -- Llaves Foraneas (Dimensiones)

    o.ClienteID AS ID_CLIENTE,

    o.EmpleadoID AS ID_EMPLEADO,

    o.EnviadoPor AS ID_TRANSPORTISTA,

-- Llaves Foraneas (Tiempo)
ISNULL(CAST(FORMAT(o.FechaOrden, 'yyyyMMdd') AS INT), 20180101) AS ID_FECHA_ORDEN,


ISNULL(CAST(FORMAT(o.FechaEnvio, 'yyyyMMdd') AS INT), 20180101) AS ID_FECHA_ENVIO,
    
    

-- Metricas base con validación de tipos y nulos

    d.Cantidad AS CANTIDAD,

    CAST(d.PrecioUnitario AS DECIMAL(10,2)) AS PRECIO_UNITARIO,
 
    CAST(ISNULL(d.Descuento, 0) AS DECIMAL(5,4)) AS DESCUENTO,


-- KPIs Calculados 
    
     CAST((d.Cantidad * d.PrecioUnitario) AS DECIMAL(14,2)) AS MONTO_BRUTO,

    
  CAST((d.Cantidad * d.PrecioUnitario * ISNULL(d.Descuento, 0)) AS DECIMAL(14,2)) AS MONTO_DESCUENTO,

  
    CAST(((d.Cantidad * d.PrecioUnitario) * (1 - ISNULL(d.Descuento, 0))) AS DECIMAL(14,2)) AS MONTO_TOTAL,

    
    
-- KPI de tiempos
    
    ISNULL(DATEDIFF(day, o.FechaOrden, o.FechaEnvio), 0) AS DIAS_DESPACHO



FROM DetalleOrden d

INNER JOIN Ordenes o ON d.OrdenID = o.OrdenID;