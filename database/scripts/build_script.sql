USE [master]
GO

IF DB_ID('KentFoodsDW') IS NOT NULL
BEGIN
    ALTER DATABASE [KentFoodsDW] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [KentFoodsDW];
END
GO

CREATE DATABASE [KentFoodsDW]
GO

USE [KentFoodsDW]
GO

-- dimension transportista
CREATE TABLE [dbo].[Dim_Transportista](
    [ID_TRANSPORTISTA]     [int]           NOT NULL,
	[NOMBRE_TRANSPORTISTA] [nvarchar](100) NOT NULL,
	[TELEFONO]             [nvarchar](30)  NOT NULL,
CONSTRAINT [PK_Dim_Transportista] PRIMARY KEY CLUSTERED ([ID_TRANSPORTISTA] ASC)
) ON [PRIMARY]
GO

--dimension producto

CREATE TABLE [dbo].[Dim_Producto](
	[ID_PROD]               [int]           NOT NULL,
	[NOMBRE_PRODUCTO]       [nvarchar](100) NOT NULL,
	[CANTIDAD_POR_UNIDAD]   [nvarchar](60)  NOT NULL,
	[PRECIO_UNITARIO]       [decimal](10,2) NULL,
	[CATEGORIA]             [nvarchar](60)  NOT NULL,
	[DESCRIPCION_CATEGORIA] [nvarchar](300) NOT NULL,
	[NOMBRE_PROVEEDOR]      [nvarchar](100) NOT NULL,
	[CONTACTO_PROVEEDOR]    [nvarchar](100) NOT NULL,
	[CIUDAD_PROVEEDOR]      [nvarchar](60)  NOT NULL,
	[PAIS_PROVEEDOR]        [nvarchar](60)  NOT NULL,
	[DIRECCION]             [nvarchar](150) NOT NULL,
CONSTRAINT [PK_Dim_Producto] PRIMARY KEY CLUSTERED ([ID_PROD] ASC)
) ON [PRIMARY]
GO

--dimension empleado

CREATE TABLE [dbo].[Dim_Empleado](
    [ID_EMPLEADO]        [int]           NOT NULL,
	[NOMBRE]             [nvarchar](60)  NOT NULL,
	[APELLIDO]           [nvarchar](60)  NOT NULL,
	[CARGO]              [nvarchar](100) NOT NULL,
	[FECHA_NACIMIENTO]   [date]          NULL,
	[FECHA_CONTRATACION] [date]          NULL,
	[DIRECCION]          [nvarchar](150) NOT NULL,
	[CIUDAD]             [nvarchar](60)  NOT NULL,
	[PAIS]               [nvarchar](60)  NOT NULL,
    [TERRITORIO]         [nvarchar](500) NOT NULL,
CONSTRAINT [PK_Dim_Empleado] PRIMARY KEY CLUSTERED ([ID_EMPLEADO] ASC)
) ON [PRIMARY]
GO

-- dimension Cliente

CREATE TABLE [dbo].[Dim_Cliente](
    [ID_CLIENTE]    [nchar](5)      NOT NULL,
	[EMPRESA]       [nvarchar](100) NOT NULL,
	[CONTACTO]      [nvarchar](100) NOT NULL,
	[CARGO]         [nvarchar](100) NOT NULL,
	[DIRECCION]     [nvarchar](150) NOT NULL,
	[CIUDAD]        [nvarchar](60)  NOT NULL,
	[PAIS]          [nvarchar](60)  NOT NULL,
	[CODIGO_POSTAL] [nvarchar](20)  NOT NULL,
CONSTRAINT [PK_Dim_Cliente] PRIMARY KEY CLUSTERED ([ID_CLIENTE] ASC)
) ON [PRIMARY]
GO

-- dimension tiempo 

CREATE TABLE [dbo].[Dim_Tiempo](
    [ID_TIEMPO] [int]          NOT NULL,
	[AÑO]       [smallint]     NOT NULL,
	[MES]       [tinyint]      NOT NULL,
	[NOMBRE_MES][nvarchar](15) NOT NULL,
	[DIA]       [tinyint]      NOT NULL,
	[HORA]      [tinyint]      NOT NULL CONSTRAINT [DF_Dim_Tiempo_HORA] DEFAULT (0),
CONSTRAINT [PK_Dim_Tiempo] PRIMARY KEY CLUSTERED ([ID_TIEMPO] ASC)
) ON [PRIMARY]
GO

-- dimension detalle_venta

CREATE TABLE [dbo].[Fact_Detalle_venta](
	[ID_ORDEN]         [int]           NOT NULL,
	[ID_PROD]          [int]           NOT NULL,
	[ID_CLIENTE]       [nchar](5)      NOT NULL,
	[ID_EMPLEADO]      [int]           NOT NULL,
	[ID_TRANSPORTISTA] [int]           NOT NULL,
	[ID_FECHA_ORDEN]   [int]           NOT NULL,
	[ID_FECHA_ENVIO]   [int]           NOT NULL,
	[CANTIDAD]         [int]           NOT NULL,
	[PRECIO_UNITARIO]  [decimal](10,2) NOT NULL,
	[DESCUENTO]        [decimal](5,4)  NOT NULL,
	[MONTO_BRUTO]      [decimal](14,2) NOT NULL,
	[MONTO_DESCUENTO]  [decimal](14,2) NOT NULL,
	[MONTO_TOTAL]      [decimal](14,2) NOT NULL,
	[DIAS_DESPACHO]    [int]           NULL,
CONSTRAINT [PK_Fact_Detalle_venta] PRIMARY KEY CLUSTERED ([ID_ORDEN] ASC, [ID_PROD] ASC)
) ON [PRIMARY]
GO

--claves foraneas

ALTER TABLE [dbo].[Fact_Detalle_venta]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Detalle_venta_Dim_Cliente] FOREIGN KEY([ID_CLIENTE])
REFERENCES [dbo].[Dim_Cliente] ([ID_CLIENTE])
GO
ALTER TABLE [dbo].[Fact_Detalle_venta] CHECK CONSTRAINT [FK_Fact_Detalle_venta_Dim_Cliente]
GO
ALTER TABLE [dbo].[Fact_Detalle_venta]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Detalle_venta_Dim_Empleado] FOREIGN KEY([ID_EMPLEADO])
REFERENCES [dbo].[Dim_Empleado] ([ID_EMPLEADO])
GO
ALTER TABLE [dbo].[Fact_Detalle_venta] CHECK CONSTRAINT [FK_Fact_Detalle_venta_Dim_Empleado]
GO
ALTER TABLE [dbo].[Fact_Detalle_venta]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Detalle_venta_Dim_Transportista] FOREIGN KEY([ID_TRANSPORTISTA])
REFERENCES [dbo].[Dim_Transportista] ([ID_TRANSPORTISTA])
GO
ALTER TABLE [dbo].[Fact_Detalle_venta] CHECK CONSTRAINT [FK_Fact_Detalle_venta_Dim_Transportista]
GO
ALTER TABLE [dbo].[Fact_Detalle_venta]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Detalle_venta_Dim_Producto] FOREIGN KEY([ID_PROD])
REFERENCES [dbo].[Dim_Producto] ([ID_PROD])
GO
ALTER TABLE [dbo].[Fact_Detalle_venta] CHECK CONSTRAINT [FK_Fact_Detalle_venta_Dim_Producto]
GO
ALTER TABLE [dbo].[Fact_Detalle_venta]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Detalle_venta_Dim_Tiempo_Orden] FOREIGN KEY([ID_FECHA_ORDEN])
REFERENCES [dbo].[Dim_Tiempo] ([ID_TIEMPO])
GO
ALTER TABLE [dbo].[Fact_Detalle_venta] CHECK CONSTRAINT [FK_Fact_Detalle_venta_Dim_Tiempo_Orden]
GO
ALTER TABLE [dbo].[Fact_Detalle_venta]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Detalle_venta_Dim_Tiempo_Envio] FOREIGN KEY([ID_FECHA_ENVIO])
REFERENCES [dbo].[Dim_Tiempo] ([ID_TIEMPO])
GO
ALTER TABLE [dbo].[Fact_Detalle_venta] CHECK CONSTRAINT [FK_Fact_Detalle_venta_Dim_Tiempo_Envio]
GO