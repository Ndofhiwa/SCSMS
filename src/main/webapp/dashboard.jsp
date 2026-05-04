<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.scsms.model.Announcement" %>
<%@ page import="com.mycompany.scsms.model.User" %>
<%@ page import="com.mycompany.scsms.model.ServiceRequest" %>
<%@ page import="com.mycompany.scsms.db.DBConnection" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>SCSMS - Admin Dashboard</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background-color: #f2f2f2; }
        .container { padding: 24px; max-width: 1200px; margin: 0 auto; }
        .cards {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
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
        .card.total .count { color: #007bff; }
        .card.pending .count { color: #856404; }
        .card.inprogress .count { color: #004085; }
        .card.completed .count { color: #155724; }
        .section {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 24px;
            margin-bottom: 24px;
        }
        .filter-bar { display: flex; gap: 8px; margin-bottom: 16px; }
        .filter-bar button {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            background-color: #e9ecef;
            color: #333;
        }
        .filter-bar button.active { background-color: #007bff; color: white; }
        .filter-bar button:hover { background-color: #007bff; color: white; }
        table { width: 100%; border-collapse: collapse; }
        th { background-color: #007bff; color: white; padding: 12px; text-align: left; }
        td { padding: 12px; border-bottom: 1px solid #eee; vertical-align: top; }
        tr:last-child td { border-bottom: none; }
        tr:hover { background-color: #f9f9f9; }
        .location-cell { font-weight: bold; color: #007bff; }
        .badge { padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: bold; }
        .PENDING { background-color: #fff3cd; color: #856404; }
        .IN_PROGRESS { background-color: #cce5ff; color: #004085; }
        .COMPLETED { background-color: #d4edda; color: #155724; }
        .HIGH { color: red; font-weight: bold; }
        .MEDIUM { color: orange; font-weight: bold; }
        .LOW { color: green; font-weight: bold; }
        select { padding: 6px 10px; border-radius: 4px; border: 1px solid #ccc; cursor: pointer; }
        button[type="submit"] { padding: 6px 10px; border-radius: 4px; border: none; cursor: pointer; background-color: #007bff; color: white; }
        .empty { text-align: center; padding: 40px; color: #999; }
        h2 { margin-bottom: 16px; color: #333; }
    </style>
</head>
<body>
    <%
        User user = (User) session.getAttribute("user");
        if (user == null || !user.getRole().equals("ADMIN")) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Fetch counts
        int totalCount = 0, pendingCount = 0, inProgressCount = 0, completedCount = 0;
        try {
            Connection conn = DBConnection.getConnection();
            ResultSet rs1 = conn.prepareStatement("SELECT COUNT(*) FROM service_requests").executeQuery();
            if (rs1.next()) totalCount = rs1.getInt(1);
            ResultSet rs2 = conn.prepareStatement("SELECT COUNT(*) FROM service_requests WHERE status='PENDING'").executeQuery();
            if (rs2.next()) pendingCount = rs2.getInt(1);
            ResultSet rs3 = conn.prepareStatement("SELECT COUNT(*) FROM service_requests WHERE status='IN_PROGRESS'").executeQuery();
            if (rs3.next()) inProgressCount = rs3.getInt(1);
            ResultSet rs4 = conn.prepareStatement("SELECT COUNT(*) FROM service_requests WHERE status='COMPLETED'").executeQuery();
            if (rs4.next()) completedCount = rs4.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Fetch requests with optional filter
        String filterStatus = request.getParameter("filterStatus");
        if (filterStatus == null) filterStatus = "ALL";

        List<ServiceRequest> requests = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt;
            if (filterStatus.equals("ALL")) {
                stmt = conn.prepareStatement("SELECT * FROM service_requests ORDER BY created_at DESC");
            } else {
                stmt = conn.prepareStatement("SELECT * FROM service_requests WHERE status = ? ORDER BY created_at DESC");
                stmt.setString(1, filterStatus);
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

        // Fetch staff grouped by department
        Map<String, List<User>> staffByDept = new HashMap<>();
        try {
            Connection connStaff = DBConnection.getConnection();
            PreparedStatement staffStmt = connStaff.prepareStatement(
                "SELECT * FROM users WHERE role = 'STAFF' ORDER BY department, name"
            );
            ResultSet rsStaff = staffStmt.executeQuery();
            while (rsStaff.next()) {
                User staffMember = new User(
                    rsStaff.getInt("id"),
                    rsStaff.getString("name"),
                    rsStaff.getString("email"),
                    rsStaff.getString("password"),
                    rsStaff.getString("role"),
                    rsStaff.getString("department")
                );
                String dept = staffMember.getDepartment();
                if (dept == null) dept = "General";
                staffByDept.computeIfAbsent(dept, k -> new ArrayList<>()).add(staffMember);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Fetch announcements
        List<Announcement> announcements = new ArrayList<>();
        try {
            Connection connAnn = DBConnection.getConnection();
            ResultSet rsAnn = connAnn.prepareStatement(
                "SELECT * FROM announcements ORDER BY created_at DESC"
            ).executeQuery();
            while (rsAnn.next()) {
                announcements.add(new Announcement(
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

    <%@ include file="sidebar.jsp" %>

    <div id="mainContent" class="main-content">
    <div class="container">

        <!-- SUMMARY CARDS -->
        <div class="cards">
            <div class="card total">
                <div class="count"><%= totalCount %></div>
                <div class="label">Total Requests</div>
            </div>
            <div class="card pending">
                <div class="count"><%= pendingCount %></div>
                <div class="label">Pending</div>
            </div>
            <div class="card inprogress">
                <div class="count"><%= inProgressCount %></div>
                <div class="label">In Progress</div>
            </div>
            <div class="card completed">
                <div class="count"><%= completedCount %></div>
                <div class="label">Completed</div>
            </div>
        </div>

        <!-- REQUESTS TABLE -->
        <div class="section">
            <h2>📋 Service Requests</h2>
            <div class="filter-bar">
                <a href="dashboard.jsp?filterStatus=ALL"><button class="<%= filterStatus.equals("ALL") ? "active" : "" %>">All</button></a>
                <a href="dashboard.jsp?filterStatus=PENDING"><button class="<%= filterStatus.equals("PENDING") ? "active" : "" %>">Pending</button></a>
                <a href="dashboard.jsp?filterStatus=IN_PROGRESS"><button class="<%= filterStatus.equals("IN_PROGRESS") ? "active" : "" %>">In Progress</button></a>
                <a href="dashboard.jsp?filterStatus=COMPLETED"><button class="<%= filterStatus.equals("COMPLETED") ? "active" : "" %>">Completed</button></a>
            </div>

            <% if (requests.isEmpty()) { %>
                <div class="empty">No requests found.</div>
            <% } else { %>
            <table>
                <tr>
                    <th>#</th>
                    <th>Category</th>
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
                    <td><%= req.getCategory() %></td>
                    <td class="location-cell">📍 <%= req.getLocation() %></td>
                    <td><%= req.getDescription() %></td>
                    <td><span class="<%= req.getPriority() %>"><%= req.getPriority() %></span></td>
                    <td><span class="badge <%= req.getStatus() %>"><%= req.getStatus() %></span></td>
                    <td><%= req.getCreatedAt() %></td>
                    <td>
                        <form action="updateStatus" method="post" style="margin-bottom:8px;">
                            <input type="hidden" name="requestId" value="<%= req.getId() %>" />
                            <select name="status">
                                <option value="PENDING" <%= req.getStatus().equals("PENDING") ? "selected" : "" %>>Pending</option>
                                <option value="IN_PROGRESS" <%= req.getStatus().equals("IN_PROGRESS") ? "selected" : "" %>>In Progress</option>
                                <option value="COMPLETED" <%= req.getStatus().equals("COMPLETED") ? "selected" : "" %>>Completed</option>
                            </select>
                            <button type="submit">Update</button>
                        </form>
                        <form action="assignRequest" method="post">
                            <input type="hidden" name="requestId" value="<%= req.getId() %>" />
                            <select name="staffId">
                                <option value="">-- Assign to Staff --</option>
                                <%
                                    String reqCategory = req.getCategory();
                                    List<User> relevantStaff = staffByDept.get(reqCategory);
                                    if (relevantStaff != null) {
                                        for (User staffMember : relevantStaff) {
                                %>
                                    <option value="<%= staffMember.getId() %>"
                                        <%= req.getAssignedTo() == staffMember.getId() ? "selected" : "" %>>
                                        <%= staffMember.getName() %>
                                    </option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                            <button type="submit">Assign</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </table>
            <% } %>
        </div>

        <!-- ANNOUNCEMENTS SECTION -->
        <div class="section">
            <h2>📢 Campus Announcements</h2>
            <form action="announcement" method="post" style="margin-bottom:24px;">
                <div style="display:flex; flex-direction:column; gap:12px;">
                    <input
                        type="text"
                        name="title"
                        placeholder="Announcement title..."
                        required
                        style="padding:10px; border:1px solid #ccc; border-radius:4px; font-size:14px;"
                    />
                    <textarea
                        name="message"
                        placeholder="Write your announcement here..."
                        required
                        style="padding:10px; border:1px solid #ccc; border-radius:4px; font-size:14px; height:80px; resize:vertical;"
                    ></textarea>
                    <button
                        type="submit"
                        style="padding:10px; background-color:#007bff; color:white; border:none; border-radius:4px; cursor:pointer; font-size:14px; width:150px;"
                    >Post Announcement</button>
                </div>
            </form>

            <% if (announcements.isEmpty()) { %>
                <div class="empty">No announcements yet.</div>
            <% } else { %>
                <% for (Announcement ann : announcements) { %>
                <div style="border:1px solid #ddd; border-radius:6px; padding:16px; margin-bottom:12px; background-color:#f9f9f9;">
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
    </div>

    <script>
        const params = new URLSearchParams(window.location.search);
        const status = params.get('filterStatus') || 'ALL';
        document.querySelectorAll('.filter-bar button').forEach(btn => {
            btn.classList.remove('active');
        });
    </script>
</body>
</html>