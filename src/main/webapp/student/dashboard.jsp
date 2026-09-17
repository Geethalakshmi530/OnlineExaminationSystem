<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ page import="com.exam.model.User" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect(
            request.getContextPath() + "/login.jsp?error=Please login first"
        );
        return;
    }

    if (!"STUDENT".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(
            request.getContextPath() + "/admin/dashboard.jsp"
        );
        return;
    }

    String studentName = user.getName();
    String initial = "U";

    if (studentName != null && !studentName.trim().isEmpty()) {
        initial = studentName.trim().substring(0, 1).toUpperCase();
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Student Dashboard | Online Examination System</title>

    <!-- IMPORTANT: CSS IS INSIDE /css/ -->
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/style.css">

    <style>

        /* =====================================================
           STUDENT DASHBOARD
           UI ONLY - NO FUNCTIONALITY CHANGED
           ===================================================== */

        .student-layout {
            min-height: 100vh;
        }

        /* ================= SIDEBAR ================= */

        .student-sidebar {
            position: fixed;
            top: 0;
            left: 0;

            width: 250px;
            height: 100vh;

            background: linear-gradient(
                180deg,
                #1e3a8a,
                #2563eb
            );

            padding: 25px 16px;

            color: white;

            display: flex;
            flex-direction: column;

            z-index: 1000;

            box-sizing: border-box;
        }

        .student-brand {
            padding: 5px 12px 28px;

            border-bottom: 1px solid rgba(255,255,255,0.15);

            margin-bottom: 20px;
        }

        .student-brand h2 {
            margin: 0;

            color: white;

            font-size: 21px;

            line-height: 1.3;
        }

        .student-brand p {
            margin: 5px 0 0;

            color: #bfdbfe;

            font-size: 13px;
        }

        /* ================= NAVIGATION ================= */

        .student-nav {
            display: flex;

            flex-direction: column;

            gap: 5px;
        }

        .student-nav a {
            display: flex;

            align-items: center;

            gap: 11px;

            padding: 12px 14px;

            border-radius: 9px;

            color: #dbeafe;

            font-size: 14px;

            font-weight: 500;

            text-decoration: none;

            transition: all 0.2s ease;
        }

        .student-nav a:hover {
            background: rgba(255,255,255,0.13);

            color: white;

            transform: translateX(2px);
        }

        .student-nav a.active {
            background: white;

            color: #1d4ed8;

            font-weight: 700;
        }

        /* ================= SIDEBAR BOTTOM ================= */

        .student-sidebar-bottom {
            margin-top: auto;
        }

        .student-user {
            padding: 14px;

            margin-bottom: 10px;

            border-radius: 10px;

            background: rgba(255,255,255,0.10);
        }

        .student-user strong {
            display: block;

            color: white;

            font-size: 14px;
        }

        .student-user span {
            color: #bfdbfe;

            font-size: 12px;
        }

        .student-logout {
            display: block;

            padding: 12px 14px;

            border-radius: 9px;

            color: #fee2e2 !important;

            font-size: 14px;

            text-decoration: none;
        }

        .student-logout:hover {
            background: rgba(220,38,38,0.25);

            color: white !important;
        }

        /* ================= MAIN ================= */

        .student-main {
            margin-left: 250px;

            min-height: 100vh;

            background: #f4f7fb;

            padding: 28px 32px 45px;

            box-sizing: border-box;
        }

        /* ================= TOP BAR ================= */

        .student-topbar {
            display: flex;

            justify-content: space-between;

            align-items: center;

            background: white;

            border: 1px solid #e2e8f0;

            border-radius: 14px;

            padding: 17px 22px;

            margin-bottom: 28px;

            box-shadow:
                0 3px 12px rgba(15,23,42,0.05);
        }

        .student-topbar-left h1 {
            margin: 0;

            color: #0f172a;

            font-size: 24px;
        }

        .student-topbar-left p {
            margin: 3px 0 0;

            color: #64748b;

            font-size: 13px;
        }

        /* ================= PROFILE ================= */

        .student-profile {
            display: flex;

            align-items: center;

            gap: 10px;
        }

        .student-avatar {
            width: 40px;

            height: 40px;

            border-radius: 50%;

            background: #dbeafe;

            color: #1d4ed8;

            display: flex;

            align-items: center;

            justify-content: center;

            font-weight: 700;
        }

        .student-profile-text strong {
            display: block;

            color: #1e293b;

            font-size: 13px;
        }

        .student-profile-text span {
            color: #64748b;

            font-size: 11px;
        }

        /* ================= WELCOME ================= */

        .welcome-banner {
            position: relative;

            overflow: hidden;

            background:
                linear-gradient(
                    135deg,
                    #1e3a8a,
                    #2563eb
                );

            color: white;

            border-radius: 16px;

            padding: 30px;

            margin-bottom: 24px;

            box-shadow:
                0 8px 24px rgba(37,99,235,0.18);
        }

        .welcome-banner::after {
            content: "";

            position: absolute;

            width: 190px;

            height: 190px;

            border-radius: 50%;

            right: -55px;

            top: -65px;

            background: rgba(255,255,255,0.08);
        }

        .welcome-banner h2 {
            position: relative;

            z-index: 1;

            margin: 0 0 7px;

            font-size: 26px;
        }

        .welcome-banner p {
            position: relative;

            z-index: 1;

            margin: 0;

            color: #dbeafe;

            font-size: 14px;

            max-width: 650px;
        }

        /* ================= SECTION ================= */

        .section-heading {
            display: flex;

            justify-content: space-between;

            align-items: center;

            margin: 28px 0 14px;
        }

        .section-heading h2 {
            margin: 0;

            color: #0f172a;

            font-size: 19px;
        }

        .section-heading span {
            color: #64748b;

            font-size: 12px;
        }

        /* ================= STATS ================= */

        .student-stats {
            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 18px;
        }

        .student-stat {
            background: white;

            border: 1px solid #e2e8f0;

            border-radius: 13px;

            padding: 20px;

            box-shadow:
                0 2px 9px rgba(15,23,42,0.04);
        }

        .student-stat-icon {
            width: 42px;

            height: 42px;

            border-radius: 10px;

            background: #eff6ff;

            color: #2563eb;

            display: flex;

            align-items: center;

            justify-content: center;

            font-size: 19px;

            margin-bottom: 13px;
        }

        .student-stat-label {
            color: #64748b;

            font-size: 12px;

            font-weight: 600;
        }

        .student-stat-value {
            color: #1e3a8a;

            font-size: 25px;

            font-weight: 700;

            margin-top: 3px;
        }

        /* ================= AVAILABLE EXAM ================= */

        .available-exam {
            background: white;

            border: 1px solid #dbeafe;

            border-radius: 15px;

            padding: 23px;

            box-shadow:
                0 3px 12px rgba(15,23,42,0.05);
        }

        .exam-top {
            display: flex;

            justify-content: space-between;

            gap: 20px;

            align-items: flex-start;
        }

        .exam-title {
            margin: 0;

            color: #1e3a8a;

            font-size: 19px;
        }

        .exam-description {
            margin: 6px 0 0;

            color: #64748b;

            font-size: 13px;
        }

        .available-badge {
            white-space: nowrap;

            background: #dcfce7;

            color: #166534;

            padding: 5px 10px;

            border-radius: 999px;

            font-size: 11px;

            font-weight: 700;
        }

        /* ================= EXAM DETAILS ================= */

        .exam-details {
            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 12px;

            margin: 20px 0;
        }

        .exam-detail {
            background: #f8fafc;

            border: 1px solid #e2e8f0;

            border-radius: 9px;

            padding: 12px;
        }

        .exam-detail span {
            display: block;

            color: #64748b;

            font-size: 11px;

            margin-bottom: 3px;
        }

        .exam-detail strong {
            color: #334155;

            font-size: 14px;
        }

        /* ================= EXAM BUTTON ================= */

        .exam-action {
            display: flex;

            justify-content: flex-end;
        }

        .view-exam-btn {
            display: inline-flex;

            align-items: center;

            gap: 7px;

            padding: 11px 20px;

            border-radius: 8px;

            background: #2563eb;

            color: white;

            font-size: 13px;

            font-weight: 700;

            text-decoration: none;

            transition: 0.2s ease;
        }

        .view-exam-btn:hover {
            background: #1d4ed8;

            color: white;

            transform: translateY(-1px);
        }

        /* ================= QUICK ACTIONS ================= */

        .quick-grid {
            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 15px;
        }

        .quick-card {
            background: white;

            border: 1px solid #e2e8f0;

            border-radius: 12px;

            padding: 18px;

            transition: 0.2s ease;
        }

        .quick-card:hover {
            border-color: #93c5fd;

            transform: translateY(-2px);

            box-shadow:
                0 5px 15px rgba(37,99,235,0.08);
        }

        .quick-card h3 {
            margin: 0 0 5px;

            color: #334155;

            font-size: 14px;
        }

        .quick-card p {
            margin: 0;

            color: #64748b;

            font-size: 12px;
        }

        .quick-card a {
            display: inline-block;

            margin-top: 10px;

            color: #2563eb;

            font-size: 12px;

            font-weight: 700;

            text-decoration: none;
        }

        .quick-card a:hover {
            color: #1d4ed8;

            text-decoration: underline;
        }

        /* ================= RESPONSIVE ================= */

        @media (max-width: 900px) {

            .student-sidebar {
                width: 210px;
            }

            .student-main {
                margin-left: 210px;

                padding: 22px;
            }

            .student-stats,
            .quick-grid {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media (max-width: 700px) {

            .student-sidebar {
                position: relative;

                width: 100%;

                height: auto;
            }

            .student-sidebar-bottom {
                margin-top: 20px;
            }

            .student-main {
                margin-left: 0;

                padding: 15px;
            }

            .student-topbar {
                flex-direction: column;

                align-items: flex-start;

                gap: 12px;
            }

            .student-stats,
            .quick-grid,
            .exam-details {
                grid-template-columns: 1fr;
            }

            .exam-top {
                flex-direction: column;
            }

            .exam-action {
                justify-content: flex-start;
            }
        }

    </style>

</head>

<body>

<div class="student-layout">

    <!-- =====================================================
         SIDEBAR
         ===================================================== -->

    <aside class="student-sidebar">

        <div class="student-brand">

            <h2>Online Examination</h2>

            <p>Student Portal</p>

        </div>

        <nav class="student-nav">

            <a href="<%= request.getContextPath() %>/student/dashboard.jsp"
               class="active">

                <span>🏠</span>
                <span>Dashboard</span>

            </a>

            <a href="#available-exams">

                <span>📝</span>
                <span>Available Exams</span>

            </a>

            <!--
                Result functionality is NOT changed here.
                Existing project result URL has not been assumed.
            -->
            <a href="<%= request.getContextPath() %>/student/result.jsp">

    <span>📊</span>
    <span>My Results</span>

</a>

            <a href="<%= request.getContextPath() %>/student/profile">

                <span>👤</span>
                <span>My Profile</span>

            </a>

            <a href="#">

                <span>🕘</span>
                <span>Exam History</span>

            </a>

        </nav>

        <div class="student-sidebar-bottom">

            <div class="student-user">

                <strong>
                    <%= user.getName() %>
                </strong>

                <span>
                    Student Account
                </span>

            </div>

            <a href="<%= request.getContextPath() %>/logout"
               class="student-logout">

                🚪 Logout

            </a>

        </div>

    </aside>


    <!-- =====================================================
         MAIN CONTENT
         ===================================================== -->

    <main class="student-main">


        <!-- TOP BAR -->

        <div class="student-topbar">

            <div class="student-topbar-left">

                <h1>
                    Student Dashboard
                </h1>

                <p>
                    Manage your examinations and track your progress.
                </p>

            </div>

            <div class="student-profile">

                <div class="student-avatar">

                    <%= initial %>

                </div>

                <div class="student-profile-text">

                    <strong>
                        <%= user.getName() %>
                    </strong>

                    <span>
                        Student
                    </span>

                </div>

            </div>

        </div>


        <!-- WELCOME -->

        <section class="welcome-banner">

            <h2>
                Welcome back, <%= user.getName() %>! 👋
            </h2>

            <p>
                Your examination portal is ready.
                View available exams, attend your tests
                and monitor your performance.
            </p>

        </section>


        <!-- STATISTICS -->

        <div class="section-heading">

            <h2>
                Your Overview
            </h2>

            <span>
                Keep track of your examination activity
            </span>

        </div>


        <div class="student-stats">

            <div class="student-stat">

                <div class="student-stat-icon">
                    📝
                </div>

                <div class="student-stat-label">
                    Available Exams
                </div>

                <div class="student-stat-value">
                    1
                </div>

            </div>


            <div class="student-stat">

                <div class="student-stat-icon">
                    ✓
                </div>

                <div class="student-stat-label">
                    Completed Exams
                </div>

                <div class="student-stat-value">
                    0
                </div>

            </div>


            <div class="student-stat">

                <div class="student-stat-icon">
                    📈
                </div>

                <div class="student-stat-label">
                    Average Score
                </div>

                <div class="student-stat-value">
                    —
                </div>

            </div>

        </div>


        <!-- AVAILABLE EXAMS -->

        <div class="section-heading"
             id="available-exams">

            <h2>
                Available Exams
            </h2>

            <span>
                Choose an exam to begin
            </span>

        </div>


        <div class="available-exam">

            <div class="exam-top">

                <div>

                    <h3 class="exam-title">
                        Java Programming Test
                    </h3>

                    <p class="exam-description">
                        Test your knowledge of Java programming fundamentals.
                    </p>

                </div>

                <span class="available-badge">
                    AVAILABLE
                </span>

            </div>


            <div class="exam-details">

                <div class="exam-detail">

                    <span>
                        Duration
                    </span>

                    <strong>
                        30 minutes
                    </strong>

                </div>


                <div class="exam-detail">

                    <span>
                        Questions
                    </span>

                    <strong>
                        5 questions
                    </strong>

                </div>


                <div class="exam-detail">

                    <span>
                        Exam Type
                    </span>

                    <strong>
                        Online Test
                    </strong>

                </div>

            </div>


            <div class="exam-action">

                <a href="<%= request.getContextPath() %>/student/exam?examId=1"
                   class="view-exam-btn">

                    View Exam →

                </a>

            </div>

        </div>


        <!-- QUICK ACTIONS -->

        <div class="section-heading">

            <h2>
                Quick Access
            </h2>

            <span>
                Useful student options
            </span>

        </div>


        <div class="quick-grid">


            <div class="quick-card">

                <h3>
                    Available Exams
                </h3>

                <p>
                    View examinations that are currently available.
                </p>

                <a href="#available-exams">
                    View Exams →
                </a>

            </div>


            <div class="quick-card">

                <h3>
                    My Results
                </h3>

                <p>
                    Review your examination scores and performance.
                </p>

                <a href="#">
                    View Results →
                </a>

            </div>


            <div class="quick-card">

                <h3>
                    Exam History
                </h3>

                <p>
                    Keep track of your previous examination activity.
                </p>

                <a href="#">
                    View History →
                </a>

            </div>


        </div>

    </main>

</div>

</body>

</html>