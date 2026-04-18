<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.scsms.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <title>SCSMS - Submit Request</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            margin: 0;
        }
        .page-content {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: calc(100vh - 60px);
        }
        .form-box {
            background-color: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            width: 450px;
        }
        h2 { text-align: center; color: #333; margin-bottom: 24px; }
        label { font-weight: bold; display: block; margin-bottom: 4px; }
        input, select, textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 16px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        textarea { height: 100px; resize: vertical; }
        button {
            width: 100%;
            padding: 10px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover { background-color: #218838; }
        .back { text-align: center; margin-top: 12px; }
        .back a { color: #007bff; text-decoration: none; }
    </style>
</head>
<body>
    <%@ page import="com.mycompany.scsms.model.User" %>
    <%
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
    %>
    <%
        User navUser = (User) session.getAttribute("user");
        String dashboardPage = (navUser != null && navUser.getRole().equals("ADMIN")) ? "dashboard.jsp" : "student.jsp";
    %>
    <div style="background-color:#007bff; color:white; padding:16px 24px; display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
        <strong>Smart Campus Service Management</strong>
        <div>
            <a href="<%= dashboardPage %>" style="color:white; text-decoration:none; background-color:#0056b3; padding:8px 16px; border-radius:4px; margin-left:8px;">Dashboard</a>
            <a href="logout" style="color:white; text-decoration:none; background-color:#0056b3; padding:8px 16px; border-radius:4px; margin-left:8px;">Logout</a>
        </div>
    </div>
            
          <div class="page-content">  
    <div class="form-box">
        <h2>Submit Service Request</h2>
        <form action="submitRequest" method="post">
            <label>Location</label>
            <input type="text" name="location" placeholder="e.g. Block B, Room 204" required />

            <label>Category</label>
            <select name="category" required>
                <option value="">-- Select Category --</option>
                <option value="Maintenance">Maintenance</option>
                <option value="IT Support">IT Support</option>
                <option value="Classroom Equipment">Classroom Equipment</option>
                <option value="General Inquiry">General Inquiry</option>
            </select>

            <label>Description</label>
            <textarea name="description" placeholder="Describe the issue..." required></textarea>

            <label>Priority</label>
            <select name="priority" required>
                <option value="">-- Select Priority --</option>
                <option value="LOW">Low</option>
                <option value="MEDIUM">Medium</option>
                <option value="HIGH">High</option>
            </select>

            <button type="submit">Submit Request</button>
        </form>
        <div class="back"><a href="dashboard.jsp">← Back to Dashboard</a></div>
    </div>
    </div>
</body>
</html>