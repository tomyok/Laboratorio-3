-- 1.Listado con apellidos y nombres de los usuarios que no se hayan inscripto a cursos durante el año 2019.
Select Distinct DP.Nombres, DP.Apellidos From DatosPersonales DP
Inner Join Inscripciones I
On I.IDUsuario = DP.ID
Where I.IDUsuario Not In(
Select IDUsuario From Inscripciones Where Year(Fecha) = 2019
)

-- 2.Listado con apellidos y nombres de los usuarios que se hayan inscripto a cursos pero no hayan realizado ningún pago.
Select Distinct DP.Nombres, DP.Apellidos From DatosPersonales DP
Inner Join Inscripciones I
On I.IDUsuario = DP.ID
Where I.IDUsuario Not In(
Select I.IDUsuario From Inscripciones I
Inner Join Pagos P
On P.IDInscripcion = I.ID
)

-- 3.Listado de países que no tengan usuarios relacionados.
Select Distinct P.Nombre From Paises P Where P.Nombre Not In(
Select Distinct P.Nombre From Paises P
Inner Join Localidades_ L
On L.IDPais = P.ID
Inner Join DatosPersonales DP
On DP.IDLocalidad = L.ID
)

-- 4.Listado de clases cuya duración sea mayor a la duración promedio.
Select C.Nombre As NombreDeLaClase, C.Duracion From Clases C Where C.Duracion > (
Select Avg(Duracion) As Duracion From Clases
)

-- 5.Listado de contenidos cuyo tamaño sea mayor al tamaño de todos los contenidos de tipo 'Audio de alta calidad'.
Select C.ID As IDContenidosMayores From Contenidos C Where C.Tamaño > (
Select Max(C.Tamaño) From Contenidos C
Inner Join TiposContenido TP
On TP.ID = C.IDTipo
Where C.IDTipo = 1
)
-- Usando All.
Select C.ID As IDContenidosMayores From Contenidos C Where C.Tamaño > All(
Select C.Tamaño From Contenidos C
Inner Join TiposContenido TP
On TP.ID = C.IDTipo
Where C.IDTipo = 1
)

-- 6.Listado de contenidos cuyo tamaño sea menor al tamaño de algún contenido de tipo 'Audio de alta calidad'.
Select C.ID As IDContenidosMenores From Contenidos C Where C.Tamaño < (
Select Max(C.Tamaño) From Contenidos C
Inner Join TiposContenido TP
On TP.ID = C.IDTipo
Where C.IDTipo = 1
)
-- Usando Any.
Select C.ID As IDContenidosMenores From Contenidos C Where C.Tamaño < Any(
Select C.Tamaño From Contenidos C
Inner Join TiposContenido TP
On TP.ID = C.IDTipo
Where C.IDTipo = 1
)

-- 7.Listado con nombre de país y la cantidad de usuarios de género masculino y la cantidad de usuarios de género femenino que haya registrado.

Select PM.Nombre As Pais,
(
Select Count(DP.Genero) From DatosPersonales DP
Inner Join Localidades_ L
On L.ID = DP.IDLocalidad
Where DP.Genero Like 'M' and PM.ID = L.IDPais) As CantMas,
(
Select Count(DP.Genero) From DatosPersonales DP
Inner Join Localidades_ L
On L.ID = DP.IDLocalidad
Where DP.Genero Like 'F' and PM.ID = L.IDPais)
As CantFem 
From Paises PM

-- 8.Listado con apellidos y nombres de los usuarios y la cantidad de inscripciones realizadas en el 2019 y la cantidad de inscripciones realizadas en el 2020.
Select DP.Apellidos + ', ' + DP.Nombres As ApellidoyNombre,
(
Select Count(I.IDUsuario) From Inscripciones I Where Year(I.Fecha) = 2019 And I.IDUsuario = DP.ID
) As CantInscripciones2019,
(
Select Count(I.IDUsuario) From Inscripciones I Where Year(I.Fecha) = 2020 And I.IDUsuario = DP.ID
) As CantInscripciones2020
From DatosPersonales DP

-- 9.Listado con nombres de los cursos y la cantidad de idiomas de cada tipo. Es decir, la cantidad de idiomas de audio, la cantidad de subtítulos y la cantidad de texto de video.
Select C.Nombre As Curso, I.Nombre As NomIdiomasPorCurso,
(Select Count(IDFormatoIdioma) From Idiomas_x_Curso Where IDFormatoIdioma = 2 And IDCurso = C.ID And I.ID = IDIdioma) As CantAudio,
(Select Count(IDFormatoIdioma) From Idiomas_x_Curso Where IDFormatoIdioma = 1 And IDCurso = C.ID And I.ID = IDIdioma) As CantSubtitulo,
(Select Count(IDFormatoIdioma) From Idiomas_x_Curso Where IDFormatoIdioma = 3 And IDCurso = C.ID And I.ID = IDIdioma) As CantVideo
From Cursos C
Inner Join Idiomas_x_Curso IXC
On IXC.IDCurso = C.ID
Inner Join Idiomas I
On I.ID = IXC.IDIdioma
Group By C.Nombre, C.ID, I.Nombre, I.ID

-- 10.Listado con apellidos y nombres de los usuarios, nombre de usuario y cantidad de cursos de nivel 'Principiante' que realizó y cantidad de cursos de nivel 'Avanzado' que realizó.
Select DP.Apellidos + ', ' + DP.Nombres As ApellidoYNombre, U.NombreUsuario,
(
Select Count(C.IDNivel) From Cursos C
Inner Join Inscripciones I
On I.IDCurso = C.ID
Where C.IDNivel = 5 And I.IDUsuario = DP.ID
)
As CantNvlPrincipiante,
(
Select Count(C.IDNivel) From Cursos C
Inner Join Inscripciones I
On I.IDCurso = C.ID
Where C.IDNivel = 3 And I.IDUsuario = DP.ID
)
As CantNvlAvanzado
From DatosPersonales DP
Inner Join Usuarios U
On U.ID = DP.ID
Group By DP.Apellidos + ', ' + DP.Nombres, U.NombreUsuario, DP.ID

-- 11.Listado con nombre de los cursos y la recaudación de inscripciones de usuarios de género femenino que se inscribieron y la recaudación de inscripciones de usuarios de género masculino.
Select C.Nombre As Curso,
(Select Sum(I.Costo) From Inscripciones I
Inner Join DatosPersonales DP
On DP.ID = I.IDUsuario
Where DP.Genero like 'F' And C.ID = I.IDCurso
) As RecGeneroFem,
(Select Sum(I.Costo) From Inscripciones I
Inner Join DatosPersonales DP
On DP.ID = I.IDUsuario
Where DP.Genero like 'M' And C.ID = I.IDCurso) As RecGeneroMas
From Cursos C
Group By C.Nombre, C.ID

-- 12.Listado con nombre de país de aquellos que hayan registrado más usuarios de género masculino que de género femenino.

Select P.Nombre As Pais From Paises P Where 
(
Select Count(DP.Genero) From DatosPersonales DP
Inner Join Localidades_ L
On L.ID = DP.IDLocalidad
Where DP.Genero like 'M' And L.IDPais = P.ID
)
> 
(
Select Count(DP.Genero) From DatosPersonales DP
Inner Join Localidades_ L
On L.ID = DP.IDLocalidad
Where DP.Genero like 'F' And L.IDPais = P.ID
)

-- 13.Listado con nombre de país de aquellos que hayan registrado más usuarios de género masculino que de género femenino pero que haya registrado al menos un usuario de género femenino.
Select P.Nombre As Pais From Paises P Where 
(
Select Count(DP.Genero) From DatosPersonales DP
Inner Join Localidades_ L
On L.ID = DP.IDLocalidad
Where DP.Genero like 'M' And L.IDPais = P.ID
)
> 
(
Select Count(DP.Genero) From DatosPersonales DP
Inner Join Localidades_ L
On L.ID = DP.IDLocalidad
Where DP.Genero like 'F' And L.IDPais = P.ID
) 
And 
(
Select Count(DP.Genero) From DatosPersonales DP
Inner Join Localidades_ L
On L.ID = DP.IDLocalidad
Where DP.Genero like 'F' And L.IDPais = P.ID
) > 0

-- 14.Listado de cursos que hayan registrado la misma cantidad de idiomas de audio que de subtítulos.
Select C.Nombre As Curso From Cursos C Where
(
Select Count(IXC.IDIdioma) From Idiomas_x_Curso IXC
Where IXC.IDFormatoIdioma = 1 And IXC.IDCurso = C.ID
) 
=
(
Select Count(IXC.IDIdioma) From Idiomas_x_Curso IXC
Where IXC.IDFormatoIdioma = 2 And IXC.IDCurso = C.ID
)
 -- 15.Listado de usuarios que hayan realizado más cursos en el año 2018 que en el 2019 y a su vez más cursos en el año 2019 que en el 2020.
 Select U.NombreUsuario As Usuario From Usuarios U Where
 (
 Select Count(I.IDUsuario) From Inscripciones I 
 Where Year(I.Fecha) = 2018 And I.IDUsuario = U.ID
 ) 
 >
 (
 Select Count(I.IDUsuario) From Inscripciones I 
 Where Year(I.Fecha) = 2019 And I.IDUsuario = U.ID
 )
 And 
 (
 Select Count(I.IDUsuario) From Inscripciones I 
 Where Year(I.Fecha) = 2019 And I.IDUsuario = U.ID
 )
 >
 (
 Select Count(I.IDUsuario)  From Inscripciones I 
 Where Year(I.Fecha) = 2020 And I.IDUsuario = U.ID
 )

 -- 16.Listado de apellido y nombres de usuarios que hayan realizado cursos pero nunca se hayan certificado.
 -- Aclaración: Listado con apellidos y nombres de usuarios que hayan realizado al menos un curso y no se hayan certificado nunca.
 
 Select Distinct Cursantes.ApellidoYNombre From 
 (
 Select DP.Apellidos + ', ' + DP.Nombres As ApellidoYNombre From DatosPersonales DP
 Inner Join Inscripciones I
 On I.IDUsuario = DP.ID
 ) As Cursantes
 Where Cursantes.ApellidoYNombre Not In
 (
 Select DP.Apellidos + ', ' + DP.Nombres As ApellidoYNombre From DatosPersonales DP
 Inner Join Inscripciones I
 On I.IDUsuario = DP.ID
 Inner Join Certificaciones CT
 On CT.IDInscripcion = I.ID
 )
