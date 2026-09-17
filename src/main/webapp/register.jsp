<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Create Account | Online Examination System</title>


    <style>

        /* =====================================================
           CREATE ACCOUNT PAGE ONLY
           Professional Blue Theme
           ===================================================== */

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
            font-family:
                "Segoe UI",
                Arial,
                Helvetica,
                sans-serif;

            background: #f4f7fb;

            color: #172033;

            min-height: 100vh;
        }


        /* =====================================================
           MAIN PAGE
           ===================================================== */

        .register-page {

            min-height: 100vh;

            display: flex;

            align-items: center;

            justify-content: center;

            padding: 35px 20px;
        }


        /* =====================================================
           MAIN CARD
           ===================================================== */

        .register-container {

            width: 100%;

            max-width: 1080px;

            min-height: 650px;

            display: grid;

            grid-template-columns:
                45% 55%;

            background: #ffffff;

            border-radius: 18px;

            overflow: hidden;

            border:
                1px solid #dce6f0;

            box-shadow:
                0 18px 50px
                rgba(15, 47, 107, 0.13);
        }


        /* =====================================================
           LEFT BLUE BRAND SECTION
           Matches Admin Theme
           ===================================================== */

        .register-brand {

            position: relative;

            overflow: hidden;

            padding: 55px 45px;

            background:
                linear-gradient(
                    145deg,
                    #0f2f6b 0%,
                    #1557a6 55%,
                    #2563eb 100%
                );

            color: #ffffff;

            display: flex;

            align-items: center;
        }


        /* Decorative circle */

        .register-brand::before {

            content: "";

            position: absolute;

            width: 390px;

            height: 390px;

            border-radius: 50%;

            border:
                1px solid
                rgba(255,255,255,0.10);

            right: -200px;

            top: -170px;
        }


        .register-brand::after {

            content: "";

            position: absolute;

            width: 300px;

            height: 300px;

            border-radius: 50%;

            border:
                1px solid
                rgba(255,255,255,0.08);

            left: -180px;

            bottom: -150px;
        }


        .brand-content {

            position: relative;

            z-index: 2;

            width: 100%;
        }


        /* =====================================================
           LOGO
           ===================================================== */

        .brand-logo {

            width: 62px;

            height: 62px;

            display: flex;

            align-items: center;

            justify-content: center;

            background: #ffffff;

            color: #2563eb;

            border-radius: 14px;

            font-size: 21px;

            font-weight: 800;

            letter-spacing: 1px;

            margin-bottom: 25px;

            box-shadow:
                0 10px 25px
                rgba(0,0,0,0.15);
        }


        /* =====================================================
           BRAND TEXT
           ===================================================== */

        .brand-content h1 {

            font-size: 31px;

            line-height: 1.25;

            font-weight: 750;

            margin-bottom: 15px;
        }


        .brand-content > p {

            max-width: 400px;

            color:
                rgba(255,255,255,0.88);

            font-size: 14px;

            line-height: 1.75;
        }


        /* =====================================================
           FEATURES
           ===================================================== */

        .features {

            margin-top: 35px;
        }


        .feature {

            display: flex;

            align-items: center;

            gap: 12px;

            margin-bottom: 18px;

            color:
                rgba(255,255,255,0.94);

            font-size: 13px;
        }


        .feature-icon {

            width: 30px;

            height: 30px;

            flex-shrink: 0;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 50%;

            background:
                rgba(255,255,255,0.13);

            border:
                1px solid
                rgba(255,255,255,0.16);

            font-size: 13px;

            font-weight: 700;
        }


        /* =====================================================
           RIGHT FORM SECTION
           ===================================================== */

        .register-form-section {

            padding: 55px 60px;

            display: flex;

            align-items: center;

            justify-content: center;

            background: #ffffff;
        }


        .register-form-container {

            width: 100%;

            max-width: 440px;
        }


        /* =====================================================
           FORM HEADER
           ===================================================== */

        .form-label {

            display: inline-block;

            color: #2563eb;

            font-size: 11px;

            font-weight: 800;

            letter-spacing: 1.2px;

            margin-bottom: 10px;
        }


        .form-header h2 {

            color: #102a56;

            font-size: 30px;

            font-weight: 750;

            margin-bottom: 8px;
        }


        .form-header p {

            color: #64748b;

            font-size: 13px;

            line-height: 1.6;

            margin-bottom: 30px;
        }


        /* =====================================================
           ERROR MESSAGE
           ===================================================== */

        .error-message {

            background: #fef2f2;

            color: #b91c1c;

            border:
                1px solid #fecaca;

            border-radius: 9px;

            padding: 12px 15px;

            margin-bottom: 20px;

            font-size: 13px;

            line-height: 1.5;
        }


        /* =====================================================
           FORM GROUP
           ===================================================== */

        .form-group {

            margin-bottom: 20px;
        }


        .form-group label {

            display: block;

            color: #334155;

            font-size: 13px;

            font-weight: 700;

            margin-bottom: 8px;
        }


        /* =====================================================
           INPUT
           ===================================================== */

        .input-wrapper {

            position: relative;
        }


        .input-icon {

            position: absolute;

            left: 15px;

            top: 50%;

            transform:
                translateY(-50%);

            width: 20px;

            color: #2563eb;

            font-size: 16px;

            text-align: center;

            pointer-events: none;
        }


        .form-input {

            width: 100%;

            height: 52px;

            border:
                1px solid #cbd8e5;

            border-radius: 9px;

            background: #ffffff;

            color: #172033;

            padding:
                0 15px 0 45px;

            font-size: 14px;

            outline: none;

            transition:
                border-color 0.2s ease,
                box-shadow 0.2s ease,
                background 0.2s ease;
        }


        .form-input::placeholder {

            color: #94a3b8;
        }


        .form-input:hover {

            border-color: #9db5ce;
        }


        .form-input:focus {

            border-color: #2563eb;

            background: #ffffff;

            box-shadow:
                0 0 0 4px
                rgba(37,99,235,0.10);
        }


        /* =====================================================
           PASSWORD HINT
           ===================================================== */

        .form-hint {

            display: block;

            color: #94a3b8;

            font-size: 11px;

            margin-top: 7px;
        }


        /* =====================================================
           CREATE ACCOUNT BUTTON
           ===================================================== */

        .register-button {

            width: 100%;

            height: 52px;

            border: none;

            border-radius: 9px;

            background:
                linear-gradient(
                    135deg,
                    #1557c0,
                    #2563eb
                );

            color: #ffffff;

            font-size: 15px;

            font-weight: 750;

            cursor: pointer;

            display: flex;

            align-items: center;

            justify-content: center;

            gap: 10px;

            margin-top: 8px;

            box-shadow:
                0 8px 20px
                rgba(37,99,235,0.22);

            transition:
                transform 0.2s ease,
                box-shadow 0.2s ease,
                background 0.2s ease;
        }


        .register-button:hover {

            background:
                linear-gradient(
                    135deg,
                    #0f47a1,
                    #1d4ed8
                );

            transform:
                translateY(-2px);

            box-shadow:
                0 12px 25px
                rgba(37,99,235,0.28);
        }


        .register-button:active {

            transform:
                translateY(0);
        }


        .button-arrow {

            font-size: 18px;

            line-height: 1;
        }


        /* =====================================================
           LOGIN FOOTER
           ===================================================== */

        .register-footer {

            text-align: center;

            margin-top: 25px;

            padding-top: 20px;

            border-top:
                1px solid #edf1f5;

            color: #64748b;

            font-size: 13px;
        }


        .register-footer a {

            color: #2563eb;

            font-weight: 700;

            text-decoration: none;

            margin-left: 4px;
        }


        .register-footer a:hover {

            text-decoration: underline;
        }


        /* =====================================================
           SECURITY NOTE
           ===================================================== */

        .security-note {

            text-align: center;

            color: #94a3b8;

            font-size: 11px;

            margin-top: 17px;

            line-height: 1.5;
        }


        /* =====================================================
           RESPONSIVE
           ===================================================== */

        @media (max-width: 850px) {

            .register-container {

                grid-template-columns: 1fr;

                max-width: 600px;
            }


            .register-brand {

                padding: 40px 35px;

                min-height: 360px;
            }


            .register-form-section {

                padding: 40px 35px;
            }

        }


        @media (max-width: 500px) {

            .register-page {

                padding: 15px;
            }


            .register-brand {

                padding: 32px 25px;

                min-height: 330px;
            }


            .brand-content h1 {

                font-size: 25px;
            }


            .register-form-section {

                padding: 35px 22px;
            }


            .form-header h2 {

                font-size: 26px;
            }

        }

    </style>

</head>


<body>


<div class="register-page">


    <div class="register-container">


        <!-- =================================================
             LEFT BLUE BRAND PANEL
             ================================================= -->

        <section class="register-brand">

            <div class="brand-content">


                <div class="brand-logo">
                    OE
                </div>


                <h1>
                    Online Examination System
                </h1>


                <p>
                    Create your student account and access a
                    secure, simple and efficient online
                    examination platform.
                </p>


                <div class="features">


                    <div class="feature">

                        <span class="feature-icon">
                            ✓
                        </span>

                        <span>
                            Secure student registration
                        </span>

                    </div>


                    <div class="feature">

                        <span class="feature-icon">
                            ✓
                        </span>

                        <span>
                            Admin approval before login
                        </span>

                    </div>


                    <div class="feature">

                        <span class="feature-icon">
                            ✓
                        </span>

                        <span>
                            Online examinations and results
                        </span>

                    </div>


                </div>

            </div>

        </section>



        <!-- =================================================
             RIGHT CREATE ACCOUNT FORM
             ================================================= -->

        <section class="register-form-section">

            <div class="register-form-container">


                <div class="form-header">

                    <span class="form-label">
                        STUDENT REGISTRATION
                    </span>

                    <h2>
                        Create Account
                    </h2>

                    <p>
                        Enter your details below to create your
                        student account.
                    </p>

                </div>



                <!-- =================================================
                     EXISTING ERROR HANDLING
                     ================================================= -->

                <%
                    String error =
                        request.getParameter("error");

                    if (error != null &&
                        !error.trim().isEmpty()) {
                %>

                    <div class="error-message">
                        <%= error %>
                    </div>

                <%
                    }
                %>



                <!-- =================================================
                     REGISTRATION FORM

                     IMPORTANT:
                     name="name" is required because
                     RegisterServlet expects "name".
                     ================================================= -->

                <form
                    action="register"
                    method="post"
                    id="registerForm">


                    <!-- FULL NAME -->

                    <div class="form-group">

                        <label for="name">
                            Full Name
                        </label>

                        <div class="input-wrapper">

                            <span class="input-icon">
                                👤
                            </span>

                            <input
                                type="text"
                                id="fullname"
                                name="name"
                                class="form-input"
                                placeholder="Enter your full name"
                                autocomplete="name"
                                required>

                        </div>

                    </div>



                    <!-- EMAIL -->

                    <div class="form-group">

                        <label for="email">
                            Email Address
                        </label>

                        <div class="input-wrapper">

                            <span class="input-icon">
                                ✉
                            </span>

                            <input
                                type="email"
                                id="email"
                                name="email"
                                class="form-input"
                                placeholder="Enter your email address"
                                autocomplete="email"
                                required>

                        </div>

                    </div>



                    <!-- PASSWORD -->

                    <div class="form-group">

                        <label for="password">
                            Password
                        </label>

                        <div class="input-wrapper">

                            <span class="input-icon">
                                🔒
                            </span>

                            <input
                                type="password"
                                id="password"
                                name="password"
                                class="form-input"
                                placeholder="Create a password"
                                minlength="6"
                                autocomplete="new-password"
                                required>

                        </div>

                        <small class="form-hint">
                            Password must contain at least 6 characters.
                        </small>

                    </div>



                    <!-- CREATE ACCOUNT -->

                    <button
                        type="submit"
                        class="register-button">

                        <span>
                            Create Account
                        </span>

                        <span class="button-arrow">
                            →
                        </span>

                    </button>

                </form>



                <!-- =================================================
                     LOGIN LINK
                     ================================================= -->

                <div class="register-footer">

                    Already have an account?

                    <a href="login.jsp">
                        Sign in
                    </a>

                </div>


                <div class="security-note">

                    Your registration will be reviewed by
                    the administrator before login access is enabled.

                </div>


            </div>

        </section>


    </div>

</div>


</body>

</html>