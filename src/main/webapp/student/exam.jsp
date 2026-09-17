<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.exam.model.Exam" %>
<%@ page import="com.exam.model.Question" %>
<%@ page import="com.exam.model.User" %>

<%
    // =========================================================
    // STUDENT SECURITY
    // =========================================================

    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect(
            request.getContextPath() + "/login.jsp"
        );
        return;
    }

    if (!"STUDENT".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(
            request.getContextPath() + "/admin/dashboard.jsp"
        );
        return;
    }


    // =========================================================
    // GET EXAM
    // =========================================================

    Exam exam = (Exam) request.getAttribute("exam");


    // =========================================================
    // GET QUESTIONS
    // =========================================================

    List<?> questionList =
        (List<?>) request.getAttribute("questions");

    List<Question> questions =
        new java.util.ArrayList<Question>();

    if (questionList != null) {
        for (Object obj : questionList) {
            if (obj instanceof Question) {
                questions.add((Question) obj);
            }
        }
    }


    // =========================================================
    // CHECK WHETHER EXAM HAS BEEN SUBMITTED
    // =========================================================

    Boolean submitted =
        (Boolean) request.getAttribute("submitted");

    boolean examSubmitted =
        submitted != null && submitted;


    // =========================================================
    // CHECK WHETHER EXAM HAS BEEN STARTED
    // =========================================================

    Boolean startedObject =
        (Boolean) request.getAttribute("examStarted");

    boolean examStarted =
        startedObject != null && startedObject;


    // =========================================================
    // REMAINING TIME FROM SERVLET
    // =========================================================

    Long remainingSecondsObject =
        (Long) request.getAttribute("remainingSeconds");

    long remainingSeconds =
        remainingSecondsObject != null
        ? remainingSecondsObject
        : (exam != null
            ? exam.getDurationMinutes() * 60L
            : 0L);


    // =========================================================
    // RESULT VALUES
    // =========================================================

    Integer scoreObject =
        (Integer) request.getAttribute("score");

    Integer answeredObject =
        (Integer) request.getAttribute("answered");

    Integer unansweredObject =
        (Integer) request.getAttribute("unanswered");

    Integer totalQuestionsObject =
        (Integer) request.getAttribute("totalQuestions");

    Double percentageObject =
        (Double) request.getAttribute("percentage");


    int score =
        scoreObject != null
        ? scoreObject
        : 0;

    int answered =
        answeredObject != null
        ? answeredObject
        : 0;

    int unanswered =
        unansweredObject != null
        ? unansweredObject
        : 0;

    int totalQuestions =
        totalQuestionsObject != null
        ? totalQuestionsObject
        : questions.size();

    double percentage =
        percentageObject != null
        ? percentageObject
        : 0.0;
%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        <%= exam != null
            ? exam.getExamName()
            : "Examination" %>
        | Online Examination System
    </title>


    <style>

        /* =====================================================
           GLOBAL
           ===================================================== */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family:
                Arial,
                Helvetica,
                sans-serif;

            background:
                #f4f7fb;

            color:
                #1e293b;

            min-height:
                100vh;
        }


        /* =====================================================
           MAIN LAYOUT
           ===================================================== */

        .dashboard-layout {
            display: flex;
            min-height: 100vh;
        }


        /* =====================================================
           SIDEBAR
           ===================================================== */

        .sidebar {
            width: 250px;

            background:
                #111827;

            color: #ffffff;

            min-height: 100vh;

            position: fixed;

            left: 0;
            top: 0;
            bottom: 0;

            display: flex;

            flex-direction: column;

            z-index: 100;
        }


        .sidebar-logo {
            padding: 25px 22px;

            border-bottom:
                1px solid #263244;
        }


        .sidebar-logo h2 {
            font-size: 21px;

            font-weight: 700;

            margin-bottom: 5px;
        }


        .sidebar-logo p {
            color: #94a3b8;

            font-size: 13px;
        }


        .sidebar-menu {
            padding: 22px 15px;
        }


        .sidebar-menu-title {
            color: #64748b;

            font-size: 11px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 1px;

            padding: 0 14px 12px;
        }


        .sidebar-menu a {
            display: block;

            text-decoration: none;

            color: #cbd5e1;

            padding: 13px 15px;

            margin-bottom: 5px;

            border-radius: 8px;

            font-size: 14px;

            transition:
                all 0.2s ease;
        }


        .sidebar-menu a:hover {
            background:
                #1e293b;

            color:
                #ffffff;
        }


        .sidebar-menu a.active {
            background:
                #2563eb;

            color:
                #ffffff;

            box-shadow:
                0 4px 12px
                rgba(37, 99, 235, 0.25);
        }


        .logout-button {
            margin-top: 15px;
        }


        /* =====================================================
           MAIN CONTENT
           ===================================================== */

        .main-content {
            margin-left: 250px;

            width:
                calc(100% - 250px);

            min-height: 100vh;

            padding: 28px 32px;
        }


        /* =====================================================
           TOP BAR
           ===================================================== */

        .topbar {
            display: flex;

            justify-content:
                space-between;

            align-items:
                center;

            margin-bottom: 25px;

            background:
                #ffffff;

            border:
                1px solid #e2e8f0;

            border-radius: 12px;

            padding: 18px 22px;

            box-shadow:
                0 2px 8px
                rgba(15, 23, 42, 0.04);
        }


        .topbar-left h1 {
            font-size: 25px;

            color:
                #0f172a;

            margin-bottom: 5px;
        }


        .topbar-left p {
            color:
                #64748b;

            font-size: 14px;
        }


        .student-badge {
            display: flex;

            align-items: center;

            gap: 10px;

            color:
                #334155;

            font-size: 14px;

            font-weight: 600;
        }


        .student-avatar {
            width: 38px;
            height: 38px;

            border-radius: 50%;

            background:
                #dbeafe;

            color:
                #2563eb;

            display: flex;

            align-items: center;

            justify-content: center;

            font-weight: 700;
        }


        /* =====================================================
           EXAM HEADER
           ===================================================== */

        .exam-header {
            background:
                linear-gradient(
                    135deg,
                    #1d4ed8,
                    #2563eb
                );

            color:
                #ffffff;

            border-radius:
                14px;

            padding:
                28px;

            margin-bottom:
                22px;

            box-shadow:
                0 8px 20px
                rgba(37, 99, 235, 0.18);
        }


        .exam-header h2 {
            font-size: 25px;

            margin-bottom: 8px;
        }


        .exam-header p {
            color:
                #dbeafe;

            font-size: 14px;

            margin-bottom: 22px;
        }


        .exam-info-grid {
            display: grid;

            grid-template-columns:
                repeat(4, 1fr);

            gap: 14px;
        }


        .exam-info-box {
            background:
                rgba(255, 255, 255, 0.12);

            border:
                1px solid
                rgba(255, 255, 255, 0.16);

            border-radius: 10px;

            padding: 15px;
        }


        .exam-info-box span {
            display: block;

            color:
                #bfdbfe;

            font-size: 12px;

            margin-bottom: 6px;
        }


        .exam-info-box strong {
            font-size: 17px;

            color:
                #ffffff;
        }


        /* =====================================================
           TIMER
           ===================================================== */

        .timer-box {
            display: flex;

            justify-content:
                space-between;

            align-items:
                center;

            background:
                #ffffff;

            border:
                1px solid #dbeafe;

            border-left:
                5px solid #2563eb;

            border-radius: 10px;

            padding: 15px 20px;

            margin-bottom: 20px;

            box-shadow:
                0 2px 8px
                rgba(15, 23, 42, 0.05);
        }


        .timer-label {
            color:
                #475569;

            font-size: 14px;

            font-weight: 600;
        }


        .timer {
            color:
                #2563eb;

            font-size: 24px;

            font-weight: 700;

            font-family:
                monospace;
        }


        /* =====================================================
           QUESTION CARD
           ===================================================== */

        .question-card {
            background:
                #ffffff;

            border:
                1px solid #e2e8f0;

            border-radius:
                12px;

            padding:
                24px;

            margin-bottom:
                18px;

            box-shadow:
                0 3px 10px
                rgba(15, 23, 42, 0.04);

            transition:
                border-color 0.2s ease,
                box-shadow 0.2s ease;
        }


        .question-card:hover {
            border-color:
                #bfdbfe;

            box-shadow:
                0 5px 14px
                rgba(37, 99, 235, 0.07);
        }


        .question-number {
            display: inline-block;

            background:
                #dbeafe;

            color:
                #2563eb;

            font-size: 12px;

            font-weight: 700;

            padding:
                6px 10px;

            border-radius:
                6px;

            margin-bottom:
                12px;
        }


        .question-text {
            color:
                #0f172a;

            font-size:
                17px;

            line-height:
                1.6;

            font-weight:
                600;

            margin-bottom:
                18px;
        }


        /* =====================================================
           OPTIONS
           ===================================================== */

        .option {
            display: flex;

            align-items:
                center;

            gap: 12px;

            background:
                #f8fafc;

            border:
                1px solid #e2e8f0;

            border-radius:
                8px;

            padding:
                13px 15px;

            margin-bottom:
                10px;

            cursor:
                pointer;

            transition:
                all 0.2s ease;
        }


        .option:hover {
            background:
                #eff6ff;

            border-color:
                #93c5fd;
        }


        .option input {
            width: 17px;
            height: 17px;

            accent-color:
                #2563eb;

            cursor:
                pointer;
        }


        .option-text {
            color:
                #334155;

            font-size:
                14px;

            line-height:
                1.5;
        }


        /* =====================================================
           BUTTON AREA
           ===================================================== */

        .button-area {
            display: flex;

            justify-content:
                space-between;

            align-items:
                center;

            gap: 12px;

            background:
                #ffffff;

            border:
                1px solid #e2e8f0;

            border-radius:
                12px;

            padding: 18px;

            margin-top: 20px;

            margin-bottom: 30px;
        }


        .btn {
            display: inline-block;

            border: none;

            border-radius: 8px;

            padding: 12px 20px;

            font-size: 14px;

            font-weight: 600;

            text-decoration: none;

            cursor: pointer;

            transition:
                all 0.2s ease;
        }


        .btn-back {
            background:
                #64748b;

            color:
                #ffffff;
        }


        .btn-back:hover {
            background:
                #475569;

            color:
                #ffffff;
        }


        .btn-submit {
            background:
                #2563eb;

            color:
                #ffffff;

            box-shadow:
                0 4px 10px
                rgba(37, 99, 235, 0.2);
        }


        .btn-submit:hover {
            background:
                #1d4ed8;

            transform:
                translateY(-1px);
        }


        /* =====================================================
           START EXAM CARD
           ===================================================== */

        .start-card {
            background:
                #ffffff;

            border:
                1px solid #dbeafe;

            border-radius:
                14px;

            padding:
                45px 35px;

            text-align:
                center;

            box-shadow:
                0 5px 18px
                rgba(15, 23, 42, 0.06);
        }


        .start-icon {
            width: 70px;
            height: 70px;

            margin:
                0 auto 20px;

            border-radius: 50%;

            background:
                #dbeafe;

            color:
                #2563eb;

            display:
                flex;

            align-items:
                center;

            justify-content:
                center;

            font-size: 28px;

            font-weight: 700;
        }


        .start-card h2 {
            color:
                #0f172a;

            font-size:
                25px;

            margin-bottom:
                12px;
        }


        .start-card p {
            color:
                #64748b;

            font-size:
                14px;

            line-height:
                1.6;

            margin-bottom:
                10px;
        }


        .start-details {
            display:
                grid;

            grid-template-columns:
                repeat(2, 1fr);

            max-width:
                500px;

            margin:
                25px auto;

            gap:
                15px;
        }


        .start-detail {
            background:
                #f8fafc;

            border:
                1px solid #e2e8f0;

            border-radius:
                9px;

            padding:
                15px;
        }


        .start-detail span {
            display:
                block;

            color:
                #64748b;

            font-size:
                12px;

            margin-bottom:
                5px;
        }


        .start-detail strong {
            color:
                #2563eb;

            font-size:
                17px;
        }


        .start-button {
            background:
                #2563eb;

            color:
                #ffffff;

            border:
                none;

            border-radius:
                8px;

            padding:
                13px 28px;

            font-size:
                15px;

            font-weight:
                700;

            cursor:
                pointer;

            margin-top:
                10px;

            box-shadow:
                0 5px 14px
                rgba(37, 99, 235, 0.22);

            transition:
                all 0.2s ease;
        }


        .start-button:hover {
            background:
                #1d4ed8;

            transform:
                translateY(-1px);
        }


        /* =====================================================
           RESULT PAGE
           ===================================================== */

        .result-card {
            background:
                #ffffff;

            border:
                1px solid #dbeafe;

            border-radius:
                14px;

            padding:
                40px;

            text-align:
                center;

            box-shadow:
                0 5px 18px
                rgba(15, 23, 42, 0.06);
        }


        .result-icon {
            width: 70px;
            height: 70px;

            margin:
                0 auto 18px;

            border-radius:
                50%;

            background:
                #dbeafe;

            color:
                #2563eb;

            display:
                flex;

            align-items:
                center;

            justify-content:
                center;

            font-size:
                28px;

            font-weight:
                700;
        }


        .result-card h2 {
            color:
                #0f172a;

            font-size:
                25px;

            margin-bottom:
                8px;
        }


        .result-exam-name {
            color:
                #64748b;

            font-size:
                15px;

            margin-bottom:
                25px;
        }


        .score {
            color:
                #2563eb;

            font-size:
                50px;

            font-weight:
                800;

            margin-bottom:
                5px;
        }


        .percentage {
            color:
                #475569;

            font-size:
                17px;

            margin-bottom:
                28px;
        }


        .result-grid {
            display:
                grid;

            grid-template-columns:
                repeat(4, 1fr);

            gap:
                14px;

            max-width:
                750px;

            margin:
                0 auto 30px;
        }


        .result-box {
            background:
                #f8fafc;

            border:
                1px solid #e2e8f0;

            border-radius:
                10px;

            padding:
                18px 10px;
        }


        .result-box strong {
            display:
                block;

            color:
                #2563eb;

            font-size:
                23px;

            margin-bottom:
                6px;
        }


        .result-box span {
            color:
                #64748b;

            font-size:
                13px;
        }


        .result-actions {
            margin-top:
                10px;
        }


        /* =====================================================
           FOOTER
           ===================================================== */

        .footer {
            text-align:
                center;

            color:
                #94a3b8;

            font-size:
                12px;

            padding:
                20px 0 5px;
        }


        /* =====================================================
           MOBILE
           ===================================================== */

        @media (max-width: 900px) {

            .sidebar {
                width: 210px;
            }

            .main-content {
                margin-left: 210px;

                width:
                    calc(100% - 210px);

                padding: 20px;
            }

            .exam-info-grid {
                grid-template-columns:
                    repeat(2, 1fr);
            }

            .result-grid {
                grid-template-columns:
                    repeat(2, 1fr);
            }
        }


        @media (max-width: 700px) {

            .dashboard-layout {
                display: block;
            }

            .sidebar {
                position: relative;

                width: 100%;

                min-height: auto;
            }

            .sidebar-menu {
                display: flex;

                flex-wrap: wrap;

                gap: 5px;
            }

            .sidebar-menu-title {
                width: 100%;
            }

            .sidebar-menu a {
                margin-bottom: 0;
            }

            .main-content {
                margin-left: 0;

                width: 100%;

                padding: 15px;
            }

            .topbar {
                flex-direction: column;

                align-items:
                    flex-start;

                gap: 15px;
            }

            .exam-info-grid {
                grid-template-columns:
                    1fr 1fr;
            }

            .button-area {
                flex-direction:
                    column-reverse;

                align-items:
                    stretch;
            }

            .btn {
                text-align:
                    center;

                width:
                    100%;
            }

            .start-details {
                grid-template-columns:
                    1fr;
            }

            .result-grid {
                grid-template-columns:
                    1fr 1fr;
            }

            .result-card {
                padding:
                    25px 15px;
            }
        }


        @media (max-width: 450px) {

            .exam-info-grid {
                grid-template-columns:
                    1fr;
            }

            .result-grid {
                grid-template-columns:
                    1fr;
            }

            .score {
                font-size:
                    42px;
            }
        }

    </style>

</head>


<body>


<div class="dashboard-layout">


    <!-- =====================================================
         SIDEBAR
         ===================================================== -->

    <aside class="sidebar">

        <div class="sidebar-logo">

            <h2>
                Online Exam
            </h2>

            <p>
                Student Portal
            </p>

        </div>


        <nav class="sidebar-menu">

            <div class="sidebar-menu-title">
                Student Menu
            </div>


            <a href="<%= request.getContextPath() %>/student/dashboard.jsp">
                Dashboard
            </a>


            <a href="<%= request.getContextPath() %>/student/dashboard.jsp">
                Available Exams
            </a>


            <a href="<%= request.getContextPath() %>/student/dashboard.jsp">
                My Results
            </a>


            <a href="<%= request.getContextPath() %>/student/dashboard.jsp">
                My Profile
            </a>


            <a href="<%= request.getContextPath() %>/student/dashboard.jsp">
                Exam History
            </a>


            <a href="<%= request.getContextPath() %>/logout"
               class="logout-button">
                Logout
            </a>

        </nav>

    </aside>



    <!-- =====================================================
         MAIN CONTENT
         ===================================================== -->

    <main class="main-content">


        <!-- =================================================
             TOP BAR
             ================================================= -->

        <div class="topbar">

            <div class="topbar-left">

                <h1>
                    <%= exam != null
                        ? exam.getExamName()
                        : "Examination" %>
                </h1>

                <p>
                    Online Examination System
                </p>

            </div>


            <div class="student-badge">

                <div class="student-avatar">

                    <%= user.getName()
                        .substring(0, 1)
                        .toUpperCase() %>

                </div>

                <span>
                    <%= user.getName() %>
                </span>

            </div>

        </div>



        <!-- =================================================
             RESULT SCREEN
             ================================================= -->

        <% if (examSubmitted) { %>


            <div class="result-card">


                <div class="result-icon">
                    ✓
                </div>


                <h2>
                    Exam Submitted Successfully
                </h2>


                <p class="result-exam-name">
                    <%= exam.getExamName() %>
                </p>


                <div class="score">

                    <%= score %> /
                    <%= totalQuestions %>

                </div>


                <div class="percentage">

                    Your Score:

                    <strong>

                        <%= String.format(
                                "%.2f",
                                percentage
                           ) %>%

                    </strong>

                </div>


                <div class="result-grid">


                    <div class="result-box">

                        <strong>
                            <%= score %>
                        </strong>

                        <span>
                            Correct Answers
                        </span>

                    </div>


                    <div class="result-box">

                        <strong>
                            <%= answered %>
                        </strong>

                        <span>
                            Answered
                        </span>

                    </div>


                    <div class="result-box">

                        <strong>
                            <%= unanswered %>
                        </strong>

                        <span>
                            Unanswered
                        </span>

                    </div>


                    <div class="result-box">

                        <strong>
                            <%= totalQuestions %>
                        </strong>

                        <span>
                            Total Questions
                        </span>

                    </div>


                </div>


                <div class="result-actions">

                    <a href="<%= request.getContextPath() %>/student/dashboard.jsp"
                       class="btn btn-back">

                        Back to Dashboard

                    </a>

                </div>


            </div>


        <!-- =================================================
             START EXAM SCREEN
             ================================================= -->

        <% } else if (!examStarted) { %>


            <div class="start-card">


                <div class="start-icon">
                    ?
                </div>


                <h2>
                    <%= exam.getExamName() %>
                </h2>


                <p>
                    You are about to start your examination.
                </p>


                <p>
                    The timer will begin only after you click
                    <strong>Start Exam</strong>.
                </p>


                <div class="start-details">


                    <div class="start-detail">

                        <span>
                            Duration
                        </span>

                        <strong>
                            <%= exam.getDurationMinutes() %>
                            Minutes
                        </strong>

                    </div>


                    <div class="start-detail">

                        <span>
                            Questions
                        </span>

                        <strong>
                            <%= questions.size() %>
                        </strong>

                    </div>


                </div>


                <form method="post"
                      action="<%= request.getContextPath() %>/student/exam">


                    <input type="hidden"
                           name="examId"
                           value="<%= exam.getId() %>">


                    <input type="hidden"
                           name="action"
                           value="start">


                    <button type="submit"
                            class="start-button">

                        Start Exam

                    </button>

                </form>


                <br>


                <a href="<%= request.getContextPath() %>/student/dashboard.jsp"
                   class="btn btn-back">

                    Back to Dashboard

                </a>


            </div>


        <!-- =================================================
             ACTIVE EXAM SCREEN
             ================================================= -->

        <% } else { %>


            <!-- EXAM HEADER -->

            <div class="exam-header">


                <h2>
                    <%= exam.getExamName() %>
                </h2>


                <p>
                    Answer all questions carefully before submitting
                    your examination.
                </p>


                <div class="exam-info-grid">


                    <div class="exam-info-box">

                        <span>
                            Duration
                        </span>

                        <strong>
                            <%= exam.getDurationMinutes() %>
                            Minutes
                        </strong>

                    </div>


                    <div class="exam-info-box">

                        <span>
                            Time Remaining
                        </span>

                        <strong id="headerTimer">
                            00:00
                        </strong>

                    </div>


                    <div class="exam-info-box">

                        <span>
                            Total Questions
                        </span>

                        <strong>
                            <%= questions.size() %>
                        </strong>

                    </div>


                    <div class="exam-info-box">

                        <span>
                            Question Bank
                        </span>

                        <strong>
                            <%= questions.size() %>
                        </strong>

                    </div>


                </div>

            </div>



            <!-- TIMER -->

            <div class="timer-box">

                <span class="timer-label">
                    Time Remaining
                </span>


                <span class="timer"
                      id="timer">

                    00:00

                </span>

            </div>



            <!-- =================================================
                 EXAM FORM
                 ================================================= -->

            <form id="examForm"
                  method="post"
                  action="<%= request.getContextPath() %>/student/exam">


                <input type="hidden"
                       name="examId"
                       value="<%= exam.getId() %>">


                <input type="hidden"
                       name="action"
                       value="submit">



                <!-- =================================================
                     QUESTIONS
                     ================================================= -->

                <%
                    int questionNumber = 1;

                    for (Question question : questions) {
                %>


                    <div class="question-card">


                        <div class="question-number">

                            Question
                            <%= questionNumber %>

                        </div>


                        <div class="question-text">

                            <%= question.getQuestionText() %>

                        </div>



                        <!-- OPTION A -->

                        <label class="option">

                            <input type="radio"
                                   name="question_<%= question.getId() %>"
                                   value="A">

                            <span class="option-text">

                                <strong>A.</strong>
                                <%= question.getOptionA() %>

                            </span>

                        </label>



                        <!-- OPTION B -->

                        <label class="option">

                            <input type="radio"
                                   name="question_<%= question.getId() %>"
                                   value="B">

                            <span class="option-text">

                                <strong>B.</strong>
                                <%= question.getOptionB() %>

                            </span>

                        </label>



                        <!-- OPTION C -->

                        <label class="option">

                            <input type="radio"
                                   name="question_<%= question.getId() %>"
                                   value="C">

                            <span class="option-text">

                                <strong>C.</strong>
                                <%= question.getOptionC() %>

                            </span>

                        </label>



                        <!-- OPTION D -->

                        <label class="option">

                            <input type="radio"
                                   name="question_<%= question.getId() %>"
                                   value="D">

                            <span class="option-text">

                                <strong>D.</strong>
                                <%= question.getOptionD() %>

                            </span>

                        </label>


                    </div>


                <%
                        questionNumber++;
                    }
                %>



                <!-- =================================================
                     BUTTONS
                     ================================================= -->

                <div class="button-area">


                   <a href="<%= request.getContextPath() %>/student/dashboard.jsp"
                 class="btn btn-back">
               Back to Dashboard
                   </a>


                    <button type="submit"
                            class="btn btn-submit"
                            onclick="return confirmSubmit();">

                        Submit Exam

                    </button>


                </div>


            </form>


        <% } %>



        <!-- =================================================
             FOOTER
             ================================================= -->

        <div class="footer">

            Online Examination System

            &nbsp; | &nbsp;

            Java • JSP • Servlet • JDBC • MySQL

        </div>


    </main>

</div>



<!-- =========================================================
     JAVASCRIPT
     ========================================================= -->

<script>


    // =========================================================
    // TIMER
    // =========================================================

    let totalSeconds = <%= remainingSeconds %>;

    let timerInterval = null;

    let timeUpSubmitted = false;


    const timerElement =
        document.getElementById("timer");


    const headerTimer =
        document.getElementById("headerTimer");



    function updateTimer() {

        let minutes =
            Math.floor(totalSeconds / 60);


        let seconds =
            totalSeconds % 60;


        let formattedSeconds =
            seconds < 10
                ? "0" + seconds
                : seconds;


        let formattedMinutes =
            minutes < 10
                ? "0" + minutes
                : minutes;


        let formattedTime =
            formattedMinutes + ":" +
            formattedSeconds;



        if (timerElement) {

            timerElement.innerHTML =
                formattedTime;

        }


        if (headerTimer) {

            headerTimer.innerHTML =
                formattedTime;

        }



        // =====================================================
        // TIME FINISHED
        // =====================================================

        if (totalSeconds <= 0) {

            clearInterval(timerInterval);


            if (!timeUpSubmitted) {

                timeUpSubmitted = true;


                alert(
                    "Time is up! Your exam will be submitted automatically."
                );


                const form =
                    document.getElementById(
                        "examForm"
                    );


                if (form) {

                    form.submit();

                }

            }


            return;
        }


        totalSeconds--;

    }



    // =========================================================
    // START TIMER ONLY AFTER START EXAM
    // =========================================================

    <% if (examStarted && !examSubmitted) { %>

        updateTimer();

        timerInterval =
            setInterval(
                updateTimer,
                1000
            );

    <% } %>



    // =========================================================
    // SUBMIT CONFIRMATION
    // =========================================================

    function confirmSubmit() {

        return confirm(
            "Are you sure you want to submit your exam?"
        );

    }


</script>


</body>

</html>