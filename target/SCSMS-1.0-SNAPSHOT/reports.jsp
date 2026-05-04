<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.scsms.model.User" %>
<%@ page import="com.mycompany.scsms.db.DBConnection" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>SCSMS - Reports</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background-color: #f2f2f2; }

        .navbar {
            background-color: #007bff;
            color: white;
            padding: 16px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .navbar a {
            color: white;
            text-decoration: none;
            background-color: #0056b3;
            padding: 8px 16px;
            border-radius: 4px;
            margin-left: 8px;
        }
        .navbar a:hover { background-color: #003d82; }

        .container { padding: 24px; max-width: 1200px; margin: 0 auto; }

        h2 { color: #333; margin-bottom: 24px; }

        .charts-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 24px;
            margin-bottom: 24px;
        }

        .chart-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 24px;
        }

        .chart-card h3 {
            color: #333;
            margin-bottom: 16px;
            font-size: 16px;
        }

        .full-width {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 24px;
            margin-bottom: 24px;
        }
    </style>
</head>
<body>
    <%
        User user = (User) session.getAttribute("user");
        if (user == null || !user.getRole().equals("ADMIN")) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Fetch data for charts
        int pending = 0, inProgress = 0, completed = 0;
        int maintenance = 0, itSupport = 0, classroom = 0, general = 0;
        int high = 0, medium = 0, low = 0;

        try {
            Connection conn = DBConnection.getConnection();

            // Status counts
            ResultSet rs1 = conn.prepareStatement("SELECT COUNT(*) FROM service_requests WHERE status='PENDING'").executeQuery();
            if (rs1.next()) pending = rs1.getInt(1);

            ResultSet rs2 = conn.prepareStatement("SELECT COUNT(*) FROM service_requests WHERE status='IN_PROGRESS'").executeQuery();
            if (rs2.next()) inProgress = rs2.getInt(1);

            ResultSet rs3 = conn.prepareStatement("SELECT COUNT(*) FROM service_requests WHERE status='COMPLETED'").executeQuery();
            if (rs3.next()) completed = rs3.getInt(1);

            // Category counts
            ResultSet rs4 = conn.prepareStatement("SELECT COUNT(*) FROM service_requests WHERE category='Maintenance'").executeQuery();
            if (rs4.next()) maintenance = rs4.getInt(1);

            ResultSet rs5 = conn.prepareStatement("SELECT COUNT(*) FROM service_requests WHERE category='IT Support'").executeQuery();
            if (rs5.next()) itSupport = rs5.getInt(1);

            ResultSet rs6 = conn.prepareStatement("SELECT COUNT(*) FROM service_requests WHERE category='Classroom Equipment'").executeQuery();
            if (rs6.next()) classroom = rs6.getInt(1);

            ResultSet rs7 = conn.prepareStatement("SELECT COUNT(*) FROM service_requests WHERE category='General Inquiry'").executeQuery();
            if (rs7.next()) general = rs7.getInt(1);

            // Priority counts
            ResultSet rs8 = conn.prepareStatement("SELECT COUNT(*) FROM service_requests WHERE priority='HIGH'").executeQuery();
            if (rs8.next()) high = rs8.getInt(1);

            ResultSet rs9 = conn.prepareStatement("SELECT COUNT(*) FROM service_requests WHERE priority='MEDIUM'").executeQuery();
            if (rs9.next()) medium = rs9.getInt(1);

            ResultSet rs10 = conn.prepareStatement("SELECT COUNT(*) FROM service_requests WHERE priority='LOW'").executeQuery();
            if (rs10.next()) low = rs10.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
    %>

<%@ include file="sidebar.jsp" %>

<div id="mainContent" class="main-content">
<div class="container">
        <h2>📊 Service Request Reports</h2>

        <div class="charts-grid">
            <!-- Status Chart -->
            <div class="chart-card">
                <h3>Requests by Status</h3>
                <canvas id="statusChart"></canvas>
            </div>

            <!-- Priority Chart -->
            <div class="chart-card">
                <h3>Requests by Priority</h3>
                <canvas id="priorityChart"></canvas>
            </div>
        </div>

        <!-- Category Chart -->
        <div class="full-width">
            <h3>Requests by Category</h3>
            <canvas id="categoryChart" style="max-height: 300px;"></canvas>
        </div>
    </div>

    <script>
        // Status Pie Chart
        new Chart(document.getElementById('statusChart'), {
            type: 'pie',
            data: {
                labels: ['Pending', 'In Progress', 'Completed'],
                datasets: [{
                    data: [<%= pending %>, <%= inProgress %>, <%= completed %>],
                    backgroundColor: ['#ffc107', '#007bff', '#28a745'],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { position: 'bottom' }
                }
            }
        });

        // Priority Doughnut Chart
        new Chart(document.getElementById('priorityChart'), {
            type: 'doughnut',
            data: {
                labels: ['High', 'Medium', 'Low'],
                datasets: [{
                    data: [<%= high %>, <%= medium %>, <%= low %>],
                    backgroundColor: ['#dc3545', '#fd7e14', '#28a745'],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { position: 'bottom' }
                }
            }
        });

        // Category Bar Chart
        new Chart(document.getElementById('categoryChart'), {
            type: 'bar',
            data: {
                labels: ['Maintenance', 'IT Support', 'Classroom Equipment', 'General Inquiry'],
                datasets: [{
                    label: 'Number of Requests',
                    data: [<%= maintenance %>, <%= itSupport %>, <%= classroom %>, <%= general %>],
                    backgroundColor: ['#007bff', '#28a745', '#ffc107', '#17a2b8'],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { stepSize: 1 }
                    }
                }
            }
        });
    </script>
    </div>
</body>
</html>