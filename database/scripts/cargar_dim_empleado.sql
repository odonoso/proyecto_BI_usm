SELECT 
    e.EmpleadoID AS ID_EMPLEADO,
    e.Nombre AS NOMBRE,
    e.Apellido AS APELLIDO,
    e.Cargo AS CARGO,
    e.FechaNacimiento AS FECHA_NACIMIENTO,
    e.FechaContratacion AS FECHA_CONTRATACION,
    e.Direccion AS DIRECCION,
    e.Ciudad AS CIUDAD,
    e.Pais AS PAIS,
    ISNULL(t.Territorio, 'Sin Territorio') AS TERRITORIO
FROM Empleados e
LEFT JOIN (
    SELECT EmpleadoID, MIN(TerritorioID) AS TerritorioID
    FROM TerritoriosEmpleados
    GROUP BY EmpleadoID
) te ON e.EmpleadoID = te.EmpleadoID
LEFT JOIN Territorios t ON te.TerritorioID = t.TerritorioID