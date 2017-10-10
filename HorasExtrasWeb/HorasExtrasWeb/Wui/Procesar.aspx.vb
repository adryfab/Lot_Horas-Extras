Imports System.IO

Public Class Procesar
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
        Dim dsTablas As New DataSet
        Dim dtProcesar As New DataTable
        Dim dsEmpleados As New DataSet
        Dim dtEmpleados As New DataTable

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

        dsTablas = SQLConexionBD.RecuperarProcesar()
        If dsTablas Is Nothing Then
            Exit Sub
        End If
        dtProcesar = dsTablas.Tables(0)
        Session("dtProcesar") = dtProcesar
        BindDataGrid()

        'Datos del empleado
        dsEmpleados = SQLConexionBD.RecuperarDatosEmpleado(user)
        If dsEmpleados Is Nothing Then
            Exit Sub
        End If
        dtEmpleados = dsEmpleados.Tables(0)
        DatosEmpleados(dtEmpleados)
    End Sub

    Private Sub BindDataGrid()
        gvProcesar.DataSource = Session("dtProcesar")
        gvProcesar.DataBind()
    End Sub

    Private Sub DatosEmpleados(ByVal dtEmpleado As DataTable)
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

    Private Sub Limpiar()
        lblOk.Text = ""
        lblOk.Visible = False
        lblError.Text = ""
        lblError.Visible = False
    End Sub

    Protected Sub btnProcesar_Click(sender As Object, e As EventArgs) Handles btnProcesar.Click
        GenerarTotales()
    End Sub

    Private Sub GenerarTotales()
        Dim SQLConexionBD As New SQLConexionBD()
        Dim dsTotales As New DataSet
        Dim dtTotal050 As New DataTable
        Dim dtTotal100 As New DataTable

        dsTotales = SQLConexionBD.TotalesProcesar()
        If dsTotales Is Nothing Then
            Exit Sub
        End If
        dtTotal050 = dsTotales.Tables(0)
        dtTotal100 = dsTotales.Tables(1)

        GenerarArchivo(dtTotal050, dtTotal100)
    End Sub

    Private Sub GenerarArchivo(ByVal dt050 As DataTable, ByVal dt100 As DataTable)
        Dim file As System.IO.StreamWriter
        Dim tab As String = vbTab
        Try
            'Procesa 50%            
            Dim name050 As String = "Horas50%_" + Master.Año + "-" + Master.Periodo + ".txt"
            Dim path050 As String = "C:\Temp\"
            'Dim path050 As String = Request.PhysicalApplicationPath
            Dim namePath050 As String = path050 + name050

            If System.IO.File.Exists(path050) Then
                System.IO.File.Delete(path050)
            End If
            file = My.Computer.FileSystem.OpenTextFileWriter(namePath050, True)
            For Each row As DataRow In dt050.Rows
                file.WriteLine(row("Cedula") + tab + row("Cod") + tab + row("50"))
            Next
            file.Close()
            DownloadFile(namePath050, True)
            'Una vez descargado, se elimina
            If System.IO.File.Exists(path050) Then
                System.IO.File.Delete(path050)
            End If

            'Procesa 100%
            Dim path100 As String = "C:\Temp\Horas100%_" + Master.Año + "-" + Master.Periodo + ".txt"
            If System.IO.File.Exists(path100) Then
                System.IO.File.Delete(path100)
            End If
            file = My.Computer.FileSystem.OpenTextFileWriter(path100, True)
            'file.Flush()
            For Each row As DataRow In dt100.Rows
                file.WriteLine(row("Cedula") + tab + row("Cod") + tab + row("100"))
            Next
            file.Close()

            lblOk.Text = "Archivos procesados"
            lblOk.Visible = True
        Catch ex As Exception
            lblError.Text = ex.Message
            lblError.Visible = True
        End Try
    End Sub

    Private Sub DownloadFile(ByVal fname As String, ByVal forceDownload As Boolean)
        'Dim path As Path
        Dim fullpath = Path.GetFullPath(fname)
        Dim name = Path.GetFileName(fullpath)
        Dim ext = Path.GetExtension(fullpath)
        Dim type As String = ""

        If Not IsDBNull(ext) Then
            ext = LCase(ext)
        End If

        Select Case ext
            Case ".htm", ".html"
                type = "text/HTML"
            Case ".txt"
                type = "text/plain"
            Case ".doc", ".rtf"
                type = "Application/msword"
            Case ".csv", ".xls"
                type = "Application/x-msexcel"
            Case Else
                type = "text/plain"
        End Select

        If (forceDownload) Then
            Response.AppendHeader("content-disposition", "attachment; filename=" + name)
        End If
        If type <> "" Then
            Response.ContentType = type
        End If

        Response.WriteFile(fullpath)
        Response.End()
    End Sub

#End Region

End Class