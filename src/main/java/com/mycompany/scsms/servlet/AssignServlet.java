package com.mycompany.scsms.servlet;

import com.mycompany.scsms.db.DBConnection;
import com.mycompany.scsms.model.User;
import com.mycompany.scsms.util.EmailService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/assignRequest")
public class AssignServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !user.getRole().equals("ADMIN")) {
            response.sendRedirect("login.jsp");
            return;
        }

        String requestId = request.getParameter("requestId");
        String staffId = request.getParameter("staffId");

        try {
            Connection conn = DBConnection.getConnection();

            // Update assigned_to
            String sql = "UPDATE service_requests SET assigned_to = ? WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(staffId));
            stmt.setInt(2, Integer.parseInt(requestId));
            stmt.executeUpdate();

            // Fetch staff email and name
            PreparedStatement staffStmt = conn.prepareStatement(
                "SELECT name, email FROM users WHERE id = ?"
            );
            staffStmt.setInt(1, Integer.parseInt(staffId));
            ResultSet rs = staffStmt.executeQuery();

            if (rs.next()) {
                String staffName = rs.getString("name");
                String staffEmail = rs.getString("email");
                EmailService.sendAssignmentNotification(staffEmail, staffName, requestId);
            }

            response.sendRedirect("dashboard.jsp");

        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}