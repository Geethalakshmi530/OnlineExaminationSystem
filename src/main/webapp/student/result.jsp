<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.exam.model.User" %>

<%
    // ============================================================
    // STUDENT LOGIN CHECK
    // ============================================================

    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect(
            request.getContextPath() + "/login.jsp?error=Please login first"
        );
        return;
    }

    // Only STUDENT can access this page
    if (!"STUDENT".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(
            request.getContextPath() + "/admin/dashboard.jsp"
        );
        return;
    }

    // ============================================================
    // GET LATEST RESULT FROM SESSION
    // ============================================================

    Object scoreObj = session.getAttribute("latestResultScore");
    Object answeredObj = session.getAttribute("latestResultAnswered");
    Object unansweredObj = session.getAttribute("latestResultUnanswered");
    Object totalQuestionsObj = session.getAttribute("latestResultTotalQuestions");
    Object percentageObj = session.getAttribute("latestResultPercentage");
    Object timeExpiredObj = session.getAttribute("latestResultTimeExpired");

    boolean resultAvailable = scoreObj != null
            && answeredObj != null
            && unansweredObj != null
            && totalQuestionsObj != null
            && percentageObj != null;

    int score = 0;
    int answered = 0;
    int unanswered = 0;
    int totalQuestions = 0;
    double percentage = 0.0;
    boolean timeExpired = false;

    if (resultAvailable) {
        score = ((Number) scoreObj).intValue();
        answered = ((Number) answeredObj).intValue();
        unanswered = ((Number) unansweredObj).intValue();
        totalQuestions = ((Number) totalQuestionsObj).intValue();
        percentage = ((Number) percentageObj).doubleValue();

        if (timeExpiredObj != null) {
            timeExpired = (Boolean) timeExpiredObj;
        }
    }

    String resultStatus = "Completed";
    String resultMessage = "Your examination has been submitted successfully.";

    if (timeExpired) {
        resultStatus = "Time Expired";
        resultMessage = "The examination was submitted because the allotted time expired.";
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>My Result - Online Examination System</title>

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #f4f7fb;
            color: #1f2937;
            min-height: 100vh;
        }

        .page-wrapper {
            display: flex;
            min-height: 100vh;
        }

        /* ========================================================
           SIDEBAR
           ======================================================== */

        .sidebar {
            width: 250px;
            background: #0b1f3a;
            color: white;
            position: fixed;
            left: 0;
            top: 0;
            bottom: 0;
            display: flex;
            flex-direction: column;
            box-shadow: 4px 0 15px rgba(0, 0, 0, 0.08);
        }

        .brand {
            padding: 28px 24px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.10);
        }

        .brand-title {
            font-size: 21px;
            font-weight: 700;
            letter-spacing: 0.2px;
        }

        .brand-subtitle {
            margin-top: 6px;
            color: #aebdd2;
            font-size: 12px;
        }

        .navigation {
            padding: 22px 14px;
            flex: 1;
        }

        .navigation-title {
            color: #8293aa;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            padding: 0 12px 12px;
        }

        .nav-link {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            color: #cbd5e1;
            padding: 13px 14px;
            border-radius: 8px;
            margin-bottom: 5px;
            font-size: 14px;
            transition: 0.2s ease;
        }

        .nav-link:hover {
            background: rgba(255, 255, 255, 0.08);
            color: white;
        }

        .nav-link.active {
            background: #1769e0;
            color: white;
            font-weight: 600;
        }

        .nav-icon {
            width: 22px;
            text-align: center;
            font-size: 16px;
        }

        .sidebar-bottom {
            padding: 16px 14px 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.10);
        }

        .user-box {
            display: flex;
            align-items: center;
            gap: 11px;
            padding: 10px;
            margin-bottom: 10px;
        }

        .avatar {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: #1769e0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 700;
            font-size: 15px;
        }

        .user-details {
            min-width: 0;
        }

        .user-name {
            color: white;
            font-size: 13px;
            font-weight: 600;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .user-role {
            color: #91a2b9;
            font-size: 11px;
            margin-top: 3px;
        }

        .logout {
            display: block;
            text-decoration: none;
            text-align: center;
            color: #cbd5e1;
            border: 1px solid rgba(255, 255, 255, 0.13);
            border-radius: 7px;
            padding: 10px;
            font-size: 13px;
            transition: 0.2s ease;
        }

        .logout:hover {
            background: rgba(255, 255, 255, 0.08);
            color: white;
        }

        /* ========================================================
           MAIN CONTENT
           ======================================================== */

        .main {
            margin-left: 250px;
            width: calc(100% - 250px);
            min-height: 100vh;
        }

        .topbar {
            height: 76px;
            background: white;
            border-bottom: 1px solid #e5eaf0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 36px;
        }

        .topbar-title {
            font-size: 21px;
            font-weight: 700;
            color: #172033;
        }

        .topbar-subtitle {
            color: #7b8798;
            font-size: 13px;
            margin-top: 4px;
        }

        .top-user {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .top-avatar {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: #e7f0ff;
            color: #1769e0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
        }

        .content {
            padding: 34px 36px 45px;
        }

        /* ========================================================
           RESULT HEADER
           ======================================================== */

        .page-heading {
            margin-bottom: 24px;
        }

        .page-heading h1 {
            font-size: 25px;
            color: #172033;
            margin-bottom: 7px;
        }

        .page-heading p {
            color: #7b8798;
            font-size: 14px;
        }

        /* ========================================================
           NO RESULT
           ======================================================== */

        .no-result {
            background: white;
            border-radius: 12px;
            border: 1px solid #e5eaf0;
            padding: 55px 30px;
            text-align: center;
            max-width: 800px;
            margin: 20px auto;
            box-shadow: 0 3px 12px rgba(15, 23, 42, 0.04);
        }

        .no-result-icon {
            width: 68px;
            height: 68px;
            border-radius: 50%;
            background: #eef4ff;
            color: #1769e0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
            margin: 0 auto 18px;
        }

        .no-result h2 {
            color: #172033;
            font-size: 21px;
            margin-bottom: 9px;
        }

        .no-result p {
            color: #7b8798;
            font-size: 14px;
            margin-bottom: 22px;
        }

        /* ========================================================
           RESULT CARD
           ======================================================== */

        .result-card {
            background: white;
            border: 1px solid #e5eaf0;
            border-radius: 13px;
            max-width: 900px;
            margin: 0 auto;
            overflow: hidden;
            box-shadow: 0 4px 14px rgba(15, 23, 42, 0.05);
        }

        .result-card-header {
            background: #0b1f3a;
            color: white;
            padding: 27px 30px;
        }

        .result-card-header h2 {
            font-size: 21px;
            margin-bottom: 7px;
        }

        .result-card-header p {
            color: #b9c7d9;
            font-size: 13px;
        }

        .status-badge {
            display: inline-block;
            margin-top: 15px;
            padding: 7px 12px;
            border-radius: 20px;
            background: rgba(255, 255, 255, 0.12);
            color: white;
            font-size: 12px;
            font-weight: 600;
        }

        .result-body {
            padding: 30px;
        }

        /* ========================================================
           SCORE
           ======================================================== */

        .score-section {
            text-align: center;
            padding: 8px 0 30px;
            border-bottom: 1px solid #edf0f4;
        }

        .score-circle {
            width: 145px;
            height: 145px;
            border-radius: 50%;
            border: 9px solid #e8f0ff;
            margin: 0 auto 17px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            background: #f8fbff;
        }

        .percentage {
            font-size: 32px;
            font-weight: 800;
            color: #1769e0;
        }

        .percentage-label {
            color: #7b8798;
            font-size: 11px;
            margin-top: 2px;
        }

        .score-text {
            color: #4b5563;
            font-size: 14px;
        }

        .score-text strong {
            color: #172033;
        }

        /* ========================================================
           STAT GRID
           ======================================================== */

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-top: 26px;
        }

        .stat-box {
            border: 1px solid #e5eaf0;
            border-radius: 9px;
            padding: 20px;
            text-align: center;
            background: #fbfcfe;
        }

        .stat-value {
            font-size: 25px;
            font-weight: 750;
            color: #172033;
            margin-bottom: 6px;
        }

        .stat-label {
            color: #7b8798;
            font-size: 12px;
        }

        .answered .stat-value {
            color: #16834b;
        }

        .unanswered .stat-value {
            color: #dc6b20;
        }

        .total .stat-value {
            color: #1769e0;
        }

        /* ========================================================
           MESSAGE
           ======================================================== */

        .message {
            margin-top: 22px;
            padding: 15px 17px;
            border-radius: 8px;
            background: #f4f8ff;
            border: 1px solid #dce8fb;
            color: #526174;
            font-size: 13px;
            line-height: 1.6;
        }

        /* ========================================================
           ACTIONS
           ======================================================== */

        .actions {
            display: flex;
            justify-content: center;
            gap: 12px;
            margin-top: 28px;
        }

        .btn {
            display: inline-block;
            text-decoration: none;
            padding: 11px 20px;
            border-radius: 7px;
            font-size: 13px;
            font-weight: 600;
            transition: 0.2s ease;
        }

        .btn-primary {
            background: #1769e0;
            color: white;
        }

        .btn-primary:hover {
            background: #0f57c2;
        }

        .btn-secondary {
            background: white;
            color: #475569;
            border: 1px solid #d8dee8;
        }

        .btn-secondary:hover {
            background: #f5f7fa;
        }

        /* ========================================================
           FOOTER
           ======================================================== */

        .footer {
            text-align: center;
            color: #8a96a6;
            font-size: 12px;
            padding: 20px 0 5px;
        }

        /* ========================================================
           RESPONSIVE
           ======================================================== */

        @media (max-width: 800px) {

            .sidebar {
                width: 210px;
            }

            .main {
                margin-left: 210px;
                width: calc(100% - 210px);
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .topbar {
                padding: 0 20px;
            }

            .content {
                padding: 25px 20px 35px;
            }
        }

        @media (max-width: 600px) {

            .sidebar {
                position: relative;
                width: 100%;
                min-height: auto;
            }

            .page-wrapper {
                display: block;
            }

            .main {
                margin-left: 0;
                width: 100%;
            }

            .navigation {
                padding-bottom: 10px;
            }

            .sidebar-bottom {
                display: none;
            }

            .topbar {
                height: auto;
                padding: 18px;
            }

            .top-user {
                display: none;
            }

            .result-body {
                padding: 20px;
            }

            .result-card-header {
                padding: 22px;
            }

            .actions {
                flex-direction: column;
            }

            .btn {
                text-align: center;
            }
        }

    </style>

</head>

<body>

<div class="page-wrapper">

    <!-- ========================================================
         SIDEBAR
         ======================================================== -->

    <aside class="sidebar">

        <div class="brand">
            <div class="brand-title">
                Online Examination
            </div>

            <div class="brand-subtitle">
                Student Portal
            </div>
        </div>

        <nav class="navigation">

            <div class="navigation-title">
                Menu
            </div>

            <a href="<%= request.getContextPath() %>/student/dashboard.jsp"
               class="nav-link">

                <span class="nav-icon">⌂</span>
                <span>Dashboard</span>

            </a>

            <a href="<%= request.getContextPath() %>/student/dashboard.jsp#available-exams"
               class="nav-link">

                <span class="nav-icon">▣</span>
                <span>Available Exams</span>

            </a>

            <a href="<%= request.getContextPath() %>/student/result.jsp"
               class="nav-link active">

                <span class="nav-icon">✓</span>
                <span>My Results</span>

            </a>

            <a href="<%= request.getContextPath() %>/student/profile"
               class="nav-link">

                <span class="nav-icon">●</span>
                <span>My Profile</span>

            </a>

            <a href="<%= request.getContextPath() %>/student/dashboard.jsp"
               class="nav-link">

                <span class="nav-icon">◷</span>
                <span>Exam History</span>

            </a>

        </nav>

        <div class="sidebar-bottom">

            <div class="user-box">

                <div class="avatar">
                    <%= user.getName() != null && !user.getName().isEmpty()
                        ? user.getName().substring(0, 1).toUpperCase()
                        : "S" %>
                </div>

                <div class="user-details">

                    <div class="user-name">
                        <%= user.getName() %>
                    </div>

                    <div class="user-role">
                        Student
                    </div>

                </div>

            </div>

            <a href="<%= request.getContextPath() %>/logout"
               class="logout">
                Logout
            </a>

        </div>

    </aside>


    <!-- ========================================================
         MAIN CONTENT
         ======================================================== -->

    <main class="main">

        <header class="topbar">

            <div>
                <div class="topbar-title">
                    My Results
                </div>

                <div class="topbar-subtitle">
                    View your latest examination result
                </div>
            </div>

            <div class="top-user">

                <div>
                    <strong><%= user.getName() %></strong>
                </div>

                <div class="top-avatar">
                    <%= user.getName() != null && !user.getName().isEmpty()
                        ? user.getName().substring(0, 1).toUpperCase()
                        : "S" %>
                </div>

            </div>

        </header>


        <section class="content">

            <div class="page-heading">

                <h1>
                    Examination Result
                </h1>

                <p>
                    Here you can view the result of your latest completed examination.
                </p>

            </div>


            <% if (!resultAvailable) { %>

                <!-- ====================================================
                     NO RESULT AVAILABLE
                     ==================================================== -->

                <div class="no-result">

                    <div class="no-result-icon">
                        ✓
                    </div>

                    <h2>
                        No Result Available
                    </h2>

                    <p>
                        You have not completed an examination yet.
                        Complete an exam to see your result here.
                    </p>

                    <a href="<%= request.getContextPath() %>/student/dashboard.jsp#available-exams"
                       class="btn btn-primary">
                        View Available Exams
                    </a>

                </div>

            <% } else { %>

                <!-- ====================================================
                     RESULT CARD
                     ==================================================== -->

                <div class="result-card">

                    <div class="result-card-header">

                        <h2>
                            Examination Result
                        </h2>

                        <p>
                            Student: <%= user.getName() %>
                        </p>

                        <span class="status-badge">
                            <%= resultStatus %>
                        </span>

                    </div>


                    <div class="result-body">

                        <!-- SCORE -->

                        <div class="score-section">

                            <div class="score-circle">

                                <div class="percentage">
                                    <%= String.format("%.1f", percentage) %>%
                                </div>

                                <div class="percentage-label">
                                    SCORE
                                </div>

                            </div>

                            <div class="score-text">

                                You scored
                                <strong>
                                    <%= score %>
                                </strong>
                                out of
                                <strong>
                                    <%= totalQuestions %>
                                </strong>

                            </div>

                        </div>


                        <!-- STATISTICS -->

                        <div class="stats-grid">

                            <div class="stat-box answered">

                                <div class="stat-value">
                                    <%= answered %>
                                </div>

                                <div class="stat-label">
                                    Answered
                                </div>

                            </div>


                            <div class="stat-box unanswered">

                                <div class="stat-value">
                                    <%= unanswered %>
                                </div>

                                <div class="stat-label">
                                    Unanswered
                                </div>

                            </div>


                            <div class="stat-box total">

                                <div class="stat-value">
                                    <%= totalQuestions %>
                                </div>

                                <div class="stat-label">
                                    Total Questions
                                </div>

                            </div>

                        </div>


                        <!-- MESSAGE -->

                        <div class="message">
                            <%= resultMessage %>
                        </div>


                        <!-- ACTIONS -->

                        <div class="actions">

                            <a href="<%= request.getContextPath() %>/student/dashboard.jsp"
                               class="btn btn-primary">
                                Back to Dashboard
                            </a>

                            <a href="<%= request.getContextPath() %>/student/dashboard.jsp#available-exams"
                               class="btn btn-secondary">
                                View Available Exams
                            </a>

                        </div>

                    </div>

                </div>

            <% } %>


            <div class="footer">
                Online Examination System &nbsp;•&nbsp; Student Portal
            </div>

        </section>

    </main>

</div>

</body>

</html>