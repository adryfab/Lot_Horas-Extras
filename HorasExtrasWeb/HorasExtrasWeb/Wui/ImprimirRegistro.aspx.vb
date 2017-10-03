Public Class ImprimirRegistro
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Primero el procedimiento que llene el grid
        LlenarGrid()

        'Ahora si, ¡a imprimir la página!
        With Response
            .Write("<script>")
            .Write("print()")
            .Write("</script>")
        End With

    End Sub

    Private Sub LlenarGrid()
        Dim SQLConexionBD As New SQLConexionBD()
        Dim dsTablas As New DataSet
        Dim dtFechas As New DataTable
        Dim dtEmpleado As New DataTable
        Dim dtSuple50 As New DataTable
        Dim dtExtra100 As New DataTable
        Dim dtJefes As New DataTable
        Dim dtTotal50 As New DataTable
        Dim dtTotal100 As New DataTable

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

        dsTablas = SQLConexionBD.RecuperarImprimir(user)
        dtFechas = dsTablas.Tables(0)
        dtEmpleado = dsTablas.Tables(1)
        dtSuple50 = dsTablas.Tables(2)
        dtExtra100 = dsTablas.Tables(3)
        dtJefes = dsTablas.Tables(4)
        dtTotal50 = dsTablas.Tables(5)
        dtTotal100 = dsTablas.Tables(6)

        Session("dtFechas") = dtFechas
        Session("dtEmpleado") = dtEmpleado
        Session("dtSuple50") = dtSuple50
        Session("dtExtra100") = dtExtra100
        Session("dtJefes") = dtJefes
        Session("dtTotal50") = dtTotal50
        Session("dtTotal100") = dtTotal100

        BindDataGrid()
        Cabecera()
        Totales()
    End Sub

    Private Sub BindDataGrid()
        gvBiometrico50.DataSource = Session("dtSuple50")
        gvBiometrico50.DataBind()
        gvBiometrico100.DataSource = Session("dtExtra100")
        gvBiometrico100.DataBind()
    End Sub

    Private Sub Cabecera()
        Dim dtFechas As DataTable = Session("dtFechas")
        Dim fechaInicial As Date = dtFechas.Rows(0).Item("FechaInicial").ToString
        Dim fechaFinal As Date = dtFechas.Rows(0).Item("FechaFinal").ToString
        lblPeriodo.Text = fechaInicial.ToString("dd-MM-yyyy") + " A " + fechaFinal.ToString("dd-MM-yyyy")

        Dim dtEmpleado As DataTable = Session("dtEmpleado")
        lblColaborador.Text = dtEmpleado.Rows(0).Item("COLABORADOR").ToString
        lblCargo.Text = dtEmpleado.Rows(0).Item("CARGO").ToString
        lblLocalidad.Text = dtEmpleado.Rows(0).Item("LOCALIDAD").ToString
        lblDepartamento.Text = dtEmpleado.Rows(0).Item("DPTO").ToString

        Dim dtJefes As DataTable = Session("dtJefes")
        lblSolicitante.Text = dtJefes.Rows(0).Item("COLABORADOR").ToString
        lblSupervisor.Text = dtJefes.Rows(0).Item("SUPERVISOR").ToString
        lblJefe.Text = dtJefes.Rows(0).Item("JEFE").ToString
    End Sub

    Private Sub Totales()
        Dim dtTotal50 As DataTable = Session("dtTotal50")
        Dim dtSuple50 As DataTable = Session("dtSuple50")
        If dtSuple50.Rows.Count > 0 Then
            Dim horLab, horAtr, horAnt, horPer, horRec, hor000, hor050, hor100 As Integer
            Dim minLab, minAtr, minAnt, minPer, minRec, min000, min050, min100 As Integer
            For Each row As DataRow In dtSuple50.Rows
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
            gvBiometrico50.FooterRow.Cells(0).Text = "Total de Horas al 50% al mes a pagar"
            gvBiometrico50.FooterRow.Cells(0).HorizontalAlign = HorizontalAlign.Right
            gvBiometrico50.FooterRow.Cells(0).ColumnSpan = 5
            'gvBiometrico50.FooterRow.Cells(1).Text = dtTotal50.Rows(0).Item("TotalHoras50").ToString
            gvBiometrico50.FooterRow.Cells(2).Visible = False
            gvBiometrico50.FooterRow.Cells(3).Visible = False
            gvBiometrico50.FooterRow.Cells(4).Visible = False
            gvBiometrico50.FooterRow.Cells(5).Visible = False
            gvBiometrico50.FooterRow.Cells(6).Visible = False

            'gvBiometrico50.FooterRow.Cells(9).Text = String.Format("{0}:{1}", horPer + Fix(minPer / 60), minPer Mod 60)
            'gvBiometrico50.FooterRow.Cells(10).Text = String.Format("{0}:{1}", horRec + Fix(minRec / 60), minRec Mod 60)
            'gvBiometrico50.FooterRow.Cells(12).Text = String.Format("{0}:{1}", hor050 + Fix(min050 / 60), min050 Mod 60)
            'gvBiometrico50.FooterRow.Cells(13).Text = String.Format("{0}:{1}", hor100 + Fix(min100 / 60), min100 Mod 60)

            lblSuplementario.Visible = True
        Else
            lblSuplementario.Visible = False
        End If

        Dim dtTotal100 As DataTable = Session("dtTotal100")
        Dim dtExtra100 As DataTable = Session("dtExtra100")
        If dtExtra100.Rows.Count > 0 Then
            gvBiometrico100.FooterRow.Cells(0).Text = "Total de Horas al 100% al mes a pagar"
            gvBiometrico100.FooterRow.Cells(0).HorizontalAlign = HorizontalAlign.Right
            gvBiometrico100.FooterRow.Cells(0).ColumnSpan = 5
            gvBiometrico100.FooterRow.Cells(1).Text = dtTotal100.Rows(0).Item("TotalHoras100").ToString
            gvBiometrico100.FooterRow.Cells(2).Visible = False
            gvBiometrico100.FooterRow.Cells(3).Visible = False
            gvBiometrico100.FooterRow.Cells(4).Visible = False
            gvBiometrico100.FooterRow.Cells(5).Visible = False
            gvBiometrico100.FooterRow.Cells(6).Visible = False
            lblExtra.Visible = True
        Else
            lblExtra.Visible = False
        End If
    End Sub

End Class