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

    Sub Page_Init(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Init

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        lblUsuario.Text = Me.usuario
        lblCodigo.Text = Me.codigo
        lblArea.Text = Me.area
        lblAreaId.Text = Me.areaId
        lblDep.Text = Me.Dep
        lblDepId.Text = Me.DepId
        idProcesar.Visible = procesar
    End Sub

End Class