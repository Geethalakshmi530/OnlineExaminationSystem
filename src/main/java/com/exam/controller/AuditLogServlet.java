package com.exam.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import com.exam.dao.AuditLogDAO;
import com.exam.model.AuditLog;
import com.exam.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/audit-logs")
public class AuditLogServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

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

        String search =
                request.getParameter("search");

        String action =
                request.getParameter("action");

        if (search == null) {
            search = "";
        }

        if (action == null) {
            action = "";
        }

        List<AuditLog> logs =
                auditLogDAO.getLogs(
                        search,
                        action
                );

        List<Map<String, Object>> summary =
                auditLogDAO.getActionSummary();

        request.setAttribute(
                "logs",
                logs
        );

        request.setAttribute(
                "actionSummary",
                summary
        );

        request.setAttribute(
                "totalLogs",
                auditLogDAO.getTotalLogs()
        );

        request.setAttribute(
                "searchValue",
                search
        );

        request.setAttribute(
                "actionValue",
                action
        );


        /*
         * Log the page view itself.
         */
        User user =
                getUser(request);

        if (user != null) {

            auditLogDAO.addLog(
                    user.getId(),
                    "VIEW_AUDIT_LOGS",
                    "AUDIT_LOG",
                    null,
                    "Administrator opened Audit Logs"
            );
        }


        request.getRequestDispatcher(
                "/admin/audit-logs.jsp"
        ).forward(
                request,
                response
        );
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