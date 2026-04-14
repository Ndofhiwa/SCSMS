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

@WebServlet("/submitRequest")
public class RequestServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String location = request.getParameter("location");
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        String priority = request.getParameter("priority");

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO service_requests (user_id, location, category, description, priority) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, user.getId());
            stmt.setString(2, location);
            stmt.setString(3, category);
            stmt.setString(4, description);
            stmt.setString(5, priority);
            stmt.executeUpdate();

            response.sendRedirect("student.jsp");

        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}