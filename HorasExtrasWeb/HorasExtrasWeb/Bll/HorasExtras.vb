Imports System.Data.SqlClient

Public Class HorasExtras

#Region "Propiedades Publicas"

    Private _CodigoEmp As Integer
    Public Property CodigoEmp() As Integer
        Get
            Return Me._CodigoEmp
        End Get
        Set(value As Integer)
            Me._CodigoEmp = value
        End Set
    End Property

    Private _Dia As String
    Public Property Dia() As String
        Get
            Return Me._Dia
        End Get
        Set(value As String)
            Me._Dia = value
        End Set
    End Property

    Private _Fecha As Date
    Public Property Fecha() As Date
        Get
            Return Me._Fecha
        End Get
        Set(value As Date)
            Me._Fecha = value
        End Set
    End Property

    Private _Ingreso As DateTime
    Public Property Ingreso() As DateTime
        Get
            Return Me._Ingreso
        End Get
        Set(value As DateTime)
            Me._Ingreso = value
        End Set
    End Property

    Private _Salida As DateTime
    Public Property Salida() As DateTime
        Get
            Return Me._Salida
        End Get
        Set(value As DateTime)
            Me._Salida = value
        End Set
    End Property

    Private _Laborado As DateTime
    Public Property Laborado() As DateTime
        Get
            Return Me._Laborado
        End Get
        Set(value As DateTime)
            Me._Laborado = value
        End Set
    End Property

    Private _Atrasado As DateTime
    Public Property Atrasado() As DateTime
        Get
            Return Me._Atrasado
        End Get
        Set(value As DateTime)
            Me._Atrasado = value
        End Set
    End Property

    Private _Anticipado As DateTime
    Public Property Anticipado() As DateTime
        Get
            Return Me._Anticipado
        End Get
        Set(value As DateTime)
            Me._Anticipado = value
        End Set
    End Property

    Private _Horas0 As DateTime
    Public Property Horas0() As DateTime
        Get
            Return Me._Horas0
        End Get
        Set(value As DateTime)
            Me._Horas0 = value
        End Set
    End Property

    Private _Horas50 As DateTime
    Public Property Horas50() As DateTime
        Get
            Return Me._Horas50
        End Get
        Set(value As DateTime)
            Me._Horas50 = value
        End Set
    End Property

    Private _Horas100 As DateTime
    Public Property Horas100() As DateTime
        Get
            Return Me._Horas100
        End Get
        Set(value As DateTime)
            Me._Horas100 = value
        End Set
    End Property

    Private _Justificativo As String
    Public Property Justificativo() As String
        Get
            Return Me._Justificativo
        End Get
        Set(value As String)
            Me._Justificativo = value
        End Set
    End Property

    Private _HorasExtrasId As Integer
    Public Property HorasExtrasId() As Integer
        Get
            Return Me._HorasExtrasId
        End Get
        Set(value As Integer)
            Me._HorasExtrasId = value
        End Set
    End Property

    Private _Anio As Integer
    Public Property Anio() As Integer
        Get
            Return Me._Anio
        End Get
        Set(value As Integer)
            Me._Anio = value
        End Set
    End Property

    Private _Periodo As Integer
    Public Property Periodo() As Integer
        Get
            Return Me._Periodo
        End Get
        Set(value As Integer)
            Me._Periodo = value
        End Set
    End Property

#End Region

    Public Sub Inicializar()
        _CodigoEmp = 0
        _Dia = String.Empty
        _Fecha = Nothing
        _Ingreso = Nothing
        _Salida = Nothing
        _Laborado = Nothing
        _Atrasado = Nothing
        _Anticipado = Nothing
        _Horas0 = Nothing
        _Horas50 = Nothing
        _Horas100 = Nothing
        _Justificativo = String.Empty
        _HorasExtrasId = 0
        _Anio = 0
        _Periodo = 0
    End Sub

    Public Function infoXML() As String
        Dim cadenaXML As String = String.Empty

        cadenaXML &= "<HOREXT "
        cadenaXML &= "CODEMP=""" & Me.CodigoEmp & """ "
        cadenaXML &= "DIAFEC=""" & Me.Dia & """ "
        cadenaXML &= "FECHAM=""" & Me.Fecha & """ "
        cadenaXML &= "INGRES=""" & Me.Ingreso & """ "
        cadenaXML &= "SALIDA=""" & Me.Salida & """ "
        cadenaXML &= "LABORA=""" & Me.Laborado & """ "
        cadenaXML &= "ATRASA=""" & Me.Atrasado & """ "
        cadenaXML &= "ANTICI=""" & Me.Anticipado & """ "
        cadenaXML &= "HORA00=""" & Me.Horas0 & """ "
        cadenaXML &= "HORA50=""" & Me.Horas50 & """ "
        cadenaXML &= "HOR100=""" & Me.Horas100 & """ "
        cadenaXML &= "JUSTIF=""" & Me.Justificativo & """ "
        cadenaXML &= "HOEXID=""" & Me.HorasExtrasId & """ "
        cadenaXML &= "ANIOPE=""" & Me.Anio & """ "
        cadenaXML &= "PERIOD=""" & Me.Periodo & """ "
        cadenaXML &= " /> "

        Return cadenaXML
    End Function

    Public Function Select_Grid(ByVal user As String) As DataTable
        Dim SQLConexionBD As New SQLConexionBD()
        Dim dtBiometrico As New DataTable
        Dim dsTablas As New DataSet
        dsTablas = SQLConexionBD.RecuperarDatosBiometricoPorUsuario(user)
        dtBiometrico = dsTablas.Tables(1)
        Return dtBiometrico
    End Function

End Class
