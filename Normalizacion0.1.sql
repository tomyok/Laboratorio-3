CREATE DATABASE EjercicioNormalizacion
USE EjercicioNormalizacion
CREATE TABLE Persona(
	IDPersona int not null primary key identity(1,1),
	Nombres varchar(50) not null,
	Apellido varchar(50) not null
)
CREATE TABLE Idioma(
	IDIdioma int not null primary key identity(1,1),
	Idioma varchar(50) not null unique
)
CREATE TABLE NivelIdioma(
	IDNivelIdioma int not null primary key check(IDNivelIdioma between 1 and 5),
	NivelIdioma varchar(100) not null unique
)
CREATE TABLE Persona_x_Idioma_x_NivelIdioma(
	Persona int not null foreign key references Persona(IDPersona),
	Idioma int not null foreign key references Idioma(IDIdioma),
	NivelIdioma int not null foreign key references NivelIdioma(IDNivelIdioma),
	constraint PK_Idioma_Persona primary key (Persona, Idioma)
)
