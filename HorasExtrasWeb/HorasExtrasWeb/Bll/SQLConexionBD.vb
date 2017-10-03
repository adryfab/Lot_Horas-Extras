Imports System.Data.SqlClient
Imports System.Web
Imports System.Security.Cryptography
Imports System.Text

Public Class SQLConexionBD

    Private Conexion As SqlConnection

    Public Sub New()
        Dim strConnString As String = GetConnectionStringByName("ConString")
        Conexion = New SqlConnection(strConnString)
        Try
            Conexion.Open()
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Function GetConnectionStringByName(ByVal name As String) As String
        ' Assume failure
        Dim returnValue As String = Nothing

        ' Look for the name in the connectionStrings section.
        Dim settings As ConnectionStringSettings = ConfigurationManager.ConnectionStrings(name)

        ' If found, return the connection string.
        If Not settings Is Nothing Then
            returnValue = settings.ConnectionString
        End If

        Dim respuesta As String = Convertir(returnValue)
        returnValue = respuesta

        Return returnValue
    End Function

    Private Function Convertir(ByVal texto As String) As String
        Dim substrings() As String = texto.Split(";")
        Dim pass As String = substrings(3).Substring(9)
        Dim newPass As String = Salida(pass)
        Dim passw As String = "password=" + newPass
        Dim subs As String = substrings(0) + ";" + substrings(1) + ";" + substrings(2) + ";" + passw
        Return subs
    End Function

    Private Function Salida(ByVal Input As String) As String
        Dim IV() As Byte = ASCIIEncoding.ASCII.GetBytes("loterias") 'Debe ser de 8 caracteres
        Dim EncryptionKey() As Byte = Convert.FromBase64String("aprPSvIvLVztmcrlUP/96cG7jky71L5S") 'No se puede alterar la cantidad de caracteres
        Dim buffer() As Byte = Convert.FromBase64String(Input)
        Dim des As TripleDESCryptoServiceProvider = New TripleDESCryptoServiceProvider
        des.Key = EncryptionKey
        des.IV = IV
        Return Encoding.UTF8.GetString(des.CreateDecryptor().TransformFinalBlock(buffer, 0, buffer.Length()))
    End Function

    Public Function RecuperarDatosBiometricoPorUsuario(ByVal user As String) As DataSet
        Dim dtSet = New DataSet
        Try
            Dim SQLDataAdapter = New SqlDataAdapter("spBiometricoPeriodoVigenteRecuperar", Conexion)
            SQLDataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure
            SQLDataAdapter.SelectCommand.Parameters.Add(New SqlParameter("@UsuarioId", SqlDbType.VarChar, 50))
            SQLDataAdapter.SelectCommand.Parameters("@UsuarioId").Value = user
            SQLDataAdapter.Fill(dtSet)
        Catch ex As Exception
            dtSet = Nothing
        End Try
        Return dtSet
    End Function

    Public Function GrabarRegisto(ByVal user As String, ByVal infoXml As String) As Integer
        Dim HorasExtrasId As Integer
        Try
            Dim SQLDataAdapter = New SqlDataAdapter("spHorasExtrasAgregar", Conexion)
            SQLDataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure
            SQLDataAdapter.SelectCommand.Parameters.Add(New SqlParameter("@UsuarioId", SqlDbType.VarChar, 50))
            SQLDataAdapter.SelectCommand.Parameters("@UsuarioId").Value = user
            SQLDataAdapter.SelectCommand.Parameters.Add(New SqlParameter("@InfoXml", SqlDbType.Xml))
            SQLDataAdapter.SelectCommand.Parameters("@InfoXml").Value = infoXml
            SQLDataAdapter.SelectCommand.Parameters.Add(New SqlParameter("@HorasExtrasId", SqlDbType.BigInt))
            SQLDataAdapter.SelectCommand.Parameters("@HorasExtrasId").Direction = ParameterDirection.Output
            SQLDataAdapter.SelectCommand.ExecuteNonQuery()
            HorasExtrasId = SQLDataAdapter.SelectCommand.Parameters("@HorasExtrasId").Value
        Catch ex As Exception
            HorasExtrasId = 0
        End Try
        Return HorasExtrasId
    End Function

    Public Function GrabarAprobacion(ByVal infoXml As String) As Integer
        Dim resultado As Integer
        Try
            Dim SQLDataAdapter = New SqlDataAdapter("spAprobacionesActualizar", Conexion)
            SQLDataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure
            SQLDataAdapter.SelectCommand.Parameters.Add(New SqlParameter("@InfoXml", SqlDbType.Xml))
            SQLDataAdapter.SelectCommand.Parameters("@InfoXml").Value = infoXml
            resultado = SQLDataAdapter.SelectCommand.ExecuteNonQuery()
        Catch ex As Exception
            resultado = 0
        End Try
        Return resultado
    End Function

    Public Function EliminarRegistro(ByVal user As String, ByVal infoXml As String) As Integer
        Dim resultado As Integer
        Try
            Dim SQLDataAdapter = New SqlDataAdapter("spHorasExtrasEliminar", Conexion)
            SQLDataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure
            SQLDataAdapter.SelectCommand.Parameters.Add(New SqlParameter("@UsuarioId", SqlDbType.VarChar, 50))
            SQLDataAdapter.SelectCommand.Parameters("@UsuarioId").Value = user
            SQLDataAdapter.SelectCommand.Parameters.Add(New SqlParameter("@InfoXml", SqlDbType.Xml))
            SQLDataAdapter.SelectCommand.Parameters("@InfoXml").Value = infoXml
            resultado = SQLDataAdapter.SelectCommand.ExecuteNonQuery()
        Catch ex As Exception
            resultado = 0
        End Try
        Return resultado
    End Function

    Public Function RecuperarAprobaciones(ByVal user As String) As DataSet
        Dim dtSet = New DataSet
        Try
            Dim SQLDataAdapter = New SqlDataAdapter("spAprobacionesRecuperar", Conexion)
            SQLDataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure
            SQLDataAdapter.SelectCommand.Parameters.Add(New SqlParameter("@UsuarioId", SqlDbType.VarChar, 50))
            SQLDataAdapter.SelectCommand.Parameters("@UsuarioId").Value = user
            SQLDataAdapter.Fill(dtSet)
        Catch ex As Exception
            dtSet = Nothing
        End Try
        Return dtSet
    End Function

    Public Function RecuperarDatosEmpleado(ByVal user As String) As DataSet
        Dim dtSet = New DataSet
        Try
            Dim SQLDataAdapter = New SqlDataAdapter("spDatosEmpleadoRecuperar", Conexion)
            SQLDataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure
            SQLDataAdapter.SelectCommand.Parameters.Add(New SqlParameter("@UsuarioId", SqlDbType.VarChar, 50))
            SQLDataAdapter.SelectCommand.Parameters("@UsuarioId").Value = user
            SQLDataAdapter.Fill(dtSet)
        Catch ex As Exception
            dtSet = Nothing
        End Try
        Return dtSet
    End Function

    Public Function ValidarJustificacion(ByVal user As String) As Boolean
        Dim validado As Boolean = False
        Try
            Dim SQLDataAdapter = New SqlDataAdapter("spJustifcacionValidar", Conexion)
            SQLDataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure
            SQLDataAdapter.SelectCommand.Parameters.Add(New SqlParameter("@UsuarioId", SqlDbType.VarChar, 50))
            SQLDataAdapter.SelectCommand.Parameters("@UsuarioId").Value = user
            SQLDataAdapter.SelectCommand.Parameters.Add(New SqlParameter("@Justificado", SqlDbType.Bit))
            SQLDataAdapter.SelectCommand.Parameters("@Justificado").Direction = ParameterDirection.Output
            SQLDataAdapter.SelectCommand.ExecuteNonQuery()
            validado = SQLDataAdapter.SelectCommand.Parameters("@Justificado").Value
        Catch ex As Exception
            validado = False
        End Try
        Return validado
    End Function

    Public Function RecuperarImprimir(ByVal user As String) As DataSet
        Dim dtSet = New DataSet
        Try
            Dim SQLDataAdapter = New SqlDataAdapter("spImprimirRecuperar", Conexion)
            SQLDataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure
            SQLDataAdapter.SelectCommand.Parameters.Add(New SqlParameter("@UsuarioId", SqlDbType.VarChar, 50))
            SQLDataAdapter.SelectCommand.Parameters("@UsuarioId").Value = user
            SQLDataAdapter.Fill(dtSet)
        Catch ex As Exception
            dtSet = Nothing
        End Try
        Return dtSet
    End Function

    Public Function RecuperarProcesar() As DataSet
        Dim dtSet = New DataSet
        Try
            Dim SQLDataAdapter = New SqlDataAdapter("spProcesarRecuperar", Conexion)
            SQLDataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure
            SQLDataAdapter.Fill(dtSet)
        Catch ex As Exception
            dtSet = Nothing
        End Try
        Return dtSet
    End Function

End Class
