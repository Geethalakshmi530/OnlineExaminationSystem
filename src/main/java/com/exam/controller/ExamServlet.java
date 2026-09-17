package com.exam.controller;

import java.io.IOException;

import com.exam.dao.ExamDAO;
import com.exam.model.Exam;
import com.exam.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/exams")
public class ExamServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final ExamDAO examDAO = new ExamDAO();

    // =========================================================
    // GET - Display all exams
    // =========================================================

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }

        request.setAttribute(
                "exams",
                examDAO.getAllExams()
        );

        request.getRequestDispatcher(
                "/admin/exams.jsp"
        ).forward(request, response);
    }

    // =========================================================
    // POST - Add / Update / Delete exam
    // =========================================================

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if (action == null || action.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/exams?error=Invalid request"
            );

            return;
        }

        // =====================================================
        // ADD EXAM
        // =====================================================

        if ("add".equalsIgnoreCase(action)) {

            addExam(request, response);
            return;
        }

        // =====================================================
        // UPDATE EXAM
        // =====================================================

        if ("update".equalsIgnoreCase(action)) {

            updateExam(request, response);
            return;
        }

        // =====================================================
        // DELETE EXAM
        // =====================================================

        if ("delete".equalsIgnoreCase(action)) {

            deleteExam(request, response);
            return;
        }

        // =====================================================
        // INVALID ACTION
        // =====================================================

        response.sendRedirect(
                request.getContextPath()
                + "/admin/exams?error=Invalid action"
        );
    }

    // =========================================================
    // ADD EXAM
    // =========================================================

    private void addExam(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        String examName = request.getParameter("examName");
        String durationParameter =
                request.getParameter("durationMinutes");
        String questionsParameter =
                request.getParameter("totalQuestions");

        // -----------------------------------------------------
        // Validate exam name
        // -----------------------------------------------------

        if (examName == null || examName.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/exams?error=Exam name is required"
            );

            return;
        }

        examName = examName.trim();

        // -----------------------------------------------------
        // Validate numeric values
        // -----------------------------------------------------

        int durationMinutes;
        int totalQuestions;

        try {

            durationMinutes =
                    Integer.parseInt(durationParameter);

            totalQuestions =
                    Integer.parseInt(questionsParameter);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/exams?error=Duration and question count must be valid numbers"
            );

            return;
        }

        // -----------------------------------------------------
        // Validate positive values
        // -----------------------------------------------------

        if (durationMinutes <= 0) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/exams?error=Duration must be greater than zero"
            );

            return;
        }

        if (totalQuestions <= 0) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/exams?error=Total questions must be greater than zero"
            );

            return;
        }

        // -----------------------------------------------------
        // Create Exam object
        // -----------------------------------------------------

        Exam exam = new Exam();

        exam.setExamName(examName);
        exam.setDurationMinutes(durationMinutes);
        exam.setTotalQuestions(totalQuestions);

        // -----------------------------------------------------
        // Save exam
        // -----------------------------------------------------

        boolean added = examDAO.addExam(exam);

        if (added) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/exams?success=Exam created successfully"
            );

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/exams?error=Unable to create exam"
            );
        }
    }

    // =========================================================
    // UPDATE EXAM
    // =========================================================

    private void updateExam(HttpServletRequest request,
                            HttpServletResponse response)
            throws IOException {

        String idParameter =
                request.getParameter("examId");

        String examName =
                request.getParameter("examName");

        String durationParameter =
                request.getParameter("durationMinutes");

        String questionsParameter =
                request.getParameter("totalQuestions");

        // -----------------------------------------------------
        // Validate ID
        // -----------------------------------------------------

        int examId;

        try {

            examId = Integer.parseInt(idParameter);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/exams?error=Invalid exam ID"
            );

            return;
        }

        // -----------------------------------------------------
        // Validate exam name
        // -----------------------------------------------------

        if (examName == null || examName.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/exams?error=Exam name is required"
            );

            return;
        }

        examName = examName.trim();

        // -----------------------------------------------------
        // Validate numeric values
        // -----------------------------------------------------

        int durationMinutes;
        int totalQuestions;

        try {

            durationMinutes =
                    Integer.parseInt(durationParameter);

            totalQuestions =
                    Integer.parseInt(questionsParameter);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/exams?error=Duration and question count must be valid numbers"
            );

            return;
        }

        // -----------------------------------------------------
        // Validate positive values
        // -----------------------------------------------------

        if (durationMinutes <= 0) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/exams?error=Duration must be greater than zero"
            );

            return;
        }

        if (totalQuestions <= 0) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/exams?error=Total questions must be greater than zero"
            );

            return;
        }

        // -----------------------------------------------------
        // Create Exam object
        // -----------------------------------------------------

        Exam exam = new Exam();

        exam.setId(examId);
        exam.setExamName(examName);
        exam.setDurationMinutes(durationMinutes);
        exam.setTotalQuestions(totalQuestions);

        // -----------------------------------------------------
        // Update exam
        // -----------------------------------------------------

        boolean updated = examDAO.updateExam(exam);

        if (updated) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/exams?success=Exam updated successfully"
            );

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/exams?error=Unable to update exam"
            );
        }
    }

    // =========================================================
    // DELETE EXAM
    // =========================================================

    private void deleteExam(HttpServletRequest request,
                            HttpServletResponse response)
            throws IOException {

        String idParameter =
                request.getParameter("examId");

        int examId;

        try {

            examId = Integer.parseInt(idParameter);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/exams?error=Invalid exam ID"
            );

            return;
        }

        boolean deleted =
                examDAO.deleteExam(examId);

        if (deleted) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/exams?success=Exam deleted successfully"
            );

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/exams?error=Unable to delete exam"
            );
        }
    }

    // =========================================================
    // ADMIN SECURITY CHECK
    // =========================================================

    private boolean isAdmin(HttpServletRequest request,
                            HttpServletResponse response)
            throws IOException {

        HttpSession session =
                request.getSession(false);

        // -----------------------------------------------------
        // No active session
        // -----------------------------------------------------

        if (session == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=Please login first"
            );

            return false;
        }

        // -----------------------------------------------------
        // No logged-in user
        // -----------------------------------------------------

        User user =
                (User) session.getAttribute("user");

        if (user == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=Please login first"
            );

            return false;
        }

        // -----------------------------------------------------
        // Only ADMIN can access exam management
        // -----------------------------------------------------

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