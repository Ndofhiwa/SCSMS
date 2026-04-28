<%@ page import="com.mycompany.scsms.model.User" %>
<%
    User sidebarUser = (User) session.getAttribute("user");
    String currentRole = sidebarUser != null ? sidebarUser.getRole() : "";
%>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

<style>
    .sidebar {
        width: 240px;
        height: 100vh;
        background-color: #1a1a2e;
        position: fixed;
        top: 0;
        left: 0;
        display: flex;
        flex-direction: column;
        transition: width 0.3s ease;
        z-index: 1000;
        overflow: hidden;
    }
    .sidebar.collapsed { width: 60px; }

    .sidebar-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 16px;
        border-bottom: 1px solid #2a2a4a;
    }
    .sidebar-title {
        color: white;
        font-weight: bold;
        font-size: 16px;
        white-space: nowrap;
    }
    .toggle-btn {
        background: none;
        border: none;
        color: white;
        font-size: 20px;
        cursor: pointer;
        padding: 4px;
    }
    .toggle-btn:hover { color: #007bff; }

    .sidebar-user {
        display: flex;
        align-items: center;
        padding: 16px;
        border-bottom: 1px solid #2a2a4a;
    }
    .user-avatar {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        background-color: #007bff;
        color: white;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        flex-shrink: 0;
    }
    .user-info {
        margin-left: 10px;
        white-space: nowrap;
        overflow: hidden;
    }
    .user-name { color: white; font-size: 14px; font-weight: bold; }
    .user-role { color: #aaa; font-size: 12px; }

    .sidebar-nav {
        display: flex;
        flex-direction: column;
        padding: 16px 0;
        flex: 1;
        position: relative;
    }
    .nav-item {
        display: flex;
        align-items: center;
        padding: 12px 16px;
        color: #ccc;
        text-decoration: none;
        transition: background-color 0.2s;
        white-space: nowrap;
    }
    .nav-item:hover { background-color: #2a2a4a; color: white; }
    .nav-icon { font-size: 16px; flex-shrink: 0; width: 28px; text-align: center; }
    .nav-label { margin-left: 8px; font-size: 14px; }
    .nav-logout {
        color: #ff6b6b;
        position: absolute;
        bottom: 0;
        width: 100%;
    }
    .nav-logout:hover { background-color: #2a2a4a; color: #ff4444; }

    .sidebar.collapsed .nav-label,
    .sidebar.collapsed .sidebar-title,
    .sidebar.collapsed .user-info { display: none; }
    .sidebar.collapsed .sidebar-header { justify-content: center; }
    .sidebar.collapsed .sidebar-user { justify-content: center; }

    .main-content {
        margin-left: 240px;
        transition: margin-left 0.3s ease;
        min-height: 100vh;
    }
    .main-content.expanded { margin-left: 60px; }
</style>

<div id="sidebar" class="sidebar">
    <div class="sidebar-header">
        <span class="sidebar-title"><i class="fas fa-university"></i> SCSMS</span>
        <button class="toggle-btn" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>
    </div>



    <nav class="sidebar-nav">
        <% if (currentRole.equals("ADMIN") || currentRole.equals("STAFF")) { %>
            <a href="dashboard.jsp" class="nav-item">
                <span class="nav-icon"><i class="fas fa-tachometer-alt"></i></span>
                <span class="nav-label">Dashboard</span>
            </a>
            <% if (currentRole.equals("ADMIN")) { %>
            <a href="reports.jsp" class="nav-item">
                <span class="nav-icon"><i class="fas fa-chart-bar"></i></span>
                <span class="nav-label">Reports</span>
            </a>
            <% } %>
            <a href="submit.jsp" class="nav-item">
                <span class="nav-icon"><i class="fas fa-plus-circle"></i></span>
                <span class="nav-label">New Request</span>
            </a>
        <% } else { %>
            <a href="student.jsp" class="nav-item">
                <span class="nav-icon"><i class="fas fa-home"></i></span>
                <span class="nav-label">Dashboard</span>
            </a>
            <a href="submit.jsp" class="nav-item">
                <span class="nav-icon"><i class="fas fa-plus-circle"></i></span>
                <span class="nav-label">New Request</span>
            </a>
        <% } %>
        
            <div class="sidebar-user">
        <div class="user-avatar"><%= sidebarUser != null ? sidebarUser.getName().substring(0,1).toUpperCase() : "?" %></div>
        <div class="user-info">
            <div class="user-name"><%= sidebarUser != null ? sidebarUser.getName() : "" %></div>
            <div class="user-role"><%= currentRole %></div>
        </div>
    </div>

        <a href="logout" class="nav-item nav-logout">
            <span class="nav-icon"><i class="fas fa-sign-out-alt"></i></span>
            <span class="nav-label">Logout</span>
        </a>
    </nav>
</div>

<script>
    function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        const content = document.getElementById('mainContent');
        sidebar.classList.toggle('collapsed');
        if (content) content.classList.toggle('expanded');
    }
</script>