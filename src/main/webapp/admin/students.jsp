<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.exam.model.User" %>
<%@ page import="com.exam.model.Student" %>

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
            request.getContextPath()
            + "/login.jsp?error=Please login first"
        );

        return;
    }

    // Only ADMIN can access Student Management

    if (!"ADMIN".equalsIgnoreCase(user.getRole())) {

        response.sendRedirect(
            request.getContextPath()
            + "/login.jsp?error=Access denied"
        );

        return;
    }

    // =========================================================
    // GET STUDENTS FROM SERVLET
    // =========================================================

    List<Student> students =
        (List<Student>) request.getAttribute("students");

%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Student Management | Online Examination System
    </title>


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

        .admin-layout {
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

            border-bottom:
                1px solid rgba(255,255,255,0.12);
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
            color: white;

            font-size: 20px;

            margin-bottom: 5px;
        }


        .sidebar-brand span {
            color: #b9c9e8;

            font-size: 13px;
        }


        /* =====================================================
           SIDEBAR NAVIGATION
           ===================================================== */

        .sidebar-nav {
            padding: 22px 14px;

            flex: 1;
        }


        .menu-title {
            padding:
                0 13px 11px;

            color: #91a9d3;

            font-size: 11px;

            font-weight: 800;

            letter-spacing: 1px;

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
            background:
                rgba(255,255,255,0.10);

            color: white;
        }


        .sidebar-nav a.active {
            background: #2563eb;

            color: white;

            box-shadow:
                0 6px 18px
                rgba(37,99,235,0.30);
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

            border-top:
                1px solid rgba(255,255,255,0.12);
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

            background:
                rgba(255,255,255,0.09);

            color: white;

            text-decoration: none;

            text-align: center;

            border-radius: 8px;

            font-size: 13px;

            font-weight: 700;

            transition: 0.2s ease;
        }


        .logout-button:hover {
            background:
                rgba(255,255,255,0.17);
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
            color: #102a56;

            font-size: 30px;

            line-height: 1.2;

            margin-bottom: 8px;
        }


        .page-header p {
            color: #64748b;

            font-size: 14px;
        }


        .user-info {
            display: flex;

            flex-direction: column;

            align-items: flex-end;

            gap: 4px;
        }


        .user-info strong {
            color: #172033;

            font-size: 14px;
        }


        .user-info span {
            color: #64748b;

            font-size: 12px;
        }


        /* =====================================================
           ALERTS
           ===================================================== */

        .alert {
            padding: 13px 16px;

            border-radius: 9px;

            margin-bottom: 20px;

            font-size: 13px;

            font-weight: 600;
        }


        .alert-success {
            background: #ecfdf5;

            color: #047857;

            border:
                1px solid #a7f3d0;
        }


        .alert-error {
            background: #fef2f2;

            color: #b91c1c;

            border:
                1px solid #fecaca;
        }


        /* =====================================================
           CONTENT CARD
           ===================================================== */

        .content-card {
            background: white;

            border:
                1px solid #e4eaf2;

            border-radius: 15px;

            padding: 25px;

            box-shadow:
                0 5px 20px
                rgba(15,23,42,0.06);
        }


        .content-card-header {
            display: flex;

            justify-content: space-between;

            align-items: center;

            gap: 20px;

            margin-bottom: 25px;
        }


        .content-card-header h2 {
            color: #172033;

            font-size: 19px;

            margin-bottom: 6px;
        }


        .content-card-header p {
            color: #64748b;

            font-size: 13px;
        }


        /* =====================================================
           STUDENT COUNT
           ===================================================== */

        .student-count {
            min-width: 105px;

            padding: 12px 18px;

            display: flex;

            flex-direction: column;

            align-items: center;

            justify-content: center;

            background: #eff6ff;

            border:
                1px solid #dbeafe;

            border-radius: 12px;
        }


        .student-count strong {
            color: #2563eb;

            font-size: 27px;

            line-height: 1;
        }


        .student-count span {
            margin-top: 5px;

            color: #64748b;

            font-size: 11px;

            font-weight: 600;
        }


        /* =====================================================
           TABLE
           ===================================================== */

        .table-container {
            width: 100%;

            overflow-x: auto;
        }


        .data-table {
            width: 100%;

            border-collapse: collapse;

            min-width: 760px;
        }


        .data-table th {
            background: #f5f8fc;

            color: #475569;

            text-align: left;

            padding: 14px;

            font-size: 11px;

            font-weight: 800;

            text-transform: uppercase;

            letter-spacing: 0.4px;

            border-bottom:
                1px solid #e2e8f0;
        }


        .data-table td {
            padding: 16px 14px;

            color: #475569;

            font-size: 13px;

            border-bottom:
                1px solid #edf1f6;

            vertical-align: middle;
        }


        .data-table tbody tr {
            transition: 0.15s ease;
        }


        .data-table tbody tr:hover {
            background: #f8fbff;
        }


        .data-table tbody tr:last-child td {
            border-bottom: none;
        }


        .student-id {
            color: #64748b;

            font-weight: 700;
        }


        .student-name {
            color: #172033;

            font-weight: 700;
        }


        .student-email {
            color: #64748b;
        }


        /* =====================================================
           STATUS BADGES
           ===================================================== */

        .status-badge {
            display: inline-flex;

            align-items: center;

            padding: 6px 11px;

            border-radius: 20px;

            font-size: 11px;

            font-weight: 700;

            text-transform: uppercase;
        }


        .status-badge.approved {
            background: #ecfdf5;

            color: #047857;

            border:
                1px solid #a7f3d0;
        }


        .status-badge.pending {
            background: #fffbeb;

            color: #b45309;

            border:
                1px solid #fde68a;
        }


        .status-badge.rejected {
            background: #fef2f2;

            color: #b91c1c;

            border:
                1px solid #fecaca;
        }


        .status-badge.unknown {
            background: #f1f5f9;

            color: #64748b;

            border:
                1px solid #e2e8f0;
        }


        /* =====================================================
           ACTIONS
           ===================================================== */

        .student-actions {
            white-space: nowrap;
        }


        .student-actions form {
            display: inline-block;

            margin-right: 6px;

            margin-bottom: 0;
        }


        .btn-approve,
        .btn-reject {
            border: none;

            color: white;

            padding: 8px 13px;

            border-radius: 7px;

            cursor: pointer;

            font-size: 12px;

            font-weight: 700;

            transition: 0.2s ease;
        }


        .btn-approve {
            background: #16a34a;
        }


        .btn-approve:hover {
            background: #15803d;

            transform: translateY(-1px);
        }


        .btn-reject {
            background: #dc2626;
        }


        .btn-reject:hover {
            background: #b91c1c;

            transform: translateY(-1px);
        }


        .action-status {
            display: inline-flex;

            padding: 7px 11px;

            border-radius: 20px;

            font-size: 11px;

            font-weight: 700;
        }


        .action-status.approved {
            background: #ecfdf5;

            color: #047857;

            border:
                1px solid #a7f3d0;
        }


        .action-status.rejected {
            background: #fef2f2;

            color: #b91c1c;

            border:
                1px solid #fecaca;
        }


        /* =====================================================
           EMPTY STATE
           ===================================================== */

        .empty-state {
            text-align: center;

            padding: 65px 20px;
        }


        .empty-icon {
            width: 55px;
            height: 55px;

            margin: 0 auto 16px;

            display: flex;

            align-items: center;

            justify-content: center;

            background: #eff6ff;

            color: #2563eb;

            border-radius: 50%;

            font-size: 20px;

            font-weight: 800;
        }


        .empty-state h3 {
            color: #334155;

            font-size: 17px;

            margin-bottom: 7px;
        }


        .empty-state p {
            color: #64748b;

            font-size: 13px;
        }


        /* =====================================================
           FOOTER
           ===================================================== */

        .page-footer {
            text-align: center;

            color: #94a3b8;

            font-size: 11px;

            padding: 18px 0 5px;
        }


        /* =====================================================
           RESPONSIVE
           ===================================================== */

        @media (max-width: 900px) {

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

            .admin-layout {
                display: block;
            }


            .sidebar {
                position: relative;

                width: 100%;

                min-height: auto;
            }


            .main-content {
                margin-left: 0;

                width: 100%;

                padding: 20px;
            }


            .page-header {
                flex-direction: column;

                align-items: flex-start;

                gap: 15px;
            }


            .user-info {
                align-items: flex-start;
            }


            .content-card {
                padding: 18px;
            }


            .content-card-header {
                flex-direction: column;

                align-items: flex-start;
            }


            .student-count {
                align-self: stretch;
            }

        }


    </style>

</head>


<body>


<div class="admin-layout">


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

            <span>
                Administrator Portal
            </span>

        </div>


        <!-- NAVIGATION -->

        <nav class="sidebar-nav">


            <div class="menu-title">
                Management
            </div>


            <!-- DASHBOARD -->

            <a href="<%= request.getContextPath() %>/admin/dashboard.jsp">

                <span class="menu-icon">
                    ⌂
                </span>

                <span>
                    Dashboard
                </span>

            </a>


            <!-- STUDENTS -->

            <a href="<%= request.getContextPath() %>/admin/students"
               class="active">

                <span class="menu-icon">
                    S
                </span>

                <span>
                    Students
                </span>

            </a>


            <!-- EXAMS -->

            <a href="<%= request.getContextPath() %>/admin/exams">

                <span class="menu-icon">
                    E
                </span>

                <span>
                    Exams
                </span>

            </a>


            <!-- QUESTIONS -->

            <a href="<%= request.getContextPath() %>/admin/exams">

                <span class="menu-icon">
                    Q
                </span>

                <span>
                    Questions
                </span>

            </a>


            <!-- RESULTS -->

            <a href="<%= request.getContextPath() %>/admin/results">

                <span class="menu-icon">
                    R
                </span>

                <span>
                    Results &amp; Analytics
                </span>

            </a>


            <!-- AUDIT LOGS -->

            <a href="<%= request.getContextPath() %>/admin/audit-logs">

                <span class="menu-icon">
                    A
                </span>

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
                 PAGE HEADER
                 ================================================= -->

            <header class="page-header">


                <div>

                    <h1>
                        Student Management
                    </h1>

                    <p>
                        View and manage registered students.
                    </p>

                </div>


                <div class="user-info">

                    <strong>
                        <%= user.getName() %>
                    </strong>

                    <span>
                        Administrator
                    </span>

                </div>


            </header>



            <!-- =================================================
                 SUCCESS / ERROR MESSAGE
                 ================================================= -->

            <%

                String success =
                    request.getParameter("success");

                String error =
                    request.getParameter("error");

            %>


            <% if (success != null &&
                   !success.trim().isEmpty()) { %>

                <div class="alert alert-success">

                    <%= success %>

                </div>

            <% } %>


            <% if (error != null &&
                   !error.trim().isEmpty()) { %>

                <div class="alert alert-error">

                    <%= error %>

                </div>

            <% } %>



            <!-- =================================================
                 STUDENT MANAGEMENT CARD
                 ================================================= -->

            <section class="content-card">


                <!-- CARD HEADER -->

                <div class="content-card-header">


                    <div>

                        <h2>
                            Registered Students
                        </h2>

                        <p>
                            Students registered in the
                            examination system.
                        </p>

                    </div>


                    <!-- STUDENT COUNT -->

                    <div class="student-count">


                        <%

                            int studentCount =
                                students != null
                                ? students.size()
                                : 0;

                        %>


                        <strong>
                            <%= studentCount %>
                        </strong>


                        <span>
                            Students
                        </span>


                    </div>


                </div>



                <!-- =================================================
                     STUDENT TABLE
                     ================================================= -->

                <%

                    if (students != null &&
                        !students.isEmpty()) {

                %>


                <div class="table-container">


                    <table class="data-table">


                        <!-- TABLE HEADER -->

                        <thead>

                            <tr>

                                <th>
                                    ID
                                </th>

                                <th>
                                    Student
                                </th>

                                <th>
                                    Email Address
                                </th>

                                <th>
                                    Status
                                </th>

                                <th>
                                    Actions
                                </th>

                            </tr>

                        </thead>


                        <!-- TABLE BODY -->

                        <tbody>


                        <%

                            for (Student student : students) {

                        %>


                            <tr>


                                <!-- ID -->

                                <td class="student-id">

                                    #<%= student.getId() %>

                                </td>


                                <!-- NAME -->

                                <td>

                                    <span class="student-name">

                                        <%= student.getName() %>

                                    </span>

                                </td>


                                <!-- EMAIL -->

                                <td class="student-email">

                                    <%= student.getEmail() %>

                                </td>


                                <!-- STATUS -->

                                <td>


                                    <span class="status-badge
                                        <%= student.getStatus() != null
                                            ? student.getStatus().toLowerCase()
                                            : "unknown" %>">

                                        <%= student.getStatus() != null
                                            ? student.getStatus()
                                            : "UNKNOWN" %>

                                    </span>


                                </td>


                                <!-- ACTIONS -->

                                <td class="student-actions">


                                    <!-- PENDING -->

                                    <% if ("PENDING".equalsIgnoreCase(
                                            student.getStatus())) { %>


                                        <!-- APPROVE FORM -->

                                        <form method="post"
                                              action="<%= request.getContextPath() %>/admin/students">


                                            <input type="hidden"
                                                   name="studentId"
                                                   value="<%= student.getId() %>">


                                            <input type="hidden"
                                                   name="action"
                                                   value="approve">


                                            <button type="submit"
                                                    class="btn-approve"
                                                    onclick="return confirm('Are you sure you want to approve this student?');">

                                                Approve

                                            </button>


                                        </form>


                                        <!-- REJECT FORM -->

                                        <form method="post"
                                              action="<%= request.getContextPath() %>/admin/students">


                                            <input type="hidden"
                                                   name="studentId"
                                                   value="<%= student.getId() %>">


                                            <input type="hidden"
                                                   name="action"
                                                   value="reject">


                                            <button type="submit"
                                                    class="btn-reject"
                                                    onclick="return confirm('Are you sure you want to reject this student?');">

                                                Reject

                                            </button>


                                        </form>


                                    <!-- APPROVED -->

                                    <% } else if (
                                        "APPROVED".equalsIgnoreCase(
                                            student.getStatus())) { %>


                                        <span class="action-status approved">

                                            Approved

                                        </span>


                                    <!-- REJECTED -->

                                    <% } else if (
                                        "REJECTED".equalsIgnoreCase(
                                            student.getStatus())) { %>


                                        <span class="action-status rejected">

                                            Rejected

                                        </span>


                                    <% } %>


                                </td>


                            </tr>


                        <%

                            }

                        %>


                        </tbody>


                    </table>


                </div>


                <%

                    } else {

                %>


                    <!-- =================================================
                         EMPTY STATE
                         ================================================= -->

                    <div class="empty-state">


                        <div class="empty-icon">
                            S
                        </div>


                        <h3>
                            No Students Found
                        </h3>


                        <p>
                            There are currently no registered
                            students.
                        </p>


                    </div>


                <%

                    }

                %>


            </section>



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