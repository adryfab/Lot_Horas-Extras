<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ImprimirRegistro.aspx.vb" Inherits="HorasExtrasWeb.ImprimirRegistro" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="w3-center w3-border w3-small">
            <b>
                <asp:Label ID="Label1" runat="server" Text="FORMULARIO PARA PAGO DE HORAS EXTRAORDINARIAS Y SUPLEMENTARIAS" /></b>
        </div>
        <br />
        <div>
            <table class="w3-border w3-tiny" style="width: 100%;">
                <tr>
                    <td>
                        <b>
                            <asp:Label ID="Label2" runat="server" Text="PERÍODO:" /></b>
                    </td>
                    <td>
                        <asp:Label ID="lblPeriodo" runat="server" Text="lblPeriodo" />
                    </td>
                    <td>
                        <b>
                            <asp:Label ID="Label3" runat="server" Text="COLABORADOR:" /></b>
                    </td>
                    <td>
                        <asp:Label ID="lblColaborador" runat="server" Text="lblColaborador" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>
                            <asp:Label ID="Label4" runat="server" Text="CARGO:" /></b>
                    </td>
                    <td>
                        <asp:Label ID="lblCargo" runat="server" Text="lblCargo" />
                    </td>
                    <td>
                        <b>
                            <asp:Label ID="Label5" runat="server" Text="LOCALIDAD:" /></b>
                    </td>
                    <td>
                        <asp:Label ID="lblLocalidad" runat="server" Text="lblLocalidad" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>
                            <asp:Label ID="Label6" runat="server" Text="DPTO./UNIDAD/P de V:" /></b>
                    </td>
                    <td>
                        <asp:Label ID="lblDepartamento" runat="server" Text="lblDepartamento" />
                    </td>
                </tr>
            </table>
        </div>
        <br />
        <div class="w3-border w3-tiny">
            <b>
                <asp:Label ID="Label8" runat="server">
                Solicito se sirva autorizar el pago de las horas suplementarias/extraordinarias del período indicado, de acuerdo al 
                detalle de permisos por recuperar y al registro de ingresos y salidas correspondientes administrado por Desarrollo Humano; 
                todo esto en apego a lo establecido por el Código del Trabajo, el Reglamento Interno de Trabajo y la política corporativa 
                vigente. Los periodos de tiempo otorgados como "permisos recuperables" (Registro de Salida de Personal) serán descontados 
                de las jornadas extendidas, siempre que corresponda. 
                </asp:Label>
            </b>
        </div>
        <br />
        <div class="w3-border w3-tiny">
            <b>
                <asp:Label ID="lblSuplementario" runat="server">
                    DIAS AUTORIZADOS PARA LABORAR HORAS SUPLEMENTARIAS (fuera de la jornada legal de trabajo a partir de 17:30, 
                    máximo 48 horas) CÓDIGO DEL TRABAJO
                </asp:Label>
            </b>
        </div>
        <div>
            <asp:GridView ID="gvBiometrico50" runat="server" AutoGenerateColumns="False" ShowFooter="True">
                <HeaderStyle CssClass="w3-gray w3-tiny"/>
                <FooterStyle CssClass="w3-gray w3-center w3-tiny" />
                <Columns>
                    <asp:TemplateField HeaderText="N°">
                        <ItemTemplate>
                            <asp:Label ID="Num" runat="server" Text='<%#Bind("Num") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Fecha">
                        <ItemTemplate>
                            <asp:Label ID="lblFecha" runat="server" Text='<%# Bind("Fecha", "{0:ddd-dd-MM-yy}") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Hora Ingreso" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:Label ID="HoraIng" runat="server" Text='<%#Bind("Ingreso", "{0: H:mm}") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Hora Salida" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:Label ID="HoraSal" runat="server" Text='<%#Bind("Salida", "{0: H:mm}") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Total horas trabajadas" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:Label ID="HoraLab" runat="server" Text='<%#Bind("Laborado", "{0: H:mm}") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Permiso" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:Label ID="Permiso" runat="server" Text='<%#Bind("HorasPermiso", "{0: H:mm}") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Horas a pagar" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:Label ID="Horas50" runat="server" Text='<%#Bind("Horas50", "{0: H:mm}") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Justificativo de extensión de jornada">
                        <ItemTemplate>
                            <asp:Label ID="Justificativo" runat="server" Text='<%# Bind("Justificativo") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <RowStyle CssClass="w3-tiny" />
            </asp:GridView>            
        </div>
        <br />
        <div class="w3-border w3-tiny">
            <b>
                <asp:Label ID="lblExtra" runat="server">
                    DIAS AUTORIZADOS PARA LABORAR HORAS EXTRAORDINARIAS (días feriados, y fines de semana, máximo  24 horas) CÓDIGO DEL TRABAJO
                </asp:Label>
            </b>
        </div>
        <div>
            <asp:GridView ID="gvBiometrico100" runat="server" AutoGenerateColumns="False" ShowFooter="True">
                <HeaderStyle CssClass="w3-gray w3-tiny" />
                <FooterStyle CssClass="w3-gray w3-center w3-tiny" />
                <Columns>
                    <asp:TemplateField HeaderText="N°">
                        <ItemTemplate>
                            <asp:Label ID="Num" runat="server" Text='<%#Bind("Num") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Fecha">
                        <ItemTemplate>
                            <asp:Label ID="lblFecha" runat="server" Text='<%# Bind("Fecha", "{0:ddd-dd-MM-yy}") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Hora Ingreso" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:Label ID="HoraIng" runat="server" Text='<%#Bind("Ingreso", "{0: H:mm}") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Hora Salida" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:Label ID="HoraSal" runat="server" Text='<%#Bind("Salida", "{0: H:mm}") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Total horas trabajadas" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:Label ID="HoraLab" runat="server" Text='<%#Bind("Laborado", "{0: H:mm}") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Recuperar" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:Label ID="Recuperar" runat="server" Text='<%#Bind("HorasRecuperar", "{0: H:mm}") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Horas a pagar" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:Label ID="Horas100" runat="server" Text='<%#Bind("Horas100", "{0: H:mm}") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Justificativo de extensión de jornada">
                        <ItemTemplate>
                            <asp:Label ID="Justificativo" runat="server" Text='<%# Bind("Justificativo") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <RowStyle CssClass="w3-tiny" />
            </asp:GridView>
        </div>
        <br />
        <br />
        <div>
            <table style="width: 100%;" class="w3-center w3-tiny">
                <tr>
                    <td class="w3-border-bottom">
                        <asp:Label ID="lblSolicitante" runat="server" Text="lblSolicitante" />
                    </td>
                    <td class="w3-border-bottom">
                        <asp:Label ID="lblSupervisor" runat="server" Text="lblSupervisor" />
                    </td>
                    <td class="w3-border-bottom">
                        <asp:Label ID="lblJefe" runat="server" Text="lblJefe" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label12" runat="server" Text="Solicitante" />
                    </td>
                    <td>
                        <asp:Label ID="Label13" runat="server" Text="Supervisor inmediato" />
                    </td>
                    <td>
                        <asp:Label ID="Label14" runat="server" Text="Gerente/Jefe Dpto." />
                    </td>
                </tr>
            </table>
        </div>
        <br />
        <div class="w3-center w3-gray w3-tiny">
            <b>
                <asp:Label ID="Label16" runat="server" Text="Nota:" />
                <br />
                <asp:Label ID="Label15" runat="server">
                Entregar con la firma de aprobación de la Gerencia/Jefatura respectiva en Desarrollo Humano para procesamiento, 
                hasta la fecha del mes que corresponda; caso contrario no procederá el pago respectivo.
                </asp:Label>
            </b>
        </div>
        <br />
        <div class="w3-border">
            <div class="w3-center w3-small">
                <b>
                    <asp:Label ID="Label17" runat="server" Text="ESPACIO RESERVADO PARA EL DPTO. DE DESARROLLO HUMANO" /></b>
            </div>
            <asp:Label ID="Label18" runat="server" Text="Observaciones:" CssClass="w3-tiny"/>
            <br />
            <br />
            <table style="width: 100%;" class="w3-tiny">
                <tr>
                    <td class="w3-border-bottom">Fecha:</td>
                    <td></td>
                    <td class="w3-border-bottom">&nbsp;</td>
                    <td></td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td></td>
                    <td class="w3-center">Analista DDHH</td>
                    <td></td>
                </tr>
            </table>
        </div>
        <br />
    </form>
</body>
</html>
