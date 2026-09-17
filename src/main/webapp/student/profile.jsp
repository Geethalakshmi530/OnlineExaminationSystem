<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.exam.model.User" %>

<%
    // ============================================================
    // USER LOGIN CHECK
    // ============================================================

    User user = (User) request.getAttribute("user");

    if (user == null) {
        response.sendRedirect(
            request.getContextPath() + "/login.jsp?error=Please login first"
        );
        return;
    }

    // ============================================================
    // USER INITIAL
    // ============================================================

    String userName = user.getName();

    if (userName == null || userName.trim().isEmpty()) {
        userName = "Student";
    }

    String initial = userName.substring(0, 1).toUpperCase();

    String email = user.getEmail();

    if (email == null) {
        email = "";
    }

    String role = user.getRole();

    if (role == null || role.trim().isEmpty()) {
        role = "STUDENT";
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>My Profile - Online Examination System</title>

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

        /* ========================================================
           MAIN LAYOUT
           ======================================================== */

        .profile-layout {
            display: flex;
            min-height: 100vh;
        }

        /* ========================================================
           SIDEBAR
           ======================================================== */

        .profile-sidebar {
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

        .profile-brand {
            padding: 28px 24px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.10);
        }

        .profile-brand h2 {
            font-size: 21px;
            font-weight: 700;
            color: white;
        }

        .profile-brand p {
            margin-top: 6px;
            color: #aebdd2;
            font-size: 12px;
        }

        .profile-navigation {
            padding: 22px 14px;
            flex: 1;
        }

        .profile-navigation-title {
            color: #8293aa;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            padding: 0 12px 12px;
        }

        .profile-navigation a {
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

        .profile-navigation a:hover {
            background: rgba(255, 255, 255, 0.08);
            color: white;
        }

        .profile-navigation a.profile-active {
            background: #1769e0;
            color: white;
            font-weight: 600;
        }

        .profile-nav-icon {
            width: 22px;
            text-align: center;
            font-size: 16px;
        }

        /* ========================================================
           SIDEBAR BOTTOM
           ======================================================== */

        .profile-sidebar-bottom {
            padding: 16px 14px 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.10);
        }

        .profile-sidebar-user {
            display: flex;
            align-items: center;
            gap: 11px;
            padding: 10px;
            margin-bottom: 10px;
        }

        .profile-small-avatar {
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

        .profile-sidebar-user-info {
            min-width: 0;
        }

        .profile-sidebar-user-name {
            color: white;
            font-size: 13px;
            font-weight: 600;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .profile-sidebar-user-role {
            color: #91a2b9;
            font-size: 11px;
            margin-top: 3px;
        }

        .profile-logout {
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

        .profile-logout:hover {
            background: rgba(255, 255, 255, 0.08);
            color: white;
        }

        /* ========================================================
           MAIN
           ======================================================== */

        .profile-main {
            margin-left: 250px;
            width: calc(100% - 250px);
            min-height: 100vh;
        }

        /* ========================================================
           TOPBAR
           ======================================================== */

        .profile-topbar {
            height: 76px;
            background: white;
            border-bottom: 1px solid #e5eaf0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 36px;
        }

        .profile-topbar-title {
            font-size: 21px;
            font-weight: 700;
            color: #172033;
        }

        .profile-topbar-subtitle {
            color: #7b8798;
            font-size: 13px;
            margin-top: 4px;
        }

        .profile-top-user {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #334155;
            font-size: 13px;
        }

        .profile-top-avatar {
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

        /* ========================================================
           CONTENT
           ======================================================== */

        .profile-content {
            padding: 34px 36px 45px;
        }

        .profile-main-card {
            background: white;
            border: 1px solid #e5eaf0;
            border-radius: 13px;
            overflow: hidden;
            max-width: 1000px;
            margin: 0 auto;
            box-shadow: 0 4px 14px rgba(15, 23, 42, 0.05);
        }

        /* ========================================================
           COVER
           ======================================================== */

        .profile-cover {
            height: 155px;
            background: #0b1f3a;
            position: relative;
        }

        .profile-cover-pattern {
            position: absolute;
            inset: 0;
            opacity: 0.08;
            background:
                radial-gradient(circle at 20% 30%, white 0, transparent 25%),
                radial-gradient(circle at 80% 70%, white 0, transparent 25%);
        }

        /* ========================================================
           PROFILE HEADER
           ======================================================== */

        .profile-header {
            padding: 0 32px 28px;
            position: relative;
        }

        .profile-large-avatar {
            width: 105px;
            height: 105px;
            border-radius: 50%;
            background: #1769e0;
            color: white;
            border: 6px solid white;
            position: relative;
            margin-top: -53px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 34px;
            font-weight: 700;
            box-shadow: 0 4px 12px rgba(15, 23, 42, 0.14);
        }

        .profile-name-section {
            margin-top: 16px;
        }

        .profile-name-section h1 {
            font-size: 26px;
            color: #172033;
            display: inline-block;
            margin-right: 9px;
        }

        .profile-approved-badge {
            display: inline-block;
            padding: 5px 9px;
            border-radius: 15px;
            background: #eaf8f0;
            color: #16834b;
            font-size: 11px;
            font-weight: 700;
            vertical-align: middle;
        }

        .profile-name-section p {
            color: #7b8798;
            font-size: 13px;
            margin-top: 7px;
        }

        /* ========================================================
           INFORMATION
           ======================================================== */

        .profile-information {
            border-top: 1px solid #edf0f4;
            padding: 28px 32px 32px;
        }

        .profile-information h2 {
            font-size: 18px;
            color: #172033;
            margin-bottom: 7px;
        }

        .profile-information-subtitle {
            color: #7b8798;
            font-size: 13px;
            margin-bottom: 22px;
        }

        .profile-information-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px;
        }

        .profile-information-box {
            border: 1px solid #e5eaf0;
            border-radius: 9px;
            padding: 18px;
            background: #fbfcfe;
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .profile-information-icon {
            width: 42px;
            height: 42px;
            border-radius: 9px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            flex-shrink: 0;
        }

        .profile-information-icon.blue {
            background: #eaf2ff;
            color: #1769e0;
        }

        .profile-information-icon.green {
            background: #eaf8f0;
            color: #16834b;
        }

        .profile-information-icon.orange {
            background: #fff4e8;
            color: #d97706;
        }

        .profile-information-box-content {
            min-width: 0;
        }

        .profile-information-label {
            color: #7b8798;
            font-size: 11px;
            margin-bottom: 5px;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        .profile-information-value {
            color: #172033;
            font-size: 14px;
            font-weight: 600;
            word-break: break-word;
        }

        .blue-text {
            color: #1769e0;
        }

        .green-text {
            color: #16834b;
        }

        .orange-text {
            color: #d97706;
        }

        /* ========================================================
           MESSAGE
           ======================================================== */

        .profile-information-message {
            margin-top: 20px;
            padding: 15px 17px;
            border-radius: 8px;
            background: #f4f8ff;
            border: 1px solid #dce8fb;
            color: #526174;
            font-size: 13px;
            line-height: 1.6;
        }

        /* ========================================================
           FOOTER
           ======================================================== */

        .profile-page-footer {
            text-align: center;
            color: #8a96a6;
            font-size: 12px;
            padding: 22px 0 5px;
        }

        /* ========================================================
           RESPONSIVE
           ======================================================== */

        @media (max-width: 800px) {

            .profile-sidebar {
                width: 210px;
            }

            .profile-main {
                margin-left: 210px;
                width: calc(100% - 210px);
            }

            .profile-information-grid {
                grid-template-columns: 1fr;
            }

            .profile-topbar {
                padding: 0 20px;
            }

            .profile-content {
                padding: 25px 20px 35px;
            }
        }

        @media (max-width: 600px) {

            .profile-layout {
                display: block;
            }

            .profile-sidebar {
                position: relative;
                width: 100%;
                min-height: auto;
            }

            .profile-main {
                margin-left: 0;
                width: 100%;
            }

            .profile-navigation {
                padding-bottom: 10px;
            }

            .profile-sidebar-bottom {
                display: none;
            }

            .profile-topbar {
                height: auto;
                padding: 18px;
            }

            .profile-top-user {
                display: none;
            }

            .profile-header {
                padding: 0 20px 25px;
            }

            .profile-information {
                padding: 25px 20px;
            }

            .profile-name-section h1 {
                font-size: 22px;
            }

        }

    </style>

</head>

<body>

<div class="profile-layout">

    <!-- ========================================================
         SIDEBAR
         ======================================================== -->

    <aside class="profile-sidebar">

        <div class="profile-brand">

            <h2>
                Online Examination
            </h2>

            <p>
                Student Portal
            </p>

        </div>


        <nav class="profile-navigation">

            <div class="profile-navigation-title">
                Menu
            </div>


            <!-- DASHBOARD -->

            <a href="<%= request.getContextPath() %>/student/dashboard.jsp">

                <span class="profile-nav-icon">⌂</span>

                <span>
                    Dashboard
                </span>

            </a>


            <!-- AVAILABLE EXAMS -->

            <a href="<%= request.getContextPath() %>/student/dashboard.jsp#available-exams">

                <span class="profile-nav-icon">▣</span>

                <span>
                    Available Exams
                </span>

            </a>


            <!-- MY RESULTS - FIXED -->

            <a href="<%= request.getContextPath() %>/student/result.jsp">

            <span>📊</span>

             <span>My Results</span>

             </a>


            <!-- MY PROFILE -->

            <a href="<%= request.getContextPath() %>/student/profile"
               class="profile-active">

                <span class="profile-nav-icon">●</span>

                <span>
                    My Profile
                </span>

            </a>


            <!-- EXAM HISTORY -->

            <a href="<%= request.getContextPath() %>/student/dashboard.jsp">

                <span class="profile-nav-icon">◷</span>

                <span>
                    Exam History
                </span>

            </a>

        </nav>


        <!-- ====================================================
             SIDEBAR USER
             ==================================================== -->

        <div class="profile-sidebar-bottom">

            <div class="profile-sidebar-user">

                <div class="profile-small-avatar">
                    <%= initial %>
                </div>

                <div class="profile-sidebar-user-info">

                    <div class="profile-sidebar-user-name">
                        <%= userName %>
                    </div>

                    <div class="profile-sidebar-user-role">
                        Student
                    </div>

                </div>

            </div>


            <a href="<%= request.getContextPath() %>/logout"
               class="profile-logout">

                Logout

            </a>

        </div>

    </aside>


    <!-- ========================================================
         MAIN
         ======================================================== -->

    <main class="profile-main">


        <!-- ====================================================
             TOPBAR
             ==================================================== -->

        <header class="profile-topbar">

            <div>

                <div class="profile-topbar-title">
                    My Profile
                </div>

                <div class="profile-topbar-subtitle">
                    View your account information
                </div>

            </div>


            <div class="profile-top-user">

                <span>
                    <strong><%= userName %></strong>
                </span>

                <div class="profile-top-avatar">
                    <%= initial %>
                </div>

            </div>

        </header>


        <!-- ====================================================
             CONTENT
             ==================================================== -->

        <section class="profile-content">

            <div class="profile-main-card">


                <!-- COVER -->

                <div class="profile-cover">

                    <div class="profile-cover-pattern"></div>

                </div>


                <!-- PROFILE HEADER -->

                <div class="profile-header">

                    <div class="profile-large-avatar">
                        <%= initial %>
                    </div>


                    <div class="profile-name-section">

                        <h1>
                            <%= userName %>
                        </h1>

                        <span class="profile-approved-badge">
                            ✓ Active
                        </span>

                        <p>
                            Student Account
                        </p>

                    </div>

                </div>


                <!-- INFORMATION -->

                <div class="profile-information">

                    <h2>
                        Personal Information
                    </h2>

                    <p class="profile-information-subtitle">
                        Your registered account details
                    </p>


                    <div class="profile-information-grid">


                        <!-- NAME -->

                        <div class="profile-information-box">

                            <div class="profile-information-icon blue">
                                👤
                            </div>

                            <div class="profile-information-box-content">

                                <div class="profile-information-label">
                                    Full Name
                                </div>

                                <div class="profile-information-value">
                                    <%= userName %>
                                </div>

                            </div>

                        </div>


                        <!-- EMAIL -->

                        <div class="profile-information-box">

                            <div class="profile-information-icon green">
                                ✉
                            </div>

                            <div class="profile-information-box-content">

                                <div class="profile-information-label">
                                    Email Address
                                </div>

                                <div class="profile-information-value">
                                    <%= email %>
                                </div>

                            </div>

                        </div>


                        <!-- ROLE -->

                        <div class="profile-information-box">

                            <div class="profile-information-icon blue">
                                🎓
                            </div>

                            <div class="profile-information-box-content">

                                <div class="profile-information-label">
                                    Role
                                </div>

                                <div class="profile-information-value blue-text">
                                    <%= role %>
                                </div>

                            </div>

                        </div>


                        <!-- STATUS -->

                        <div class="profile-information-box">

                            <div class="profile-information-icon green">
                                ✓
                            </div>

                            <div class="profile-information-box-content">

                                <div class="profile-information-label">
                                    Account Status
                                </div>

                                <div class="profile-information-value green-text">
                                    Active
                                </div>

                            </div>

                        </div>

                    </div>


                    <!-- INFORMATION MESSAGE -->

                    <div class="profile-information-message">

                        Your profile information is securely maintained
                        by the Online Examination System.

                    </div>

                </div>

            </div>


            <!-- FOOTER -->

            <div class="profile-page-footer">

                Online Examination System &nbsp;•&nbsp; Student Portal

            </div>

        </section>

    </main>

</div>

</body>

</html>