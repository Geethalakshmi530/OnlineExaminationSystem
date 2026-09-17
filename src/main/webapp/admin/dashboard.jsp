<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ page import="com.exam.model.User" %>

<%
    // =========================================================
    // GET LOGGED-IN USER
    // =========================================================

    User user = (User) session.getAttribute("user");

    // =========================================================
    // SECURITY CHECK
    // =========================================================

    if (user == null) {

        response.sendRedirect(
            request.getContextPath() + "/login.jsp"
        );

        return;
    }

    // Only ADMIN can access this page
    if (!"ADMIN".equalsIgnoreCase(user.getRole())) {

        response.sendRedirect(
            request.getContextPath() + "/student/dashboard.jsp"
        );

        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Admin Dashboard | Online Examination System</title>

    <style>

        /* =====================================================
           RESET
           ===================================================== */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #f4f7fb;
            color: #172033;
        }


        /* =====================================================
           MAIN LAYOUT
           ===================================================== */

        .dashboard-layout {
            min-height: 100vh;
            display: flex;
        }


        /* =====================================================
           SIDEBAR
           ===================================================== */

        .sidebar {
            width: 250px;
            min-height: 100vh;
            background: #0f2f6b;
            color: white;

            position: fixed;
            left: 0;
            top: 0;
            bottom: 0;

            display: flex;
            flex-direction: column;
        }


        /* =====================================================
           SIDEBAR BRAND
           ===================================================== */

        .sidebar-brand {
            padding: 27px 24px;
            border-bottom: 1px solid rgba(255,255,255,0.12);
        }

        .brand-logo {
            width: 45px;
            height: 45px;

            display: flex;
            align-items: center;
            justify-content: center;

            background: white;
            color: #2563eb;

            border-radius: 12px;

            font-size: 18px;
            font-weight: 800;

            margin-bottom: 15px;
        }

        .sidebar-brand h2 {
            font-size: 20px;
            margin-bottom: 5px;
            color: white;
        }

        .sidebar-brand p {
            font-size: 13px;
            color: #b9c9e8;
        }


        /* =====================================================
           SIDEBAR MENU
           ===================================================== */

        .sidebar-menu {
            padding: 22px 14px;
            flex: 1;
        }

        .menu-title {
            padding: 0 13px 11px;

            color: #91a9d3;

            font-size: 11px;
            font-weight: 800;

            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .sidebar-menu a {
            display: flex;
            align-items: center;

            gap: 12px;

            padding: 12px 14px;
            margin-bottom: 5px;

            border-radius: 9px;

            color: #dbe7fb;
            text-decoration: none;

            font-size: 14px;
            font-weight: 500;

            transition: 0.2s ease;
        }

        .sidebar-menu a:hover {
            background: rgba(255,255,255,0.10);
            color: white;
        }

        .sidebar-menu a.active {
            background: #2563eb;
            color: white;

            box-shadow:
                0 6px 18px rgba(37,99,235,0.30);
        }

        .menu-icon {
            width: 22px;

            display: flex;
            align-items: center;
            justify-content: center;

            font-size: 15px;
            font-weight: 700;
        }


        /* =====================================================
           SIDEBAR FOOTER
           ===================================================== */

        .sidebar-footer {
            padding: 20px;
            border-top: 1px solid rgba(255,255,255,0.12);
        }

        .admin-profile {
            margin-bottom: 15px;
        }

        .admin-profile strong {
            display: block;

            color: white;
            font-size: 14px;

            margin-bottom: 4px;
        }

        .admin-profile span {
            color: #aebfdf;
            font-size: 12px;
        }

        .logout-button {
            display: block;

            width: 100%;

            padding: 10px;

            background: rgba(255,255,255,0.09);

            color: white;
            text-decoration: none;

            text-align: center;

            border-radius: 8px;

            font-size: 13px;
            font-weight: 700;

            transition: 0.2s ease;
        }

        .logout-button:hover {
            background: rgba(255,255,255,0.17);
        }


        /* =====================================================
           MAIN CONTENT
           ===================================================== */

        .main-content {
            margin-left: 250px;

            width: calc(100% - 250px);

            padding: 35px;
        }

        .content-wrapper {
            max-width: 1400px;
            margin: 0 auto;
        }


        /* =====================================================
           TOP BAR
           ===================================================== */

        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;

            margin-bottom: 30px;
        }

        .topbar h1 {
            color: #102a56;

            font-size: 30px;
            line-height: 1.2;

            margin-bottom: 8px;
        }

        .welcome-text {
            color: #64748b;
            font-size: 14px;
        }

        .welcome-text strong {
            color: #2563eb;
        }

        .admin-badge {
            background: #eff6ff;
            color: #2563eb;

            border: 1px solid #dbeafe;

            padding: 9px 15px;

            border-radius: 20px;

            font-size: 12px;
            font-weight: 800;
        }


        /* =====================================================
           STATISTICS
           ===================================================== */

        .stats-grid {
            display: grid;

            grid-template-columns:
                repeat(4, 1fr);

            gap: 18px;

            margin-bottom: 25px;
        }

        .stat-card {
            background: white;

            border: 1px solid #e4eaf2;

            border-radius: 15px;

            padding: 22px;

            box-shadow:
                0 5px 20px rgba(15,23,42,0.06);

            transition: 0.2s ease;
        }

        .stat-card:hover {
            transform: translateY(-2px);

            box-shadow:
                0 9px 25px rgba(15,23,42,0.09);
        }

        .stat-top {
            display: flex;
            justify-content: space-between;
            align-items: center;

            margin-bottom: 15px;
        }

        .stat-icon {
            width: 40px;
            height: 40px;

            display: flex;
            align-items: center;
            justify-content: center;

            background: #eff6ff;
            color: #2563eb;

            border-radius: 10px;

            font-size: 17px;
            font-weight: 800;
        }

        .stat-label {
            color: #64748b;

            font-size: 12px;
            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 0.4px;
        }

        .stat-card h2 {
            color: #172033;

            font-size: 30px;

            margin-bottom: 7px;
        }

        .stat-description {
            color: #94a3b8;

            font-size: 12px;
        }


        /* =====================================================
           CONTENT CARD
           ===================================================== */

        .content-card {
            background: white;

            border: 1px solid #e4eaf2;

            border-radius: 15px;

            padding: 25px;

            margin-bottom: 25px;

            box-shadow:
                0 5px 20px rgba(15,23,42,0.06);
        }

        .content-card-header {
            margin-bottom: 20px;
        }

        .content-card h2 {
            color: #172033;

            font-size: 19px;

            margin-bottom: 6px;
        }

        .content-card-subtitle {
            color: #64748b;

            font-size: 13px;
        }


        /* =====================================================
           QUICK ACTIONS
           ===================================================== */

        .action-grid {
            display: grid;

            grid-template-columns:
                repeat(4, 1fr);

            gap: 16px;
        }

        .action-card {
            border: 1px solid #e4eaf2;

            border-radius: 12px;

            padding: 20px;

            background: #fbfdff;

            transition: 0.2s ease;
        }

        .action-card:hover {
            border-color: #cbdcfb;

            background: #f8fbff;

            transform: translateY(-2px);
        }

        .action-icon {
            width: 42px;
            height: 42px;

            background: #eff6ff;
            color: #2563eb;

            border-radius: 10px;

            display: flex;
            align-items: center;
            justify-content: center;

            font-size: 18px;
            font-weight: 800;

            margin-bottom: 16px;
        }

        .action-card h3 {
            color: #172033;

            font-size: 15px;

            margin-bottom: 8px;
        }

        .action-card p {
            color: #64748b;

            font-size: 12px;
            line-height: 1.6;

            min-height: 58px;

            margin-bottom: 17px;
        }

        .secondary-button {
            display: inline-flex;

            align-items: center;
            justify-content: center;

            padding: 9px 12px;

            border-radius: 8px;

            background: #eff6ff;
            color: #2563eb;

            border: 1px solid #dbeafe;

            text-decoration: none;

            font-size: 12px;
            font-weight: 700;

            transition: 0.2s ease;
        }

        .secondary-button:hover {
            background: #2563eb;
            color: white;
        }


        /* =====================================================
           SYSTEM OVERVIEW TABLE
           ===================================================== */

        .table-container {
            width: 100%;

            overflow-x: auto;
        }

        .overview-table {
            width: 100%;

            border-collapse: collapse;

            min-width: 650px;
        }

        .overview-table th {
            background: #f5f8fc;

            color: #475569;

            text-align: left;

            padding: 13px 14px;

            font-size: 11px;
            font-weight: 800;

            text-transform: uppercase;

            letter-spacing: 0.4px;

            border-bottom: 1px solid #e2e8f0;
        }

        .overview-table td {
            padding: 15px 14px;

            color: #475569;

            font-size: 13px;

            border-bottom: 1px solid #edf1f6;
        }

        .overview-table tr:last-child td {
            border-bottom: none;
        }

        .overview-table tbody tr:hover {
            background: #f8fbff;
        }

        .module-name {
            color: #172033;

            font-weight: 700;
        }

        .status {
            display: inline-flex;

            padding: 6px 10px;

            border-radius: 20px;

            font-size: 11px;
            font-weight: 700;
        }

        .status-active {
            background: #ecfdf5;
            color: #047857;

            border: 1px solid #a7f3d0;
        }


        /* =====================================================
           FOOTER
           ===================================================== */

        .page-footer {
            text-align: center;

            color: #94a3b8;

            font-size: 11px;

            padding: 5px 0 15px;
        }


        /* =====================================================
           RESPONSIVE
           ===================================================== */

        @media (max-width: 1150px) {

            .stats-grid {
                grid-template-columns:
                    repeat(2, 1fr);
            }

            .action-grid {
                grid-template-columns:
                    repeat(2, 1fr);
            }
        }


        @media (max-width: 850px) {

            .sidebar {
                width: 215px;
            }

            .main-content {
                margin-left: 215px;

                width: calc(100% - 215px);

                padding: 25px;
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
                padding-bottom: 10px;
            }

            .main-content {
                margin-left: 0;

                width: 100%;

                padding: 20px;
            }

            .topbar {
                flex-direction: column;

                align-items: flex-start;

                gap: 15px;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .action-grid {
                grid-template-columns: 1fr;
            }

            .content-card {
                padding: 18px;
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


        <!-- BRAND -->

        <div class="sidebar-brand">

            <div class="brand-logo">
                OE
            </div>

            <h2>
                Online Exam
            </h2>

            <p>
                Administrator Portal
            </p>

        </div>


        <!-- MENU -->

        <nav class="sidebar-menu">

            <div class="menu-title">
                Management
            </div>


            <!-- DASHBOARD -->

            <a href="<%= request.getContextPath() %>/admin/dashboard.jsp"
               class="active">

                <span class="menu-icon">⌂</span>

                <span>
                    Dashboard
                </span>

            </a>


            <!-- STUDENTS -->

            <a href="<%= request.getContextPath() %>/admin/students">

                <span class="menu-icon">S</span>

                <span>
                    Students
                </span>

            </a>


            <!-- EXAMS -->

            <a href="<%= request.getContextPath() %>/admin/exams">

                <span class="menu-icon">E</span>

                <span>
                    Exams
                </span>

            </a>


            <!-- QUESTIONS -->

            <a href="<%= request.getContextPath() %>/admin/exams">

                <span class="menu-icon">Q</span>

                <span>
                    Questions
                </span>

            </a>


            <!-- RESULTS -->

           <a href="<%= request.getContextPath() %>/admin/results">

                <span class="menu-icon">R</span>

                <span>
                    Results &amp; Analytics
                </span>

            </a>


            <!-- AUDIT LOGS -->

           <a href="<%= request.getContextPath() %>/admin/audit-logs">

                <span class="menu-icon">A</span>

                <span>
                    Audit Logs
                </span>

            </a>

        </nav>


        <!-- SIDEBAR FOOTER -->

        <div class="sidebar-footer">

            <div class="admin-profile">

                <strong>
                    <%= user.getName() %>
                </strong>

                <span>
                    Administrator
                </span>

            </div>


            <a href="<%= request.getContextPath() %>/logout"
               class="logout-button">

                Logout

            </a>

        </div>

    </aside>



    <!-- =====================================================
         MAIN CONTENT
         ===================================================== -->

    <main class="main-content">

        <div class="content-wrapper">


            <!-- =================================================
                 TOP BAR
                 ================================================= -->

            <div class="topbar">

                <div>

                    <h1>
                        Admin Dashboard
                    </h1>

                    <p class="welcome-text">

                        Welcome back,
                        <strong>
                            <%= user.getName() %>
                        </strong>

                    </p>

                </div>


                <div class="admin-badge">
                    Administrator
                </div>

            </div>



            <!-- =================================================
                 STATISTICS
                 ================================================= -->

            <div class="stats-grid">


                <!-- TOTAL STUDENTS -->

                <div class="stat-card">

                    <div class="stat-top">

                        <span class="stat-label">
                            Total Students
                        </span>

                        <div class="stat-icon">
                            S
                        </div>

                    </div>

                    <h2>
                        ${dashboard.totalStudents}
                    </h2>

                    <span class="stat-description">
                        Registered students
                    </span>

                </div>



                <!-- ACTIVE EXAMS -->

                <div class="stat-card">

                    <div class="stat-top">

                        <span class="stat-label">
                            Active Exams
                        </span>

                        <div class="stat-icon">
                            E
                        </div>

                    </div>

                    <h2>
                        ${dashboard.activeExams}
                    </h2>

                    <span class="stat-description">
                        Currently available
                    </span>

                </div>



                <!-- TOTAL QUESTIONS -->

                <div class="stat-card">

                    <div class="stat-top">

                        <span class="stat-label">
                            Total Questions
                        </span>

                        <div class="stat-icon">
                            Q
                        </div>

                    </div>

                    <h2>
                        ${dashboard.totalQuestions}
                    </h2>

                    <span class="stat-description">
                        Question bank
                    </span>

                </div>



                <!-- EXAM ATTEMPTS -->

                <div class="stat-card">

                    <div class="stat-top">

                        <span class="stat-label">
                            Exam Attempts
                        </span>

                        <div class="stat-icon">
                            ✓
                        </div>

                    </div>

                    <h2>
                        ${dashboard.totalExamAttempts}
                    </h2>

                    <span class="stat-description">
                        Student attempts
                    </span>

                </div>

            </div>



            <!-- =================================================
                 QUICK ACTIONS
                 ================================================= -->

            <div class="content-card">

                <div class="content-card-header">

                    <h2>
                        Quick Actions
                    </h2>

                    <p class="content-card-subtitle">
                        Manage the main areas of your examination system.
                    </p>

                </div>


                <div class="action-grid">


                    <!-- STUDENT MANAGEMENT -->

                    <div class="action-card">

                        <div class="action-icon">
                            S
                        </div>

                        <h3>
                            Student Management
                        </h3>

                        <p>
                            Review registrations and manage
                            student accounts.
                        </p>

                        <a href="<%= request.getContextPath() %>/admin/students"
                           class="secondary-button">

                            Manage Students

                        </a>

                    </div>



                    <!-- EXAM MANAGEMENT -->

                    <div class="action-card">

                        <div class="action-icon">
                            E
                        </div>

                        <h3>
                            Exam Management
                        </h3>

                        <p>
                            Create, update and manage
                            online examinations.
                        </p>

                        <a href="<%= request.getContextPath() %>/admin/exams"
                           class="secondary-button">

                            Manage Exams

                        </a>

                    </div>



                    <!-- QUESTION MANAGEMENT -->

                    <div class="action-card">

                        <div class="action-icon">
                            Q
                        </div>

                        <h3>
                            Question Management
                        </h3>

                        <p>
                            Add and organize questions
                            for examinations.
                        </p>

                        <a href="<%= request.getContextPath() %>/admin/exams"
                           class="secondary-button">

                            Manage Questions

                        </a>

                    </div>



                    <!-- RESULTS -->

                    <div class="action-card">

                        <div class="action-icon">
                            R
                        </div>

                        <h3>
                            Results &amp; Analytics
                        </h3>

                        <p>
                            View examination results and
                            student performance.
                        </p>

                        <a href="#"
                           class="secondary-button">

                            View Analytics

                        </a>

                    </div>

                </div>

            </div>



            <!-- =================================================
                 SYSTEM OVERVIEW
                 ================================================= -->

            <div class="content-card">

                <div class="content-card-header">

                    <h2>
                        System Overview
                    </h2>

                    <p class="content-card-subtitle">
                        Current status of the examination system modules.
                    </p>

                </div>


                <div class="table-container">

                    <table class="overview-table">

                        <thead>

                            <tr>

                                <th>
                                    Module
                                </th>

                                <th>
                                    Description
                                </th>

                                <th>
                                    Status
                                </th>

                            </tr>

                        </thead>


                        <tbody>


                            <!-- STUDENT MANAGEMENT -->

                            <tr>

                                <td class="module-name">
                                    Student Management
                                </td>

                                <td>
                                    Student registration and approval
                                </td>

                                <td>

                                    <span class="status status-active">
                                        Available
                                    </span>

                                </td>

                            </tr>


                            <!-- EXAM MANAGEMENT -->

                            <tr>

                                <td class="module-name">
                                    Exam Management
                                </td>

                                <td>
                                    Examination creation and scheduling
                                </td>

                                <td>

                                    <span class="status status-active">
                                        Available
                                    </span>

                                </td>

                            </tr>


                            <!-- QUESTION MANAGEMENT -->

                            <tr>

                                <td class="module-name">
                                    Question Management
                                </td>

                                <td>
                                    Manage examination question bank
                                </td>

                                <td>

                                    <span class="status status-active">
                                        Available
                                    </span>

                                </td>

                            </tr>


                            <!-- RESULTS -->

                            <tr>

                                <td class="module-name">
                                    Results &amp; Analytics
                                </td>

                                <td>
                                    Performance and result analysis
                                </td>

                                <td>

                                    <span class="status status-active">
                                        Available
                                    </span>

                                </td>

                            </tr>


                        </tbody>

                    </table>

                </div>

            </div>



            <!-- =================================================
                 FOOTER
                 ================================================= -->

            <div class="page-footer">

                Online Examination System
                &nbsp; | &nbsp;
                Java • JSP • Servlet • JDBC • MySQL

            </div>


        </div>

    </main>

</div>

</body>

</html>