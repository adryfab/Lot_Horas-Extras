Public Class Maestro
    Inherits System.Web.UI.MasterPage

    Public Property usuario() As String
        Get
            Return CType(ViewState("usuario"), String)
        End Get
        Set(ByVal Value As String)
            ViewState("usuario") = Value
        End Set
    End Property

    Public Property codigo() As String
        Get
            Return CType(ViewState("codigo"), String)
        End Get
        Set(ByVal Value As String)
            ViewState("codigo") = Value
        End Set
    End Property

    Public Property area() As String
        Get
            Return CType(ViewState("area"), String)
        End Get
        Set(ByVal Value As String)
            ViewState("area") = Value
        End Set
    End Property

    Public Property areaId() As String
        Get
            Return CType(ViewState("areaId"), String)
        End Get
        Set(ByVal Value As String)
            ViewState("areaId") = Value
        End Set
    End Property

    Public Property Dep() As String
        Get
            Return CType(ViewState("Dep"), String)
        End Get
        Set(ByVal Value As String)
            ViewState("Dep") = Value
        End Set
    End Property

    Public Property DepId() As String
        Get
            Return CType(ViewState("DepId"), String)
        End Get
        Set(ByVal Value As String)
            ViewState("DepId") = Value
        End Set
    End Property

    Public Property procesar() As Boolean
        Get
            Return CType(ViewState("procesar"), Boolean)
        End Get
        Set(ByVal Value As Boolean)
            ViewState("procesar") = Value
        End Set
    End Property

    Public Property sesionIni() As Boolean
        Get
            Return CType(ViewState("sesionIni"), Boolean)
        End Get
        Set(ByVal Value As Boolean)
            ViewState("sesionIni") = Value
        End Set
    End Property

    Public Property Año() As String
        Get
            Return CType(ViewState("Año"), String)
        End Get
        Set(ByVal Value As String)
            ViewState("Año") = Value
        End Set
    End Property

    Public Property Periodo() As String
        Get
            Return CType(ViewState("Periodo"), String)
        End Get
        Set(ByVal Value As String)
            ViewState("Periodo") = Value
        End Set
    End Property

    Public Property Inicio() As Date
        Get
            Return CType(ViewState("Inicio"), Date)
        End Get
        Set(ByVal Value As Date)
            ViewState("Inicio") = Value
        End Set
    End Property

    Public Property Fin() As Date
        Get
            Return CType(ViewState("Fin"), Date)
        End Get
        Set(ByVal Value As Date)
            ViewState("Fin") = Value
        End Set
    End Property

    Public Property Cargo() As String
        Get
            Return CType(ViewState("Cargo"), String)
        End Get
        Set(ByVal Value As String)
            ViewState("Cargo") = Value
        End Set
    End Property

    Public Property CargoId() As String
        Get
            Return CType(ViewState("CargoId"), String)
        End Get
        Set(ByVal Value As String)
            ViewState("CargoId") = Value
        End Set
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        lblUsuario.Text = Me.usuario
        lblCodigo.Text = Me.codigo
        lblArea.Text = Me.area
        lblAreaId.Text = Me.areaId
        lblDep.Text = Me.Dep
        lblDepId.Text = Me.DepId
        idProcesar.Visible = procesar
        lblAnio.Text = Me.Año
        lblPeriodo.Text = Me.Periodo
        lblInicio.Text = Me.Inicio
        lblFin.Text = Me.Fin
        lblCargo.Text = Me.Cargo
        lblCargoId.Text = Me.CargoId
        idInicio.Visible = Not Me.sesionIni
        idFin.Visible = Me.sesionIni
    End Sub

End Class