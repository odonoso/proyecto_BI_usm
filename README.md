# proyecto_BI_usm


## Caso Seleccionado:

El caso de estudio corresponde a la empresa **Kent Foods**, una organización comercial dedicada a la venta y distribución de productos alimenticios mediante despachos a domicilio y envíos. La compañía ha experimentado un crecimiento acelerado durante los últimos años, lo que ha generado una acumulación significativa de registros operacionales en su base de datos transaccional (cubriendo clientes, colaboradores, catálogo de alimentos, proveedores, transportistas y órdenes de compra con sus respectivos detalles). Ante esta expansión, el propietario de la organización requiere incorporar una arquitectura de Inteligencia de Negocios que permita transformar dichos registros operativos en información estructurada para la toma oportuna de decisiones.

## Información de equipo de trabajo

- Felipe Gamboa
- Osvaldo Donoso
- Gonzalo Cayupil

## Sección y Asignatura

- **Asignatura**: Inteligencia de negocios
- **Sección**: Paralelo 300
- **Docente**: Hernan Marcelo Saavedra Gonzalez

## Descripción del problema

Debio al rápido crecimiento en el volumen de operaciones de Kent Foods, los directivos y encargados de área enfrentan dificultades para evaluar el desempeño real del negocio a partir de su base de datos relacional transaccional (OLTP).

## Objetivo del Proyecto

Diseñar e implementar una solución de Inteligencia de Negocios para la empresa Kent Foods, estructurando un Data Warehouse dimensional mediante la metodología Kimball y desarrollando un flujo automatizado de Extracción, Transformación y Carga (ETL) en SQL Server Integration Services (SSIS), con el fin de suministrar información confiable y métricas consolidadas que optimicen la toma de decisiones estratégicas del propietario y la gerencia.


## Creación del modelo dimensional

Para este proceso de negocio, se escogerá el modelo dimensional "**TIPO ESTRELLA**", que nos ayudará a desnormalizar las tablas operacionales y optimizar las consultas SQL


- **Proceso de negocio**: Proceso de ventas y despacho de alimentos a clientes

- **Granularidad**: fila/item de producto por venta

- **Dimensiones**: DIM_CLIENTE, DIM_PRODUCTO, DIM_EMPLEADO, DIM_TIEMPO, DIM_TRANSPORTISTA

- **Medidas**: cantidad, precio_unitario, descuento, monto_bruto(**cantidad x precio_unitario**), monto_descuento(**cantidad x precio_unitario x descuento**), monto_total (**monto_bruto - monto_descuento**), dias_despacho

- **Tabla de hechos**: FACT_DETALLE_VENTA, la cual almacena las claves foráneas de las dimensiones (id_cliente, id_producto, id_empleado, id_fecha_orden,id_fecha_envio, id_transportista)

### Esquema dimensional 

![](docs/modelo-dimensional/Fact.png)


## KPIs definidos

- **Ventas Netas Totales**: 
    - **Fórmula analítica:** $\sum \text{MontoNeto} = \sum (\text{Cantidad} \times \text{PrecioUnitario} \times (1 - \text{Descuento}))$. 

    - **Dimensiones de análisis:** Dim_Tiempo (mes, dia, año), Dim_Producto (categoría de alimentos), Dim_Cliente (país/ciudad).

    - **Justificación de negocio:** Es el indicador principal de salud comercial y crecimiento financiero de Kent Foods. Permite monitorear si las metas de ingresos se están cumpliendo a lo largo del tiempo e identificar qué líneas de alimentos traccionan la mayor recaudación.

- **Concentración de Ventas por Categoría de Alimento**
    - **Fórmula analítica:** $\frac{\text{Ventas Netas por Categoría}}{\text{Ventas Netas Totales}} \times 100$.
    
    - **Dimensiones de análisis:** Dim_Producto (Categoria, Proveedor).

    - **Justificación de negocio:** Detecta qué categorías de alimentos concentran el mayor volumen de negocio y cuáles tienen baja rotación, facilitando decisiones estratégicas de abastecimiento con proveedores y gestión de inventario.

- **Desempeño y Ranking de Mejores Proveedores**
    
    - **Fórmula análitica:** $\sum (\text{Cantidad} \times \text{PrecioUnitario} \times (1 - \text{Descuento})) \quad \text{agrupado por } \text{NombreProveedor}$

    - **Dimensiones de análisis:** Dim_Producto (NombreProveedor, PaisProveedor, NombreCategoria).   Dim_Tiempo (Anio, Trimestre, Mes). 
    
    - **Justificación de negocio:** Kent Foods comercializa productos alimenticios elaborados por terceros. Medir el rendimiento de cada proveedor permite a la gerencia:   Identificar socios estratégicos clave para negociar mejores acuerdos de compra por volumen o descuentos por pronto pago.Evaluar el riesgo de dependencia frente a un proveedor específico.Detectar proveedores con baja rotación o catálogo de alimentos poco demandado para renegociar contratos o reemplazarlos. 

- **Tiempo Promedio de Entrega y Despacho**
    
    - **Formula análitica:** $$\frac{\sum (\text{FechaEnvio} - \text{FechaOrden})}{\text{Cantidad Total de Órdenes Despachadas}}$$

    - **Justificacion del negocio:** Dado que el modelo comercial de la empresa se basa en el envío de alimentos perecibles y no perecibles, la velocidad del despacho es crítica para asegurar la frescura de los productos y la satisfacción del consumidor.



## Script SQL (build_script.sql)

Creación de la base de datos del modelo dimensional

La base KentFoodsDW se crea con un modelo en estrella: 5 dimensiones (Transportista, Producto, Empleado, Cliente y Tiempo) y 1 tabla de hechos (Detalle_venta), unidas por claves foráneas. El script borra y recrea la base, así que puede ejecutarse más de una vez.

**Transportista:** empresa que despacha el pedido. Campos: ID_TRANSPORTISTA (clave primaria), NOMBRE_TRANSPORTISTA y TELEFONO.

**Producto:** productos vendidos, con su categoría y proveedor aplanados en una sola tabla. Campos: ID_PROD (clave primaria), NOMBRE_PRODUCTO, CANTIDAD_POR_UNIDAD, PRECIO_UNITARIO (precio de lista), CATEGORIA, DESCRIPCION_CATEGORIA, NOMBRE_PROVEEDOR, CONTACTO_PROVEEDOR, CIUDAD_PROVEEDOR, PAIS_PROVEEDOR y DIRECCION (del proveedor).

**Empleado:** empleados que gestionan las ventas y su ubicación. Campos: ID_EMPLEADO (clave primaria), NOMBRE, APELLIDO, CARGO, FECHA_NACIMIENTO, FECHA_CONTRATACION, DIRECCION, CIUDAD, PAIS y TERRITORIO (territorios atendidos, concatenados en un solo texto).

**Cliente:** empresas que compran. Campos: ID_CLIENTE (clave primaria), EMPRESA, CONTACTO, CARGO, DIRECCION, CIUDAD, PAIS y CODIGO_POSTAL.

**Tiempo:** calendario generado por script, usado para la fecha de orden y la de envío. Campos: ID_TIEMPO (clave primaria, formato AAAAMMDD), AÑO, MES, NOMBRE_MES, DIA y HORA.

**Detalle_venta:** tabla de hechos, con una fila por producto dentro de una orden.

* **Claves:** ID_DETALLE_VENTA (clave primaria autoincremental), y las claves foráneas ID_CLIENTE, ID_EMPLEADO, ID_TRANSPORTISTA, ID_PROD, ID_FECHA_ORDEN e ID_FECHA_ENVIO (-1 si no se ha enviado).
* **Medidas:** CANTIDAD, PRECIO_UNITARIO, DESCUENTO (entre 0 y 1), MONTO_BRUTO (cantidad por precio), MONTO_DESCUENTO, MONTO_TOTAL (bruto menos descuento) y DIAS_DESPACHO (días entre orden y envío, nulo si no se ha enviado).


## Proceso ETL 

El proceso de Extracción, Transformación y Carga (ETL) se está desarrollando utilizando **SQL Server Integration Services (SSIS)** mediante Visual Studio. 

**Arquitectura de Conexiones:**
* **Origen:** Conexión OLE DB apuntando a la base de datos transaccional original (`KentFoods`).
* **Destino:** Conexión OLE DB apuntando al Data Warehouse (`KentFoodsDW`).

**Progreso de Carga de Dimensiones:**
* **Dimensión Transportista:** Se implementó el flujo de datos (Data Flow) realizando una extracción directa desde la tabla origen `Transportista` hacia la tabla destino `[dbo].[Transportista]` en el DW. Se verificó el correcto mapeo de las columnas (ID, Nombre y Teléfono) logrando una transferencia exitosa de los registros sin errores de compatibilidad de metadatos.
* **Dimensión Cliente:** Se implementó el flujo de datos integrando un componente de **Columna Derivada** para gestionar y limpiar los valores nulos del campo `CodigoPostal` mediante la función `REPLACENULL`, asegurando el cumplimiento de la restricción `NOT NULL` en el Data Warehouse. Se logró una transferencia exitosa de **91 filas** hacia la tabla destino `[dbo].[Cliente]`.
* **Dimensión Producto:** Se configuró el flujo de datos integrando las tablas origen `Productos`, `Categorias` y `Proveedores` mediante una consulta SQL con `LEFT JOIN` para garantizar la integridad analítica y evitar la pérdida de registros. Se implementó un componente de **Conversión de Datos** para transformar el tipo de dato antiguo `ntext` a `DT_WVARCHAR` en la descripción de categoría, y se aplicó manejo de nulos con `ISNULL`. Se transfirieron exitosamente **77 filas** hacia la tabla destino `[dbo].[Dim_Producto]`.
* **Dimensión Empleado:** Se configuró el flujo para cargar `Dim_Empleado` uniendo las tablas `Empleados`, `TerritoriosEmpleados` y `Territorios`. Como algunos trabajadores están asignados a varias zonas, se usó una subconsulta con `MIN(TerritorioID)` para evitar duplicados y errores de llave primaria. Se cargaron exitosamente **49 filas** a la tabla destino.
* **Dimensión Tiempo:** Se estructuró y pobló mediante un script T-SQL que calcula automáticamente el rango de fechas calendario basándose estrictamente en las operaciones reales de la tabla de órdenes origen, utilizando tipos de datos eficientes (`ID_TIEMPO` en formato entero `YYYYMMDD`, `AÑO` smallint, `MES`/`DIA`/`HORA` tinyint).
* **Tabla de Hechos (`FACT_DETALLE_VENTA`):** Se configuró la carga de **2,155 filas** operativas en SSIS mediante una consulta SQL optimizada. Incorpora métricas de negocio precalculadas (`MONTO_BRUTO`, `MONTO_DESCUENTO`, `MONTO_TOTAL`, `DIAS_DESPACHO`), transformación de fechas a formato entero para enlazar con la dimensión `Tiempo`, y se apoya en la llave autoincremental (`IDENTITY`) de la tabla destino con validación de unicidad por grano (`[ID_ORDEN]`, `[ID_PROD]`).