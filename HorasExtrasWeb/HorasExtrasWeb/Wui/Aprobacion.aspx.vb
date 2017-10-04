Public Class Aprobacion
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
        Dim dtEmpleado As New DataTable
        Dim dsTablas As New DataSet
        Dim dtAprobaciones As New DataTable
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

        'Datos del empleado
        dsEmpleados = SQLConexionBD.RecuperarDatosEmpleado(user)
        If dsEmpleados Is Nothing Then
            Exit Sub
        End If
        dtEmpleado = dsEmpleados.Tables(0)
        DatosEmpleado(dtEmpleado)

        dsTablas = SQLConexionBD.RecuperarAprobaciones(user)
        dtAprobaciones = dsTablas.Tables(0)
        If dsTablas.Tables.Count = 1 Then
            Exit Sub
        End If
        Session("dtAprobaciones") = dtAprobaciones
        BindDataGrid()
    End Sub

    Private Sub DatosEmpleado(ByVal dtEmpleado As DataTable)
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
    End Sub

    Private Sub BindDataGrid()
        gvAprobar.DataSource = Session("dtAprobaciones")
        gvAprobar.DataBind()
    End Sub

    Protected Sub OnConfirm(ByVal sender As Object, ByVal e As EventArgs)
        Dim confirmValue As String = Request.Form("confirm_value")
        If confirmValue = "Si" Then
            'Get the button that raised the event
            Dim btn As ImageButton = DirectCast(sender, ImageButton)

            'Get the row that contains this button
            Dim row As GridViewRow = DirectCast(btn.NamingContainer, GridViewRow)

            Dim dt As DataTable = CType(Session("dtAprobaciones"), DataTable)
            Dim rows As DataRow = dt.Rows(row.DataItemIndex)

            If btn.ID = "ButtonAprobar" Then
                'Validar Si están todos los registros justificados
                Dim SQLConexionBD As New SQLConexionBD()
                If SQLConexionBD.ValidarJustificacion(rows.Item("NOMINA_ID")) = False Then
                    'Mostrar mensaje
                    id01.Visible = True
                    id01.Style.Item("display") = "block"
                    Exit Sub
                Else
                    id01.Visible = False
                    id01.Style.Item("display") = "none"
                End If

                If rows.Item("SUPERVISOR") = "True" Then
                    'rows.Item("UsuarioSuper") = lblUsuario.Text
                    rows.Item("UsuarioSuper") = Master.usuario
                    rows.Item("FechaSuper") = DateTime.Now.ToShortDateString
                Else
                    'rows.Item("UsuarioJefe") = lblUsuario.Text
                    rows.Item("UsuarioJefe") = Master.usuario
                    rows.Item("FechaJefe") = DateTime.Now.ToShortDateString
                End If
            ElseIf btn.ID = "ButtonRechazar" Then
                If rows.Item("SUPERVISOR") = "True" Then
                    rows.Item("UsuarioSuper") = ""
                    rows.Item("FechaSuper") = System.DBNull.Value
                Else
                    rows.Item("UsuarioJefe") = ""
                    rows.Item("FechaJefe") = System.DBNull.Value
                End If
            End If

            If GrabarRegistros(rows) = 1 Then 'OK
                Llenar_Grid()
            End If
        End If
    End Sub

    Private Function GrabarRegistros(ByVal rows As DataRow) As Integer
        Dim SQLConexionBD As New SQLConexionBD()
        Dim Resultados As Integer
        Dim infoXlm As String = infoXML(rows)
        Resultados = SQLConexionBD.GrabarAprobacion(infoXlm)
        Return Resultados
    End Function

    Public Function infoXML(ByVal row As DataRow) As String
        Dim cadenaXML As String = String.Empty

        cadenaXML &= "<APROBA "
        cadenaXML &= "CODEMP=""" & row.Item("NOMINA_ID").ToString & """ "
        'cadenaXML &= "ANIOPE=""" & lblAnio.Text & """ "
        cadenaXML &= "ANIOPE=""" & Master.Año & """ "
        'cadenaXML &= "PERIOD=""" & lblPeriodo.Text & """ "
        cadenaXML &= "PERIOD=""" & Master.Periodo & """ "
        cadenaXML &= "HORA50=""" & row.Item("SUPLEMENTARIAS").ToString & """ "
        cadenaXML &= "HOR100=""" & row.Item("EXTRAORDINARIAS").ToString & """ "
        cadenaXML &= "SUPERV=""" & row.Item("SUPERVISOR").ToString & """ "
        'cadenaXML &= "USUARI=""" & lblUsuario.Text & """ "
        cadenaXML &= "USUARI=""" & Master.usuario & """ "
        cadenaXML &= "USUSUP=""" & row.Item("UsuarioSuper").ToString & """ "
        If row.Item("FechaSuper") IsNot System.DBNull.Value Then
            Dim fechaSuper As Date = row.Item("FechaSuper")
            cadenaXML &= "FECSUP=""" & fechaSuper.ToString("yyyy-MM-dd") & """ "
        Else
            cadenaXML &= "FECSUP=""" & row.Item("FechaSuper").ToString & """ "
        End If
        cadenaXML &= "USUJEF=""" & row.Item("UsuarioJefe").ToString & """ "
        If row.Item("FechaJefe") IsNot System.DBNull.Value Then
            Dim fechaJefe As Date = row.Item("FechaJefe")
            cadenaXML &= "FECJEF=""" & fechaJefe.ToString("yyyy-MM-dd") & """ "
        Else
            cadenaXML &= "FECJEF=""" & row.Item("FechaJefe").ToString & """ "
        End If
        cadenaXML &= " /> "

        Return cadenaXML
    End Function

    Private Sub Llenar_Grid_Detalle(ByVal index As Integer, ByVal user As String)
        Dim SQLConexionBD As New SQLConexionBD()
        Dim dtBiometrico As New DataTable
        Dim dsTablas As New DataSet

        dsTablas = SQLConexionBD.RecuperarDatosBiometricoPorUsuario(user)
        dtBiometrico = dsTablas.Tables(0)
        Session("dtBiometrico") = dtBiometrico
        BindDataGridDetalle(index)
    End Sub

    Private Sub BindDataGridDetalle(ByVal index As Integer)
        gvBiometrico.DataSource = Session("dtBiometrico")
        gvBiometrico.DataBind()
        'trmostrar.Visible = Not trmostrar.Visible
        id01.Visible = False
        id01.Style.Item("display") = "none"

        Dim imgButon As ImageButton = gvAprobar.Rows(index).FindControl("ButtonMas")
        Dim id As Label = gvAprobar.Rows(index).FindControl("NOMINA_ID")

        'Cambiando todos los iconos a plus
        For Each row As GridViewRow In gvAprobar.Rows
            Dim img As ImageButton = row.FindControl("ButtonMas")
            Dim lab As Label = row.FindControl("NOMINA_ID")
            If id.Text = lab.Text Then Continue For 'Siguiente registro
            img.ImageUrl = "../icons/plus.gif"
        Next

        If imgButon.ImageUrl = "../icons/plus.gif" Then
            imgButon.ImageUrl = "../icons/minus.gif"
            trmostrar.Visible = True
        Else
            imgButon.ImageUrl = "../icons/plus.gif"
            trmostrar.Visible = False
        End If
    End Sub

    Protected Shared Function FindControlRecursive(root As Control, ctrlID As [String]) As Control
        If root.ID = ctrlID Then
            Return root
        End If
        For Each ctrl As Control In root.Controls
            Dim foundControl As Control = FindControlRecursive(ctrl, ctrlID)
            If Not (foundControl Is Nothing) Then
                Return foundControl
            End If
        Next
        Return Nothing
    End Function

#End Region

#Region "Eventos del GridView"

    Protected Sub GridView_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName = "PlusMas" Then
            Dim rowIndex As Integer
            rowIndex = Integer.Parse(e.CommandArgument.ToString)
            Dim gvRow As GridViewRow = gvAprobar.Rows(rowIndex)
            Dim NOMINA_ID As Label = CType(gvRow.FindControl("NOMINA_ID"), Label)
            Llenar_Grid_Detalle(rowIndex, NOMINA_ID.Text)
        End If
    End Sub

    Protected Sub GridView_RowDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim imgAprobar As ImageButton = TryCast(e.Row.Cells(11).Controls(1), ImageButton)
            Dim imgRechazar As ImageButton = TryCast(e.Row.Cells(11).Controls(3), ImageButton)
            If DirectCast(e.Row.Cells(10).Controls(1), System.Web.UI.WebControls.Label).Text = "True" Then 'SUPERVISOR
                If DirectCast(e.Row.Cells(6).Controls(1), System.Web.UI.WebControls.Label).Text = "" Then 'UsuarioSuper
                    imgAprobar.Visible = True
                    imgRechazar.Visible = False
                Else
                    imgAprobar.Visible = False
                    imgRechazar.Visible = True
                End If
            End If
        End If
    End Sub

#End Region

End Class