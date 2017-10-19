Imports System.Configuration
Public Class Login
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        FormsAuthentication.SignOut()
        Session.Clear()
        Session.Abandon()
        Session.RemoveAll()
        Master.sesionIni = False
    End Sub

    Protected Sub Login_Click(sender As Object, e As EventArgs) Handles btnLogin.Click
        Dim adAuth As LdapAuthentication = New LdapAuthentication("LDAP://")
        Try
            Dim resultado As Boolean = adAuth.ValidarCredenciales(txtUsername.Text, txtPassword.Text, txtDomain.Text)

            If resultado = True Then
                Dim groups As String = txtDomain.Text

                'Create the ticket, and add the groups.
                Dim isCookiePersistent As Boolean = False
                Dim authTicket As FormsAuthenticationTicket = New FormsAuthenticationTicket(1,
                     txtUsername.Text, DateTime.Now, DateTime.Now.AddMinutes(1), isCookiePersistent, groups)

                'Encrypt the ticket.
                Dim encryptedTicket As String = FormsAuthentication.Encrypt(authTicket)

                'Create a cookie, and then add the encrypted ticket to the cookie as data.
                Dim authCookie As HttpCookie = New HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket)

                If (isCookiePersistent = True) Then
                    authCookie.Expires = authTicket.Expiration
                End If
                'Add the cookie to the outgoing cookies collection.
                Response.Cookies.Add(authCookie)

                'Cookie personal
                Response.Cookies("Usuario")("TxtEmp") = adAuth._Usuario
                Response.Cookies("Usuario")("CodEmp") = adAuth._CodEmp
                Response.Cookies("Usuario")("NomEmp") = adAuth._NomEmp
                Response.Cookies("Usuario").Expires = DateTime.Now.AddHours(1)

                'You can redirect now.
                Response.Redirect("~/Wui/Registro.aspx")
            Else
                errorLabel.Text = "La autenticación no tuvo éxito. Compruebe el nombre de usuario y la contraseña."
            End If

        Catch ex As Exception
            errorLabel.Text = "Error de autenticación. " & ex.Message
        End Try
    End Sub

    'Private Function CargarDatosBasicos() As Boolean
    '    Dim SQLConexionBD As New SQLConexionBD()
    '    Dim dtEmpleado As New DataTable
    '    Dim dsTablas As New DataSet
    '    Dim resultado As Boolean = False

    '    Dim user As String
    '    If (Request.Cookies("Usuario") IsNot Nothing) Then
    '        If (Request.Cookies("Usuario")("CodEmp") IsNot Nothing) Then
    '            user = Request.Cookies("Usuario")("CodEmp")
    '        Else
    '            Return False
    '        End If
    '    Else
    '        Return False
    '    End If

    '    dsTablas = SQLConexionBD.RecuperarDatosEmpleado(user)
    '    If dsTablas Is Nothing Then
    '        Return False
    '    End If
    '    dtEmpleado = dsTablas.Tables(0)
    '    'DatosEmpleado(dtEmpleado)
    '    resultado = True
    '    Return resultado
    'End Function

    'Private Sub DatosEmpleado(ByVal dtEmpleado As DataTable)
    '    Dim mpForm As System.Web.UI.HtmlControls.HtmlForm
    '    Dim lblUsuario, lblTxtUsuario, lblCodigo, lblTxtCodigo, lblAnio, lblTxtAnio, lblPeriodo, lblTxtPeriodo,
    '        lblInicio, lblTxtInicio, lblFin, lblTxtFin As Label
    '    mpForm = CType(Master.FindControl("form1"), HtmlForm)
    '    lblUsuario = CType(Master.FindControl("lblUsuario"), Label)
    '    If Not mpForm Is Nothing Then
    '        lblUsuario = CType(mpForm.FindControl("lblUsuario"), Label)
    '        If Not lblUsuario Is Nothing Then
    '            lblUsuario.Text = Context.User.Identity.Name
    '            lblUsuario.Visible = True
    '            lblTxtUsuario = CType(mpForm.FindControl("lblTxtUsuario"), Label)
    '            lblTxtUsuario.Visible = True
    '        End If
    '        lblCodigo = CType(mpForm.FindControl("lblCodigo"), Label)
    '        If Not lblCodigo Is Nothing Then
    '            lblCodigo.Text = dtEmpleado.Rows(0)("CodigoEmp")
    '            lblCodigo.Visible = True
    '            lblTxtCodigo = CType(mpForm.FindControl("lblTxtCodigo"), Label)
    '            lblTxtCodigo.Visible = True
    '        End If
    '        lblAnio = CType(mpForm.FindControl("lblAnio"), Label)
    '        If Not lblAnio Is Nothing Then
    '            lblAnio.Text = dtEmpleado.Rows(0)("Anio")
    '            lblAnio.Visible = True
    '            lblTxtAnio = CType(mpForm.FindControl("lblTxtAnio"), Label)
    '            lblTxtAnio.Visible = True
    '        End If
    '        lblPeriodo = CType(mpForm.FindControl("lblPeriodo"), Label)
    '        If Not lblPeriodo Is Nothing Then
    '            lblPeriodo.Text = dtEmpleado.Rows(0)("Periodo")
    '            lblPeriodo.Visible = True
    '            lblTxtPeriodo = CType(mpForm.FindControl("lblTxtPeriodo"), Label)
    '            lblTxtPeriodo.Visible = True
    '        End If
    '        lblInicio = CType(mpForm.FindControl("lblInicio"), Label)
    '        If Not lblInicio Is Nothing Then
    '            Dim fecIni As Date = dtEmpleado.Rows(0)("FechaInicial")
    '            lblInicio.Text = fecIni.ToString("yyyy/MM/dd")
    '            lblInicio.Visible = True
    '            lblTxtInicio = CType(mpForm.FindControl("lblTxtInicio"), Label)
    '            lblTxtInicio.Visible = True
    '        End If
    '        lblFin = CType(mpForm.FindControl("lblFin"), Label)
    '        If Not lblFin Is Nothing Then
    '            Dim fecFin As Date = dtEmpleado.Rows(0)("FechaFinal")
    '            lblFin.Text = fecFin.ToString("yyyy/MM/dd")
    '            lblFin.Visible = True
    '            lblTxtFin = CType(mpForm.FindControl("lblTxtFin"), Label)
    '            lblTxtFin.Visible = True
    '        End If
    '    End If

    'End Sub

End Class