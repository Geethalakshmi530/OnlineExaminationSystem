package com.exam.controller;

import java.io.IOException;

import com.exam.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validate input
        if (name == null || name.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || password == null || password.isEmpty()) {

            response.sendRedirect(
                    "register.jsp?error=All fields are required");
            return;
        }

        name = name.trim();
        email = email.trim().toLowerCase();

        // Validate password length
        if (password.length() < 6) {

            response.sendRedirect(
                    "register.jsp?error=Password must contain at least 6 characters");
            return;
        }

        // Check duplicate email
        if (userDAO.emailExists(email)) {

            response.sendRedirect(
                    "register.jsp?error=Email already registered");
            return;
        }

        // Register student
        boolean registered =
                userDAO.registerUser(name, email, password);

        if (registered) {

            response.sendRedirect(
                    "login.jsp?success=Registration successful. Wait for admin approval");

        } else {

            response.sendRedirect(
                    "register.jsp?error=Registration failed. Please try again");
        }
    }
}