CREATE TABLE Cursos(
	ID int not null primary key identity(1,1),
	Nombre varchar(50) not null,
	CostoCursado money not null,
	CostoCertificacion Money not null,
	FechaDeEstreno date not null,
	Nivel varchar(50)
)
CREATE TABLE IdiomaAudio(
	ID int not null primary key identity(1,1),
	IdiomaAudio varchar(50) not null
)
CREATE TABLE Curso_x_IdiomaAudio(
	IDCurso int not null foreign key references Cursos(ID),
	IDIdiomaAudio int not null foreign key references IdiomaAudio(ID),
	constraint PK_Audio_Curso primary key (IDCurso, IDIdiomaAudio)
)
CREATE TABLE IdiomaSub(
	ID int not null primary key identity(1,1),
	IdiomaSub varchar(50) not null
)
CREATE TABLE Curso_x_IdiomaSub(
	IDCurso int not null foreign key references Cursos(ID),
	IDIdiomaSub int not null foreign key references IdiomaSub(ID),
	constraint PK_Sub_Curso primary key (IDCurso, IDIdiomaSub)
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

/*--------------------------------------------------------------------*/

CREATE TABLE Clases(
	ID int not null primary key identity(1,1),
	IDCurso int not null foreign key references Cursos(ID),
	NombreClase varchar(100) not null,
	NroClase int not null,
	Duracion int not null
)

/*--------------------------------------------------------------------*/

CREATE TABLE Contenidos(
	
)
