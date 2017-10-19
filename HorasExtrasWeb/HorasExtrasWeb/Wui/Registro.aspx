<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="Maestro.Master" CodeBehind="Registro.aspx.vb" Inherits="HorasExtrasWeb.Registro" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Import Namespace="System.Security.Principal" %>
<%@ MasterType virtualpath="~/Wui/Maestro.Master" %>
<%@ OutputCache Location="None" NoStore="true" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <script type="text/javascript"> 
    var patron = new Array(2,2) 
    function mascara(d, sep, pat, nums){ 
        if (d.valant != d.value){ 
            val = d.value 
            largo = val.length 
            val = val.split(sep) 
            val2 = '' 
            for (r = 0; r < val.length; r++){ 
                val2 += val[r] 
            } 
            if (nums){ 
                for(z=0;z<val2.length;z++){ 
                    if(isNaN(val2.charAt(z))){ 
                        letra = new RegExp(val2.charAt(z),"g") 
                        val2 = val2.replace(letra,"") 
                    } 
                } 
            } 
            val = '' 
            val3 = new Array() 
            for(s=0; s<pat.length; s++){ 
                val3[s] = val2.substring(0,pat[s]) 
                val2 = val2.substr(pat[s]) 
            } 
            for(q=0;q<val3.length; q++){ 
                if(q ==0){ 
                    val = val3[q] 
                } 
                else{ 
                    if(val3[q] != ""){ 
                        val += sep + val3[q] 
                    } 
                } 
            } 
            d.value = val 
            d.valant = val 
        } 
        if (val.length==5){ 
            hora=val.split(":") 
            if ((hora[0]>23) ||(hora[1]>59)) 
                alert("Recuerde el formato de Horas, desde 00:00 hasta 23:59 ")
        } 
    } 
    </script> 
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="w3-container w3-center w3-panel w3-blue">
        <h2 class="w3-opacity" style="text-shadow:2px 2px 0 #444">Registro de Horas Extras</h2>
    </div>
    <div>
    </div>
    <div id="NewReg2" runat="server" visible="false">
        <table>
            <tr>
                <td>
                </td>
                <td>
                </td>
                <td>
                </td>
                <td>
                </td>
                <td>
                </td>
                <td>
                </td>
                <td colspan="2" class="w3-tiny w3-center w3-border-top w3-border-right w3-border-left">
                    <asp:Label ID="Label6" runat="server" Text="Resta el 50%"/>
                </td>
                <td colspan="2" class="w3-tiny w3-center w3-border-top w3-border-right w3-border-left">
                    <asp:Label ID="Label8" runat="server" Text="Resta el 100%"/>
                </td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td class="w3-small">
                    <asp:Label ID="Label1" runat="server" Text="Fecha:"/>
                </td>
                <td>
                    <asp:TextBox ID="FechaTxt" runat="server" Width="100px"/>
                    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
                    <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender1" runat="server" Mask="99/99/9999" MaskType="Date" TargetControlID="FechaTxt" />
                </td>
                <td class="w3-small">
                    <asp:Label ID="Label2" runat="server" Text="Ingreso:"/>
                </td>
                <td>
                    <asp:TextBox ID="IngresoTxt" runat="server" onkeyup="mascara(this,':',patron,true)" Width="60px" />
                </td>
                <td class="w3-small">
                    <asp:Label ID="Label3" runat="server" Text="Salida:"/>
                </td>
                <td>
                    <asp:TextBox ID="SalidaTxt" runat="server" onkeyup="mascara(this,':',patron,true)" Width="60px" />
                </td>
                <td class="w3-small w3-border-left w3-border-bottom">
                    <asp:Label ID="Label5" runat="server" Text="Permiso"/>
                </td>
                <td class="w3-border-right w3-border-bottom">
                    <asp:TextBox ID="Permisotxt" runat="server" onkeyup="mascara(this,':',patron,true)" Width="60px" />
                </td>
                <td class="w3-small w3-border-left w3-border-bottom">
                    <asp:Label ID="Label7" runat="server" Text="Recuperar"/>
                </td>
                <td class="w3-border-right w3-border-bottom">
                    <asp:TextBox ID="RecuperarTxt" runat="server" onkeyup="mascara(this,':',patron,true)" Width="60px" />
                </td>
                <td class="w3-small">
                    <asp:Label ID="Label4" runat="server" Text="Justificativo:"/>
                </td>
                <td>
                    <asp:TextBox ID="DetalleTxt" runat="server" Width="150px"/>
                </td>
                <td>
                    <asp:ImageButton ID="btnAgregar" runat="server" CommandName="Agregar" ImageUrl="../icons/guardar.ico" ToolTipText="Agregar" />
                </td>
                <td>
                    <asp:ImageButton ID="btnDeshacer" runat="server" CommandName="Cancelar" ImageUrl="../icons/regresar.ico" ToolTipText="Cancelar" 
                        CausesValidation="False" />
                </td>
                <td class="w3-tiny w3-text-red">
                    <asp:CompareValidator ID="CompFechaIni" runat="server" ErrorMessage="Fecha inferior a Desde" ControlToValidate="FechaTxt" 
                        Operator="GreaterThanEqual" Type="Date" />
                </td>
            </tr>
            <tr>
                <td colspan="2" class="w3-tiny w3-text-red">
                    <asp:CompareValidator ID="ComFechaTipo" runat="server" ErrorMessage="Sin formato" ControlToValidate="FechaTxt" 
                        Operator="DataTypeCheck" Type="Date" />
                    <asp:RequiredFieldValidator ID="ValFecha" runat="server" ErrorMessage="Fecha Vacía" ControlToValidate="FechaTxt"/>
                </td>
                <td>
                </td>
                <td class="w3-tiny w3-text-red">
                    <%--<asp:RequiredFieldValidator ID="ValIngreso" runat="server" ErrorMessage="Vacío" ControlToValidate="IngresoTxt"/>--%>
                </td>
                <td>
                </td>
                <td class="w3-tiny w3-text-red">
                    <%--<asp:RequiredFieldValidator ID="ValSalida" runat="server" ErrorMessage="Vacío" ControlToValidate="SalidaTxt"/>--%>
                </td>
                <td>
                </td>
                <td class="w3-tiny w3-text-red">
                    <%--<asp:RequiredFieldValidator ID="ValPermiso" runat="server" ErrorMessage="Vacío" ControlToValidate="Permisotxt"/>--%>
                </td>
                <td>
                </td>
                <td class="w3-tiny w3-text-red">
                    <%--<asp:RequiredFieldValidator ID="ValRecuperar" runat="server" ErrorMessage="Vacío" ControlToValidate="RecuperarTxt"/>--%>
                </td>
                <td class="w3-tiny w3-text-red">
                    <asp:RequiredFieldValidator ID="ValJustifica" runat="server" ErrorMessage="Escriba" ControlToValidate="DetalleTxt"/>
                </td>
                <td class="w3-tiny w3-text-red">
                    <asp:Label ID="lblExisteFecha" runat="server" Text="Fecha y hora ya existen" Visible="false"/>
                </td>
                <td>
                </td>
                <td>
                </td>
                <td colspan="2" class="w3-tiny w3-text-red">
                    <asp:CompareValidator ID="ComFechFin" runat="server" ErrorMessage="Fecha superior a Hasta" 
                        ControlToValidate="FechaTxt" Operator="LessThanEqual" Type="Date" />
                </td>
            </tr>
        </table>
        <div runat="server" visible="false" id="divError">
                <asp:Label ID="lblError" runat="server" Text="" Visible="false" CssClass="w3-panel w3-red"/>
        </div>
    </div>
    <div>
        <asp:GridView ID="gvBiometrico" runat="server" AutoGenerateColumns="False"
            OnRowEditing="GridView_RowEditing" 
            OnRowCancelingEdit="GridView_RowCancelingEdit" 
            OnRowDeleting="GridView_RowDeleting" 
            OnRowUpdating="GridView_RowUpdating" ShowHeaderWhenEmpty="True" 
            onRowDatabound="GridView_RowDataBound" ShowFooter="True" 
            >
            <HeaderStyle CssClass="w3-indigo w3-center w3-small" />
            <FooterStyle CssClass="w3-gray w3-center w3-small" />
            <%--<AlternatingRowStyle CssClass="w3-light-grey" />--%>
            <Columns>
                <asp:TemplateField HeaderText="Codigo" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="Codigo" runat="server" Text='<%#Bind("CodigoEmp") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Acción">
                    <EditItemTemplate>
                        <asp:ImageButton ID="ButtonUpdate" runat="server" CommandName="Update" ImageUrl="../icons/guardar.ico" ToolTipText="Guardar" />
                        <asp:ImageButton ID="ButtonCancel" runat="server" CommandName="Cancel" ImageUrl="../icons/regresar.ico" ToolTipText="Cancelar" />
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:ImageButton ID="ButtonEdit" runat="server" CommandName="Edit" ImageUrl="../icons/editar.ico" ToolTipText="Modificar" />
                        <asp:ImageButton ID="ButtonDelete" runat="server" CommandName="Delete" ImageUrl="../icons/eliminar.ico" ToolTipText="Elminar" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Dia">
                    <ItemTemplate>
                        <asp:Label ID="Dia" runat="server" Text='<%#Bind("Dia") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Fecha">
                    <ItemTemplate>
                        <asp:Label ID="lblFecha" runat="server" Text='<%# Bind("Fecha", "{0:dd/MM/yyyy}") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Ingreso" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:Label ID="HoraIng" runat="server" Text='<%#Bind("Ingreso", "{0: H:mm}") %>'  />
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center"/>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Salida" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:Label ID="HoraSal" runat="server" Text='<%#Bind("Salida", "{0: H:mm}") %>' />
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center"/>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Laborado" ItemStyle-HorizontalAlign="Center">                
                    <ItemTemplate>
                        <asp:Label ID="HoraLab" runat="server" Text='<%#Bind("Laborado", "{0: H:mm}") %>' />
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center"/>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Atrasado" ItemStyle-HorizontalAlign="Center" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="HoraAtr" runat="server" Text='<%#Bind("Atrasado", "{0: H:mm}") %>' />
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center"/>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Anticipado" ItemStyle-HorizontalAlign="Center" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="HoraAnt" runat="server" Text='<%#Bind("Anticipado", "{0: H:mm}") %>' />
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center"/>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Permiso" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:Label ID="HorasPermiso" runat="server" Text='<%#Bind("HorasPermiso", "{0: H:mm}") %>' />
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center"/>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Recuperar" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:Label ID="HorasRecuperar" runat="server" Text='<%#Bind("HorasRecuperar", "{0: H:mm}") %>' />
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center"/>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="0%" ItemStyle-HorizontalAlign="Center" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="Hora0" runat="server" Text='<%#Bind("Horas0", "{0: H:mm}") %>' />
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center"/>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="50%" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:Label ID="Horas50" runat="server" Text='<%#Bind("Horas50", "{0: H:mm}") %>' />
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center"/>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="100%" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:Label ID="Horas100" runat="server" Text='<%#Bind("Horas100", "{0: H:mm}") %>' />
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center"/>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Justificativo">
                    <EditItemTemplate>
                        <asp:TextBox ID="Justificativo" runat="server" Text='<%#Bind("Justificativo") %>' />
                        <br>
                        </br>
                        <asp:RequiredFieldValidator id="JustValidator" ControlToValidate="Justificativo"
                            display="Dynamic" text="FALTA!" runat="server" />
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Justificativo" runat="server" Text='<%# Bind("Justificativo") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="HorasExtrasId" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="HorasExtrasId" runat="server" Text='<%#Bind("HorasExtrasId") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Anio" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="Anio" runat="server" Text='<%#Bind("Anio") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Periodo" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="Periodo" runat="server" Text='<%#Bind("Periodo") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Activo" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="Activo" runat="server" Text='<%#Bind("Activo") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Biometrico" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="Biometrico" runat="server" Text='<%#Bind("Biometrico") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
    <div>
        <table>
            <tr>
                <td>
                    <asp:Button ID="BtnAdd" runat="server" Text="Agregar Registro" />
                </td>
                <td>
                    <asp:Label ID="lblAprobado" runat="server" Text="Aprobado" Visible="false" class="w3-red"/>
                </td>
                <td>
                    <asp:ImageButton ID="btnPrint" runat="server" CommandName="Imprimir" ImageUrl="../icons/impresora.ico" ToolTipText="Imprimir" 
                        CausesValidation="False" />
                </td>
                <td>
                    &nbsp;</td>
            </tr>
        </table>
    </div>
    <br />    
</asp:Content>
