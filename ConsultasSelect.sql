-- 1.Listado de todos los idiomas.
Select * From Idiomas;

-- 2.Listado de todos los cursos.
Select * From Cursos;

-- 3.Listado con nombre, costo de inscripción (costo de curso), costo de certificación y fecha de estreno de todos los cursos.
Select Nombre As Curso, CostoCurso, CostoCertificacion, FechaEstreno From Cursos;

-- 4.Listado con ID, nombre, costo de inscripción y ID de nivel de todos los cursos cuyo costo de certificación sea menor a $5000.
Select ID, Nombre As Curso, CostoCurso, IDNivel From Cursos Where CostoCertificacion < 5000;

-- 5.Listado con ID, nombre, costo de inscripción y ID de nivel de todos los cursos cuyo costo de certificación sea mayor a $1200.
Select ID, Nombre As Curso, CostoCurso, IDNivel From Cursos Where CostoCertificacion > 1200;

-- 6.Listado con nombre, número y duración de todas las clases del curso con ID número 6.
Select Nombre As Clase, Numero, Duracion From Clases Where ID=6;

-- 7.Listado con nombre, número y duración de todas las clases del curso con ID número 10.
Select Nombre As Clase, Numero, Duracion From Clases Where ID=10;

-- 8.Listado con nombre y duración de todas las clases del curso con ID número 4. Ordenado por duración de mayor a menor.
Select Nombre As Clase, Duracion From Clases Where ID=4 Order By Duracion Desc;

-- 9.Listado de cursos con nombre, fecha de estreno, costo del curso, costo de certificación ordenados por fecha de estreno de manera creciente.
Select Nombre As Curso, FechaEstreno, CostoCurso, CostoCertificacion From Cursos Order By FechaEstreno Asc;

-- 10.Listado con nombre, fecha de estreno y costo del curso de todos aquellos cuyo ID de nivel sea 1, 5, 9 o 10.
Select Nombre As Curso, FechaEstreno, CostoCurso From Cursos Where IDNivel = 1 OR IDNivel = 5 OR IDNivel = 9 OR IDNivel = 10;

-- 11.Listado con nombre, fecha de estreno y costo de cursado de los tres cursos más caros de certificar.
Select Top (3) Nombre As Curso, FechaEstreno, CostoCurso From Cursos ORDER BY CostoCertificacion Desc;

-- 12.Listado con nombre, duración y número de todas las clases de los cursos con ID 2, 5 y 7. Ordenados por ID de Curso ascendente y luego por número de clase ascendente.
Select Nombre As Clase, Duracion, Numero From Clases Where ID=2 OR ID=5 OR ID=7 Order By IDCurso Asc, Numero Asc;

-- 13.Listado con nombre y fecha de estreno de todos los cursos cuya fecha de estreno haya sido en el primer semestre del año 2019.
Select Nombre As Curso, FechaEstreno From Cursos Where FechaEstreno Between '1/1/2019' And '7/1/2019';

-- 14.Listado de cursos cuya fecha de estreno haya sido en el año 2020.
Select * From Cursos Where YEAR(FechaEstreno)=2020; 

-- 15.Listado de cursos cuyo mes de estreno haya sido entre el 1 y el 4.
Select * From Cursos Where MONTH(FechaEstreno) Between 1 And 4; 

-- 16.Listado de clases cuya duración se encuentre entre 15 y 90 minutos.
Select * From Clases Where Duracion Between 15 And 90;

-- 17.Listado de contenidos cuyo tamaño supere los 5000MB y sean de tipo 4 o sean menores a 400MB y sean de tipo 1.
Select * From Contenidos Where (Tamaño > 5000 And IDTipoContenido = 4) Or (Tamaño < 400 And IDTipoContenido = 1);

-- 18.Listado de cursos que no posean ID de nivel.
Select * From Cursos Where IDNivel Is Null;

-- 19.Listado de cursos cuyo costo de certificación corresponda al 20% o más del costo del curso.
Select * From Cursos Where CostoCertificacion >= CostoCurso*0.2;

-- 20.Listado de costos de cursado de todos los cursos sin repetir y ordenados de mayor a menor.
Select Distinct CostoCurso From Cursos Order By CostoCurso Asc;
