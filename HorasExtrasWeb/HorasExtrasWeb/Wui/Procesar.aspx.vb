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

        dsTablas = SQLConexionBD.RecuperarProcesar()
        If dsTablas Is Nothing Then
            Exit Sub
        End If

        dtProcesar = dsTablas.Tables(0)
        Session("dtProcesar") = dtProcesar
    End Sub
#End Region
End Class