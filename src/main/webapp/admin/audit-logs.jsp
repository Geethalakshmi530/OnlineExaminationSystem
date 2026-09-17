<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ page import="java.util.*" %>
<%@ page import="com.exam.model.User" %>
<%@ page import="com.exam.model.AuditLog" %>

<%
    User user =
            (User) session.getAttribute("user");

    if (user == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/login.jsp?error=Please login first"
        );

        return;
    }

    if (!"ADMIN".equalsIgnoreCase(
            user.getRole())) {

        response.sendRedirect(
                request.getContextPath()
                + "/student/dashboard.jsp?error=Access denied"
        );

        return;
    }

    List<AuditLog> logs =
            (List<AuditLog>)
            request.getAttribute("logs");

    if (logs == null) {
        logs = new ArrayList<>();
    }

    List<Map<String,Object>> actionSummary =
            (List<Map<String,Object>>)
            request.getAttribute(
                    "actionSummary"
            );

    if (actionSummary == null) {
        actionSummary = new ArrayList<>();
    }

    Integer totalLogsObj =
            (Integer)
            request.getAttribute(
                    "totalLogs"
            );

    int totalLogs =
            totalLogsObj == null
            ? 0
            : totalLogsObj;

    String searchValue =
            (String)
            request.getAttribute(
                    "searchValue"
            );

    String actionValue =
            (String)
            request.getAttribute(
                    "actionValue"
            );

    if (searchValue == null) {
        searchValue = "";
    }

    if (actionValue == null) {
        actionValue = "";
    }


    /*
     * JavaScript labels for action chart.
     */

    StringBuilder actionLabels =
            new StringBuilder("[");

    StringBuilder actionValues =
            new StringBuilder("[");

    for (int i = 0;
         i < actionSummary.size();
         i++) {

        Map<String,Object> item =
                actionSummary.get(i);

        String action =
                String.valueOf(
                        item.get("action")
                )
                .replace("\\", "\\\\")
                .replace("'", "\\'");

        if (i > 0) {
            actionLabels.append(",");
            actionValues.append(",");
        }

        actionLabels
                .append("'")
                .append(action)
                .append("'");

        actionValues.append(
                item.get("total")
        );
    }

    actionLabels.append("]");
    actionValues.append("]");
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Audit Logs | Online Examination System</title>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>

* {
    box-sizing: border-box;
}

body {
    margin: 0;

    font-family:
        Arial,
        Helvetica,
        sans-serif;

    background: #f4f7fb;
    color: #172033;
}

/* =========================================================
   SIDEBAR
   ========================================================= */

.sidebar {
    width: 250px;

    position: fixed;

    left: 0;
    top: 0;
    bottom: 0;

    background: #0f2f6b;
    color: white;

    display: flex;
    flex-direction: column;
}

.brand {
    padding: 28px 24px;

    border-bottom:
        1px solid
        rgba(255,255,255,0.12);
}

.logo {
    width: 44px;
    height: 44px;

    background: white;
    color: #2563eb;

    border-radius: 12px;

    display: flex;
    align-items: center;
    justify-content: center;

    font-weight: 800;
    font-size: 20px;

    margin-bottom: 15px;
}

.brand h2 {
    margin: 0;
    font-size: 20px;
}

.brand p {
    margin: 6px 0 0;

    color: #b9c9e8;

    font-size: 13px;
}

.nav {
    padding: 22px 14px;

    flex: 1;
}

.nav-title {
    padding: 0 12px 11px;

    color: #91a9d3;

    font-size: 11px;
    font-weight: 800;

    letter-spacing: 1px;

    text-transform: uppercase;
}

.nav a {
    display: flex;
    align-items: center;

    gap: 12px;

    padding: 12px 14px;

    margin-bottom: 5px;

    border-radius: 9px;

    color: #dbe7fb;

    text-decoration: none;

    font-size: 14px;
}

.nav a:hover {
    background:
        rgba(255,255,255,0.10);

    color: white;
}

.nav a.active {
    background: #2563eb;
    color: white;
}

.icon {
    width: 22px;

    display: flex;
    justify-content: center;
}

.footer {
    padding: 20px;

    border-top:
        1px solid
        rgba(255,255,255,0.12);
}

.footer strong {
    display: block;

    color: white;

    font-size: 14px;

    margin-bottom: 4px;
}

.footer span {
    color: #aebfdf;

    font-size: 12px;
}

.logout {
    display: block;

    text-align: center;

    background:
        rgba(255,255,255,0.09);

    color: white;

    text-decoration: none;

    padding: 10px;

    border-radius: 8px;

    margin-top: 15px;

    font-size: 13px;
    font-weight: 700;
}

/* =========================================================
   MAIN
   ========================================================= */

.main {
    margin-left: 250px;

    padding: 35px;
}

.container {
    max-width: 1450px;

    margin: auto;
}

.header {
    display: flex;

    justify-content: space-between;

    align-items: center;

    margin-bottom: 28px;
}

.header h1 {
    margin: 0;

    color: #102a56;

    font-size: 30px;
}

.header p {
    margin: 7px 0 0;

    color: #64748b;

    font-size: 14px;
}

.badge {
    background: #e8f0ff;

    color: #2563eb;

    border: 1px solid #cfe0ff;

    padding: 9px 15px;

    border-radius: 20px;

    font-size: 13px;

    font-weight: 700;
}

/* =========================================================
   STATS
   ========================================================= */

.stats {
    display: grid;

    grid-template-columns:
        repeat(3, 1fr);

    gap: 18px;

    margin-bottom: 22px;
}

.stat {
    background: white;

    border:
        1px solid
        #e4eaf3;

    border-radius: 15px;

    padding: 22px;

    box-shadow:
        0 5px 20px
        rgba(15,23,42,0.06);
}

.stat-label {
    color: #64748b;

    font-size: 11px;

    font-weight: 800;

    text-transform: uppercase;

    letter-spacing: .5px;
}

.stat h2 {
    margin: 10px 0 5px;

    color: #172033;

    font-size: 30px;
}

.stat p {
    margin: 0;

    color: #94a3b8;

    font-size: 12px;
}

/* =========================================================
   CARD
   ========================================================= */

.card {
    background: white;

    border:
        1px solid
        #e4eaf3;

    border-radius: 15px;

    padding: 24px;

    box-shadow:
        0 5px 20px
        rgba(15,23,42,0.06);

    margin-bottom: 22px;
}

.card h2 {
    margin: 0 0 5px;

    font-size: 19px;
}

.subtitle {
    color: #64748b;

    font-size: 13px;

    margin-bottom: 20px;
}

/* =========================================================
   CHART
   ========================================================= */

.chart-area {
    height: 270px;

    position: relative;
}

/* =========================================================
   FILTERS
   ========================================================= */

.filters {
    display: grid;

    grid-template-columns:
        2fr 1fr auto;

    gap: 12px;

    margin-bottom: 20px;
}

.filters input,
.filters select {
    width: 100%;

    padding: 11px 13px;

    border:
        1px solid
        #cbd5e1;

    border-radius: 8px;

    font-size: 13px;

    outline: none;
}

.filters input:focus,
.filters select:focus {
    border-color: #2563eb;

    box-shadow:
        0 0 0 3px
        rgba(37,99,235,0.10);
}

.btn {
    border: none;

    background: #2563eb;

    color: white;

    padding: 11px 17px;

    border-radius: 8px;

    cursor: pointer;

    font-size: 13px;

    font-weight: 700;
}

.btn:hover {
    background: #1d4ed8;
}

.clear {
    display: inline-flex;

    align-items: center;

    justify-content: center;

    padding: 11px 15px;

    border-radius: 8px;

    text-decoration: none;

    background: #f1f5f9;

    color: #475569;

    font-size: 13px;

    font-weight: 700;
}

/* =========================================================
   TABLE
   ========================================================= */

.table-wrapper {
    overflow-x: auto;
}

table {
    width: 100%;

    border-collapse: collapse;

    min-width: 950px;
}

th {
    background: #f5f8fc;

    color: #475569;

    font-size: 11px;

    font-weight: 800;

    text-align: left;

    text-transform: uppercase;

    padding: 13px;

    border-bottom:
        1px solid
        #e2e8f0;
}

td {
    padding: 15px 13px;

    border-bottom:
        1px solid
        #edf1f6;

    color: #334155;

    font-size: 13px;

    vertical-align: middle;
}

tr:last-child td {
    border-bottom: none;
}

.action-badge {
    display: inline-block;

    padding: 6px 9px;

    background: #eff6ff;

    color: #2563eb;

    border-radius: 7px;

    font-size: 11px;

    font-weight: 800;
}

.entity {
    color: #64748b;

    font-size: 12px;
}

.description {
    max-width: 350px;

    color: #475569;

    line-height: 1.5;
}

.user-name {
    font-weight: 700;

    color: #172033;
}

.user-email {
    margin-top: 3px;

    color: #94a3b8;

    font-size: 11px;
}

.time {
    white-space: nowrap;

    color: #64748b;

    font-size: 12px;
}

/* =========================================================
   EMPTY
   ========================================================= */

.empty {
    text-align: center;

    padding: 45px;

    color: #64748b;
}

.empty-icon {
    font-size: 32px;

    margin-bottom: 10px;
}

/* =========================================================
   RESPONSIVE
   ========================================================= */

@media (max-width: 900px) {

    .stats {
        grid-template-columns: 1fr;
    }

    .filters {
        grid-template-columns: 1fr;
    }
}

@media (max-width: 700px) {

    .sidebar {
        position: relative;

        width: 100%;

        min-height: auto;
    }

    .main {
        margin-left: 0;

        padding: 20px;
    }

    .header {
        flex-direction: column;

        align-items: flex-start;

        gap: 12px;
    }
}

</style>

</head>

<body>


<!-- =========================================================
     SIDEBAR
     ========================================================= -->

<aside class="sidebar">

    <div class="brand">

        <div class="logo">
            OE
        </div>

        <h2>
            Online Exam
        </h2>

        <p>
            Administrator Portal
        </p>

    </div>


    <nav class="nav">

        <div class="nav-title">
            Management
        </div>


        <a href="<%= request.getContextPath() %>/admin/dashboard.jsp">

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


        <a href="<%= request.getContextPath() %>/admin/results">

            <span class="icon">
                ▥
            </span>

            Results &amp; Analytics

        </a>


        <a href="<%= request.getContextPath() %>/admin/audit-logs"
           class="active">

            <span class="icon">
                ◷
            </span>

            Audit Logs

        </a>

    </nav>


    <div class="footer">

        <strong>
            <%= user.getName() %>
        </strong>

        <span>
            Administrator
        </span>

        <a class="logout"
           href="<%= request.getContextPath() %>/logout">

            Logout

        </a>

    </div>

</aside>


<!-- =========================================================
     MAIN
     ========================================================= -->

<main class="main">

<div class="container">


    <div class="header">

        <div>

            <h1>
                Audit Logs
            </h1>

            <p>
                Monitor administrator and system activity.
            </p>

        </div>

        <div class="badge">
            <%= totalLogs %> Total Logs
        </div>

    </div>


    <!-- =====================================================
         STATISTICS
         ===================================================== -->

    <section class="stats">

        <div class="stat">

            <div class="stat-label">
                Total Activities
            </div>

            <h2>
                <%= totalLogs %>
            </h2>

            <p>
                Records stored in audit_logs
            </p>

        </div>


        <div class="stat">

            <div class="stat-label">
                Showing
            </div>

            <h2>
                <%= logs.size() %>
            </h2>

            <p>
                Logs matching current filter
            </p>

        </div>


        <div class="stat">

            <div class="stat-label">
                Monitoring
            </div>

            <h2>
                Active
            </h2>

            <p>
                Audit monitoring is available
            </p>

        </div>

    </section>


    <!-- =====================================================
         ACTION CHART
         ===================================================== -->

    <section class="card">

        <h2>
            Activity Overview
        </h2>

        <div class="subtitle">
            Most frequently recorded actions.
        </div>

        <div class="chart-area">

            <canvas id="actionChart"></canvas>

        </div>

    </section>


    <!-- =====================================================
         FILTER
         ===================================================== -->

    <section class="card">

        <h2>
            Search Activity
        </h2>

        <div class="subtitle">
            Search by user, action, entity or description.
        </div>


        <form method="get"
              action="<%= request.getContextPath() %>/admin/audit-logs"
              class="filters">


            <input
                type="text"
                name="search"
                value="<%= searchValue %>"
                placeholder="Search activity...">


            <select name="action">

                <option value="">
                    All Actions
                </option>

                <%
                    for (
                        Map<String,Object> item
                        : actionSummary
                    ) {

                        String action =
                                String.valueOf(
                                    item.get("action")
                                );

                        boolean selected =
                                action.equals(
                                    actionValue
                                );
                %>

                    <option value="<%= action %>"
                            <%= selected
                                ? "selected"
                                : "" %>>

                        <%= action %>

                    </option>

                <%
                    }
                %>

            </select>


            <button
                type="submit"
                class="btn">

                Search

            </button>

        </form>


        <a class="clear"
           href="<%= request.getContextPath() %>/admin/audit-logs">

            Clear Filters

        </a>

    </section>


    <!-- =====================================================
         LOG TABLE
         ===================================================== -->

    <section class="card">

        <h2>
            Activity Log
        </h2>

        <div class="subtitle">
            Latest 100 matching audit records.
        </div>


        <div class="table-wrapper">

            <table>

                <thead>

                <tr>

                    <th>
                        ID
                    </th>

                    <th>
                        User
                    </th>

                    <th>
                        Action
                    </th>

                    <th>
                        Entity
                    </th>

                    <th>
                        Description
                    </th>

                    <th>
                        Time
                    </th>

                </tr>

                </thead>


                <tbody>

                <%
                    for (AuditLog log : logs) {
                %>

                <tr>

                    <td>
                        #<%= log.getId() %>
                    </td>


                    <td>

                        <div class="user-name">

                            <%= log.getUserName() != null
                                ? log.getUserName()
                                : "Unknown User" %>

                        </div>

                        <div class="user-email">

                            <%= log.getUserEmail() != null
                                ? log.getUserEmail()
                                : "—" %>

                        </div>

                    </td>


                    <td>

                        <span class="action-badge">

                            <%= log.getAction() != null
                                ? log.getAction()
                                : "UNKNOWN" %>

                        </span>

                    </td>


                    <td>

                        <div class="entity">

                            <%= log.getEntityType() != null
                                ? log.getEntityType()
                                : "—" %>

                            <%
                                if (log.getEntityId() > 0) {
                            %>

                                #<%= log.getEntityId() %>

                            <%
                                }
                            %>

                        </div>

                    </td>


                    <td>

                        <div class="description">

                            <%= log.getDescription() != null
                                ? log.getDescription()
                                : "—" %>

                        </div>

                    </td>


                    <td>

                        <div class="time">

                            <%= log.getActionTime() != null
                                ? log.getActionTime()
                                : "—" %>

                        </div>

                    </td>

                </tr>

                <%
                    }

                    if (logs.isEmpty()) {
                %>

                <tr>

                    <td colspan="6">

                        <div class="empty">

                            <div class="empty-icon">
                                ◷
                            </div>

                            <strong>
                                No audit logs found
                            </strong>

                            <br>

                            No activity matches the current filter.

                        </div>

                    </td>

                </tr>

                <% } %>

                </tbody>

            </table>

        </div>

    </section>


</div>

</main>


<script>

const actionLabels =
    <%= actionLabels.toString() %>;

const actionValues =
    <%= actionValues.toString() %>;


new Chart(
    document.getElementById("actionChart"),
    {
        type: "bar",

        data: {

            labels: actionLabels,

            datasets: [
                {
                    label: "Activities",
                    data: actionValues
                }
            ]
        },

        options: {

            responsive: true,

            maintainAspectRatio: false,

            scales: {

                y: {
                    beginAtZero: true
                }

            },

            plugins: {

                legend: {
                    display: false
                }

            }

        }
    }
);

</script>

</body>

</html>