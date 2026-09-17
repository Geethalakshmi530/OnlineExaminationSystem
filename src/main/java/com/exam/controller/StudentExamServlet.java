package com.exam.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.exam.dao.ExamDAO;
import com.exam.dao.QuestionDAO;
import com.exam.model.Exam;
import com.exam.model.Question;
import com.exam.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/student/exam")
public class StudentExamServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final ExamDAO examDAO = new ExamDAO();
    private final QuestionDAO questionDAO = new QuestionDAO();


    // =========================================================
    // OPEN EXAM
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // Student security check
        if (!isStudent(request, response)) {
            return;
        }


        // =====================================================
        // GET EXAM ID
        // =====================================================

        String examIdParameter =
                request.getParameter("examId");

        if (examIdParameter == null ||
            examIdParameter.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/student/dashboard.jsp?error=Exam not selected"
            );

            return;
        }


        int examId;

        try {

            examId =
                    Integer.parseInt(
                            examIdParameter.trim()
                    );

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/student/dashboard.jsp?error=Invalid exam"
            );

            return;
        }


        // =====================================================
        // GET EXAM FROM DATABASE
        // =====================================================

        Exam exam =
                examDAO.getExamById(examId);

        if (exam == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/student/dashboard.jsp?error=Exam not found"
            );

            return;
        }


        // =====================================================
        // GET ALL QUESTIONS
        // =====================================================

        List<Question> allQuestions =
                questionDAO.getQuestionsByExamId(examId);

        if (allQuestions == null ||
            allQuestions.isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/student/dashboard.jsp?error=No questions available"
            );

            return;
        }


        // =====================================================
        // GET SESSION
        // =====================================================

        HttpSession session =
                request.getSession();


        // =====================================================
        // SELECT QUESTIONS
        // =====================================================

        List<Question> selectedQuestions =
                new ArrayList<>();


        String questionSessionKey =
                "exam_" + examId + "_questionIds";


        Object storedQuestionObject =
                session.getAttribute(
                        questionSessionKey
                );


        // =====================================================
        // IF QUESTIONS ALREADY EXIST IN SESSION
        // KEEP THE SAME QUESTIONS
        // =====================================================

        if (storedQuestionObject instanceof List<?>) {

            List<?> storedList =
                    (List<?>) storedQuestionObject;


            for (Object object : storedList) {

                if (object instanceof Integer) {

                    int questionId =
                            (Integer) object;


                    for (Question question :
                            allQuestions) {

                        if (question.getId() ==
                                questionId) {

                            selectedQuestions.add(
                                    question
                            );

                            break;
                        }
                    }
                }
            }
        }


        // =====================================================
        // IF NO QUESTIONS IN SESSION
        // SELECT QUESTIONS FOR NEW EXAM
        // =====================================================

        if (selectedQuestions.isEmpty()) {

            int numberOfQuestions =
                    exam.getTotalQuestions();


            if (numberOfQuestions <= 0) {

                numberOfQuestions =
                        allQuestions.size();
            }


            if (numberOfQuestions >
                    allQuestions.size()) {

                numberOfQuestions =
                        allQuestions.size();
            }


            for (int i = 0;
                 i < numberOfQuestions;
                 i++) {

                selectedQuestions.add(
                        allQuestions.get(i)
                );
            }


            // =================================================
            // STORE QUESTION IDS IN SESSION
            // =================================================

            List<Integer> questionIds =
                    new ArrayList<>();


            for (Question question :
                    selectedQuestions) {

                questionIds.add(
                        question.getId()
                );
            }


            session.setAttribute(
                    questionSessionKey,
                    questionIds
            );
        }


        // =====================================================
        // CHECK WHETHER EXAM HAS STARTED
        // =====================================================

        String startTimeSessionKey =
                "exam_" + examId + "_startTime";


        Object startTimeObject =
                session.getAttribute(
                        startTimeSessionKey
                );


        boolean examStarted =
                startTimeObject != null;


        // =====================================================
        // CALCULATE REMAINING TIME
        // =====================================================

        long remainingSeconds =
                exam.getDurationMinutes() * 60L;


        if (examStarted &&
            startTimeObject instanceof Long) {

            long startTime =
                    (Long) startTimeObject;


            long elapsedMilliseconds =
                    System.currentTimeMillis()
                    - startTime;


            long elapsedSeconds =
                    elapsedMilliseconds / 1000L;


            remainingSeconds =
                    (exam.getDurationMinutes() * 60L)
                    - elapsedSeconds;


            if (remainingSeconds < 0) {

                remainingSeconds = 0;
            }
        }


        // =====================================================
        // SEND DATA TO EXAM JSP
        // =====================================================

        request.setAttribute(
                "exam",
                exam
        );


        request.setAttribute(
                "questions",
                selectedQuestions
        );


        request.setAttribute(
                "examStarted",
                examStarted
        );


        request.setAttribute(
                "remainingSeconds",
                remainingSeconds
        );


        // =====================================================
        // OPEN EXAM JSP
        // =====================================================

        request.getRequestDispatcher(
                "/student/exam.jsp"
        ).forward(
                request,
                response
        );
    }



    // =========================================================
    // START EXAM
    // =========================================================

    private void startExam(
            HttpServletRequest request,
            HttpServletResponse response,
            int examId)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession();


        String startTimeSessionKey =
                "exam_" + examId + "_startTime";


        // =====================================================
        // CHECK WHETHER EXAM IS ALREADY STARTED
        // =====================================================

        Object existingStartTime =
                session.getAttribute(
                        startTimeSessionKey
                );


        if (existingStartTime == null) {

            // =================================================
            // START TIMER NOW
            // =================================================

            session.setAttribute(
                    startTimeSessionKey,
                    System.currentTimeMillis()
            );
        }


        // =====================================================
        // REDIRECT TO EXAM PAGE
        // =====================================================

        response.sendRedirect(
                request.getContextPath()
                + "/student/exam?examId="
                + examId
        );
    }



    // =========================================================
    // SUBMIT EXAM
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // Student security
        if (!isStudent(request, response)) {
            return;
        }


        request.setCharacterEncoding("UTF-8");


        // =====================================================
        // GET ACTION
        // =====================================================

        String action =
                request.getParameter("action");


        // =====================================================
        // GET EXAM ID
        // =====================================================

        String examIdParameter =
                request.getParameter("examId");


        if (examIdParameter == null ||
            examIdParameter.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/student/dashboard.jsp?error=Exam not selected"
            );

            return;
        }


        int examId;


        try {

            examId =
                    Integer.parseInt(
                            examIdParameter.trim()
                    );

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/student/dashboard.jsp?error=Invalid exam"
            );

            return;
        }


        // =====================================================
        // START EXAM ACTION
        // =====================================================

        if ("start".equalsIgnoreCase(action)) {

            startExam(
                    request,
                    response,
                    examId
            );

            return;
        }


        // =====================================================
        // SUBMIT EXAM
        // =====================================================

        if (!"submit".equalsIgnoreCase(action)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/student/dashboard.jsp?error=Invalid exam action"
            );

            return;
        }


        // =====================================================
        // GET EXAM
        // =====================================================

        Exam exam =
                examDAO.getExamById(examId);


        if (exam == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/student/dashboard.jsp?error=Exam not found"
            );

            return;
        }


        HttpSession session =
                request.getSession();


        // =====================================================
        // GET START TIME
        // =====================================================

        String startTimeSessionKey =
                "exam_" + examId + "_startTime";


        Object startTimeObject =
                session.getAttribute(
                        startTimeSessionKey
                );


        // =====================================================
        // IF STUDENT NEVER STARTED THE EXAM
        // =====================================================

        if (!(startTimeObject instanceof Long)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/student/exam?examId="
                    + examId
                    + "&error=Please start the exam first"
            );

            return;
        }


        long startTime =
                (Long) startTimeObject;


        // =====================================================
        // CHECK EXAM TIME
        // =====================================================

        long elapsedMilliseconds =
                System.currentTimeMillis()
                - startTime;


        long elapsedSeconds =
                elapsedMilliseconds / 1000L;


        long allowedSeconds =
                exam.getDurationMinutes() * 60L;


        boolean timeExpired =
                elapsedSeconds >= allowedSeconds;


        // =====================================================
        // GET QUESTION IDS FROM SESSION
        // =====================================================

        String questionSessionKey =
                "exam_" + examId + "_questionIds";


        Object storedObject =
                session.getAttribute(
                        questionSessionKey
                );


        if (!(storedObject instanceof List<?>)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/student/dashboard.jsp?error=Exam session expired"
            );

            return;
        }


        List<?> storedList =
                (List<?>) storedObject;


        List<Integer> questionIds =
                new ArrayList<>();


        for (Object object :
                storedList) {

            if (object instanceof Integer) {

                questionIds.add(
                        (Integer) object
                );
            }
        }


        if (questionIds.isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/student/dashboard.jsp?error=No questions found"
            );

            return;
        }


        // =====================================================
        // GET QUESTIONS FROM DATABASE
        // =====================================================

        List<Question> allQuestions =
                questionDAO.getQuestionsByExamId(
                        examId
                );


        int score = 0;

        int answered = 0;


        // =====================================================
        // CHECK EACH QUESTION
        // =====================================================

        for (Integer questionId :
                questionIds) {


            Question currentQuestion =
                    null;


            // =================================================
            // FIND QUESTION
            // =================================================

            for (Question question :
                    allQuestions) {

                if (question.getId() ==
                        questionId) {

                    currentQuestion =
                            question;

                    break;
                }
            }


            if (currentQuestion == null) {
                continue;
            }


            // =================================================
            // GET STUDENT ANSWER
            // =================================================

            String studentAnswer =
                    request.getParameter(
                            "question_" + questionId
                    );


            // No answer
            if (studentAnswer == null ||
                studentAnswer.trim().isEmpty()) {

                continue;
            }


            answered++;


            // =================================================
            // NORMALIZE STUDENT ANSWER
            // =================================================

            studentAnswer =
                    normalizeAnswer(
                            studentAnswer
                    );


            // =================================================
            // GET CORRECT ANSWER
            // =================================================

            String correctAnswer =
                    currentQuestion.getCorrectAnswer();


            if (correctAnswer == null ||
                correctAnswer.trim().isEmpty()) {

                continue;
            }


            correctAnswer =
                    normalizeAnswer(
                            correctAnswer
                    );


            // =================================================
            // COMPARE ANSWERS
            // =================================================

            if (studentAnswer.equals(
                    correctAnswer)) {

                score++;
            }
        }


        // =====================================================
        // CALCULATE RESULT
        // =====================================================

        int totalQuestions =
                questionIds.size();


        int unanswered =
                totalQuestions - answered;


        double percentage =
                0.0;


        if (totalQuestions > 0) {

            percentage =
                    ((double) score
                    / totalQuestions)
                    * 100.0;
        }


        // =====================================================
        // REMOVE EXAM SESSION DATA
        // =====================================================

        session.removeAttribute(
                questionSessionKey
        );


        session.removeAttribute(
                startTimeSessionKey
        );


        // =====================================================
        // SAVE LATEST RESULT IN SESSION
        // =====================================================

        /*
         * These values are stored in the session so that
         * result.jsp can display the result even after the
         * student clicks "My Results" from the dashboard.
         */

        session.setAttribute(
                "latestResultExam",
                exam
        );


        session.setAttribute(
                "latestResultScore",
                score
        );


        session.setAttribute(
                "latestResultAnswered",
                answered
        );


        session.setAttribute(
                "latestResultUnanswered",
                unanswered
        );


        session.setAttribute(
                "latestResultTotalQuestions",
                totalQuestions
        );


        session.setAttribute(
                "latestResultPercentage",
                percentage
        );


        session.setAttribute(
                "latestResultTimeExpired",
                timeExpired
        );


        // =====================================================
        // ALSO KEEP RESULT AS REQUEST ATTRIBUTES
        // =====================================================

        request.setAttribute(
                "exam",
                exam
        );


        request.setAttribute(
                "score",
                score
        );


        request.setAttribute(
                "answered",
                answered
        );


        request.setAttribute(
                "unanswered",
                unanswered
        );


        request.setAttribute(
                "totalQuestions",
                totalQuestions
        );


        request.setAttribute(
                "percentage",
                percentage
        );


        request.setAttribute(
                "submitted",
                true
        );


        request.setAttribute(
                "timeExpired",
                timeExpired
        );


        // =====================================================
        // OPEN RESULT PAGE
        // =====================================================

        response.sendRedirect(
                request.getContextPath()
                + "/student/result.jsp"
        );
    }



    // =========================================================
    // NORMALIZE ANSWERS
    // =========================================================

    private String normalizeAnswer(
            String answer) {

        if (answer == null) {
            return "";
        }


        String value =
                answer.trim()
                      .toLowerCase();


        value =
                value.replace(
                        ".",
                        ""
                );


        value =
                value.replace(
                        ")",
                        ""
                );


        value =
                value.replace(
                        "(",
                        ""
                );


        value =
                value.trim();


        if (value.equals("a") ||
            value.equals("option a") ||
            value.equals("option_a") ||
            value.equals("optiona")) {

            return "a";
        }


        if (value.equals("b") ||
            value.equals("option b") ||
            value.equals("option_b") ||
            value.equals("optionb")) {

            return "b";
        }


        if (value.equals("c") ||
            value.equals("option c") ||
            value.equals("option_c") ||
            value.equals("optionc")) {

            return "c";
        }


        if (value.equals("d") ||
            value.equals("option d") ||
            value.equals("option_d") ||
            value.equals("optiond")) {

            return "d";
        }


        return value;
    }



    // =========================================================
    // STUDENT SECURITY
    // =========================================================

    private boolean isStudent(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session =
                request.getSession(false);


        // =====================================================
        // NO SESSION
        // =====================================================

        if (session == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=Please login first"
            );

            return false;
        }


        // =====================================================
        // GET USER
        // =====================================================

        User user =
                (User) session.getAttribute(
                        "user"
                );


        // =====================================================
        // USER NOT LOGGED IN
        // =====================================================

        if (user == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=Please login first"
            );

            return false;
        }


        // =====================================================
        // ONLY STUDENT ALLOWED
        // =====================================================

        if (!"STUDENT".equalsIgnoreCase(
                user.getRole())) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/dashboard.jsp?error=Access denied"
            );

            return false;
        }


        return true;
    }
}