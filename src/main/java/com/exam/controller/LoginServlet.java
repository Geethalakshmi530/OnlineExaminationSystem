package com.exam.controller;

import java.io.IOException;
import com.exam.dao.UserDAO;
import com.exam.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validate input
        if (email == null || email.trim().isEmpty()
                || password == null || password.isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=Email and password are required");
            return;
        }

        email = email.trim().toLowerCase();

        // Authenticate user
        User user = userDAO.loginUser(email, password);
       
        if (user != null) {
            System.out.println("LOGIN DEBUG: email=" + user.getEmail()
                    + " | role=" + user.getRole()
                    + " | status=" + user.getStatus());
        }


        if (user == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=Invalid email or password");
            return;
        }

        // Check account status
        if (!"APPROVED".equalsIgnoreCase(user.getStatus())) {

            if ("PENDING".equalsIgnoreCase(user.getStatus())) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/login.jsp?error=Your account is waiting for admin approval");

            } else if ("REJECTED".equalsIgnoreCase(user.getStatus())) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/login.jsp?error=Your registration was rejected");

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/login.jsp?error=Your account is not active");
            }

            return;
        }

        // Create session
        HttpSession session = request.getSession();

        // Prevent session fixation
        request.changeSessionId();

        // Session timeout: 30 minutes
        session.setMaxInactiveInterval(30 * 60);

        // Store user information in session
        session.setAttribute("user", user);

        // Role-based redirection
        if ("ADMIN".equalsIgnoreCase(user.getRole())) {

            response.sendRedirect(
                    request.getContextPath()
                     + "/dashboard");

        } else if ("STUDENT".equalsIgnoreCase(user.getRole())) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/student/dashboard.jsp");

        } else {

            session.invalidate();

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=Invalid user role");
        }
    }
}