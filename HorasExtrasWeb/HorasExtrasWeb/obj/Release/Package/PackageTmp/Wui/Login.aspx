<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="Maestro.Master" CodeBehind="Login.aspx.vb" 
    Inherits="HorasExtrasWeb.Login"%>
<%@ MasterType virtualpath="Maestro.Master" %>
<%@ OutputCache Location="None" NoStore="true" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <div class="w3-container w3-center w3-panel w3-blue">
        <h2 class="w3-opacity" style="text-shadow:2px 2px 0 #444">Iniciar sesión</h2>
    </div>
    <br />        
        <div class="w3-row w3-section">
            <div class="w3-rest">
                <label>Dominio</label>
                <div class="w3-col" style="width:50px"><i class="w3-xxlarge fa fa-home"></i></div>
                <asp:TextBox ID="txtDomain" Runat="server" Text="CENTRAL" class="w3-input w3-border" style="width:20%" />
            </div>
            <div class="w3-col" style="width:50px"><i class="w3-xxlarge fa fa-user"></i></div>
            <div class="w3-rest">
                <asp:TextBox ID="txtUsername" Runat="server" class="w3-input w3-border" style="width:20%" placeholder="Nombre de Usuario" />
            </div>
            <div class="w3-col" style="width:50px"><i class="w3-xxlarge fa fa-pencil"></i></div>
            <div class="w3-rest">
                <asp:TextBox ID="txtPassword" Runat="server" TextMode="Password" class="w3-input w3-border" style="width:20%" 
                    placeholder="Contraseña"/>
            </div>
            <asp:Button ID="btnLogin" Runat="server" Text="Inicio de sesión" OnClick="Login_Click" 
                class="w3-button w3-blue-grey w3-section w3-ripple w3-padding" />
        </div>

    <br />
    <div class="w3-panel w3-pale-red">
        <asp:Label ID="errorLabel" Runat="server" ForeColor="#ff3300"></asp:Label>
    </div> 
    <br>
    <br>
    <br>
    <br>
    <br>
    </asp:Content>
