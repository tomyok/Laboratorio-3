Alter Table Cursos
Add DebeSerMayorDeEdad bit Default 0

Update Cursos
Set DebeSerMayorDeEdad=1
Where ID = 2

Update Cursos
Set DebeSerMayorDeEdad=1
Where ID = 3

Update Cursos
Set DebeSerMayorDeEdad=1
Where ID = 4

-- 1.Hacer una función llamada FN_PagosxUsuario que a partir de un IDUsuario devuelva el total abonado en concepto de pagos. Si no hay pagos debe retornar 0.
Create Function FN_PagosxUsuario(
@IDUsuario int 
)
Returns int
As
Begin 
	Declare @Totalpagos int

	Select @Totalpagos=Sum(p.Importe) from Pagos p
	Inner Join Inscripciones i
	On i.ID = P.IDInscripcion
	Where i.IDUsuario = @IDUsuario
	if @TotalPagos Is Null Begin
	Return 0
	End

	Return @Totalpagos
End

Select dbo.FN_PagosxUsuario(u.ID) as PagosxUsuarios From Usuarios u

-- 2.Hacer una función llamada FN_DeudaxUsuario que a partir de un IDUsuario devuelva el total adeudado. Si no hay deuda debe retornar 0.
Create Or Alter Function FN_DeudaxUsuario(
@IDusuario int
)
Returns money
As
Begin
	Declare @CapitalAdeudado money
	
	Select @CapitalAdeudado = Coalesce(Sum(i.Costo) - Sum(p.Importe), 0) From Inscripciones i
	Inner Join Pagos p On i.ID = p.IDInscripcion
	Inner Join Usuarios u On i.IDUsuario = u.ID
	Where u.ID = @IDusuario

	Return @CapitalAdeudado

End

Select Distinct u.ID, u.NombreUsuario, Sum(p.Importe) As ImportePago, Sum(i.Costo) As CostoInscrip , dbo.FN_DeudaxUsuario(U.ID) as CapitalAdeudado From Usuarios u
Inner Join Inscripciones i On i.IDUsuario = u.ID
Inner Join Pagos p On p.IDInscripcion = I.ID
Group By u.ID, U.NombreUsuario

-- 3.Hacer una función llamada FN_CalcularEdad que a partir de un IDUsuario devuelva la edad del mismo. La edad es un valor entero.
Create Or Alter Function FN_CalcularEdad(
@IDUsuario int
)
Returns int
As
Begin
	
	Declare @Edad int

	Select @Edad = CASE
			WHEN MONTH(GETDATE()) > MONTH(dp.Nacimiento) OR
			(MONTH(GETDATE()) = MONTH(dp.Nacimiento) AND DAY(GETDATE()) >= DAY(dp.Nacimiento))
			THEN YEAR(GETDATE()) - YEAR(dp.Nacimiento)
					ELSE
						YEAR(GETDATE()) - YEAR(dp.Nacimiento) -1
				END
			From Datos_Personales AS dp
			Inner Join Usuarios u On u.ID = dp.ID
			Where u.ID = @IDUsuario

			Return @Edad
End

Select u.NombreUsuario, dbo.FN_CalcularEdad(u.ID) As Edad From Usuarios u

-- 4.Hacer una función llamada Fn_PuntajeCurso que a partir de un IDCurso devuelva el promedio de puntaje en concepto de reseñas..

Create or Alter Function FN_PuntajeCurso(
@IDCurso int
)
Returns int
As
Begin

	Declare @PromedioPuntaje decimal

	Select @PromedioPuntaje = Avg(R.Puntaje) From Reseñas R
	Inner Join Inscripciones I On R.IDInscripcion = I.ID
	Inner Join Cursos C On I.IDCurso = C.ID
	Where C.ID = @IDCurso

	Return @PromedioPuntaje

End

Select C.Nombre, dbo.FN_PuntajeCurso(C.ID) As PromedioPuntaje from Cursos C

-- 5.Hacer una vista que muestre por cada usuario el apellido y nombre, una columna llamada Contacto que muestre el celular, si no tiene celular el teléfono, si no tiene teléfono el email, si no tiene email el domicilio. También debe mostrar la edad del usuario, el total pagado y el total adeudado.

Create Or Alter View VW_Usuarios
As
Select
	DP.Nombres,
	DP.Apellidos,
	COALESCE(DP.Celular, DP.Telefono, DP.Email, DP.Domicilio) AS Contacto,
	dbo.FN_CalcularEdad(DP.ID) As Edad,
	dbo.FN_PagosxUsuario(DP.ID) As TotalPagado,
	dbo.FN_DeudaxUsuario(DP.ID) As TotalAdeudado

	From Datos_Personales DP;

Select * From VW_Usuarios 

-- 6.Hacer uso de la vista creada anteriormente para obtener la cantidad de usuarios que adeuden más de los que pagaron.

Select Count(*) As CantUsuariosAdeudan From VW_Usuarios V Where V.TotalAdeudado > V.TotalPagado

-- 7.Hacer un procedimiento almacenado que permita dar de alta un nuevo curso. Debe recibir todos los valores necesarios para poder insertar un nuevo registro.

Create Or Alter Procedure  SP_NuevoCurso(
 @IDNivel TinyInt,
 @Nombre Varchar(100),
 @CostoCurso Money,
 @CostoCertificacion Money,
 @Estreno Date,
 @DebeSerMayorDeEdad Bit
)
As
Begin
	Insert Into Cursos (IDNivel, Nombre, Costocurso, CostoCertificacion, Estreno, DebeSerMayorDeEdad) Values(@IDNivel, @Nombre, @Costocurso, @CostoCertificacion, @Estreno, @DebeSerMayorDeEdad)
End

Exec SP_NuevoCurso 2, 'Aprender SQL', 2000, 1500, '2024-03-03', 0

-- 8.Hacer un procedimiento almacenado que permita modificar porcentualmente el Costo de Cursada de todos los cursos. El procedimiento debe recibir un valor numérico que representa el valor a aumentar porcentualmente. Por ejemplo, si recibe un 60. Debe aumentar un 60% todos los costos.

Create Or Alter Procedure SP_CostoCursada(
@Aumento Int
)
As
Begin

	Update Cursos Set CostoCurso = CostoCurso * (1 + (@Aumento / 100.0));

End

Exec SP_CostoCursada 20

-- 9.Hacer un procedimiento almacenado llamado SP_PagarInscripcion que a partir de un IDInscripcion permita hacer un pago de la inscripción. El pago puede ser menor al costo de la inscripción o bien el total del mismo. El sistema no debe permitir que el usuario pueda abonar más dinero para una inscripción que el costo de la misma. Se debe registrar en la tabla de pagos con la información que corresponda.

Create Or Alter Procedure SP_PagarInscripcion(
@IDInscripcion Int,
@Monto Money
)
As
Begin

	Declare @CostoInscripcion Money
	Declare @MontoPago Money
	Declare @MontoRestante Money
	
	Select @CostoInscripcion = I.Costo From Inscripciones I Where I.ID = @IDInscripcion

	Select @MontoPago = P.Importe From Pagos P Where P.IDInscripcion = @IDInscripcion

	Set @MontoRestante = @CostoInscripcion - @MontoPago

	
	If @Monto > @MontoRestante
	Begin
		RAISERROR('El Monto sobrepasa el costo total de la inscripcion.', 16, 0)
		Return
	End

	Insert Pagos (IDInscripcion, Fecha, Importe) Values (@IDInscripcion, GetDate(), @Monto)

End

Exec SP_PagarInscripcion 31, 2000

-- 10.Hacer un procedimiento almacenado llamado SP_InscribirUsuario que reciba un IDUsuario y un IDCurso y realice la inscripción a dicho curso de ese usuario. El procedimiento debe realizar las siguientes comprobaciones:
-- El usuario no debe registrar deuda para poder inscribirse.
-- El usuario debe ser mayor de edad si el curso requiere esa condición.
-- En caso que estas comprobaciones sean satisfechas entonces registrar la inscripción. Determinar el costo de la inscripción al valor actual del curso. Si alguna comprobación no se cumple, indicarlo con un mensaje de error correspondiente.

Create Or Alter Procedure SP_InscribiUsuario(
@IDUsuario Int,
@IDCurso Int
)
As
Begin

	Declare @Deuda Money
	Declare @Edad Int
	Declare @CostoCurso Money
	Declare @DebeSerMayor Bit

	Set @Deuda = dbo.FN_DeudaxUsuario(@IDUsuario)

	Set @Edad = dbo.FN_CalcularEdad(@IDUsuario)

	Select @CostoCurso = C.CostoCurso From Cursos C Where C.ID = @IDCurso

	Select @DebeSerMayor = C.DebeSerMayorDeEdad From Cursos C Where C.ID = @IDCurso

	If @Deuda != 0 Begin
	Raiserror('El usuario presenta deuda vigente.', 16, 0)
	Return
	End

	If @DebeSerMayor = 1 Begin

			If @Edad >= 18 Begin
				
				Insert Into Inscripciones (IDUsuario, IDCurso, Costo) Values (@IDUsuario, @IDCurso, @CostoCurso)
				Return
			End
			Else Begin
			Raiserror('El usuario es menor a 18 años.', 16, 0)
			Return
			End
	End

	Insert Into Inscripciones (IDUsuario, IDCurso, Costo) Values (@IDUsuario, @IDCurso, @CostoCurso)
End

Exec SP_InscribiUsuario 23, 8
