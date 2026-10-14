SELECT 
    p.ProductoID AS ID_PROD,
    p.Producto AS NOMBRE_PRODUCTO,
    p.CantidadPorUnidad AS CANTIDAD_POR_UNIDAD,
    p.PrecioUnitario AS PRECIO_UNITARIO,
    ISNULL(c.Categoria, 'Sin Categoría') AS CATEGORIA,
    ISNULL(c.Descripcion, 'Sin Descripción') AS DESCRIPCION_CATEGORIA,
    ISNULL(pr.Proveedor, 'Sin Proveedor') AS NOMBRE_PROVEEDOR,
    ISNULL(pr.Contacto, 'Sin Contacto') AS CONTACTO_PROVEEDOR,
    ISNULL(pr.Ciudad, 'Sin Ciudad') AS CIUDAD_PROVEEDOR,
    ISNULL(pr.Pais, 'Sin País') AS PAIS_PROVEEDOR,
    ISNULL(pr.Direccion, 'Sin Dirección') AS DIRECCION
FROM Productos p
LEFT JOIN Categorias c ON p.CategoriaID = c.CategoriaID
LEFT JOIN Proveedores pr ON p.ProveedorID = pr.ProveedorID