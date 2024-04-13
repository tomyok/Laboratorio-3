Create Database Univ
Go
Use Univ
Go
Create Table Niveles(
    ID smallint not null primary key identity(1, 1),
    Nombre varchar(50) not null
)
Go
Create Table Idiomas(
    ID smallint not null primary key identity (1, 1),
    Nombre varchar(50) not null
)
Go
Create Table Cursos(
    ID int not null primary key identity (1, 1),
    Nombre varchar(100) not null,
    CostoCurso money not null,
    CostoCertificacion money not null,
    FechaEstreno date not null,
    IDNivel smallint null foreign key references Niveles(ID)
)
Go
Create Table FormatosIdioma(
    ID smallint not null primary key identity (1, 1),
    Nombre varchar(50) not null
)
Go
Create Table Idiomas_x_Curso(
    IDIdioma smallint not null foreign key references Idiomas(ID),
    IDCurso int not null foreign key references Cursos(ID),
    IDFormatoIdioma smallint not null foreign key references FormatosIdioma(ID),
    primary key (IDIdioma, IDCurso, IDFormatoIdioma)   
)
Go
Create Table Clases(
    ID bigint not null primary key identity(1,1),
    IDCurso int not null foreign key references Cursos(ID),
    Nombre varchar(100) not null,
    Numero smallint not null,
    Duracion int not null check (Duracion > 0)
)
Go
Create Table TiposContenido(
    ID smallint not null primary key identity(1,1),
    Nombre varchar(50) not null
)
Go
Create Table Contenidos(
    ID bigint not null primary key identity(1, 1),
    IDClase bigint not null foreign key references Clases(ID),
    IDTipoContenido smallint not null foreign key references TiposContenido(ID),
    Tamaño int not null, -- MB
)
Go
Create Table Categorias(
    ID smallint not null primary key identity(1, 1),
    Nombre varchar(100) not null
)
Go
Create Table Categorias_x_Curso(
    IDCurso int not null foreign key references Cursos(ID),
    IDCategoria smallint not null foreign key references Categorias(ID),
    primary key (IDCurso, IDCategoria)
)
Go

/*          Normalizacion Univ Actividad1.2          */

Create Table Paises(
	ID smallint not null primary key identity(1,1),
	Nombre varchar(100) not null
)
Go
Create Table Usuarios(
	ID int not null primary key identity(1,1),
	Usuario varchar(100) not null,
	Email varchar(100),
)
Go
Create Table DatosPersonales(
	IDUsuario int not null primary key foreign key references Usuarios(ID),
	Apellidos varchar(100) not null,
	Nombres varchar(100) not null,
	FechaNacimiento date not null,
	Genero char(1) check(Genero = 'M' or Genero = 'F'),
	Telefono int,
	Celular int,
	Domicilio varchar(100) not null,
	Cp int not null,
	IDPais smallint not null foreign key references Paises(ID),
	NombreCiudad varchar(100) not null
)
Go
Create Table Instructores(
	ID int not null primary key identity(1,1),
	IDUsuario int not null foreign key references Usuarios(ID),
)
Go
Create Table Instructores_x_Curso(
	IDInstructores int not null foreign key references Instructores(ID),
	IDCurso int not null foreign key references Cursos(ID),
)
Go
Create Table Inscripciones(
	ID smallint not null primary key identity(1,1),
	IDCurso int not null foreign key references Cursos(ID),
	IDUsuario int not null foreign key references Usuarios(ID),
	FechaInscripcion date not null
)
Go
Create Table Pagos(
	ID smallint not null primary key identity(1,1),
	FechaPago date,
	Pago money,
)
Go
Create Table Inscripciones_x_Pagos(
	IDInscripciones smallint not null foreign key references Inscripciones(ID),
	IDPagos smallint not null foreign key references Pagos(ID)
	constraint PK_Pagos_Inscripciones primary key (IDinscripciones, IDPagos)
)
Go
Create Table Resenias(
	ID smallint not null primary key identity(1,1),
	IDInscripciones smallint not null foreign key references Inscripciones(ID),
	Resenia varchar(200) not null,
	Puntaje int not null check(Puntaje between 0 and 10)
)
Go
Create Table Certificacion(
	ID smallint not null primary key identity(1,1),
	IDInscripciones smallint not null foreign key references Inscripciones(ID),
	FechaCertificacion Date not null,
	CostoCertificacion money not null
)
Go
