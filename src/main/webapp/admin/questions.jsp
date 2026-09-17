<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.exam.model.Question"%>
<%@ page import="com.exam.model.User"%>

<%
    User user = (User) session.getAttribute("user");

    if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(
            request.getContextPath()
            + "/login.jsp?error=Access denied"
        );
        return;
    }

    Integer examId = (Integer) request.getAttribute("examId");

    List<Question> questions =
        (List<Question>) request.getAttribute("questions");

    String success = request.getParameter("success");
    String error = request.getParameter("error");

    int questionCount =
        questions != null ? questions.size() : 0;
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Questions | Online Examination System</title>

    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family:
                "Segoe UI",
                Arial,
                sans-serif;

            background: #f4f7fb;
            color: #1f2937;
            min-height: 100vh;
        }

        .layout {
            display: flex;
            min-height: 100vh;
        }

        /* =========================
           SIDEBAR
           ========================= */

        .sidebar {
            width: 250px;
            background: #111827;
            color: #ffffff;
            position: fixed;
            top: 0;
            left: 0;
            bottom: 0;
            display: flex;
            flex-direction: column;
            z-index: 1000;
        }

        .brand {
            height: 72px;
            display: flex;
            align-items: center;
            padding: 0 24px;
            border-bottom: 1px solid #273244;
        }

        .brand-icon {
            width: 38px;
            height: 38px;
            background: #2563eb;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
            font-size: 17px;
            font-weight: 700;
        }

        .brand-text {
            font-size: 17px;
            font-weight: 700;
        }

        .navigation {
            padding: 24px 14px;
            flex: 1;
        }

        .nav-title {
            color: #6b7280;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 700;
            padding: 0 12px 10px;
        }

        .nav-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 14px;
            margin-bottom: 5px;
            border-radius: 8px;
            color: #cbd5e1;
            text-decoration: none;
            font-size: 14px;
            transition: all 0.2s ease;
        }

        .nav-link:hover {
            background: #1f2937;
            color: #ffffff;
        }

        .nav-link.active {
            background: #2563eb;
            color: #ffffff;
        }

        .nav-icon {
            width: 20px;
            text-align: center;
            font-size: 16px;
        }

        .sidebar-footer {
            padding: 16px;
            border-top: 1px solid #273244;
        }

        .admin-mini {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .admin-avatar {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: #2563eb;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
        }

        .admin-name {
            font-size: 13px;
            font-weight: 600;
        }

        .admin-role {
            color: #9ca3af;
            font-size: 11px;
            margin-top: 2px;
        }

        /* =========================
           MAIN
           ========================= */

        .main {
            margin-left: 250px;
            width: calc(100% - 250px);
            min-height: 100vh;
        }

        .topbar {
            height: 72px;
            background: #ffffff;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
        }

        .page-heading h1 {
            font-size: 22px;
            font-weight: 700;
            color: #111827;
        }

        .page-heading p {
            margin-top: 3px;
            color: #6b7280;
            font-size: 13px;
        }

        .topbar-user {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .topbar-avatar {
            width: 36px;
            height: 36px;
            background: #eff6ff;
            color: #2563eb;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
        }

        .content {
            padding: 30px 32px 40px;
        }

        /* =========================
           ALERTS
           ========================= */

        .alert {
            padding: 13px 16px;
            border-radius: 8px;
            margin-bottom: 22px;
            font-size: 14px;
            border: 1px solid;
        }

        .alert-success {
            background: #ecfdf5;
            border-color: #a7f3d0;
            color: #047857;
        }

        .alert-error {
            background: #fef2f2;
            border-color: #fecaca;
            color: #b91c1c;
        }

        /* =========================
           SUMMARY
           ========================= */

        .summary-grid {
            display: grid;
            grid-template-columns:
                repeat(2, minmax(0, 1fr));

            gap: 18px;
            margin-bottom: 28px;
        }

        .summary-card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 15px;
            box-shadow:
                0 2px 8px rgba(15, 23, 42, 0.03);
        }

        .summary-icon {
            width: 46px;
            height: 46px;
            border-radius: 10px;
            background: #eff6ff;
            color: #2563eb;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 19px;
            font-weight: 700;
        }

        .summary-value {
            font-size: 23px;
            font-weight: 700;
            color: #111827;
        }

        .summary-label {
            color: #6b7280;
            font-size: 12px;
            margin-top: 3px;
        }

        /* =========================
           CARD
           ========================= */

        .card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            box-shadow:
                0 2px 8px rgba(15, 23, 42, 0.03);
        }

        .card-header {
            padding: 20px 22px;
            border-bottom: 1px solid #e5e7eb;
        }

        .card-header h2 {
            font-size: 16px;
            font-weight: 700;
            color: #111827;
        }

        .card-header p {
            color: #6b7280;
            font-size: 12px;
            margin-top: 4px;
        }

        /* =========================
           ADD QUESTION
           ========================= */

        .form-body {
            padding: 22px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            margin-bottom: 16px;
        }

        .form-label {
            font-size: 12px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 7px;
        }

        .form-input,
        .form-textarea,
        .form-select {
            width: 100%;
            border: 1px solid #d1d5db;
            border-radius: 7px;
            padding: 10px 12px;
            font-size: 13px;
            color: #111827;
            background: #ffffff;
            outline: none;
            transition:
                border-color 0.2s,
                box-shadow 0.2s;
        }

        .form-input,
        .form-select {
            height: 42px;
        }

        .form-textarea {
            min-height: 90px;
            resize: vertical;
            font-family: inherit;
        }

        .form-input:focus,
        .form-textarea:focus,
        .form-select:focus {
            border-color: #2563eb;
            box-shadow:
                0 0 0 3px rgba(37, 99, 235, 0.10);
        }

        .options-grid {
            display: grid;
            grid-template-columns:
                repeat(2, 1fr);

            gap: 16px;
        }

        .answer-row {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .answer-row .form-select {
            max-width: 250px;
        }

        .btn {
            height: 42px;
            border: none;
            border-radius: 7px;
            padding: 0 18px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-primary {
            background: #2563eb;
            color: #ffffff;
        }

        .btn-primary:hover {
            background: #1d4ed8;
        }

        .btn-secondary {
            background: #e5e7eb;
            color: #374151;
        }

        .btn-secondary:hover {
            background: #d1d5db;
        }

        /* =========================
           QUESTIONS
           ========================= */

        .questions-card {
            margin-top: 28px;
        }

        .question-item {
            padding: 22px;
            border-bottom: 1px solid #e5e7eb;
        }

        .question-item:last-child {
            border-bottom: none;
        }

        .question-top {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            align-items: flex-start;
        }

        .question-number {
            min-width: 38px;
            height: 38px;
            border-radius: 9px;
            background: #eff6ff;
            color: #2563eb;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 13px;
            margin-right: 12px;
        }

        .question-title {
            display: flex;
            align-items: flex-start;
            flex: 1;
        }

        .question-text {
            font-size: 14px;
            line-height: 1.6;
            font-weight: 600;
            color: #111827;
            padding-top: 8px;
        }

        .question-actions {
            display: flex;
            gap: 7px;
        }

        .action-btn {
            border: none;
            border-radius: 6px;
            padding: 7px 11px;
            font-size: 11px;
            font-weight: 600;
            cursor: pointer;
        }

        .action-edit {
            background: #eff6ff;
            color: #2563eb;
        }

        .action-delete {
            background: #fef2f2;
            color: #dc2626;
        }

        .options-list {
            margin:
                17px 0 0 50px;

            display: grid;
            grid-template-columns:
                repeat(2, 1fr);

            gap: 10px;
        }

        .option {
            border: 1px solid #e5e7eb;
            border-radius: 7px;
            padding: 11px 13px;
            font-size: 12px;
            color: #4b5563;
            background: #fafafa;
        }

        .option.correct {
            background: #ecfdf5;
            border-color: #a7f3d0;
            color: #047857;
            font-weight: 600;
        }

        .correct-label {
            margin-left: 6px;
            font-size: 10px;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        /* =========================
           EDIT PANEL
           ========================= */

        .edit-panel {
            display: none;
            margin-top: 20px;
            padding: 20px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 9px;
        }

        .edit-panel.show {
            display: block;
        }

        .edit-actions {
            display: flex;
            gap: 8px;
        }

        /* =========================
           EMPTY STATE
           ========================= */

        .empty-state {
            text-align: center;
            padding: 55px 20px;
        }

        .empty-icon {
            width: 55px;
            height: 55px;
            margin: 0 auto 15px;
            border-radius: 50%;
            background: #f1f5f9;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #64748b;
            font-size: 22px;
        }

        .empty-state h3 {
            font-size: 15px;
            color: #374151;
        }

        .empty-state p {
            color: #6b7280;
            font-size: 12px;
            margin-top: 5px;
        }

        /* =========================
           RESPONSIVE
           ========================= */

        @media (max-width: 900px) {

            .options-grid {
                grid-template-columns: 1fr;
            }

            .options-list {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {

            .sidebar {
                width: 220px;
            }

            .main {
                margin-left: 220px;
                width: calc(100% - 220px);
            }

            .content {
                padding: 22px 20px 30px;
            }

            .summary-grid {
                grid-template-columns: 1fr;
            }

            .question-top {
                flex-direction: column;
            }

            .question-actions {
                margin-left: 50px;
            }
        }

        @media (max-width: 600px) {

            .layout {
                display: block;
            }

            .sidebar {
                position: relative;
                width: 100%;
            }

            .main {
                margin-left: 0;
                width: 100%;
            }

            .navigation {
                padding: 12px;
            }

            .nav-title {
                display: none;
            }

            .nav-link {
                display: inline-flex;
                margin-right: 4px;
            }

            .sidebar-footer {
                display: none;
            }

            .topbar {
                height: auto;
                padding: 18px;
            }

            .topbar-user {
                display: none;
            }

            .content {
                padding: 18px 14px 25px;
            }

            .form-body,
            .card-header {
                padding: 17px;
            }

            .options-list {
                margin-left: 0;
            }

            .question-actions {
                margin-left: 0;
            }

            .answer-row {
                align-items: flex-start;
                flex-direction: column;
            }
        }

    </style>

</head>

<body>

<div class="layout">

    <!-- =========================
         SIDEBAR
         ========================= -->

    <aside class="sidebar">

        <div class="brand">

            <div class="brand-icon">
                OE
            </div>

            <div class="brand-text">
                Online Exam
            </div>

        </div>

        <nav class="navigation">

            <div class="nav-title">
                Administration
            </div>

            <a href="<%= request.getContextPath() %>/dashboard"
               class="nav-link">

                <span class="nav-icon">⌂</span>
                Dashboard

            </a>

            <a href="<%= request.getContextPath() %>/admin/students"
               class="nav-link">

                <span class="nav-icon">◉</span>
                Students

            </a>

            <a href="<%= request.getContextPath() %>/admin/exams"
               class="nav-link">

                <span class="nav-icon">▣</span>
                Exams

            </a>

            <a href="<%= request.getContextPath() %>/admin/questions?examId=<%= examId %>"
               class="nav-link active">

                <span class="nav-icon">?</span>
                Questions

            </a>

        </nav>

        <div class="sidebar-footer">

            <div class="admin-mini">

                <div class="admin-avatar">

                    <%= user.getName() != null
                            && !user.getName().isEmpty()
                            ? user.getName()
                                .substring(0, 1)
                                .toUpperCase()
                            : "A" %>

                </div>

                <div>

                    <div class="admin-name">
                        <%= user.getName() %>
                    </div>

                    <div class="admin-role">
                        Administrator
                    </div>

                </div>

            </div>

        </div>

    </aside>


    <!-- =========================
         MAIN CONTENT
         ========================= -->

    <main class="main">

        <header class="topbar">

            <div class="page-heading">

                <h1>
                    Questions
                </h1>

                <p>
                    Manage questions for the selected examination
                </p>

            </div>

            <div class="topbar-user">

                <div class="topbar-avatar">

                    <%= user.getName() != null
                            && !user.getName().isEmpty()
                            ? user.getName()
                                .substring(0, 1)
                                .toUpperCase()
                            : "A" %>

                </div>

                <span>
                    <%= user.getName() %>
                </span>

            </div>

        </header>


        <section class="content">


            <!-- =========================
                 ALERTS
                 ========================= -->

            <% if (success != null
                    && !success.trim().isEmpty()) { %>

                <div class="alert alert-success">
                    <%= success %>
                </div>

            <% } %>


            <% if (error != null
                    && !error.trim().isEmpty()) { %>

                <div class="alert alert-error">
                    <%= error %>
                </div>

            <% } %>


            <!-- =========================
                 SUMMARY
                 ========================= -->

            <div class="summary-grid">

                <div class="summary-card">

                    <div class="summary-icon">
                        Q
                    </div>

                    <div>

                        <div class="summary-value">
                            <%= questionCount %>
                        </div>

                        <div class="summary-label">
                            Questions in this Exam
                        </div>

                    </div>

                </div>


                <div class="summary-card">

                    <div class="summary-icon">
                        #
                    </div>

                    <div>

                        <div class="summary-value">
                            <%= examId %>
                        </div>

                        <div class="summary-label">
                            Selected Exam ID
                        </div>

                    </div>

                </div>

            </div>


            <!-- =========================
                 ADD QUESTION
                 ========================= -->

            <div class="card">

                <div class="card-header">

                    <h2>
                        Add New Question
                    </h2>

                    <p>
                        Create a multiple-choice question
                        for Exam ID <%= examId %>.
                    </p>

                </div>


                <div class="form-body">

                    <form method="post"
                          action="<%= request.getContextPath() %>/admin/questions">

                        <input type="hidden"
                               name="action"
                               value="add">

                        <input type="hidden"
                               name="examId"
                               value="<%= examId %>">


                        <div class="form-group">

                            <label class="form-label">
                                Question
                            </label>

                            <textarea
                                name="questionText"
                                class="form-textarea"
                                maxlength="500"
                                placeholder="Enter the question..."
                                required></textarea>

                        </div>


                        <div class="options-grid">


                            <div class="form-group">

                                <label class="form-label">
                                    Option A
                                </label>

                                <input
                                    type="text"
                                    name="optionA"
                                    class="form-input"
                                    maxlength="255"
                                    placeholder="Enter option A"
                                    required>

                            </div>


                            <div class="form-group">

                                <label class="form-label">
                                    Option B
                                </label>

                                <input
                                    type="text"
                                    name="optionB"
                                    class="form-input"
                                    maxlength="255"
                                    placeholder="Enter option B"
                                    required>

                            </div>


                            <div class="form-group">

                                <label class="form-label">
                                    Option C
                                </label>

                                <input
                                    type="text"
                                    name="optionC"
                                    class="form-input"
                                    maxlength="255"
                                    placeholder="Enter option C"
                                    required>

                            </div>


                            <div class="form-group">

                                <label class="form-label">
                                    Option D
                                </label>

                                <input
                                    type="text"
                                    name="optionD"
                                    class="form-input"
                                    maxlength="255"
                                    placeholder="Enter option D"
                                    required>

                            </div>

                        </div>


                        <div class="form-group">

                            <label class="form-label">
                                Correct Answer
                            </label>

                            <div class="answer-row">

                                <select
                                    name="correctAnswer"
                                    class="form-select"
                                    required>

                                    <option value="">
                                        Select correct answer
                                    </option>

                                    <option value="A">
                                        Option A
                                    </option>

                                    <option value="B">
                                        Option B
                                    </option>

                                    <option value="C">
                                        Option C
                                    </option>

                                    <option value="D">
                                        Option D
                                    </option>

                                </select>

                                <button
                                    type="submit"
                                    class="btn btn-primary">

                                    + Add Question

                                </button>

                            </div>

                        </div>

                    </form>

                </div>

            </div>


            <!-- =========================
                 QUESTION LIST
                 ========================= -->

            <div class="card questions-card">

                <div class="card-header">

                    <h2>
                        Questions
                    </h2>

                    <p>
                        Review, edit or delete questions
                        belonging to this exam.
                    </p>

                </div>


                <% if (questions == null
                        || questions.isEmpty()) { %>

                    <div class="empty-state">

                        <div class="empty-icon">
                            ?
                        </div>

                        <h3>
                            No questions found
                        </h3>

                        <p>
                            Add the first question using
                            the form above.
                        </p>

                    </div>

                <% } else { %>


                    <% int questionNumber = 1; %>


                    <% for (Question question : questions) { %>

                        <div class="question-item">


                            <div class="question-top">


                                <div class="question-title">

                                    <span class="question-number">
                                        <%= questionNumber++ %>
                                    </span>

                                    <div class="question-text">
                                        <%= question.getQuestionText() %>
                                    </div>

                                </div>


                                <div class="question-actions">

                                    <button
                                        type="button"
                                        class="action-btn action-edit"
                                        onclick="showEditForm(<%= question.getId() %>)">

                                        Edit

                                    </button>


                                    <form
                                        method="post"
                                        action="<%= request.getContextPath() %>/admin/questions"
                                        style="display:inline;"
                                        onsubmit="return confirmDelete();">

                                        <input
                                            type="hidden"
                                            name="action"
                                            value="delete">

                                        <input
                                            type="hidden"
                                            name="questionId"
                                            value="<%= question.getId() %>">

                                        <input
                                            type="hidden"
                                            name="examId"
                                            value="<%= examId %>">

                                        <button
                                            type="submit"
                                            class="action-btn action-delete">

                                            Delete

                                        </button>

                                    </form>

                                </div>

                            </div>


                            <!-- OPTIONS -->

                            <div class="options-list">

                                <div class="option
                                    <%= "A".equalsIgnoreCase(
                                            question.getCorrectAnswer())
                                            ? "correct"
                                            : "" %>">

                                    <strong>A.</strong>
                                    <%= question.getOptionA() %>

                                    <% if ("A".equalsIgnoreCase(
                                            question.getCorrectAnswer())) { %>

                                        <span class="correct-label">
                                            Correct
                                        </span>

                                    <% } %>

                                </div>


                                <div class="option
                                    <%= "B".equalsIgnoreCase(
                                            question.getCorrectAnswer())
                                            ? "correct"
                                            : "" %>">

                                    <strong>B.</strong>
                                    <%= question.getOptionB() %>

                                    <% if ("B".equalsIgnoreCase(
                                            question.getCorrectAnswer())) { %>

                                        <span class="correct-label">
                                            Correct
                                        </span>

                                    <% } %>

                                </div>


                                <div class="option
                                    <%= "C".equalsIgnoreCase(
                                            question.getCorrectAnswer())
                                            ? "correct"
                                            : "" %>">

                                    <strong>C.</strong>
                                    <%= question.getOptionC() %>

                                    <% if ("C".equalsIgnoreCase(
                                            question.getCorrectAnswer())) { %>

                                        <span class="correct-label">
                                            Correct
                                        </span>

                                    <% } %>

                                </div>


                                <div class="option
                                    <%= "D".equalsIgnoreCase(
                                            question.getCorrectAnswer())
                                            ? "correct"
                                            : "" %>">

                                    <strong>D.</strong>
                                    <%= question.getOptionD() %>

                                    <% if ("D".equalsIgnoreCase(
                                            question.getCorrectAnswer())) { %>

                                        <span class="correct-label">
                                            Correct
                                        </span>

                                    <% } %>

                                </div>

                            </div>


                            <!-- =========================
                                 EDIT QUESTION
                                 ========================= -->

                            <div
                                id="edit-<%= question.getId() %>"
                                class="edit-panel">


                                <form
                                    method="post"
                                    action="<%= request.getContextPath() %>/admin/questions">

                                    <input
                                        type="hidden"
                                        name="action"
                                        value="update">

                                    <input
                                        type="hidden"
                                        name="questionId"
                                        value="<%= question.getId() %>">

                                    <input
                                        type="hidden"
                                        name="examId"
                                        value="<%= examId %>">


                                    <div class="form-group">

                                        <label class="form-label">
                                            Question
                                        </label>

                                        <textarea
                                            name="questionText"
                                            class="form-textarea"
                                            maxlength="500"
                                            required><%= question.getQuestionText() %></textarea>

                                    </div>


                                    <div class="options-grid">


                                        <div class="form-group">

                                            <label class="form-label">
                                                Option A
                                            </label>

                                            <input
                                                type="text"
                                                name="optionA"
                                                class="form-input"
                                                maxlength="255"
                                                value="<%= question.getOptionA() %>"
                                                required>

                                        </div>


                                        <div class="form-group">

                                            <label class="form-label">
                                                Option B
                                            </label>

                                            <input
                                                type="text"
                                                name="optionB"
                                                class="form-input"
                                                maxlength="255"
                                                value="<%= question.getOptionB() %>"
                                                required>

                                        </div>


                                        <div class="form-group">

                                            <label class="form-label">
                                                Option C
                                            </label>

                                            <input
                                                type="text"
                                                name="optionC"
                                                class="form-input"
                                                maxlength="255"
                                                value="<%= question.getOptionC() %>"
                                                required>

                                        </div>


                                        <div class="form-group">

                                            <label class="form-label">
                                                Option D
                                            </label>

                                            <input
                                                type="text"
                                                name="optionD"
                                                class="form-input"
                                                maxlength="255"
                                                value="<%= question.getOptionD() %>"
                                                required>

                                        </div>

                                    </div>


                                    <div class="form-group">

                                        <label class="form-label">
                                            Correct Answer
                                        </label>

                                        <select
                                            name="correctAnswer"
                                            class="form-select"
                                            required>

                                            <option
                                                value="A"
                                                <%= "A".equalsIgnoreCase(
                                                    question.getCorrectAnswer())
                                                    ? "selected"
                                                    : "" %>>
                                                Option A
                                            </option>

                                            <option
                                                value="B"
                                                <%= "B".equalsIgnoreCase(
                                                    question.getCorrectAnswer())
                                                    ? "selected"
                                                    : "" %>>
                                                Option B
                                            </option>

                                            <option
                                                value="C"
                                                <%= "C".equalsIgnoreCase(
                                                    question.getCorrectAnswer())
                                                    ? "selected"
                                                    : "" %>>
                                                Option C
                                            </option>

                                            <option
                                                value="D"
                                                <%= "D".equalsIgnoreCase(
                                                    question.getCorrectAnswer())
                                                    ? "selected"
                                                    : "" %>>
                                                Option D
                                            </option>

                                        </select>

                                    </div>


                                    <div class="edit-actions">

                                        <button
                                            type="submit"
                                            class="btn btn-primary">

                                            Update Question

                                        </button>

                                        <button
                                            type="button"
                                            class="btn btn-secondary"
                                            onclick="hideEditForm(<%= question.getId() %>)">

                                            Cancel

                                        </button>

                                    </div>

                                </form>

                            </div>

                        </div>

                    <% } %>

                <% } %>

            </div>

        </section>

    </main>

</div>


<script>

    function showEditForm(id) {

        const panel =
            document.getElementById("edit-" + id);

        if (panel) {

            panel.classList.add("show");

            panel.scrollIntoView({
                behavior: "smooth",
                block: "center"
            });
        }
    }


    function hideEditForm(id) {

        const panel =
            document.getElementById("edit-" + id);

        if (panel) {
            panel.classList.remove("show");
        }
    }


    function confirmDelete() {

        return confirm(
            "Are you sure you want to delete this question?\n\n" +
            "This action cannot be undone."
        );

    }


    setTimeout(function () {

        const alerts =
            document.querySelectorAll(".alert");

        alerts.forEach(function (alert) {

            alert.style.transition =
                "opacity 0.4s ease";

            alert.style.opacity = "0";

            setTimeout(function () {

                alert.remove();

            }, 400);

        });

    }, 5000);

</script>

</body>

</html>