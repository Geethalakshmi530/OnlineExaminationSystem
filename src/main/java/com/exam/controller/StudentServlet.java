package com.exam.controller;

import java.io.IOException;

import com.exam.dao.StudentDAO;
import com.exam.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/students")
public class StudentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final StudentDAO studentDAO = new StudentDAO();

    // =========================================================
    // GET - Display all students
    // =========================================================
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }

        request.setAttribute(
                "students",
                studentDAO.getAllStudents()
        );

        request.getRequestDispatcher(
                "/admin/students.jsp"
        ).forward(request, response);
    }

    // =========================================================
    // POST - Approve / Reject student
    // =========================================================
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        String studentIdParameter = request.getParameter("studentId");

        // Validate parameters
        if (action == null || studentIdParameter == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/students?error=Invalid request"
            );

            return;
        }

        int studentId;

        try {

            studentId = Integer.parseInt(studentIdParameter);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/students?error=Invalid student ID"
            );

            return;
        }

        boolean updated = false;

        // =====================================================
        // APPROVE STUDENT
        // =====================================================
        if ("approve".equalsIgnoreCase(action)) {

            updated = studentDAO.updateStudentStatus(
                    studentId,
                    "APPROVED"
            );

        }

        // =====================================================
        // REJECT STUDENT
        // =====================================================
        else if ("reject".equalsIgnoreCase(action)) {

            updated = studentDAO.updateStudentStatus(
                    studentId,
                    "REJECTED"
            );

        }

        // =====================================================
        // INVALID ACTION
        // =====================================================
        else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/students?error=Invalid action"
            );

            return;
        }

        // =====================================================
        // RESULT
        // =====================================================
        if (updated) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/students?success=Student status updated successfully"
            );

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/students?error=Unable to update student status"
            );
        }
    }

    // =========================================================
    // ADMIN SECURITY CHECK
    // =========================================================
    private boolean isAdmin(HttpServletRequest request,
                            HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=Please login first"
            );

            return false;
        }

        User user = (User) session.getAttribute("user");

        if (user == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=Please login first"
            );

            return false;
        }

        if (!"ADMIN".equalsIgnoreCase(user.getRole())) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=Access denied"
            );

            return false;
        }

        return true;
    }
}