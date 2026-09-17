package com.exam.controller;

import java.io.IOException;

import com.exam.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/student/profile")
public class StudentProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // Get existing session
        HttpSession session = request.getSession(false);

        // Check login
        if (session == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=Please login first"
            );
            return;
        }

        // Get logged-in user
        User user = (User) session.getAttribute("user");

        // Check user
        if (user == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=Please login first"
            );
            return;
        }

        // Only STUDENT can access this page
        if (!"STUDENT".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/dashboard.jsp?error=Access denied"
            );
            return;
        }

        // Send user to profile.jsp
        request.setAttribute("user", user);

        request.getRequestDispatcher(
                "/student/profile.jsp"
        ).forward(request, response);
    }
}