<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="Maestro.Master" CodeBehind="Registro.aspx.vb" Inherits="HorasExtrasWeb.Registro" %>
<%@ Import Namespace="System.Security.Principal" %>
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
        <table>
            <tr>
                <td>
                    <asp:Label ID="lblTxtUsuario" runat="server" Text="Usuario: " Visible="False" />
                </td>
                <td class="w3-tag w3-pale-blue">
                    <asp:Label ID="lblUsuario" runat="server" Text="Label" Visible="False" />
                </td>
                <td>
                    <asp:Label ID="lblTxtCodigo" runat="server" Text="Codigo: " Visible="False" />
                </td>
                <td class="w3-tag w3-pale-blue">
                    <asp:Label ID="lblCodigo" runat="server" Text="Label" Visible="False" />
                </td>
                <td>
                    <asp:Label ID="lblTxtAnio" runat="server" Text="Año: " Visible="False" />
                </td>
                <td class="w3-tag w3-pale-blue">
                    <asp:Label ID="lblAnio" runat="server" Text="Label" Visible="False" />
                </td>
                <td>
                    <asp:Label ID="lblTxtPeriodo" runat="server" Text="Periodo: " Visible="False" />
                </td>
                <td class="w3-tag w3-pale-blue">
                    <asp:Label ID="lblPeriodo" runat="server" Text="Label" Visible="False"/>
                </td>
                <td>
                    <asp:Label ID="lblTxtInicio" runat="server" Text="Desde: " Visible="False" />
                </td>
                <td class="w3-tag w3-pale-blue">
                    <asp:Label ID="lblInicio" runat="server" Text="Label" Visible="False"/>
                </td>
                <td>
                    <asp:Label ID="lblTxtFin" runat="server" Text="Hasta: " Visible="False"/>
                </td>
                <td class="w3-tag w3-pale-blue">
                    <asp:Label ID="lblFin" runat="server" Text="Label" Visible="False"/>
                </td>
                <td>
                    <asp:Label ID="lblAprobado" runat="server" Text="Aprobado" Visible="false" class="w3-red"/>
                </td>
                <td>
                    <asp:ImageButton ID="btnPrint" runat="server" CommandName="Imprimir" ImageUrl="../icons/impresora.ico" ToolTipText="Imprimir" 
                        CausesValidation="False" />
                </td>
            </tr>
        </table>
    </div>
    <div id="NewReg2" runat="server" visible="false">
        </br>
        <table>
            <tr>
                <td>
                    <asp:Label ID="Label1" runat="server" Text="Fecha:"/>
                </td>
                <td>
                    <asp:TextBox ID="FechaTxt" runat="server"/>
                </td>
                <td>
                    <asp:Label ID="Label2" runat="server" Text="Ingreso:"/>
                </td>
                <td>
                    <asp:TextBox ID="IngresoTxt" runat="server" onkeyup="mascara(this,':',patron,true)" />
                </td>
                <td>
                    <asp:Label ID="Label3" runat="server" Text="Salida:"/>
                </td>
                <td>
                    <asp:TextBox ID="SalidaTxt" runat="server" onkeyup="mascara(this,':',patron,true)" />
                </td>
                <td>
                    <asp:Label ID="Label4" runat="server" Text="Justificativo:"/>
                </td>
                <td>
                    <asp:TextBox ID="DetalleTxt" runat="server"/>
                </td>
                <td>
                    <asp:ImageButton ID="btnAgregar" runat="server" CommandName="Agregar" ImageUrl="../icons/guardar.ico" ToolTipText="Agregar" />
                </td>
                <td>
                    <asp:ImageButton ID="btnDeshacer" runat="server" CommandName="Cancelar" ImageUrl="../icons/regresar.ico" ToolTipText="Cancelar" 
                        CausesValidation="False" />
                </td>
            </tr>
            <tr>
                <td colspan="2" class="w3-tiny w3-text-red">
                    <asp:RequiredFieldValidator ID="ValFecha" runat="server" ErrorMessage="Vacío" ControlToValidate="FechaTxt"/>
                    <asp:CompareValidator ID="CompFechaIni" runat="server" ErrorMessage="Inferior" ControlToValidate="FechaTxt" 
                        Operator="GreaterThanEqual" Type="Date" />
                    <asp:CompareValidator ID="ComFechFin" runat="server" ErrorMessage="Superior" ControlToValidate="FechaTxt" 
                        Operator="LessThanEqual" Type="Date" />
                    <asp:CompareValidator ID="ComFechaTipo" runat="server" ErrorMessage="Sin formato" ControlToValidate="FechaTxt" 
                        Operator="DataTypeCheck" Type="Date" />
                </td>
                <td colspan="2" class="w3-tiny w3-text-red">
                    <asp:RequiredFieldValidator ID="ValIngreso" runat="server" ErrorMessage="Vacío" ControlToValidate="IngresoTxt"/>
                </td>
                <td colspan="2" class="w3-tiny w3-text-red">
                    <asp:RequiredFieldValidator ID="ValSalida" runat="server" ErrorMessage="Vacío" ControlToValidate="SalidaTxt"/>
                </td>
                <td colspan="2" class="w3-tiny w3-text-red">
                    <asp:RequiredFieldValidator ID="ValJustifica" runat="server" ErrorMessage="Escriba" ControlToValidate="DetalleTxt"/>
                </td>
            </tr>
            <tr>
                <td colspan="2" class="w3-tiny w3-text-red">
                    <asp:Label ID="lblExisteFecha" runat="server" Text="La fecha y hora ya existen" Visible="false"/>
                </td>
            </tr>
        </table>
    </div>
    </br>
    <asp:GridView ID="gvBiometrico" runat="server" AutoGenerateColumns="False"
        OnRowEditing="GridView_RowEditing" 
        OnRowCancelingEdit="GridView_RowCancelingEdit" 
        OnRowDeleting="GridView_RowDeleting" 
        OnRowUpdating="GridView_RowUpdating" ShowHeaderWhenEmpty="True" 
        onrowdatabound="GridView_RowDataBound" 
        >
        <HeaderStyle CssClass="w3-indigo w3-center" />
        <AlternatingRowStyle CssClass="w3-light-grey" />
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
                <EditItemTemplate>
                    <asp:TextBox ID="txtFecha" runat="server" Text='<%#Bind("Fecha") %>' Width="100" />
                    <asp:Calendar ID="calFecha" runat="server" VisibleDate='<%# Eval("Fecha") %>' />
                    <br/>
                    <asp:RequiredFieldValidator id="FechaValidator" ControlToValidate="txtFecha"
                        display="Dynamic" text="FALTA!" runat="server" />                    
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblFecha" runat="server" Text='<%# Bind("Fecha", "{0:dd/MM/yyyy}") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Ingreso" ItemStyle-HorizontalAlign="Center">
                <EditItemTemplate>
                    <asp:TextBox ID="HoraIng" runat="server" Text='<%#Bind("Ingreso") %>' Width="60"/>
                    <br/>
                    <asp:RequiredFieldValidator id="IngresoValidator" ControlToValidate="HoraIng"
                        display="Dynamic" text="FALTA!" runat="server" />                    
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="HoraIng" runat="server" Text='<%#Bind("Ingreso", "{0: H:mm}") %>'  />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Salida" ItemStyle-HorizontalAlign="Center">
                <EditItemTemplate>
                    <asp:TextBox ID="HoraSal" runat="server" DataFormatString="{0:N4}" Text='<%#Bind("Salida") %>' Width="60"/>
                    <br/>
                    <asp:RequiredFieldValidator id="SalidaValidator" ControlToValidate="HoraSal"
                        display="Dynamic" text="FALTA!" runat="server" />                    
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="HoraSal" runat="server" Text='<%#Bind("Salida", "{0: H:mm}") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Laborado" ItemStyle-HorizontalAlign="Center">                
                <ItemTemplate>
                    <asp:Label ID="HoraLab" runat="server" Text='<%#Bind("Laborado", "{0: H:mm}") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Atrasado" ItemStyle-HorizontalAlign="Center">
                <ItemTemplate>
                    <asp:Label ID="HoraAtr" runat="server" Text='<%#Bind("Atrasado", "{0: H:mm}") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Anticipado" ItemStyle-HorizontalAlign="Center">
                <ItemTemplate>
                    <asp:Label ID="HoraAnt" runat="server" Text='<%#Bind("Anticipado", "{0: H:mm}") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="0%" ItemStyle-HorizontalAlign="Center">
                <ItemTemplate>
                    <asp:Label ID="Hora0" runat="server" Text='<%#Bind("Horas0", "{0: H:mm}") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="50%" ItemStyle-HorizontalAlign="Center">
                <EditItemTemplate>
                    <asp:TextBox ID="Horas50" runat="server" Text='<%#Bind("Horas50") %>' Width="60"/>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Horas50" runat="server" Text='<%#Bind("Horas50", "{0: H:mm}") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="100%" ItemStyle-HorizontalAlign="Center">
                <EditItemTemplate>
                    <asp:TextBox ID="Horas100" runat="server" Text='<%#Bind("Horas100") %>' Width="60"/>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Horas100" runat="server" Text='<%#Bind("Horas100", "{0: H:mm}") %>' />
                </ItemTemplate>
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
        </Columns>
    </asp:GridView>    
    <asp:Button ID="BtnAdd" runat="server" Text="Agregar Registro" />
    <br />    
</asp:Content>
