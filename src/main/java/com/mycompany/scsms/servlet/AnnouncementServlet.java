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

@WebServlet("/announcement")
public class AnnouncementServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !user.getRole().equals("ADMIN")) {
            response.sendRedirect("login.jsp");
            return;
        }

        String title = request.getParameter("title");
        String message = request.getParameter("message");

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO announcements (title, message, created_by) VALUES (?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, title);
            stmt.setString(2, message);
            stmt.setInt(3, user.getId());
            stmt.executeUpdate();

            response.sendRedirect("dashboard.jsp");

        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}