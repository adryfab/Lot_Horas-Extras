<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Wui/Maestro.Master" CodeBehind="Procesar.aspx.vb" Inherits="HorasExtrasWeb.Procesar" %>
<%@ MasterType virtualpath="~/Wui/Maestro.Master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="w3-container w3-center w3-panel w3-blue">
        <h2 class="w3-opacity" style="text-shadow:2px 2px 0 #444">Procesar</h2>
    </div>
    <div>        
        <asp:Button ID="btn050" runat="server" Text="Generar Archivo 50%" />
        <asp:Button ID="btn100" runat="server" Text="Generar Archivo 100%" />
        <asp:Label ID="lblOk" runat="server" Text="" Visible="false" CssClass="w3-panel w3-blue"/>
        <asp:Label ID="lblError" runat="server" Text="" Visible="false" CssClass="w3-panel w3-red"/>
    </div>
    <br/>
    <div>
        <asp:GridView ID="gvProcesar" runat="server" AutoGenerateColumns="False">
        <HeaderStyle CssClass="w3-indigo w3-small" />
        <AlternatingRowStyle CssClass="w3-light-grey w3-small" />
        <RowStyle CssClass="w3-small" />
            <Columns>
                <asp:TemplateField HeaderText="Codigo">
                    <ItemTemplate>
                        <asp:Label ID="CodigoEmp" runat="server" Text='<%#Bind("CodigoEmp") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Cedula">
                    <ItemTemplate>
                        <asp:Label ID="Cedula" runat="server" Text='<%#Bind("Cedula") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Nombre">
                    <ItemTemplate>
                        <asp:Label ID="Nombre" runat="server" Text='<%#Bind("Nombre") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Apellido">
                    <ItemTemplate>
                        <asp:Label ID="Apellido" runat="server" Text='<%#Bind("Apellido") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Area">
                    <ItemTemplate>
                        <asp:Label ID="Area" runat="server" Text='<%#Bind("Area") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="AreaId" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="AreaId" runat="server" Text='<%#Bind("AreaId") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Departamento">
                    <ItemTemplate>
                        <asp:Label ID="Departamento" runat="server" Text='<%#Bind("Departamento") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="DepartamentoId" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="DepartamentoId" runat="server" Text='<%#Bind("DepartamentoId") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Aprobado" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:CheckBox ID="Aprobado" runat="server" checked='<%#Bind("Aprobado") %>' Enabled="false"/>
                    </ItemTemplate>
                </asp:TemplateField>                
            </Columns>
        </asp:GridView>
    </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
