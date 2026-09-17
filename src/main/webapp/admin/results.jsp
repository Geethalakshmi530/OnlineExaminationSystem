<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.LinkedHashMap"%>
<%@ page import="java.lang.reflect.Method"%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Results & Analytics | Online Examination System</title>

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
            background: #f4f7fb;
            color: #172b4d;
        }

        .layout {
            display: flex;
            min-height: 100vh;
        }

        /* =====================================================
           SIDEBAR
           ===================================================== */

        .sidebar {
            width: 270px;
            background: #153875;
            color: white;
            min-height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            bottom: 0;
            z-index: 100;
        }

        .brand {
            padding: 30px 25px;
            border-bottom: 1px solid rgba(255,255,255,0.15);
        }

        .brand-logo {
            width: 48px;
            height: 48px;
            background: white;
            color: #2864df;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 21px;
            font-weight: bold;
            margin-bottom: 15px;
        }

        .brand-title {
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .brand-subtitle {
            font-size: 14px;
            opacity: 0.85;
        }

        .menu-title {
            padding: 28px 28px 12px;
            font-size: 12px;
            font-weight: bold;
            letter-spacing: 1px;
            opacity: 0.7;
        }

        .menu a {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 15px 28px;
            margin: 4px 15px;
            border-radius: 10px;
            color: white;
            text-decoration: none;
            font-size: 15px;
            transition: 0.2s;
        }

        .menu a:hover {
            background: rgba(255,255,255,0.10);
        }

        .menu a.active {
            background: #2864df;
        }

        .icon {
            width: 20px;
            text-align: center;
            font-size: 17px;
        }

        .sidebar-bottom {
            position: absolute;
            bottom: 25px;
            left: 20px;
            right: 20px;
            padding-top: 20px;
            border-top: 1px solid rgba(255,255,255,0.15);
        }

        .admin-name {
            font-weight: bold;
            font-size: 14px;
        }

        .admin-role {
            font-size: 12px;
            opacity: 0.75;
            margin-top: 5px;
        }

        .logout {
            display: block;
            text-align: center;
            text-decoration: none;
            color: white;
            background: rgba(255,255,255,0.10);
            padding: 12px;
            border-radius: 9px;
            margin-top: 18px;
            font-weight: bold;
        }

        .logout:hover {
            background: rgba(255,255,255,0.18);
        }

        /* =====================================================
           MAIN
           ===================================================== */

        .main {
            margin-left: 270px;
            width: calc(100% - 270px);
            padding: 40px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .header h1 {
            margin: 0;
            font-size: 32px;
            color: #173c70;
        }

        .header p {
            margin-top: 8px;
            margin-bottom: 0;
            color: #71809a;
        }

        .badge {
            background: #eaf1ff;
            color: #2864df;
            padding: 11px 18px;
            border-radius: 25px;
            font-weight: bold;
            font-size: 14px;
        }

        /* =====================================================
           ERROR
           ===================================================== */

        .error {
            background: #fff1f1;
            border: 1px solid #f1b8b8;
            color: #b42318;
            padding: 16px 18px;
            border-radius: 12px;
            margin-bottom: 25px;
        }

        /* =====================================================
           STAT CARDS
           ===================================================== */

        .cards {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 25px;
        }

        .card {
            background: white;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(35, 56, 90, 0.08);
            border: 1px solid #e7edf5;
        }

        .card-title {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: bold;
            color: #71809a;
            margin-bottom: 12px;
        }

        .card-value {
            font-size: 31px;
            font-weight: bold;
            color: #142d50;
        }

        .card-description {
            margin-top: 8px;
            color: #91a0b8;
            font-size: 13px;
        }

        /* =====================================================
           PANELS
           ===================================================== */

        .grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 25px;
        }

        .panel {
            background: white;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(35, 56, 90, 0.08);
            border: 1px solid #e7edf5;
        }

        .panel h2 {
            margin: 0;
            font-size: 21px;
            color: #142d50;
        }

        .panel-subtitle {
            margin-top: 6px;
            margin-bottom: 20px;
            color: #8290a8;
            font-size: 14px;
        }

        .chart-container {
            height: 310px;
            position: relative;
        }

        /* =====================================================
           FULL WIDTH PANEL
           ===================================================== */

        .full-panel {
            background: white;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(35, 56, 90, 0.08);
            border: 1px solid #e7edf5;
            margin-bottom: 25px;
        }

        /* =====================================================
           TABLE
           ===================================================== */

        .table-wrapper {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th {
            text-align: left;
            background: #f6f8fc;
            padding: 14px;
            font-size: 12px;
            text-transform: uppercase;
            color: #687993;
            white-space: nowrap;
        }

        td {
            padding: 15px 14px;
            border-bottom: 1px solid #edf1f6;
            font-size: 14px;
            color: #334155;
        }

        tr:hover td {
            background: #fafcff;
        }

        .score {
            font-weight: bold;
            color: #2864df;
        }

        .pass {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 15px;
            background: #e7f7ee;
            color: #18834b;
            font-size: 12px;
            font-weight: bold;
        }

        .fail {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 15px;
            background: #fdeaea;
            color: #c53d3d;
            font-size: 12px;
            font-weight: bold;
        }

        .security {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 15px;
            background: #fff4df;
            color: #a65b00;
            font-size: 12px;
            font-weight: bold;
        }

        .empty {
            text-align: center;
            padding: 45px;
            color: #8492a9;
        }

        /* =====================================================
           SECURITY SUMMARY
           ===================================================== */

        .security-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 25px;
        }

        .security-card {
            background: white;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(35, 56, 90, 0.08);
            border: 1px solid #e7edf5;
        }

        .security-number {
            font-size: 30px;
            font-weight: bold;
            color: #142d50;
            margin-top: 10px;
        }

        /* =====================================================
           RESPONSIVE
           ===================================================== */

        @media(max-width: 1150px) {

            .cards {
                grid-template-columns: 1fr 1fr;
            }

            .grid {
                grid-template-columns: 1fr;
            }

            .security-grid {
                grid-template-columns: 1fr;
            }
        }

        @media(max-width: 800px) {

            .sidebar {
                width: 220px;
            }

            .main {
                margin-left: 220px;
                width: calc(100% - 220px);
                padding: 25px;
            }

            .cards {
                grid-template-columns: 1fr;
            }

            .header {
                align-items: flex-start;
                gap: 15px;
                flex-direction: column;
            }
        }

    </style>

</head>


<body>


<%

    /*
     * =========================================================
     * DATA FROM ResultAnalyticsServlet
     * =========================================================
     */

    Object analytics =
            request.getAttribute("analytics");

    Map<?, ?> scoreDistribution =
            (Map<?, ?>) request.getAttribute("scoreDistribution");

    List<?> examPerformance =
            (List<?>) request.getAttribute("examPerformance");

    List<?> topStudents =
            (List<?>) request.getAttribute("topStudents");

    List<?> recentResults =
            (List<?>) request.getAttribute("recentResults");

    List<?> suspiciousActivities =
            (List<?>) request.getAttribute("suspiciousActivities");

    String pageError =
            (String) request.getAttribute("pageError");


    /*
     * =========================================================
     * HELPER VALUES
     *
     * Reflection is used here so this JSP can work with the
     * existing ResultAnalytics model without requiring us to
     * rename or modify that model.
     * =========================================================
     */

    int totalResults = 0;
    double averagePercentage = 0;
    int passCount = 0;
    int highestScore = 0;


    try {

        if (analytics != null) {

            try {

                Method m =
                    analytics.getClass()
                             .getMethod("getTotalResults");

                Object value = m.invoke(analytics);

                if (value != null) {
                    totalResults =
                        ((Number) value).intValue();
                }

            } catch (Exception ignored) {}


            try {

                Method m =
                    analytics.getClass()
                             .getMethod("getAveragePercentage");

                Object value = m.invoke(analytics);

                if (value != null) {
                    averagePercentage =
                        ((Number) value).doubleValue();
                }

            } catch (Exception ignored) {}


            try {

                Method m =
                    analytics.getClass()
                             .getMethod("getPassCount");

                Object value = m.invoke(analytics);

                if (value != null) {
                    passCount =
                        ((Number) value).intValue();
                }

            } catch (Exception ignored) {}


            try {

                Method m =
                    analytics.getClass()
                             .getMethod("getHighestScore");

                Object value = m.invoke(analytics);

                if (value != null) {
                    highestScore =
                        ((Number) value).intValue();
                }

            } catch (Exception ignored) {}

        }

    } catch (Exception ignored) {}


    double passRate =
        totalResults > 0
        ? ((double) passCount / totalResults) * 100
        : 0;


    /*
     * If the model uses totalAttempts instead of totalResults,
     * try that as a fallback.
     */

    if (totalResults == 0 && analytics != null) {

        try {

            Method m =
                analytics.getClass()
                         .getMethod("getTotalAttempts");

            Object value = m.invoke(analytics);

            if (value != null) {
                totalResults =
                    ((Number) value).intValue();
            }

        } catch (Exception ignored) {}
    }


    /*
     * =========================================================
     * MAP PROPERTY HELPER
     * =========================================================
     */

    java.util.function.BiFunction<Map<?, ?>, String[], Object>
        getMapValue = (map, keys) -> {

            if (map == null) {
                return null;
            }

            for (String key : keys) {

                if (map.containsKey(key)) {
                    return map.get(key);
                }
            }

            return null;
        };


    /*
     * =========================================================
     * PREPARE CHART DATA
     * =========================================================
     */

    StringBuilder scoreLabels =
        new StringBuilder();

    StringBuilder scoreValues =
        new StringBuilder();

    if (scoreDistribution != null) {

        for (Map.Entry<?, ?> entry :
                scoreDistribution.entrySet()) {

            if (scoreLabels.length() > 0) {
                scoreLabels.append(",");
                scoreValues.append(",");
            }

            String label =
                String.valueOf(entry.getKey())
                    .replace("\\", "\\\\")
                    .replace("\"", "\\\"");

            Object value =
                entry.getValue();

            scoreLabels.append("\"")
                      .append(label)
                      .append("\"");

            scoreValues.append(
                value != null
                    ? value.toString()
                    : "0"
            );
        }
    }


    /*
     * EXAM PERFORMANCE DATA
     */

    StringBuilder examLabels =
        new StringBuilder();

    StringBuilder examValues =
        new StringBuilder();


    if (examPerformance != null) {

        for (Object item : examPerformance) {

            if (!(item instanceof Map)) {
                continue;
            }

            Map<?, ?> row =
                (Map<?, ?>) item;


            Object name =
                getMapValue.apply(
                    row,
                    new String[] {
                        "exam_name",
                        "examName",
                        "name"
                    }
                );


            Object score =
                getMapValue.apply(
                    row,
                    new String[] {
                        "average_score",
                        "avg_score",
                        "averagePercentage",
                        "average_percentage",
                        "score"
                    }
                );


            if (examLabels.length() > 0) {
                examLabels.append(",");
                examValues.append(",");
            }


            String safeName =
                name != null
                    ? String.valueOf(name)
                        .replace("\\", "\\\\")
                        .replace("\"", "\\\"")
                    : "Exam";


            examLabels.append("\"")
                      .append(safeName)
                      .append("\"");


            examValues.append(
                score != null
                    ? score.toString()
                    : "0"
            );
        }
    }


    /*
     * TOP STUDENT DATA
     */

    StringBuilder studentLabels =
        new StringBuilder();

    StringBuilder studentValues =
        new StringBuilder();


    if (topStudents != null) {

        for (Object item : topStudents) {

            if (!(item instanceof Map)) {
                continue;
            }

            Map<?, ?> row =
                (Map<?, ?>) item;


            Object name =
                getMapValue.apply(
                    row,
                    new String[] {
                        "student_name",
                        "studentName",
                        "name"
                    }
                );


            Object score =
                getMapValue.apply(
                    row,
                    new String[] {
                        "average_score",
                        "avg_score",
                        "averagePercentage",
                        "average_percentage",
                        "score"
                    }
                );


            if (studentLabels.length() > 0) {
                studentLabels.append(",");
                studentValues.append(",");
            }


            String safeName =
                name != null
                    ? String.valueOf(name)
                        .replace("\\", "\\\\")
                        .replace("\"", "\\\"")
                    : "Student";


            studentLabels.append("\"")
                        .append(safeName)
                        .append("\"");


            studentValues.append(
                score != null
                    ? score.toString()
                    : "0"
            );
        }
    }

%>


<div class="layout">


    <!-- =====================================================
         SIDEBAR
         ===================================================== -->

    <aside class="sidebar">


        <div class="brand">

            <div class="brand-logo">
                OE
            </div>

            <div class="brand-title">
                Online Exam
            </div>

            <div class="brand-subtitle">
                Administrator Portal
            </div>

        </div>


        <div class="menu-title">
            MANAGEMENT
        </div>


        <nav class="menu">


            <a href="<%= request.getContextPath() %>/dashboard">

                <span class="icon">
                    ▦
                </span>

                Dashboard

            </a>


            <a href="<%= request.getContextPath() %>/admin/students">

                <span class="icon">
                    ♙
                </span>

                Students

            </a>


            <a href="<%= request.getContextPath() %>/admin/exams">

                <span class="icon">
                    ▤
                </span>

                Exams

            </a>


            <a href="<%= request.getContextPath() %>/admin/questions">

                <span class="icon">
                    ?
                </span>

                Questions

            </a>


            <a class="active"
               href="<%= request.getContextPath() %>/admin/results">

                <span class="icon">
                    ▥
                </span>

                Results & Analytics

            </a>


            <a href="<%= request.getContextPath() %>/admin/audit-logs">

                <span class="icon">
                    ◷
                </span>

                Audit Logs

            </a>


        </nav>


        <div class="sidebar-bottom">


            <div class="admin-name">
                Admin
            </div>


            <div class="admin-role">
                Administrator
            </div>


            <a class="logout"
               href="<%= request.getContextPath() %>/logout">

                Logout

            </a>


        </div>


    </aside>



    <!-- =====================================================
         MAIN CONTENT
         ===================================================== -->

    <main class="main">


        <div class="header">


            <div>

                <h1>
                    Results & Analytics
                </h1>

                <p>
                    Monitor examination performance and student results.
                </p>

            </div>


            <div class="badge">

                <%= totalResults %>
                Total Results

            </div>


        </div>



        <!-- =================================================
             ERROR MESSAGE
             ================================================= -->

        <% if (pageError != null) { %>

            <div class="error">

                <strong>
                    Unable to load analytics:
                </strong>

                <%= pageError %>

            </div>

        <% } %>



        <!-- =================================================
             STAT CARDS
             ================================================= -->

        <div class="cards">


            <div class="card">

                <div class="card-title">
                    Total Results
                </div>

                <div class="card-value">
                    <%= totalResults %>
                </div>

                <div class="card-description">
                    Examination results recorded
                </div>

            </div>


            <div class="card">

                <div class="card-title">
                    Average Performance
                </div>

                <div class="card-value">

                    <%= String.format(
                            "%.1f",
                            averagePercentage
                        ) %>%

                </div>

                <div class="card-description">
                    Average student performance
                </div>

            </div>


            <div class="card">

                <div class="card-title">
                    Pass Rate
                </div>

                <div class="card-value">

                    <%= String.format(
                            "%.1f",
                            passRate
                        ) %>%

                </div>

                <div class="card-description">
                    Students scoring 40% or above
                </div>

            </div>


            <div class="card">

                <div class="card-title">
                    Highest Score
                </div>

                <div class="card-value">
                    <%= highestScore %>
                </div>

                <div class="card-description">
                    Highest marks achieved
                </div>

            </div>


        </div>



        <!-- =================================================
             CHARTS
             ================================================= -->

        <div class="grid">


            <!-- SCORE DISTRIBUTION -->

            <div class="panel">

                <h2>
                    Score Distribution
                </h2>

                <div class="panel-subtitle">
                    Distribution of student examination scores
                </div>

                <div class="chart-container">

                    <canvas id="scoreChart">
                    </canvas>

                </div>

            </div>



            <!-- EXAM PERFORMANCE -->

            <div class="panel">

                <h2>
                    Exam Performance
                </h2>

                <div class="panel-subtitle">
                    Average performance by examination
                </div>

                <div class="chart-container">

                    <canvas id="examChart">
                    </canvas>

                </div>

            </div>


        </div>



        <!-- =================================================
             TOP STUDENTS
             ================================================= -->

        <div class="grid">


            <div class="panel">

                <h2>
                    Top Students
                </h2>

                <div class="panel-subtitle">
                    Highest performing students
                </div>

                <div class="chart-container">

                    <canvas id="studentChart">
                    </canvas>

                </div>

            </div>



            <!-- SECURITY -->

            <div class="panel">

                <h2>
                    Security Monitoring
                </h2>

                <div class="panel-subtitle">
                    Recent suspicious examination activity
                </div>


                <div style="
                    text-align:center;
                    padding:50px 20px;
                ">


                    <div style="
                        font-size:42px;
                        margin-bottom:15px;
                    ">
                        🛡
                    </div>


                    <div style="
                        font-size:28px;
                        font-weight:bold;
                        color:#142d50;
                    ">

                        <%= suspiciousActivities != null
                                ? suspiciousActivities.size()
                                : 0 %>

                    </div>


                    <div style="
                        color:#8290a8;
                        margin-top:8px;
                    ">

                        Recent suspicious activities

                    </div>


                </div>

            </div>


        </div>



        <!-- =================================================
             RECENT RESULTS
             ================================================= -->

        <div class="full-panel">


            <h2>
                Recent Results
            </h2>


            <div class="panel-subtitle">
                Latest examination results submitted by students.
            </div>


            <div class="table-wrapper">


                <table>


                    <thead>

                        <tr>

                            <th>
                                Student
                            </th>

                            <th>
                                Exam
                            </th>

                            <th>
                                Correct
                            </th>

                            <th>
                                Total
                            </th>

                            <th>
                                Score
                            </th>

                            <th>
                                Status
                            </th>

                            <th>
                                Date
                            </th>

                        </tr>

                    </thead>


                    <tbody>


                    <%

                    if (recentResults != null
                            && !recentResults.isEmpty()) {


                        for (Object item :
                                recentResults) {


                            if (!(item instanceof Map)) {
                                continue;
                            }


                            Map<?, ?> row =
                                (Map<?, ?>) item;


                            Object student =
                                getMapValue.apply(
                                    row,
                                    new String[] {
                                        "student_name",
                                        "studentName",
                                        "name"
                                    }
                                );


                            Object exam =
                                getMapValue.apply(
                                    row,
                                    new String[] {
                                        "exam_name",
                                        "examName",
                                        "exam"
                                    }
                                );


                            Object correct =
                                getMapValue.apply(
                                    row,
                                    new String[] {
                                        "correct_answers",
                                        "correctAnswers",
                                        "correct"
                                    }
                                );


                            Object total =
                                getMapValue.apply(
                                    row,
                                    new String[] {
                                        "total_questions",
                                        "totalQuestions",
                                        "total"
                                    }
                                );


                            Object score =
                                getMapValue.apply(
                                    row,
                                    new String[] {
                                        "score",
                                        "marks"
                                    }
                                );


                            Object date =
                                getMapValue.apply(
                                    row,
                                    new String[] {
                                        "exam_date",
                                        "examDate",
                                        "date"
                                    }
                                );


                            double percentage = 0;


                            try {

                                double c =
                                    correct != null
                                    ? Double.parseDouble(
                                        correct.toString())
                                    : 0;

                                double t =
                                    total != null
                                    ? Double.parseDouble(
                                        total.toString())
                                    : 0;


                                if (t > 0) {

                                    percentage =
                                        (c / t) * 100;
                                }

                            } catch (Exception ignored) {}


                            boolean passed =
                                percentage >= 40;

                    %>


                        <tr>


                            <td>

                                <strong>

                                    <%= student != null
                                            ? student
                                            : "-" %>

                                </strong>

                            </td>


                            <td>

                                <%= exam != null
                                        ? exam
                                        : "-" %>

                            </td>


                            <td>

                                <%= correct != null
                                        ? correct
                                        : "0" %>

                            </td>


                            <td>

                                <%= total != null
                                        ? total
                                        : "0" %>

                            </td>


                            <td class="score">

                                <%= score != null
                                        ? score
                                        : "0" %>

                            </td>


                            <td>


                                <% if (passed) { %>

                                    <span class="pass">
                                        PASSED
                                    </span>

                                <% } else { %>

                                    <span class="fail">
                                        FAILED
                                    </span>

                                <% } %>


                            </td>


                            <td>

                                <%= date != null
                                        ? date
                                        : "-" %>

                            </td>


                        </tr>


                    <%

                        }

                    } else {

                    %>


                        <tr>

                            <td colspan="7"
                                class="empty">

                                No examination results
                                are available yet.

                            </td>

                        </tr>


                    <%

                    }

                    %>


                    </tbody>


                </table>


            </div>


        </div>



        <!-- =================================================
             SUSPICIOUS ACTIVITIES
             ================================================= -->

        <div class="full-panel">


            <h2>
                Recent Suspicious Activity
            </h2>


            <div class="panel-subtitle">
                Security events detected during examinations.
            </div>


            <div class="table-wrapper">


                <table>


                    <thead>

                        <tr>

                            <th>
                                Activity
                            </th>

                            <th>
                                Details
                            </th>

                            <th>
                                Time
                            </th>

                        </tr>

                    </thead>


                    <tbody>


                    <%

                    if (suspiciousActivities != null
                            && !suspiciousActivities.isEmpty()) {


                        for (Object item :
                                suspiciousActivities) {


                            if (!(item instanceof Map)) {
                                continue;
                            }


                            Map<?, ?> row =
                                (Map<?, ?>) item;


                            Object activity =
                                getMapValue.apply(
                                    row,
                                    new String[] {
                                        "activity_type",
                                        "activityType",
                                        "type"
                                    }
                                );


                            Object details =
                                getMapValue.apply(
                                    row,
                                    new String[] {
                                        "details",
                                        "description"
                                    }
                                );


                            Object time =
                                getMapValue.apply(
                                    row,
                                    new String[] {
                                        "activity_time",
                                        "activityTime",
                                        "time"
                                    }
                                );

                    %>


                        <tr>


                            <td>

                                <span class="security">

                                    <%= activity != null
                                            ? activity
                                            : "Suspicious Activity" %>

                                </span>

                            </td>


                            <td>

                                <%= details != null
                                        ? details
                                        : "-" %>

                            </td>


                            <td>

                                <%= time != null
                                        ? time
                                        : "-" %>

                            </td>


                        </tr>


                    <%

                        }

                    } else {

                    %>


                        <tr>

                            <td colspan="3"
                                class="empty">

                                No suspicious activities
                                have been recorded.

                            </td>

                        </tr>


                    <%

                    }

                    %>


                    </tbody>


                </table>


            </div>


        </div>


    </main>


</div>



<!-- =========================================================
     CHART JAVASCRIPT
     ========================================================= -->

<script>


    /*
     * =========================================================
     * SCORE DISTRIBUTION
     * =========================================================
     */

    const scoreLabels = [
        <%= scoreLabels.toString() %>
    ];


    const scoreValues = [
        <%= scoreValues.toString() %>
    ];


    const scoreCanvas =
        document.getElementById("scoreChart");


    if (scoreCanvas) {

        new Chart(
            scoreCanvas,
            {

                type: "doughnut",

                data: {

                    labels: scoreLabels,

                    datasets: [

                        {

                            label: "Results",

                            data: scoreValues,

                            borderWidth: 1

                        }

                    ]

                },

                options: {

                    responsive: true,

                    maintainAspectRatio: false,

                    plugins: {

                        legend: {

                            position: "bottom"

                        }

                    }

                }

            }
        );
    }



    /*
     * =========================================================
     * EXAM PERFORMANCE
     * =========================================================
     */

    const examLabels = [
        <%= examLabels.toString() %>
    ];


    const examValues = [
        <%= examValues.toString() %>
    ];


    const examCanvas =
        document.getElementById("examChart");


    if (examCanvas) {

        new Chart(
            examCanvas,
            {

                type: "bar",

                data: {

                    labels: examLabels,

                    datasets: [

                        {

                            label: "Average Percentage",

                            data: examValues,

                            borderWidth: 1

                        }

                    ]

                },

                options: {

                    responsive: true,

                    maintainAspectRatio: false,

                    scales: {

                        y: {

                            beginAtZero: true,

                            max: 100,

                            title: {

                                display: true,

                                text: "Percentage"

                            }

                        }

                    }

                }

            }
        );
    }



    /*
     * =========================================================
     * TOP STUDENTS
     * =========================================================
     */

    const studentLabels = [
        <%= studentLabels.toString() %>
    ];


    const studentValues = [
        <%= studentValues.toString() %>
    ];


    const studentCanvas =
        document.getElementById("studentChart");


    if (studentCanvas) {

        new Chart(
            studentCanvas,
            {

                type: "bar",

                data: {

                    labels: studentLabels,

                    datasets: [

                        {

                            label: "Average Score",

                            data: studentValues,

                            borderWidth: 1

                        }

                    ]

                },

                options: {

                    responsive: true,

                    maintainAspectRatio: false,

                    scales: {

                        y: {

                            beginAtZero: true,

                            max: 100,

                            title: {

                                display: true,

                                text: "Percentage"

                            }

                        }

                    }

                }

            }
        );
    }


</script>


</body>

</html>