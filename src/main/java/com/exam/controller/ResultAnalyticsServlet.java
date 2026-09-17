package com.exam.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import com.exam.dao.AuditLogDAO;
import com.exam.dao.ResultAnalyticsDAO;
import com.exam.model.ResultAnalytics;
import com.exam.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/results")
public class ResultAnalyticsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final ResultAnalyticsDAO analyticsDAO =
            new ResultAnalyticsDAO();

    private final AuditLogDAO auditLogDAO =
            new AuditLogDAO();


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }

        try {

            ResultAnalytics analytics =
                    analyticsDAO.getAnalytics();

            request.setAttribute(
                    "analytics",
                    analytics
            );

            Map<String, Integer> distribution =
                    analyticsDAO.getScoreDistribution();

            request.setAttribute(
                    "scoreDistribution",
                    distribution
            );

            List<Map<String, Object>> examPerformance =
                    analyticsDAO.getExamPerformance();

            request.setAttribute(
                    "examPerformance",
                    examPerformance
            );

            List<Map<String, Object>> topStudents =
                    analyticsDAO.getTopStudents();

            request.setAttribute(
                    "topStudents",
                    topStudents
            );

            List<Map<String, Object>> recentResults =
                    analyticsDAO.getRecentResults();

            request.setAttribute(
                    "recentResults",
                    recentResults
            );

            List<Map<String, Object>> suspiciousActivities =
                    analyticsDAO.getRecentSuspiciousActivity();

            request.setAttribute(
                    "suspiciousActivities",
                    suspiciousActivities
            );

            /*
             * Log that admin opened analytics.
             */
            User user =
                    getUser(request);

            if (user != null) {

                auditLogDAO.addLog(
                        user.getId(),
                        "VIEW_ANALYTICS",
                        "RESULTS",
                        null,
                        "Administrator opened Results & Analytics"
                );
            }

            request.getRequestDispatcher(
                    "/admin/results.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "pageError",
                    "Unable to load results analytics."
            );

            request.getRequestDispatcher(
                    "/admin/results.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }


    private boolean isAdmin(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=Please login first"
            );

            return false;
        }

        User user =
                (User) session.getAttribute(
                        "user"
                );

        if (user == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=Please login first"
            );

            return false;
        }

        if (!"ADMIN".equalsIgnoreCase(
                user.getRole())) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/student/dashboard.jsp?error=Access denied"
            );

            return false;
        }

        return true;
    }


    private User getUser(
            HttpServletRequest request) {

        HttpSession session =
                request.getSession(false);

        if (session == null) {
            return null;
        }

        return (User) session.getAttribute(
                "user"
        );
    }
}