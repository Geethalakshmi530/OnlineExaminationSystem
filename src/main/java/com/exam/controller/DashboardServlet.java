package com.exam.controller;

import java.io.IOException;

import com.exam.dao.DashboardDAO;
import com.exam.model.Dashboard;
import com.exam.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final DashboardDAO dashboardDAO = new DashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Get existing session
        HttpSession session = request.getSession(false);

        // Check whether user is logged in
        if (session == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=Please login first");
            return;
        }

        // Get logged-in user
        User user = (User) session.getAttribute("user");

        // Check user object
        if (user == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=Please login first");
            return;
        }

        // Dashboard is only for ADMIN
        if (!"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/student/dashboard.jsp?error=Access denied");
            return;
        }

        // Get dashboard data from database through DAO
        Dashboard dashboard = new Dashboard();

        dashboard.setTotalStudents(
                dashboardDAO.getTotalStudents());

        dashboard.setActiveExams(
                dashboardDAO.getActiveExams());

        dashboard.setTotalQuestions(
                dashboardDAO.getTotalQuestions());

        dashboard.setTotalExamAttempts(
                dashboardDAO.getTotalExamAttempts());

        // Send dashboard data to JSP
        request.setAttribute("dashboard", dashboard);

        // Send logged-in user information to JSP
        request.setAttribute("user", user);

        // Open dashboard JSP
        request.getRequestDispatcher(
                "/admin/dashboard.jsp")
                .forward(request, response);
    }
}