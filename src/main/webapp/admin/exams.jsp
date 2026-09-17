<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.exam.model.Exam" %>
<%@ page import="com.exam.model.User" %>

<%
    // =========================================================
    // ADMIN SECURITY CHECK
    // =========================================================

    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect(
            request.getContextPath() + "/login.jsp?error=Please login first"
        );
        return;
    }

    if (!"ADMIN".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(
            request.getContextPath() + "/student/dashboard.jsp?error=Access denied"
        );
        return;
    }

    // =========================================================
    // DATA FROM SERVLET
    // =========================================================

    @SuppressWarnings("unchecked")
    List<Exam> exams =
        (List<Exam>) request.getAttribute("exams");

    String success = request.getParameter("success");
    String error = request.getParameter("error");

    int examCount = (exams == null) ? 0 : exams.size();
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Manage Exams | Online Examination System</title>

    <!-- Global CSS -->
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/style.css">

    <style>

        /* =====================================================
           PAGE
           ===================================================== */

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
            background: #f4f7fb;
            color: #172033;
        }

        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }


        /* =====================================================
           SIDEBAR
           ===================================================== */

        .sidebar {
            width: 250px;
            min-height: 100vh;
            background: #0f2f6b;
            color: #ffffff;

            display: flex;
            flex-direction: column;

            position: fixed;
            left: 0;
            top: 0;
            bottom: 0;
        }

        .sidebar-header {
            padding: 28px 24px;
            border-bottom: 1px solid rgba(255,255,255,0.12);
        }

        .sidebar-logo {
            width: 44px;
            height: 44px;

            border-radius: 12px;
            background: #ffffff;
            color: #2563eb;

            display: flex;
            align-items: center;
            justify-content: center;

            font-size: 21px;
            font-weight: 800;

            margin-bottom: 15px;
        }

        .sidebar-header h2 {
            margin: 0;
            font-size: 20px;
            font-weight: 700;
        }

        .sidebar-header p {
            margin: 6px 0 0;
            color: #b9c9e8;
            font-size: 13px;
        }

        .sidebar-nav {
            padding: 22px 14px;
            flex: 1;
        }

        .nav-section-title {
            padding: 0 12px 10px;

            font-size: 11px;
            font-weight: 700;
            letter-spacing: 1px;

            color: #91a9d3;

            text-transform: uppercase;
        }

        .sidebar-nav a {
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

        .sidebar-nav a:hover {
            background: rgba(255,255,255,0.10);
            color: #ffffff;
        }

        .sidebar-nav a.active {
            background: #2563eb;
            color: #ffffff;

            box-shadow: 0 5px 14px rgba(37,99,235,0.30);
        }


        /* =====================================================
           PROFESSIONAL SVG NAV ICONS
           ===================================================== */

        .nav-icon {
            width: 22px;
            height: 22px;

            display: inline-flex;
            align-items: center;
            justify-content: center;

            flex-shrink: 0;
        }

        .nav-icon svg {
            width: 18px;
            height: 18px;

            stroke: currentColor;
            fill: none;

            stroke-width: 2;

            stroke-linecap: round;
            stroke-linejoin: round;
        }


        /* =====================================================
           SIDEBAR FOOTER
           ===================================================== */

        .sidebar-footer {
            padding: 18px 20px;

            border-top: 1px solid rgba(255,255,255,0.12);
        }

        .admin-info {
            margin-bottom: 15px;
        }

        .admin-info strong {
            display: block;

            color: #ffffff;

            font-size: 14px;

            margin-bottom: 4px;
        }

        .admin-info span {
            color: #aebfdf;
            font-size: 12px;
        }

        .logout-btn {
            display: block;

            text-align: center;

            padding: 10px;

            border-radius: 8px;

            background: rgba(255,255,255,0.08);

            color: #ffffff;

            text-decoration: none;

            font-size: 13px;
            font-weight: 600;
        }

        .logout-btn:hover {
            background: rgba(255,255,255,0.16);
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
           PAGE HEADER
           ===================================================== */

        .page-header {
            display: flex;

            justify-content: space-between;
            align-items: center;

            margin-bottom: 28px;
        }

        .page-header h1 {
            margin: 0;

            font-size: 30px;

            color: #102a56;
        }

        .page-header p {
            margin: 7px 0 0;

            color: #64748b;

            font-size: 14px;
        }

        .header-badge {
            background: #e8f0ff;

            color: #2563eb;

            border: 1px solid #cfe0ff;

            padding: 9px 14px;

            border-radius: 20px;

            font-size: 13px;
            font-weight: 700;
        }


        /* =====================================================
           ALERTS
           ===================================================== */

        .alert {
            padding: 14px 17px;

            border-radius: 10px;

            margin-bottom: 20px;

            font-size: 14px;

            font-weight: 600;
        }

        .alert-success {
            background: #ecfdf5;

            color: #047857;

            border: 1px solid #a7f3d0;
        }

        .alert-error {
            background: #fef2f2;

            color: #b91c1c;

            border: 1px solid #fecaca;
        }


        /* =====================================================
           CREATE EXAM CARD
           ===================================================== */

        .exam-form-card {
            background: #ffffff;

            border: 1px solid #e4eaf3;

            border-radius: 15px;

            padding: 26px;

            margin-bottom: 25px;

            box-shadow: 0 5px 20px rgba(15, 23, 42, 0.06);
        }

        .card-heading {
            display: flex;

            align-items: center;

            gap: 13px;

            margin-bottom: 6px;
        }

        .card-icon {
            width: 40px;
            height: 40px;

            border-radius: 10px;

            background: #e8f0ff;

            color: #2563eb;

            display: flex;
            align-items: center;
            justify-content: center;

            font-size: 20px;

            font-weight: 700;

            flex-shrink: 0;
        }

        .card-icon svg {
            width: 20px;
            height: 20px;

            stroke: currentColor;
            fill: none;

            stroke-width: 2;

            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .exam-form-card h2 {
            margin: 0;

            font-size: 19px;

            color: #172033;
        }

        .exam-form-description {
            margin: 0 0 22px 53px;

            color: #64748b;

            font-size: 13px;
        }

        .exam-form {
            display: grid;

            grid-template-columns: 2fr 1fr 1fr auto;

            gap: 15px;

            align-items: end;
        }

        .form-group {
            display: flex;

            flex-direction: column;

            gap: 7px;
        }

        .form-group label {
            font-size: 12px;

            font-weight: 700;

            color: #334155;
        }

        .form-group input {
            width: 100%;

            padding: 12px 13px;

            border: 1px solid #cbd5e1;

            border-radius: 8px;

            background: #ffffff;

            color: #172033;

            font-size: 14px;

            outline: none;
        }

        .form-group input:focus {
            border-color: #2563eb;

            box-shadow: 0 0 0 3px rgba(37,99,235,0.10);
        }


        /* =====================================================
           BUTTONS
           ===================================================== */

        .btn {
            border: none;

            border-radius: 8px;

            padding: 10px 15px;

            font-size: 13px;

            font-weight: 700;

            cursor: pointer;

            text-decoration: none;

            display: inline-flex;

            align-items: center;

            justify-content: center;

            transition: 0.2s ease;

            white-space: nowrap;
        }

        .btn-primary {
            background: #2563eb;

            color: #ffffff !important;
        }

        .btn-primary:hover {
            background: #1d4ed8;
        }

        .btn-warning {
            background: #f59e0b;

            color: #ffffff !important;
        }

        .btn-warning:hover {
            background: #d97706;
        }

        .btn-danger {
            background: #dc2626;

            color: #ffffff !important;
        }

        .btn-danger:hover {
            background: #b91c1c;
        }

        .btn-small {
            padding: 8px 11px;

            font-size: 12px;
        }


        /* =====================================================
           TABLE CARD
           ===================================================== */

        .table-card {
            background: #ffffff;

            border: 1px solid #e4eaf3;

            border-radius: 15px;

            padding: 25px;

            box-shadow: 0 5px 20px rgba(15,23,42,0.06);

            overflow-x: auto;
        }

        .table-header {
            display: flex;

            justify-content: space-between;

            align-items: center;

            margin-bottom: 18px;
        }

        .table-title {
            display: flex;

            align-items: center;

            gap: 11px;
        }

        .table-title h2 {
            margin: 0;

            font-size: 19px;

            color: #172033;
        }

        .exam-count {
            background: #eff6ff;

            color: #2563eb;

            padding: 6px 10px;

            border-radius: 15px;

            font-size: 12px;

            font-weight: 700;
        }


        /* =====================================================
           TABLE
           ===================================================== */

        .exam-table {
            width: 100%;

            border-collapse: collapse;

            min-width: 850px;
        }

        .exam-table th {
            background: #f5f8fc;

            color: #475569;

            font-size: 11px;

            font-weight: 800;

            text-align: left;

            text-transform: uppercase;

            letter-spacing: 0.4px;

            padding: 14px;

            border-bottom: 1px solid #e2e8f0;
        }

        .exam-table td {
            padding: 16px 14px;

            border-bottom: 1px solid #edf1f6;

            color: #334155;

            font-size: 13px;

            vertical-align: middle;
        }

        .exam-table tbody tr:hover {
            background: #f8fbff;
        }

        .exam-table tbody tr:last-child td {
            border-bottom: none;
        }

        .exam-id {
            color: #2563eb;

            font-weight: 800;
        }

        .exam-name {
            font-weight: 700;

            color: #172033;
        }

        .duration-badge,
        .question-badge {
            display: inline-block;

            background: #f1f5f9;

            color: #475569;

            padding: 6px 9px;

            border-radius: 6px;

            font-size: 12px;

            font-weight: 600;
        }

        .created-date {
            color: #64748b;

            font-size: 12px;
        }

        .action-group {
            display: flex;

            gap: 7px;

            align-items: center;

            flex-wrap: wrap;
        }

        .inline-form {
            display: inline;

            margin: 0;
        }


        /* =====================================================
           EDIT DETAILS
           ===================================================== */

        .edit-details {
            position: relative;

            display: inline-block;
        }

        .edit-details summary {
            list-style: none;

            cursor: pointer;
        }

        .edit-details summary::-webkit-details-marker {
            display: none;
        }

        .edit-details[open] {
            z-index: 1000;
        }

        .edit-form {
            position: absolute;

            z-index: 1000;

            right: 0;

            top: 42px;

            width: 330px;

            background: #ffffff;

            border: 1px solid #dbe3ef;

            border-radius: 12px;

            padding: 18px;

            box-shadow: 0 15px 35px rgba(15,23,42,0.18);
        }

        .edit-form-title {
            margin: 0 0 16px;

            font-size: 16px;

            color: #172033;
        }

        .edit-form-group {
            display: flex;

            flex-direction: column;

            gap: 6px;

            margin-bottom: 14px;
        }

        .edit-form-group label {
            font-size: 12px;

            font-weight: 700;

            color: #475569;
        }

        .edit-form-group input {
            width: 100%;

            padding: 9px 11px;

            border: 1px solid #cbd5e1;

            border-radius: 7px;

            font-size: 13px;

            outline: none;
        }

        .edit-form-group input:focus {
            border-color: #2563eb;

            box-shadow: 0 0 0 3px rgba(37,99,235,0.10);
        }

        .edit-form-actions {
            display: flex;

            justify-content: flex-end;

            gap: 8px;

            margin-top: 5px;
        }


        /* =====================================================
           EMPTY STATE
           ===================================================== */

        .empty-state {
            text-align: center;

            padding: 60px 20px;

            color: #64748b;
        }

        .empty-icon {
            width: 58px;
            height: 58px;

            margin: 0 auto 15px;

            border-radius: 50%;

            background: #eff6ff;

            color: #2563eb;

            display: flex;

            align-items: center;

            justify-content: center;

            font-size: 24px;
        }

        .empty-icon svg {
            width: 25px;
            height: 25px;

            stroke: currentColor;
            fill: none;

            stroke-width: 2;

            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .empty-state h3 {
            margin: 0 0 7px;

            color: #334155;

            font-size: 17px;
        }

        .empty-state p {
            margin: 0;

            font-size: 13px;
        }


        /* =====================================================
           RESPONSIVE
           ===================================================== */

        @media (max-width: 1100px) {

            .exam-form {
                grid-template-columns: 1fr 1fr;
            }

            .exam-form .submit-group {
                grid-column: span 2;
            }
        }


        @media (max-width: 800px) {

            .sidebar {
                width: 210px;
            }

            .main-content {
                margin-left: 210px;

                width: calc(100% - 210px);

                padding: 25px;
            }

            .page-header {
                align-items: flex-start;
            }
        }


        @media (max-width: 650px) {

            .sidebar {
                position: relative;

                width: 100%;

                min-height: auto;
            }

            .dashboard-container {
                display: block;
            }

            .main-content {
                margin-left: 0;

                width: 100%;

                padding: 18px;
            }

            .page-header {
                flex-direction: column;

                gap: 12px;
            }

            .exam-form {
                grid-template-columns: 1fr;
            }

            .exam-form .submit-group {
                grid-column: span 1;
            }

            .exam-form-card,
            .table-card {
                padding: 18px;
            }

            .exam-form-description {
                margin-left: 0;
            }

            .edit-form {
                right: auto;

                left: 0;

                width: 290px;
            }
        }

    </style>

</head>


<body>

<div class="dashboard-container">


    <!-- =====================================================
         SIDEBAR
         ===================================================== -->

    <aside class="sidebar">

        <div class="sidebar-header">

            <div class="sidebar-logo">
                OE
            </div>

            <h2>Online Exam</h2>

            <p>Administrator Portal</p>

        </div>


        <nav class="sidebar-nav">

            <div class="nav-section-title">
                Management
            </div>


            <!-- =================================================
                 DASHBOARD
                 ================================================= -->

            <a href="<%= request.getContextPath() %>/admin/dashboard.jsp">

                <span class="nav-icon">

                    <svg viewBox="0 0 24 24" aria-hidden="true">

                        <rect x="3" y="3"
                              width="7"
                              height="7">
                        </rect>

                        <rect x="14" y="3"
                              width="7"
                              height="7">
                        </rect>

                        <rect x="3" y="14"
                              width="7"
                              height="7">
                        </rect>

                        <rect x="14" y="14"
                              width="7"
                              height="7">
                        </rect>

                    </svg>

                </span>

                <span>Dashboard</span>

            </a>


            <!-- =================================================
                 STUDENTS
                 ================================================= -->

            <a href="<%= request.getContextPath() %>/admin/students">

                <span class="nav-icon">

                    <svg viewBox="0 0 24 24" aria-hidden="true">

                        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2">
                        </path>

                        <circle cx="9" cy="7" r="4">
                        </circle>

                        <path d="M22 21v-2a4 4 0 0 0-3-3.87">
                        </path>

                        <path d="M16 3.13a4 4 0 0 1 0 7.75">
                        </path>

                    </svg>

                </span>

                <span>Students</span>

            </a>


            <!-- =================================================
                 EXAMS
                 ================================================= -->

            <a href="<%= request.getContextPath() %>/admin/exams"
               class="active">

                <span class="nav-icon">

                    <svg viewBox="0 0 24 24" aria-hidden="true">

                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z">
                        </path>

                        <polyline points="14 2 14 8 20 8">
                        </polyline>

                        <line x1="8" y1="13"
                              x2="16" y2="13">
                        </line>

                        <line x1="8" y1="17"
                              x2="16" y2="17">
                        </line>

                        <line x1="8" y1="9"
                              x2="10" y2="9">
                        </line>

                    </svg>

                </span>

                <span>Exams</span>

            </a>


            <!-- =================================================
                 QUESTIONS
                 ================================================= -->

            <a href="<%= request.getContextPath() %>/admin/questions">

                <span class="nav-icon">

                    <svg viewBox="0 0 24 24" aria-hidden="true">

                        <circle cx="12"
                                cy="12"
                                r="9">
                        </circle>

                        <path d="M9.5 9a2.5 2.5 0 1 1 4.3 1.8c-.9.9-1.8 1.3-1.8 2.7">
                        </path>

                        <line x1="12"
                              y1="17"
                              x2="12.01"
                              y2="17">
                        </line>

                    </svg>

                </span>

                <span>Questions</span>

            </a>


            <!-- =================================================
                 RESULTS
                 ================================================= -->

            <a href="<%= request.getContextPath() %>/admin/results">

                <span class="nav-icon">

                    <svg viewBox="0 0 24 24" aria-hidden="true">

                        <line x1="4"
                              y1="19"
                              x2="20"
                              y2="19">
                        </line>

                        <rect x="5"
                              y="10"
                              width="3"
                              height="7">
                        </rect>

                        <rect x="10.5"
                              y="6"
                              width="3"
                              height="11">
                        </rect>

                        <rect x="16"
                              y="3"
                              width="3"
                              height="14">
                        </rect>

                    </svg>

                </span>

                <span>Results &amp; Analytics</span>

            </a>


            <!-- =================================================
                 AUDIT LOGS
                 ================================================= -->

            <a href="<%= request.getContextPath() %>/admin/audit-logs">

                <span class="nav-icon">

                    <svg viewBox="0 0 24 24" aria-hidden="true">

                        <circle cx="12"
                                cy="12"
                                r="9">
                        </circle>

                        <polyline points="12 7 12 12 15 14">
                        </polyline>

                    </svg>

                </span>

                <span>Audit Logs</span>

            </a>

        </nav>


        <!-- =====================================================
             SIDEBAR FOOTER
             ===================================================== -->

        <div class="sidebar-footer">

            <div class="admin-info">

                <strong>
                    <%= user.getName() %>
                </strong>

                <span>
                    Administrator
                </span>

            </div>


            <a class="logout-btn"
               href="<%= request.getContextPath() %>/logout">

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
                 PAGE HEADER
                 ================================================= -->

            <div class="page-header">

                <div>

                    <h1>Exams</h1>

                    <p>
                        Create, manage and organize examination tests.
                    </p>

                </div>


                <div class="header-badge">

                    <%= examCount %>

                    <%= examCount == 1 ? "Exam" : "Exams" %>

                </div>

            </div>



            <!-- =================================================
                 SUCCESS MESSAGE
                 ================================================= -->

            <% if (success != null && !success.trim().isEmpty()) { %>

                <div class="alert alert-success">

                    ✓ &nbsp; <%= success %>

                </div>

            <% } %>



            <!-- =================================================
                 ERROR MESSAGE
                 ================================================= -->

            <% if (error != null && !error.trim().isEmpty()) { %>

                <div class="alert alert-error">

                    ! &nbsp; <%= error %>

                </div>

            <% } %>



            <!-- =================================================
                 CREATE EXAM
                 ================================================= -->

            <section class="exam-form-card">


                <div class="card-heading">

                    <div class="card-icon">

                        <!-- PLUS ICON -->

                        <svg viewBox="0 0 24 24"
                             aria-hidden="true">

                            <line x1="12"
                                  y1="5"
                                  x2="12"
                                  y2="19">
                            </line>

                            <line x1="5"
                                  y1="12"
                                  x2="19"
                                  y2="12">
                            </line>

                        </svg>

                    </div>


                    <h2>
                        Create New Exam
                    </h2>

                </div>


                <p class="exam-form-description">

                    Add a new examination by providing its name,
                    duration and total number of questions.

                </p>



                <form class="exam-form"
                      method="post"
                      action="<%= request.getContextPath() %>/admin/exams">


                    <!-- KEEP: action=add -->

                    <input type="hidden"
                           name="action"
                           value="add">



                    <!-- =================================================
                         EXAM NAME
                         ================================================= -->

                    <div class="form-group">

                        <label for="examName">
                            Exam Name
                        </label>

                        <input type="text"
                               id="examName"
                               name="examName"
                               maxlength="150"
                               placeholder="Example: Java Programming Test"
                               required>

                    </div>



                    <!-- =================================================
                         DURATION
                         ================================================= -->

                    <div class="form-group">

                        <label for="durationMinutes">
                            Duration (minutes)
                        </label>

                        <input type="number"
                               id="durationMinutes"
                               name="durationMinutes"
                               min="1"
                               placeholder="30"
                               required>

                    </div>



                    <!-- =================================================
                         TOTAL QUESTIONS
                         ================================================= -->

                    <div class="form-group">

                        <label for="totalQuestions">
                            Total Questions
                        </label>

                        <input type="number"
                               id="totalQuestions"
                               name="totalQuestions"
                               min="1"
                               placeholder="20"
                               required>

                    </div>



                    <!-- =================================================
                         SUBMIT
                         ================================================= -->

                    <div class="submit-group">

                        <button type="submit"
                                class="btn btn-primary">

                            + Create Exam

                        </button>

                    </div>

                </form>

            </section>



            <!-- =====================================================
                 EXAMS TABLE
                 ===================================================== -->

            <section class="table-card">


                <div class="table-header">


                    <div class="table-title">


                        <div class="card-icon">

                            <!-- DOCUMENT ICON -->

                            <svg viewBox="0 0 24 24"
                                 aria-hidden="true">

                                <rect x="4"
                                      y="4"
                                      width="16"
                                      height="16"
                                      rx="2">
                                </rect>

                                <line x1="8"
                                      y1="9"
                                      x2="16"
                                      y2="9">
                                </line>

                                <line x1="8"
                                      y1="13"
                                      x2="16"
                                      y2="13">
                                </line>

                                <line x1="8"
                                      y1="17"
                                      x2="13"
                                      y2="17">
                                </line>

                            </svg>

                        </div>


                        <h2>
                            All Exams
                        </h2>

                    </div>


                    <span class="exam-count">

                        <%= examCount %>

                        <%= examCount == 1 ? "exam" : "exams" %>

                    </span>

                </div>



                <!-- =================================================
                     NO EXAMS
                     ================================================= -->

                <% if (exams == null || exams.isEmpty()) { %>


                    <div class="empty-state">


                        <div class="empty-icon">

                            <!-- DOCUMENT ICON -->

                            <svg viewBox="0 0 24 24"
                                 aria-hidden="true">

                                <rect x="4"
                                      y="4"
                                      width="16"
                                      height="16"
                                      rx="2">
                                </rect>

                                <line x1="8"
                                      y1="9"
                                      x2="16"
                                      y2="9">
                                </line>

                                <line x1="8"
                                      y1="13"
                                      x2="16"
                                      y2="13">
                                </line>

                                <line x1="8"
                                      y1="17"
                                      x2="13"
                                      y2="17">
                                </line>

                            </svg>

                        </div>


                        <h3>
                            No Exams Found
                        </h3>


                        <p>

                            No examinations have been created yet.
                            Use the form above to create your first exam.

                        </p>

                    </div>



                <!-- =================================================
                     EXAMS EXIST
                     ================================================= -->

                <% } else { %>


                    <table class="exam-table">


                        <thead>

                            <tr>

                                <th>
                                    ID
                                </th>

                                <th>
                                    Exam Name
                                </th>

                                <th>
                                    Duration
                                </th>

                                <th>
                                    Questions
                                </th>

                                <th>
                                    Created At
                                </th>

                                <th>
                                    Actions
                                </th>

                            </tr>

                        </thead>



                        <tbody>


                        <% for (Exam exam : exams) { %>


                            <tr>


                                <!-- =================================================
                                     ID
                                     ================================================= -->

                                <td class="exam-id">

                                    #<%= exam.getId() %>

                                </td>



                                <!-- =================================================
                                     EXAM NAME
                                     ================================================= -->

                                <td class="exam-name">

                                    <%= exam.getExamName() %>

                                </td>



                                <!-- =================================================
                                     DURATION
                                     ================================================= -->

                                <td>

                                    <span class="duration-badge">

                                        <%= exam.getDurationMinutes() %>
                                        min

                                    </span>

                                </td>



                                <!-- =================================================
                                     QUESTIONS COUNT
                                     ================================================= -->

                                <td>

                                    <span class="question-badge">

                                        <%= exam.getTotalQuestions() %>

                                    </span>

                                </td>



                                <!-- =================================================
                                     CREATED DATE
                                     ================================================= -->

                                <td class="created-date">

                                    <%= exam.getCreatedAt() != null
                                        ? exam.getCreatedAt()
                                        : "—" %>

                                </td>



                                <!-- =================================================
                                     ACTIONS
                                     ================================================= -->

                                <td>

                                    <div class="action-group">


                                        <!-- =================================================
                                             QUESTIONS
                                             ================================================= -->

                                        <a href="<%= request.getContextPath() %>/admin/questions?examId=<%= exam.getId() %>"
                                           class="btn btn-primary btn-small">

                                            Questions

                                        </a>



                                        <!-- =================================================
                                             EDIT
                                             ================================================= -->

                                        <details class="edit-details">


                                            <summary class="btn btn-warning btn-small">

                                                Edit

                                            </summary>



                                            <form class="edit-form"
                                                  method="post"
                                                  action="<%= request.getContextPath() %>/admin/exams">


                                                <h3 class="edit-form-title">

                                                    Edit Exam

                                                </h3>



                                                <!-- KEEP: action=update -->

                                                <input type="hidden"
                                                       name="action"
                                                       value="update">



                                                <!-- KEEP: examId -->

                                                <input type="hidden"
                                                       name="examId"
                                                       value="<%= exam.getId() %>">



                                                <!-- =================================================
                                                     EXAM NAME
                                                     ================================================= -->

                                                <div class="edit-form-group">

                                                    <label>
                                                        Exam Name
                                                    </label>

                                                    <input type="text"
                                                           name="examName"
                                                           value="<%= exam.getExamName() %>"
                                                           maxlength="150"
                                                           required>

                                                </div>



                                                <!-- =================================================
                                                     DURATION
                                                     ================================================= -->

                                                <div class="edit-form-group">

                                                    <label>
                                                        Duration (minutes)
                                                    </label>

                                                    <input type="number"
                                                           name="durationMinutes"
                                                           value="<%= exam.getDurationMinutes() %>"
                                                           min="1"
                                                           required>

                                                </div>



                                                <!-- =================================================
                                                     TOTAL QUESTIONS
                                                     ================================================= -->

                                                <div class="edit-form-group">

                                                    <label>
                                                        Total Questions
                                                    </label>

                                                    <input type="number"
                                                           name="totalQuestions"
                                                           value="<%= exam.getTotalQuestions() %>"
                                                           min="1"
                                                           required>

                                                </div>



                                                <!-- =================================================
                                                     UPDATE
                                                     ================================================= -->

                                                <div class="edit-form-actions">

                                                    <button type="submit"
                                                            class="btn btn-primary btn-small">

                                                        Update Exam

                                                    </button>

                                                </div>

                                            </form>

                                        </details>



                                        <!-- =================================================
                                             DELETE
                                             ================================================= -->

                                        <form class="inline-form"
                                              method="post"
                                              action="<%= request.getContextPath() %>/admin/exams">


                                            <!-- KEEP: action=delete -->

                                            <input type="hidden"
                                                   name="action"
                                                   value="delete">



                                            <!-- KEEP: examId -->

                                            <input type="hidden"
                                                   name="examId"
                                                   value="<%= exam.getId() %>">



                                            <button type="submit"
                                                    class="btn btn-danger btn-small"
                                                    onclick="return confirm('Are you sure you want to delete this exam? This action cannot be undone.');">

                                                Delete

                                            </button>

                                        </form>


                                    </div>

                                </td>


                            </tr>


                        <% } %>


                        </tbody>

                    </table>


                <% } %>


            </section>


        </div>

    </main>

</div>

</body>

</html>