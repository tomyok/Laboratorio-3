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
Begin

	Select

End
