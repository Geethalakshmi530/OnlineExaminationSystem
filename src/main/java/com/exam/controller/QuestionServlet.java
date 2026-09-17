package com.exam.controller;

import java.io.IOException;

import com.exam.dao.QuestionDAO;
import com.exam.model.Question;
import com.exam.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/questions")
public class QuestionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final QuestionDAO questionDAO = new QuestionDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }

        String examIdParameter = request.getParameter("examId");

        if (examIdParameter == null
                || examIdParameter.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/exams?error=Please select an exam"
            );
            return;
        }

        int examId;

        try {
            examId = Integer.parseInt(examIdParameter);
        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/exams?error=Invalid exam ID"
            );
            return;
        }

        if (examId <= 0) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/exams?error=Invalid exam ID"
            );
            return;
        }

        request.setAttribute(
                "examId",
                examId
        );

        request.setAttribute(
                "questions",
                questionDAO.getQuestionsByExamId(examId)
        );

        request.getRequestDispatcher(
                "/admin/questions.jsp"
        ).forward(request, response);
    }

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

            redirectWithError(
                    request,
                    response,
                    0,
                    "Invalid request"
            );
            return;
        }

        if ("add".equalsIgnoreCase(action)) {
            addQuestion(request, response);
            return;
        }

        if ("update".equalsIgnoreCase(action)) {
            updateQuestion(request, response);
            return;
        }

        if ("delete".equalsIgnoreCase(action)) {
            deleteQuestion(request, response);
            return;
        }

        redirectWithError(
                request,
                response,
                getExamId(request),
                "Invalid action"
        );
    }

    private void addQuestion(HttpServletRequest request,
                             HttpServletResponse response)
            throws IOException {

        int examId = getExamId(request);

        if (examId <= 0) {
            redirectWithError(
                    request,
                    response,
                    0,
                    "Invalid exam ID"
            );
            return;
        }

        String questionText =
                request.getParameter("questionText");

        String optionA =
                request.getParameter("optionA");

        String optionB =
                request.getParameter("optionB");

        String optionC =
                request.getParameter("optionC");

        String optionD =
                request.getParameter("optionD");

        String correctAnswer =
                request.getParameter("correctAnswer");

        String validationError =
                validateQuestion(
                        questionText,
                        optionA,
                        optionB,
                        optionC,
                        optionD,
                        correctAnswer
                );

        if (validationError != null) {

            redirectWithError(
                    request,
                    response,
                    examId,
                    validationError
            );
            return;
        }

        Question question = new Question();

        question.setExamId(examId);
        question.setQuestionText(questionText.trim());
        question.setOptionA(optionA.trim());
        question.setOptionB(optionB.trim());
        question.setOptionC(optionC.trim());
        question.setOptionD(optionD.trim());
        question.setCorrectAnswer(
                correctAnswer.trim().toUpperCase()
        );

        boolean added =
                questionDAO.addQuestion(question);

        if (added) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/questions?examId="
                    + examId
                    + "&success=Question added successfully"
            );

        } else {

            redirectWithError(
                    request,
                    response,
                    examId,
                    "Unable to add question"
            );
        }
    }

    private void updateQuestion(HttpServletRequest request,
                                HttpServletResponse response)
            throws IOException {

        int examId = getExamId(request);

        if (examId <= 0) {
            redirectWithError(
                    request,
                    response,
                    0,
                    "Invalid exam ID"
            );
            return;
        }

        String questionIdParameter =
                request.getParameter("questionId");

        int questionId;

        try {
            questionId =
                    Integer.parseInt(questionIdParameter);
        } catch (NumberFormatException e) {

            redirectWithError(
                    request,
                    response,
                    examId,
                    "Invalid question ID"
            );
            return;
        }

        if (questionId <= 0) {

            redirectWithError(
                    request,
                    response,
                    examId,
                    "Invalid question ID"
            );
            return;
        }

        String questionText =
                request.getParameter("questionText");

        String optionA =
                request.getParameter("optionA");

        String optionB =
                request.getParameter("optionB");

        String optionC =
                request.getParameter("optionC");

        String optionD =
                request.getParameter("optionD");

        String correctAnswer =
                request.getParameter("correctAnswer");

        String validationError =
                validateQuestion(
                        questionText,
                        optionA,
                        optionB,
                        optionC,
                        optionD,
                        correctAnswer
                );

        if (validationError != null) {

            redirectWithError(
                    request,
                    response,
                    examId,
                    validationError
            );
            return;
        }

        Question question = new Question();

        question.setId(questionId);
        question.setExamId(examId);
        question.setQuestionText(questionText.trim());
        question.setOptionA(optionA.trim());
        question.setOptionB(optionB.trim());
        question.setOptionC(optionC.trim());
        question.setOptionD(optionD.trim());
        question.setCorrectAnswer(
                correctAnswer.trim().toUpperCase()
        );

        boolean updated =
                questionDAO.updateQuestion(question);

        if (updated) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/questions?examId="
                    + examId
                    + "&success=Question updated successfully"
            );

        } else {

            redirectWithError(
                    request,
                    response,
                    examId,
                    "Unable to update question"
            );
        }
    }

    private void deleteQuestion(HttpServletRequest request,
                                HttpServletResponse response)
            throws IOException {

        int examId = getExamId(request);

        if (examId <= 0) {
            redirectWithError(
                    request,
                    response,
                    0,
                    "Invalid exam ID"
            );
            return;
        }

        String questionIdParameter =
                request.getParameter("questionId");

        int questionId;

        try {
            questionId =
                    Integer.parseInt(questionIdParameter);
        } catch (NumberFormatException e) {

            redirectWithError(
                    request,
                    response,
                    examId,
                    "Invalid question ID"
            );
            return;
        }

        if (questionId <= 0) {

            redirectWithError(
                    request,
                    response,
                    examId,
                    "Invalid question ID"
            );
            return;
        }

        boolean deleted =
                questionDAO.deleteQuestion(
                        questionId,
                        examId
                );

        if (deleted) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/questions?examId="
                    + examId
                    + "&success=Question deleted successfully"
            );

        } else {

            redirectWithError(
                    request,
                    response,
                    examId,
                    "Unable to delete question"
            );
        }
    }

    private String validateQuestion(
            String questionText,
            String optionA,
            String optionB,
            String optionC,
            String optionD,
            String correctAnswer) {

        if (questionText == null
                || questionText.trim().isEmpty()) {

            return "Question text is required";
        }

        if (questionText.trim().length() > 500) {

            return "Question text cannot exceed 500 characters";
        }

        if (optionA == null || optionA.trim().isEmpty()) {
            return "Option A is required";
        }

        if (optionB == null || optionB.trim().isEmpty()) {
            return "Option B is required";
        }

        if (optionC == null || optionC.trim().isEmpty()) {
            return "Option C is required";
        }

        if (optionD == null || optionD.trim().isEmpty()) {
            return "Option D is required";
        }

        if (optionA.trim().length() > 255
                || optionB.trim().length() > 255
                || optionC.trim().length() > 255
                || optionD.trim().length() > 255) {

            return "Each option cannot exceed 255 characters";
        }

        if (correctAnswer == null
                || correctAnswer.trim().isEmpty()) {

            return "Please select the correct answer";
        }

        String answer =
                correctAnswer.trim().toUpperCase();

        if (!"A".equals(answer)
                && !"B".equals(answer)
                && !"C".equals(answer)
                && !"D".equals(answer)) {

            return "Correct answer must be A, B, C, or D";
        }

        return null;
    }

    private int getExamId(HttpServletRequest request) {

        String examIdParameter =
                request.getParameter("examId");

        if (examIdParameter == null
                || examIdParameter.trim().isEmpty()) {

            return 0;
        }

        try {
            return Integer.parseInt(examIdParameter);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private void redirectWithError(
            HttpServletRequest request,
            HttpServletResponse response,
            int examId,
            String message)
            throws IOException {

        String url =
                request.getContextPath()
                + "/admin/questions";

        if (examId > 0) {
            url += "?examId=" + examId
                    + "&error=" + message;
        } else {
            url += "?error=" + message;
        }

        response.sendRedirect(url);
    }

    private boolean isAdmin(HttpServletRequest request,
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
                (User) session.getAttribute("user");

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