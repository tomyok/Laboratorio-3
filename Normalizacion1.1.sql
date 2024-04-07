CREATE TABLE Cursos(
	ID int not null primary key identity(1,1),
	Nombre varchar(50) not null,
)
CREATE TABLE Costos(
	ID int not null primary key identity(1,1),
	IDCurso int not null foreign key references Cursos(ID),
	CostoCursado money not null,
	CostoCertificacion Money not null
)
CREATE TABLE IdiomaAudio(
	ID int not null primary key identity(1,1),
	IDCurso int not null foreign key references Cursos(ID),
	IdiomaAudio varchar(50) not null
)
CREATE TABLE Curso_x_IdiomaAudio(
	
)
CREATE TABLE IdiomaSub(
	ID int not null primary key identity(1,1),
	IDCurso int not null foreign key references Cursos(ID),
	IdiomaSub varchar(50) not null
)
CREATE TABLE FechaDeEstreno(
	ID int not null primary key identity(1,1),
	IDCurso int not null foreign key references Cursos(ID),
	FechaDeEstreno date not null
)
CREATE TABLE Nivel(
	ID int not null primary key identity(1,1),
	IDCurso int not null foreign key references Cursos(ID),
	Nivel varchar(50)
)

/*--------------------------------------------------------------------*/

CREATE TABLE Categorias(
	ID int not null primary key identity(1,1),
	Nombre varchar(50) not null,
)

CREATE TABLE Categorias_x_Cursos(
	IDCategoria int not null foreign key references Categorias(ID),
	IDCurso int not null foreign key references Cursos(ID),
	constraint PK_Categorias_Cursos primary key (IDCategoria, IDCurso)
)
/*Hacer una tabla con idcat y idcurso*/

/*--------------------------------------------------------------------*/

CREATE TABLE Clases(
	ID int not null primary key identity(1,1),
	IDCurso int not null foreign key references Cursos(ID),
	NombreClase varchar(100) not null,
	NroClase int not null,
	Duracion int not null
)
