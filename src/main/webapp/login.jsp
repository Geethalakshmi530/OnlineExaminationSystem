<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Login | Online Examination System</title>

<style>

/* =========================================================
   RESET
   ========================================================= */

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

html,
body {
    width: 100%;
    min-height: 100%;
}

body {
    font-family: "Segoe UI", Arial, Helvetica, sans-serif;
    background: #eef6fc;
    color: #17324f;
    min-height: 100vh;
}


/* =========================================================
   TOP HEADER
   ========================================================= */

.top-header {
    min-height: 95px;
    background: #ffffff;

    display: flex;
    align-items: center;
    justify-content: space-between;

    padding: 15px 6%;

    border-bottom: 1px solid #dce8f2;

    position: relative;
    overflow: hidden;
}

.top-header::after {
    content: "";
    position: absolute;

    width: 420px;
    height: 220px;

    right: -100px;
    top: -120px;

    border-radius: 50%;

    background: rgba(25, 190, 215, 0.10);
}


/* =========================================================
   BRAND
   ========================================================= */

.brand {
    display: flex;
    align-items: center;
    gap: 16px;

    position: relative;
    z-index: 2;
}

.brand-logo {
    width: 62px;
    height: 62px;

    border-radius: 14px;

    background: linear-gradient(
        135deg,
        #1763d9,
        #2d76ed
    );

    color: #ffffff;

    display: flex;
    align-items: center;
    justify-content: center;

    font-size: 25px;
    font-weight: 800;
    letter-spacing: 1px;

    box-shadow:
        0 8px 20px rgba(37, 99, 235, 0.20);
}

.brand-text h1 {
    color: #0c427c;

    font-size: 26px;
    font-weight: 750;

    margin-bottom: 4px;
}

.brand-text p {
    color: #5c7590;

    font-size: 12px;

    letter-spacing: 1px;
}


/* =========================================================
   HEADER TAGLINE
   ========================================================= */

.tagline {
    text-align: right;

    color: #165693;

    font-size: 14px;

    line-height: 1.7;

    position: relative;
    z-index: 2;
}

.tagline strong {
    font-weight: 700;
}

.tagline-line {
    width: 55px;
    height: 3px;

    background: #19b9d3;

    margin: 7px 0 0 auto;

    border-radius: 10px;
}


/* =========================================================
   HERO
   ========================================================= */

.hero {
    min-height: 170px;

    background:
        linear-gradient(
            120deg,
            #087fae 0%,
            #087eb4 45%,
            #18c2d2 100%
        );

    color: #ffffff;

    display: flex;
    align-items: center;

    padding: 30px 10%;

    position: relative;
    overflow: hidden;
}

.hero::before {
    content: "";

    position: absolute;

    width: 480px;
    height: 480px;

    border: 1px solid rgba(255,255,255,0.11);

    border-radius: 50%;

    left: -250px;
    top: -250px;
}

.hero::after {
    content: "";

    position: absolute;

    width: 650px;
    height: 240px;

    border: 1px solid rgba(255,255,255,0.10);

    border-radius: 50%;

    right: -300px;
    bottom: -160px;

    transform: rotate(-10deg);
}

.hero-content {
    display: flex;

    align-items: center;

    gap: 25px;

    position: relative;

    z-index: 2;
}

.hero-icon {
    width: 76px;
    height: 76px;

    flex-shrink: 0;

    border: 2px solid rgba(255,255,255,0.90);

    border-radius: 50%;

    display: flex;
    align-items: center;
    justify-content: center;

    font-size: 36px;
}

.hero-divider {
    width: 2px;
    height: 70px;

    background: rgba(255,255,255,0.45);
}

.hero-text h2 {
    font-size: 29px;

    font-weight: 750;

    margin-bottom: 8px;
}

.hero-text p {
    font-size: 16px;

    opacity: 0.95;
}


/* =========================================================
   MAIN
   ========================================================= */

.main-content {
    padding: 35px 5% 45px;
}

.intro {
    text-align: center;

    margin-bottom: 28px;
}

.intro h2 {
    color: #123e6c;

    font-size: 26px;

    margin-bottom: 7px;
}

.intro p {
    color: #687f98;

    font-size: 14px;
}


/* =========================================================
   ERROR / SUCCESS
   ========================================================= */

.message {
    width: 100%;
    max-width: 1160px;

    margin: 0 auto 22px;

    padding: 13px 17px;

    border-radius: 9px;

    font-size: 13px;

    line-height: 1.5;

    text-align: center;
}

.message-error {
    background: #fff1f1;

    color: #b42318;

    border: 1px solid #ffd0d0;
}

.message-success {
    background: #ecfdf3;

    color: #087443;

    border: 1px solid #b8efd0;
}


/* =========================================================
   TWO LOGIN PANELS
   IMPORTANT:
   DESKTOP = LEFT + RIGHT
   ========================================================= */

.login-panels {
    width: 100%;
    max-width: 1160px;

    margin: 0 auto;

    display: grid;

    /* ADMIN LEFT | STUDENT RIGHT */
    grid-template-columns: minmax(0, 1fr) minmax(0, 1fr);

    gap: 30px;

    align-items: stretch;
}


/* =========================================================
   LOGIN CARD
   ========================================================= */

.login-panel {
    background: #ffffff;

    border: 1px solid #d9e6f1;

    border-radius: 18px;

    overflow: hidden;

    box-shadow:
        0 15px 40px
        rgba(22, 70, 110, 0.12);

    transition:
        transform 0.2s ease,
        box-shadow 0.2s ease;
}

.login-panel:hover {
    transform: translateY(-3px);

    box-shadow:
        0 20px 45px
        rgba(22, 70, 110, 0.16);
}


/* =========================================================
   PANEL HEADER
   ========================================================= */

.panel-header {
    min-height: 125px;

    padding: 24px 28px;

    color: #ffffff;

    display: flex;

    align-items: center;

    gap: 18px;

    position: relative;

    overflow: hidden;
}


/* Administrator */

.admin-panel .panel-header {
    background:
        linear-gradient(
            135deg,
            #075899,
            #176fba
        );
}


/* Student */

.student-panel .panel-header {
    background:
        linear-gradient(
            135deg,
            #08718f,
            #0ca7bd
        );
}


.panel-header::after {
    content: "";

    position: absolute;

    width: 230px;
    height: 230px;

    border: 1px solid rgba(255,255,255,0.11);

    border-radius: 50%;

    right: -100px;
    top: -145px;
}


/* =========================================================
   PANEL ICON
   ========================================================= */

.panel-icon {
    width: 65px;
    height: 65px;

    flex-shrink: 0;

    border:
        2px solid
        rgba(255,255,255,0.9);

    border-radius: 14px;

    display: flex;

    align-items: center;
    justify-content: center;

    font-size: 29px;

    position: relative;
    z-index: 2;
}


/* =========================================================
   PANEL TITLE
   ========================================================= */

.panel-title {
    position: relative;
    z-index: 2;
}

.panel-title h3 {
    font-size: 22px;

    font-weight: 750;

    margin-bottom: 6px;
}

.panel-title span {
    font-size: 13px;

    opacity: 0.91;

    line-height: 1.4;
}


/* =========================================================
   PANEL BODY
   ========================================================= */

.panel-body {
    padding: 28px;

    background:
        linear-gradient(
            180deg,
            #f6fbff 0%,
            #ffffff 38%
        );
}


/* =========================================================
   FORM
   ========================================================= */

.form-group {
    margin-bottom: 19px;
}

.form-group label {
    display: block;

    color: #284660;

    font-size: 13px;

    font-weight: 700;

    margin-bottom: 8px;
}

.input-wrap {
    position: relative;
}

.input-icon {
    position: absolute;

    left: 14px;
    top: 50%;

    transform:
        translateY(-50%);

    color: #1179a5;

    font-size: 17px;

    width: 22px;

    text-align: center;

    pointer-events: none;
}

.form-group input {
    width: 100%;

    height: 52px;

    border:
        1px solid #cadce9;

    border-radius: 9px;

    background: #ffffff;

    color: #172b4d;

    font-size: 14px;

    padding:
        0 15px 0 46px;

    outline: none;

    transition:
        border-color 0.2s ease,
        box-shadow 0.2s ease;
}

.form-group input::placeholder {
    color: #91a2b4;
}

.form-group input:focus {
    border-color: #2580d5;

    box-shadow:
        0 0 0 4px
        rgba(37,128,213,0.10);
}


/* =========================================================
   FORGOT PASSWORD
   ========================================================= */

.forgot-row {
    margin: 0 0 19px;
}

.forgot-row a {
    color: #087eaf;

    font-size: 13px;

    font-weight: 600;

    text-decoration: none;
}

.forgot-row a:hover {
    text-decoration: underline;
}


/* =========================================================
   LOGIN BUTTON
   ========================================================= */

.login-button {
    width: 100%;

    height: 52px;

    border: none;

    border-radius: 9px;

    background:
        linear-gradient(
            135deg,
            #1765d8,
            #2582ed
        );

    color: #ffffff;

    font-size: 15px;

    font-weight: 750;

    cursor: pointer;

    box-shadow:
        0 8px 19px
        rgba(30, 105, 218, 0.21);

    transition:
        all 0.2s ease;
}

.login-button:hover {
    transform: translateY(-2px);

    box-shadow:
        0 12px 25px
        rgba(30, 105, 218, 0.28);
}

.login-button:active {
    transform: translateY(0);
}


/* =========================================================
   PANEL FOOTER
   ========================================================= */

.panel-note {
    text-align: center;

    border-top:
        1px solid #e5edf4;

    padding-top: 18px;

    margin-top: 22px;

    color: #71859a;

    font-size: 12.5px;

    line-height: 1.5;
}

.panel-note a {
    color: #1767d8;

    text-decoration: none;

    font-weight: 700;
}

.panel-note a:hover {
    text-decoration: underline;
}


/* =========================================================
   SECURITY FOOTER
   ========================================================= */

.security-footer {
    text-align: center;

    color: #8497aa;

    font-size: 11.5px;

    margin-top: 25px;
}


/* =========================================================
   RESPONSIVE
   ONLY SMALL MOBILE SCREEN WILL STACK
   ========================================================= */

@media (max-width: 600px) {

    .top-header {
        min-height: 82px;

        padding:
            12px 20px;
    }

    .tagline {
        display: none;
    }

    .brand-logo {
        width: 52px;
        height: 52px;

        font-size: 21px;
    }

    .brand-text h1 {
        font-size: 19px;
    }

    .brand-text p {
        font-size: 9px;
    }

    .hero {
        min-height: 150px;

        padding:
            25px 22px;
    }

    .hero-content {
        gap: 17px;
    }

    .hero-icon {
        width: 58px;
        height: 58px;

        font-size: 27px;
    }

    .hero-divider {
        height: 55px;
    }

    .hero-text h2 {
        font-size: 21px;
    }

    .hero-text p {
        font-size: 13px;
    }

    .main-content {
        padding:
            28px 16px 38px;
    }

    .intro h2 {
        font-size: 22px;
    }

    .login-panels {
        grid-template-columns: 1fr;
        gap: 22px;
    }

    .panel-header {
        padding: 22px;
    }

    .panel-body {
        padding: 24px 22px;
    }

    .panel-icon {
        width: 57px;
        height: 57px;

        font-size: 25px;
    }

    .panel-title h3 {
        font-size: 20px;
    }
}


/* =========================================================
   VERY SMALL MOBILE
   ========================================================= */

@media (max-width: 430px) {

    .brand-text h1 {
        font-size: 17px;
    }

    .brand-text p {
        font-size: 8px;
    }

    .hero-icon,
    .hero-divider {
        display: none;
    }

    .hero-text h2 {
        font-size: 20px;
    }
}

</style>

</head>


<body>


<!-- =========================================================
     TOP HEADER
     ========================================================= -->

<header class="top-header">

    <div class="brand">

        <div class="brand-logo">
            OE
        </div>

        <div class="brand-text">

            <h1>
                Online Examination System
            </h1>

            <p>
                Secure &nbsp; | &nbsp; Fair &nbsp; | &nbsp; Transparent
            </p>

        </div>

    </div>


    <div class="tagline">

        <strong>Better Assessment</strong>

        &nbsp; | &nbsp;

        <strong>Brighter Future</strong>

        <div class="tagline-line"></div>

    </div>

</header>



<!-- =========================================================
     HERO
     ========================================================= -->

<section class="hero">

    <div class="hero-content">

        <div class="hero-icon">
            🎓
        </div>

        <div class="hero-divider"></div>

        <div class="hero-text">

            <h2>
                Welcome to Online Examination System
            </h2>

            <p>
                Choose your login type to access your examination portal
            </p>

        </div>

    </div>

</section>



<!-- =========================================================
     MAIN
     ========================================================= -->

<main class="main-content">


    <div class="intro">

        <h2>
            Sign in to your account
        </h2>

        <p>
            Select Administrator or Student access below
        </p>

    </div>



    <!-- =====================================================
         ERROR / SUCCESS MESSAGE
         ===================================================== -->

    <%

        String error =
            request.getParameter("error");

        String success =
            request.getParameter("success");


        if (error != null &&
            !error.trim().isEmpty()) {

    %>

        <div class="message message-error">

            <%= error %>

        </div>

    <%

        }


        if (success != null &&
            !success.trim().isEmpty()) {

    %>

        <div class="message message-success">

            <%= success %>

        </div>

    <%

        }

    %>



    <!-- =====================================================
         TWO LOGIN PANELS
         ADMIN = LEFT
         STUDENT = RIGHT
         ===================================================== -->

    <div class="login-panels">


        <!-- =================================================
             ADMINISTRATOR LOGIN - LEFT
             ================================================= -->

        <section class="login-panel admin-panel">


            <div class="panel-header">

                <div class="panel-icon">
                    👤
                </div>


                <div class="panel-title">

                    <h3>
                        Administrator Login
                    </h3>

                    <span>
                        Access the administration panel
                    </span>

                </div>

            </div>



            <div class="panel-body">


                <!--
                    DO NOT CHANGE THIS ACTION.
                    It uses your existing LoginServlet.
                -->

                <form
                    action="<%= request.getContextPath() %>/login"
                    method="post">


                    <div class="form-group">

                        <label for="admin-email">
                            Email Address
                        </label>


                        <div class="input-wrap">

                            <span class="input-icon">
                                ✉
                            </span>


                            <input
                                type="email"
                                id="admin-email"
                                name="email"
                                placeholder="Enter administrator email"
                                autocomplete="email"
                                required>

                        </div>

                    </div>



                    <div class="form-group">

                        <label for="admin-password">
                            Password
                        </label>


                        <div class="input-wrap">

                            <span class="input-icon">
                                🔒
                            </span>


                            <input
                                type="password"
                                id="admin-password"
                                name="password"
                                placeholder="Enter your password"
                                autocomplete="current-password"
                                required>

                        </div>

                    </div>



                    <div class="forgot-row">

                        <a href="#">
                            Forgot Password?
                        </a>

                    </div>



                    <button
                        type="submit"
                        class="login-button">

                        Sign In
                        &nbsp; →

                    </button>


                </form>



                <div class="panel-note">

                    Administrator access is restricted to authorized users.

                </div>


            </div>


        </section>



        <!-- =================================================
             STUDENT LOGIN - RIGHT
             ================================================= -->

        <section class="login-panel student-panel">


            <div class="panel-header">

                <div class="panel-icon">
                    🎓
                </div>


                <div class="panel-title">

                    <h3>
                        Student Login
                    </h3>

                    <span>
                        Access your student examination portal
                    </span>

                </div>

            </div>



            <div class="panel-body">


                <!--
                    DO NOT CHANGE THIS ACTION.
                    It uses your existing LoginServlet.
                -->

                <form
                    action="<%= request.getContextPath() %>/login"
                    method="post">


                    <div class="form-group">

                        <label for="student-email">
                            Email Address
                        </label>


                        <div class="input-wrap">

                            <span class="input-icon">
                                ✉
                            </span>


                            <input
                                type="email"
                                id="student-email"
                                name="email"
                                placeholder="Enter student email"
                                autocomplete="email"
                                required>

                        </div>

                    </div>



                    <div class="form-group">

                        <label for="student-password">
                            Password
                        </label>


                        <div class="input-wrap">

                            <span class="input-icon">
                                🔒
                            </span>


                            <input
                                type="password"
                                id="student-password"
                                name="password"
                                placeholder="Enter your password"
                                autocomplete="current-password"
                                required>

                        </div>

                    </div>



                    <div class="forgot-row">

                        <a href="#">
                            Forgot Password?
                        </a>

                    </div>



                    <button
                        type="submit"
                        class="login-button">

                        Sign In
                        &nbsp; →

                    </button>


                </form>



                <div class="panel-note">

                    Don't have an account?

                    <a
                        href="<%= request.getContextPath() %>/register.jsp">

                        Create an account

                    </a>

                </div>


            </div>


        </section>


    </div>



    <!-- =====================================================
         SECURITY FOOTER
         ===================================================== -->

    <div class="security-footer">

        🔒 &nbsp;
        Your login information is securely protected.

    </div>


</main>


</body>

</html>