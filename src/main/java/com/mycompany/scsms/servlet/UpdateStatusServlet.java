package com.mycompany.scsms.servlet;

import com.mycompany.scsms.db.DBConnection;
import com.mycompany.scsms.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import com.mycompany.scsms.util.EmailService;
import java.sql.ResultSet;

@WebServlet("/updateStatus")
public class UpdateStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || (!user.getRole().equals("ADMIN") && !user.getRole().equals("STAFF"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String requestId = request.getParameter("requestId");
        String status = request.getParameter("status");

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE service_requests SET status = ? WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            stmt.setInt(2, Integer.parseInt(requestId));
stmt.executeUpdate();

// Fetch the student's email and name
String fetchSql = "SELECT u.email, u.name FROM users u " +
                  "JOIN service_requests sr ON u.id = sr.user_id " +
                  "WHERE sr.id = ?";
PreparedStatement fetchStmt = conn.prepareStatement(fetchSql);
fetchStmt.setInt(1, Integer.parseInt(requestId));
ResultSet rs = fetchStmt.executeQuery();

if (rs.next()) {
    String studentEmail = rs.getString("email");
    String studentName = rs.getString("name");
    EmailService.sendStatusUpdate(studentEmail, studentName, status);
}

if (user.getRole().equals("STAFF")) {
    
    response.sendRedirect("dashboard.jsp");
}
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}