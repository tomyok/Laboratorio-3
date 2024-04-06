CREATE TABLE Costos(
	ID int not null primary key identity(1,1),
	CostoCursado money not null,
	CostoCertificacion Money not null
)
CREATE TABLE Idioma(
	ID int not null primary key identity(1,1),
	IdiomaAudio varchar(50) not null unique,
	IdiomaSub varchar(50) unique
)
CREATE TABLE FechaDeEstreno(
	ID int not null primary key identity(1,1),
	FechaDeEstreno date not null
)
CREATE TABLE Nivel(
	ID int not null primary key identity(1,1),
	Nivel varchar(50)
)
CREATE TABLE Cursos(
	ID int not null primary key identity(1,1),
	Nombre varchar(50) not null
)

/*--------------------------------------------------------------------*/

CREATE TABLE Clases(
	ID int not null primary key identity(1,1),
	IDCurso int not null foreign key references Cursos(ID),
	NombreClase varchar(100) not null,
	NroClase int not null,
	Duracion int not null
)
