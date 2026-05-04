<%@ page import="com.mycompany.scsms.model.Announcement" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.scsms.model.User" %>
<%@ page import="com.mycompany.scsms.model.ServiceRequest" %>
<%@ page import="com.mycompany.scsms.db.DBConnection" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>SCSMS - Staff Dashboard</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background-color: #f2f2f2; }
        .container { padding: 24px; max-width: 1200px; margin: 0 auto; }
        .section {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 24px;
            margin-bottom: 24px;
        }
        .cards {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }
        .card {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .card .count { font-size: 36px; font-weight: bold; }
        .card .label { font-size: 14px; color: #666; margin-top: 8px; }
        .card.total .count { color: #28a745; }
        .card.pending .count { color: #856404; }
        .card.inprogress .count { color: #004085; }
        .filter-bar { display: flex; gap: 8px; margin-bottom: 16px; }
        .filter-bar a button {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            background-color: #e9ecef;
            color: #333;
        }
        .filter-bar a button.active,
        .filter-bar a button:hover { background-color: #28a745; color: white; }
        table { width: 100%; border-collapse: collapse; }
        th { background-color: #28a745; color: white; padding: 12px; text-align: left; }
        td { padding: 12px; border-bottom: 1px solid #eee; }
        tr:last-child td { border-bottom: none; }
        tr:hover { background-color: #f9f9f9; }
        .location-cell { font-weight: bold; color: #28a745; }
        .badge { padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: bold; }
        .PENDING { background-color: #fff3cd; color: #856404; }
        .IN_PROGRESS { background-color: #cce5ff; color: #004085; }
        .COMPLETED { background-color: #d4edda; color: #155724; }
        .HIGH { color: red; font-weight: bold; }
        .MEDIUM { color: orange; font-weight: bold; }
        .LOW { color: green; font-weight: bold; }
        select, button[type="submit"] {
            padding: 6px 10px;
            border-radius: 4px;
            border: 1px solid #ccc;
            cursor: pointer;
        }
        button[type="submit"] { background-color: #28a745; color: white; border: none; }
        .empty { text-align: center; padding: 40px; color: #999; }
        h2 { margin-bottom: 16px; color: #333; }
        .dept-badge {
            background-color: #28a745;
            color: white;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            margin-left: 8px;
        }
    </style>
</head>
<body>
    <%@ include file="sidebar.jsp" %>
    <%
        User user = (User) session.getAttribute("user");
        if (user == null || !user.getRole().equals("STAFF")) {
            response.sendRedirect("login.jsp");
            return;
        }

        String department = user.getDepartment();

        // Fetch counts for this department
        int totalCount = 0, pendingCount = 0, inProgressCount = 0;
        try {
            Connection conn = DBConnection.getConnection();

            PreparedStatement ps1 = conn.prepareStatement("SELECT COUNT(*) FROM service_requests WHERE category = ?");
            ps1.setString(1, department);
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) totalCount = rs1.getInt(1);

            PreparedStatement ps2 = conn.prepareStatement("SELECT COUNT(*) FROM service_requests WHERE category = ? AND status='PENDING'");
            ps2.setString(1, department);
            ResultSet rs2 = ps2.executeQuery();
            if (rs2.next()) pendingCount = rs2.getInt(1);

            PreparedStatement ps3 = conn.prepareStatement("SELECT COUNT(*) FROM service_requests WHERE category = ? AND status='IN_PROGRESS'");
            ps3.setString(1, department);
            ResultSet rs3 = ps3.executeQuery();
            if (rs3.next()) inProgressCount = rs3.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Fetch requests for this department
        String filterStatus = request.getParameter("filterStatus");
        if (filterStatus == null) filterStatus = "ALL";

        List<ServiceRequest> requests = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt;

            if (filterStatus.equals("ALL")) {
                stmt = conn.prepareStatement("SELECT * FROM service_requests WHERE category = ? ORDER BY created_at DESC");
                stmt.setString(1, department);
            } else {
                stmt = conn.prepareStatement("SELECT * FROM service_requests WHERE category = ? AND status = ? ORDER BY created_at DESC");
                stmt.setString(1, department);
                stmt.setString(2, filterStatus);
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                requests.add(new ServiceRequest(
                    rs.getInt("id"),
                    rs.getInt("user_id"),
                    rs.getString("location"),
                    rs.getString("category"),
                    rs.getString("description"),
                    rs.getString("priority"),
                    rs.getString("status"),
                    rs.getString("created_at"),
                    rs.getInt("assigned_to")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>

    <div id="mainContent" class="main-content">
    <div class="container">

        <div class="section" style="padding:16px 24px; margin-bottom:16px;">
            <h2>Staff Dashboard <span class="dept-badge"><%= department %></span></h2>
        </div>

        <!-- SUMMARY CARDS -->
        <div class="cards">
            <div class="card total">
                <div class="count"><%= totalCount %></div>
                <div class="label">Total in My Department</div>
            </div>
            <div class="card pending">
                <div class="count"><%= pendingCount %></div>
                <div class="label">Pending</div>
            </div>
            <div class="card inprogress">
                <div class="count"><%= inProgressCount %></div>
                <div class="label">In Progress</div>
            </div>
        </div>

        <!-- REQUESTS TABLE -->
        <div class="section">
            <h2>📋 <%= department %> Requests</h2>

            <div class="filter-bar">
                <a href="staff.jsp?filterStatus=ALL"><button class="<%= filterStatus.equals("ALL") ? "active" : "" %>">All</button></a>
                <a href="staff.jsp?filterStatus=PENDING"><button class="<%= filterStatus.equals("PENDING") ? "active" : "" %>">Pending</button></a>
                <a href="staff.jsp?filterStatus=IN_PROGRESS"><button class="<%= filterStatus.equals("IN_PROGRESS") ? "active" : "" %>">In Progress</button></a>
                <a href="staff.jsp?filterStatus=COMPLETED"><button class="<%= filterStatus.equals("COMPLETED") ? "active" : "" %>">Completed</button></a>
            </div>

            <% if (requests.isEmpty()) { %>
                <div class="empty">No <%= department %> requests found.</div>
            <% } else { %>
            <table>
                <tr>
                    <th>#</th>
                    <th>Location</th>
                    <th>Description</th>
                    <th>Priority</th>
                    <th>Status</th>
                    <th>Date</th>
                    <th>Action</th>
                </tr>
                <% for (ServiceRequest req : requests) { %>
                <tr>
                    <td><%= req.getId() %></td>
                    <td class="location-cell"><i class="fas fa-map-marker-alt"></i> <%= req.getLocation() %></td>
                    <td><%= req.getDescription() %></td>
                    <td><span class="<%= req.getPriority() %>"><%= req.getPriority() %></span></td>
                    <td><span class="badge <%= req.getStatus() %>"><%= req.getStatus() %></span></td>
                    <td><%= req.getCreatedAt() %></td>
                    <td>
                        <form action="updateStatus" method="post">
                            <input type="hidden" name="requestId" value="<%= req.getId() %>" />
                            <select name="status">
                                <option value="PENDING" <%= req.getStatus().equals("PENDING") ? "selected" : "" %>>Pending</option>
                                <option value="IN_PROGRESS" <%= req.getStatus().equals("IN_PROGRESS") ? "selected" : "" %>>In Progress</option>
                                <option value="COMPLETED" <%= req.getStatus().equals("COMPLETED") ? "selected" : "" %>>Completed</option>
                            </select>
                            <button type="submit">Update</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </table>
            <% } %>
        </div>
    </div>
    
        
        
        <!-- ANNOUNCEMENTS -->
<div class="section">
    <h2>📢 Campus Announcements</h2>
    <%
        List<com.mycompany.scsms.model.Announcement> announcements = new ArrayList<>();
        try {
            Connection connAnn = DBConnection.getConnection();
            ResultSet rsAnn = connAnn.prepareStatement(
                "SELECT * FROM announcements ORDER BY created_at DESC"
            ).executeQuery();
            while (rsAnn.next()) {
                announcements.add(new com.mycompany.scsms.model.Announcement(
                    rsAnn.getInt("id"),
                    rsAnn.getString("title"),
                    rsAnn.getString("message"),
                    rsAnn.getInt("created_by"),
                    rsAnn.getString("created_at")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
    <% if (announcements.isEmpty()) { %>
        <div class="empty">No announcements at this time.</div>
    <% } else { %>
        <% for (com.mycompany.scsms.model.Announcement ann : announcements) { %>
        <div style="border-left:4px solid #007bff; border-radius:6px; padding:16px; margin-bottom:12px; background-color:#f0f7ff;">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
                <strong style="color:#007bff; font-size:16px;"><%= ann.getTitle() %></strong>
                <small style="color:#999;"><%= ann.getCreatedAt() %></small>
            </div>
            <p style="color:#333; font-size:14px;"><%= ann.getMessage() %></p>
        </div>
        <% } %>
    <% } %>
</div>
</div>
        
</body>
</html>