Imports System.Web.UI.WebControls
Imports System.Xml

Public Class Registro
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            If (User.Identity.IsAuthenticated) Then
                Llenar_Grid()
            End If
        End If
    End Sub

#Region "Manejo de Datos"

    Private Sub Llenar_Grid()
        Dim SQLConexionBD As New SQLConexionBD()
        Dim dtBiometrico As New DataTable
        Dim dtEmpleado As New DataTable
        Dim dsTablas As New DataSet
        Dim dsEmpleados As New DataSet

        Dim user As String
        If (Request.Cookies("Usuario") IsNot Nothing) Then
            If (Request.Cookies("Usuario")("CodEmp") IsNot Nothing) Then
                user = Request.Cookies("Usuario")("CodEmp")
            Else
                Exit Sub
            End If
        Else
            Exit Sub
        End If

        dsTablas = SQLConexionBD.RecuperarDatosBiometricoPorUsuario(user)
        If dsTablas Is Nothing Then
            Exit Sub
        End If
        dtBiometrico = dsTablas.Tables(0)

        'Datos del empleado
        dsEmpleados = SQLConexionBD.RecuperarDatosEmpleado(user)
        If dsEmpleados Is Nothing Then
            Exit Sub
        End If
        dtEmpleado = dsEmpleados.Tables(0)
        DatosEmpleado(dtEmpleado)

        Session("dtBiometrico") = dtBiometrico
        BindDataGrid()
        Totales()
    End Sub

    Private Sub DatosEmpleado(ByVal dtEmpleado As DataTable)
        If dtEmpleado.Rows(0)("Aprobado") = "1" Then
            lblAprobado.Visible = True
        Else
            lblAprobado.Visible = False
        End If

        Master.usuario = Context.User.Identity.Name
        Master.codigo = dtEmpleado.Rows(0)("CodigoEmp")
        Master.area = dtEmpleado.Rows(0)("Area")
        Master.areaId = dtEmpleado.Rows(0)("AreaId")
        Master.Dep = dtEmpleado.Rows(0)("Departamento")
        Master.DepId = dtEmpleado.Rows(0)("DepartamentoId")
        Master.Año = dtEmpleado.Rows(0)("Anio")
        Master.Periodo = dtEmpleado.Rows(0)("Periodo")
        Master.Inicio = dtEmpleado.Rows(0)("FechaInicial")
        Master.Fin = dtEmpleado.Rows(0)("FechaFinal")
        Master.Cargo = dtEmpleado.Rows(0)("Cargo")
        Master.CargoId = dtEmpleado.Rows(0)("CargoId")

        Dim adAuth As LdapAuthentication = New LdapAuthentication("")
        Master.procesar = adAuth.MenuProcesar(Master.areaId, Master.DepId, Master.CargoId)
        Master.sesionIni = True

        CompFechaIni.ValueToCompare = Master.Inicio
        ComFechFin.ValueToCompare = Master.Fin
    End Sub

    Private Function GrabarRegistros(ByVal rows As DataRow) As Integer
        Dim SQLConexionBD As New SQLConexionBD()
        Dim HorasExtrasId As Integer
        Dim infoXlm As String = infoXML(rows)
        HorasExtrasId = SQLConexionBD.GrabarRegisto(Context.User.Identity.Name, infoXlm)
        Return HorasExtrasId
    End Function

    Private Function EliminarRegistros(ByVal rows As DataRow) As Integer
        Dim SQLConexionBD As New SQLConexionBD()
        Dim Resultados As Integer
        Dim infoXlm As String = infoXML(rows)
        Resultados = SQLConexionBD.EliminarRegistro(Context.User.Identity.Name, infoXlm)
        Return Resultados
    End Function

    Private Sub BindDataGrid()
        gvBiometrico.DataSource = Session("dtBiometrico")
        gvBiometrico.DataBind()
    End Sub

    Public Function infoXML(ByVal row As DataRow) As String
        Dim cadenaXML As String = String.Empty

        cadenaXML &= "<HOREXT "
        cadenaXML &= "CODEMP=""" & Master.codigo & """ "
        Dim fecha As Date = row.Item("Fecha")
        cadenaXML &= "FECHAM=""" & fecha.ToString("yyyy-MM-dd") & """ "
        Dim ingreso As DateTime = row.Item("Ingreso")
        cadenaXML &= "INGRES=""" & ingreso.ToString("HH:mm") & """ "
        Dim salida As DateTime = row.Item("Salida")
        cadenaXML &= "SALIDA=""" & salida.ToString("HH:mm") & """ "
        Dim laborado As DateTime = row.Item("Laborado")
        cadenaXML &= "LABORA=""" & laborado.ToString("HH:mm") & """ "
        Dim atrasado As DateTime = row.Item("Atrasado")
        cadenaXML &= "ATRASA=""" & atrasado.ToString("HH:mm") & """ "
        Dim anticipado As DateTime = row.Item("Anticipado")
        cadenaXML &= "ANTICI=""" & anticipado.ToString("HH:mm") & """ "
        Dim hora0 As DateTime = row.Item("Horas0")
        cadenaXML &= "HORA00=""" & hora0.ToString("HH:mm") & """ "
        Dim hora50 As DateTime = row.Item("Horas50")
        cadenaXML &= "HORA50=""" & hora50.ToString("HH:mm") & """ "
        Dim hora100 As DateTime = row.Item("Horas100")
        cadenaXML &= "HOR100=""" & hora100.ToString("HH:mm") & """ "
        Dim horaPermiso As DateTime = row.Item("HorasPermiso")
        cadenaXML &= "HORPER=""" & horaPermiso.ToString("HH:mm") & """ "
        Dim horaRecuperar As DateTime = row.Item("HorasRecuperar")
        cadenaXML &= "HORREC=""" & horaRecuperar.ToString("HH:mm") & """ "
        cadenaXML &= "JUSTIF=""" & row.Item("Justificativo").ToString & """ "
        cadenaXML &= "ANIOPE=""" & Master.Año & """ "
        cadenaXML &= "PERIOD=""" & Master.Periodo & """ "
        cadenaXML &= "HOREXT=""" & row.Item("HorasExtrasId").ToString & """ "
        cadenaXML &= "ACTIVO=""" & row.Item("Activo") & """ "
        cadenaXML &= "BIOMET=""" & row.Item("Biometrico") & """ "
        cadenaXML &= " /> "

        Return cadenaXML
    End Function

    Private Function ValidarFechaHora(ByVal fecha As Date, ByVal inicio As DateTime) As Boolean
        Dim result As Boolean = False
        Dim SiFecha As Boolean = False
        For Each row As GridViewRow In gvBiometrico.Rows
            Dim lblFecha As Label = (CType(row.FindControl("lblFecha"), Label))
            'Se compara la fecha de ingreso con todas las fechas del grid
            If fecha = Convert.ToDateTime(lblFecha.Text) Then
                SiFecha = True 'La fecha es la misma que alguno del grid
                'Se compara el inicio con todos los rangos de inicio y fin del grid
                Dim lblInicio As Label = (CType(row.FindControl("HoraIng"), Label))
                Dim lblFin As Label = (CType(row.FindControl("HoraSal"), Label))
                Dim dateInicio As DateTime = fecha.ToShortDateString + " " + lblInicio.Text
                Dim dateFin As DateTime = fecha.ToShortDateString + " " + lblFin.Text
                If inicio > dateInicio And inicio < dateFin Then
                    result = False 'Se encuentra dentro del rango
                    lblError.Text = "Fecha y hora ya se encuentran en el grid"
                    lblError.Visible = True
                    divError.Visible = True
                    Exit For
                Else
                    result = True 'Está fuera del rango
                End If
            End If
        Next
        If SiFecha = False Then 'No hay fecha repetida
            result = True
        End If
        Return result
    End Function

    Private Sub Totales()
        Dim dtBiometrico As DataTable = Session("dtBiometrico")
        If dtBiometrico.Rows.Count > 0 Then
            Dim horLab, horAtr, horAnt, horPer, horRec, hor000, hor050, hor100 As Integer
            Dim minLab, minAtr, minAnt, minPer, minRec, min000, min050, min100 As Integer
            For Each row As DataRow In dtBiometrico.Rows
                horLab = horLab + Convert.ToDateTime(row("Laborado")).Hour
                minLab = minLab + Convert.ToDateTime(row("Laborado")).Minute
                horAtr = horAtr + Convert.ToDateTime(row("Atrasado")).Hour
                minAtr = minAtr + Convert.ToDateTime(row("Atrasado")).Minute
                horAnt = horAnt + Convert.ToDateTime(row("Anticipado")).Hour
                minAnt = minAnt + Convert.ToDateTime(row("Anticipado")).Minute
                horPer = horPer + Convert.ToDateTime(row("HorasPermiso")).Hour
                minPer = minPer + Convert.ToDateTime(row("HorasPermiso")).Minute
                horRec = horRec + Convert.ToDateTime(row("HorasRecuperar")).Hour
                minRec = minRec + Convert.ToDateTime(row("HorasRecuperar")).Minute
                hor000 = hor000 + Convert.ToDateTime(row("Horas0")).Hour
                min000 = min000 + Convert.ToDateTime(row("Horas0")).Minute
                hor050 = hor050 + Convert.ToDateTime(row("Horas50")).Hour
                min050 = min050 + Convert.ToDateTime(row("Horas50")).Minute
                hor100 = hor100 + Convert.ToDateTime(row("Horas100")).Hour
                min100 = min100 + Convert.ToDateTime(row("Horas100")).Minute
            Next

            'gvBiometrico.FooterRow.Cells(6).Text = String.Format("{0}:{1}", horLab + Fix(minLab / 60), minLab Mod 60)
            'gvBiometrico.FooterRow.Cells(7).Text = String.Format("{0}:{1}", horAtr + Fix(minAtr / 60), minAtr Mod 60)
            'gvBiometrico.FooterRow.Cells(8).Text = String.Format("{0}:{1}", horAnt + Fix(minAnt / 60), minAnt Mod 60)
            gvBiometrico.FooterRow.Cells(9).Text = String.Format("{0}:{1}", horPer + Fix(minPer / 60), minPer Mod 60)
            gvBiometrico.FooterRow.Cells(10).Text = String.Format("{0}:{1}", horRec + Fix(minRec / 60), minRec Mod 60)
            'gvBiometrico.FooterRow.Cells(11).Text = String.Format("{0}:{1}", hor000 + Fix(min000 / 60), min000 Mod 60)
            gvBiometrico.FooterRow.Cells(12).Text = String.Format("{0}:{1}", hor050 + Fix(min050 / 60), min050 Mod 60)
            gvBiometrico.FooterRow.Cells(13).Text = String.Format("{0}:{1}", hor100 + Fix(min100 / 60), min100 Mod 60)

            SumTotal(min050, minPer, hor050, horPer, min100, minRec, hor100, horRec)
        End If
    End Sub

    Private Sub SumTotal(ByVal min050 As Integer, ByVal minPer As Integer, ByVal hor050 As Integer, ByVal horPer As Integer,
                         ByVal min100 As Integer, ByVal minRec As Integer, ByVal hor100 As Integer, ByVal horRec As Integer)
        Dim horTot050, horTot100 As Integer
        Dim minTot050, minTot100 As Integer

        If min050 >= minPer Then
            horTot050 = hor050 - horPer
            minTot050 = min050 - minPer
        Else
            horTot050 = hor050 - horPer - 1
            'minTot050 = ((min050 - (minPer + 60)) + 60) * (-1)
            minTot050 = (minPer - (min050 + 60)) * (-1)
        End If
        If min100 >= minRec Then
            horTot100 = hor100 - horRec
            minTot100 = min100 - minRec
        Else
            horTot100 = hor100 - horRec - 1
            'minTot100 = ((min100 - (minRec + 60)) + 60) * (-1)
            minTot100 = (minRec - (min100 + 60)) * (-1)
        End If

        Dim row As New GridViewRow(0, 0, DataControlRowType.Footer, DataControlRowState.Normal)
        Dim cel0, cel050, cel100 As New TableCell()
        cel0.Text = "Total de Horas a pagar"
        cel0.ColumnSpan = 8
        cel0.HorizontalAlign = HorizontalAlign.Right
        cel050.Text = String.Format("{0}:{1}", horTot050 + Fix(minTot050 / 60), minTot050 Mod 60)
        cel100.Text = String.Format("{0}:{1}", horTot100 + Fix(minTot100 / 60), minTot100 Mod 60)
        row.Cells.Add(cel0)
        row.Cells.Add(cel050)
        row.Cells.Add(cel100)
        gvBiometrico.Controls(0).Controls.Add(row)
    End Sub

#End Region

#Region "Eventos del GridView"

    Protected Sub GridView_RowEditing(ByVal sender As Object, ByVal e As GridViewEditEventArgs)
        'Set the edit index.
        gvBiometrico.EditIndex = e.NewEditIndex

        'Bind data to the GridView control.
        BindDataGrid()

        Dim row = gvBiometrico.Rows(e.NewEditIndex)
        Dim HorasExtrasId, Dia As String
        HorasExtrasId = (CType(row.FindControl("HorasExtrasId"), Label)).Text
        Dia = (CType(row.FindControl("Dia"), Label)).Text
        Dim Ingreso As Label = CType(row.FindControl("HoraIng"), Label)
        Dim Salida As Label = CType(row.FindControl("HoraSal"), Label)
        Dim Horas50 As Label = CType(row.FindControl("Horas50"), Label)
        Dim Horas100 As Label = CType(row.FindControl("Horas100"), Label)

        'Cambios por si es un nuevo registro
        If Dia = "" Then 'Es nuevo
            Ingreso.Enabled = True
            Salida.Enabled = True
            Horas50.Enabled = False
            Horas100.Enabled = False
        Else 'Es del biometrico
            Ingreso.Enabled = False
            Salida.Enabled = False
            Horas50.Enabled = False
            Horas100.Enabled = False
        End If

    End Sub

    Protected Sub GridView_RowCancelingEdit()
        'Reset the edit index.
        gvBiometrico.EditIndex = -1
        'Bind data to the GridView control.
        BindDataGrid()
        Llenar_Grid()
    End Sub

    Protected Sub GridView_RowDeleting(ByVal sender As Object, ByVal e As GridViewDeleteEventArgs)
        Dim DTable As New DataTable("dtBiometrico")
        DTable = Session("dtBiometrico")
        DTable.Rows(e.RowIndex)("Activo") = False
        Dim rows As DataRow = DTable.Rows(e.RowIndex)
        Dim horasExtrasId As Integer = DTable.Rows(e.RowIndex)("HorasExtrasId")
        Dim Resultado As Integer
        If horasExtrasId = 0 Then 'Es nuevo
            Resultado = GrabarRegistros(rows)
        Else
            Resultado = EliminarRegistros(rows)
        End If
        DTable.Rows(e.RowIndex).Delete()
        Session("dtBiometrico") = DTable
        BindDataGrid()
        Llenar_Grid()
    End Sub

    Protected Sub GridView_RowUpdating(ByVal sender As Object, ByVal e As GridViewUpdateEventArgs)
        Dim dt As DataTable = CType(Session("dtBiometrico"), DataTable)
        Dim row As GridViewRow = gvBiometrico.Rows(e.RowIndex)
        Dim drow As DataRow = dt.Rows(row.DataItemIndex)

        Dim horaIngreso As DateTime = Convert.ToDateTime((CType(row.FindControl("HoraIng"), Label)).Text)
        drow("Ingreso") = horaIngreso.ToShortTimeString
        Dim horaSalida As DateTime = Convert.ToDateTime((CType(row.FindControl("HoraSal"), Label)).Text)
        drow("Salida") = horaSalida.ToShortTimeString

        Dim Dia As String = (CType(row.FindControl("Dia"), Label)).Text

        drow("Justificativo") = (CType(row.FindControl("Justificativo"), TextBox)).Text

        Dim fecha As Date = dt.Rows(row.DataItemIndex)("Fecha")

        'La fecha no está en el rango
        If fecha < Master.Inicio Or fecha > Master.Fin Then
            Response.Write("La fecha no está dentro del rango")
            Exit Sub
        End If

        CalculoHoras(drow)

        'Grabando el registro en la BD
        Dim HorasExtrasId As Integer = GrabarRegistros(drow)
        drow("HorasExtrasId") = HorasExtrasId

        'Reset the edit index.
        gvBiometrico.EditIndex = -1

        'Bind data to the GridView control.
        BindDataGrid()
        Llenar_Grid()
    End Sub

    Protected Sub BtnAdd_Click(sender As Object, e As EventArgs) Handles BtnAdd.Click
        MostrarNewRegistro()
    End Sub

    Private Sub MostrarNewRegistro()
        NewReg2.Visible = True
        BtnAdd.Enabled = False
    End Sub

    Protected Sub btnDeshacer_Click(sender As Object, e As ImageClickEventArgs) Handles btnDeshacer.Click
        LimpiarNew()
    End Sub

    Private Sub LimpiarNew()
        NewReg2.Visible = False
        FechaTxt.Text = Nothing
        IngresoTxt.Text = Nothing
        SalidaTxt.Text = Nothing
        DetalleTxt.Text = Nothing
        Permisotxt.Text = Nothing
        RecuperarTxt.Text = Nothing
        BtnAdd.Enabled = True
        lblError.Text = Nothing
        lblError.Visible = False
        divError.Visible = False
    End Sub

    Protected Sub btnAgregar_Click(sender As Object, e As ImageClickEventArgs) Handles btnAgregar.Click
        If Validaciones() = False Then
            Exit Sub
        End If

        Dim fecha As Date = FechaTxt.Text
        Dim ingreso As DateTime = FechaTxt.Text + " " + IngresoTxt.Text
        lblExisteFecha.Visible = False
        If ValidarFechaHora(fecha, ingreso) = False Then
            lblExisteFecha.Visible = True
            Exit Sub
        End If

        Dim dt As DataTable = Session("dtBiometrico")
        Dim row As DataRow = dt.NewRow()

        row("CodigoEmp") = 0
        row("Dia") = ""
        row("Fecha") = FechaTxt.Text
        If String.IsNullOrEmpty(IngresoTxt.Text) Then IngresoTxt.Text = "00:00"
        row("Ingreso") = IngresoTxt.Text
        If String.IsNullOrEmpty(SalidaTxt.Text) Then SalidaTxt.Text = "00:00"
        row("Salida") = SalidaTxt.Text
        row("Laborado") = "00:00"
        row("Atrasado") = "00:00"
        row("Anticipado") = "00:00"
        row("Horas0") = "00:00"
        row("Horas50") = "00:00"
        row("Horas100") = "00:00"
        If String.IsNullOrEmpty(Permisotxt.Text) Then Permisotxt.Text = "00:00"
        row("HorasPermiso") = Permisotxt.Text
        If String.IsNullOrEmpty(RecuperarTxt.Text) Then RecuperarTxt.Text = "00:00"
        row("HorasRecuperar") = RecuperarTxt.Text
        row("Justificativo") = DetalleTxt.Text
        row("Anio") = Master.Año
        row("Periodo") = Master.Periodo
        row("Biometrico") = False

        If CalculoHoras(row) = False Then Exit Sub

        'Grabando el registro en la BD
        Dim HorasExtrasId As Integer = GrabarRegistros(row)

        row("HorasExtrasId") = HorasExtrasId

        dt.Rows.Add(row)

        Session("dtBiometrico") = dt
        BindDataGrid()

        LimpiarNew()
        Llenar_Grid()
    End Sub

    Private Function Validaciones() As Boolean
        Dim resultado As Boolean = False

        If IngresoTxt.Text <> "" And SalidaTxt.Text <> "" Then
            'Valida si lo ingresado es una hora correcta (mm:ss)
            If IsDate(IngresoTxt.Text) = False Then
                Return False
            End If
            If IsDate(SalidaTxt.Text) = False Then
                Return False
            End If

            Dim ingreso As DateTime = FechaTxt.Text + " " + IngresoTxt.Text
            Dim salida As DateTime = FechaTxt.Text + " " + SalidaTxt.Text

            'La hora de ingreso debe ser mayor que la hora de salida
            If ingreso > salida Then
                lblError.Text = "La hora de ingreso debe ser mayor que la hora de salida"
                lblError.Visible = True
                divError.Visible = True
                Return False
            End If

            resultado = True
        Else
            If IngresoTxt.Text = "" And SalidaTxt.Text = "" And (Permisotxt.Text <> "" Or RecuperarTxt.Text <> "") Then
                resultado = True
            Else
                lblError.Text = "Debe ingresar alguna hora"
                lblError.Visible = True
                divError.Visible = True
                resultado = False
            End If
        End If

        Return resultado
    End Function

    Private Function CalculoHoras(ByRef row As DataRow) As Boolean
        Dim resultado As Boolean = False

        Dim fecha As Date = row("Fecha")

        Dim horaIngreso As DateTime = row("Ingreso")
        Dim horaSalida As DateTime = row("Salida")

        Dim TiempoDiferencia As TimeSpan = horaSalida.Subtract(horaIngreso)
        Dim horasDifrencia As Integer = TiempoDiferencia.Hours
        Dim minutosDiferencia As Integer = TiempoDiferencia.Minutes
        Dim TotalDiferencia As String = horasDifrencia.ToString + ":" + minutosDiferencia.ToString
        Dim sobretiempo50 As Integer = horasDifrencia - 9 'OJO: Revisar 9 horas
        Dim thorOfi As TimeSpan = New TimeSpan(0, 9, 0, 0)
        Dim thorDiff As TimeSpan = TiempoDiferencia.Subtract(thorOfi)

        row("Laborado") = TotalDiferencia

        Dim diaDeLaSemana As Integer = Weekday(fecha)

        'Verifica si es 50% o 100%
        If diaDeLaSemana = 1 Or diaDeLaSemana = 7 Then 'Domingo=1 o Sabado=7 --> 100%
            row("Horas100") = TotalDiferencia
            resultado = True
        Else 'Lunes a Viernes
            Dim SQLConexionBD As New SQLConexionBD()
            Dim feriado As Boolean = SQLConexionBD.ValidarFeriados(fecha, Master.areaId)
            If feriado = True Then 'SI es feriado --> 100%
                row("Horas100") = TotalDiferencia
                resultado = True
            Else 'NO es feriado
                If thorDiff.TotalMinutes > 0 Then 'más de 9 horas de trabajo 50%
                    row("Horas50") = (sobretiempo50.ToString + ":" + minutosDiferencia.ToString)
                    resultado = True
                Else 'ingresa por la noche
                    Dim fechaIngreso As DateTime = fecha.ToShortDateString + " " + horaIngreso.ToShortTimeString
                    Dim fechaSalida As DateTime = fecha.ToShortDateString + " " + horaSalida.ToShortTimeString
                    Dim fechaIniHEN1 As DateTime = fecha.ToShortDateString + " 17:30"
                    Dim fechaFinHEN1 As DateTime = fecha.ToShortDateString + " 23:59"
                    Dim fechaIniHEN2 As DateTime = fecha.ToShortDateString + " 00:00"
                    Dim fechaFinHEN2 As DateTime = fecha.ToShortDateString + " 05:59"
                    If fechaIngreso >= fechaIniHEN1 And fechaSalida <= fechaFinHEN1 Then 'Entre las 17:30-23:50 = 50%
                        row("Horas50") = TotalDiferencia
                        resultado = True
                    Else
                        If fechaIngreso >= fechaIniHEN2 And fechaSalida <= fechaFinHEN2 Then 'Entre las 00:00-05:50 = 100%
                            row("Horas100") = TotalDiferencia
                            resultado = True
                        Else
                            lblError.Text = "Separe las horas del 50% y 100% en dos registros diferentes"
                            lblError.Visible = True
                            divError.Visible = True
                            resultado = False
                        End If
                    End If
                End If
            End If
        End If

        row("Activo") = True
        Return resultado
    End Function

    Protected Sub GridView_RowDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            'Desaparece botones si esta aprobado
            Dim imgEdit As ImageButton = TryCast(e.Row.Cells(1).Controls(1), ImageButton)
            Dim imgDelete As ImageButton = TryCast(e.Row.Cells(1).Controls(3), ImageButton)
            If lblAprobado.Visible = True Then 'SI Aprobado
                imgEdit.Visible = False
                imgDelete.Visible = False
                BtnAdd.Visible = False
            Else 'NO Aprobado
                imgEdit.Visible = True
                imgDelete.Visible = True
                BtnAdd.Visible = True
            End If
            'Cambia de color la fila si no es del biometrico (ingreso manual)
            Dim lblBio As Label = TryCast(e.Row.Cells(19).Controls(1), Label)
            If lblBio.Text = "0" Then
                e.Row.BackColor = System.Drawing.Color.LightBlue
            End If
        End If
    End Sub

    Protected Sub btnPrint_Click(sender As Object, e As ImageClickEventArgs) Handles btnPrint.Click
        Response.Redirect("~/Wui/ImprimirRegistro.aspx")
    End Sub

#End Region

End Class